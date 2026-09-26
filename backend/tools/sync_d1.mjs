import mysql from 'mysql2/promise';
import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const backendDir = path.resolve(__dirname, '..');
const configPath = '/Users/gin/Documents/PROJECT/TOOL/masjid-api/config/config.json';

const args = process.argv.slice(2);
const isIncremental = args.includes('--incremental');
// --local: tulis ke D1 lokal (wrangler dev) saja — tidak menyentuh kuota D1 remote.
const isLocal = args.includes('--local');
const d1Flag = isLocal ? '--local' : '--remote';
const d1Target = isLocal ? 'LOCAL' : 'REMOTE';

console.log(`\n======================================================`);
console.log(`🔄 SYNC MARIADB PROD -> CLOUDFLARE D1 (masjid-db)`);
console.log(`Mode: ${isIncremental ? 'INCREMENTAL (Update Susulan)' : 'FULL SYNC'}`);
console.log(`======================================================\n`);

const rawConfig = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const conf = rawConfig.production;

const conn = await mysql.createConnection({
  host: conf.host,
  port: conf.port,
  user: conf.username,
  password: conf.password,
  database: conf.database,
});

console.log(`✅ Connected to MariaDB (${conf.host}:${conf.port}/${conf.database})`);

function escapeSql(val) {
  if (val === null || val === undefined) return 'NULL';
  if (typeof val === 'number') return Number.isFinite(val) ? val.toString() : 'NULL';
  if (typeof val === 'boolean') return val ? '1' : '0';
  if (val instanceof Date) {
    return `'${val.toISOString().slice(0, 19).replace('T', ' ')}'`;
  }
  return `'${String(val).replace(/'/g, "''")}'`;
}

function convertMediaUrl(str) {
  if (!str) return str;
  return String(str).replace(/https:\/\/marbot\.nos\.wjv-1\.neo\.id/g, 'https://marbot-api.ginteknologi.workers.dev/media');
}

// Ambil watermark terakhir dari D1 jika mode incremental
let watermarks = {};
if (isIncremental) {
  console.log('Fetching latest watermarks from Cloudflare D1 _sync_meta...');
  try {
    const jsonStr = execSync(
      `npx wrangler d1 execute masjid-db ${d1Flag} --command="SELECT table_name, MAX(last_synced_timestamp) as last_ts, MAX(last_synced_id) as last_id FROM _sync_meta GROUP BY table_name;" --json`,
      { cwd: backendDir, encoding: 'utf8' }
    );
    const parsed = JSON.parse(jsonStr);
    if (parsed && parsed[0] && parsed[0].results) {
      for (const row of parsed[0].results) {
        watermarks[row.table_name] = { last_ts: row.last_ts, last_id: row.last_id };
      }
    }
    console.log('Watermarks loaded:', watermarks);
  } catch (e) {
    console.warn('Gagal membaca watermark dari D1, fallback ke full sync:', e.message);
  }
}

const syncDir = path.join(backendDir, 'sync_temp');
if (!fs.existsSync(syncDir)) fs.mkdirSync(syncDir, { recursive: true });

async function processTable(tableName, targetTable, queryBuilder) {
  const wm = watermarks[tableName];
  let query = `SELECT * FROM \`${tableName}\``;
  if (isIncremental && wm && wm.last_ts) {
    query += ` WHERE updatedAt > '${wm.last_ts}' OR createdAt > '${wm.last_ts}' OR id > ${wm.last_id || 0}`;
  }
  query += ` ORDER BY id ASC`;

  const [rows] = await conn.query(query);
  console.log(`- ${tableName} -> ${targetTable}: ${rows.length} rows to sync`);
  if (rows.length === 0) return;

  let maxId = wm ? wm.last_id || 0 : 0;
  let maxUpdated = wm ? wm.last_ts || null : null;
  const sqlStatements = [];

  for (const r of rows) {
    if (r.id > maxId) maxId = r.id;
    const upd = r.updatedAt || r.createdAt;
    if (upd && (!maxUpdated || new Date(upd) > new Date(maxUpdated))) maxUpdated = upd;
    const insertSql = queryBuilder(r);
    if (insertSql) sqlStatements.push(insertSql);
  }

  sqlStatements.push(
    `INSERT INTO _sync_meta (source_db, table_name, target_table, last_synced_id, last_synced_timestamp, total_records, notes) ` +
    `VALUES ('mariadb_marbot_prod', '${tableName}', '${targetTable}', ${maxId}, ${escapeSql(maxUpdated)}, ${rows.length}, '${isIncremental ? 'Incremental sync' : 'Full sync'}');`
  );

  const chunkPath = path.join(syncDir, `sync_${tableName}.sql`);
  fs.writeFileSync(chunkPath, sqlStatements.join('\n') + '\n', 'utf8');

  console.log(`  Executing D1 sync for ${targetTable} (${d1Target})...`);
  execSync(`npx wrangler d1 execute masjid-db ${d1Flag} --file="${chunkPath}" -y`, {
    cwd: backendDir,
    stdio: 'ignore'
  });
  console.log(`  ✅ Synced ${targetTable} successfully.`);
}

// Sync tables
await processTable('profiles', 'users', (r) => {
  const email = r.email || `jamaah_${r.id}@masjidannimah.id`;
  const name = r.nama || 'Jamaah';
  const photo = r.photo || '';
  const totalSedekah = r.total_sedekah || 0;
  const createdAt = r.createdAt ? escapeSql(r.createdAt) : 'CURRENT_TIMESTAMP';
  const updatedAt = r.updatedAt ? escapeSql(r.updatedAt) : 'CURRENT_TIMESTAMP';
  return `INSERT OR REPLACE INTO users (id, google_id, name, email, photo, total_sedekah, role, created_at, updated_at) VALUES (${r.id}, NULL, ${escapeSql(name)}, ${escapeSql(email)}, ${escapeSql(photo)}, ${totalSedekah}, 'jamaah', ${createdAt}, ${updatedAt});`;
});

await processTable('artikels', 'artikel', (a) => {
  const slug = a.seo || `artikel-${a.id}`;
  const createdAt = a.createdAt ? escapeSql(a.createdAt) : (a.tanggal ? escapeSql(a.tanggal) : 'CURRENT_TIMESTAMP');
  const konten = convertMediaUrl(a.isi || '');
  const image = convertMediaUrl(a.image || '');
  return `INSERT OR REPLACE INTO artikel (id, kategori_id, judul, slug, konten, thumbnail, penulis, dibaca, created_at) VALUES (${a.id}, ${a.idCategoryArtikel || 'NULL'}, ${escapeSql(a.judul || 'Tanpa Judul')}, ${escapeSql(slug)}, ${escapeSql(konten)}, ${escapeSql(image)}, 'DKM An-Ni''mah', 0, ${createdAt});`;
});

// id_kategori -> kajian_kategoris.nama (tabel kategori MariaDB prod, isinya statis):
// 1 tafsir | 2 live | 3 muadzin | 4 doa_ramadhan | 5 quotes
const KAJIAN_TIPE = { 1: 'tafsir', 2: 'live', 3: 'muadzin', 4: 'doa_ramadhan', 5: 'quotes' };

await processTable('kajians', 'kajian', (k) => {
  const tgl = k.tanggal ? escapeSql(k.tanggal) : (k.createdAt ? escapeSql(k.createdAt) : 'CURRENT_TIMESTAMP');
  const tipe = KAJIAN_TIPE[k.id_kategori] || 'list';
  const image = convertMediaUrl(k.image || '');
  return `INSERT OR REPLACE INTO kajian (id, judul, ustadz, deskripsi, thumbnail, video_link, tipe, tanggal_waktu, created_at) VALUES (${k.id}, ${escapeSql(k.judul || '')}, ${escapeSql(k.subjudul || 'Ustadz')}, ${escapeSql(k.subjudul || '')}, ${escapeSql(image)}, ${escapeSql(k.link || '')}, '${tipe}', ${tgl}, ${tgl});`;
});

await processTable('campaigns', 'campaign_sedekah', (c) => {
  const deskripsi = c.isi || c.subjudul || '';
  const end_date = c.deadline ? escapeSql(c.deadline.toISOString().slice(0, 10)) : 'NULL';
  const createdAt = c.createdAt ? escapeSql(c.createdAt) : 'CURRENT_TIMESTAMP';
  return `INSERT OR REPLACE INTO campaign_sedekah (id, judul, deskripsi, target_nominal, terkumpul_nominal, thumbnail, status, end_date, created_at) VALUES (${c.id}, ${escapeSql(c.judul || '')}, ${escapeSql(deskripsi)}, ${c.dana_kebutuhan || 0}, ${c.total || 0}, ${escapeSql(c.image || '')}, 'aktif', ${end_date}, ${createdAt});`;
});

await processTable('transaksis', 'transaksi_sedekah', (t) => {
  let email = '';
  let name = 'Donatur';
  let hp = '';
  let anonim = 0;
  let pesan = '';
  if (t.data_sedekah) {
    try {
      const parsed = JSON.parse(t.data_sedekah);
      email = parsed.email || '';
      name = parsed.nama || parsed.name || 'Donatur';
      hp = parsed.hp || parsed.phone || '';
      anonim = parsed.anonim ? 1 : 0;
      pesan = parsed.pesan || parsed.ucapan || '';
    } catch (e) {}
  }
  const createdAt = t.createdAt ? escapeSql(t.createdAt) : 'CURRENT_TIMESTAMP';
  return `INSERT OR REPLACE INTO transaksi_sedekah (id, invoice, campaign_id, user_email, nama_donatur, nomor_hp, nominal, pesan, anonim, metode_pembayaran, status, payment_url, va_number, qr_string, created_at) VALUES (${t.id}, ${escapeSql(t.invoice || `INV-${t.id}`)}, ${t.id_campaign || 'NULL'}, ${escapeSql(email)}, ${escapeSql(name)}, ${escapeSql(hp)}, ${t.nominal || 0}, ${escapeSql(pesan)}, ${anonim}, ${escapeSql(t.metode || 'manual')}, ${escapeSql(t.status || 'pending')}, NULL, NULL, NULL, ${createdAt});`;
});

await conn.end();
if (fs.existsSync(syncDir)) fs.rmSync(syncDir, { recursive: true, force: true });
console.log('\n✨ SINKRONISASI SELESAI!\n');
