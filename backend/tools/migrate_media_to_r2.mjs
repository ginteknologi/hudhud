/**
 * tools/migrate_media_to_r2.mjs
 * 
 * Script migrasi media gambar dari Biznet NEO (marbot.nos.wjv-1.neo.id)
 * ke Cloudflare R2 Bucket (masjid-media) tanpa dependencies eksternal (menggunakan CLI sqlite3 bawaan macOS/Linux).
 */

import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const backendDir = path.resolve(__dirname, '..');
const tempDir = path.join(backendDir, '.media_temp');

if (!fs.existsSync(tempDir)) fs.mkdirSync(tempDir, { recursive: true });

// Cari file SQLite lokal di .wrangler
const d1Dir = path.join(backendDir, '.wrangler/state/v3/d1/miniflare-D1DatabaseObject');
const sqliteFiles = fs.readdirSync(d1Dir).filter(f => f.endsWith('.sqlite'));
if (sqliteFiles.length === 0) {
  console.error('❌ Database SQLite lokal tidak ditemukan di:', d1Dir);
  process.exit(1);
}
const dbPath = path.join(d1Dir, sqliteFiles[0]);

console.log('\n======================================================');
console.log('📦 MIGRASI MEDIA GAMBAR: NEO STORAGE -> CLOUDFLARE R2');
console.log('Database Lokal:', dbPath);
console.log('======================================================\n');

function runSql(query) {
  return execSync(`sqlite3 "${dbPath}" "${query.replace(/"/g, '""')}"`, { encoding: 'utf8' });
}

async function main() {
  const urls = new Set();

  // 1. Ambil URL dari artikel (thumbnail & konten)
  const artikelThumbnails = runSql("SELECT thumbnail FROM artikel WHERE thumbnail LIKE '%marbot.nos%';").trim().split('\n');
  artikelThumbnails.forEach(u => { if (u.trim()) urls.add(u.trim()); });

  const artikelKonten = runSql("SELECT konten FROM artikel WHERE konten LIKE '%marbot.nos%';").trim().split('\n');
  artikelKonten.forEach(line => {
    const matches = line.match(/https:\/\/marbot\.nos\.wjv-1\.neo\.id\/[^\s"'>)]+/g);
    if (matches) matches.forEach(u => urls.add(u));
  });

  // 2. Ambil URL dari kajian
  const kajianThumbnails = runSql("SELECT thumbnail FROM kajian WHERE thumbnail LIKE '%marbot.nos%';").trim().split('\n');
  kajianThumbnails.forEach(u => { if (u.trim()) urls.add(u.trim()); });

  // 3. Ambil URL dari event
  const eventBanners = runSql("SELECT banner FROM event WHERE banner LIKE '%marbot.nos%';").trim().split('\n');
  eventBanners.forEach(u => { if (u.trim()) urls.add(u.trim()); });

  const allUrls = Array.from(urls);
  console.log(`🔍 Ditemukan ${allUrls.length} file gambar unik dari NEO Storage.\n`);

  let successCount = 0;
  let failCount = 0;

  for (let i = 0; i < allUrls.length; i++) {
    const rawUrl = allUrls[i];
    try {
      const urlObj = new URL(rawUrl);
      const key = decodeURIComponent(urlObj.pathname.replace(/^\//, ''));
      const tempFile = path.join(tempDir, `temp_${Date.now()}_${path.basename(key)}`);

      process.stdout.write(`[${i + 1}/${allUrls.length}] ${key}... `);

      // Download dari NEO
      const res = await fetch(rawUrl);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const arrayBuffer = await res.arrayBuffer();
      fs.writeFileSync(tempFile, Buffer.from(arrayBuffer));

      // Upload ke Cloudflare R2
      execSync(`npx wrangler r2 object put "masjid-media/${key}" --file="${tempFile}"`, {
        cwd: backendDir,
        stdio: 'ignore'
      });

      if (fs.existsSync(tempFile)) fs.unlinkSync(tempFile);
      console.log('✅ OK');
      successCount++;
    } catch (e) {
      console.log(`❌ GAGAL: ${e.message}`);
      failCount++;
    }
  }

  console.log(`\n🎉 SELESAI UPLOAD KE R2: ${successCount} Berhasil, ${failCount} Gagal.`);

  // Update Database Lokal SQLite
  console.log('\n📝 Mengupdate link URL di database lokal SQLite...');
  const oldPrefix = 'https://marbot.nos.wjv-1.neo.id';
  const newPrefix = 'https://marbot-api.ginteknologi.workers.dev/media';

  runSql(`
    UPDATE artikel SET thumbnail = REPLACE(thumbnail, '${oldPrefix}', '${newPrefix}') WHERE thumbnail LIKE '%marbot.nos%';
    UPDATE artikel SET konten = REPLACE(konten, '${oldPrefix}', '${newPrefix}') WHERE konten LIKE '%marbot.nos%';
    UPDATE kajian SET thumbnail = REPLACE(thumbnail, '${oldPrefix}', '${newPrefix}') WHERE thumbnail LIKE '%marbot.nos%';
    UPDATE event SET banner = REPLACE(banner, '${oldPrefix}', '${newPrefix}') WHERE banner LIKE '%marbot.nos%';
  `);

  console.log('✅ URL gambar di database lokal SQLite berhasil diperbarui ke endpoint R2 Worker!');

  if (fs.existsSync(tempDir)) fs.rmSync(tempDir, { recursive: true, force: true });
  console.log('\n✨ SEMUA PROSES SELESAI!');
}

main().catch(err => {
  console.error('Fatal error:', err);
  process.exit(1);
});
