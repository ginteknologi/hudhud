import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const hadits = new Hono<{ Bindings: Env }>();

// ============================================================
// GET /api/v1/hadits
// Daftar semua imam/perawi
// ============================================================
hadits.get('/', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(
      'SELECT imamId, imamSorting, hadits, longNama, namaTabel FROM had_imam ORDER BY imamSorting ASC'
    ).all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 500, false, e.message, []);
  }
});

// ============================================================
// GET /api/v1/hadits/detail/:namaTabel?page=1&limit=20
// Daftar hadits dengan pagination
// Arbain: langsung semua (42 hadits, tidak perlu pagination)
// ============================================================
hadits.get('/detail/:id', async (c) => {
  const table = c.req.param('id');
  const page  = Math.max(1, parseInt(c.req.query('page')  || '1',  10));
  const limit = Math.min(100, Math.max(1, parseInt(c.req.query('limit') || '20', 10)));
  const offset = (page - 1) * limit;

  try {
    if (table === 'arbain') {
      // Arbain: kembalikan semua (42 hadits)
      const { results } = await c.env.DB.prepare(
        'SELECT NoHdt, Isi_Arab, Isi_Indonesia FROM hadits_arbain ORDER BY NoHdt ASC'
      ).all();
      return apiResponse(c, 200, true, 'Success', results || []);
    }

    // 9 Imam: pagination
    const [{ total }] = (await c.env.DB.prepare(
      'SELECT COUNT(*) as total FROM hadits_konten WHERE namaTabel = ?'
    ).bind(table).all()).results as any[];

    const { results } = await c.env.DB.prepare(
      'SELECT NoHdt, Isi_Arab, Isi_Indonesia FROM hadits_konten WHERE namaTabel = ? ORDER BY NoHdt ASC LIMIT ? OFFSET ?'
    ).bind(table, limit, offset).all();

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
// GET /api/v1/hadits/detail/bab/:namaTabel?kitab=1
// DEPRECATED — dijaga untuk backward compatibility
// Arahkan ke endpoint pagination
// ============================================================
hadits.get('/detail/bab/:id', async (c) => {
  return apiResponse(c, 200, true, 'Deprecated. Gunakan /detail/:namaTabel?page=1', []);
});

// ============================================================
// GET /api/v1/hadits/detail/bab/content/:namaTabel?ID_Kitab=&ID_Bab=
// DEPRECATED — dijaga untuk backward compatibility
// ============================================================
hadits.get('/detail/bab/content/:id', async (c) => {
  return apiResponse(c, 200, true, 'Deprecated. Gunakan /detail/:namaTabel?page=1', []);
});

export default hadits;
