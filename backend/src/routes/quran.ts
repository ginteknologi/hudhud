import { Hono } from 'hono';
import { Env } from '../types/env';
import { apiResponse } from '../helpers/response';

const quran = new Hono<{ Bindings: Env }>();

// GET /api/v1/quran/surah
quran.get('/surah', async (c) => {
  const search = c.req.query('search') || '';
  try {
    let query = 'SELECT id, nama, asma, jumlah_ayat as ayat, tipe as type, arti FROM surah';
    let params: any[] = [];
    if (search) {
      query += ' WHERE nama LIKE ? OR arti LIKE ?';
      params.push(`%${search}%`, `%${search}%`);
    }
    query += ' ORDER BY id ASC';

    const stmt = c.env.DB.prepare(query);
    const { results } = params.length > 0 ? await stmt.bind(...params).all() : await stmt.all();
    return apiResponse(c, 200, true, 'Success', results || []);
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', []);
  }
});

// GET /api/v1/quran/surah/:id
quran.get('/surah/:id', async (c) => {
  const id = c.req.param('id');
  try {
    const surah = await c.env.DB.prepare('SELECT * FROM surah WHERE id = ?').bind(id).first();
    if (!surah) {
      return apiResponse(c, 404, false, 'Surah tidak ditemukan', null);
    }

    const { results: ayats } = await c.env.DB.prepare(
      'SELECT surah_id as surat, nomor_ayat as ayat, teks_arab as arab, teks_latin as latin_karakter, terjemahan, audio_url FROM ayat WHERE surah_id = ? ORDER BY nomor_ayat ASC'
    ).bind(id).all();

    const formattedAyats = (ayats || []).map((a: any) => ({
      surat: a.surat,
      ayat: a.ayat,
      arab: a.arab,
      latin_karakter: a.latin_karakter,
      arti: { text: a.terjemahan },
      audio: {
        'ar.alafasy':
          a.audio_url ||
          `https://cdn.islamic.network/quran/audio/128/ar.alafasy/${a.surat}${String(a.ayat).padStart(3, '0')}.mp3`,
      },
    }));

    return apiResponse(c, 200, true, 'Success', {
      ...surah,
      list: formattedAyats,
    });
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Surah tidak ditemukan', null);
  }
});

// GET /api/v1/quran/surah/:id/:ayah
quran.get('/surah/:id/:ayah', async (c) => {
  const surahId = c.req.param('id');
  const ayahNum = c.req.param('ayah');
  try {
    const ayat = await c.env.DB.prepare(
      'SELECT surah_id as surat, nomor_ayat as ayat, teks_arab as arab, teks_latin as latin_karakter, terjemahan, audio_url FROM ayat WHERE surah_id = ? AND nomor_ayat = ?'
    ).bind(surahId, ayahNum).first();

    if (!ayat) {
      return apiResponse(c, 404, false, 'Ayat tidak ditemukan', null);
    }

    return apiResponse(c, 200, true, 'Success', {
      ...ayat,
      arti: { text: (ayat as any).terjemahan },
      audio: {
        'ar.alafasy':
          (ayat as any).audio_url ||
          `https://cdn.islamic.network/quran/audio/128/ar.alafasy/${surahId}${String(ayahNum).padStart(3, '0')}.mp3`,
      },
    });
  } catch (e: any) {
    return apiResponse(c, 404, false, 'Ayat tidak ditemukan', null);
  }
});

// GET /api/v1/quran/random-surah
quran.get('/random-surah', async (c) => {
  try {
    const randomAyat = await c.env.DB.prepare(`
      SELECT s.nama as surat, a.nomor_ayat, a.teks_arab as arab, a.terjemahan as indonesia
      FROM ayat a
      JOIN surah s ON a.surah_id = s.id
      ORDER BY RANDOM() LIMIT 1
    `).first();

    if (randomAyat) {
      return apiResponse(c, 200, true, 'Success', randomAyat);
    }

    return apiResponse(c, 200, true, 'Success', {
      surat: 'Al-Fatihah',
      nomor_ayat: 1,
      arab: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      indonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
    });
  } catch (e: any) {
    return apiResponse(c, 200, true, 'Success', {
      surat: 'Al-Fatihah',
      nomor_ayat: 1,
      arab: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      indonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
    });
  }
});

// GET /api/v1/quran/juz/:juz
quran.get('/juz/:juz', async (c) => {
  const juz = parseInt(c.req.param('juz'), 10);
  return apiResponse(c, 200, true, 'Success', {
    juz,
    message: `Data juz ${juz}`,
  });
});

export default quran;
