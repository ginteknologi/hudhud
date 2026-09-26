/**
 * import_tema_myquran.mjs
 *
 * Impor koleksi tematik (Lidwa) dari api.myquran.com:
 *   /hadits/koleksi/kategori      → hadits_tema (435 kategori, parent_id NULL = induk)
 *   /hadits/koleksi/no/1..2091    → hadits_koleksi + hadits_tema_item
 *
 * Endpoint listing per kategori tidak tersedia (404), jadi keanggotaan tema
 * diambil dari array `categories` tiap hadits dengan menyapu seluruh koleksi.
 *
 * Hasil di-cache di sql/hadits_tema_cache.json supaya re-run tidak fetch ulang.
 * SQL dipecah per 300 baris: sql/hadits_tema_data_00.sql, _01.sql, ...
 *
 * Usage:
 *   node tools/import_tema_myquran.mjs              -- fetch (pakai cache kalau ada) + generate SQL
 *   node tools/import_tema_myquran.mjs --refresh    -- paksa fetch ulang dari API
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const backendDir = path.resolve(__dirname, '..');
const sqlDir = path.join(backendDir, 'sql');
const cacheFile = path.join(sqlDir, 'hadits_tema_cache.json');
const refresh = process.argv.includes('--refresh');

const BASE = 'https://api.myquran.com/v2/hadits';
const CHUNK = 300; // baris INSERT per file SQL

function esc(val) {
  if (val === null || val === undefined) return 'NULL';
  return `'${String(val).replace(/'/g, "''")}'`;
}

async function fetchJson(url, retries = 4, delayMs = 1500) {
  for (let i = 0; i < retries; i++) {
    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      return await res.json();
    } catch (e) {
      if (i === retries - 1) throw e;
      await new Promise((r) => setTimeout(r, delayMs * (i + 1)));
    }
  }
}

async function fetchAll() {
  if (!refresh && fs.existsSync(cacheFile)) {
    const cached = JSON.parse(fs.readFileSync(cacheFile, 'utf8'));
    console.log(`⏭  Pakai cache: ${cached.items.length} hadits, ${cached.kategori.length} kategori.`);
    return cached;
  }

  console.log('📥 Fetch daftar kategori ...');
  const katJson = await fetchJson(`${BASE}/koleksi/kategori`);
  const kategori = katJson.data || [];
  console.log(`   ${kategori.length} kategori.`);

  // Batas atas koleksi diambil dari response /koleksi/no/1 → info.max
  const first = await fetchJson(`${BASE}/koleksi/no/1`);
  const max = Number(first.info?.max || 2091);
  console.log(`📥 Fetch koleksi no 1..${max} (sekali jalan, sabar) ...`);

  const items = [];
  for (let n = 1; n <= max; n++) {
    try {
      const json = await fetchJson(`${BASE}/koleksi/no/${n}`);
      const d = json.data;
      if (d && d.id) {
        items.push({
          id: Number(d.id),
          judul: d.title || '',
          arab: d.arab || d.idn?.hadis || '',
          indo: d.indo || d.idn?.terjemah || d.idn?.hadis || '',
          categories: (d.categories || []).map(Number),
        });
      }
    } catch (e) {
      console.warn(`\n  ⚠️  no ${n} gagal: ${e.message}`);
    }
    if (n % 50 === 0 || n === max) {
      process.stdout.write(`\r   ${n}/${max} ...`);
    }
    await new Promise((r) => setTimeout(r, 120));
  }
  process.stdout.write('\n');

  const payload = { kategori, items, fetchedAt: new Date().toISOString() };
  fs.writeFileSync(cacheFile, JSON.stringify(payload), 'utf8');
  console.log(`  💾 cache: ${path.relative(backendDir, cacheFile)}`);
  return payload;
}

// `prefix` wajib berbeda per tabel: tiga urutan statement dengan nomor bagian
// yang sama akan saling menimpa kalau namanya sama.
function writeChunks(prefix, name, statements) {
  const files = [];
  for (let i = 0, part = 0; i < statements.length; i += CHUNK, part++) {
    const slice = statements.slice(i, i + CHUNK);
    const file = path.join(sqlDir, `${prefix}_${String(part).padStart(2, '0')}.sql`);
    const head = [
      `-- ${name} (bagian ${part + 1})`,
      `-- Generated: ${new Date().toISOString()}`,
      '',
    ];
    fs.writeFileSync(file, head.concat(slice).join('\n') + '\n', 'utf8');
    files.push(file);
  }
  return files;
}

async function main() {
  const { kategori, items } = await fetchAll();

  const topLevel = kategori.filter((k) => !k.parent_id);
  console.log(
    `\n${items.length} hadits, ${kategori.length} kategori (${topLevel.length} induk), ` +
      `${items.reduce((a, h) => a + h.categories.length, 0)} relasi tema-item.`
  );

  // ── Kategori ─────────────────────────────────────────────
  const katStmt = ["DELETE FROM hadits_tema;"];
  for (const k of kategori) {
    katStmt.push(
      'INSERT OR IGNORE INTO hadits_tema (id, nama, parent) VALUES ' +
        `(${Number(k.id)}, ${esc(k.title)}, ${k.parent_id ? Number(k.parent_id) : 'NULL'});`
    );
  }
  const katFiles = writeChunks('hadits_tema_kategori', 'hadits_tema', katStmt);

  // ── Koleksi ──────────────────────────────────────────────
  const kolStmt = ["DELETE FROM hadits_koleksi;"];
  for (const h of items) {
    kolStmt.push(
      'INSERT OR IGNORE INTO hadits_koleksi (id, judul, arab, indo) VALUES ' +
        `(${h.id}, ${esc(h.judul)}, ${esc(h.arab)}, ${esc(h.indo)});`
    );
  }
  const kolFiles = writeChunks('hadits_tema_koleksi', 'hadits_koleksi', kolStmt);

  // ── Relasi ───────────────────────────────────────────────
  const relStmt = ["DELETE FROM hadits_tema_item;"];
  for (const h of items) {
    for (const c of h.categories) {
      relStmt.push(
        'INSERT OR IGNORE INTO hadits_tema_item (temaId, koleksiId) VALUES ' +
          `(${c}, ${h.id});`
      );
    }
  }
  const relFiles = writeChunks('hadits_tema_relasi', 'hadits_tema_item', relStmt);

  console.log('\n💾 SQL dipecah jadi:');
  for (const f of [...katFiles, ...kolFiles, ...relFiles]) {
    const kb = Math.round(fs.statSync(f).size / 1024);
    console.log(`   ${path.relative(backendDir, f)} (${kb} KB)`);
  }
  console.log('\nℹ️  Push ke D1 (urutkan persis seperti ini):');
  console.log('   npx wrangler d1 execute masjid-db --remote --file=sql/hadits_bab_tema.sql -y');
  for (const g of ['hadits_tema_kategori', 'hadits_tema_koleksi', 'hadits_tema_relasi']) {
    console.log(
      `   for f in sql/${g}_*.sql; do npx wrangler d1 execute masjid-db --remote --file="$f" -y; done`
    );
  }
}

main().catch((e) => {
  console.error('❌', e.message);
  process.exit(1);
});
