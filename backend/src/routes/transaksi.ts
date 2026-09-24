import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const transaksi = new Hono<{ Bindings: Env }>();

// GET /api/v1/transaksi/list_payment
transaksi.get('/list_payment', (c) => {
  const data = {
    ewallet: [
      {
        _id: 'qris',
        data: {
          name: 'QRIS (GoPay, OVO, Dana, LinkAja)',
          img: 'https://cdn.masjidannimah.id/icons/qris.png',
        },
      },
    ],
    bank: [
      {
        _id: 'bca_va',
        data: {
          name: 'BCA Virtual Account',
          img: 'https://cdn.masjidannimah.id/icons/bca.png',
        },
      },
      {
        _id: 'mandiri_va',
        data: {
          name: 'Mandiri Virtual Account',
          img: 'https://cdn.masjidannimah.id/icons/mandiri.png',
        },
      },
      {
        _id: 'bsi_va',
        data: {
          name: 'BSI Virtual Account',
          img: 'https://cdn.masjidannimah.id/icons/bsi.png',
        },
      },
    ],
  };

  return apiResponse(c, 200, true, 'berhasil', data);
});

// POST /api/v1/transaksi/order
transaksi.post('/order', async (c) => {
  try {
    const body = await c.req.json();
    const invoice = 'INV-MA-' + Math.random().toString(36).substring(2, 9).toUpperCase();
    const nominal = parseInt(body.nominal, 10) || 10000;
    const campaignId = parseInt(body.id_campaign, 10) || 1;
    const name = body.name || 'Hamba Allah';
    const email = body.email || '';
    const phone = body.phone || '';
    const pesan = body.pesan || '';
    const anonim = body.anonim ? 1 : 0;
    const paymentMethod = body.paymentMethod || 'qris';

    // VA or QR generation simulation
    let vaNumber = '';
    let qrString = '';
    if (paymentMethod.includes('va')) {
      const bankCode = paymentMethod.includes('bca') ? '8277' : paymentMethod.includes('mandiri') ? '8890' : '9988';
      vaNumber = bankCode + Math.floor(10000000 + Math.random() * 90000000).toString();
    } else {
      qrString = `00020101021226670016ID.CO.MASJID.WWW01189360000201112233440215${invoice}5204581253033605405${nominal}5802ID5915MASJID AN-NIMAH6007CIBUBUR6304ABCD`;
    }

    const expiredAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString();

    await c.env.DB.prepare(`
      INSERT INTO transaksi_sedekah (
        invoice, campaign_id, user_email, nama_donatur, nomor_hp, nominal, pesan, anonim, metode_pembayaran, status, payment_url, va_number, qr_string
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', ?, ?, ?)
    `).bind(
      invoice,
      campaignId,
      email,
      name,
      phone,
      nominal,
      pesan,
      anonim,
      paymentMethod,
      `https://marbot.masjidannimah.id/pay/${invoice}`,
      vaNumber,
      qrString
    ).run();

    const resultData = {
      invoice,
      nominal,
      status: 'pending',
      payment_url: `https://marbot.masjidannimah.id/pay/${invoice}`,
      qr_code: qrString,
      va_number: vaNumber,
      expired_at: expiredAt,
    };

    return apiResponse(c, 200, true, 'Pesanan donasi berhasil dibuat', resultData);
  } catch (e: any) {
    return apiResponse(c, 400, false, 'Gagal membuat pesanan donasi', null);
  }
});

// GET /api/v1/transaksi/order
transaksi.get('/order', async (c) => {
  try {
    const { results } = await c.env.DB.prepare('SELECT * FROM transaksi_sedekah ORDER BY id DESC LIMIT 50').all();
    return apiResponse(c, 200, true, 'Daftar transaksi', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Daftar transaksi', []);
  }
});

// GET /api/v1/transaksi/detail/:invoice
transaksi.get('/detail/:invoice', async (c) => {
  const invoice = c.req.param('invoice');
  try {
    const item = await c.env.DB.prepare('SELECT * FROM transaksi_sedekah WHERE invoice = ? OR id = ?')
      .bind(invoice, invoice)
      .first();

    if (!item) return apiResponse(c, 404, false, 'Invoice tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Detail transaksi', item);
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Invoice tidak ditemukan', null);
  }
});

// GET /api/v1/transaksi/detail/invoice/:invoice
transaksi.get('/detail/invoice/:invoice', async (c) => {
  const invoice = c.req.param('invoice');
  try {
    const item = await c.env.DB.prepare('SELECT * FROM transaksi_sedekah WHERE invoice = ?').bind(invoice).first();
    if (!item) return apiResponse(c, 404, false, 'Invoice tidak ditemukan', null);
    return apiResponse(c, 200, true, 'Detail invoice', item);
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Invoice tidak ditemukan', null);
  }
});

// GET /api/v1/transaksi/history/:email
transaksi.get('/history/:email', async (c) => {
  const email = c.req.param('email');
  try {
    const { results } = await c.env.DB.prepare(`
      SELECT t.*, c.judul as campaign_judul, c.thumbnail as campaign_image
      FROM transaksi_sedekah t
      LEFT JOIN campaign_sedekah c ON t.campaign_id = c.id
      WHERE t.user_email = ?
      ORDER BY t.id DESC
    `).bind(email).all();

    const sumResult: any = await c.env.DB.prepare(`
      SELECT SUM(nominal) as total FROM transaksi_sedekah WHERE user_email = ? AND status = 'paid'
    `).bind(email).first();

    const total = sumResult?.total || 0;

    return apiResponse(c, 200, true, 'Riwayat sedekah', {
      history: results || [],
      total_sedekah: total,
    });
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Riwayat sedekah', {
      history: [],
      total_sedekah: 0,
    });
  }
});

// POST /api/v1/transaksi/response (Webhook update status)
transaksi.post('/response', async (c) => {
  try {
    const body = await c.req.json();
    const invoice = body.invoice || body.order_id;
    const status = body.status || 'paid';

    if (!invoice) return apiResponse(c, 400, false, 'Invoice wajib diisi', null);

    await c.env.DB.prepare('UPDATE transaksi_sedekah SET status = ? WHERE invoice = ?').bind(status, invoice).run();
    return apiResponse(c, 200, true, 'Status transaksi berhasil diperbarui', { invoice, status });
  } catch (e: any) {
    return apiResponse(c, 400, false, 'Gagal memperbarui status transaksi', null);
  }
});

export default transaksi;
