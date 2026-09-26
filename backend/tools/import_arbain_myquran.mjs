/**
 * import_arbain_myquran.mjs
 *
 * Ambil Hadits Arba'in An-Nawawiyah (42 hadits) dari api.myquran.com lalu
 * generate DUA file SQL lokal:
 *   seeds/04_hadits_arbain_konten.sql  → konten ke hadits_konten (namaTabel='arbain')
 *   seeds/03_hadits_bab_arbain.sql     → bab, satu bab per hadits (nama = judul)
 *
 * Sumber hadis-api-id TIDAK punya koleksi arbain, jadi kontennya dari sini.
 * Numbering myquran identik dengan numbering hadits_konten (1..N).
 *
 * Usage:
 *   node tools/import_arbain_myquran.mjs            -- fetch + generate SQL
 *   node tools/import_arbain_myquran.mjs --d1       -- generate lalu push ke D1 remote
 */

import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const backendDir = path.resolve(__dirname, '..');
const seedsDir = path.join(backendDir, 'seeds');
const pushD1 = process.argv.includes('--d1');

const URL_SEMUA = 'https://api.myquran.com/v2/hadits/arbain/all';

function esc(val) {
  if (val === null || val === undefined) return 'NULL';
  return `'${String(val).replace(/'/g, "''")}'`;
}

async function fetchWithRetry(url, retries = 5, delayMs = 2000) {
  for (let i = 0; i < retries; i++) {
    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      return await res.json();
    } catch (e) {
      if (i === retries - 1) throw e;
      process.stdout.write(` [retry ${i + 1}]`);
      await new Promise((r) => setTimeout(r, delayMs));
    }
  }
}

function pushToD1(sqlFile) {
  execSync(
    `npx wrangler d1 execute masjid-db --remote --file="${sqlFile}" -y`,
    { cwd: backendDir, stdio: 'inherit' }
  );
}

async function main() {
  console.log('\n📥 Fetch Arbain dari api.myquran.com ...');
  const json = await fetchWithRetry(URL_SEMUA);
  const items = (json.data || []).filter((h) => h && h.no);
  if (items.length === 0) {
    console.error('❌ Tidak ada data arbain.');
    process.exit(1);
  }
  items.sort((a, b) => Number(a.no) - Number(b.no));
  console.log(`✅ ${items.length} hadits diterima.`);

  // ── Konten ────────────────────────────────────────────────
  const konten = [
    '-- Hadits Arbain An-Nawawiyah — konten (hadits_konten, namaTabel = arbain)',
    `-- Total: ${items.length} hadits`,
    `-- Generated: ${new Date().toISOString()}`,
    '-- Source: https://api.myquran.com/v2/hadits/arbain/all',
    '-- Dibuat oleh: backend/tools/import_arbain_myquran.mjs',
    '',
    "DELETE FROM hadits_konten WHERE namaTabel = 'arbain';",
    '',
  ];
  for (const h of items) {
    konten.push(
      'INSERT OR IGNORE INTO hadits_konten (namaTabel, NoHdt, Isi_Arab, Isi_Indonesia) VALUES ' +
        `('arbain', ${Number(h.no)}, ${esc(h.arab)}, ${esc(h.indo)});`
    );
  }
  const kontenFile = path.join(seedsDir, '04_hadits_arbain_konten.sql');
  fs.writeFileSync(kontenFile, konten.join('\n') + '\n', 'utf8');

  // ── Bab ───────────────────────────────────────────────────
  // Struktur Arbain: tiap hadits punya judul sendiri, jadi satu bab per hadits.
  // Tidak ada pengelompokan yang dikarang.
  const bab = [
    '-- Hadits Arbain An-Nawawiyah — bab (1 bab per hadits, nama = judul)',
    `-- Total: ${items.length} bab`,
    `-- Generated: ${new Date().toISOString()}`,
    '-- Source: https://api.myquran.com/v2/hadits/arbain/all',
    '-- Dibuat oleh: backend/tools/import_arbain_myquran.mjs',
    '',
    "DELETE FROM hadits_bab WHERE namaTabel = 'arbain';",
    '',
  ];
  for (const h of items) {
    const no = Number(h.no);
    bab.push(
      'INSERT OR IGNORE INTO hadits_bab (namaTabel, urutan, nama, namaArab, noAwal, noAkhir) VALUES ' +
        `('arbain', ${no}, ${esc(h.judul || `Hadits ${no}`)}, NULL, ${no}, ${no});`
    );
  }
  const babFile = path.join(seedsDir, '03_hadits_bab_arbain.sql');
  fs.writeFileSync(babFile, bab.join('\n') + '\n', 'utf8');

  console.log(`  💾 ${path.relative(backendDir, kontenFile)}`);
  console.log(`  💾 ${path.relative(backendDir, babFile)}`);

  if (pushD1) {
    console.log('\n📤 Push ke D1 remote ...');
    pushToD1(babFile);
    pushToD1(kontenFile);
    console.log('✅ D1 updated.');
  } else {
    console.log('\nℹ️  Belum di-push. Jalankan dengan --d1 atau:');
    console.log('   npx wrangler d1 execute masjid-db --remote --file=seeds/03_hadits_bab_arbain.sql -y');
    console.log('   npx wrangler d1 execute masjid-db --remote --file=seeds/04_hadits_arbain_konten.sql -y');
  }
}

main().catch((e) => {
  console.error('❌', e.message);
  process.exit(1);
});
