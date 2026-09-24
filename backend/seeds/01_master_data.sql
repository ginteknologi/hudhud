-- Seeds 01: Master Data Masjid An-Ni'mah (Marbot Backend)

-- 1. Surah Master
INSERT OR IGNORE INTO surah (id, nama, asma, jumlah_ayat, tipe, arti, audio_url) VALUES
(1, 'Al-Fatihah', 'الفاتحة', 7, 'mekah', 'Pembukaan', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3'),
(2, 'Al-Baqarah', 'البقرة', 286, 'madinah', 'Sapi Betina', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/2.mp3'),
(3, 'Ali ''Imran', 'آل عمران', 200, 'madinah', 'Keluarga Imran', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/3.mp3'),
(112, 'Al-Ikhlas', 'الإخلاص', 4, 'mekah', 'Memurnikan Keesaan Allah', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/112.mp3'),
(113, 'Al-Falaq', 'الفلق', 5, 'mekah', 'Waktu Subuh', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/113.mp3'),
(114, 'An-Nas', 'الناس', 6, 'mekah', 'Manusia', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/114.mp3');

-- 2. Sample Ayat Al-Fatihah
INSERT OR IGNORE INTO ayat (id, surah_id, nomor_ayat, teks_arab, teks_latin, terjemahan, audio_url) VALUES
(1, 1, 1, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', 'Bismillaahir-rohmaanir-rohiim', 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1001.mp3'),
(2, 1, 2, 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 'Al-hamdu lillaahi robbil-''aalamiin', 'Segala puji bagi Allah, Tuhan seluruh alam,', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1002.mp3'),
(3, 1, 3, 'الرَّحْمَٰنِ الرَّحِيمِ', 'Ar-rohmaanir-rohiim', 'Yang Maha Pengasih, Maha Penyayang,', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1003.mp3'),
(4, 1, 4, 'مَالِكِ يَوْمِ الدِّينِ', 'Maaliki yawmid-diin', 'Pemilik hari pembalasan.', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1004.mp3'),
(5, 1, 5, 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', 'Iyyaaka na''budu wa iyyaaka nasta''iin', 'Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan.', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1005.mp3'),
(6, 1, 6, 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', 'Ihdinash-shiroothol-mustaqiim', 'Tunjukilah kami jalan yang lurus,', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1006.mp3'),
(7, 1, 7, 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ', 'Shiroothol-ladziina an''amta ''alayhim ghoiril-maghdhuubi ''alayhim waladh-dhoolliin', '(yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai, dan bukan (pula jalan) mereka yang sesat.', 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1007.mp3');

-- 3. Kategori Doa & Doa
INSERT OR IGNORE INTO doa_kategori (id, nama, icon) VALUES
(1, 'Doa Harian', 'assets/icons/doa_harian.png'),
(2, 'Doa Shalat', 'assets/icons/doa_shalat.png'),
(3, 'Doa Pilihan', 'assets/icons/doa_pilihan.png'),
(4, 'Doa Perlindungan', 'assets/icons/doa_perlindungan.png');

INSERT OR IGNORE INTO doa (id, kategori_id, judul, teks_arab, teks_latin, terjemahan, riwayat) VALUES
(1, 1, 'Doa Sebelum Tidur', 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي وَبِكَ أَرْفَعُهُ', 'Bismika robbi wadho''tu jambi wa bika arfa''uh', 'Dengan nama-Mu wahai Tuhanku, aku meletakkan lambungku dan dengan nama-Mu aku mengangkatnya.', 'HR. Bukhari & Muslim'),
(2, 1, 'Doa Bangun Tidur', 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ', 'Alhamdulillahilladzi ahyana ba''da ma amatana wa ilaihin nusyur', 'Segala puji bagi Allah yang menghidupkan kami setelah mematikan kami, dan kepada-Nya kami kembali.', 'HR. Bukhari'),
(3, 1, 'Doa Masuk Masjid', 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ', 'Allahummaftah lii abwaaba rohmatik', 'Ya Allah, bukakanlah untukku pintu-pintu rahmat-Mu.', 'HR. Muslim'),
(4, 1, 'Doa Keluar Masjid', 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ', 'Allahumma inni as-aluka min fadhlik', 'Ya Allah, sesungguhnya aku memohon keutamaan dari-Mu.', 'HR. Muslim');

-- 4. Dzikir
INSERT OR IGNORE INTO dzikir (id, judul, teks_arab, terjemahan, target_count, waktu) VALUES
(1, 'Tasbih', 'سُبْحَانَ اللَّهِ', 'Maha Suci Allah', 33, 'solat'),
(2, 'Tahmid', 'الْحَمْدُ لِلَّهِ', 'Segala puji bagi Allah', 33, 'solat'),
(3, 'Takbir', 'اللَّهُ أَكْبَرُ', 'Allah Maha Besar', 33, 'solat'),
(4, 'Ayat Kursi Pagi & Petang', 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...', 'Allah, tidak ada tuhan selain Dia. Yang Mahahidup, Yang terus-menerus mengurus (makhluk-Nya)...', 1, 'pagi');

-- 5. Artikel & Kategori
INSERT OR IGNORE INTO artikel_kategori (id, nama, slug) VALUES
(1, 'Kajian & Dakwah', 'kajian-dakwah'),
(2, 'Berita Masjid', 'berita-masjid'),
(3, 'Fiqih & Ibadah', 'fiqih-ibadah');

INSERT OR IGNORE INTO artikel (id, kategori_id, judul, slug, konten, thumbnail, penulis, dibaca) VALUES
(1, 1, 'Keutamaan Menjaga Shalat Berjamaah di Masjid', 'keutamaan-sholat-berjamaah', 'Shalat berjamaah memiliki pahala 27 derajat lebih tinggi dibandingkan shalat sendirian...', 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?q=80&w=800', 'DKM An-Ni''mah', 125),
(2, 2, 'Laporan Keuangan & Kegiatan Infaq Ramadhan', 'laporan-infaq-ramadhan', 'Alhamdulillah, rekapitulasi dana infaq dan sedekah jamaah telah disalurkan kepada yang berhak...', 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=800', 'DKM An-Ni''mah', 94),
(3, 3, 'Adab dan Sunnah di Hari Jumat', 'adab-sunnah-hari-jumat', 'Mandi Jumat, memakai pakaian terbaik, membersihkan diri, dan bersegera datang ke masjid adalah amalan utama...', 'https://images.unsplash.com/photo-1584286595398-a59f21d313f5?q=80&w=800', 'Ustadz Ahmad', 210);

-- 6. Kajian
INSERT OR IGNORE INTO kajian (id, judul, ustadz, deskripsi, thumbnail, video_link, tipe) VALUES
(1, 'Tafsir Surat Al-Fatihah & Makna Tauhid', 'Ust. Dr. Muhammad Yasir, Lc., MA', 'Kajian rutin ba''da Maghrib membahas intisari ayat-ayat Ummul Quran.', 'https://images.unsplash.com/photo-1564769625905-50e93615e769?q=80&w=800', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'slider'),
(2, 'Fiqih Muamalah: Panduan Keuangan Syariah Jamaah', 'Ust. Ahmad Fauzi, S.E.I', 'Memahami akad-akad syariah kontemporer dalam kehidupan sehari-hari.', 'https://images.unsplash.com/photo-1579621970795-87facc2f976d?q=80&w=800', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'list'),
(3, 'Tuntunan Tahsin & Adzan Terbaik', 'Ustadz Bilal Al-Indunisi', 'Pelatihan makharijul huruf bagi calon muadzin dan imam muda.', 'https://images.unsplash.com/photo-1585036156171-384164a8c675?q=80&w=800', '', 'muadzin');

-- 7. Campaign Sedekah
INSERT OR IGNORE INTO campaign_sedekah (id, judul, deskripsi, target_nominal, terkumpul_nominal, thumbnail, status, end_date) VALUES
(1, 'Infaq Renovasi & Perluasan Tempat Wudhu', 'Program renovasi fasilitas tempat wudhu dan toilet ramah lansia di Masjid An-Ni''mah Cibubur.', 100000000, 48500000, 'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?q=80&w=800', 'aktif', '2026-12-31'),
(2, 'Santunan Bulanan 50 Anak Yatim & Dhuafa', 'Pemberian paket sembako dan biaya pendidikan santri binaan Masjid An-Ni''mah.', 25000000, 18750000, 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?q=80&w=800', 'aktif', '2026-12-31'),
(3, 'Operasional & Air Bersih Masjid', 'Dukungan listrik, kebersihan karpet, AC, dan ketersediaan air bersih jamaah.', 15000000, 12200000, 'https://images.unsplash.com/photo-1590076215667-873d425f19c3?q=80&w=800', 'aktif', '2026-12-31');

-- 8. Ruangan
INSERT OR IGNORE INTO ruangan (id, nama, kapasitas, fasilitas, foto) VALUES
(1, 'Aula Serbaguna Utama', 200, 'AC, Sound System, Proyektor, Karpet', 'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=800'),
(2, 'Ruang Rapat Syura', 30, 'Meja Rapat, AC, TV Monitor, Wifi', 'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=800');

-- 9. DKM & Sosmed
INSERT OR IGNORE INTO dkm (id, nama, jabatan, foto, urutan) VALUES
(1, 'H. Bambang Sudirman', 'Ketua DKM', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=400', 1),
(2, 'Ust. Ridwan Kamil, Lc.', 'Bidang Dakwah & Ibadah', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=400', 2),
(3, 'Ir. Hendra Wijaya', 'Bidang Sarana & Prasarana', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400', 3);

INSERT OR IGNORE INTO sosmed (id, nama, type, icon, link) VALUES
(1, 'YouTube Official Masjid An-Ni''mah', 'youtube', 'assets/icons/youtube.png', 'https://youtube.com/@masjidannimah'),
(2, 'Instagram @masjidannimah', 'instagram', 'assets/icons/instagram.png', 'https://instagram.com/masjidannimah'),
(3, 'WhatsApp Call Center', 'whatsapp', 'assets/icons/whatsapp.png', 'https://wa.me/6281234567890'),
(4, 'Website Resmi', 'website', 'assets/icons/website.png', 'https://annimah.id');

-- 10. Event & Kartu Ucapan
INSERT OR IGNORE INTO event (id, judul, deskripsi, tanggal_event, banner, lokasi) VALUES
(1, 'Peringatan Nuzulul Quran Akbar', 'Kajian akbar dan buka puasa bersama jamaah sekabupaten Cibubur.', '2026-04-10 16:30:00', 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?q=80&w=800', 'Masjid An-Ni''mah Cibubur');

INSERT OR IGNORE INTO kartu_ucapan (id, judul, ucapan, background_image) VALUES
(1, 'Selamat Hari Raya Idul Fitri', 'Taqabbalallahu minna wa minkum, mohon maaf lahir dan batin.', 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?q=80&w=800'),
(2, 'Selamat Hari Raya Idul Adha', 'Semoga keikhlasan dan semangat berkurban senantiasa menyertai kita.', 'https://images.unsplash.com/photo-1584286595398-a59f21d313f5?q=80&w=800');
