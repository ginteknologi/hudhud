import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const kajian = new Hono<{ Bindings: Env }>();

// GET /api/v1/kajian/list?type=tafsir&page=1&limit=10
kajian.get('/list', async (c) => {
  const type = c.req.query('type');
  const page = Math.max(1, parseInt(c.req.query('page') || '1', 10));
  const limit = Math.min(50, Math.max(1, parseInt(c.req.query('limit') || '10', 10)));
  const offset = (page - 1) * limit;

  try {
    let countSql = "SELECT COUNT(*) as total FROM kajian WHERE tipe != 'muadzin'";
    let dataSql = `
      SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
             thumbnail as image, thumbnail, video_link as link, video_link, tipe
      FROM kajian
      WHERE tipe != 'muadzin'
    `;
    const params: any[] = [];
    if (type) {
      countSql = "SELECT COUNT(*) as total FROM kajian WHERE tipe = ?";
      dataSql = `
        SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
               thumbnail as image, thumbnail, video_link as link, video_link, tipe
        FROM kajian
        WHERE tipe = ?
      `;
      params.push(type);
    }

    const countRes: any = await c.env.DB.prepare(countSql).bind(...params).first();
    const total = countRes?.total || 0;

    dataSql += ' ORDER BY id DESC LIMIT ? OFFSET ?';
    const { results } = await c.env.DB.prepare(dataSql).bind(...params, limit, offset).all();

    return apiResponse(c, 200, true, 'Success', results || [], {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    });
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

// GET /api/v1/kajian/kaji-live/list?page=1&limit=10
kajian.get('/kaji-live/list', async (c) => {
  const page = Math.max(1, parseInt(c.req.query('page') || '1', 10));
  const limit = Math.min(50, Math.max(1, parseInt(c.req.query('limit') || '10', 10)));
  const offset = (page - 1) * limit;

  try {
    const countRes: any = await c.env.DB.prepare(
      "SELECT COUNT(*) as total FROM kajian WHERE tipe = 'live'"
    ).first();
    const total = countRes?.total || 0;

    const { results } = await c.env.DB.prepare(`
      SELECT id, judul, ustadz, deskripsi as subjudul, deskripsi,
             thumbnail as image, thumbnail, video_link as link, video_link, tipe
      FROM kajian
      WHERE tipe = 'live'
      ORDER BY id DESC LIMIT ? OFFSET ?
    `).bind(limit, offset).all();

    return apiResponse(c, 200, true, 'Success', results || [], {
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    });
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
