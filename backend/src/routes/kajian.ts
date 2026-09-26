import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const kajian = new Hono<{ Bindings: Env }>();

// GET /api/v1/kajian/list
kajian.get('/list', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
             thumbnail as image, thumbnail, video_link as link, video_link, tipe
      FROM kajian
      WHERE tipe != 'muadzin'
      ORDER BY id DESC
    `).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/kajian/slider?type=tafsir
// `type` cocok persis dengan `tipe` (asal: kajian_kategoris.nama di MariaDB prod).
kajian.get('/slider', async (c) => {
  const type = c.req.query('type') || 'tafsir';
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
             thumbnail as image, thumbnail, video_link as link, video_link, tipe
      FROM kajian
      WHERE tipe = ?
      ORDER BY id DESC LIMIT 5
    `).bind(type).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/kajian/kategori-list
kajian.get('/kategori-list', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
             thumbnail as image, thumbnail, video_link as link, video_link, tipe
      FROM kajian
      ORDER BY id DESC
    `).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/kajian/kategori-slider
kajian.get('/kategori-slider', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
             thumbnail as image, thumbnail, video_link as link, video_link, tipe
      FROM kajian
      WHERE tipe = 'slider'
      ORDER BY id DESC LIMIT 5
    `).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/kajian/muadzin/list
kajian.get('/muadzin/list', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
             thumbnail as image, thumbnail, video_link as link, video_link, tipe
      FROM kajian
      WHERE tipe = 'muadzin'
      ORDER BY id DESC
    `).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/kajian/kaji-live/list
kajian.get('/kaji-live/list', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
             thumbnail as image, thumbnail, video_link as link, video_link, tipe
      FROM kajian
      WHERE tipe = 'live'
      ORDER BY id DESC
    `).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/kajian/kaji-live/slider
kajian.get('/kaji-live/slider', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
             thumbnail as image, thumbnail, video_link as link, video_link, tipe
      FROM kajian
      WHERE tipe = 'live'
      ORDER BY id DESC LIMIT 5
    `).all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

export default kajian;
