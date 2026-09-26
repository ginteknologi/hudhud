/**
 * import_hadits_v2.mjs
 * 
 * Script re-import hadits dari hadis-api-id.vercel.app
 * Struktur baru (v2): flat, tanpa kitab/bab artificial
 * 
 * Alur:
 * 1. Fetch semua hadits dari API (per page 100)
 * 2. Generate file .sql lokal (disimpan di backend/sql/hadits_data/)
 * 3. Execute ke D1 remote
 * 
 * Usage:
 *   node tools/import_hadits_v2.mjs all           -- semua 9 imam
 *   node tools/import_hadits_v2.mjs bukhari       -- satu kitab saja
 *   node tools/import_hadits_v2.mjs all --sql-only -- hanya generate SQL, jangan push ke D1
 *   node tools/import_hadits_v2.mjs all --d1-only  -- push SQL yang sudah ada ke D1 (skip fetch)
 */

import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const backendDir = path.resolve(__dirname, '..');

// Folder output SQL lokal — DISIMPAN PERMANEN
const sqlDir = path.join(backendDir, 'sql', 'hadits_data');
if (!fs.existsSync(sqlDir)) fs.mkdirSync(sqlDir, { recursive: true });

const args = process.argv.slice(2);
const target = args.find(a => !a.startsWith('--')) || null;
const sqlOnly = args.includes('--sql-only');   // hanya generate SQL, skip D1
const d1Only  = args.includes('--d1-only');    // skip fetch, langsung push SQL yang ada

// ============================================================
// Daftar kitab
// ============================================================
const BOOKS = [
  { slug: 'bukhari',   table: 'bukhari',   name: "Shahih Bukhari",             total: 6638 },
  { slug: 'muslim',    table: 'muslim',    name: "Shahih Muslim",              total: 4930 },
  { slug: 'abu-dawud', table: 'abudaud',   name: "Sunan Abu Daud",             total: 4419 },
  { slug: 'tirmidzi',  table: 'tirmidzi',  name: "Sunan At-Tirmidzi",          total: 3625 },
  { slug: 'nasai',     table: 'nasai',     name: "Sunan An-Nasa'i",            total: 5364 },
  { slug: 'ibnu-majah',table: 'ibnumajah', name: "Sunan Ibnu Majah",           total: 4285 },
  { slug: 'ahmad',     table: 'ahmad',     name: "Musnad Ahmad",               total: 4305 },
  { slug: 'malik',     table: 'malik',     name: "Muwaththa' Malik",           total: 1587 },
  { slug: 'darimi',    table: 'darimi',    name: "Sunan Ad-Darimi",            total: 2949 },
];

// ============================================================
// Helpers
// ============================================================
function esc(val) {
  if (val === null || val === undefined) return 'NULL';
  if (typeof val === 'number') return val.toString();
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
      await new Promise(r => setTimeout(r, delayMs));
    }
  }
}

function pushToD1(sqlFile) {
  execSync(
    `npx wrangler d1 execute masjid-db --remote --file="${sqlFile}" -y`,
    { cwd: backendDir, stdio: 'ignore' }
  );
}

// ============================================================
// STEP 1 — Apply schema v2 ke D1
// ============================================================
async function applySchema() {
  const schemaFile = path.join(backendDir, 'sql', 'hadits_schema_v2.sql');
  if (!fs.existsSync(schemaFile)) {
    console.error('❌ Schema v2 tidak ditemukan:', schemaFile);
    process.exit(1);
  }
  console.log('\n📋 Menerapkan schema v2 (DROP + CREATE tables)...');
  pushToD1(schemaFile);
  console.log('✅ Schema v2 berhasil diterapkan ke D1.');
}

// ============================================================
// STEP 2 — Fetch + Generate SQL per kitab
// ============================================================
async function fetchAndGenerateSql(book) {
  const sqlFile = path.join(sqlDir, `${book.table}.sql`);
  
  // Skip fetch jika --d1-only dan file sudah ada
  if (d1Only && fs.existsSync(sqlFile)) {
    console.log(`⏭  Skip fetch ${book.name} — pakai SQL lokal: ${book.table}.sql`);
    return sqlFile;
  }

  console.log(`\n📥 Fetch ${book.name} (${book.slug}) — ${book.total} hadits...`);
  
  const PAGE_SIZE = 100;
  const totalPages = Math.ceil(book.total / PAGE_SIZE);
  const lines = [];

  // Header komentar di file SQL
  lines.push(`-- ${book.name} (${book.table})`);
  lines.push(`-- Total: ${book.total} hadits`);
  lines.push(`-- Generated: ${new Date().toISOString()}`);
  lines.push(`-- Source: https://hadis-api-id.vercel.app/hadith/${book.slug}`);
  lines.push('');
  lines.push(`DELETE FROM hadits_konten WHERE namaTabel = '${book.table}';`);
  lines.push('');

  let fetched = 0;
  for (let page = 1; page <= totalPages; page++) {
    const pct = Math.round((page / totalPages) * 100);
    process.stdout.write(`\r  Page ${page}/${totalPages} (${pct}%)... `);

    const url = `https://hadis-api-id.vercel.app/hadith/${book.slug}?page=${page}&limit=${PAGE_SIZE}`;
    const data = await fetchWithRetry(url);
    const items = data.items || [];
    if (items.length === 0) break;

    for (const item of items) {
      lines.push(
        `INSERT INTO hadits_konten (namaTabel, NoHdt, Isi_Arab, Isi_Indonesia) VALUES ` +
        `(${esc(book.table)}, ${item.number}, ${esc(item.arab)}, ${esc(item.id)});`
      );
    }
    fetched += items.length;

    // Delay antar page agar tidak rate-limit
    if (page < totalPages) await new Promise(r => setTimeout(r, 300));
  }

  process.stdout.write(`\r  ✅ ${fetched} hadits di-fetch. Simpan ke SQL...          \n`);
  fs.writeFileSync(sqlFile, lines.join('\n') + '\n', 'utf8');
  console.log(`  💾 Disimpan: sql/hadits_data/${book.table}.sql (${Math.round(fs.statSync(sqlFile).size / 1024)} KB)`);

  return sqlFile;
}

// ============================================================
// STEP 3 — Push SQL ke D1
// ============================================================
async function pushBook(book, sqlFile) {
  if (sqlOnly) {
    console.log(`  ⏭  --sql-only: skip push ke D1 untuk ${book.table}`);
    return;
  }
  console.log(`  📤 Push ke D1: ${book.table}...`);
  pushToD1(sqlFile);
  console.log(`  ✅ D1 updated: ${book.table}`);
}

// ============================================================
// MAIN
// ============================================================
async function main() {
  if (!target) {
    console.log('Usage:');
    console.log('  node tools/import_hadits_v2.mjs <slug|all> [--sql-only] [--d1-only]');
    console.log('');
    console.log('Slugs tersedia:', BOOKS.map(b => b.slug).join(', '));
    console.log('');
    console.log('Options:');
    console.log('  --sql-only   Hanya fetch & generate SQL lokal, tidak push ke D1');
    console.log('  --d1-only    Pakai SQL lokal yang sudah ada, langsung push ke D1');
    process.exit(1);
  }

  const books = target === 'all'
    ? BOOKS
    : [BOOKS.find(b => b.slug === target || b.table === target)].filter(Boolean);

  if (books.length === 0) {
    console.error(`❌ Kitab tidak ditemukan: ${target}`);
    process.exit(1);
  }

  console.log('');
  console.log('╔══════════════════════════════════════════════════╗');
  console.log('║   Import Hadits v2 — Marbot (Masjid An-Nikmah)  ║');
  console.log('╚══════════════════════════════════════════════════╝');
  console.log(`Mode: ${sqlOnly ? 'SQL Only (no D1)' : d1Only ? 'D1 Only (from local SQL)' : 'Full (fetch + D1)'}`);
  console.log(`Target: ${target === 'all' ? `Semua ${books.length} kitab` : books[0].name}`);
  console.log('');

  // Apply schema hanya jika bukan --sql-only dan target = all atau eksplisit diminta
  if (!sqlOnly && target === 'all') {
    await applySchema();
  }

  // Catat checkpoint waktu mulai
  if (!sqlOnly) {
    const ts = new Date().toISOString();
    const checkpointSql = path.join(sqlDir, '_checkpoint.sql');
    fs.writeFileSync(checkpointSql,
      `-- Import Checkpoint\n` +
      `-- Waktu mulai: ${ts}\n` +
      `-- Target: ${target}\n`,
      'utf8'
    );
    console.log(`🕐 Checkpoint: ${ts}`);
  }

  // Proses per kitab
  for (const book of books) {
    const sqlFile = await fetchAndGenerateSql(book);
    await pushBook(book, sqlFile);
  }

  console.log('\n');
  console.log('╔══════════════════════════════════════════════════╗');
  console.log('║   🎉 SELESAI!                                    ║');
  console.log('╚══════════════════════════════════════════════════╝');
  console.log(`📁 SQL lokal tersimpan di: backend/sql/hadits_data/`);
  if (!sqlOnly) {
    console.log(`☁️  Data sudah di-push ke D1 Cloudflare`);
  }
  console.log('');
}

main().catch(err => {
  console.error('\n❌ Fatal error:', err.message);
  process.exit(1);
});
