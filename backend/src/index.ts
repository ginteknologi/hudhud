import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { Env } from './types/env';

// Import domain route modules
import waktusolatRouter from './routes/waktusolat';
import quranRouter from './routes/quran';
import doaRouter from './routes/doa';
import haditsRouter from './routes/hadits';
import artikelRouter from './routes/artikel';
import profileRouter from './routes/profile';
import extraRouter from './routes/extra';
import cmsDoaRouter from './routes/cms/doa';
import cmsArtikelRouter from './routes/cms/artikel';

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
    service: 'Hudhud Islamic App API',
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
api.route('/profile', profileRouter);
api.route('/', extraRouter); // /event, /notif, /fcm
api.route('/cms/doa', cmsDoaRouter);
api.route('/cms/artikel', cmsArtikelRouter);

// Media Streamer (Cloudflare R2 Bucket) — Mendukung path bertingkat seperti /media/files/xxx.png
app.get('/media/*', async (c) => {
  const path = c.req.path.replace(/^\/media\//, '');
  if (!path) return c.json({ code: 400, message: 'Key path media diperlukan' }, 400);

  if (!c.env.MEDIA_BUCKET) {
    return c.json({ code: 404, message: 'Bucket media tidak dikonfigurasi' }, 404);
  }
  try {
    const object = await c.env.MEDIA_BUCKET.get(path);
    if (!object) {
      return c.json({ code: 404, message: 'Media tidak ditemukan' }, 404);
    }
    const headers = new Headers();
    object.writeHttpMetadata(headers);
    headers.set('etag', object.httpEtag);
    headers.set('Cache-Control', 'public, max-age=31536000, immutable');

    // Fallback Content-Type jika belum ada di metadata
    if (!headers.get('content-type')) {
      if (path.endsWith('.png')) headers.set('content-type', 'image/png');
      else if (path.endsWith('.jpg') || path.endsWith('.jpeg')) headers.set('content-type', 'image/jpeg');
      else if (path.endsWith('.webp')) headers.set('content-type', 'image/webp');
      else if (path.endsWith('.svg')) headers.set('content-type', 'image/svg+xml');
    }

    return new Response(object.body, { headers });
  } catch (e) {
    return c.json({ code: 500, message: 'Gagal mengambil media' }, 500);
  }
});

// Register API v1 to Main App
app.route('/api/v1', api);

export default app;
