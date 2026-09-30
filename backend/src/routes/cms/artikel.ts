import { Hono } from 'hono';
import { Env } from '../../types/env';
import { apiResponse } from '../../helpers/response';
import { adminAuth } from '../../middleware/adminAuth';

const cmsArtikel = new Hono<{ Bindings: Env }>();
cmsArtikel.use('*', adminAuth);

// ── Kategori ──

cmsArtikel.get('/kategori', async (c) => {
  const { results } = await c.env.DB.prepare('SELECT * FROM artikel_kategori ORDER BY id ASC').all();
  return apiResponse(c, 200, true, 'Success', results || []);
});

cmsArtikel.post('/kategori', async (c) => {
  const { nama, slug } = await c.req.json<{ nama: string; slug: string }>();
  if (!nama?.trim()) return apiResponse(c, 400, false, 'Nama wajib diisi', null);
  if (!slug?.trim()) return apiResponse(c, 400, false, 'Slug wajib diisi', null);

  try {
    const res = await c.env.DB.prepare('INSERT INTO artikel_kategori (nama, slug) VALUES (?, ?)')
      .bind(nama.trim(), slug.trim())
      .run();
    return apiResponse(c, 201, true, 'Kategori berhasil ditambahkan', { id: res.meta.last_row_id });
  } catch (e: any) {
    if (e.message?.includes('UNIQUE')) return apiResponse(c, 409, false, 'Slug sudah digunakan', null);
    throw e;
  }
});

cmsArtikel.put('/kategori/:id', async (c) => {
  const id = c.req.param('id');
  const { nama, slug } = await c.req.json<{ nama: string; slug: string }>();
  if (!nama?.trim()) return apiResponse(c, 400, false, 'Nama wajib diisi', null);
  if (!slug?.trim()) return apiResponse(c, 400, false, 'Slug wajib diisi', null);

  try {
    const res = await c.env.DB.prepare('UPDATE artikel_kategori SET nama = ?, slug = ? WHERE id = ?')
      .bind(nama.trim(), slug.trim(), id)
      .run();
    if (!res.meta.changes) return apiResponse(c, 404, false, 'Kategori tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Kategori berhasil diupdate', null);
  } catch (e: any) {
    if (e.message?.includes('UNIQUE')) return apiResponse(c, 409, false, 'Slug sudah digunakan', null);
    throw e;
  }
});

cmsArtikel.delete('/kategori/:id', async (c) => {
  const id = c.req.param('id');
  const res = await c.env.DB.prepare('DELETE FROM artikel_kategori WHERE id = ?').bind(id).run();
  if (!res.meta.changes) return apiResponse(c, 404, false, 'Kategori tidak ditemukan', null);
  return apiResponse(c, 200, true, 'Kategori berhasil dihapus', null);
});

// ── Artikel CRUD ──

cmsArtikel.get('/', async (c) => {
  const page = Math.max(1, parseInt(c.req.query('page') || '1', 10));
  const limit = Math.min(50, Math.max(1, parseInt(c.req.query('size') || c.req.query('limit') || '10', 10)));
  const offset = (page - 1) * limit;
  const kategoriId = c.req.query('kategori_id');
  const search = c.req.query('search') || '';
  const sortField = c.req.query('sortField') || 'id';
  const sortOrder = c.req.query('order') === '1' ? 'ASC' : 'DESC';
  const allowedSort = ['id', 'judul', 'penulis', 'dibaca', 'created_at', 'kategori_id'];
  const safeSort = allowedSort.includes(sortField) ? `a.${sortField}` : 'a.id';

  let countSql = 'SELECT COUNT(*) as total FROM artikel';
  let dataSql = `
    SELECT a.*, k.nama as cat_nama, k.slug as cat_slug
    FROM artikel a
    LEFT JOIN artikel_kategori k ON a.kategori_id = k.id
  `;
  const params: any[] = [];
  const wheres: string[] = [];

  if (kategoriId) {
    wheres.push('a.kategori_id = ?');
    params.push(kategoriId);
  }
  if (search) {
    wheres.push('(a.judul LIKE ? OR a.konten LIKE ?)');
    params.push(`%${search}%`, `%${search}%`);
  }
  if (wheres.length) {
    const w = ' WHERE ' + wheres.join(' AND ');
    countSql += w.replace(/a\./g, '');
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

cmsArtikel.get('/:id', async (c) => {
  const id = c.req.param('id');
  const row = await c.env.DB.prepare(`
    SELECT a.*, k.nama as cat_nama, k.slug as cat_slug
    FROM artikel a
    LEFT JOIN artikel_kategori k ON a.kategori_id = k.id
    WHERE a.id = ?
  `).bind(id).first();
  if (!row) return apiResponse(c, 404, false, 'Artikel tidak ditemukan', null);
  return apiResponse(c, 200, true, 'Success', row);
});

cmsArtikel.post('/', async (c) => {
  const body = await c.req.json<{
    judul: string; slug: string; konten: string;
    thumbnail?: string; penulis?: string; kategori_id?: number;
  }>();
  if (!body.judul?.trim()) return apiResponse(c, 400, false, 'Judul wajib diisi', null);
  if (!body.slug?.trim()) return apiResponse(c, 400, false, 'Slug wajib diisi', null);
  if (!body.konten?.trim()) return apiResponse(c, 400, false, 'Konten wajib diisi', null);

  try {
    const res = await c.env.DB.prepare(
      'INSERT INTO artikel (kategori_id, judul, slug, konten, thumbnail, penulis) VALUES (?, ?, ?, ?, ?, ?)'
    ).bind(
      body.kategori_id || null, body.judul.trim(), body.slug.trim(),
      body.konten.trim(), body.thumbnail?.trim() || null, body.penulis?.trim() || "DKM An-Ni'mah"
    ).run();
    return apiResponse(c, 201, true, 'Artikel berhasil ditambahkan', { id: res.meta.last_row_id });
  } catch (e: any) {
    if (e.message?.includes('UNIQUE')) return apiResponse(c, 409, false, 'Slug sudah digunakan', null);
    throw e;
  }
});

cmsArtikel.put('/:id', async (c) => {
  const id = c.req.param('id');
  const body = await c.req.json<{
    judul: string; slug: string; konten: string;
    thumbnail?: string; penulis?: string; kategori_id?: number;
  }>();
  if (!body.judul?.trim()) return apiResponse(c, 400, false, 'Judul wajib diisi', null);
  if (!body.slug?.trim()) return apiResponse(c, 400, false, 'Slug wajib diisi', null);
  if (!body.konten?.trim()) return apiResponse(c, 400, false, 'Konten wajib diisi', null);

  try {
    const res = await c.env.DB.prepare(
      'UPDATE artikel SET kategori_id = ?, judul = ?, slug = ?, konten = ?, thumbnail = ?, penulis = ? WHERE id = ?'
    ).bind(
      body.kategori_id || null, body.judul.trim(), body.slug.trim(),
      body.konten.trim(), body.thumbnail?.trim() || null, body.penulis?.trim() || "DKM An-Ni'mah", id
    ).run();
    if (!res.meta.changes) return apiResponse(c, 404, false, 'Artikel tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Artikel berhasil diupdate', null);
  } catch (e: any) {
    if (e.message?.includes('UNIQUE')) return apiResponse(c, 409, false, 'Slug sudah digunakan', null);
    throw e;
  }
});

cmsArtikel.delete('/:id', async (c) => {
  const id = c.req.param('id');
  const res = await c.env.DB.prepare('DELETE FROM artikel WHERE id = ?').bind(id).run();
  if (!res.meta.changes) return apiResponse(c, 404, false, 'Artikel tidak ditemukan', null);
  return apiResponse(c, 200, true, 'Artikel berhasil dihapus', null);
});

export default cmsArtikel;
