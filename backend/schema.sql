-- Cloudflare D1 SQLite Schema for Masjid An-Ni'mah (Marbot)

-- 1. Users & Auth
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    google_id TEXT UNIQUE,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    photo TEXT,
    total_sedekah INTEGER DEFAULT 0,
    role TEXT DEFAULT 'jamaah',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. FCM Tokens
CREATE TABLE IF NOT EXISTS fcm_tokens (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    token TEXT NOT NULL UNIQUE,
    device_type TEXT DEFAULT 'android',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Jadwal Shalat Cache
CREATE TABLE IF NOT EXISTS jadwal_shalat (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tanggal DATE NOT NULL UNIQUE,
    imsak TEXT NOT NULL,
    subuh TEXT NOT NULL,
    terbit TEXT NOT NULL,
    dzuhur TEXT NOT NULL,
    ashar TEXT NOT NULL,
    maghrib TEXT NOT NULL,
    isya TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 4. Al-Qur'an
CREATE TABLE IF NOT EXISTS surah (
    id INTEGER PRIMARY KEY,
    nama TEXT NOT NULL,
    asma TEXT NOT NULL,
    jumlah_ayat INTEGER NOT NULL,
    tipe TEXT NOT NULL, -- mekah / madinah
    arti TEXT,
    audio_url TEXT
);

CREATE TABLE IF NOT EXISTS ayat (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    surah_id INTEGER NOT NULL,
    nomor_ayat INTEGER NOT NULL,
    teks_arab TEXT NOT NULL,
    teks_latin TEXT,
    terjemahan TEXT NOT NULL,
    audio_url TEXT,
    FOREIGN KEY(surah_id) REFERENCES surah(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_ayat_surah ON ayat(surah_id, nomor_ayat);

-- 5. Doa & Dzikir
CREATE TABLE IF NOT EXISTS doa_kategori (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL,
    icon TEXT
);

CREATE TABLE IF NOT EXISTS doa (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kategori_id INTEGER,
    judul TEXT NOT NULL,
    teks_arab TEXT NOT NULL,
    teks_latin TEXT,
    terjemahan TEXT NOT NULL,
    riwayat TEXT,
    FOREIGN KEY(kategori_id) REFERENCES doa_kategori(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS dzikir (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    judul TEXT NOT NULL,
    teks_arab TEXT NOT NULL,
    terjemahan TEXT NOT NULL,
    target_count INTEGER DEFAULT 33,
    waktu TEXT DEFAULT 'solat' -- pagi, petang, solat
);

-- 6. Hadits
CREATE TABLE IF NOT EXISTS hadits_bab (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL,
    total_hadits INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS hadits_detail (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bab_id INTEGER NOT NULL,
    nomor INTEGER NOT NULL,
    judul TEXT NOT NULL,
    arab TEXT NOT NULL,
    arti TEXT NOT NULL,
    FOREIGN KEY(bab_id) REFERENCES hadits_bab(id) ON DELETE CASCADE
);

-- 7. Artikel & Berita
CREATE TABLE IF NOT EXISTS artikel (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    judul TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    konten TEXT NOT NULL,
    thumbnail TEXT,
    penulis TEXT DEFAULT 'DKM An-Ni’mah',
    dibaca INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 8. Jadwal Kajian & Video
CREATE TABLE IF NOT EXISTS kajian (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    judul TEXT NOT NULL,
    ustadz TEXT NOT NULL,
    deskripsi TEXT,
    thumbnail TEXT NOT NULL,
    video_link TEXT,
    tipe TEXT DEFAULT 'list', -- 'slider', 'list', 'live', 'muadzin'
    tanggal_waktu DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 9. Sedekah & Infaq (Fintech)
CREATE TABLE IF NOT EXISTS campaign_sedekah (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    judul TEXT NOT NULL,
    deskripsi TEXT,
    target_nominal INTEGER DEFAULT 0,
    terkumpul_nominal INTEGER DEFAULT 0,
    thumbnail TEXT NOT NULL,
    status TEXT DEFAULT 'aktif', -- 'aktif', 'selesai'
    end_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS transaksi_sedekah (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice TEXT NOT NULL UNIQUE,
    campaign_id INTEGER,
    user_email TEXT,
    nama_donatur TEXT NOT NULL,
    nomor_hp TEXT,
    nominal INTEGER NOT NULL,
    pesan TEXT,
    anonim BOOLEAN DEFAULT 0,
    metode_pembayaran TEXT NOT NULL,
    status TEXT DEFAULT 'pending', -- 'pending', 'paid', 'expired', 'failed'
    payment_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(campaign_id) REFERENCES campaign_sedekah(id) ON DELETE SET NULL
);

-- 10. Ruangan & Booking Fasilitas
CREATE TABLE IF NOT EXISTS ruangan (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL,
    kapasitas INTEGER DEFAULT 50,
    fasilitas TEXT,
    foto TEXT
);

CREATE TABLE IF NOT EXISTS booking_ruangan (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ruangan_id INTEGER NOT NULL,
    nama_pemohon TEXT NOT NULL,
    instansi TEXT,
    kontak TEXT NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    keperluan TEXT NOT NULL,
    status TEXT DEFAULT 'pending', -- 'pending', 'disetujui', 'ditolak'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(ruangan_id) REFERENCES ruangan(id) ON DELETE CASCADE
);

-- 11. DKM & Notifikasi
CREATE TABLE IF NOT EXISTS dkm (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL,
    jabatan TEXT NOT NULL,
    foto TEXT,
    urutan INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS notifikasi (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    judul TEXT NOT NULL,
    pesan TEXT NOT NULL,
    tipe TEXT DEFAULT 'info',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
