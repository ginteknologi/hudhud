import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const sedekah = new Hono<{ Bindings: Env }>();

// GET /api/v1/campaign
sedekah.get('/campaign', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, judul as title, deskripsi, deskripsi as description,
             target_nominal as target, target_nominal,
             terkumpul_nominal as terkumpul, terkumpul_nominal,
             thumbnail as image, thumbnail, status, end_date, created_at
      FROM campaign_sedekah
      WHERE status = 'aktif'
      ORDER BY id DESC
    `).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/campaign/:id
sedekah.get('/campaign/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const item = await c.env.DB.prepare(`
      SELECT id, judul, judul as title, deskripsi, deskripsi as description,
             target_nominal as target, target_nominal,
             terkumpul_nominal as terkumpul, terkumpul_nominal,
             thumbnail as image, thumbnail, status, end_date, created_at
      FROM campaign_sedekah
      WHERE id = ?
    `).bind(id).first();

    if (!item) {
      return apiResponse(c, 404, false, 'Campaign tidak ditemukan', null);
    }
    return apiResponse(c, 200, true, 'Success', item);
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Campaign tidak ditemukan', null);
  }
});

// GET /api/v1/sedekah
sedekah.get('/sedekah', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, judul as title, deskripsi, deskripsi as description,
             target_nominal as target, target_nominal,
             terkumpul_nominal as terkumpul, terkumpul_nominal,
             thumbnail as image, thumbnail, status, end_date, created_at
      FROM campaign_sedekah
      ORDER BY id DESC
    `).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/penyalur_campaign
sedekah.get('/penyalur_campaign', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM penyalur_campaign ORDER BY id ASC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

export default sedekah;
