# SO_PRD_MVP.md — Self Order (MVP)

**Status:** Siap Handoff Developer
**Versi:** 3.0 (standalone)
**Tanggal:** 2026-07-27
**Fitur:** Self Order
**Prefix:** SO
**Bahasa:** Indonesia
**File Figma:** `mAZuRze02w906M6u2EwVWh` (Self Order)

---

## 0. Cara Pakai Dokumen Ini

Dokumen ini **berdiri sendiri**. Semua yang dibutuhkan untuk membangun Self Order MVP ada di sini — tidak perlu membuka dokumen lain.

- **Tidak ada rujukan ke `SO_PRD.md` v0.2.** Dokumen itu sekarang murni arsip riwayat. Kalau ada perbedaan isi, **dokumen ini yang berlaku.**
- **Tidak ada asumsi.** Setiap keputusan di dokumen ini berasal dari keputusan PM. Yang belum diputuskan dikumpulkan di §12 — bukan ditebak.
- **ID stabil.** `PAGE-0X`, `FR-0X`, `AC-0X.Y` dipertahankan agar sinkron dengan `SO_TestScenario_MVP.md`. Nomor yang hilang (PAGE-02, 03, 10) memang dihapus dari scope, bukan salah tulis.
- **Direvisi ke v3.0** — perubahan besar dari v2.0:
  1. **Member tidak lagi memberi poin.** No. HP kini murni untuk pencocokan member POS demi laporan internal merchant — tidak memengaruhi harga, diskon, atau SPA pada transaksi self-order.
  2. **Identitas pindah dari chip+sheet ke field inline** di layar Konfirmasi (label "Data Pelanggan · opsional"), tanpa tombol submit, tanpa umpan balik visual apa pun ke tamu.
  3. **Perubahan ini hanya berlaku di QR Statis.** QR Dinamis sengaja belum diselaraskan — lihat §6.3 dan §10 #7.
  4. **Bagikan Struk jadi Email saja.** Channel WhatsApp dihapus.
  5. **Voucher diganti nama jadi Promo**, dengan kategorisasi baru: **Promo Produk** vs **Diskon Transaksi** — lihat §6 (Kategori Promo).

Urutan baca yang disarankan untuk developer: §3 Scope → §4 Alur → §6 Spesifikasi Halaman (baca dulu subbagian **Kategori Promo** di paling atas §6) → §7 Komponen Bersama → §9 Lapis Teknis.

---

## 1. Executive Summary

**Self Order** adalah fitur pemesanan mandiri berbasis **web mobile** (browser HP, tanpa instalasi aplikasi) untuk pelanggan restoran Accurate POS. Pelanggan memindai QR Code di meja, memilih menu, mengelola keranjang (termasuk promo), lalu membayar — tanpa menunggu waiter.

Tiga karakter utama MVP:

1. **Tanpa login, tanpa OTP, tanpa akun.** Tamu selalu guest secara teknis. Nomor HP bersifat opsional dan dipakai hanya untuk pencocokan member POS demi laporan internal — bukan kredensial, dan **tidak memberi poin atau harga khusus** pada transaksi self-order.
2. **Bayar di muka.** Pesanan dibayar sebelum masuk dapur, lewat QRIS atau di kasir. Open Bill (bayar belakangan) tidak termasuk MVP.
3. **Selesai di struk.** Setelah bayar, tamu menerima konfirmasi & bisa mengirim struk lewat email. Tidak ada pelacakan antrean di MVP.

## 2. Problem Statement

Restoran pada jam ramai menghadapi tiga masalah:

- Tamu menunggu lama hanya untuk memesan, karena waiter terbatas.
- Beban staf tinggi saat ramai — mencatat pesanan manual rawan salah.
- Tamu tidak tahu stok habis atau promo yang berlaku saat memesan, sehingga sering bolak-balik konfirmasi.

Self Order memindahkan proses pesan dan bayar ke tangan tamu, dengan validasi stok & promo real-time dari POS.

## 3. Scope

### In Scope (MVP)

| Area | Cakupan |
|---|---|
| Platform | Web mobile (browser HP), tanpa instalasi aplikasi. Tampilan **Klasik** (`MenuClassicScreen`) — shell sidebar sudah dihapus dari produk. |
| Tipe QR | **QR Statis** (tempel di meja, konteks "Pesan Mandiri") dan **QR Dinamis** (per sesi meja, konteks "Meja {nomor}"). Keduanya bayar di muka. **Identitas opsional (lihat baris berikut) cuma diperbarui di QR Statis** — QR Dinamis belum diselaraskan. |
| Identitas | Tanpa login. Nomor HP opsional lewat field **"Data Pelanggan · opsional"** di layar Konfirmasi (**khusus QR Statis**) — untuk pencocokan member POS demi laporan internal merchant; **tidak memengaruhi harga, diskon, SPA, atau poin**. QR Dinamis untuk sementara masih pakai mekanisme lama (field Nama + Nomor HP + chip "Masuk"), belum diselaraskan — lihat §6.3 dan §10 #7. |
| Katalog | Menu live dari POS, pencarian, kategori, penanda habis (86) real-time, empty state. |
| Keranjang | Kelola qty, catatan dapur, hapus item lewat qty→0 + dialog konfirmasi, ringkasan biaya. |
| Promo | **Promo Produk** (barang gratis atau diskon produk, otomatis berdasar kuantitas/nominal — lihat Kategori Promo di §6) & **Diskon Transaksi** (dipilih tamu dari halaman Promo, maks 1 aktif, bisa dilepas). Boleh menumpuk satu sama lain. |
| Validasi | Popup adaptif saat "Konfirmasi Pesanan" — stok habis, harga naik, promo/SPA berakhir, atau kombinasinya. |
| Pembayaran | **QRIS** (kode + countdown 5 menit + polling) dan **Bayar di Kasir** (kode referensi + cek status manual). |
| Struk | Bagikan struk lewat **Email**, lengkap dengan state validasi & gagal kirim. |
| Tipe pesanan | Dine In / Take Away ditandai **per item** di Menu, dikelompokkan di Keranjang. |
| Error jaringan | Satu komponen global untuk seluruh halaman. |

### Out of Scope

| Yang dikecualikan | Alasan |
|---|---|
| **Open Bill / bayar belakangan** | Seluruh alur (bill terbuka per meja, tambah order bertahap, Kirim ke Dapur, Lihat Tagihan Berjalan, Tutup & Bayar) didorong ke rilis berikutnya. |
| **Waiting List / pelacakan antrean** | Handoff ke modul Waiting List keluar dari MVP. Tamu tidak dapat nomor antrean maupun estimasi waktu; alur berhenti di layar Selesai & Struk. |
| **Login, OTP, akun tamu** | Tidak ada mekanisme autentikasi apa pun. Tidak ada pengiriman/verifikasi kode. |
| **Poin / loyalty program** | Member di Self Order MVP murni identifikasi untuk laporan POS internal. **Tidak ada poin, saldo, atau riwayat** yang dihitung, disimpan, atau ditampilkan ke tamu dari transaksi self-order. |
| **Pendaftaran member baru di app** | Tamu yang ingin jadi member diarahkan ke kasir. |
| **Penyelarasan QR Dinamis** | Field identitas versi baru (§6.3) cuma diterapkan di QR Statis. QR Dinamis sengaja belum disentuh — masih pakai field Nama+Nomor HP & chip "Masuk" versi lama. Bukan keputusan final, menunggu digarap terpisah. |
| **Dampak tipe pesanan ke Checkout** | Penanda Dine In/Take Away tidak dibawa ke Konfirmasi, struk, maupun tiket dapur — lihat §3.1. |
| **Double-payment guard** | Pencegahan bayar ganda tidak dispesifikasikan — lihat §3.1. |
| **Channel bayar selain QRIS & kasir** | Transfer bank / VA belum masuk. |
| **Channel struk selain Email** | WhatsApp untuk pengiriman struk dihapus dari MVP. |
| **Mode gelap** | Light mode only. |

### 3.1 Risiko yang Diterima Sadar

Dua hal berikut **sengaja** tidak ditangani di MVP. Dicatat agar developer & QA tidak menganggapnya bug.

**Tipe pesanan tidak sampai ke dapur.** Tamu bisa menandai tiap item sebagai Dine In atau Take Away, dan Keranjang mengelompokkannya. Tapi penanda ini **berhenti di Keranjang** — Konfirmasi, struk, dan tiket dapur tidak membedakannya. Konsekuensinya: dapur tidak tahu item mana yang harus dibungkus. Penanganannya sementara manual (staf bertanya ke tamu). Desain untuk membawa tipe sampai Checkout belum dibuat.

**Bayar ganda mungkin terjadi.** Kalau tamu me-refresh halaman saat QRIS pending lalu membayar lagi, sistem tidak mencegahnya. Penyelesaian dilakukan manual oleh kasir. Idempotency key / guard di sisi backend tidak dispesifikasikan di MVP.

## 4. Alur & Page Map

### Alur utama (satu-satunya alur MVP, QR Statis)

```
PAGE-01  Landing / QR Entry
   ↓
PAGE-04  Menu / Katalog  ⇄  PAGE-05  Detail Item
   ↓                          ↑
PAGE-06  Keranjang  ─────────┘
   │  └─→ PAGE-06V  Promo               (kondisional)
   ↓  [tap "Konfirmasi Pesanan" → validasi server]
   │
   ├─ ada masalah →  ValidationPopup (di atas Keranjang) → kembali ke PAGE-06
   │
   ↓  bersih
PAGE-08  Konfirmasi Pesanan   [field "Data Pelanggan · opsional" — No. HP, tanpa tombol]
   ↓  [pilih metode bayar → tap "Bayar"]
PAGE-09  Pembayaran  — QRIS (ProcessingScreen) / Bayar di Kasir (CashStatusScreen)
   ↓  [QRIS: lunas terdeteksi · Kasir: tamu tap "Cek Status Pesanan" setelah kasir tandai lunas]
PAGE-11  Selesai & Struk   [→ ShareReceiptSheet, email saja]
   ↓
kembali ke PAGE-04
```

Tidak ada gate login di titik mana pun. Tidak ada cabang Open Bill. Diagram ini menggambarkan **QR Statis** — QR Dinamis memakai alur & konteks yang sama, tapi field identitas di PAGE-08 masih versi lama (lihat §6.3).

### Page Map

| Page ID | Nama | Bentuk | Diakses dari |
|---|---|---|---|
| PAGE-01 | Landing / QR Entry | Halaman | Scan QR |
| PAGE-04 | Menu / Katalog | Halaman | PAGE-01; kembali dari 05/06 |
| PAGE-04V | Promo Hari Ini (Katalog) | Halaman | PAGE-04, tap "Lihat Semua" di rail Promo Hari Ini |
| PAGE-05 | Detail Item & Tambah ke Keranjang | Bottom sheet / halaman | PAGE-04 |
| PAGE-06 | Keranjang | Halaman | PAGE-04, PAGE-05 |
| PAGE-06V | Promo | Sheet / halaman | PAGE-06 |
| — | Validasi Keranjang (`ValidationPopup`) | Popup di atas PAGE-06 | PAGE-06, saat "Konfirmasi Pesanan" |
| PAGE-08 | Konfirmasi Pesanan (`ConfirmScreen`) | Halaman | PAGE-06 |
| PAGE-09 | Pembayaran | Halaman | PAGE-08 |
| PAGE-11 | Selesai & Struk | Halaman | PAGE-09 |
| — | Bagikan Struk (`ShareReceiptSheet`) | Bottom sheet | PAGE-11 |

> PAGE-02, PAGE-03 (login & OTP) dan PAGE-10 (Open Bill) dihapus dari scope. Nomornya tidak dipakai ulang. **Tidak ada lagi entri `PoinMemberSheet`** di Page Map — mekanisme itu diganti field inline di PAGE-08 (§6.3) untuk QR Statis; sheet lama masih dipakai apa adanya di QR Dinamis untuk sementara.

## 5. Feature List

| FR ID | Deskripsi | Halaman |
|---|---|---|
| FR-01 | Entry & routing QR (statis / dinamis) | PAGE-01 |
| FR-02 | Browse katalog menu — pencarian, kategori, penanda habis | PAGE-04 |
| FR-02b | Katalog lengkap promo (Promo Produk + Diskon Transaksi), read-only, dari "Lihat Semua" | PAGE-04V |
| FR-03 | Detail item & tambah ke keranjang — opsi berbayar, qty, catatan | PAGE-05 |
| FR-04 | Kelola keranjang — qty, catatan, hapus via dialog konfirmasi | PAGE-06 |
| FR-05b | Pakai Diskon Transaksi (Promo) — pilih dari daftar, syarat & potongan eksplisit, maks 1 aktif | PAGE-06V |
| FR-06 | Promo Produk otomatis & klaim item gratis (auto-apply, berapa pun jumlah varian — dipilih sistem berdasar harga satuan terkecil) | PAGE-06 |
| FR-07b | Identitas opsional (No. HP) — field inline di Konfirmasi, khusus QR Statis; untuk laporan member POS, tidak memengaruhi harga/poin | PAGE-08 |
| FR-08 | Validasi keranjang adaptif — stok / harga / promo / SPA | `ValidationPopup` |
| FR-09 | Konfirmasi pesanan — ringkasan + metode bayar dalam satu layar | PAGE-08 |
| FR-10 | Pembayaran — QRIS & Bayar di Kasir | PAGE-09 |
| FR-12 | Konfirmasi selesai — ringkasan transaksi | PAGE-11 |
| FR-13 | Bagikan struk — Email, dengan state validasi & gagal kirim | PAGE-11 |
| FR-14 | Manajemen sesi & error lintas-halaman | Semua |
| FR-15 | Tipe pesanan per item (Dine In / Take Away) | PAGE-04, PAGE-06 |

---

## 6. Spesifikasi Halaman

> Halaman yang **tidak** disebut berubah di sini dianggap **tidak berubah** dari v2.0.

### Kategori Promo (baca dulu — dipakai di beberapa halaman)

Self Order membedakan promo jadi **dua kategori**, berdasar **di mana hasilnya jatuh** — bukan berdasar apa yang memicunya.

| Kategori | Hasil jatuh di | Bentuk hasil | Perilaku | Contoh |
|---|---|---|---|---|
| **Promo Produk** | Produk tertentu | Barang gratis **atau** diskon pada produk itu sendiri | Otomatis. Tamu **tidak bisa** memilih atau melepasnya. | "Beli 1, gratis Ayam Goreng" · "Beli 2, diskon 20%" |
| **Diskon Transaksi** | Total belanja | Potongan rupiah dari total | Dipilih tamu di halaman **Promo** (PAGE-06V), tombol "Pakai" ↔ "Dipakai", **maksimal 1 aktif**. | "Diskon 20% min. belanja Rp100.000" · "Potongan Rp15.000" |

**Syarat pemicu yang didukung Self Order cuma dua: kuantitas barang & nominal transaksi.** Pemicu **tidak menentukan kategori** — "Beli 2, diskon 20%" dipicu kuantitas tapi tetap **Promo Produk**, karena hasilnya (diskon) jatuh di produk itu, bukan di total belanja.

**Tes cepat pembeda:** hapus item pemicunya dari keranjang. Kalau promonya ikut hilang → **Promo Produk**. Kalau promonya cuma hilang saat total belanja turun di bawah minimum → **Diskon Transaksi**.

**Di mana masing-masing muncul:**

- **Promo Produk** — section "Informasi Promo" di detail item, rail "Promo Hari Ini" di Menu (`OfferHeader`/`OfferRail`/`OfferCard`), baris "Gratis"/diskon di Keranjang, **dan PAGE-04V (katalog lengkap dari "Lihat Semua")** — read-only di semua tempat, tamu tidak pernah bisa memilih/mengklaimnya. **Tidak muncul di halaman Promo (PAGE-06V, dari Keranjang)** — halaman itu khusus Diskon Transaksi, lihat §10 keputusan #26/#27. **Tidak ada penanda di kartu Menu** — lihat §6 PAGE-04.
- **Diskon Transaksi** — halaman **Promo** (PAGE-06V, CTA dari Keranjang, **bisa** "Pakai" di sini) dan **PAGE-04V** (katalog dari Menu, read-only, **tanpa** tombol Pakai — lihat §10 keputusan #27).

**Boleh menumpuk.** Promo Produk & Diskon Transaksi bisa aktif bersamaan. Urutan hitung: Promo Produk diterapkan lebih dulu, Diskon Transaksi dihitung dari nilai setelahnya.

**Prioritas antar-sesama Promo Produk.** Satu barang boleh ke-match lebih dari satu Promo Produk sekaligus. Di Menu/PAGE-05, semua promo yang nempel ditampilkan (deklaratif). Tapi yang benar-benar diapply di Keranjang cuma **satu**: syarat **kuantitas-barang** menang atas syarat **nominal-transaksi**; kalau dua promo sejenis bentrok (sama-sama kuantitas atau sama-sama nominal), yang menang adalah promo dengan **nilai hasil lebih kecil**. Promo yang kalah tidak berefek sama sekali ke item itu di transaksi tersebut. Detail & contoh angka: [[SO_Case_PromoProdukAutoApply]].

> Referensi desain: Figma → page **↳ Fondasi & Panduan** → kartu **"🏷 Kategori Promo"**; catatan singkat juga ada di page ↳ Menu & Katalog, section "Case: Lihat Promo Hari Ini".

---

### PAGE-01 — Landing / QR Entry

**Route:** `https://order.accuratepos.id/s/{venueId}/{qrToken}` (statis) atau `https://order.accuratepos.id/d/{venueId}/{sessionToken}` (dinamis).

**Tujuan:** Memvalidasi QR, me-resolve konteks (venue, meja, tipe QR), memuat menu live, lalu mengarahkan tamu ke katalog.

**Element Inventory**

1. Logo / nama restoran — dinamis dari venue; tengah atas; tampil setelah resolve sukses.
2. Indikator konteks — chip; "Meja {nomorMeja}" (dinamis) atau "Pesan Mandiri" (statis); di bawah logo.
3. Spinner + pesan loading — tengah.
4. Tombol "Lihat Menu" — primary; menuju PAGE-04.
5. Area error — panel tengah.

**States**

| State | Tampilan |
|---|---|
| default | Logo + konteks, lalu auto-redirect ke PAGE-04 (atau tombol "Lihat Menu") |
| loading | Spinner + "Menyiapkan menu…" |
| error | Panel error sesuai Validation Rules + tombol "Coba Lagi" |
| success | Redirect ke PAGE-04 |
| disabled | Tombol "Lihat Menu" disabled selama loading |

**Validation Rules**

| Field | Aturan | Pesan error (persis) |
|---|---|---|
| qrToken / sessionToken | Wajib ada & valid di server | "QR tidak dikenali. Minta bantuan staf, ya." |
| sessionToken (dinamis) | Belum kedaluwarsa | "Sesi meja ini sudah berakhir. Pindai ulang QR di meja atau hubungi staf." |
| Status venue | Aktif & Self Order menyala | "Pemesanan mandiri sedang tidak tersedia di restoran ini." |

**Copy Bank**

| Key | Teks final |
|---|---|
| loading_msg | "Menyiapkan menu…" |
| ctx_static | "Pesan Mandiri" |
| ctx_dynamic | "Meja {nomorMeja}" |
| btn_view_menu | "Lihat Menu" |
| err_invalid_qr | "QR tidak dikenali. Minta bantuan staf, ya." |
| err_expired_session | "Sesi meja ini sudah berakhir. Pindai ulang QR di meja atau hubungi staf." |
| err_venue_off | "Pemesanan mandiri sedang tidak tersedia di restoran ini." |
| btn_retry | "Coba Lagi" |

**Edge Cases**

- Resolve lebih dari 10 detik → tetap loading; saat timeout tampilkan error + "Coba Lagi", konteks URL tidak hilang.
- Tamu membuka ulang URL statis lama → resolver tetap memuat menu terbaru.
- QR dinamis sudah ditutup kasir → error kedaluwarsa.

**Acceptance Criteria**

- **AC-01.1** — Given tamu memindai QR statis valid, When resolve sukses, Then menu live dimuat dan tamu diarahkan ke PAGE-04 dengan konteks "Pesan Mandiri".
- **AC-01.2** — Given tamu memindai QR dinamis valid, When resolve sukses, Then PAGE-04 terbuka dengan konteks "Meja {nomorMeja}".
- **AC-01.3** — Given token tidak dikenali server, When resolve gagal, Then tampil "QR tidak dikenali. Minta bantuan staf, ya." dan tombol "Coba Lagi".
- **AC-01.4** — Given QR dinamis kedaluwarsa, When resolve, Then tampil err_expired_session dan tamu tidak dapat lanjut ke menu.
- **AC-01.5** — Given resolve melebihi 10 detik, When timeout, Then tampil error koneksi + "Coba Lagi" tanpa kehilangan konteks URL.

---

### PAGE-04 — Menu / Katalog

**Route:** `/menu` (konteks sesi dipertahankan).
**Tujuan:** Menampilkan katalog live dan memfasilitasi pencarian serta penambahan item.

**Element Inventory**

1. Header konteks — "Pesan Mandiri" atau "Meja {nomorMeja}".
2. `OrderTypePills` — pemilih tipe pesanan (Dine In / Take Away). Lihat §6.1.
3. Search bar — placeholder "Cari menu…", filter real-time.
4. `CategoryTabs` — chip kategori horizontal scroll; filter/jump ke kategori.
5. `PromoRail` (dulu `VoucherRail`) + `OfferRail` — di area Hero; menampilkan Diskon Transaksi & Promo Produk yang sedang berjalan, satu kalimat gabungan syarat+hasil pakai nama promo apa adanya (mis. "Beli 1, gratis Ayam Goreng" — tanpa nominal rupiah). **Murni informasi** — tap kartu di rail tidak menambah item, tidak membuka aksi apa pun, tidak menavigasi ke item tertentu di grid (lihat [[SO_Case_PromoProdukAutoApply]]).
6. Kartu item — foto, nama, harga, tombol "Tambah". Item habis → badge "Habis", kartu redup, tombol "Habis" (disabled). Promo Produk **tidak lagi punya penanda di kartu** — info-nya cukup lewat `PromoRail`/`OfferRail` di atas.
7. `CartDock` (floating cart bar) — "{n} item · Rp{subtotal}" + "Lihat Keranjang"; muncul bila keranjang berisi; menuju PAGE-06 **tanpa syarat apa pun**.

**States**

| State | Tampilan |
|---|---|
| default | Kategori & item live; CartDock muncul bila keranjang berisi |
| empty (cari) | "Menu tidak ditemukan. Coba kata kunci lain." |
| empty (venue) | "Menu belum tersedia. Hubungi staf, ya." |
| loading | Skeleton kartu item |
| error | "Gagal memuat menu. Coba lagi." + tombol "Coba Lagi" |
| success | Toast "Ditambahkan ke keranjang" + badge cart bertambah |
| disabled | Tombol item habis disabled |

**Validation Rules**

| Field | Aturan | Pesan error (persis) |
|---|---|---|
| Pencarian | Maks 50 karakter | "Kata kunci terlalu panjang." |
| Ketersediaan item | Item habis tidak dapat ditambah | "Menu ini sedang habis." |

**Copy Bank**

| Key | Teks final |
|---|---|
| ph_search | "Cari menu…" |
| badge_soldout | "Habis" |
| btn_add | "Tambah" |
| btn_soldout | "Habis" |
| cart_bar | "{n} item · Rp{subtotal}" |
| btn_view_cart | "Lihat Keranjang" |
| toast_added | "Ditambahkan ke keranjang" |
| empty_search | "Menu tidak ditemukan. Coba kata kunci lain." |
| empty_menu | "Menu belum tersedia. Hubungi staf, ya." |
| err_load | "Gagal memuat menu. Coba lagi." |
| btn_retry | "Coba Lagi" |

**Edge Cases**

- Item menjadi habis saat tamu melihat menu → badge "Habis" muncul real-time.
- Harga berubah dari server → kartu memperbarui harga; dampaknya ke keranjang ditegaskan lagi saat validasi (`ValidationPopup`).
- Item dengan opsi wajib → tombol "Tambah" membuka PAGE-05, bukan quick-add.

**Acceptance Criteria**

- **AC-04.1** — Given menu berhasil dimuat, When PAGE-04 tampil, Then kategori & item ditampilkan dengan harga dan ketersediaan terkini.
- **AC-04.2** — Given sebuah item habis, When ditampilkan, Then kartu menampilkan badge "Habis" dan tombol "Habis" (disabled).
- **AC-04.3** — Given tamu mengetik kata kunci tanpa hasil, When pencarian dijalankan, Then tampil "Menu tidak ditemukan. Coba kata kunci lain."
- **AC-04.4** — Given keranjang berisi ≥1 item, When PAGE-04 tampil, Then CartDock menampilkan jumlah item & subtotal dan dapat menuju PAGE-06.
- **AC-04.5** — Given tamu belum mengisi identitas apa pun, When menekan "Lihat Keranjang", Then tamu langsung masuk PAGE-06 tanpa diminta login.

#### 6.1 Tipe Pesanan (Dine In / Take Away)

- `OrderTypePills` di PAGE-04 menetapkan tipe untuk **item yang ditambahkan setelahnya**. Item yang sudah ada di keranjang **tidak** ikut berubah.
- Di PAGE-06 item dikelompokkan per section "Dine In · N item" / "Take Away · N item". Subtotal, pajak, dan total tetap **gabungan** — tidak dipecah per grup.
- Tipe **tidak** dibawa ke PAGE-08, struk, maupun tiket dapur. Lihat risiko di §3.1.

- **AC-04.6** — Given tamu mengganti tipe pesanan lewat `OrderTypePills`, When tipe diganti, Then item yang sudah ada di keranjang tidak berubah tipenya dan keranjang tidak di-reset.

---

### PAGE-04V — Promo Hari Ini (Katalog)

**Route:** Dari tap **"Lihat Semua"** (chevron `see-all` di `OfferHeader`) pada rail "Promo Hari Ini" di PAGE-04.
**Tujuan:** Katalog lengkap **semua** promo yang sedang aktif di venue — **Promo Produk maupun Diskon Transaksi** — murni buat discovery/browsing. **Tidak ada aksi apply di halaman ini**, beda dari PAGE-06V:

| | PAGE-04V (halaman ini) | PAGE-06V (dari Keranjang) |
|---|---|---|
| Diakses dari | PAGE-04 (Menu), tap "Lihat Semua" | PAGE-06 (Keranjang), CTA "Promo" |
| Isi | Promo Produk **+** Diskon Transaksi | **Cuma** Diskon Transaksi |
| Diskon Transaksi bisa "Pakai" di sini? | **Tidak** — read-only, tanpa tombol | **Ya** — tombol "Pakai"↔"Dipakai" |
| Promo Produk bisa diklaim di sini? | Tidak — selalu read-only, di mana pun (§6) | — (gak ditampilkan di sini) |

Diskon Transaksi cuma bisa benar-benar dipakai dari PAGE-06V. Promo Produk otomatis kepotong begitu tamu menambah item pemicunya ke Keranjang lewat alur normal — bukan lewat halaman promo mana pun (§6 Kategori Promo).

**Prinsip "1 paragraf deskriptif, bukan bullet."** Kartu nampilin **judul hasil (singkat, ramah) + 1 paragraf deskripsi** (bukan list bullet) yang jelasin hasil + batas maksimalnya — **bukan syarat pemicu** (syarat gak disebut di kartu ini). Detail lengkap template kalimat: [[SO_Case_TemplateDeskripsiPromo]]. Ini berlaku juga di PAGE-06V (lihat di sana) — cuma beda di PAGE-06V ada tombol Pakai/Dipakai juga.

**Tidak ada pemisah section.** Promo Produk dan Diskon Transaksi **digabung jadi satu list**, tidak dipisah label/section — tamu tidak perlu tahu bedanya kategori internal ini.

**Element Inventory**

1. `PromoCard` per promo aktif venue (Promo Produk maupun Diskon Transaksi, **komponen & bentuk visual sama persis**, tidak ada badge/label pembeda kategori):
   - **Judul** = hasil, kalimat pendek dan ramah (mis. "Diskon 20%", "Gratis Es Jeruk", "Diskon Rp5.000").
   - **Paragraf deskripsi 1 baris** (font Inter Regular 12px, warna netral, wrap natural, **tanpa dot/bullet**) — pakai salah satu dari 4 template di [[SO_Case_TemplateDeskripsiPromo]], mis. "Diskon 20% pada Ayam Goreng. Maksimum 1 barang terdiskon dalam satuan pcs." atau "Diskon 20% pada transaksi. Maksimum potongan Rp30.000." "Gratis" ditulis sebagai "Diskon 100%" di paragraf (satu aturan buat kedua kasus).
   - **Chevron ">"** di kanan, vertically centered — nandain kartu tappable ke `DetailPromoSheet`. Tidak ada badge "Otomatis" atau tombol apa pun di halaman ini.
2. Banner promosi opsional — sama seperti PAGE-06V, hidden by default.

**`DetailPromoSheet` — buat baca "Deskripsi" versi lebih panjang / (rencana) syarat pemicu.** Kartu di list ini sengaja gak nyebut syarat pemicu (lihat [[SO_Case_TemplateDeskripsiPromo]] § Pertanyaan Terbuka) — kalau ke depan itu perlu ditampilkan, di sinilah tempatnya. Isi sheet beda per tipe:

| | `DetailPromoSheet Type=Transaksi` ("Detail Voucher") | `DetailPromoSheet Type=Produk` ("Detail Promo") |
|---|---|---|
| Header | Judul hasil (mis. "Diskon 20%") + subjudul syarat ringkas | Judul hasil (mis. "Gratis Es Jeruk") + subjudul "{item pemicu} · Rp{harga}" |
| Section "Syarat" | Cuma **syarat qualifying**, gabung min+maks jadi **1 baris**: **"Minimal transaksi Rp{nominal} (Maksimal {nominal_cap})"** — mis. "Minimal transaksi Rp100.000 (Maksimal 30.000)". Ganti dari copy lama "Min. belanja Rp100.000" (subjudul header pakai copy yang sama, biar konsisten). | Sama — buat Promo Produk syarat-nya kuantitas/nominal pemicu (mis. "Beli 2 Ayam Goreng"), bukan batas kuantitas hasil (mis. "Maksimum 1 barang" — itu bagian hasil, di Deskripsi) |
| Bullet Syarat | **Dot netral** — **bukan** `Icon/checkCircle`. Checkmark keliru nyiratin syarat udah kepenuhi padahal belum tentu. | Sama, dot netral. |
| Section **"Periode Promosi"** *(baru)* | Kotak bordered (sama gaya dengan box "Syarat") — baris 1: tanggal (`Icon/calendar` + "{tglMulai} - {tglAkhir}") **sejajar 1 baris** dengan hari (`Icon/repeat` + "Setiap hari" atau nama hari spesifik — **beda icon dari tanggal**, biar gak ketuker "calendar yang mana"); baris 2: jam (`Icon/clock` + "{jamMulai} - {jamAkhir}"). Posisi: antara "Syarat" dan "Deskripsi". | Sama, komponen & posisi identik. |
| "Deskripsi" (dulu "Syarat & Ketentuan") | Paragraf penjelasan diskon | Paragraf mekanisme promo + baris "Promo diterapkan otomatis di Keranjang saat syarat terpenuhi." |
| Footer | Tombol **"Mengerti"** — dismiss doang, **bukan** "Pakai". Apply Diskon Transaksi tetap lewat tombol di kartu list PAGE-06V. | Tombol **"Mengerti"** — dismiss doang, tidak ada jalan klaim apa pun. |

**Format teks "hari" — sudah diputuskan (lihat detail & contoh di [[SO_Case_TemplateDeskripsiPromo]]):** "Setiap hari" (7 hari) · "Hari {hari}" (1 hari) · "Hari {awal} Sampai {akhir}" (≥2 hari berurutan, mis. "Hari Senin Sampai Sabtu") · fallback daftar disingkat kalau gak berurutan (belum ada contoh Figma). Baris tanggal+hari otomatis wrap ke baris baru kalau teksnya kepanjangan buat 1 baris (`layoutWrap`), gak kepotong.

**Periode Promosi — batasan yang masih terbuka:** Contoh yang dibangun cuma menangani **1 rentang jam aktif per hari**. Admin (POS/Accurate Online) bisa nambah lebih dari satu rentang jam ("+ Tambah Jam Aktif") — itu belum ada aturan tampilnya di Self Order.

**Urutan tampil.** Seluruh kartu (Promo Produk + Diskon Transaksi campur jadi satu list) diurutkan alfabetis A→Z (ASCII) berdasar judul hasil.

**States**

| State | Tampilan |
|---|---|
| default | Satu list gabungan, terurut A→Z — tiap kartu judul + 1 paragraf deskripsi |
| empty (total) | Tidak ada promo aktif sama sekali di venue → "Belum ada promo yang berlaku hari ini" + ilustrasi kosong |

**Copy Bank**

| Key | Teks final |
|---|---|
| empty_katalog | "Belum ada promo yang berlaku hari ini" |
| sheet_title_produk | "Detail Promo" |
| sheet_title_transaksi | "Detail Voucher" |
| sheet_label_syarat | "Syarat" |
| sheet_label_periode | "Periode Promosi" |
| sheet_periode_hari_setiap | "Setiap hari" |
| sheet_label_deskripsi | "Deskripsi" |
| sheet_note_auto | "Promo diterapkan otomatis di Keranjang saat syarat terpenuhi." |
| btn_sheet_dismiss | "Mengerti" |

**Acceptance Criteria**

- **AC-04V.1** — Given tamu menekan "Lihat Semua" di rail "Promo Hari Ini" (PAGE-04), When ditekan, Then PAGE-04V terbuka menampilkan satu list gabungan Promo Produk dan Diskon Transaksi yang sedang aktif, tanpa pemisah section.
- **AC-04V.2** — Given ada Diskon Transaksi aktif, When PAGE-04V tampil, Then kartunya tampil judul hasil + 1 paragraf deskripsi (hasil + batas maksimal, pakai template [[SO_Case_TemplateDeskripsiPromo]]) + chevron ">" di kanan, **tanpa** tombol Pakai/Ganti/Dipakai, **tanpa** bullet dot.
- **AC-04V.3** — Given ada Promo Produk aktif, When PAGE-04V tampil, Then kartunya tampil sebagai `PromoCard` (bentuk sama dengan Diskon Transaksi) — judul hasil + 1 paragraf deskripsi + chevron ">", **tanpa** badge "Otomatis" atau label kategori apa pun. Kalau hasilnya barang-gratis, paragraf tetap ditulis sebagai "Diskon 100%" (bukan kalimat "gratis" terpisah).
- **AC-04V.4** — Given tidak ada promo aktif sama sekali di venue, When PAGE-04V tampil, Then tampil empty state "Belum ada promo yang berlaku hari ini".
- **AC-04V.5** — Given lebih dari satu kartu tampil, When PAGE-04V tampil, Then seluruh kartu (Produk maupun Transaksi campur) terurut alfabetis A→Z berdasar judul hasil, tidak dikelompokkan per kategori.
- **AC-04V.7** — Given `DetailPromoSheet` terbuka (tipe apa pun), When section "Syarat" tampil, Then tiap baris pakai bullet dot netral, **bukan** `Icon/checkCircle` — supaya tidak menyiratkan syarat sudah terpenuhi.

---

### PAGE-05 — Detail Item & Tambah ke Keranjang

**Route:** Bottom sheet / halaman dari kartu item di PAGE-04.
**Tujuan:** Menampilkan detail item dan mengonfigurasi pesanan sebelum masuk keranjang.

**Element Inventory**

1. Foto item — atas.
2. Nama, deskripsi, harga dasar.
3. **"Informasi Promo"** — bentuknya beda tergantung jumlah Promo Produk yang nempel di item:
   - **1 promo:** row statis, tanpa chevron/tap-target. Copy: "Item ini diberlakukan Promo: {syarat & hasil}", mis. "Beli 1, gratis Ayam Goreng". Ditambah 1 baris kecil: "Promo diterapkan otomatis di Keranjang saat syarat terpenuhi."
   - **>1 promo:** row jadi ringkasan tappable — "Item ini berlaku {N} promo" + chevron. Tap membuka `PromoListSheet` (lihat Komponen Bersama §7): daftar semua promo item itu, tiap kartu mandiri (nama promo, syarat, hasil, catatan auto-apply) — **dead-end**, tidak ada aksi tap lanjutan di dalam sheet ini.
   - Aturan prioritas soal mana yang benar-benar diapply di Keranjang (kalau syaratnya bentrok): lihat [[SO_Case_PromoProdukAutoApply]].
4. Grup opsi — radio (wajib pilih satu) atau checkbox (bisa lebih dari satu). Ditandai "Wajib" bila perlu.
5. `OptionRow` per opsi — label + slot harga opsional.
6. Stepper jumlah — "−" / "+", default 1, minimum 1.
7. Catatan untuk dapur — textarea, opsional, maks 140 karakter.
8. Tombol tambah — "Tambah • Rp{totalItem}", mengikuti total live.

**Aturan harga opsi.** Setiap opsi di grup mana pun boleh punya delta harga sendiri, ditampilkan sebagai `+RpX.000` di sebelah label. **Bukan hanya grup "Tambahan" yang berbayar** — opsi wajib (radio) juga bisa menambah harga. Opsi tanpa delta tidak menampilkan teks harga sama sekali.

Contoh nyata (item "Nasi Ayam Bakar Madu", harga dasar Rp45.000):

| Grup | Tipe | Opsi | Delta |
|---|---|---|---|
| Tingkat Pedas | radio, wajib | Tidak Pedas / Sedang / Pedas | — |
| Tingkat Pedas | radio, wajib | Extra Pedas | +Rp3.000 |
| Tambahan | checkbox | Nasi Putih | +Rp8.000 |
| Tambahan | checkbox | Telur Dadar | +Rp7.000 |
| Tambahan | checkbox | Kerupuk Udang | +Rp5.000 |

Total tombol = (harga dasar + delta radio terpilih + jumlah semua delta checkbox terpilih) × qty.

**States**

| State | Tampilan |
|---|---|
| default | Opsi default terpilih bila ada, qty 1, tombol menampilkan total |
| loading | Memuat detail item / harga opsi |
| error | "Gagal memuat detail menu. Coba lagi." atau inline "Pilih dulu {namaGrup}." |
| success | Toast "Ditambahkan ke keranjang", kembali ke PAGE-04 |
| disabled | Tombol "Tambah" disabled bila opsi wajib belum lengkap; stepper "−" disabled di qty 1 |

**Validation Rules**

| Field | Aturan | Pesan error (persis) |
|---|---|---|
| Opsi wajib | Tiap grup "Wajib" harus dipilih | "Pilih dulu {namaGrup}." |
| Jumlah | Minimum 1; maksimum = stok tersisa. **Tidak ada plafon lain.** | "Jumlah melebihi stok tersedia ({sisa})." |
| Catatan | Maks 140 karakter | "Catatan maksimal 140 karakter." |

**Copy Bank**

| Key | Teks final |
|---|---|
| label_required | "Wajib" |
| ph_note | "Contoh: tanpa sambal" |
| btn_add_total | "Tambah • Rp{totalItem}" |
| err_required_opt | "Pilih dulu {namaGrup}." |
| err_qty_stock | "Jumlah melebihi stok tersedia ({sisa})." |
| info_promo | "Item ini diberlakukan Promo: {syarat & hasil}" |
| info_promo_auto | "Promo diterapkan otomatis di Keranjang saat syarat terpenuhi." |
| info_promo_multi | "Item ini berlaku {n} promo" |
| err_note_len | "Catatan maksimal 140 karakter." |
| err_load_detail | "Gagal memuat detail menu. Coba lagi." |
| toast_added | "Ditambahkan ke keranjang" |
| toast_soldout | "Yah, menu ini baru saja habis." |

**Edge Cases**

- Item menjadi habis saat sheet terbuka → tombol "Tambah" disabled + toast "Yah, menu ini baru saja habis."; sheet tetap bisa ditutup.
- Stok tersisa kurang dari qty yang dipilih → qty dibatasi + pesan err_qty_stock.
- Harga opsi berubah dari server → total di tombol diperbarui sebelum item ditambahkan.

**Acceptance Criteria**

- **AC-05.1** — Given item punya grup opsi "Wajib", When tamu belum memilihnya, Then tombol "Tambah" disabled dan tampil "Pilih dulu {namaGrup}." saat mencoba menambah.
- **AC-05.2** — Given opsi & jumlah valid, When menekan "Tambah", Then item masuk keranjang dengan konfigurasi tepat dan tampil toast "Ditambahkan ke keranjang".
- **AC-05.3** — Given jumlah melebihi stok tersisa, When tamu menaikkan qty, Then qty dibatasi dan tampil "Jumlah melebihi stok tersedia ({sisa})."
- **AC-05.4** — Given item menjadi habis saat sheet terbuka, When status berubah, Then tombol "Tambah" disabled dan tampil toast "Yah, menu ini baru saja habis."
- **AC-05.5** — Given catatan lebih dari 140 karakter, When mengetik, Then input dibatasi dan tampil "Catatan maksimal 140 karakter."
- **AC-05.6** — Given sebuah opsi punya delta harga, When ditampilkan, Then `OptionRow` menampilkan `+RpX.000` di sebelah label; opsi tanpa delta tidak menampilkan teks harga.
- **AC-05.7** — Given tamu memilih ≥1 opsi Tambahan berbayar, When dipilih, Then total di tombol bertambah akumulatif sesuai seluruh opsi terpilih.
- **AC-05.8** — Given item punya Promo Produk aktif, When PAGE-05 tampil, Then section "Informasi Promo" menampilkan syarat & hasil promo tersebut beserta baris "Promo diterapkan otomatis di Keranjang saat syarat terpenuhi."
- **AC-05.9** — Given item ke-match lebih dari satu Promo Produk sekaligus, When PAGE-05 tampil, Then row "Informasi Promo" menampilkan ringkasan "Item ini berlaku {n} promo" dengan chevron, bukan detail tiap promo.
- **AC-05.10** — Given tamu menekan row ringkasan promo, When `PromoListSheet` terbuka, Then semua promo tampil sebagai kartu mandiri (nama, syarat, hasil, catatan auto-apply) tanpa elemen yang bisa ditekan di dalam kartu.

---

### PAGE-06 — Keranjang

**Route:** `/cart`, dari CartDock atau ikon keranjang.
**Tujuan:** Mengelola isi pesanan, melihat ringkasan biaya, dan memulai konfirmasi.

**Element Inventory**

1. Daftar item — nama + opsi terpilih, catatan, harga, stepper qty. Dikelompokkan per tipe pesanan bila campuran (§6.1).
2. Baris Promo Produk — item/diskon gratis tampil sebagai baris **"Gratis"** (atau nilai potongan) menempel item pemicunya. Tidak ada chip/aksi apa pun di baris ini — murni hasil auto-apply.
3. CTA **"Promo"** — tile ikon tag; menuju PAGE-06V.
4. `SummaryCard` — Subtotal, Diskon Transaksi bernama, Perkiraan Total.
5. Tombol utama **"Konfirmasi Pesanan"** — sticky bawah.
6. Tautan "Tambah Menu Lain" — kembali ke PAGE-04.

**States**

| State | Tampilan |
|---|---|
| default | Item, promo, subtotal tampil; tombol "Konfirmasi Pesanan" aktif |
| empty | Ilustrasi + "Keranjangmu masih kosong." + tombol "Lihat Menu" |
| loading | Menghitung ulang subtotal / promo |
| success | Subtotal & promo ter-update setelah perubahan |
| disabled | Tombol "Konfirmasi Pesanan" disabled saat keranjang kosong atau sedang menghitung |

**Validation Rules**

| Field | Aturan | Pesan error (persis) |
|---|---|---|
| Qty item | Minimum 1. Menurunkan ke 0 memicu dialog hapus. | — |

**Copy Bank**

| Key | Teks final |
|---|---|
| row_subtotal | "Subtotal" |
| row_discount | "Diskon" |
| row_total_est | "Perkiraan Total" |
| note_tax | "Pajak & total final dihitung saat konfirmasi." |
| btn_checkout | "Konfirmasi Pesanan" |
| link_add_more | "Tambah Menu Lain" |
| empty_cart | "Keranjangmu masih kosong." |
| btn_see_menu | "Lihat Menu" |
| cta_promo_title | "Promo" |
| cta_promo_sub | "Lihat promo yang bisa dipakai" |
| cta_promo_sub_active | "Promo dipakai" |
| dialog_delete_title | "Hapus item?" |
| dialog_delete_confirm | "Hapus" |
| dialog_delete_cancel | "Batal" |

**Hapus item.** Stepper qty diturunkan sampai 0 → `ConfirmDialog` "Hapus item?" muncul sebelum item benar-benar dihapus. Tombol "Hapus" memakai **warna oranye brand**, bukan merah (lihat §8). Bila item terakhir dihapus, keranjang masuk state empty.

**Edge Cases**

- Menghapus item terakhir → keranjang kembali ke state empty.
- Promo Produk (dapat-item) dengan >1 varian hadiah → sistem otomatis pilih varian harga satuan terkecil yang stoknya tersedia (tie-break: nama item A→Z); dengan 1 varian → langsung auto-apply. Tidak ada sheet pilihan di kedua kasus.
- Semua varian hadiah habis stok → hadiah tidak diklaim saat itu; ketahuan lewat `ValidationPopup` saat "Konfirmasi Pesanan" sebagai `IssueRow Type=Promo` (bukan `Type=Stock`) — tombol utama tetap **"Lanjut Bayar"** (auto-resolve, bukan keputusan manual). Tidak ada notifikasi baru di Keranjang. Copy pasti `IssueRow` untuk kasus ini belum final, lihat [[SO_Case_PromoProdukAutoApply]] Pertanyaan Terbuka.
- Satu item ke-match >1 Promo Produk sekaligus → cuma satu yang diapply (prioritas kuantitas-barang > nominal-transaksi, lalu nilai hasil terkecil kalau sejenis); yang lain tidak berefek ke item itu.
- Mengubah keranjang sehingga syarat promo gugur → Promo Produk & Diskon Transaksi terkait dilepas otomatis.

**Acceptance Criteria**

- **AC-06.1** — Given keranjang berisi item, When PAGE-06 tampil, Then daftar item, ringkasan biaya, dan tombol "Konfirmasi Pesanan" (aktif) tampil.
- **AC-06.4** — Given keranjang kosong, When PAGE-06 tampil, Then tampil state empty dengan tombol "Lihat Menu" dan tombol konfirmasi disabled.
- **AC-06.7** — Given tamu menurunkan qty item ke 0, When qty mencapai 0, Then `ConfirmDialog` "Hapus item?" muncul sebelum item dihapus.
- **AC-06.8** — Given tamu mengonfirmasi hapus pada item terakhir, When dikonfirmasi, Then keranjang menampilkan state empty.
- **AC-06.9** — Given tamu belum mengisi identitas apa pun, When menekan "Konfirmasi Pesanan", Then validasi server berjalan tanpa syarat login.
- **AC-06.10** — Given keranjang berisi item Dine In dan Take Away, When PAGE-06 tampil, Then item dikelompokkan per tipe dengan subtotal tetap gabungan.
- **AC-06.11** — Given Promo Produk barang-gratis punya ≥2 varian hadiah, When syarat terpenuhi, Then sistem otomatis menambahkan varian dengan harga satuan terkecil yang stoknya tersedia sebagai baris "Gratis", tanpa sheet pilihan.
- **AC-06.12** — Given satu item ke-match lebih dari satu Promo Produk sekaligus, When syarat kepenuhi, Then cuma satu Promo Produk yang diapply — menang lewat prioritas kuantitas-barang atas nominal-transaksi, atau nilai hasil terkecil kalau sejenis.

---

### PAGE-06V — Promo

**Route:** Dari CTA "Promo" di PAGE-06.
**Tujuan:** Tamu memilih **Diskon Transaksi** dari daftar yang memenuhi syarat. **Bukan** input kode ketik bebas, dan **bukan** tempat Promo Produk (itu otomatis, discovery-nya lewat rail "Promo Hari Ini" di Menu — lihat Kategori Promo di atas §6).

**Prinsip "1 paragraf deskriptif, bukan bullet."** Kartu nampilin **judul hasil + 1 paragraf deskripsi** (hasil + batas maksimal, bukan syarat pemicu) — sama persis pola & template kalimat di PAGE-04V, lihat [[SO_Case_TemplateDeskripsiPromo]]. Bedanya di sini ada tombol Pakai/Dipakai.

**Element Inventory**

1. `PromoCard` (dulu `VoucherPickCard`) per Diskon Transaksi — judul hasil (mis. "Diskon 20%", "Potongan Rp15.000") + 1 paragraf deskripsi (mis. "Diskon 20% pada transaksi. Maksimum potongan Rp30.000."), tombol **"Pakai"** ↔ **"Dipakai"**. Tap area kartu (di luar tombol) → buka `DetailPromoSheet` buat baca "Deskripsi" versi lebih panjang.
2. Banner promosi opsional — hidden by default.

**Urutan tampil.** Kartu diurutkan **alfabetis A→Z (ASCII) berdasar judul promo**.

**States**

| State | Tampilan |
|---|---|
| default | Daftar Diskon Transaksi yang memenuhi syarat keranjang saat ini (terurut A→Z) |
| empty | "Belum ada promo yang bisa dipakai" + ilustrasi kosong |
| success | Tap "Pakai" → diskon terhitung di `SummaryCard`, kembali ke PAGE-06 |

**Aturan maks 1 aktif.** Cuma **satu** Diskon Transaksi bisa aktif dalam satu waktu. Memilih promo baru otomatis melepas yang sebelumnya aktif. Kartu yang sedang dipakai tombolnya berubah jadi **"Dipakai"** — ditekan lagi untuk melepas tanpa perlu memilih promo lain.

**Aturan penumpukan dengan Promo Produk.** Diskon Transaksi **boleh digabung** dengan Promo Produk (barang gratis atau diskon produk) — keduanya bisa aktif bersamaan. Urutan hitung: Promo Produk diterapkan lebih dulu, Diskon Transaksi dihitung dari nilai setelahnya.

**Copy Bank**

| Key | Teks final |
|---|---|
| btn_use | "Pakai" |
| btn_used | "Dipakai" |
| empty_promo | "Belum ada promo yang bisa dipakai" |

**Acceptance Criteria**

- **AC-06V.1** — Given ada Diskon Transaksi yang memenuhi syarat belanja, When PAGE-06V tampil, Then daftar promo tampil dengan judul hasil + 1 paragraf deskripsi (hasil + batas maksimal, tanpa bullet dot) & tombol "Pakai".
- **AC-06V.11** — Given tamu menekan area kartu (bukan tombol Pakai/Dipakai), When ditekan, Then `DetailPromoSheet` terbuka menampilkan "Deskripsi" versi lebih panjang, footer cuma "Mengerti".
- **AC-06V.2** — Given tamu menekan "Pakai" pada satu promo, When dipilih, Then diskon diterapkan ke ringkasan biaya di PAGE-06 dan tombol kartu tersebut berubah jadi "Dipakai".
- **AC-06V.3** — Given tidak ada Diskon Transaksi aktif, When PAGE-06V tampil, Then tampil empty state "Belum ada promo yang bisa dipakai".
- **AC-06V.4** — Given keranjang sudah kena Promo Produk, When tamu memakai Diskon Transaksi, Then keduanya tetap aktif dan Diskon Transaksi dihitung dari nilai setelah Promo Produk.
- **AC-06V.5** — Given satu Diskon Transaksi sedang aktif, When tamu memilih Diskon Transaksi lain, Then yang lama otomatis lepas dan cuma yang baru yang aktif.
- **AC-06V.6** — Given Diskon Transaksi sedang aktif (tombol "Dipakai"), When tombol itu ditekan lagi, Then diskon dilepas dari ringkasan biaya dan tombol kembali ke "Pakai".
- ~~AC-06V.7, AC-06V.8, AC-06V.9~~ — **dibatalkan (2026-08-12).** Sempat ditambah buat section "Promo Produk" di PAGE-06V, tapi keputusan itu dibatalkan — lihat §10 keputusan #26. PAGE-06V tetap khusus Diskon Transaksi.
- **AC-06V.10** *(baru, 2026-08-12)* — Given lebih dari satu Diskon Transaksi tampil, When PAGE-06V tampil, Then kartu-kartu terurut alfabetis A→Z berdasar judul promo.

---

### PAGE-07 — ~~Klaim Item Gratis (`FreeItemSheet`)~~ Dihapus dari scope

> **Sheet ini sudah tidak ada.** Promo Produk barang-gratis sekarang selalu auto-apply, berapa pun jumlah varian hadiahnya (dulu: sheet cuma dilewati kalau 1 varian). Sistem otomatis memilih varian dengan **harga satuan terkecil** yang stoknya tersedia; kalau ada dasi harga, tie-break berdasarkan nama item alfabetis A→Z. Kalau **semua** varian habis stok, hadiah tidak diklaim saat itu — tidak ada notifikasi baru di Keranjang, baru ketahuan lewat `ValidationPopup` saat "Konfirmasi Pesanan".
>
> Algoritma lengkap, skenario uji, dan aturan prioritas kalau 1 barang ke-match >1 Promo Produk: [[SO_Case_PromoProdukAutoApply]].

---

### Validasi Keranjang — `ValidationPopup`

> Popup di atas PAGE-06, **bukan halaman terpisah**.

**Trigger:** Tamu menekan "Konfirmasi Pesanan" di PAGE-06 → server memvalidasi stok, harga, promo, dan SPA (*Special Price Adjustment* — mekanisme harga katalog merchant, berlaku ke semua tamu, **tidak berubah** di revisi ini dan **tidak terkait** dengan identitas member di §6.3). Bila bersih, tamu langsung ke PAGE-08. Bila ada masalah, popup ini muncul.

**Nada desain:** tenang & informatif — ini notifikasi, bukan alarm. Sistem sudah otomatis menyelesaikan sebagian besar masalah (item habis dihapus, harga diperbarui); tamu hanya perlu tahu. Tidak memakai ilustrasi besar atau teks merah bertumpuk.

**Struktur**

```
icon kecil netral (52×52)
  ↓
heading
  ↓
1 baris alasan singkat        ← kenapa ini terjadi
  ↓
paragraph
  ↓
issues-card  →  N × IssueRow  (auto-collapse "Lihat N lainnya" bila >3–4)
  ↓
tombol aksi dinamis
```

**Tombol aksi — dinamis berdasar isi**

| Kondisi | Tombol utama | Alasan |
|---|---|---|
| Ada ≥1 issue `Type=Stock` | **"Kembali ke keranjang"** | Tamu perlu memutuskan: ganti item atau lanjut tanpa item itu |
| Semua issue `Type=Harga/Promo/SPA` | **"Lanjut bayar"** | Keranjang sudah otomatis ter-update, tidak butuh keputusan manual |

**Component property**

| Property | Tipe | Fungsi |
|---|---|---|
| `hasStockIssue` | BOOLEAN | `true` → tombol "Kembali ke keranjang"; `false` → "Lanjut bayar" |
| `reasonText` | TEXT | 1 kalimat alasan singkat; hidden bila kosong |

**Yang sengaja tidak ditampilkan:** total baru maupun selisih harga. Keputusan sadar untuk menjaga scope tetap kecil.

**Acceptance Criteria**

- **AC-NC.1** — Given tamu menekan "Konfirmasi Pesanan" dan server menemukan item habis, When validasi selesai, Then `ValidationPopup` tampil dengan `IssueRow` bernama item yang habis.
- **AC-NC.2** — Given harga/promo sebuah item berubah, When validasi selesai, Then popup menampilkan nilai baru per item terdampak.
- **AC-NC.3** — Given lebih dari 4 item bermasalah, When popup tampil, Then daftar `IssueRow` auto-collapse dengan "Lihat N lainnya".
- **AC-NC.4** — Given semua issue bertipe Harga/Promo/SPA, When popup tampil, Then tombol utama berlabel "Lanjut bayar" dan menekannya membawa tamu ke PAGE-08.
- **AC-NC.5** — Given ada minimal 1 issue bertipe Stock, When popup tampil, Then tombol utama berlabel "Kembali ke keranjang".
- **AC-NC.6** — Given tamu kembali ke keranjang dan masalah sudah teratasi, When menekan ulang "Konfirmasi Pesanan", Then validasi bersih dan tamu lanjut ke PAGE-08.

---

### PAGE-08 — Konfirmasi Pesanan (`ConfirmScreen`)

**Route:** `/confirm`, dari PAGE-06 (langsung atau setelah `ValidationPopup` bersih).
**Tujuan:** Menampilkan ringkasan pesanan, menawarkan identitas opsional, dan memilih metode pembayaran — **dalam satu layar**.

**Element Inventory (QR Statis)**

1. `TopBar` — tombol kembali + judul "Konfirmasi Pesanan". **Tanpa chip** apa pun di kanan.
2. Header ringkasan — "RINGKASAN PESANAN" + "{n} item".
3. `OrderSummary/flat` — item pertama tampil detail (foto, nama, opsi, qty, harga), sisanya diringkas "Lihat semua · N item lainnya". Diikuti breakdown: Subtotal, promo bernama (mis. "Gratis Ayam Goreng Kremes"), Pajak (10%), **Total**.
4. **Field "Data Pelanggan · opsional"** — lihat §6.3.
5. Metode Pembayaran — daftar `PaymentOption`:
   - **QRIS** — "Semua e-wallet & m-banking"
   - **Bayar di Kasir** — "Tunai atau kartu di kasir"
6. `BottomBar` — tombol **"Bayar"** (primary tunggal di layar ini).

**Urutan layar:** Ringkasan Pesanan → **Data Pelanggan** → Metode Pembayaran → Bayar.

**States**

| State | Tampilan |
|---|---|
| default | Ringkasan + field Data Pelanggan + metode bayar; tombol "Bayar" aktif setelah metode dipilih |
| loading | Memuat ringkasan / menghitung total |
| disabled | Tombol "Bayar" disabled sebelum metode pembayaran dipilih |

**Edge Case — QRIS Tidak Tersedia.** Bila merchant menonaktifkan QRIS (mis. gangguan provider), opsi QRIS tampil **grayscale/disabled** dan **Bayar di Kasir** otomatis menjadi satu-satunya pilihan aktif. Alur berikutnya sama seperti pembayaran kasir biasa.

**Copy Bank**

| Key | Teks final |
|---|---|
| title | "Konfirmasi Pesanan" |
| section_summary | "Ringkasan Pesanan" |
| item_count | "{n} item" |
| link_see_all | "Lihat semua · {n} item lainnya" |
| row_subtotal | "Subtotal" |
| row_tax | "Pajak (10%)" |
| row_total | "Total" |
| section_customer | "Data Pelanggan · opsional" |
| ph_phone | "Nomor HP" |
| section_payment | "Metode Pembayaran" |
| pay_qris_title | "QRIS" |
| pay_qris_sub | "Semua e-wallet & m-banking" |
| pay_cashier_title | "Bayar di Kasir" |
| pay_cashier_sub | "Tunai atau kartu di kasir" |
| btn_pay | "Bayar" |

**Acceptance Criteria**

- **AC-08.1** — Given validasi bersih, When PAGE-08 tampil, Then ringkasan pesanan, field "Data Pelanggan · opsional", dan pilihan metode bayar tampil dalam satu layar tanpa syarat login.
- **AC-08.2** — Given tamu tidak mengisi field Data Pelanggan sama sekali, When memilih metode dan menekan "Bayar", Then tamu tetap lanjut ke PAGE-09 tanpa hambatan.
- **AC-08.4** — Given merchant menonaktifkan QRIS, When PAGE-08 tampil, Then opsi QRIS disabled/grayscale dan Bayar di Kasir otomatis aktif.
- **AC-08.5** — Given tamu menekan "Lihat semua", When ditekan, Then seluruh item pesanan ditampilkan, bukan hanya yang pertama.
- **AC-08.6** — Given tamu belum memilih metode pembayaran, When PAGE-08 tampil, Then tombol "Bayar" disabled.

#### 6.3 Data Pelanggan — Identitas Opsional (No. HP)

> **Scope: QR Statis saja.** Bagian ini menggantikan mekanisme chip "Masuk" + `PoinMemberSheet` versi lama — **khusus untuk QR Statis**. QR Dinamis belum diselaraskan, lihat catatan di akhir subbagian ini.

**Komponen:** Instance `TextField` (variant `State=Default`, `Icon` = `Icon/phone`), diberi label section **"DATA PELANGGAN · OPSIONAL"** di atasnya. Diposisikan antara Ringkasan Pesanan dan Metode Pembayaran.

**Bukan autentikasi.** Tidak ada OTP, tidak ada tombol submit, tidak ada akun yang dibuat. Field ini murni menampung **No. HP** — placeholder "Nomor HP" — untuk dicocokkan ke data member POS **di server**.

**Perilaku pencocokan — sepenuhnya diam.**

- Tidak ada tombol "Masuk" atau submit manual. Nomor yang diketik dikirim & dicocokkan ke server secara otomatis.
- **Tidak ada umpan balik visual apa pun** ke tamu soal hasil pencocokan. Field selalu tampil sama (`State=Default`) baik nomornya cocok member maupun tidak. Tidak ada nama yang muncul, tidak ada badge, tidak ada pesan sukses/gagal.
- Tujuannya murni **pelaporan internal POS** (merchant tahu transaksi ini dari member yang mana) — bukan untuk memberi tamu manfaat apa pun yang terlihat di sesi self-order ini.

**Tidak ada poin, tidak ada harga khusus.** Pencocokan member di sini **tidak** mengubah harga, tidak memberi diskon, dan **tidak memberi poin**. SPA (harga khusus katalog) adalah mekanisme terpisah yang berlaku untuk semua tamu — lihat `ValidationPopup` di atas — dan **tidak terkait** dengan field ini. Pendaftaran member baru & manfaat SPA di kasir tetap ada, tapi itu terjadi di kasir secara langsung, bukan lewat field ini.

**Field ini opsional total.** Kosong pun, tamu tetap bisa langsung memilih metode bayar dan menekan "Bayar".

**Tidak ada field Nama.** Cuma No. HP.

**Catatan QR Dinamis.** Dua layar Konfirmasi untuk QR Dinamis **masih menampilkan mekanisme lama**: dua field ("Nama" + "Nomor HP") di bawah label "DATA PELANGGAN · OPSIONAL", plus chip "Masuk" di `TopBar` yang membuka `PoinMemberSheet`. Ini **sengaja belum disentuh** — bukan keputusan final, cuma belum digarap karena QR Dinamis belum dipakai. Developer tidak perlu membangun ulang mekanisme ini untuk Dinamis; cukup pertahankan seperti yang ada di Figma sekarang.

**Acceptance Criteria**

- **AC-08.7** — Given QR Statis, field Data Pelanggan kosong, When tamu menekan "Bayar" tanpa mengisi apa pun, Then pesanan tetap diproses tanpa hambatan.
- **AC-08.8** — Given tamu mengisi No. HP di field Data Pelanggan, When ketikan terkirim ke server, Then sistem mencocokkan nomor ke data member POS di background **tanpa mengubah tampilan field maupun menampilkan pesan apa pun** ke tamu.
- **AC-08.9** — Given hasil pencocokan (cocok atau tidak cocok member), When pesanan dikirim, Then status member (bila cocok) tercatat untuk laporan POS internal tanpa memengaruhi harga, diskon, SPA, atau poin pada transaksi ini.
- **AC-08.10** — Given QR Dinamis, When PAGE-08 varian Dinamis tampil, Then field yang tampil tetap "Nama" + "Nomor HP" dengan chip "Masuk" di `TopBar` seperti sebelumnya (belum diselaraskan dengan QR Statis).

---

### PAGE-09 — Pembayaran

**Route:** `/payment`, dari PAGE-08 sesuai metode terpilih.

#### A. QRIS — `ProcessingScreen`

**Element Inventory**

1. `TopBar` — judul "Pembayaran QRIS" + tombol kembali.
2. Kartu QR — kode QR, border tegas.
3. Status — titik hijau berdenyut + "Menunggu pembayaran…".
4. Countdown — "Berlaku {mm:ss}", masa berlaku **5 menit**. Kurang dari 30 detik → berubah oranye peringatan.
5. Tombol "Download QR".
6. Panduan **"Cara Bayar"** — 4 langkah: buka e-wallet / m-banking → pilih Scan QR atau Bayar → arahkan kamera ke kode → konfirmasi & bayar.

**Perilaku:** sistem melakukan polling status ke gateway. Begitu terdeteksi lunas, tamu **otomatis** diarahkan ke PAGE-11 tanpa menekan apa pun.

**QRIS Kedaluwarsa.** Bila 5 menit terlewat sebelum dibayar → popup **"Kode QRIS kedaluwarsa"** dengan copy "Masa berlaku kode habis. Kembali ke konfirmasi untuk membuat kode baru." dan tombol **"Kembali ke konfirmasi"**. **Isi pesanan tidak hilang** — tamu kembali ke PAGE-08 dengan keranjang utuh dan bisa membuat kode baru.

#### B. Bayar di Kasir — `CashStatusScreen`

**Alur yang disepakati:**

1. Tamu memilih "Bayar di Kasir" di PAGE-08 lalu menekan "Bayar".
2. Pesanan masuk ke POS dengan status **"menunggu pembayaran"**.
3. Layar tamu menampilkan **kode referensi** (mis. `REF-001234`) + instruksi menunjukkannya ke kasir, beserta rincian pesanan & biaya lengkap.
4. Kasir menerima pembayaran dan menandai lunas di POS.
5. **Tamu menekan tombol "Cek Status Pesanan"** → sistem memeriksa status ke server.
   - Sudah lunas → tamu diarahkan ke PAGE-11.
   - Belum lunas → tetap di layar ini dengan pesan bahwa pembayaran belum diterima.

> Perpindahan ke layar Selesai **dipicu oleh tamu**, bukan otomatis. Tombol "Cek Status Pesanan" adalah satu-satunya jalan maju dari layar ini.

**Element Inventory**

1. Ilustrasi "Menunggu Pembayaran".
2. Copy "Silakan selesaikan pembayaran di kasir agar pesanan segera diproses."
3. Kartu kode referensi — "Tunjukkan kode ini ke kasir" + `REF-XXXXXX`.
4. Rincian pesanan & rincian biaya lengkap.
5. Tombol **"Cek Status Pesanan"**.

**Copy Bank (PAGE-09)**

| Key | Teks final |
|---|---|
| title_qris | "Pembayaran QRIS" |
| qris_waiting | "Menunggu pembayaran…" |
| qris_countdown | "Berlaku {mm:ss}" |
| btn_download_qr | "Download QR" |
| howto_title | "Cara Bayar" |
| err_qris_expired_title | "Kode QRIS kedaluwarsa" |
| err_qris_expired_body | "Masa berlaku kode habis. Kembali ke konfirmasi untuk membuat kode baru." |
| btn_back_confirm | "Kembali ke konfirmasi" |
| cashier_title | "Menunggu Pembayaran" |
| cashier_body | "Silakan selesaikan pembayaran di kasir agar pesanan segera diproses." |
| cashier_ref_label | "Tunjukkan kode ini ke kasir" |
| btn_check_status | "Cek Status Pesanan" |
| err_not_paid | "Pembayaran belum diterima." |

**Acceptance Criteria**

- **AC-09.1** — Given tamu di PAGE-09, When halaman tampil, Then total final dan pilihan metode (QRIS, Bayar di Kasir) ditampilkan.
- **AC-09.2** — Given tamu memilih QRIS, When kode dibuat, Then QR + nominal + countdown 5 menit tampil dengan status "Menunggu pembayaran…".
- **AC-09.3** — Given QRIS dibayar, When server mendeteksi lunas lewat polling, Then tamu otomatis diarahkan ke PAGE-11 tanpa aksi tambahan.
- **AC-09.4** — Given countdown QRIS habis sebelum dibayar, When kedaluwarsa terdeteksi, Then popup "Kode QRIS kedaluwarsa" tampil dengan tombol "Kembali ke konfirmasi" dan isi pesanan tidak hilang.
- **AC-09.5** — Given tamu memilih Bayar di Kasir, When `CashStatusScreen` tampil, Then kode referensi, instruksi ke kasir, dan rincian pesanan lengkap ditampilkan bersama tombol "Cek Status Pesanan".
- **AC-09.6** — Given kasir sudah menandai lunas di POS, When tamu menekan "Cek Status Pesanan", Then tamu diarahkan ke PAGE-11.
- **AC-09.7** — Given kasir belum menandai lunas, When tamu menekan "Cek Status Pesanan", Then tamu tetap di layar ini dengan pesan "Pembayaran belum diterima."

---

### PAGE-11 — Selesai & Struk

**Route:** `/success`, dari PAGE-09 setelah pembayaran terkonfirmasi.
**Tujuan:** Mengonfirmasi pesanan berhasil, menampilkan ringkasan transaksi, dan memfasilitasi pengiriman struk lewat email.

**Element Inventory**

1. Hero sukses — ikon centang + "Pembayaran berhasil" + nominal besar.
2. Ringkasan pesanan — daftar item + qty + harga.
3. Rincian pembayaran — Subtotal, Diskon promo, Pajak & layanan.
4. Detail transaksi — Metode, Tanggal, ID Transaksi (dengan tombol salin).
5. Tombol **"Bagikan Struk"** — membuka `ShareReceiptSheet` (§6.4).
6. Tombol **"Kembali ke Menu"** — kembali ke PAGE-04, sesi baru.

**Tidak ada blok poin, blok Waiting List, nomor antrean, maupun estimasi waktu** — semuanya di luar scope MVP. Layar ini **sama untuk semua tamu**, member atau bukan — tidak ada perbedaan tampilan berdasar status member.

**States**

| State | Tampilan |
|---|---|
| default | Hero + ringkasan + detail transaksi + Bagikan Struk + Kembali ke Menu |
| loading | Memuat data transaksi |

**Copy Bank**

| Key | Teks final |
|---|---|
| title_success | "Pembayaran berhasil" |
| section_order | "Pesananmu" |
| section_breakdown | "Rincian Pembayaran" |
| section_detail | "Detail Transaksi" |
| row_method | "Metode" |
| row_date | "Tanggal" |
| row_txn | "ID Transaksi" |
| btn_share | "Bagikan Struk" |
| btn_back_menu | "Kembali ke Menu" |

**Acceptance Criteria**

- **AC-11.1** — Given pembayaran sukses, When PAGE-11 tampil, Then konfirmasi sukses, ringkasan pesanan, dan detail transaksi ditampilkan.
- ~~AC-11.2, AC-11.3~~ — **dihapus.** Blok poin dihapus total dari MVP (lihat §10 #2); tidak ada perbedaan tampilan member vs guest di layar ini.
- **AC-11.4** — Given tamu menekan "Kembali ke Menu", When ditekan, Then tamu kembali ke PAGE-04 dengan sesi baru.
- **AC-11.5** — Given tamu membuka ulang link konfirmasi, When halaman dimuat, Then status sukses dipulihkan dari server tanpa menggandakan pesanan.

#### 6.4 Bagikan Struk — `ShareReceiptSheet`

**Pemicu:** tombol "Bagikan Struk" di PAGE-11.

**Email saja.** Channel WhatsApp **dihapus**. Tidak ada `ShareChannelSeg` (segmented control), tidak ada `WhatsAppNumberField`. Sheet ini cuma berisi satu field: **email**.

**Tidak ada carry-over nomor.** Field email di sini **tidak** terisi otomatis dari mana pun — termasuk dari field "Data Pelanggan" di PAGE-08 (§6.3). Dua mekanisme itu independen total: No. HP di Konfirmasi untuk laporan POS, email di sini murni untuk kirim struk. Tamu selalu mengisi email dari kosong setiap kali membuka sheet ini.

**Element Inventory**

1. Field email — ikon amplop di lingkaran kiri, placeholder contoh alamat email.
2. Helper text di bawah field.
3. Tombol kirim.

**Validasi format.** Dicek **saat blur**, bukan tiap ketikan. Bila tamu langsung menekan kirim tanpa pernah blur, validasi tetap dijalankan.

| Field | Aturan | Pesan (persis) |
|---|---|---|
| Email | Format email valid | "Format email belum valid." |

Saat error: border field memakai token `danger`, tetapi **teks helper tetap netral** (bukan merah) — pembeda cukup dari border + ikon.

**Empat state tombol kirim**

| State | Label | Tampilan |
|---|---|---|
| Disabled | "Kirim struk" | Muted; field kosong atau tidak valid |
| Enabled | "Kirim struk" | Warna brand |
| Loading | "Mengirim..." | Disabled selama proses |
| Retry | "Coba lagi" | Warna brand; muncul setelah submit gagal |

**Gagal kirim.** Banner `Toast` (`Tone=Error`) muncul di atas tombol, di dalam footer sheet: latar `danger`, ikon `Icon/info`, teks putih — **"Gagal Mengirim Struk. Coba lagi, ya."** Sheet **tetap terbuka** dan nilai input **tidak di-reset**, sehingga tamu tidak perlu mengetik ulang. Banner hilang otomatis begitu tamu menekan "Coba lagi".

> Aksesibilitas (wajib di kode, bukan Figma): banner ini muncul dinamis, jadi butuh `role="alert"` + `aria-live="assertive"`; ikonnya dekoratif sehingga butuh `aria-hidden="true"`. Tanpa ini screen reader tidak mengumumkan kegagalan sama sekali.

**Berhasil kirim.** Sheet **langsung menutup**, lalu `Toast` (`Tone=Success`) muncul mengambang di atas PAGE-11: latar token `primary`, ikon `Icon/checkCircle`, teks **"Struk berhasil dikirim."** Auto-dismiss sekitar **3 detik**, tanpa tombol tutup.

**Copy Bank**

| Key | Teks final |
|---|---|
| helper_email | "Struk akan dikirim ke alamat email ini." |
| btn_send | "Kirim struk" |
| btn_sending | "Mengirim..." |
| btn_retry | "Coba lagi" |
| err_email_format | "Format email belum valid." |
| toast_send_failed | "Gagal Mengirim Struk. Coba lagi, ya." |
| toast_send_success | "Struk berhasil dikirim." |

**Acceptance Criteria**

- ~~AC-11.6, AC-11.7~~ — **dihapus.** Tidak ada lagi carry-over nomor dari PAGE-08 — field email di sini selalu mulai kosong (lihat "Tidak ada carry-over nomor" di atas).
- **AC-11.8** — Given tamu mengisi email berformat salah, When field kehilangan fokus, Then border field menjadi `danger` dan helper berubah menjadi "Format email belum valid." dengan tombol kirim disabled.
- **AC-11.9** — Given submit gagal karena jaringan atau server, When kegagalan terdeteksi, Then banner "Gagal Mengirim Struk. Coba lagi, ya." muncul, sheet tetap terbuka, dan nilai input tidak hilang.
- **AC-11.10** — Given banner gagal tampil, When tamu menekan "Coba lagi", Then banner hilang dan tombol masuk state "Mengirim...".
- **AC-11.11** — Given submit berhasil, When pengiriman sukses, Then sheet menutup dan toast "Struk berhasil dikirim." muncul lalu hilang sendiri setelah ±3 detik.

---

## 7. Komponen Bersama

Komponen yang dipakai lintas halaman. Nama mengikuti Figma.

| Komponen | Dipakai di | Catatan |
|---|---|---|
| `TopBar` | Semua halaman | Judul + tombol kembali. Tanpa chip di PAGE-08 (QR Statis); **QR Dinamis masih ada chip "Masuk"** (belum diselaraskan). |
| `BottomBar` | PAGE-06, PAGE-08 | Container CTA sticky |
| `CartDock` | PAGE-04, PAGE-05 | Floating cart bar |
| `CategoryTabs` | PAGE-04 | Chip kategori |
| `OrderTypePills` | PAGE-04 | Pemilih Dine In / Take Away |
| `OrderTypeOption` | Sheet tipe pesanan | Variant `Type` (Dine In/Takeaway) × `Selected` (True/False) |
| `OptionRow` | PAGE-05 | Label + slot harga opsional |
| `SummaryCard` / `SummaryRow` | PAGE-06, PAGE-08, PAGE-11 | Baris rincian biaya |
| `PromoCard` (dulu `VoucherPickCard`) | PAGE-06V, PAGE-04V | Di PAGE-06V: judul hasil + tombol "Pakai"↔"Dipakai", tap area kartu → `DetailPromoSheet`. Di PAGE-04V: **satu bentuk buat Promo Produk maupun Diskon Transaksi** (gak ada variant/badge pembeda) — judul hasil + subtitle (nama item pemicu, atau "Diskon Transaksi") + chevron ">", tappable → `DetailPromoSheet`. |
| `DetailPromoSheet` (dulu "Detail Voucher", cuma buat Diskon Transaksi) | PAGE-06V, PAGE-04V (kedua tipe kartu) | Bottom sheet dismiss-only, footer selalu "Mengerti" (bukan "Pakai"). Variant `Type=Transaksi` (existing) & `Type=Produk` (baru — header judul hasil + subjudul item pemicu, syarat 1 baris, catatan auto-apply). Section "Syarat" pakai **bullet dot netral**, bukan `Icon/checkCircle` — checkmark keliru nyiratin syarat udah kepenuhi. Section paragraf disebut **"Deskripsi"**, bukan "Syarat & Ketentuan". Section **"Periode Promosi"** *(baru)* — kotak bordered, `Icon/calendar` (tanggal) + `Icon/repeat` (hari — beda icon, biar gak ketuker) + `Icon/clock` (jam, existing), nampilin tanggal mulai-akhir, hari berlaku, jam aktif. `Icon/calendar` & `Icon/repeat` baru dibuat, gak ada sebelumnya di design system. |
| `PromoListSheet` | PAGE-05 | Daftar semua Promo Produk 1 item (>1 promo) — kartu mandiri, dead-end, tanpa tap lanjutan |
| `ConfirmDialog` | PAGE-06 | Dialog hapus item |
| `ValidationPopup` | Di atas PAGE-06 | Property `hasStockIssue`, `reasonText` |
| `IssueRow` | Dalam `ValidationPopup` | Variant `Type` = Stock / Harga / Promo / SPA |
| `PaymentOption` | PAGE-08 | Kartu metode bayar |
| `TextField` | PAGE-08 (Data Pelanggan, QR Statis) & beberapa form | Variant `State` = Default / Filled / Error |
| `ShareReceiptSheet` | PAGE-11 | Sheet bagikan struk, email saja |
| `Toast` | PAGE-11 | Variant `Tone` = Error / Success |

**Komponen yang sudah tidak dipakai di QR Statis** (masih dipakai di QR Dinamis untuk sementara): `PoinMemberSheet`. Section eksplorasinya di Figma dipindah ke page **🗄 Arsip · Desain Lama** dengan nama **"🗄 [Arsip] Case: Kumpulin Poin Member (Header Chip + Sheet)"**.

**Komponen yang dihapus total dari MVP:** `ShareChannelSeg`, `WhatsAppNumberField` (dalam konteks Bagikan Struk).

### `IssueRow` — variant `Type`

Struktur seluruh variant sama: icon-tile 44×44 di kiri + blok teks di kanan (nama item tebal + baris status netral). Yang berbeda hanya glyph dan warna icon-tile.

| Type | Ikon | Warna icon-tile | Contoh status |
|---|---|---|---|
| Stock | `Icon/cart` | danger soft | "Habis · dihapus dari pesanan" |
| Harga | `Icon/tag` | oranye soft | "Harga naik · Rp45.000 → Rp48.000" |
| Promo | `Icon/percent` | primary soft | "Promo berakhir · −Rp30.000 gak berlaku" |
| SPA | `Icon/percent` | primary soft | "SPA gak berlaku lagi" |

Teks status **selalu netral** (`muted` / `ink`), tidak pernah memakai warna alarm. Pembeda kategori cukup dari warna dan bentuk icon-tile.

### `Toast` — variant `Tone`

| Elemen | `Tone=Error` | `Tone=Success` |
|---|---|---|
| Latar | Token `danger` | Token `primary` |
| Ikon | `Icon/info` | `Icon/checkCircle` |
| Teks | Putih tebal, 1 baris | Putih tebal, 1 baris |
| Posisi | Menempel di dalam sheet, di atas tombol | Mengambang di atas layar |
| Dismiss | Hilang saat tamu menekan "Coba lagi" | Auto ±3 detik |

Sistem ini **tidak punya token "success" terpisah** — `primary` dipakai sebagai warna konfirmasi positif.

---

## 8. Cross-Cutting

### Theming

- **Light mode only.** Mode gelap di luar scope.
- **Primary color dinamis** — token brand merchant, default `#1799A5`. Diatur merchant di Accurate Online; Self Order membacanya saat halaman dimuat. Tamu tidak bisa mengubahnya.
- **Hanya primary yang dinamis.** Warna lain, tipografi, ukuran, dan elemen lain tetap.
- Seluruh elemen beraksen (tombol utama, tautan aktif, highlight, ikon aktif, badge terpilih) **wajib memakai satu token primary yang sama**, agar otomatis ikut berubah saat merchant mengganti warna.
- **Kontras:** karena primary bisa diganti merchant, warna teks/ikon di atasnya harus dipilih otomatis (putih atau gelap) sesuai luminance, menargetkan WCAG AA. Warna semantik tidak mengikuti primary.

### Warna destruktif

**Aksi destruktif memakai oranye brand `#E2680E`, bukan merah.** Tombol Hapus/delete memakai oranye; sinyal bahaya disampaikan lewat state disabled dan dialog konfirmasi, bukan lewat warna merah. Token `danger` tetap ada dan dipakai untuk **state error input** (border field) serta banner gagal — bukan untuk tombol destruktif.

### Design Tokens (default)

- **Netral (light):** bg `#FFFFFF` · surface `#F9FAFB` · border `#E5E7EB` · teks `#111827` · teks sekunder `#6B7280` · disabled `#9CA3AF`
- **Semantik:** error `#DC2626` · warning `#F59E0B` · info = primary · **tidak ada token success** (pakai primary)
- **Tipografi:** `Inter, system-ui, sans-serif` — H1 24/bold · H2 20/semibold · H3 16/semibold · body 14 · caption 12 · label tombol 14–16/semibold
- **Spacing & radius:** grid 8pt; padding halaman 16; jarak kartu 12; radius kartu/sheet 12–16; input/tombol 8–12
- **Tombol:** primer solid primary (tinggi 48, full-width CTA) · sekunder outline/ghost primary · disabled bg `#E5E7EB` teks `#9CA3AF`
- **Sheet/dialog:** bottom sheet sudut atas 16 + drag handle + scrim hitam 40%
- **Input:** tinggi 44–48, border `#D1D5DB`, radius 8; focus = border primary + ring tipis; error = border `danger`

### Error Jaringan — satu komponen global

Satu komponen dipakai di **seluruh halaman**. Muncul menimpa konten ketika request gagal karena koneksi.

- Ilustrasi + judul **"Koneksi terputus"** + tombol **"Coba Lagi"**.
- Menekan "Coba Lagi" mengulang request terakhir tanpa kehilangan konteks (keranjang, sesi, isi form).
- Berlaku sama di semua halaman, termasuk layar pembayaran.

- **AC-NET.1** — Given request gagal karena koneksi terputus, When kegagalan terdeteksi, Then komponen error jaringan global tampil dengan tombol "Coba Lagi".
- **AC-NET.2** — Given tamu menekan "Coba Lagi", When koneksi pulih, Then request diulang dan konteks (keranjang/sesi/form) tetap utuh.

### Navigasi & Sesi

- **Persistensi konteks:** `venueId` + tipe QR + `sessionToken` (dinamis) dipertahankan di seluruh halaman. Keranjang & promo bertahan selama sesi.
- **Tombol kembali** mengikuti Page Map.
- **Indikator konteks** di header: "Pesan Mandiri" (statis) atau "Meja {nomorMeja}" (dinamis).
- Semua tamu **setara secara teknis** — tidak ada peran "guest vs teridentifikasi". Nomor HP murni data opsional untuk laporan internal, bukan kredensial, tidak memberi manfaat apa pun yang terlihat tamu.

### Non-Functional Requirements

| Aspek | Ketentuan |
|---|---|
| Tanpa instalasi | Seluruh alur berjalan di browser HP standar |
| Performa | Menu (PAGE-04) tampil < 3 detik pada koneksi normal; skeleton saat loading |
| Mobile-first | Tap target memadai, responsif |
| Data live | Harga & stok bersumber dari POS real-time |
| Privasi | Nomor HP (QR Statis) sepenuhnya opsional; dipakai hanya untuk pencocokan member POS demi laporan internal. **Tidak** dipakai untuk kirim struk (struk pakai email, diisi terpisah di `ShareReceiptSheet`). |
| Keamanan | Tidak ada OTP, kredensial, maupun sesi terautentikasi untuk diamankan |

### Data & Integrasi

**Entitas konseptual**

| Entitas | Isi |
|---|---|
| `SO Session` | venueId, tipe QR, sessionToken (dinamis), nomorMeja, status |
| `Cart / CartItem` | itemId, opsi terpilih, qty, catatan, tipe pesanan, harga snapshot |
| `PromoProduk` | id, tipe (barang-gratis / diskon-produk), itemId terkait, syarat kuantitas, deskripsi (maks. 100 kata — dicek saat promo dikonfigurasi di POS/AOL, bukan truncation di Self Order), **periode (tglMulai, tglAkhir, hari — "Setiap hari" atau daftar hari spesifik, jamMulai, jamAkhir — asumsi 1 rentang jam per hari)** |
| `PromoTransaksi` (dulu `Voucher`) | id, judul, **syarat: min. belanja** (qualifying condition), **maks. potongan** (cap/batas hasil — bukan syarat, lihat catatan di PAGE-06V), deskripsi (maks. 100 kata, sama seperti `PromoProduk`), **periode (field sama seperti `PromoProduk`)** |
| `GuestIdentity` | Opsional, per-order (khusus QR Statis): nomor HP saja — untuk pencocokan member POS, bukan kredensial |
| `Member` | Dicocokkan dari nomor HP di sisi server, murni untuk pelaporan internal. **Tidak ada saldo poin** — member tidak mendapat poin di Self Order MVP. |
| `Order` | Daftar item tervalidasi, total, referensi pembayaran |
| `Payment` | Metode (QRIS / Kasir), nominal, status, referensi gateway |

**Integrasi sistem**

| Sistem | Peran |
|---|---|
| QR Resolver | Memetakan token QR → konteks venue/sesi + menu live |
| Katalog & Stok POS | Sumber menu, harga, ketersediaan live; validasi stok saat konfirmasi |
| Engine Promo POS | Hitung Promo Produk (otomatis) & validasi pilihan Diskon Transaksi |
| Data Member POS | Pencocokan nomor HP untuk pelaporan internal — **tidak memengaruhi harga, diskon, atau poin** di Self Order |
| Gateway Pembayaran QRIS | Pembuatan kode, polling status, pencatatan transaksi ke POS |
| POS (kasir) | Menerima pesanan berstatus "menunggu pembayaran", menandai lunas |
| Pengirim Struk | Pengiriman struk via **Email** |
| Accurate Online | Sumber konfigurasi primary color merchant |

**Tidak ada integrasi pengirim OTP** — dihapus sepenuhnya dari scope. **Tidak ada integrasi pengirim WhatsApp untuk struk.**

---

## 9. Lapis Teknis

### Tabel Route

| Route | Halaman | Catatan |
|---|---|---|
| `/s/{venueId}/{qrToken}` | PAGE-01 | Entry QR statis |
| `/d/{venueId}/{sessionToken}` | PAGE-01 | Entry QR dinamis |
| `/menu` | PAGE-04 | Katalog |
| `/menu/promo` | PAGE-04V | Katalog lengkap promo (read-only) |
| `/menu/{itemId}` | PAGE-05 | Detail item (sheet di atas menu) |
| `/cart` | PAGE-06 | Keranjang |
| `/cart/promo` | PAGE-06V | Daftar Diskon Transaksi |
| `/confirm` | PAGE-08 | Konfirmasi pesanan |
| `/payment` | PAGE-09 | QRIS atau kasir, sesuai metode terpilih |
| `/success` | PAGE-11 | Selesai & struk |

Sheet (`ShareReceiptSheet`) dan popup (`ValidationPopup`, `ConfirmDialog`) **tidak punya route sendiri** — statusnya overlay di atas halaman induk. Field "Data Pelanggan" di PAGE-08 juga bukan overlay — inline langsung di `/confirm`.

### State Global

State yang bertahan selama sesi dan diakses lintas halaman.

| State | Tipe | Keterangan |
|---|---|---|
| `venueId` | string | Dari resolve QR |
| `qrType` | `'static' \| 'dynamic'` | Menentukan konteks header **dan** varian field identitas di PAGE-08 (§6.3) |
| `sessionToken` | string \| null | Hanya untuk QR dinamis |
| `tableNumber` | string \| null | Hanya untuk QR dinamis |
| `cart` | CartItem[] | Isi keranjang, termasuk baris gratis |
| `orderType` | `'dinein' \| 'takeaway'` | Tipe default untuk item berikutnya |
| `appliedPromo` | PromoTransaksi \| null | Diskon Transaksi yang sedang dipakai (maks 1) |
| `customerPhone` | string \| null | No. HP dari field Data Pelanggan (QR Statis). **Dikirim ke server untuk pencocokan member — tidak disimpan/ditampilkan balik ke client, tidak dipakai di alur lain.** |
| `paymentMethod` | `'qris' \| 'cashier' \| null` | Pilihan di PAGE-08 |
| `order` | Order \| null | Pesanan yang sudah dikirim ke server |

**Catatan penting:** berbeda dari v2.0 — `customerPhone` **bukan** sumber nomor bersama lagi. Email di `ShareReceiptSheet` (PAGE-11) independen total, selalu diisi manual, tidak pernah mewarisi nilai dari `customerPhone`. Tidak ada state `member` di sisi client — pencocokan & penyimpanan status member murni terjadi di server.

### Peta Komponen ke Halaman

| Halaman | Komponen utama |
|---|---|
| PAGE-01 | — |
| PAGE-04 | `TopBar`, `CategoryTabs`, `OrderTypePills`, `PromoRail`, `OfferRail`, `CartDock` |
| PAGE-04V | `PromoCard` (satu bentuk buat kedua kategori, judul+subtitle+chevron, tanpa badge/tombol), `DetailPromoSheet` (kedua tipe) |
| PAGE-05 | `OptionRow` |
| PAGE-06 | `SummaryCard`, `ConfirmDialog`, `ValidationPopup` + `IssueRow`, `BottomBar` |
| PAGE-06V | `PromoCard` |
| PAGE-08 (QR Statis) | `TopBar` (tanpa chip), `OrderSummary/flat`, `SummaryRow`, `TextField` (Data Pelanggan), `PaymentOption`, `BottomBar` |
| PAGE-08 (QR Dinamis) | `TopBar` (+ chip Masuk), `OrderSummary/flat`, dua `TextField` (Nama + Nomor HP), `PoinMemberSheet`, `PaymentOption`, `BottomBar` — belum diselaraskan |
| PAGE-09 | `ProcessingScreen`, `CashStatusScreen` |
| PAGE-11 | `ShareReceiptSheet` (email saja), `Toast` |
| Global | Komponen error jaringan |

---

## 10. Log Keputusan Produk

Seluruh keputusan di dokumen ini berasal dari PM. Tidak ada asumsi.

| # | Topik | Keputusan |
|---|---|---|
| 1 | Login & OTP | Dihapus sepenuhnya. Tidak ada gate di titik mana pun. |
| 2 | Member & poin | Member **tidak** mendapat poin. No. HP cuma untuk pencocokan/pelaporan internal POS, tidak memengaruhi harga sama sekali. |
| 3 | SPA | Mekanisme harga katalog lama, independen dari member, **tidak berubah** dan **tidak disentuh** oleh perubahan identitas di revisi ini. |
| 4 | Wadah identitas | Field inline **"Data Pelanggan · opsional"** di PAGE-08, antara Ringkasan Pesanan & Metode Pembayaran. Bukan chip+sheet. |
| 5 | Interaksi field | Tanpa tombol submit, tanpa field Nama (khusus QR Statis). Pencocokan ke server terjadi otomatis saat mengetik. |
| 6 | Umpan balik pencocokan | **Tidak ada.** Field selalu tampil sama (`State=Default`) apa pun hasil pencocokan server. |
| 7 | Cakupan | Field baru ini **hanya berlaku di QR Statis**. QR Dinamis sengaja belum diselaraskan — masih pakai field Nama+Nomor HP + chip "Masuk" yang lama. Bukan keputusan akhir, menunggu digarap. |
| 8 | Bagikan Struk | **Email saja.** WhatsApp dihapus. Tidak ada carry-over dari field No. HP — dua mekanisme independen total. |
| 9 | Voucher → Promo | Rename UI-wide: CTA, judul halaman, komponen (`VoucherPickCard`→`PromoCard`, dst). |
| 10 | Kategori promo | **Promo Produk** (hasil jatuh di produk: barang gratis atau diskon produk, otomatis) vs **Diskon Transaksi** (hasil jatuh di total, dipilih tamu, maks 1 aktif). Kategori ditentukan dari letak hasil, bukan pemicu. |
| 11 | Promo Produk di Menu | **Dihapus badge di kartu item.** Semua info promo ditampilkan lewat `PromoRail`/`OfferRail` di atas. Promo Produk tidak lagi punya penanda visual di kartu. |
| 12 | Section Figma lama | `PoinMemberSheet` (chip+sheet) dipindah jadi arsip di page 🗄 Arsip · Desain Lama — bukan dihapus, karena masih dipakai QR Dinamis untuk sementara. |
| 13 | Open Bill | Di luar MVP. |
| 14 | Waiting List | Di luar MVP. |
| 15 | Layar setelah bayar | Struk + kembali ke menu. Sama untuk member maupun bukan. |
| 16 | Bayar di Kasir | Kasir konfirmasi di POS; tamu menekan "Cek Status Pesanan" untuk maju ke Selesai. |
| 17 | Stacking promo | Promo Produk + Diskon Transaksi boleh menumpuk. Diskon Transaksi maksimal 1 aktif, bisa dilepas via tombol "Dipakai". |
| 18 | Batas qty | Hanya dibatasi stok; tidak ada plafon lain. |
| 19 | Double-payment guard | Di luar MVP. |
| 20 | Tipe pesanan | Per item di Menu & Keranjang; tidak dibawa ke Checkout. |
| 21 | Copy tombol keranjang | "Konfirmasi Pesanan". |
| 22 | Error jaringan | Masuk MVP, satu komponen global. |
| 23 | Lapis teknis | Route, komponen, state global. Tanpa data model detail & kontrak API. |
| 24 | Promo Produk di halaman Promo | PAGE-06V dapat section baru "Promo Produk" (read-only — gak ada tombol Pakai/Ganti, badge "Otomatis") — transparansi, karena tamu harus sadar sendiri menambah item pemicu (tidak ada aksi klaim/CTA otomatis). Kalau kosong, section hilang total. |
| 25 | Urutan kartu promo | Kartu Diskon Transaksi di PAGE-06V diurutkan alfabetis A→Z (ASCII) berdasar judul promo. |
| 26 | Promo Produk di halaman Promo (PAGE-06V) — dibatalkan | **Revisi final #24.** PAGE-06V (dari CTA "Promo" di Keranjang) tetap **khusus Diskon Transaksi** — Promo Produk **tidak** ditampilkan di sana sama sekali. Section "Informasi Promo" di PAGE-05 (row statis + `PromoListSheet`, AC-05.8/9/10) **tetap ada seperti semula**. |
| 27 | Promo/Voucher punya 2 halaman beda, bukan 1 | Klarifikasi PM: list promo diakses dari **2 entry point berbeda konten** — (1) dari **Menu** ("Lihat Semua" di rail Promo Hari Ini) → **PAGE-04V**, katalog lengkap (Promo Produk + Diskon Transaksi), **read-only total, gak ada yang bisa di-apply**; (2) dari **Keranjang** (CTA "Promo") → **PAGE-06V**, cuma Diskon Transaksi, **bisa** "Pakai". Promo Produk tetap read-only di mana pun (gak pernah ada tombol klaim) — tamu mengaktifkannya cuma dengan cara manual nambah item pemicu ke Keranjang lewat alur normal, bukan lewat halaman promo. |
| 28 | Kartu Promo Produk di PAGE-04V pakai `OfferCard`, bukan `PromoCard` | Kalimat syarat+hasil kepanjangan buat slot judul `PromoCard` (dibuat buat judul singkat kayak "Diskon 20%"), dan badge "Otomatis" nempatin posisi tombol jadi keliatan kayak CTA padahal bukan. `OfferCard` (udah ada, dipakai di `OfferRail` Menu) jauh lebih pas — foto item pemicu + tagline pendek + nama + harga. Tombol quick-add "+" bawaan `OfferCard` **dicabut** di PAGE-04V (tetap murni info, gak ada shortcut nambah item). |
| 29 | Tap kartu (kedua tipe) di PAGE-04V buka sheet detail, bukan no-op | Reuse pola sheet "Detail Voucher" existing (footer "Mengerti", bukan "Pakai" — sheet ini emang selalu dismiss-only, bukan cuma di Diskon Transaksi). Promo Produk dapet variant sejenis (`DetailPromoSheet Type=Produk`, judul "Detail Promo") — beda dari `PromoRail` PAGE-04 yang tetap no-op total (rule lama gak berubah, ini cuma buat PAGE-04V). |
| 30 | Prinsip "surface = hasil doang" — berlaku semua list promo | Kartu list (PAGE-06V **dan** PAGE-04V, kedua tipe) cuma nampilin judul **hasil** (mis. "Diskon 20%", "Gratis Es Jeruk") — bullet syarat (Min. belanja, Maks. potongan, item pemicu) **dicabut dari kartu list**, cuma kebuka di `DetailPromoSheet` pas kartu ditekan. Alasan: kartu Promo Produk yang isi kalimat syarat+hasil gabungan kepanjangan & keliatan aneh; simplifikasi ini juga diterapkan balik ke Diskon Transaksi biar konsisten satu bahasa desain. |
| 31 | Kartu Promo Produk pakai `PromoCard`, bukan `OfferCard` | Revisi dari keputusan #28 — `OfferCard` (foto+nama+harga) balik dicabut, kartu Promo Produk sekarang **sama bentuk dengan Diskon Transaksi** (`PromoCard`, tag icon, badge "Otomatis" pengganti tombol). Konsisten satu bahasa visual di seluruh list promo. |
| 32 | Bullet Syarat di `DetailPromoSheet` pakai dot netral, bukan checkmark | `Icon/checkCircle` keliru nyiratin syarat sudah terpenuhi — padahal ini cuma daftar syarat, belum tentu sudah kepenuhi tamu. Diganti dot abu netral (reuse style bullet yang sama dipakai di `PromoCard`). Section paragraf bawah (dulu "Syarat & Ketentuan") diganti nama jadi **"Deskripsi"** — framing-nya deskripsi promo, bukan bahasa hukum T&C. |
| 33 | Kartu Diskon Transaksi read-only (PAGE-04V) dapet chevron | Setelah bullet syarat dicabut (keputusan #30) dan kartu ini emang gak punya tombol dari awal, kartunya keliatan kosong/timpang — banyak ruang blank di kanan. Slot itu diisi chevron ">" — sekalian nandain kartu tappable ke `DetailPromoSheet`, bukan cuma dekor. |
| 34 | PAGE-04V: section digabung jadi 1 list, badge "Otomatis" dicabut, tambah subtitle | Label section "PROMO PRODUK · OTOMATIS" / "DISKON TRANSAKSI" dan badge "Otomatis" **dicabut total** — tamu gak perlu tahu kategori internal Produk vs Transaksi, semua promo digabung jadi **satu list**, terurut A→Z campur (bukan per-kategori). Konsekuensinya kartu Promo Produk kehilangan pembeda visual (badge) — makanya kartu Promo Produk dapet **subtitle 1 baris** (nama item pemicu), biar gak kosong/timpang (keluhan "terlalu kosong"). |
| 35 | Subtitle "Diskon Transaksi" dicabut lagi | Revisi #34 — subtitle "Diskon Transaksi" yang sempat ditambah buat kartu Diskon Transaksi ternyata cuma nyebut ulang nama kategori ke tamu, gak nambah info berguna, dan kontradiksi sama prinsip "tamu gak perlu tahu kategori" di keputusan #34 itu sendiri. Dicabut — kartu Diskon Transaksi sekarang judul + chevron doang, tanpa subtitle (beda dari kartu Promo Produk yang tetap pakai subtitle nama item, karena itu genuinely informatif, bukan cuma label kategori). |
| 36 | Balik nampilin syarat langsung di kartu — threshold ≤2 | **Revisi #30/#34/#35 soal "hasil doang."** PM: bullet syarat (Min. belanja, Maks. potongan / syarat kuantitas Promo Produk) balik ditampilkan **langsung di kartu**, gak perlu tap dulu — selama jumlah syarat **≤2**, yang mana mencakup SEMUA kasus nyata sekarang (Diskon Transaksi maks 2 syarat, Promo Produk 1 syarat). Kalau ada promo >2 syarat di masa depan, baru kartu diringkas + chevron + `DetailPromoSheet` jadi wajib. Chevron & subtitle item-pemicu yang sempat dipakai (keputusan #33/#34) jadi gak perlu lagi buat kasus ≤2 syarat, karena body kartu udah terisi bullet — cuma masih dipakai kalau kelak ada kasus >2 syarat. Yang TETAP berlaku dari #34: satu list gabungan tanpa section/badge kategori. |
| 37 | Bullet dot diganti 1 paragraf deskripsi + template kalimat resmi | **Revisi #36.** PM kasih referensi visual (Figma node `3407:496`) + 4 template kalimat baku buat deskripsi promo — lihat [[SO_Case_TemplateDeskripsiPromo]] buat detail lengkap & alasan tiap template. Perubahan: (1) list bullet dot diganti **1 paragraf mengalir**; (2) paragraf itu jelasin **hasil + batas maksimal**, bukan syarat pemicu (syarat pemicu gak disebut sama sekali di kartu — beda dari keputusan #36 yang masih nampilin syarat); (3) "gratis" (barang lain gratis) ditulis sebagai **"Diskon 100%"** — satu aturan kalimat buat semua kasus produk, gak ada kalimat "gratis" terpisah. Berlaku di PAGE-04V & PAGE-06V. |
| 38 | Chevron balik ditambah di kartu PAGE-04V | Kartu tanpa badge/tombol butuh sinyal visual kalau bisa ditekan (buka `DetailPromoSheet`) — chevron ">" ditambah lagi di kanan tiap kartu, vertically centered. Tidak berlaku di PAGE-06V (tombol Pakai/Dipakai udah cukup jadi sinyal interaktif di sana). |
| 39 | Spacing kartu dirapetin | Gap antar-elemen (icon↔teks↔chevron) kerasa longgar setelah body jadi lebih tinggi (deskripsi 2-3 baris). Padding kartu 14→**12px**, gap antar-elemen 13→**10px**, gap title↔deskripsi 4→**3px**, chip 60×60→**52×52**. Berlaku di kedua halaman (PAGE-04V & PAGE-06V). |
| 40 | Section "Periode Promosi" ditambah ke `DetailPromoSheet` | PM minta info periode aktif promo (tanggal mulai-akhir, hari berlaku, jam aktif) ditampilkan ke tamu — referensi gaya dari tampilan admin (POS/Accurate Online "Pengaturan Promo" § Periode Promosi). Ditaruh di antara "Syarat" dan "Deskripsi" (rekomendasi Claude, PM defer keputusan posisi). Berlaku dua-duanya (Promo Produk & Diskon Transaksi). Bikin `Icon/calendar` baru (belum ada di design system) — reuse `Icon/clock` yang udah ada. **Asumsi:** cuma nangani 1 rentang jam aktif per hari; kalau admin set >1 rentang jam ("+ Tambah Jam Aktif" di AOL), belum ada aturan tampilnya — lihat Pertanyaan Terbuka [[SO_Case_TemplateDeskripsiPromo]]. |
| 41 | Format teks "hari" di Periode Promosi & fix label/layout | Jawab Pertanyaan Terbuka #3: "Setiap hari" (7 hari) · "Hari {hari}" (1 hari) · "Hari {awal} Sampai {akhir}" (≥2 hari berurutan) — detail & contoh di [[SO_Case_TemplateDeskripsiPromo]]. Sekalian benerin 2 bug dari build sebelumnya: (1) label "PERIODE PROMOSI" kebetulan ke-bind ke variable border (opacity 8%, nyaris gak keliatan) — dibenerin ke variable teks muted yang sama dipakai "SYARAT"; (2) baris tanggal+hari sempat gak nempel jadi 1 baris (bug nesting) lalu setelah dibenerin malah kepotong kalau teks hari panjang ("Hari Senin Sampai Sabtu") — dibenerin pakai `layoutWrap` biar otomatis pindah baris kalau kepanjangan, bukan kepotong. |
| 42 | Icon "hari" diganti `Icon/repeat`, beda dari `Icon/calendar` | PM: 2 icon calendar identik (tanggal & hari) bikin bingung "calendar yang mana". Icon baris hari diganti `Icon/repeat` (dua panah muter, lambang pola berulang) — beda bentuk dari `Icon/calendar` (tanggal spesifik), jadi tamu bisa bedain sekilas. Sekalian ke-fix 2 bug korupsi data yang gak berkaitan sama perubahan ini: teks Syarat sempat ke-merge jadi 1 baris ("Min. belanja Rp100.000 (Maks. potongan Rp30.000)") — dipisah balik jadi 2 bullet; dan ada baris "hari" duplikat nyasar (leftover dari edit sebelumnya) — dihapus. |
| 43 | "Maks. potongan" dicabut dari bullet Syarat — itu bukan syarat | PM koreksi: "Maks. potongan Rp30.000" **bukan syarat qualifying** (bukan sesuatu yang tamu perlu penuhi) — itu **batas/cap dari hasil** (nilai diskon dibatasi maksimal segitu). Dicabut dari section "Syarat" (yang jadinya cuma "Min. belanja Rp100.000"); info cap-nya tetap ada di subjudul header & paragraf "Deskripsi" (gak hilang, cuma dipindah ke tempat yang benar). Berlaku sama buat Promo Produk: "Maksimum N barang" juga bukan syarat, itu batas kuantitas hasil — section "Syarat" Promo Produk isinya cuma syarat pemicu (mis. "Beli 2 Ayam Goreng"), sudah benar dari awal. |
| 44 | Copy min+maks digabung 1 baris: "Minimal transaksi Rp{X} (Maksimal {Y})" | Revisi wording dari #43 — PM: "Min. belanja Rp100.000" kurang jelas. Diganti **"Minimal transaksi Rp100.000 (Maksimal 30.000)"** — min & maks tetap 1 baris gabungan (bukan 2 baris terpisah kayak sebelum #43), tapi maks ditulis dalam kurung (posisi sekunder/parentetikal — bukan syarat yang setara, cuma info tambahan). Dipakai di subjudul header **dan** bullet Syarat (2 tempat, copy sama biar konsisten). Paragraf "Deskripsi" belum diubah (masih pakai frasa "minimum belanja... maksimal potongan..." versi lama) — belum diminta eksplisit, flag buat diselaraskan kalau perlu. |
| 45 | Icon Periode Promosi diturunin ke warna muted, bukan ink gelap | PM: icon calendar/repeat/clock kelihatan sehitam ink (dark), padahal teks di sebelahnya pakai warna muted (lebih terang) — kontrasnya njomplang. Semua icon di section "Periode Promosi" diganti ke variable teks muted yang sama dipakai teksnya, biar senada satu section. |

---

## 11. Traceability

| FR ID | Halaman | AC ID |
|---|---|---|
| FR-01 | PAGE-01 | AC-01.1 … AC-01.5 |
| FR-02 | PAGE-04 | AC-04.1 … AC-04.6 |
| FR-02b | PAGE-04V | AC-04V.1 … AC-04V.5 |
| FR-03 | PAGE-05 | AC-05.1 … AC-05.10 |
| FR-04 | PAGE-06 | AC-06.1, AC-06.4, AC-06.7, AC-06.8, AC-06.9, AC-06.10 |
| FR-05b | PAGE-06V | AC-06V.1 … AC-06V.6, AC-06V.10, AC-06V.11 |
| FR-06 | PAGE-06 | AC-06.11, AC-06.12 |
| FR-07b | PAGE-08 | AC-08.7 … AC-08.10 |
| FR-08 | `ValidationPopup` | AC-NC.1 … AC-NC.6 |
| FR-09 | PAGE-08 | AC-08.1, AC-08.2, AC-08.4, AC-08.5, AC-08.6 |
| FR-10 | PAGE-09 | AC-09.1 … AC-09.7 |
| FR-12 | PAGE-11 | AC-11.1, AC-11.4, AC-11.5 |
| FR-13 | PAGE-11 | AC-11.8 … AC-11.11 |
| FR-14 | Global | AC-NET.1, AC-NET.2 |
| FR-15 | PAGE-04, PAGE-06 | AC-04.6, AC-06.10 |

---

## 12. Yang Belum Diputuskan

Pertanyaan panjang minimum nomor WhatsApp dari v2.0 **gugur otomatis** — channel WhatsApp untuk struk dihapus, dan field No. HP di PAGE-08 tidak punya validasi format yang ditampilkan ke tamu (lihat §6.3).

**3 pertanyaan terbuka dari perubahan Promo Produk auto-apply** (belum diputuskan PM, lihat [[SO_Case_PromoProdukAutoApply]] § Pertanyaan Terbuka): copy pasti `IssueRow` saat hadiah promo habis stok; urutan tampil di "Informasi Promo" kalau item ke-match >2 Promo Produk; tie-break kalau nilai hasil dua promo yang bentrok persis sama.

---

## 13. Yang Belum Ada / Belum Diverifikasi di Figma

Bagian berikut sudah dispesifikasikan di dokumen ini tapi **belum dibangun** atau **belum diverifikasi** ada di Figma pada revisi ini. Developer & desainer perlu tahu supaya tidak menganggapnya sudah siap pakai.

| Bagian | Status |
|---|---|
| PAGE-04V — frame `1315:36446` ("Promo Hari Ini — Katalog"): satu list gabungan (Promo Produk + Diskon Transaksi, tanpa pemisah section/badge), 6 `PromoCard` — judul hasil + 1 paragraf deskripsi (pakai 4 template [[SO_Case_TemplateDeskripsiPromo]]), terurut A→Z | **Draft dibangun** untuk referensi struktur/copy. |
| PAGE-06V — frame `534:539`, kedua `PromoCard` (`Status=Terpakai`/`Aktif`) — judul hasil + 1 paragraf deskripsi + tombol Pakai/Dipakai. Kontras teks deskripsi di kartu `Status=Terpakai` (bg teal) agak rendah — warisan dari desain lama, belum diperbaiki. | **Sudah diterapkan** di frame existing. |
| `DetailPromoSheet Type=Produk` ("Detail Promo") — clone dari Sheet "Detail Voucher" existing (`1315:36503`), contoh isi di frame standalone `3360:397` dekat PAGE-04V. Kedua sheet (`1315:36503` & `3360:397`) sudah dibenerin: bullet Syarat pakai dot netral (bukan `Icon/checkCircle`), label "Syarat & Ketentuan" jadi "Deskripsi", **section "Periode Promosi" baru ditambah** (`Icon/calendar` baru dibuat, `Icon/clock` reuse existing). | **Draft dibangun** untuk referensi konten. Belum dirangkai jadi overlay utuh di atas PAGE-04V/PAGE-06V (belum ada scrim + posisi sheet final terpasang ke masing-masing frame). |

| Bagian | Status |
|---|---|
| Field "Data Pelanggan" (No. HP) di PAGE-08 QR Statis | **Sudah dibangun** di Figma (2 layar: QRIS & Bayar di Kasir), termasuk penghapusan chip "Masuk" di kedua layar itu. |
| Rename Voucher → Promo (komponen, CTA, judul halaman) | **Belum dilakukan di Figma.** Baru keputusan penamaan di dokumen ini — komponen `VoucherPickCard`/`VoucherCTA`/`VoucherTicket`/`VoucherRail` di Figma masih pakai nama lama. |
| Label "PROMO" di `MenuCard` (varian Grid) | **Dibatalkan** — badge ini tidak jadi dibangun. Info Promo Produk per item dipindah total ke `PromoRail`/`OfferRail`. Lihat [[SO_Case_PromoProdukAutoApply]]. |
| Tombol "Pakai" ↔ "Dipakai" (lepas Diskon Transaksi) | **Belum diverifikasi.** Perlu dicek apakah `VoucherPickCard`/`PromoCard` di Figma sudah mendukung toggle lepas, atau baru bisa "Pakai" satu arah. |
| `ShareReceiptSheet` versi Email-saja | **Belum dibangun.** Figma saat ini (dari case doc Negative Case & Toast Sukses Bagikan Struk) masih menampilkan dua channel (WhatsApp + Email). Perlu dirombak jadi satu field email. |
| Komponen error jaringan global | Ilustrasi tersedia di Arsip, komponen belum dibuat. |
| `Toast` variant `Tone=Success` | Sudah disetujui, belum diimplementasi di Figma. |
| Kartu panduan "🏷 Kategori Promo" | **Sudah dibangun** di Figma, page ↳ Fondasi & Panduan. |
| Nomor ref di `ProcessingScreen` QRIS ([[SO_Case_NomorRefQRIS]]) | Sudah disetujui, belum diimplementasi di Figma. |
| PAGE-07 (`FreeItemSheet`) & aturan prioritas antar-Promo Produk | **Belum digambar di Figma.** Spec teks & perilaku sudah final di [[SO_Case_PromoProdukAutoApply]] — PAGE-07 perlu dihapus dari canvas, badge PROMO di `MenuCard` perlu dihapus. |
| Row "Informasi Promo" (PAGE-05, node `529:380`) & `PromoListSheet` baru | **Belum digambar di Figma.** Chevron di node existing cuma dipertahankan untuk kasus >1 promo (buka `PromoListSheet`); kasus 1 promo jadi statis tanpa chevron. `PromoListSheet` itu sendiri komponen baru, belum ada di canvas sama sekali. |

---

*Dokumen ini menggantikan `SO_PRD_MVP.md` v2.0. Perubahan utama v3.0: member tidak lagi memberi poin (No. HP kini murni untuk pelaporan POS internal, tidak memengaruhi harga/SPA); identitas pindah dari chip+sheet ke field inline "Data Pelanggan · opsional" — khusus QR Statis, QR Dinamis sengaja belum diselaraskan; Bagikan Struk jadi email saja tanpa carry-over nomor; Voucher diganti nama jadi Promo dengan kategorisasi baru (Promo Produk vs Diskon Transaksi berdasar letak hasil, bukan pemicu).*
