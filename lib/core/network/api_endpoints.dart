class ApiEndpoints {
  // Base URLs
  // Default to local/dev or Cloudflare Worker domain via compile-time environment variable
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://marbot-api.ginteknologi.workers.dev/api/v1',
    // defaultValue: 'http://192.168.1.10:8787/api/v1',
  );

  static const String mediaBaseUrl = String.fromEnvironment(
    'MEDIA_BASE_URL',
    defaultValue: 'https://cdn.masjidannimah.id',
  );

  // Auth & Profile
  static const String profile = '/profile';
  static const String fcm = '/fcm';
  static const String fcmSet = '/fcm/set';
  static const String account = '/akun';

  // Jadwal Shalat & Waktu
  static const String waktuSolat = '/waktusolat';
  static const String waktuSolatKalender = '/waktusolat/kalender';

  // Al-Qur'an
  static const String quranSurah = '/quran/surah';
  static const String quranDetail = '/quran/surah'; // + /:id
  static const String quranRandom = '/quran/random-surah';
  static const String quranJuz = '/quran/juz'; // + /:id — mushaf page images

  // Doa & Dzikir
  static const String doaCategory = '/doa/category';
  static const String doaList = '/doa/list'; // + /:category
  static const String doaDetail = '/doa/detail'; // + /:id
  static const String dzikir = '/doa/dzikir';

  // Hadits
  static const String hadits = '/hadits';
  static const String haditsBab = '/hadits/bab'; // + /:namaTabel
  static const String haditsDetail = '/hadits/detail'; // + /:namaTabel
  static const String haditsSearch = '/hadits/search';
  static const String haditsTema = '/hadits/tema'; // + /:id

  // Artikel
  static const String artikel = '/artikel';
  static const String artikelTerbaru = '/artikel/terbaru';

  // Transaksi
  static const String transaksiHistory = '/transaksi/history'; // + /:email

  // Notif & Events
  static const String notif = '/notif';
  static const String event = '/event';
}
