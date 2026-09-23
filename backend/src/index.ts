import { Hono } from 'hono';
import { cors } from 'hono/cors';

export type Env = {
  DB: D1Database;
  MEDIA_BUCKET: R2Bucket;
  ENVIRONMENT: string;
};

const app = new Hono<{ Bindings: Env }>();

// Enable CORS
app.use('/*', cors({
  origin: '*',
  allowHeaders: ['Content-Type', 'Authorization'],
  allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
}));

// Root Healthcheck
app.get('/', (c) => {
  return c.json({
    status: 'online',
    service: 'Masjid An-Nimah API',
    engine: 'Cloudflare Workers (Edge)',
    database: 'Cloudflare D1',
    storage: 'Cloudflare R2',
  });
});

const api = new Hono<{ Bindings: Env }>();

// ==========================================
// 1. WAKTU SOLAT
// ==========================================
api.get('/waktusolat', async (c) => {
  // If database has today's schedule, return it; otherwise return default calculation
  const today = new Date().toISOString().split('T')[0];
  try {
    const row = await c.env.DB.prepare(
      'SELECT * FROM jadwal_shalat WHERE tanggal = ?'
    ).bind(today).first();

    if (row) {
      return c.json({
        code: 200,
        message: 'Jadwal shalat hari ini',
        data: row,
      });
    }
  } catch (e) {
    // fallback
  }

  // Standard fallback coordinates for Masjid An-Ni'mah Cibubur
  return c.json({
    code: 200,
    message: 'Jadwal shalat default Cibubur',
    data: {
      fajr: '04:36',
      imsak: '04:26',
      dhuhr: '11:57',
      asr: '15:10',
      maghrib: '17:59',
      isha: '19:08',
      sunset: '17:59',
      date: today,
    },
  });
});

// ==========================================
// 2. PROFILE & AUTH
// ==========================================
api.post('/profile', async (c) => {
  const body = await c.req.json();
  const { name, email, photo } = body;

  if (!email) {
    return c.json({ code: 400, message: 'Email wajib diisi' }, 400);
  }

  try {
    // Upsert user in D1
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

    return c.json({
      code: 200,
      message: 'Profil berhasil diperbarui',
      data: user,
    });
  } catch (err: any) {
    return c.json({
      code: 200,
      message: 'Profil tamu',
      data: { id: 1, nama: name || 'Tamu', email, photo: photo || '', total_sedekah: 0 },
    });
  }
});

// ==========================================
// 3. AL-QURAN
// ==========================================
api.get('/quran/surah', async (c) => {
  const search = c.req.query('search') || '';
  try {
    let query = 'SELECT id, nama, asma, jumlah_ayat as ayat, tipe as type, arti FROM surah';
    if (search) {
      query += ` WHERE nama LIKE '%${search}%' OR arti LIKE '%${search}%'`;
    }
    query += ' ORDER BY id ASC';
    const { results } = await c.env.DB.prepare(query).all();
    return c.json({ code: 200, message: 'Daftar surah', data: results });
  } catch (e) {
    return c.json({ code: 200, message: 'Daftar surah', data: [] });
  }
});

api.get('/quran/surah/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const surah = await c.env.DB.prepare('SELECT * FROM surah WHERE id = ?').bind(id).first();
    const { results: ayats } = await c.env.DB.prepare(
      'SELECT surah_id as surat, nomor_ayat as ayat, teks_arab as arab, teks_latin as latin_karakter, terjemahan, audio_url FROM ayat WHERE surah_id = ? ORDER BY nomor_ayat ASC'
    ).bind(id).all();

    const formattedAyats = ayats.map((a: any) => ({
      surat: a.surat,
      ayat: a.ayat,
      arab: a.arab,
      latin_karakter: a.latin_karakter,
      arti: { text: a.terjemahan },
      audio: { 'ar.alafasy': a.audio_url || `https://cdn.islamic.network/quran/audio/128/ar.alafasy/${a.surat}${String(a.ayat).padStart(3, '0')}.mp3` },
    }));

    return c.json({
      code: 200,
      message: 'Detail surah',
      data: {
        ...surah,
        list: formattedAyats,
      },
    });
  } catch (e) {
    return c.json({ code: 404, message: 'Surah tidak ditemukan' }, 404);
  }
});

api.get('/quran/random-surah', async (c) => {
  try {
    const surah = await c.env.DB.prepare(
      'SELECT id, nama, asma, jumlah_ayat as ayat, tipe as type, arti FROM surah ORDER BY RANDOM() LIMIT 1'
    ).first();
    return c.json({ code: 200, message: 'Random surah', data: surah });
  } catch (e) {
    return c.json({ code: 200, message: 'Random surah', data: { id: 1, nama: 'Al-Fatihah', ayat: 7 } });
  }
});

// ==========================================
// 4. DOA & DZIKIR
// ==========================================
api.get('/doa/category', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM doa_kategori ORDER BY id ASC').all();
    return c.json({ code: 200, message: 'Kategori doa', data: results });
  } catch (e) {
    return c.json({ code: 200, message: 'Kategori doa', data: [] });
  }
});

api.get('/doa/list/:category', async (c) => {
  const categoryId = c.req.param('category');
  const search = c.req.query('search') || '';
  try {
    let query = 'SELECT * FROM doa WHERE kategori_id = ?';
    if (search) {
      query += ` AND (judul LIKE '%${search}%' OR terjemahan LIKE '%${search}%')`;
    }
    const { results } = await c.env.DB.prepare(query).bind(categoryId).all();
    return c.json({ code: 200, message: 'List doa', data: results });
  } catch (e) {
    return c.json({ code: 200, message: 'List doa', data: [] });
  }
});

api.get('/doa/detail/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const item = await c.env.DB.prepare('SELECT * FROM doa WHERE id = ?').bind(id).first();
    return c.json({ code: 200, message: 'Detail doa', data: item });
  } catch (e) {
    return c.json({ code: 404, message: 'Doa tidak ditemukan' }, 404);
  }
});

api.get('/doa/dzikir', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM dzikir ORDER BY id ASC').all();
    return c.json({ code: 200, message: 'List dzikir', data: results });
  } catch (e) {
    return c.json({ code: 200, message: 'List dzikir', data: [] });
  }
});

// ==========================================
// 5. KAJIAN & ARTIKEL
// ==========================================
api.get('/kajian/list', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(
      "SELECT id, judul, ustadz, deskripsi as subjudul, thumbnail as image, video_link as link, tipe FROM kajian WHERE tipe != 'muadzin' ORDER BY id DESC"
    ).all();
    return c.json({ code: 200, message: 'Daftar kajian', data: results });
  } catch (e) {
    return c.json({ code: 200, message: 'Daftar kajian', data: [] });
  }
});

api.get('/kajian/slider', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(
      "SELECT id, judul, ustadz, deskripsi as subjudul, thumbnail as image, video_link as link FROM kajian WHERE tipe = 'slider' ORDER BY id DESC LIMIT 5"
    ).all();
    return c.json({ code: 200, message: 'Slider kajian', data: results });
  } catch (e) {
    return c.json({ code: 200, message: 'Slider kajian', data: [] });
  }
});

api.get('/kajian/muadzin/list', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(
      "SELECT id, judul, ustadz, deskripsi as subjudul, thumbnail as image, video_link as link FROM kajian WHERE tipe = 'muadzin' ORDER BY id DESC"
    ).all();
    return c.json({ code: 200, message: 'Sahabat Muadzin', data: results });
  } catch (e) {
    return c.json({ code: 200, message: 'Sahabat Muadzin', data: [] });
  }
});

api.get('/artikel/terbaru', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(
      'SELECT id, judul, slug, konten, thumbnail, created_at FROM artikel ORDER BY id DESC LIMIT 5'
    ).all();
    return c.json({ code: 200, message: 'Artikel terbaru', data: results });
  } catch (e) {
    return c.json({ code: 200, message: 'Artikel terbaru', data: [] });
  }
});

// ==========================================
// 6. SEDEKAH & TRANSAKSI
// ==========================================
api.get('/campaign', async (c) => {
  try {
    const { results } = await c.env.DB.prepare(
      "SELECT id, judul as title, deskripsi as description, target_nominal, terkumpul_nominal, thumbnail as image, end_date FROM campaign_sedekah WHERE status = 'aktif' ORDER BY id DESC"
    ).all();
    return c.json({ code: 200, message: 'Daftar campaign', data: results });
  } catch (e) {
    return c.json({ code: 200, message: 'Daftar campaign', data: [] });
  }
});

api.get('/campaign/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const item = await c.env.DB.prepare(
      'SELECT id, judul as title, deskripsi as description, target_nominal, terkumpul_nominal, thumbnail as image, end_date FROM campaign_sedekah WHERE id = ?'
    ).bind(id).first();
    return c.json({ code: 200, message: 'Detail campaign', data: item });
  } catch (e) {
    return c.json({ code: 404, message: 'Campaign tidak ditemukan' }, 404);
  }
});

api.get('/transaksi/list_payment', (c) => {
  return c.json({
    code: 200,
    message: 'Metode pembayaran',
    data: [
      { id: 'qris', name: 'QRIS (Gopay, OVO, Dana, ShopeePay)', code: 'qris', logo: 'assets/icons/qris.png', category: 'qris' },
      { id: 'bca_va', name: 'BCA Virtual Account', code: 'bca', logo: 'assets/icons/bca.png', category: 'va' },
      { id: 'mandiri_va', name: 'Mandiri Virtual Account', code: 'mandiri', logo: 'assets/icons/mandiri.png', category: 'va' },
      { id: 'bsi_va', name: 'BSI Virtual Account', code: 'bsi', logo: 'assets/icons/bsi.png', category: 'va' },
    ],
  });
});

api.post('/transaksi/order', async (c) => {
  const body = await c.req.json();
  const invoice = 'INV-NI-' + Date.now().toString(36).toUpperCase();

  try {
    await c.env.DB.prepare(`
      INSERT INTO transaksi_sedekah (
        invoice, campaign_id, user_email, nama_donatur, nomor_hp, nominal, pesan, anonim, metode_pembayaran, status
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')
    `).bind(
      invoice,
      body.id_campaign || 1,
      body.email || '',
      body.name || 'Hamba Allah',
      body.phone || '',
      body.nominal || 10000,
      body.pesan || '',
      body.anonim ? 1 : 0,
      body.paymentMethod || 'qris'
    ).run();

    return c.json({
      success: true,
      code: 200,
      message: 'Pesanan donasi dibuat',
      data: {
        invoice,
        nominal: body.nominal,
        status: 'pending',
        payment_url: `https://app.midtrans.com/snap/v2/vtweb/${invoice}`,
      },
    });
  } catch (e: any) {
    return c.json({
      success: true,
      code: 200,
      message: 'Pesanan donasi dibuat',
      data: { invoice, nominal: body.nominal, status: 'pending' },
    });
  }
});

api.get('/transaksi/detail/:invoice', async (c) => {
  const invoice = c.req.param('invoice');
  try {
    const item = await c.env.DB.prepare('SELECT * FROM transaksi_sedekah WHERE invoice = ?').bind(invoice).first();
    return c.json({ code: 200, message: 'Detail invoice', data: item });
  } catch (e) {
    return c.json({ code: 404, message: 'Invoice tidak ditemukan' }, 404);
  }
});

// ==========================================
// 7. R2 MEDIA HANDLER (Streaming / Upload)
// ==========================================
api.get('/media/:key', async (c) => {
  const key = c.req.param('key');
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

app.route('/api/v1', api);

export default app;
