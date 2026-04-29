# PRD — Braveline Admin Dashboard
**Versi:** 1.0.2  
**Tanggal:** 18 Maret 2026  
**Project:** braveline.com  
**Database:** Supabase — Project **`mix data`** (`pgltsyrtduvddpcdlchk`, Singapore)  
**Stack:** HTML5 + Vanilla CSS + JavaScript (Supabase CDN)

---

## 1. Ringkasan Proyek

Membangun **Admin Dashboard** untuk website Braveline Apparel sehingga pemilik toko dapat mengedit seluruh teks, gambar, dan konten website secara real-time tanpa menyentuh kode.

---

## 2. Ruang Lingkup

| Komponen | Deskripsi |
|---|---|
| **Admin Dashboard** | `admin.html` (Single Page Application) |
| **Database** | Supabase PostgreSQL untuk semua konten teks |
| **File Storage** | Supabase Storage untuk upload gambar/foto |
| **Akses** | Tanpa Auth (Hanya Input Password) |

---

## 3. Fitur Utama

### 3.1 Akses Dashboard (Hanya Password)
- Login hanya menggunakan **Input Password**.
- Password disimpan dalam database (hash).
- Session dikontrol via cookie/localStorage (24 jam).

---

### 3.2 Halaman Dashboard Utama
Berisi panduan penggunaan, status seksi, dan shortcut editor.

---

### 3.3 Modul Konten per Seksi
- **Hero**: Edit teks & badge.
- **USP**: CRUD kartu keunggulan.
- **Harga**: CRUD paket harga.
- **Katalog**: CRUD produk + Upload gambar.
- **Testimonial**: CRUD ulasan.
- **FAQ**: CRUD tanya jawab.
- **Footer**: Info bisnis & alamat.
- **Settings**: Ganti password & WA number.

---

## 4. Konvensi Penamaan Supabase
Prefix: **`braveline_`** untuk tabel dan **`braveline-`** untuk storage bucket.

---

## 5. Struktur Database Supabase
(Sesuai migrasi SQL yang telah dijalankan)

---

## 6. Alur Upload Gambar
- Client-side resizing (Canvas API) ke max 800x800px.
- Upload langsung ke Supabase Storage via Client SDK.
- Max file size: 1MB.

---

## 7. Keamanan
- RLS aktif.
- Akses dashboard diproteksi password check via Client JS.
