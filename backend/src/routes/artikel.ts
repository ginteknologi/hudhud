import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const artikel = new Hono<{ Bindings: Env }>();

// GET /api/v1/artikel?page=1&limit=10&kategori=
artikel.get('/', async (c) => {
  const page = Math.max(1, parseInt(c.req.query('page') || '1', 10));
  const limit = Math.min(50, Math.max(1, parseInt(c.req.query('limit') || '10', 10)));
  const offset = (page - 1) * limit;
  const kategori = c.req.query('kategori') || c.req.query('cat_id');

  try {
    let countSql = 'SELECT COUNT(*) as total FROM artikel';
    let dataSql = `
      SELECT a.id, a.judul, a.slug, a.konten as isi, a.konten,
             a.thumbnail as image, a.thumbnail, a.penulis, a.dibaca,
             a.created_at, a.created_at as updatedAt, a.created_at as publish_date,
             k.id as cat_id, k.nama as cat_nama, k.slug as cat_slug
      FROM artikel a
      LEFT JOIN artikel_kategori k ON a.kategori_id = k.id
    `;
    const params: any[] = [];
    if (kategori) {
      countSql += ' WHERE a.kategori_id = ?';
      dataSql += ' WHERE a.kategori_id = ?';
      params.push(kategori);
    }

    const countRes: any = await c.env.DB.prepare(countSql).bind(...params).first();
    const total = countRes?.total || 0;

    dataSql += ' ORDER BY a.id DESC LIMIT ? OFFSET ?';
    const { results } = await c.env.DB.prepare(dataSql).bind(...params, limit, offset).all();

    const formatted = (results || []).map((row: any) => ({
      ...row,
      category_artikel: row.cat_id
        ? { id: row.cat_id, nama: row.cat_nama, slug: row.cat_slug }
        : { id: 1, nama: 'Umum', slug: 'umum' },
    }));

    return apiResponse(c, 200, true, 'Success', formatted, {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    });
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/artikel/terbaru
artikel.get('/terbaru', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT a.id, a.judul, a.slug, a.konten, a.konten as isi,
             a.thumbnail, a.thumbnail as image, a.created_at,
             a.created_at as updatedAt, a.created_at as publish_date
      FROM artikel a
      ORDER BY a.id DESC LIMIT 5
    `).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/artikel/detail/:id
artikel.get('/detail/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const row: any = await c.env.DB.prepare(`
      SELECT a.id, a.judul, a.slug, a.konten as isi, a.konten,
             a.thumbnail as image, a.thumbnail, a.penulis, a.dibaca,
             a.created_at, a.created_at as updatedAt, a.created_at as publish_date,
             k.id as cat_id, k.nama as cat_nama, k.slug as cat_slug
      FROM artikel a
      LEFT JOIN artikel_kategori k ON a.kategori_id = k.id
      WHERE a.id = ?
    `).bind(id).first();

    if (!row) {
      return apiResponse(c, 404, false, 'Artikel tidak ditemukan', null);
    }

    const item = {
      ...row,
      category_artikel: row.cat_id
        ? { id: row.cat_id, nama: row.cat_nama, slug: row.cat_slug }
        : { id: 1, nama: 'Umum', slug: 'umum' },
    };

    return apiResponse(c, 200, true, 'Success', item);
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Artikel tidak ditemukan', null);
  }
});

// GET /api/v1/artikel/lain/:id
artikel.get('/lain/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT a.id, a.judul, a.slug, a.konten as isi, a.konten,
             a.thumbnail as image, a.thumbnail, a.created_at,
             a.created_at as updatedAt, a.created_at as publish_date
      FROM artikel a
      WHERE a.id != ?
      ORDER BY a.id DESC LIMIT 4
    `).bind(id).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

export default artikel;
