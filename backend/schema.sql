-- Cloudflare D1 SQLite Schema for Hudhud Backend
-- Quran, Hadits, Doa, prayer times, articles, notifications, and events

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

-- 3. Al-Qur'an
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

-- 4. Doa & Dzikir
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

-- 5. Hadits (v2)
DROP TABLE IF EXISTS had_imam;
CREATE TABLE IF NOT EXISTS had_imam (
    imamId      INTEGER PRIMARY KEY,
    imamSorting INTEGER DEFAULT 0,
    hadits      INTEGER DEFAULT 0,
    longNama    TEXT    NOT NULL,
    namaTabel   TEXT    NOT NULL UNIQUE,
    slug        TEXT    NOT NULL UNIQUE
);

INSERT OR REPLACE INTO had_imam (imamId, imamSorting, hadits, longNama, namaTabel, slug) VALUES
  (1,  1, 42,   'Hadits Arba''in An-Nawawiyah', 'arbain',    'arbain'),
  (2,  2, 6638, 'Shahih Bukhari',               'bukhari',   'bukhari'),
  (3,  3, 4930, 'Shahih Muslim',                'muslim',    'muslim'),
  (4,  4, 4419, 'Sunan Abu Daud',               'abudaud',   'abu-dawud'),
  (5,  5, 3625, 'Sunan At-Tirmidzi',            'tirmidzi',  'tirmidzi'),
  (6,  6, 5364, 'Sunan An-Nasa''i',             'nasai',     'nasai'),
  (7,  7, 4285, 'Sunan Ibnu Majah',             'ibnumajah', 'ibnu-majah'),
  (8,  8, 4305, 'Musnad Ahmad',                 'ahmad',     'ahmad'),
  (9,  9, 1587, 'Muwaththa'' Malik',            'malik',     'malik'),
  (10,10, 2949, 'Sunan Ad-Darimi',              'darimi',    'darimi');

DROP TABLE IF EXISTS hadits_konten;
CREATE TABLE IF NOT EXISTS hadits_konten (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    namaTabel    TEXT    NOT NULL,
    NoHdt        INTEGER NOT NULL,
    Isi_Arab     TEXT    NOT NULL,
    Isi_Indonesia TEXT   NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_hadits_konten_tabel ON hadits_konten(namaTabel, NoHdt);
CREATE INDEX IF NOT EXISTS idx_hadits_konten_pagination ON hadits_konten(namaTabel, id);

DROP TABLE IF EXISTS hadits_arbain;
CREATE TABLE IF NOT EXISTS hadits_arbain (
    NoHdt        INTEGER PRIMARY KEY,
    Isi_Arab     TEXT NOT NULL,
    Isi_Indonesia TEXT NOT NULL
);
DROP TABLE IF EXISTS hadits_kitab;
DROP TABLE IF EXISTS hadits_bab;

-- 6. Artikel
CREATE TABLE IF NOT EXISTS artikel_kategori (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS artikel (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kategori_id INTEGER,
    judul TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    konten TEXT NOT NULL,
    thumbnail TEXT,
    penulis TEXT DEFAULT 'DKM An-Ni''mah',
    dibaca INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(kategori_id) REFERENCES artikel_kategori(id) ON DELETE SET NULL
);

-- 7. Notifications & Events
CREATE TABLE IF NOT EXISTS notifikasi (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    judul TEXT NOT NULL,
    pesan TEXT NOT NULL,
    tipe TEXT DEFAULT 'info',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS event (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    judul TEXT NOT NULL,
    deskripsi TEXT,
    tanggal_event DATETIME NOT NULL,
    banner TEXT,
    lokasi TEXT DEFAULT 'Masjid An-Ni''mah Cibubur',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 8. Hadits v3 — Bab & Tema (lihat sql/hadits_bab_tema.sql untuk DDL lengkap)
CREATE TABLE IF NOT EXISTS hadits_bab (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    namaTabel TEXT    NOT NULL,
    urutan    INTEGER NOT NULL DEFAULT 0,
    nama      TEXT    NOT NULL,
    namaArab  TEXT,
    noAwal    INTEGER NOT NULL,
    noAkhir   INTEGER NOT NULL,
    UNIQUE(namaTabel, urutan)
);
CREATE INDEX IF NOT EXISTS idx_hadits_bab_tabel ON hadits_bab(namaTabel, urutan);

CREATE TABLE IF NOT EXISTS hadits_koleksi (
    id    INTEGER PRIMARY KEY,
    judul TEXT    NOT NULL,
    arab  TEXT    NOT NULL,
    indo  TEXT    NOT NULL
);

CREATE TABLE IF NOT EXISTS hadits_tema (
    id     INTEGER PRIMARY KEY,
    nama   TEXT    NOT NULL,
    parent INTEGER
);

CREATE TABLE IF NOT EXISTS hadits_tema_item (
    temaId    INTEGER NOT NULL,
    koleksiId INTEGER NOT NULL,
    PRIMARY KEY (temaId, koleksiId)
);
CREATE INDEX IF NOT EXISTS idx_hadits_tema_item ON hadits_tema_item(temaId);
