import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const profile = new Hono<{ Bindings: Env }>();

// GET /api/v1/profile
profile.get('/', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT id, name as nama, email, photo, total_sedekah FROM users').all();
    return apiResponse(c, 200, true, 'Daftar pengguna', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Daftar pengguna', []);
  }
});

// GET /api/v1/profile/:id
profile.get('/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const user = await c.env.DB.prepare(
      'SELECT id, name as nama, email, photo, total_sedekah FROM users WHERE id = ? OR email = ?'
    ).bind(id, id).first();

    if (!user) return apiResponse(c, 404, false, 'Pengguna tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Profil pengguna', user);
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Pengguna tidak ditemukan', null);
  }
});

// POST /api/v1/profile
profile.post('/', async (c) => {
  try {
    const body = await c.req.json();
    const { name, email, photo } = body;

    if (!email) {
      return apiResponse(c, 400, false, 'Email wajib diisi', null);
    }

    await c.env.DB.prepare(`
      INSERT INTO users (name, email, photo)
      VALUES (?, ?, ?)
      ON CONFLICT(email) DO UPDATE SET
        name = excluded.name,
        photo = excluded.photo,
        updated_at = CURRENT_TIMESTAMP
    `).bind(name || 'Pengguna', email, photo || '').run();

    const user = await c.env.DB.prepare(
      'SELECT id, name as nama, email, photo, total_sedekah FROM users WHERE email = ?'
    ).bind(email).first();

    return apiResponse(c, 200, true, 'Profil berhasil diperbarui', user);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Profil tamu', {
      id: 1,
      nama: 'Jamaah',
      email: 'jamaah@annimah.id',
      photo: '',
      total_sedekah: 0,
    });
  }
});

export default profile;
