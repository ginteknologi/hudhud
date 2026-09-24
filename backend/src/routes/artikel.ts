import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const artikel = new Hono<{ Bindings: Env }>();

// GET /api/v1/artikel
artikel.get('/', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT a.id, a.judul, a.slug, a.konten as isi, a.konten,
             a.thumbnail as image, a.thumbnail, a.penulis, a.dibaca,
             a.created_at, a.created_at as updatedAt, a.created_at as publish_date,
             k.id as cat_id, k.nama as cat_nama, k.slug as cat_slug
      FROM artikel a
      LEFT JOIN artikel_kategori k ON a.kategori_id = k.id
      ORDER BY a.id DESC
    `).all();

    const formatted = (results || []).map((row: any) => ({
      ...row,
      category_artikel: row.cat_id
        ? { id: row.cat_id, nama: row.cat_nama, slug: row.cat_slug }
        : { id: 1, nama: 'Umum', slug: 'umum' },
    }));

    return apiResponse(c, 200, true, 'Success', formatted);
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

// GET /api/v1/artikel/category
artikel.get('/category', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM artikel_kategori ORDER BY id ASC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

export default artikel;
