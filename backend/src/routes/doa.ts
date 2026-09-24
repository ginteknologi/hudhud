import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const doa = new Hono<{ Bindings: Env }>();

// GET /api/v1/doa
doa.get('/', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM doa ORDER BY id ASC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/doa/category
doa.get('/category', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM doa_kategori ORDER BY id ASC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/doa/category/:id
doa.get('/category/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const item = await c.env.DB.prepare('SELECT * FROM doa_kategori WHERE id = ?').bind(id).first();
    if (!item) return apiResponse(c, 404, false, 'Kategori tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Success', item);
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Kategori tidak ditemukan', null);
  }
});

// GET /api/v1/doa/list/:id (by category)
doa.get('/list/:id', async (c) => {
  const categoryId = c.req.param('id');
  const search = c.req.query('search') || '';
  try {
    let query = 'SELECT * FROM doa WHERE kategori_id = ?';
    const params: any[] = [categoryId];
    if (search) {
      query += ' AND (judul LIKE ? OR terjemahan LIKE ?)';
      params.push(`%${search}%`, `%${search}%`);
    }
    query += ' ORDER BY id ASC';
    const { results } = await c.env.DB.prepare(query).bind(...params).all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/doa/detail/:id
doa.get('/detail/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const item = await c.env.DB.prepare('SELECT * FROM doa WHERE id = ?').bind(id).first();
    if (!item) return apiResponse(c, 404, false, 'Doa tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Success', item);
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Doa tidak ditemukan', null);
  }
});

// GET /api/v1/doa/dzikir
doa.get('/dzikir', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM dzikir ORDER BY id ASC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

export default doa;
