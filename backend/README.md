# Masjid An-Ni'mah Backend (Cloudflare Workers + D1 + R2)

Backend modern, serverless, dan ultra-fast berbasis Cloudflare Workers dengan framework **Hono**, database relasional **Cloudflare D1 (SQLite)**, dan object storage **Cloudflare R2**.

---

## 🚀 Fitur Backend
- **Edge Performance**: Latensi milidetik global melalui edge network Cloudflare.
- **Relational D1 Database**: Skema lengkap 18 tabel (jadwal sholat, profil, surah/ayat, hadits, doa, dzikir, kajian, artikel, program sedekah, transaksi).
- **R2 Storage Streaming**: Streaming file audio murottal, quran page webp, foto artikel/kajian, dan bukti transfer pembayaran langsung dari Cloudflare R2 bucket.
- **CORS & Type-Safe**: Dibangun dengan TypeScript dan router Hono.

---

## 🛠️ Persiapan & Langkah Deploy

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Login ke Cloudflare
```bash
npx wrangler login
```

### 3. Buat Database Cloudflare D1
```bash
npx wrangler d1 create masjid-db
```
Salin `database_id` yang dihasilkan ke dalam file `wrangler.toml`:
```toml
[[d1_databases]]
binding = "DB"
database_name = "masjid-db"
database_id = "<PASTE_DATABASE_ID_DISINI>"
```

### 4. Eksekusi Skema Database ke D1
- **Lokal (Local dev)**:
  ```bash
  npx wrangler d1 execute masjid-db --local --file=./schema.sql
  ```
- **Produksi (Cloudflare Cloud)**:
  ```bash
  npx wrangler d1 execute masjid-db --remote --file=./schema.sql
  ```

### 5. Buat Cloudflare R2 Bucket
```bash
npx wrangler r2 bucket create masjid-media
npx wrangler r2 bucket create masjid-media-preview
```

### 6. Testing Lokal
Jalankan dev server di port lokal:
```bash
npm run dev
# Server aktif di http://localhost:8787
```

### 7. Deploy ke Cloudflare Workers
```bash
npm run deploy
```
Setelah deploy, Anda akan mendapatkan URL publik Worker (contoh: `https://marbot-api.<subdomain>.workers.dev`).

---

## 📱 Menghubungkan ke Aplikasi Flutter
Saat menjalankan aplikasi Flutter atau membuild APK:
```bash
fvm flutter run --dart-define=API_BASE_URL="https://marbot-api.<subdomain>.workers.dev/api/v1" --dart-define=MEDIA_BASE_URL="https://cdn.masjidannimah.id"
```
Atau ubah nilai default di file `lib/core/network/api_endpoints.dart`.
