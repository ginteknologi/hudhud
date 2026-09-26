import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const doa = new Hono<{ Bindings: Env }>();

function extractArabicFromHtml(html: string): string {
  if (!html) return '';
  const matches = html.match(/<p class=['"]arabic['"]>([\s\S]*?)<\/p>/gi);
  if (matches && matches.length > 0) {
    return matches
      .map((m) => m.replace(/<[^>]+>/g, ' ').replace(/&nbsp;/g, ' ').replace(/\s+/g, ' ').trim())
      .filter(Boolean)
      .join('\n\n');
  }
  return '';
}

function extractLatinFromHtml(html: string): string {
  if (!html) return '';
  const matches = html.match(/<p class=['"]latin-text['"]>([\s\S]*?)<\/p>/gi);
  if (matches && matches.length > 0) {
    return matches
      .map((m) => m.replace(/<[^>]+>/g, ' ').replace(/&nbsp;/g, ' ').replace(/\s+/g, ' ').trim())
      .filter(Boolean)
      .join('\n\n');
  }
  return '';
}

function formatDoaRow(row: any) {
  let arabic = (row.teks_arab || '').trim();
  if (!arabic && row.terjemahan) {
    arabic = extractArabicFromHtml(row.terjemahan);
  }
  let latin = (row.teks_latin || '').trim();
  if (!latin && row.terjemahan) {
    latin = extractLatinFromHtml(row.terjemahan);
  }

  const terjemahan = row.terjemahan || '';
  return {
    ...row,
    teks_arab: arabic,
    teks_latin: latin,
    terjemahan: terjemahan,
    arab: arabic,
    arabic: arabic,
    latin: latin,
    transliteration: latin,
    arti: terjemahan,
    translations: terjemahan,
    isi: terjemahan,
  };
}

// GET /api/v1/doa?page=1&limit=20
doa.get('/', async (c) => {
  const page = Math.max(1, parseInt(c.req.query('page') || '1', 10));
  const limit = Math.min(50, Math.max(1, parseInt(c.req.query('limit') || '20', 10)));
  const offset = (page - 1) * limit;

  try {
    const countRes: any = await c.env.DB.prepare('SELECT COUNT(*) as total FROM doa').first();
    const total = countRes?.total || 0;

    const { results } = await c.env.DB.prepare(
      'SELECT * FROM doa ORDER BY id ASC LIMIT ? OFFSET ?'
    ).bind(limit, offset).all();

    const formatted = (results || []).map(formatDoaRow);

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

// GET /api/v1/doa/list/:id?page=1&limit=15&search= (by category)
doa.get('/list/:id', async (c) => {
  const categoryId = c.req.param('id');
  const search = c.req.query('search') || '';
  const page = Math.max(1, parseInt(c.req.query('page') || '1', 10));
  const limit = Math.min(50, Math.max(1, parseInt(c.req.query('limit') || '15', 10)));
  const offset = (page - 1) * limit;

  try {
    let countSql = 'SELECT COUNT(*) as total FROM doa WHERE kategori_id = ?';
    let dataSql = 'SELECT * FROM doa WHERE kategori_id = ?';
    const params: any[] = [categoryId];

    if (search) {
      countSql += ' AND (judul LIKE ? OR terjemahan LIKE ?)';
      dataSql += ' AND (judul LIKE ? OR terjemahan LIKE ?)';
      params.push(`%${search}%`, `%${search}%`);
    }

    const countRes: any = await c.env.DB.prepare(countSql).bind(...params).first();
    const total = countRes?.total || 0;

    dataSql += ' ORDER BY id ASC LIMIT ? OFFSET ?';
    const { results } = await c.env.DB.prepare(dataSql).bind(...params, limit, offset).all();

    const formatted = (results || []).map(formatDoaRow);

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

// GET /api/v1/doa/detail/:id
doa.get('/detail/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const item: any = await c.env.DB.prepare('SELECT * FROM doa WHERE id = ?').bind(id).first();
    if (!item) return apiResponse(c, 404, false, 'Doa tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Success', formatDoaRow(item));
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
