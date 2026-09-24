import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const extra = new Hono<{ Bindings: Env }>();

// GET /api/v1/dkm
extra.get('/dkm', async (c) => {
  try {
    // In Flutter, dkmKontakProvider queries ApiEndpoints.dkm and maps to SosmedData.
    // If table sosmed has data, return sosmed, otherwise return dkm
    const { results: sosmedList } = await c.env.DB.prepare('SELECT id, nama, type, icon, link FROM sosmed').all();
    if (sosmedList && sosmedList.length > 0) {
      return apiResponse(c, 200, true, 'Success', sosmedList);
    }
    const { results } = await c.env.DB.prepare('SELECT * FROM dkm ORDER BY urutan ASC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/sosmed
extra.get('/sosmed', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT id, nama, type, icon, link FROM sosmed').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/event
extra.get('/event', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM event ORDER BY tanggal_event ASC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/kartu-ucapan
extra.get('/kartu-ucapan', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM kartu_ucapan ORDER BY id DESC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/live
extra.get('/live', async (c) => {
  try {
    const item = await c.env.DB.prepare("SELECT * FROM kajian WHERE tipe = 'live' ORDER BY id DESC").first();
    return apiResponse(c, 200, true, 'Status live', item || { is_live: false, message: 'Tidak ada siaran langsung' });
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Status live', { is_live: false });
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

// GET /api/v1/home (Dashboard aggregator)
extra.get('/home', async (c) => {
  try {
    const artikel = await c.env.DB.prepare(
      'SELECT id, judul, konten as isi, thumbnail as image, created_at FROM artikel ORDER BY id DESC LIMIT 1'
    ).first();

    const doa = await c.env.DB.prepare(
      'SELECT id, judul, terjemahan as isi, teks_arab, riwayat FROM doa ORDER BY RANDOM() LIMIT 1'
    ).first();

    const campaign = await c.env.DB.prepare(
      "SELECT id, judul, target_nominal, terkumpul_nominal, thumbnail as image FROM campaign_sedekah WHERE status = 'aktif' ORDER BY id DESC LIMIT 1"
    ).first();

    return apiResponse(c, 200, true, 'Success', {
      artikel: artikel || {},
      doa: doa || {},
      campaign: campaign || {},
    });
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', {
      artikel: {},
      doa: {},
      campaign: {},
    });
  }
});

export default extra;
