import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const extra = new Hono<{ Bindings: Env }>();

// GET /api/v1/event
extra.get('/event', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM event ORDER BY tanggal_event ASC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/notif/:id
extra.get('/notif/:id', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM notifikasi ORDER BY id DESC LIMIT 20').all();
    return apiResponse(c, 200, true, 'Daftar notifikasi', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Daftar notifikasi', []);
  }
});

// GET /api/v1/notif/detail/:id
extra.get('/notif/detail/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const item = await c.env.DB.prepare('SELECT * FROM notifikasi WHERE id = ?').bind(id).first();
    if (!item) return apiResponse(c, 404, false, 'Notifikasi tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Detail notifikasi', item);
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Notifikasi tidak ditemukan', null);
  }
});

// POST /api/v1/fcm and /api/v1/fcm/set
const handleFcm = async (c: any) => {
  try {
    const body = await c.req.json();
    const token = body.token || body.fcm_token;
    if (token) {
      await c.env.DB.prepare(
        'INSERT INTO fcm_tokens (token, device_type) VALUES (?, ?) ON CONFLICT(token) DO NOTHING'
      ).bind(token, body.device_type || 'android').run();
    }
    return apiResponse(c, 200, true, 'FCM token berhasil disimpan', { token });
  } catch (e: any) {
    return apiResponse(c, 200, true, 'FCM token diterima', null);
  }
};
extra.post('/fcm', handleFcm);
extra.post('/fcm/set', handleFcm);

export default extra;
