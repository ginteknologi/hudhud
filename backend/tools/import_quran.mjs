/**
 * tools/import_quran.mjs
 * 
 * Script untuk mengambil seluruh data Al-Qur'an (114 Surah, 6.236 Ayat)
 * Sumber: EQuran.id API v2 (Standar Kemenag RI / Hafs 'an 'Asim)
 * Output:
 * 1. File SQL lokal: backend/sql/quran_complete.sql
 * 2. Eksekusi ke local SQLite database marbot jika tidak ada flag --sql-only
 */

import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const backendDir = path.resolve(__dirname, '..');
const sqlDir = path.join(backendDir, 'sql');
if (!fs.existsSync(sqlDir)) fs.mkdirSync(sqlDir, { recursive: true });

const outputFile = path.join(sqlDir, 'quran_complete.sql');
const args = process.argv.slice(2);
const sqlOnly = args.includes('--sql-only');

function escapeSql(val) {
  if (val === null || val === undefined) return 'NULL';
  if (typeof val === 'number') return Number.isFinite(val) ? val.toString() : 'NULL';
  return `'${String(val).replace(/'/g, "''")}'`;
}

async function fetchWithRetry(url, retries = 5, delay = 1500) {
  for (let i = 0; i < retries; i++) {
    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      return await res.json();
    } catch (e) {
      if (i === retries - 1) throw e;
      await new Promise(r => setTimeout(r, delay));
    }
  }
}

async function main() {
  console.log('\n======================================================');
  console.log('📖 PENGAMBILAN DATA AL-QUR\'AN LENGKAP (114 SURAH & 6.236 AYAT)');
  console.log('======================================================\n');

  console.log('📥 Mengambil daftar 114 Surah dari equran.id...');
  const surahListRes = await fetchWithRetry('https://equran.id/api/v2/surat');
  if (!surahListRes || !surahListRes.data) {
    throw new Error('Gagal mengambil daftar surah');
  }

  const surahList = surahListRes.data;
  console.log(`✅ Berhasil mendapatkan ${surahList.length} surah.\n`);

  const sqlStatements = [];
  sqlStatements.push('-- ======================================================');
  sqlStatements.push('-- AL-QUR\'ANUL KARIM DATASET LENGKAP');
  sqlStatements.push('-- 114 Surah & 6.236 Ayat');
  sqlStatements.push(`-- Dibuat pada: ${new Date().toISOString()}`);
  sqlStatements.push('-- ======================================================\n');

  sqlStatements.push('DELETE FROM ayat;');
  sqlStatements.push('DELETE FROM surah;\n');

  let totalAyatCount = 0;

  for (let i = 0; i < surahList.length; i++) {
    const s = surahList[i];
    const surahId = s.nomor;
    const namaLatin = s.namaLatin;
    const namaArab = s.nama;
    const jumlahAyat = s.jumlahAyat;
    const tempatTurun = s.tempatTurun.toLowerCase().includes('mad') ? 'madinah' : 'mekah';
    const arti = s.arti;
    const audioUrl = s.audioFull ? (s.audioFull['05'] || s.audioFull['01'] || '') : '';

    process.stdout.write(`[${surahId}/114] Mengambil ${namaLatin} (${jumlahAyat} ayat)... `);

    // SQL Surah
    sqlStatements.push(
      `INSERT OR REPLACE INTO surah (id, nama, asma, jumlah_ayat, tipe, arti, audio_url) VALUES ` +
      `(${surahId}, ${escapeSql(namaLatin)}, ${escapeSql(namaArab)}, ${jumlahAyat}, ${escapeSql(tempatTurun)}, ${escapeSql(arti)}, ${escapeSql(audioUrl)});`
    );

    // Fetch ayat detail
    const detailRes = await fetchWithRetry(`https://equran.id/api/v2/surat/${surahId}`);
    if (!detailRes || !detailRes.data || !detailRes.data.ayat) {
      throw new Error(`Gagal mengambil detail ayat surah ${surahId}`);
    }

    const ayats = detailRes.data.ayat;
    for (const a of ayats) {
      const nomorAyat = a.nomorAyat;
      const teksArab = a.teksArab;
      const teksLatin = a.teksLatin ? a.teksLatin.trim() : '';
      const terjemahan = a.teksIndonesia;
      const audioAyat = a.audio ? (a.audio['05'] || a.audio['01'] || '') : '';

      sqlStatements.push(
        `INSERT INTO ayat (surah_id, nomor_ayat, teks_arab, teks_latin, terjemahan, audio_url) VALUES ` +
        `(${surahId}, ${nomorAyat}, ${escapeSql(teksArab)}, ${escapeSql(teksLatin)}, ${escapeSql(terjemahan)}, ${escapeSql(audioAyat)});`
      );
      totalAyatCount++;
    }

    console.log(`✅ OK (${ayats.length} ayat)`);
    // Delay kecil agar ramah server API
    await new Promise(r => setTimeout(r, 120));
  }

  console.log(`\n💾 Menyimpan file SQL lokal ke: ${outputFile}...`);
  fs.writeFileSync(outputFile, sqlStatements.join('\n') + '\n', 'utf8');
  const sizeMB = (fs.statSync(outputFile).size / (1024 * 1024)).toFixed(2);
  console.log(`✅ File SQL berhasil disimpan! Ukuran: ${sizeMB} MB (Total: 114 Surah, ${totalAyatCount} Ayat).\n`);

  if (!sqlOnly) {
    console.log('🔄 Memasukkan data ke database SQLite lokal (.wrangler)...');
    execSync(`npx wrangler d1 execute masjid-db --local --file="${outputFile}" -y`, {
      cwd: backendDir,
      stdio: 'inherit'
    });
    console.log('\n✨ SEMUA DATA AL-QUR\'AN BERHASIL MASUK KE DATABASE LOKAL!');
  }
}

main().catch(err => {
  console.error('\n❌ Fatal error:', err);
  process.exit(1);
});
