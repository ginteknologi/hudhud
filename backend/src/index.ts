import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { Env } from './types/env';

// Import domain route modules
import waktusolatRouter from './routes/waktusolat';
import quranRouter from './routes/quran';
import doaRouter from './routes/doa';
import haditsRouter from './routes/hadits';
import artikelRouter from './routes/artikel';
import kajianRouter from './routes/kajian';
import sedekahRouter from './routes/sedekah';
import transaksiRouter from './routes/transaksi';
import ruanganRouter from './routes/ruangan';
import profileRouter from './routes/profile';
import extraRouter from './routes/extra';

const app = new Hono<{ Bindings: Env }>();

// Enable Global CORS
app.use(
  '/*',
  cors({
    origin: '*',
    allowHeaders: ['Content-Type', 'Authorization'],
    allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  })
);

// Root Healthcheck
app.get('/', (c) => {
  return c.json({
    status: 'online',
    service: 'Masjid An-Ni’mah API (Marbot)',
    engine: 'Cloudflare Workers (Edge Serverless)',
    version: '2.0.0',
    database: 'Cloudflare D1 SQLite',
  });
});

// Create API v1 sub-router
const api = new Hono<{ Bindings: Env }>();

// Mount all modular routes
api.route('/waktusolat', waktusolatRouter);
api.route('/quran', quranRouter);
api.route('/doa', doaRouter);
api.route('/hadits', haditsRouter);
api.route('/artikel', artikelRouter);
api.route('/kajian', kajianRouter);
api.route('/', sedekahRouter); // /campaign, /sedekah, /penyalur_campaign
api.route('/transaksi', transaksiRouter);
api.route('/ruangan', ruanganRouter);
api.route('/profile', profileRouter);
api.route('/', extraRouter); // /dkm, /sosmed, /event, /kartu-ucapan, /live, /notif, /fcm, /home

// Media Streamer (Cloudflare R2 Bucket)
api.get('/media/:key', async (c) => {
  const key = c.req.param('key');
  if (!c.env.MEDIA_BUCKET) {
    return c.json({ code: 404, message: 'Bucket media tidak dikonfigurasi' }, 404);
  }
  try {
    const object = await c.env.MEDIA_BUCKET.get(key);
    if (!object) {
      return c.json({ code: 404, message: 'Media tidak ditemukan' }, 404);
    }
    const headers = new Headers();
    object.writeHttpMetadata(headers);
    headers.set('etag', object.httpEtag);
    headers.set('Cache-Control', 'public, max-age=31536000, immutable');
    return new Response(object.body, { headers });
  } catch (e) {
    return c.json({ code: 500, message: 'Gagal mengambil media' }, 500);
  }
});

// Register API v1 to Main App
app.route('/api/v1', api);

export default app;
