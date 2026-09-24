import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const ruangan = new Hono<{ Bindings: Env }>();

// GET /api/v1/ruangan
ruangan.get('/', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM ruangan ORDER BY id ASC').all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/ruangan/booking
ruangan.get('/booking', async (c) => {
  const tanggal = c.req.query('tanggal');
  const bulan = c.req.query('bulan');
  const tahun = c.req.query('tahun');

  try {
    let query = 'SELECT * FROM booking_ruangan';
    const params: any[] = [];

    if (tanggal && bulan && tahun) {
      const formattedDate = `${tahun}-${String(bulan).padStart(2, '0')}-${String(tanggal).padStart(2, '0')}`;
      query += ' WHERE tanggal_mulai <= ? AND tanggal_selesai >= ?';
      params.push(formattedDate, formattedDate);
    }
    query += ' ORDER BY id DESC';

    const stmt = c.env.DB.prepare(query);
    const { results } = params.length > 0 ? await stmt.bind(...params).all() : await stmt.all();

    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/ruangan/:id
ruangan.get('/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const item = await c.env.DB.prepare('SELECT * FROM ruangan WHERE id = ?').bind(id).first();
    if (!item) return apiResponse(c, 404, false, 'Ruangan tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Success', item);
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Ruangan tidak ditemukan', null);
  }
});

// POST /api/v1/ruangan/booking
ruangan.post('/booking', async (c) => {
  try {
    const body = await c.req.json();
    const namaPemohon = body.nama_pemesan || body.nama_pemohon || 'Pemohon';
    const kontak = body.kontak_pemesan || body.kontak || '';
    const keperluan = body.nama_kegiatan || body.keperluan || 'Kegiatan';
    const tanggal = body.tanggal || new Date().toISOString().split('T')[0];
    const ruanganId = body.ruangan_id || 1;

    await c.env.DB.prepare(`
      INSERT INTO booking_ruangan (
        ruangan_id, nama_pemohon, kontak, tanggal_mulai, tanggal_selesai, keperluan, status
      ) VALUES (?, ?, ?, ?, ?, ?, 'pending')
    `).bind(ruanganId, namaPemohon, kontak, tanggal, tanggal, keperluan).run();

    return apiResponse(c, 200, true, 'Pengajuan booking ruangan berhasil dibuat', {
      success: true,
      message: 'Booking berhasil diajukan',
    });
  } catch (e: any) {
    return apiResponse(c, 400, false, 'Gagal membuat pengajuan booking', null);
  }
});

export default ruangan;
