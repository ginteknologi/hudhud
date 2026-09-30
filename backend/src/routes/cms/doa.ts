import { Hono } from 'hono';
import { Env } from '../../types/env';
import { apiResponse } from '../../helpers/response';
import { adminAuth } from '../../middleware/adminAuth';

const cmsDoa = new Hono<{ Bindings: Env }>();
cmsDoa.use('*', adminAuth);

// ── Kategori ──

cmsDoa.get('/kategori', async (c) => {
  const { results } = await c.env.DB.prepare('SELECT * FROM doa_kategori ORDER BY id ASC').all();
  return apiResponse(c, 200, true, 'Success', results || []);
});

cmsDoa.post('/kategori', async (c) => {
  const { nama, icon } = await c.req.json<{ nama: string; icon?: string }>();
  if (!nama?.trim()) return apiResponse(c, 400, false, 'Nama wajib diisi', null);

  const res = await c.env.DB.prepare('INSERT INTO doa_kategori (nama, icon) VALUES (?, ?)')
    .bind(nama.trim(), icon?.trim() || null)
    .run();
  return apiResponse(c, 201, true, 'Kategori berhasil ditambahkan', { id: res.meta.last_row_id });
});

cmsDoa.put('/kategori/:id', async (c) => {
  const id = c.req.param('id');
  const { nama, icon } = await c.req.json<{ nama: string; icon?: string }>();
  if (!nama?.trim()) return apiResponse(c, 400, false, 'Nama wajib diisi', null);

  const res = await c.env.DB.prepare('UPDATE doa_kategori SET nama = ?, icon = ? WHERE id = ?')
    .bind(nama.trim(), icon?.trim() || null, id)
    .run();
  if (!res.meta.changes) return apiResponse(c, 404, false, 'Kategori tidak ditemukan', null);
  return apiResponse(c, 200, true, 'Kategori berhasil diupdate', null);
});

cmsDoa.delete('/kategori/:id', async (c) => {
  const id = c.req.param('id');
  const res = await c.env.DB.prepare('DELETE FROM doa_kategori WHERE id = ?').bind(id).run();
  if (!res.meta.changes) return apiResponse(c, 404, false, 'Kategori tidak ditemukan', null);
  return apiResponse(c, 200, true, 'Kategori berhasil dihapus', null);
});

// ── Doa CRUD ──

cmsDoa.get('/', async (c) => {
  const page = Math.max(1, parseInt(c.req.query('page') || '1', 10));
  const limit = Math.min(50, Math.max(1, parseInt(c.req.query('size') || c.req.query('limit') || '20', 10)));
  const offset = (page - 1) * limit;
  const kategoriId = c.req.query('kategori_id');
  const search = c.req.query('search') || '';
  const sortField = c.req.query('sortField') || 'id';
  const sortOrder = c.req.query('order') === '1' ? 'ASC' : 'DESC';
  const allowedSort = ['id', 'judul', 'kategori_id'];
  const safeSort = allowedSort.includes(sortField) ? sortField : 'id';

  let countSql = 'SELECT COUNT(*) as total FROM doa';
  let dataSql = 'SELECT * FROM doa';
  const params: any[] = [];
  const wheres: string[] = [];

  if (kategoriId) {
    wheres.push('kategori_id = ?');
    params.push(kategoriId);
  }
  if (search) {
    wheres.push('(judul LIKE ? OR terjemahan LIKE ?)');
    params.push(`%${search}%`, `%${search}%`);
  }
  if (wheres.length) {
    const w = ' WHERE ' + wheres.join(' AND ');
    countSql += w;
    dataSql += w;
  }

  const countRes: any = await c.env.DB.prepare(countSql).bind(...params).first();
  const total = countRes?.total || 0;

  dataSql += ` ORDER BY ${safeSort} ${sortOrder} LIMIT ? OFFSET ?`;
  const { results } = await c.env.DB.prepare(dataSql).bind(...params, limit, offset).all();

  return apiResponse(c, 200, true, 'Success', results || [], {
    page, limit, total, totalItems: total, totalPages: Math.ceil(total / limit),
  });
});

cmsDoa.get('/:id', async (c) => {
  const id = c.req.param('id');
  const item = await c.env.DB.prepare('SELECT * FROM doa WHERE id = ?').bind(id).first();
  if (!item) return apiResponse(c, 404, false, 'Doa tidak ditemukan', null);
  return apiResponse(c, 200, true, 'Success', item);
});

cmsDoa.post('/', async (c) => {
  const body = await c.req.json<{
    judul: string; teks_arab: string; teks_latin?: string;
    terjemahan: string; riwayat?: string; kategori_id?: number;
  }>();
  if (!body.judul?.trim()) return apiResponse(c, 400, false, 'Judul wajib diisi', null);
  if (!body.teks_arab?.trim()) return apiResponse(c, 400, false, 'Teks arab wajib diisi', null);
  if (!body.terjemahan?.trim()) return apiResponse(c, 400, false, 'Terjemahan wajib diisi', null);

  const res = await c.env.DB.prepare(
    'INSERT INTO doa (kategori_id, judul, teks_arab, teks_latin, terjemahan, riwayat) VALUES (?, ?, ?, ?, ?, ?)'
  ).bind(
    body.kategori_id || null, body.judul.trim(), body.teks_arab.trim(),
    body.teks_latin?.trim() || null, body.terjemahan.trim(), body.riwayat?.trim() || null
  ).run();

  return apiResponse(c, 201, true, 'Doa berhasil ditambahkan', { id: res.meta.last_row_id });
});

cmsDoa.put('/:id', async (c) => {
  const id = c.req.param('id');
  const body = await c.req.json<{
    judul: string; teks_arab: string; teks_latin?: string;
    terjemahan: string; riwayat?: string; kategori_id?: number;
  }>();
  if (!body.judul?.trim()) return apiResponse(c, 400, false, 'Judul wajib diisi', null);
  if (!body.teks_arab?.trim()) return apiResponse(c, 400, false, 'Teks arab wajib diisi', null);
  if (!body.terjemahan?.trim()) return apiResponse(c, 400, false, 'Terjemahan wajib diisi', null);

  const res = await c.env.DB.prepare(
    'UPDATE doa SET kategori_id = ?, judul = ?, teks_arab = ?, teks_latin = ?, terjemahan = ?, riwayat = ? WHERE id = ?'
  ).bind(
    body.kategori_id || null, body.judul.trim(), body.teks_arab.trim(),
    body.teks_latin?.trim() || null, body.terjemahan.trim(), body.riwayat?.trim() || null, id
  ).run();

  if (!res.meta.changes) return apiResponse(c, 404, false, 'Doa tidak ditemukan', null);
  return apiResponse(c, 200, true, 'Doa berhasil diupdate', null);
});

cmsDoa.delete('/:id', async (c) => {
  const id = c.req.param('id');
  const res = await c.env.DB.prepare('DELETE FROM doa WHERE id = ?').bind(id).run();
  if (!res.meta.changes) return apiResponse(c, 404, false, 'Doa tidak ditemukan', null);
  return apiResponse(c, 200, true, 'Doa berhasil dihapus', null);
});

export default cmsDoa;
