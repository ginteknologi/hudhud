import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const hadits = new Hono<{ Bindings: Env }>();

// Panjang minimum query pencarian. Di bawah ini langsung balas kosong supaya
// tidak ada LIKE '%a%' yang men-scan 39.5k baris.
const MIN_QUERY_LENGTH = 3;

function likePattern(raw: string): string {
  // Escape wildcard LIKE supaya '100%' tidak jadi match-semua.
  return `%${raw.replace(/[\\%_]/g, (m) => '\\' + m)}%`;
}

// ============================================================
// GET /api/v1/hadits
// Daftar semua imam/perawi + jumlah bab (0 = kitab tanpa level bab)
// ============================================================
hadits.get('/', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(
      `SELECT i.imamId, i.imamSorting, i.hadits, i.longNama, i.namaTabel, i.slug,
              (SELECT COUNT(*) FROM hadits_bab b WHERE b.namaTabel = i.namaTabel) AS babCount
         FROM had_imam i
        ORDER BY i.imamSorting ASC`
    ).all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 500, false, e.message, []);
  }
});

// ============================================================
// GET /api/v1/hadits/bab/:id
// Daftar bab satu kitab. Array kosong = kitab ini belum punya bab.
// ============================================================
hadits.get('/bab/:id', async (c) => {
  const table = c.req.param('id');
  try {
    const { results } = await c.env.DB.prepare(
      `SELECT id, nama, namaArab, urutan, noAwal, noAkhir
         FROM hadits_bab
        WHERE namaTabel = ?
        ORDER BY urutan ASC, noAwal ASC`
    ).bind(table).all();
    return apiResponse(c, 200, true, 'Success', results || [], {
      total: (results || []).length,
    });
  } catch (e: any) {
    return apiResponse(c, 500, false, e.message, []);
  }
});

// ============================================================
// GET /api/v1/hadits/search?q=&namaTabel=&page=1&limit=20
// Cari kata di teks Arab / terjemahan. Lintas kitab atau satu kitab.
// ponytail: LIKE scan; kalau p95 > 300ms baru pertimbangkan FTS5
// (D1 mendukung FTS5, tapi tanpa tokenizer Indonesia ia hanya menambah kecepatan).
// ============================================================
hadits.get('/search', async (c) => {
  const raw = (c.req.query('q') || '').trim();
  const page = Math.max(1, parseInt(c.req.query('page') || '1', 10));
  const limit = Math.min(50, Math.max(1, parseInt(c.req.query('limit') || '20', 10)));
  const offset = (page - 1) * limit;
  const namaTabel = c.req.query('namaTabel') || '';

  if (raw.length < MIN_QUERY_LENGTH) {
    return apiResponse(c, 200, true, 'Query terlalu pendek', [], {
      page,
      limit,
      total: 0,
      totalPages: 0,
    });
  }

  const pattern = likePattern(raw);
  let where = `(Isi_Indonesia LIKE ? ESCAPE '\\' OR Isi_Arab LIKE ? ESCAPE '\\')`;
  const binds: any[] = [pattern, pattern];

  if (namaTabel) {
    where += ' AND namaTabel = ?';
    binds.push(namaTabel);
  }

  try {
    const [{ total }] = (await c.env.DB.prepare(
      `SELECT COUNT(*) as total FROM hadits_konten WHERE ${where}`
    ).bind(...binds).all()).results as any[];

    const { results } = await c.env.DB.prepare(
      `SELECT namaTabel, NoHdt, Isi_Arab, Isi_Indonesia
         FROM hadits_konten
        WHERE ${where}
        ORDER BY namaTabel ASC, NoHdt ASC
        LIMIT ? OFFSET ?`
    ).bind(...binds, limit, offset).all();

    return apiResponse(c, 200, true, 'Success', results || [], {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    });
  } catch (e: any) {
    return apiResponse(c, 500, false, e.message, []);
  }
});

// ============================================================
// GET /api/v1/hadits/tema
// Tujuh kategori induk saja (435 baris jadi daftar yang tidak berguna).
//
// `jumlah` = hitungan TURUNAN, bukan relasi langsung. Kategori induk hampir
// tidak pernah menampung hadits sendiri (akidah: 6 langsung vs 503 turunan),
// jadi hitungan langsung membuat menu terlihat kosong.
//
// Kategori "yatim": `categories` pada tiap koleksi memuat id yang tidak ada di
// /hadits/koleksi/kategori (739, 1001–1007, …) dan tidak ada endpoint nama
// untuknya. Hadits di id-id itu tetap ditampilkan, di bucket "Tanpa Kategori",
// bukan dibuang atau diberi nama karangan.
// ============================================================
const DESCENDANTS_CTE = `
  WITH RECURSIVE turunan(id, root) AS (
    SELECT id, id FROM hadits_tema WHERE parent IS NULL
    UNION ALL
    SELECT t.id, d.root FROM hadits_tema t JOIN turunan d ON t.parent = d.id
  )`;

hadits.get('/tema', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(
      `${DESCENDANTS_CTE}
       SELECT t.id, t.nama,
              (SELECT COUNT(DISTINCT i.koleksiId)
                 FROM hadits_tema_item i
                WHERE i.temaId IN (SELECT id FROM turunan WHERE root = t.id)) AS jumlah
         FROM hadits_tema t
        WHERE t.parent IS NULL
        ORDER BY jumlah DESC, t.nama ASC`
    ).all();

    const yatim = await c.env.DB.prepare(
      `SELECT COUNT(DISTINCT i.koleksiId) AS jumlah
         FROM hadits_tema_item i
        WHERE NOT EXISTS (SELECT 1 FROM hadits_tema t WHERE t.id = i.temaId)`
    ).first<{ jumlah: number }>();

    const rows = [...(results || [])];
    if ((yatim?.jumlah ?? 0) > 0) {
      rows.push({ id: 0, nama: 'Tanpa Kategori', jumlah: yatim!.jumlah });
    }

    return apiResponse(c, 200, true, 'Success', rows, { total: rows.length });
  } catch (e: any) {
    return apiResponse(c, 500, false, e.message, []);
  }
});

// ============================================================
// GET /api/v1/hadits/tema/:id
// Isi satu tema = hadits dari dirinya + seluruh turunannya.
//
// `root` di CTE = anak LANGSUNG dari tema yang diminta, bukan kategori induk.
// Itu yang membuat hitungan per sub benar: baris (id, root) memuat tiap
// keturunan beserta anak langsung yang menaunginya, jadi
// `WHERE root = t.id` menghitung subtree milik t.
//
// `id = 0` → bucket "Tanpa Kategori" (lihat catatan di /tema).
// Tanpa pagination — set kurasi kecil.
// ponytail: kalau suatu tema > ~200 baris, tambah LIMIT/OFFSET.
// ============================================================
const SUBTREE_CTE = `
  WITH RECURSIVE keturunan(id, root) AS (
    SELECT id, id FROM hadits_tema WHERE parent = ?
    UNION ALL
    SELECT t.id, kt.root FROM hadits_tema t JOIN keturunan kt ON t.parent = kt.id
  )`;

hadits.get('/tema/:id', async (c) => {
  const id = parseInt(c.req.param('id'), 10);
  if (!Number.isFinite(id) || id < 0) {
    return apiResponse(c, 400, false, 'id tema tidak valid', []);
  }
  try {
    const tanpaKategori = id === 0;
    const tema = tanpaKategori
      ? { id: 0, nama: 'Tanpa Kategori' }
      : await c.env.DB.prepare('SELECT id, nama FROM hadits_tema WHERE id = ?')
          .bind(id)
          .first();

    const scope = tanpaKategori
      ? `SELECT i.koleksiId FROM hadits_tema_item i
          WHERE NOT EXISTS (SELECT 1 FROM hadits_tema t WHERE t.id = i.temaId)`
      : `${SUBTREE_CTE}
         SELECT i.koleksiId FROM hadits_tema_item i
          WHERE i.temaId IN (SELECT id FROM keturunan) OR i.temaId = ?`;

    const { results } = await c.env.DB.prepare(
      `SELECT k.id, k.judul, k.arab, k.indo
         FROM (${scope}) s
         JOIN hadits_koleksi k ON k.id = s.koleksiId
        GROUP BY k.id
        ORDER BY k.id ASC`
    ).bind(...(tanpaKategori ? [] : [id, id])).all();

    // Anak langsung, masing-masing dengan jumlah seluruh subtree-nya.
    const { results: sub } = tanpaKategori
      ? { results: [] as any[] }
      : await c.env.DB.prepare(
          `${SUBTREE_CTE}
           SELECT t.id, t.nama,
                  (SELECT COUNT(DISTINCT i.koleksiId)
                     FROM hadits_tema_item i
                    WHERE i.temaId IN (SELECT id FROM keturunan WHERE root = t.id)) AS jumlah
             FROM hadits_tema t
            WHERE t.parent = ?
            ORDER BY jumlah DESC, t.nama ASC`
        ).bind(id, id).all();

    return apiResponse(c, 200, true, 'Success', results || [], {
      tema: tema || null,
      sub: sub || [],
      total: (results || []).length,
    });
  } catch (e: any) {
    return apiResponse(c, 500, false, e.message, []);
  }
});

// ============================================================
// GET /api/v1/hadits/detail/:namaTabel?page=1&limit=20&mulai=&akhir=
// Daftar hadits dengan pagination.
// `mulai`/`akhir` = jendela NoHdt; dipakai untuk lompat nomor, scope bab,
// dan lanjutkan-baca. Ketiganya hal yang sama.
// ============================================================
hadits.get('/detail/:id', async (c) => {
  const table = c.req.param('id');
  const page = Math.max(1, parseInt(c.req.query('page') || '1', 10));
  const limit = Math.min(100, Math.max(1, parseInt(c.req.query('limit') || '20', 10)));
  const offset = (page - 1) * limit;
  const mulai = parseInt(c.req.query('mulai') || '0', 10);
  const akhir = parseInt(c.req.query('akhir') || '0', 10);

  let where = 'namaTabel = ?';
  const binds: any[] = [table];
  if (Number.isFinite(mulai) && mulai > 0) {
    where += ' AND NoHdt >= ?';
    binds.push(mulai);
  }
  if (Number.isFinite(akhir) && akhir > 0 && akhir >= mulai) {
    where += ' AND NoHdt <= ?';
    binds.push(akhir);
  }

  try {
    const [{ total }] = (await c.env.DB.prepare(
      `SELECT COUNT(*) as total FROM hadits_konten WHERE ${where}`
    ).bind(...binds).all()).results as any[];

    const { results } = await c.env.DB.prepare(
      `SELECT NoHdt, Isi_Arab, Isi_Indonesia
         FROM hadits_konten
        WHERE ${where}
        ORDER BY NoHdt ASC
        LIMIT ? OFFSET ?`
    ).bind(...binds, limit, offset).all();

    return apiResponse(c, 200, true, 'Success', results || [], {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    });
  } catch (e: any) {
    return apiResponse(c, 500, false, e.message, []);
  }
});

export default hadits;
