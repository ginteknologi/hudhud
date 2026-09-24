import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const hadits = new Hono<{ Bindings: Env }>();

// GET /api/v1/hadits
hadits.get('/', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(
      'SELECT imamId, imamSorting, hadits, longNama, namaTabel FROM had_imam ORDER BY imamSorting ASC'
    ).all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/hadits/detail/:id
hadits.get('/detail/:id', async (c) => {
  const table = c.req.param('id');
  try {
    if (table === 'arbain') {
      const { results } = await c.env.DB.prepare(
        'SELECT NoHdt, ID_Kitab, Kitab_Indonesia, Isi_Arab, Isi_Indonesia FROM hadits_arbain ORDER BY NoHdt ASC'
      ).all();
      return apiResponse(c, 200, true, 'Success', results || []);
    } else {
      const { results } = await c.env.DB.prepare(
        'SELECT ID_Kitab, Kitab_Indonesia, Kitab_Arab, total_hadits as NoHdt FROM hadits_kitab WHERE namaTabel = ? ORDER BY ID_Kitab ASC'
      ).bind(table).all();
      return apiResponse(c, 200, true, 'Success', results || []);
    }
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/hadits/detail/bab/:id?kitab=:idKitab
hadits.get('/detail/bab/:id', async (c) => {
  const table = c.req.param('id');
  const kitab = c.req.query('kitab') || '1';
  try {
    if (table === 'arbain') {
      const { results } = await c.env.DB.prepare(
        'SELECT ID_Bab, ID_Kitab, Bab_Indonesia, Bab_Arab FROM hadits_bab WHERE namaTabel = ? ORDER BY ID_Bab ASC'
      ).bind('arbain').all();
      return apiResponse(c, 200, true, 'Success', results || []);
    } else {
      const { results } = await c.env.DB.prepare(
        'SELECT ID_Bab, ID_Kitab, Bab_Indonesia, Bab_Arab FROM hadits_bab WHERE namaTabel = ? AND ID_Kitab = ? ORDER BY ID_Bab ASC'
      ).bind(table, kitab).all();
      return apiResponse(c, 200, true, 'Success', results || []);
    }
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/hadits/detail/bab/content/:id?ID_Kitab=&ID_Bab=
hadits.get('/detail/bab/content/:id', async (c) => {
  const table = c.req.param('id');
  const idKitab = c.req.query('ID_Kitab');
  const idBab = c.req.query('ID_Bab');

  try {
    if (table === 'arbain') {
      let query = 'SELECT NoHdt, ID_Bab, ID_Kitab, Isi_Arab, Isi_Indonesia FROM hadits_arbain';
      const params: any[] = [];
      if (idBab && idBab !== 'null') {
        query += ' WHERE ID_Bab = ?';
        params.push(parseInt(idBab, 10));
      }
      query += ' ORDER BY NoHdt ASC';

      const stmt = c.env.DB.prepare(query);
      const { results } = params.length > 0 ? await stmt.bind(...params).all() : await stmt.all();
      return apiResponse(c, 200, true, 'Success', results || []);
    } else {
      let query = 'SELECT NoHdt, ID_Bab, ID_Kitab, Isi_Arab, Isi_Indonesia FROM hadits_konten WHERE namaTabel = ?';
      const params: any[] = [table];

      if (idBab && idBab !== 'null') {
        query += ' AND ID_Bab = ?';
        params.push(parseInt(idBab, 10));
      } else if (idKitab && idKitab !== 'null') {
        query += ' AND ID_Kitab = ?';
        params.push(parseInt(idKitab, 10));
      }
      query += ' ORDER BY NoHdt ASC';

      const stmt = c.env.DB.prepare(query);
      const { results } = await stmt.bind(...params).all();
      return apiResponse(c, 200, true, 'Success', results || []);
    }
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

export default hadits;
