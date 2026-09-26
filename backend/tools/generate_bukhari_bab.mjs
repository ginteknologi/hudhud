import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const fawazMappedFile = '/tmp/bukhari_mapped_clean.json';
const fawaz = JSON.parse(fs.readFileSync(fawazMappedFile, 'utf8'));

const ARABIC_AND_INDO = [
  { urutan: 1, nama: 'Permulaan Wahyu', namaArab: 'كتاب بدء الوحي' },
  { urutan: 2, nama: 'Iman', namaArab: 'كتاب الإيمان' },
  { urutan: 3, nama: 'Ilmu', namaArab: 'كتاب العلم' },
  { urutan: 4, nama: 'Wudhu', namaArab: 'كتاب الوضوء' },
  { urutan: 5, nama: 'Mandi', namaArab: 'كتاب الغسل' },
  { urutan: 6, nama: 'Haid', namaArab: 'كتاب الحيض' },
  { urutan: 7, nama: 'Tayamum', namaArab: 'كتاب التيمم' },
  { urutan: 8, nama: 'Shalat', namaArab: 'كتاب الصلاة' },
  { urutan: 9, nama: 'Waktu-Waktu Shalat', namaArab: 'كتاب مواقيت الصلاة' },
  { urutan: 10, nama: 'Adzan', namaArab: 'كتاب الأذان' },
  { urutan: 11, nama: 'Shalat Jumat', namaArab: 'كتاب الجمعة' },
  { urutan: 12, nama: 'Shalat Khauf', namaArab: 'كتاب صلاة الخوف' },
  { urutan: 13, nama: 'Shalat Dua Hari Raya', namaArab: 'كتاب العيدين' },
  { urutan: 14, nama: 'Shalat Witir', namaArab: 'كتاب الوتر' },
  { urutan: 15, nama: "Istisqa' (Meminta Hujan)", namaArab: 'كتاب الاستسقاء' },
  { urutan: 16, nama: 'Kusuf (Gerhana)', namaArab: 'كتاب الكسوف' },
  { urutan: 17, nama: "Sujud Qur'an", namaArab: 'كتاب سجود القرآن' },
  { urutan: 18, nama: 'Qashar Shalat', namaArab: 'كتاب تقصير الصلاة' },
  { urutan: 19, nama: 'Tahajjud & Shalat Malam', namaArab: 'كتاب التهجد' },
  { urutan: 20, nama: 'Keutamaan Shalat di Masjid Makkah & Madinah', namaArab: 'كتاب فضل الصلاة في مسجد مكة والمدينة' },
  { urutan: 21, nama: 'Beramal dalam Shalat', namaArab: 'كتاب العمل في الصلاة' },
  { urutan: 22, nama: 'Sujud Sahwi', namaArab: 'كتاب السهو' },
  { urutan: 23, nama: 'Jenazah', namaArab: 'كتاب الجنائز' },
  { urutan: 24, nama: 'Zakat', namaArab: 'كتاب الزكاة' },
  { urutan: 25, nama: 'Haji', namaArab: 'كتاب الحج' },
  { urutan: 26, nama: 'Umrah', namaArab: 'كتاب العمرة' },
  { urutan: 27, nama: 'Terhalang Haji (Muhshar)', namaArab: 'كتاب المحصر' },
  { urutan: 28, nama: 'Denda Berburu Saat Ihram', namaArab: 'كتاب جزاء الصيد' },
  { urutan: 29, nama: 'Keutamaan Kota Madinah', namaArab: 'كتاب فضائل المدينة' },
  { urutan: 30, nama: 'Puasa', namaArab: 'كتاب الصوم' },
  { urutan: 31, nama: 'Shalat Tarawih', namaArab: 'كتاب صلاة التراويح' },
  { urutan: 32, nama: 'Keutamaan Lailatul Qadar', namaArab: 'كتاب فضل ليلة القدر' },
  { urutan: 33, nama: "I'tikaf", namaArab: 'كتاب الاعتكاف' },
  { urutan: 34, nama: 'Jual Beli', namaArab: 'كتاب البيوع' },
  { urutan: 35, nama: 'Salam (Jual Beli Pesanan)', namaArab: 'كتاب السلم' },
  { urutan: 36, nama: "Asy-Syuf'ah", namaArab: 'كتاب الشفعة' },
  { urutan: 37, nama: 'Ijarah (Sewa Menyewa)', namaArab: 'كتاب الإجارة' },
  { urutan: 38, nama: 'Hawalah (Pengalihan Hutang)', namaArab: 'كتاب الحوالة' },
  { urutan: 39, nama: 'Kafalah (Jaminan Hutang)', namaArab: 'كتاب الكفالة' },
  { urutan: 40, nama: 'Wakalah (Perwakilan)', namaArab: 'كتاب الوكالة' },
  { urutan: 41, nama: "Muzara'ah (Bercocok Tanam)", namaArab: 'كتاب المزارعة' },
  { urutan: 42, nama: 'Pengairan & Pembagian Air', namaArab: 'كتاب المساقاة والشرب' },
  { urutan: 43, nama: 'Hutang Piutang & Kepailitan', namaArab: 'كتاب الاستقراض وأداء الديون' },
  { urutan: 44, nama: 'Khusumat (Perselisihan)', namaArab: 'كتاب الخصومات' },
  { urutan: 45, nama: 'Luqathah (Barang Temuan)', namaArab: 'كتاب اللقطة' },
  { urutan: 46, nama: 'Kezaliman & Ghasab', namaArab: 'كتاب المظالم والغصب' },
  { urutan: 47, nama: 'Syirkah (Kemitraan/Kongsi)', namaArab: 'كتاب الشركة' },
  { urutan: 48, nama: 'Rahn (Gadai)', namaArab: 'كتاب الرهن' },
  { urutan: 49, nama: 'Pembebasan Budak', namaArab: 'كتاب العتق' },
  { urutan: 50, nama: 'Mukatab', namaArab: 'كتاب المكاتب' },
  { urutan: 51, nama: 'Hibah & Hadiah', namaArab: 'كتاب الهبة وفضلها' },
  { urutan: 52, nama: 'Saksi-Saksi', namaArab: 'كتاب الشهادات' },
  { urutan: 53, nama: 'Perdamaian (Shulh)', namaArab: 'كتاب الصلح' },
  { urutan: 54, nama: 'Syarat-Syarat', namaArab: 'كتاب الشروط' },
  { urutan: 55, nama: 'Wasiat', namaArab: 'كتاب الوصايا' },
  { urutan: 56, nama: 'Jihad & Ekspedisi', namaArab: 'كتاب الجهاد والسير' },
  { urutan: 57, nama: 'Khumus (Seperlima Rampasan Perang)', namaArab: 'كتاب فرض الخمس' },
  { urutan: 58, nama: 'Jizyah & Gencatan Senjata', namaArab: 'كتاب الجزية والموادعة' },
  { urutan: 59, nama: 'Awal Penciptaan Makhluk', namaArab: 'كتاب بدء الخلق' },
  { urutan: 60, nama: 'Kisah Para Nabi', namaArab: 'كتاب أحاديث الأنبياء' },
  { urutan: 61, nama: 'Manaqib (Keutamaan & Sifat)', namaArab: 'كتاب المناقب' },
  { urutan: 62, nama: 'Keutamaan Para Shahabat', namaArab: 'كتاب فضائل أصحاب النبي' },
  { urutan: 63, nama: 'Keutamaan Kaum Anshar', namaArab: 'كتاب مناقب الأنصار' },
  { urutan: 64, nama: 'Peperangan Nabi (Al-Maghazi)', namaArab: 'كتاب المغازي' },
  { urutan: 65, nama: "Tafsir Al-Qur'an", namaArab: 'كتاب التفسير' },
  { urutan: 66, nama: "Keutamaan Al-Qur'an", namaArab: 'كتاب فضائل القرآن' },
  { urutan: 67, nama: 'Nikah', namaArab: 'كتاب النكاح' },
  { urutan: 68, nama: 'Thalaq (Perceraian)', namaArab: 'كتاب الطلاق' },
  { urutan: 69, nama: 'Nafkah Keluarga', namaArab: 'كتاب النفقات' },
  { urutan: 70, nama: 'Makanan & Hidangan', namaArab: 'كتاب الأطعمة' },
  { urutan: 71, nama: 'Aqiqah', namaArab: 'كتاب العقيقة' },
  { urutan: 72, nama: 'Sembelihan & Berburu', namaArab: 'كتاب الذبائح والصيد' },
  { urutan: 73, nama: 'Qurban (Udhiyah)', namaArab: 'كتاب الأضاحي' },
  { urutan: 74, nama: 'Minuman', namaArab: 'كتاب الأشربة' },
  { urutan: 75, nama: 'Menjenguk Orang Sakit', namaArab: 'كتاب المرضى' },
  { urutan: 76, nama: 'Pengobatan (Thibbun Nabawi)', namaArab: 'كتاب الطب' },
  { urutan: 77, nama: 'Pakaian & Perhiasan', namaArab: 'كتاب اللباس' },
  { urutan: 78, nama: 'Adab & Akhlak', namaArab: 'كتاب الأدب' },
  { urutan: 79, nama: "Isti'dzan (Meminta Izin)", namaArab: 'كتاب الاستئذان' },
  { urutan: 80, nama: "Doa-Doa (Ad-Da'awat)", namaArab: 'كتاب الدعوات' },
  { urutan: 81, nama: 'Ar-Riqaq (Pelelembut Hati)', namaArab: 'كتاب الرقاق' },
  { urutan: 82, nama: 'Qadar (Takdir Allah)', namaArab: 'كتاب القدر' },
  { urutan: 83, nama: 'Sumpah & Nadzar', namaArab: 'كتاب الأيمان والنذور' },
  { urutan: 84, nama: 'Kafarat Sumpah', namaArab: 'كتاب كفارات الأيمان' },
  { urutan: 85, nama: 'Faraidh (Hukum Waris)', namaArab: 'كتاب الفرائض' },
  { urutan: 86, nama: 'Hudud (Hukum Pidana Islam)', namaArab: 'كتاب الحدود' },
  { urutan: 87, nama: 'Diyat (Tebusan Darah)', namaArab: 'كتاب الديات' },
  { urutan: 88, nama: 'Mengajak Bertaubat Orang Murtad', namaArab: 'كتاب استتابة المرتدين' },
  { urutan: 89, nama: 'Ikrah (Pemaksaan)', namaArab: 'كتاب الإكراه' },
  { urutan: 90, nama: 'Hilah (Tipu Daya)', namaArab: 'كتاب الحيل' },
  { urutan: 91, nama: "Ta'bir Mimpi", namaArab: 'كتاب التعبير' },
  { urutan: 92, nama: 'Fitnah Akhir Zaman', namaArab: 'كتاب الفتن' },
  { urutan: 93, nama: 'Ahkam (Hukum Peradilan & Pemerintahan)', namaArab: 'كتاب الأحكام' },
  { urutan: 94, nama: 'Angan-Angan & Harapan', namaArab: 'كتاب التمني' },
  { urutan: 95, nama: 'Berita Ahad (Khabar Wahid)', namaArab: 'كتاب أخبار الآحاد' },
  { urutan: 96, nama: "Berpegang Teguh pada Al-Qur'an & As-Sunnah", namaArab: 'كتاب الاعتصام بالكتاب والسنة' },
  { urutan: 97, nama: 'Tauhid', namaArab: 'كتاب التوحيد' }
];

const totalBukhari = 6638;
const finalRows = [];

for (let i = 0; i < fawaz.length; i++) {
  const item = fawaz[i];
  const info = ARABIC_AND_INDO[i];
  const noAwal = item.localNo;
  const noAkhir = (i < fawaz.length - 1) ? (fawaz[i + 1].localNo - 1) : totalBukhari;
  const total = (noAkhir - noAwal + 1);

  finalRows.push({
    namaTabel: 'bukhari',
    urutan: item.sec,
    nama: info.nama,
    namaArab: info.namaArab,
    noAwal,
    noAkhir,
    totalHadits: total
  });
}

console.log('Total chapters constructed:', finalRows.length);
console.log('Total hadiths covered:', finalRows.reduce((acc, r) => acc + r.totalHadits, 0));
console.log('First 5:', finalRows.slice(0, 5));
console.log('Last 5:', finalRows.slice(-5));

// Generate SQL
const sqlStatements = [
  '-- Data Bab Shahih Bukhari (97 Bab Tematik)',
  '-- Generated with Boundary Matan Matching for Fathul Bari/Lidwa Numbering',
  "DELETE FROM hadits_bab WHERE namaTabel = 'bukhari';",
  ''
];

function esc(str) {
  return `'${String(str).replace(/'/g, "''")}'`;
}

for (const row of finalRows) {
  sqlStatements.push(
    `INSERT INTO hadits_bab (namaTabel, urutan, nama, namaArab, noAwal, noAkhir) VALUES ('bukhari', ${row.urutan}, ${esc(row.nama)}, ${esc(row.namaArab)}, ${row.noAwal}, ${row.noAkhir});`
  );
}

const outFile = path.resolve(__dirname, '../seeds/05_hadits_bab_bukhari.sql');
fs.writeFileSync(outFile, sqlStatements.join('\n') + '\n', 'utf8');
console.log('Generated SQL file:', outFile);
