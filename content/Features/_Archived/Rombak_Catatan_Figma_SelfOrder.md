# Rombak Catatan di Figma — Self Order

**Status:** Draft (menunggu keputusan pada 3 konflik di bagian 5)
**Tanggal:** 2026-07-30
**Untuk:** UI/UX (yang mengeksekusi di Figma) · QA & DEV (pembaca catatannya)
**File:** Figma `mAZuRze02w906M6u2EwVWh` (Self-Order), canvas MVP `1223:2`
**Terkait:** [[SO_Case_QRManagementNegative]] · [[SO_Case_JourneyMVP]] · [[Riset_Workflow_Handoff_UIUX_QA_DEV]]

> Isi catatan di dokumen ini dibaca langsung dari file Figma-nya, bukan dari ingatan.

---

## 1. Kondisi sekarang, dalam angka

| Metrik | Nilai |
|---|---|
| Frame bernama `catatan` / `Catatan` / `Note` di canvas MVP | **28** (sebagian frame anak di dalam frame catatan besar) |
| **Kosong sama sekali** | **6** |
| Lebih dari 800 karakter dalam satu blok teks | **8** |
| Catatan terpanjang | **1.804 karakter** (`2397:23828`, Generate QR Gagal) |
| Berisi placeholder komponen yang belum diisi (`Title`, `Date`, `@devs`, `Write note here...`) | 2 |

Delapan catatan di atas 800 karakter itu inti masalahnya. Satu blok teks 1.800 karakter tanpa jeda baris tidak dibaca siapa pun — dilewati.

## 2. Kenapa terasa "tidak kebaca"

Lima pola, semuanya ada buktinya di file:

**a. Struktur dokumen dipaksa masuk ke satu blok teks.** Catatan panjang memakai heading bernomor `1. Pre-condition (Kondisi Awal)` … `2. Steps to Reproduce (Langkah-langkah)` … `3. Expected Result (Hasil yang Diharapkan)`, plus bullet `•`, semuanya **di dalam satu text node**. Di dokumen itu rapi; di canvas jadi paragraf rapat tanpa hierarki.

**b. Istilah Inggris yang tidak perlu.** `Sorting Behavior`, `Kondisi Limitasi Karakter (Truncation Rule)`, `State Recovery`, `Steps to Reproduce`, `Expected Result`. Pembacanya orang Indonesia yang sedang melihat gambar, bukan pembaca dokumen teknis berbahasa Inggris.

**c. Kalimat bergaya laporan, bukan bergaya orang menjelaskan.** *"Sistem memproses request yang masuk hitungan milidetik lebih awal (misal: milik User A)."* · *"sistem harus otomatis memuat ulang (refresh) data terbaru"*. Panjang, pasif, dan menyebut "sistem" di setiap kalimat.

**d. Catatan menyalin seluruh isi spec.** Catatan `2405:22710` (hak akses) memuat 1.278 karakter yang isinya sama dengan spec — termasuk alasan desain "kontrol yang tidak bisa dipakai tidak perlu ada". Itu bagus di spec, berlebihan di canvas. Catatan di Figma sebaiknya menjawab satu hal saja: **apa yang tidak kelihatan dari gambarnya.**

**e. Sisa kerja yang tidak dibersihkan.** 6 catatan kosong, 2 sticky note dengan placeholder `Write note here...` yang isinya kembar, dan catatan setengah kalimat seperti *"ini catatan dari penerimaan"* (27 karakter) atau *"ini setelah user cari cari menu, lalu mengklik es cendol durian"*.

## 3. Aturan penulisan catatan (usulan)

Enam aturan. Semuanya bisa dipakai tanpa mengubah komponen catatan yang sudah ada.

| # | Aturan | Alasan |
|---|---|---|
| 1 | **Maksimal ~40 kata per blok.** Lebih dari itu, pecah ke field terpisah (Kondisi / Langkah / Hasil) sebagai text node sendiri. | yang panjang tidak dibaca |
| 2 | **Satu kalimat satu baris.** Jangan sambung pakai `•` di tengah paragraf. | biar bisa dipindai, bukan dibaca berurutan |
| 3 | **Bahasa Indonesia biasa.** Tidak ada `Sorting Behavior`, `Truncation Rule`, `State Recovery`. | pembacanya QA & DEV lokal yang sedang lihat gambar |
| 4 | **Tulis yang tidak kelihatan dari gambar.** Copy final, aturan urutan, apa yang terjadi setelah tombol ditekan. Bukan mengulang seluruh kasus. | detail lengkap tempatnya di spec |
| 5 | **Sebut nama kasus di spec, jangan disalin.** Cukup: *"Detail: SO-QRN-B4 di SO_Case_QRManagementNegative.md"*. | satu sumber kebenaran, dan catatan tetap pendek |
| 6 | **Hapus catatan kosong.** Frame catatan kosong lebih buruk daripada tidak ada — pembaca menyangka ada informasi yang belum ditulis. | mengurangi kebisingan |

## 4. Rombakan per catatan

Format: **sekarang** (ringkasan/kutipan) → **ganti jadi** (siap tempel).
Yang ditandai ⚠ tidak bisa dirombak dulu — lihat bagian 5.

### 4.1 Generate QR Gagal — `2397:23828` (1.804 karakter)

Sekarang: heading bernomor + `Sorting Behavior` + `Kondisi Limitasi Karakter (Truncation Rule)` + dua "Ekspektasi" lengkap dengan contoh teks.

**Ganti jadi:**

```
Muncul kalau TIDAK ADA satu pun meja yang berhasil digenerate.
Kalau minimal 1 berhasil → modal sukses, lihat case "Generate QR Sebagian Bentrok".

Nama meja diurutkan A-Z lalu 0-9.
Lebih dari 3 meja: sebut 2 nama pertama, sisanya "dan N meja lainnya".
Tidak ada koma sebelum "dan".

"Baik, Saya mengerti" memuat ulang data — bukan cuma menutup modal.
Meja yang bentrok berubah jadi disabled di popup.

Detail: SO-QRN-B2 di SO_Case_QRManagementNegative.md
```

### 4.2 Hapus Daftar QR Gagal — `2316:18982` (1.645 karakter) ⚠

Sekarang: sama polanya dengan di atas. Dua masalah tambahan: contoh teksnya masih `"QR Meja AA-01, AA-02, dan AA-03"` (nama meja tanpa spasi, dan ada koma sebelum "dan" — dua-duanya salah menurut modal yang sudah digambar), dan menyebut *toast "11 QR Meja Gagal Dihapus"* padahal toast di kasus itu adalah toast **sukses** `"11 QR Statis Berhasil Dihapus"`.

**Ganti jadi:**

```
Muncul kalau TIDAK ADA satu pun QR yang berhasil dihapus.
Kalau minimal 1 berhasil → toast sukses "11 QR Statis Berhasil Dihapus",
lihat case "Hapus QR Sebagian Bentrok".

Nama meja diurutkan A-Z lalu 0-9.
Lebih dari 3 meja: sebut 2 nama pertama, sisanya "dan N meja lainnya".
Tidak ada koma sebelum "dan". Nama meja pakai spasi: "AA - 01".

"Baik, Saya mengerti" memuat ulang daftar — bukan cuma menutup modal.

Detail: SO-QRN-B4 di SO_Case_QRManagementNegative.md
```

### 4.3 Hapus QR Sebagian Bentrok — `2397:37288` (1.371 karakter)

Sekarang: isinya sudah benar dan lengkap, cuma terlalu panjang.

**Ganti jadi:**

```
User A hapus AA - 12 lebih dulu. Daftar User B belum ter-update.
User B centang AA - 01 sampai AA - 12, lalu Hapus.

AA - 01 sampai AA - 11 terhapus. AA - 12 dilewati diam-diam,
tanpa modal dan tanpa peringatan apa pun.
Toast: "11 QR Statis Berhasil Dihapus" — bukan 12.
Daftar jadi kosong: "Belum ada QR yang aktif".

Untuk DEV: hitungan di toast dari respons backend,
bukan dari jumlah centang di klien.

Detail: SO-QRN-B3 di SO_Case_QRManagementNegative.md
```

### 4.4 Generate QR Sebagian Bentrok — `2397:37283` (1.351 karakter)

**Ganti jadi:**

```
User A generate AA - 12 lebih dulu. Popup User B sudah terbuka sejak sebelum itu.
User B pilih AA - 01 sampai AA - 12, lalu Generate QR.

AA - 01 sampai AA - 11 dibuat. AA - 12 dilewati diam-diam.
Modal sukses: "11 QR meja berhasil dibuat" — bukan 12,
bukan juga "11 dari 12, 1 dilewati".
Chip nama meja hanya 11, AA - 12 tidak ikut tampil.
Tombol tetap "Selesai" dan "Download PDF".

Untuk DEV: hitungan dari respons backend, bukan panjang array pilihan.

Detail: SO-QRN-B1 di SO_Case_QRManagementNegative.md
```

### 4.5 QR Management Tanpa Hak Akses — `2405:22710` (1.278 karakter)

Sekarang: menyalin hampir seluruh kasus, termasuk alasan desainnya.

**Ganti jadi:**

```
Karyawan tanpa permission "Mengelola QR Self Order".

Halaman tetap bisa dibuka. Judulnya tetap "QR Management".
Blok "Generate QR untuk meja terpilih" hilang total.
Link "Pilih" hilang. Kebab menu (titik tiga) hilang di semua baris.
Blok "Ekspor data ke Self Order" tetap bisa dipakai.
Kolom "Cari daftar QR" tetap aktif — membaca daftar tetap boleh.

Dihilangkan, bukan diabukan: kontrol yang tidak bisa dipakai tidak perlu ada.

Detail: SO-QRN-E1 di SO_Case_QRManagementNegative.md
```

### 4.6 Gagal Mencetak QR Meja — `2377:41459` (1.002 karakter)

**Ganti jadi:**

```
User A hapus AA - 01 lebih dulu. Layar User B belum ter-update,
entri AA - 01 masih tampil.
User B tekan kebab (titik tiga) pada AA - 01, pilih "Cetak QR".

Cetak tidak dijalankan.
Modal: "QR Meja Gagal Dicetak"
"QR Meja AA - 01 gagal dicetak karena sudah dihapus lebih dulu oleh pengguna lain."
Satu tombol saja: "Baik, Saya mengerti" — tidak ada yang bisa diulang.

Menekannya memuat ulang daftar; entri AA - 01 hilang.
Cetak selalu satu meja, jadi tidak ada aturan pemotongan nama di sini.

Detail: SO-QRN-B5 di SO_Case_QRManagementNegative.md
```

### 4.7 Gagal Mendownload PDF — `2362:40404` (962 karakter)

**Konflik selesai 2026-07-30: catatan Figma yang benar.** Penyebabnya hanya "QR sudah dihapus pengguna lain", jadi satu tombol tanpa retry. Spec sudah dikoreksi. Yang perlu dirombak hanya panjangnya.

**Ganti jadi:**

```
User B centang QR meja, lalu User A menghapus QR yang sama lebih dulu.
User B tekan "Unduh PDF" sebelum layarnya ter-update.

Modal: "Gagal Mengunduh PDF"
"PDF tidak dapat diunduh karena data QR sudah dihapus oleh pengguna lain.
Data ini akan dihapus dari Daftar QR Aktif Anda."
Satu tombol saja: "Baik, Saya mengerti" — tidak ada yang bisa diulang.

Menekannya menutup modal lalu memuat ulang halaman.
QR yang sudah dihapus hilang dari Daftar QR Aktif.

Detail: SO-QRN-A3 di SO_Case_QRManagementNegative.md
```

### 4.8 Ekspor Data Gagal — `2325:15719` (623 karakter)

**Ganti jadi:**

```
Perangkat tidak terhubung internet, lalu tekan "Ekspor Data".

Toast merah di atas tengah:
"Gagal mengekspor data. Periksa koneksi internet Anda."
Label "Terakhir disinkronkan" TIDAK berubah.

Catatan: alur Ekspor Data sedang ditahan, kemungkinan berubah.
Lihat bagian G di SO_Case_QRManagementNegative.md.
```

### 4.9 Journey QRIS — `1223:1840` (676 karakter) ⚠

**Isinya sudah kedaluwarsa.** Menyebut *"Belum login → wajib login WhatsApp dulu"*, *"Verifikasi kode balas otomatis di WhatsApp"*, *"review read-only akurat"*, dan tombol *"Cek Stok & Promo"*. Keempatnya sudah dihapus/diganti di `SO_PRD_MVP.md`, dan Precondition-nya masih merujuk `SO_PRD.md` (baseline lama) serta menyebut "Metode A".

**Ganti jadi:**

```
Catatan
Scan QR statis → pilih menu → bayar QRIS. Tidak ada login sama sekali.

Kondisi awal
Outlet aktif, QR statis terdaftar. Stok normal.
QRIS provider terisi di AOL, jadi metode QRIS aktif.

Pemicu
Tamu scan QR di meja, pilih menu, buka keranjang, tekan "Konfirmasi Pesanan".

Hasil
Masuk halaman Menu dengan konteks "Pesan Mandiri" → keranjang →
Konfirmasi Pesanan (Data Pelanggan opsional) → bayar QRIS →
otomatis pindah ke halaman Pesanan Selesai.

Detail: SO-JRN-A1 di SO_Case_JourneyMVP.md
```

### 4.10 Journey Bayar di Kasir — `1223:2620` (947 karakter) ⚠

Masalah sama, plus menyebut *"masuk antrean WL"* — Waiting List belum jadi fitur.

**Ganti jadi:**

```
Catatan
Scan QR statis → pilih menu → bayar di kasir. Tidak ada login sama sekali.
QRIS tidak dipakai di jalur ini.

Kondisi awal
Outlet aktif, QR statis terdaftar. Stok normal.
QRIS provider dikosongkan di AOL, jadi QRIS mati dan hanya Bayar di Kasir aktif.

Pemicu
Tamu pesan sampai Konfirmasi Pesanan, pilih "Bayar di Kasir", tekan "Bayar".

Hasil
Muncul kode REF (6 angka acak) + instruksi ke kasir + rincian pesanan.
Pesanan masuk POS berstatus menunggu bayar.
Setelah kasir menandai lunas, tamu tekan "Cek Status Pesanan"
lalu masuk ke halaman Pesanan Selesai.

Detail: SO-JRN-B1 di SO_Case_JourneyMVP.md
```

### 4.11 Hapus QR Satuan — `1348:18436` (188 karakter)

**Konflik selesai 2026-07-30: catatan Figma yang benar.** Sesi pelanggan **tidak** terputus. Spec sudah dikoreksi dan catatan risikonya dihapus. Isi catatan ini sudah tepat, cuma perlu dipecah jadi baris pendek.

**Ganti jadi:**

```
Hapus = QR tidak bisa dipindai lagi untuk pesanan BARU.

Pelanggan yang sudah scan dan sedang memesan tetap lanjut sampai selesai.
Sesi berjalan TIDAK terputus.
Meja bebas untuk di-generate dan dicetak QR baru.

Detail: SO-QRN-C di SO_Case_QRManagementNegative.md
```

### 4.12 Popup Pilih Meja — `1629:60774` (257 karakter)

Isinya **sudah benar** (aturan "Pilih Semua jadi hilang" sudah tertulis). Cuma ada salah tulis `kateogori` dan masih disambung `•` dalam satu paragraf.

**Ganti jadi:**

```
Meja yang sudah punya QR tampil disabled — tidak bisa dipilih.
"Pilih Semua" hanya mencakup meja yang masih bisa dipilih.
Semua meja di satu kategori sudah ber-QR → link "Pilih Semua" hilang, bukan disabled.
Seluruh area sudah ber-QR → semua link hilang, grid tetap tampil (bukan empty state).

Detail: SO-QRN-A2 di SO_Case_QRManagementNegative.md
```

### 4.13 Promo auto-apply — `1357:18441` (208 karakter)

**Tidak perlu diubah.** Ini contoh catatan yang sudah sehat: satu aturan, bahasa biasa, panjangnya pas. Pola inilah yang dipakai untuk semua rombakan di atas.

### 4.14 REF Bayar di Kasir — `1841:24631` (148 karakter)

Isinya benar dan pendek. Satu perbaikan kalimat:

**Ganti jadi:**

```
Pilih bayar di kasir → pesanan masuk ke POS.
Nomor REF: 6 angka acak, ditunjukkan ke kasir untuk mencari pesanan.

Belum masuk PRD — perlu diangkat jadi acceptance criteria.
```

### 4.15 Yang perlu dibersihkan, bukan ditulis ulang

| Node | Isi sekarang | Tindakan |
|---|---|---|
| `1907:27046` · `1907:27449` · `1841:20875` · `1841:20985` · `1922:27532` · `1922:27718` | kosong | **hapus** frame-nya, atau isi kalau memang ada yang perlu dicatat |
| `2329:17524` dan `2329:17635` | dua sticky note dengan isi **kembar** + placeholder `Title` / `Date` / `@devs` / `Write note here...` belum diisi | sisakan satu, isi placeholder-nya atau hapus field yang tidak dipakai |
| `2016:85520` — *"ini catatan dari piutang tanpa dp (max 60 karakter)"* | catatan untuk diri sendiri, pembaca lain tidak paham | tulis ulang jelas atau hapus |
| `2016:85523` — *"ini catatan dari penerimaan"* | idem | idem |
| `1294:23017` — *"ini setelah user cari cari menu, lalu mengklik es cendol durian"* | menjelaskan yang sudah kelihatan dari gambar | hapus, atau ganti jadi keterangan urutan frame |

## 5. Tiga konflik — dua sudah selesai

Ini bukan soal gaya bahasa — isinya **bertabrakan** dengan spec. **Dua di antaranya sudah diputuskan 2026-07-30, dan dua-duanya memenangkan catatan Figma**: yang salah justru spec di vault, dan spec-nya sudah dikoreksi.

### 5.1 Penyebab "Gagal Mendownload PDF" — ✅ selesai: catatan Figma yang benar

| Sumber | Penyebab | Copy | Tombol |
|---|---|---|---|
| Catatan Figma `2362:40404` | QR-nya **sudah dihapus pengguna lain** | "PDF tidak dapat diunduh karena data QR sudah dihapus oleh pengguna lain. Data ini akan dihapus dari Daftar QR Aktif Anda." | satu: "Baik, Saya mengerti", lalu refresh |
| Spec `SO-QRN-A3` | **koneksi/timeout** saat mengunduh | "PDF tidak berhasil diunduh. QR meja tetap tersimpan di Daftar QR Aktif." | dua: "Tutup" · "Coba Lagi", centang meja dipertahankan |

**Keputusan: penyebabnya hanya QR sudah dihapus pengguna lain.** Tidak ada varian kegagalan jaringan. Konsekuensinya di spec:

- `SO-QRN-A3` ditulis ulang: modal **satu tombol** ("Baik, Saya mengerti") + muat ulang halaman, sepola dengan `SO-QRN-B5`.
- Aturan "centang meja tidak boleh hilang" **dihapus** — aturan itu lahir dari asumsi ada retry, dan retry-nya tidak ada.
- `SO-QRN-D` (printer) jadi **satu-satunya** modal kegagalan dengan dua tombol, karena cuma di situ ada jalan keluar yang masuk akal (hubungkan printer).
- Muncul pertanyaan baru (no. 10 di spec): kalau **sebagian** QR yang dicentang masih valid, PDF tetap dibuat untuk yang valid, atau seluruh unduhan digagalkan?

### 5.2 Hapus QR saat pelanggan sedang memesan — ✅ selesai: sesi TIDAK terputus

| Sumber | Isi |
|---|---|
| Catatan Figma `1348:18436` | *"Pelanggan yang sudah scan & sedang memesan tetap lanjut sampai selesai. **Sesi berjalan tidak terputus.**"* |
| Spec `SO-QRN-C` | *"Sesi Self Order pelanggan **terputus** sebagai konsekuensinya."* + catatan risiko yang diterima sadar |

**Keputusan: sesi pelanggan tidak terputus.** Menghapus QR hanya menutup pintu masuk untuk pesanan **baru**. Konsekuensinya di spec:

- `SO-QRN-C` ditulis ulang: langkah pengujiannya sekarang **melanjutkan pesanan sampai selesai** (bukan cuma melihat sesinya mati), plus cek bahwa QR lama tidak bisa dipindai lagi dan mejanya bebas di-generate ulang.
- **Catatan risiko dihapus.** Versi lama menyebut "operator tidak tahu meja sedang dipakai" sebagai risiko yang diterima sadar — sekarang tidak ada risikonya, jadi operator boleh menghapus QR kapan saja tanpa memeriksa apa pun.
- Judul kasusnya berubah dari *"jalan normal tanpa peringatan"* jadi *"sesi pelanggan tetap jalan sampai selesai"*, karena itu inti yang harus dibuktikan.

### 5.3 Toast pada catatan Hapus Daftar QR Gagal

Catatan `2316:18982` menyebut *toast "11 QR Meja Gagal Dihapus"*. Yang benar (dan yang sudah digambar) adalah toast **sukses** `"11 QR Statis Berhasil Dihapus"`. Ini kelihatannya salah tulis, bukan keputusan — tapi perlu dikonfirmasi sebelum diganti, karena menyangkut istilah "QR Statis" vs "QR Meja" yang masih jadi pertanyaan terbuka no. 2 di spec.

## 6. Urutan pengerjaan yang disarankan

| #   | Langkah                                                                              | Waktu              | Kenapa duluan                                                                                                |     |
| --- | ------------------------------------------------------------------------------------ | ------------------ | ------------------------------------------------------------------------------------------------------------ | --- |
| 1   | Hapus 6 catatan kosong + 1 sticky note kembar                                        | ~15 menit          | nol risiko, langsung mengurangi kebisingan                                                                   |     |
| 2   | Rombak dua catatan journey (`1223:1840`, `1223:2620`)                                | ~30 menit          | isinya **kedaluwarsa**, ini yang paling berbahaya karena bisa bikin QA menguji login WhatsApp yang tidak ada |     |
| 3   | Rombak enam catatan panjang (4.1, 4.3, 4.4, 4.5, 4.6, 4.8)                           | ~1 jam             | tinggal tempel dari dokumen ini                                                                              |     |
| 4   | Perbaiki `1629:60774` (typo `kateogori`) dan `1841:24631`                            | ~10 menit          | kecil, sekalian jalan                                                                                        |     |
| 5   | Putuskan 3 konflik di bagian 5, lalu rombak `2362:40404`, `1348:18436`, `2316:18982` | menunggu keputusan | menulis ulang sebelum diputuskan = mengunci versi yang mungkin salah                                         |     |

Langkah 2 yang paling mendesak. Catatan panjang cuma tidak dibaca; catatan **kedaluwarsa** dibaca, dipercaya, lalu dijadikan dasar pengujian.
