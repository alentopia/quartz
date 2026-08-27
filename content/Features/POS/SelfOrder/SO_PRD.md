# Self Order — PRD

<!-- Output skill /prd-agent. ID stabil: PAGE-0X, FR-0X, AC-0X.Y. Semua wikilink target wajib ada. -->

**Status:** Review
**Versi:** 0.2
**Tanggal:** 2026-06-09
**Author:** /prd-agent
**Fitur:** Self Order
**Prefix:** SO
**Bahasa:** Indonesia

---

## Daftar Isi

- [[SO_PRD#1. Executive Summary|1. Executive Summary]]
- [[SO_PRD#2. Problem Statement|2. Problem Statement]]
- [[SO_PRD#3. Goals & Success Metrics|3. Goals & Success Metrics]]
- [[SO_PRD#4. Scope|4. Scope]]
- [[SO_PRD#5. Page Map|5. Page Map]]
- [[SO_PRD#6. Feature List|6. Feature List]]
- [[SO_PRD#7. Spesifikasi Halaman|7. Spesifikasi Halaman]]
    - [[SO_PRD#PAGE-01 — Landing / QR Entry|PAGE-01 — Landing / QR Entry]]
    - [[SO_PRD#PAGE-02 — Login Nomor HP|PAGE-02 — Login Nomor HP]]
    - [[SO_PRD#PAGE-03 — Verifikasi OTP|PAGE-03 — Verifikasi OTP]]
    - [[SO_PRD#PAGE-04 — Menu / Katalog|PAGE-04 — Menu / Katalog]]
    - [[SO_PRD#PAGE-05 — Detail Item & Tambah ke Keranjang|PAGE-05 — Detail Item & Tambah ke Keranjang]]
    - [[SO_PRD#PAGE-06 — Keranjang|PAGE-06 — Keranjang]]
    - [[SO_PRD#PAGE-07 — Pilih Item Hadiah Promo|PAGE-07 — Pilih Item Hadiah Promo]]
    - [[SO_PRD#PAGE-08 — Review Read-only (Cek Stok & Promo)|PAGE-08 — Review Read-only (Cek Stok & Promo)]]
    - [[SO_PRD#PAGE-09 — Pembayaran|PAGE-09 — Pembayaran]]
    - [[SO_PRD#PAGE-10 — Open Bill (Ringkasan Sesi & Tambah Order)|PAGE-10 — Open Bill (Ringkasan Sesi & Tambah Order)]]
    - [[SO_PRD#PAGE-11 — Konfirmasi Sukses & Handoff WL|PAGE-11 — Konfirmasi Sukses & Handoff WL]]
- [[SO_PRD#8. Cross-Cutting|8. Cross-Cutting]]
- [[SO_PRD#9. Data & Integrasi|9. Data & Integrasi]]
- [[SO_PRD#10. Open Questions / TBD|10. Open Questions / TBD]]
- [[SO_PRD#11. Appendix — Referensi (Web Research)|11. Appendix — Referensi (Web Research)]]
- [[SO_PRD#12. Traceability|12. Traceability]]

---

## 1. Executive Summary

**Self Order** adalah fitur pemesanan mandiri berbasis **web mobile** (tanpa instalasi aplikasi) untuk pelanggan restoran Accurate POS. Pelanggan memindai **QR Code** di restoran, lalu memilih menu, mengelola keranjang, menerapkan diskon, memeriksa stok & promo, dan menyelesaikan pesanan — tanpa harus menunggu atau memanggil waiter. Fitur ini mendukung **dua tipe QR** (statis & dinamis) dengan **tiga metode** transaksi, dan menjadi **alur hulu** sebelum fitur antrean [[WL_Overview|Waiting List]]: untuk metode bayar-di-muka, pelanggan otomatis didaftarkan ke antrean WL setelah membayar. Nilai utamanya: mempercepat operasional layanan, mengurangi friksi tamu, dan menjaga seluruh transaksi tetap terintegrasi dalam satu sistem POS.

## 2. Problem Statement

Restoran dengan jam ramai menghadapi:
- **Tamu harus menunggu waiter** untuk memesan → layanan lambat, antrean pencatatan order, dan rawan salah catat.
- **Beban staf tinggi** saat ramai — banyak tenaga terpakai hanya untuk mencatat pesanan.
- **Tamu tidak tahu ketersediaan stok & promo** saat memesan → order gagal/refund dan kekecewaan tamu.

Self Order memindahkan proses pesan (dan bayar, untuk metode tertentu) ke tangan tamu lewat QR, dengan validasi stok & promo real-time, sehingga layanan lebih cepat dan beban staf berkurang.

## 3. Goals & Success Metrics

> Atas keputusan PM, bagian **Goals & Success Metrics sengaja tidak disertakan** dalam PRD ini. Fokus dokumen ada pada spesifikasi fungsional, alur, dan UI yang siap di-parse untuk desain dan implementasi.

## 4. Scope

### In Scope
- Alur **pelanggan** Self Order di **web mobile** (browser HP, tanpa app).
- **Tiga metode** transaksi:
    - **Metode A** — QR **Statis** → **login Nomor HP + OTP (WhatsApp)** → **bayar di muka** (Bayar Langsung / Online QRIS).
    - **Metode B** — QR **Dinamis** → **Open Bill** (bayar belakangan), tambah order bertahap.
    - **Metode C** — QR **Dinamis** → **bayar di muka** (Bayar Langsung / Online QRIS).
- **Deferred/contextual login**: tamu boleh browse menu & isi keranjang sebagai *guest*; login (metode A) hanya dipicu saat checkout.
- **Katalog menu** dengan harga & ketersediaan **live** (QR statis pun melalui *resolver* sehingga menu selalu update), penanda item **habis (86)** real-time, dan **re-validasi** stok + promo saat "Cek Stok & Promo".
- **Promo**: promo otomatis dan **promo-dapat-item** (sebagian otomatis, sebagian tamu memilih item hadiah). ~~Kode diskon manual~~ — dihapus dari scope (revisi 2026-07-14). Untuk **open bill**, promo dihitung **per-order, tidak lintas-order**.
- **Review read-only** (ringkasan order terkunci, divalidasi server) sebelum bayar / buka bill.
- **Pembayaran**: **Bayar Langsung** (di tempat/kasir) & **Bayar Online (QRIS)** dengan **auto-detect status sukses** (polling).
- **Handoff ke [[WL_Overview|Waiting List]]**: definisi titik integrasi — untuk metode **A & C** (bayar di muka) tamu di-*enqueue* ke WL setelah pembayaran sukses.
- - **Setting & generate QR oleh operator/admin**.

### Out of Scope
- **Detail antrean WL** (nomor antrean, posisi, estimasi tunggu) — hanya **titik handoff** yang masuk; selebihnya di [[WL_Overview]].
- **Handoff WL untuk Open Bill (Metode B)** — **di-hold/TBD** (lihat [[SO_PRD#10. Open Questions / TBD|Open Questions]]).
- **Channel Bayar Online selain QRIS** (bank Virtual Account BCA/Mandiri dll) — *future*, ditampilkan sebagai konsep pilihan tetapi tidak dispesifikasi detail.
- Loyalty/poin, push/SMS notifikasi non-OTP, integrasi platform pihak ketiga (GoFood/GrabFood).
- "Ingat nomor HP / skip OTP", badge "stok menipis", dan promo-transparency nudge (tidak dipilih PM pada Fase Research).

## 5. Page Map

| Page ID | Nama Halaman                              | Tujuan singkat                                               | Diakses dari                                                |
| ------- | ----------------------------------------- | ------------------------------------------------------------ | ----------------------------------------------------------- |
| PAGE-01 | Landing / QR Entry                        | Loading, validasi QR, deteksi statis/dinamis, routing        | Scan QR (entry)                                             |
| PAGE-02 | Login Nomor HP                            | Input nomor HP (sheet, kontekstual saat checkout) — Metode A | PAGE-06 (tap "Cek Stok & Promo")                            |
| PAGE-03 | Verifikasi OTP                            | Input kode OTP WhatsApp — Metode A                           | PAGE-02                                                     |
| PAGE-04 | Menu / Katalog                            | Kategori, cari, daftar item live, penanda habis              | PAGE-01; PAGE-05/06 (kembali); PAGE-10 (tambah order)       |
| PAGE-05 | Detail Item & Tambah ke Keranjang         | Varian, qty, catatan, tambah ke keranjang (sheet)            | PAGE-04                                                     |
| PAGE-06 | Keranjang                                 | Kelola item, apply diskon, subtotal, mulai checkout          | PAGE-04 (ikon keranjang); PAGE-05                           |
| PAGE-07 | Pilih Item Hadiah Promo *(kondisional)*   | Tamu memilih item hadiah saat promo memberi item pilihan     | PAGE-06 / PAGE-08 (saat promo butuh pilihan)                |
| PAGE-08 | Review Read-only (Cek Stok & Promo)       | Ringkasan order terkunci, stok & promo tervalidasi server    | PAGE-06 (Metode B/C) atau PAGE-03 (Metode A, setelah login) |
| PAGE-09 | Pembayaran                                | Bayar Langsung / Online QRIS + auto-detect sukses            | PAGE-08 (bayar di muka); PAGE-10 (tutup & bayar bill)       |
| PAGE-10 | Open Bill (Ringkasan Sesi & Tambah Order) | Bill terbuka, tambah order, promo per-order — Metode B       | PAGE-08 (pilih "Buka Bill")                                 |
| PAGE-11 | Konfirmasi Sukses & Handoff WL            | Sukses; A & C → info masuk antrean WL; B → tanpa WL          | PAGE-09 (bayar sukses)                                      |

**Alur navigasi:**

- **Umum:** PAGE-01 → PAGE-04 → (PAGE-05 → PAGE-04/PAGE-06) → PAGE-06 → tap **"Cek Stok & Promo"**.
- **Metode A (QR Statis):** PAGE-06 → **PAGE-02 → PAGE-03** (login+OTP) → PAGE-08 → PAGE-09 → PAGE-11.
- **Metode C (QR Dinamis, bayar di muka):** PAGE-06 → PAGE-08 → (tombol **"Bayar Sekarang"**) → PAGE-09 → PAGE-11.
- **Metode B (QR Dinamis, open bill):** PAGE-06 → PAGE-08 → (tombol **"Buka Bill"**) → PAGE-10 → (tambah order: PAGE-10 → PAGE-04 → … → PAGE-08 → "Tambahkan ke Bill" → PAGE-10) → (opsional **"Tutup & Bayar"** → PAGE-09).
- **PAGE-07** disisipkan dari PAGE-06/PAGE-08 hanya bila promo aktif memerlukan tamu memilih item hadiah.

## 6. Feature List

| FR ID | Deskripsi | Halaman terkait |
|-------|-----------|-----------------|
| FR-01 | **Entry & Routing QR** — deteksi QR statis vs dinamis, validasi QR, resolve menu live, arahkan ke metode yang sesuai (A vs B/C) | PAGE-01 |
| FR-02 | **Browse Katalog Menu** — kategori, pencarian, foto/deskripsi/harga **live**, penanda **habis (86)** real-time | PAGE-04 |
| FR-03 | **Detail Item & Tambah ke Keranjang** — varian/opsi, qty, catatan | PAGE-05 |
| FR-04 | **Kelola Keranjang** — ubah qty, hapus item, subtotal | PAGE-06 |
| FR-05 | ~~**Apply Diskon** — input & validasi kode diskon~~ — **dihapus** (revisi 2026-07-14, tidak dipakai) | PAGE-06 |
| FR-06 | **Promo Otomatis & Promo-dapat-Item** — promo otomatis; item hadiah otomatis atau dipilih tamu | PAGE-06, PAGE-07, PAGE-08 |
| FR-07 | **Contextual Login HP + OTP** — login deferred saat checkout (Metode A), OTP WhatsApp | PAGE-02, PAGE-03 |
| FR-08 | **Cek Stok & Promo → Review Read-only** — validasi server (stok + promo), ringkasan terkunci | PAGE-08 |
| FR-09 | **Pembayaran** — Bayar Langsung + Online QRIS dengan auto-detect status sukses | PAGE-09 |
| FR-10 | **Open Bill** — buka bill, tambah order, promo **per-order**, tutup & bayar | PAGE-10 |
| FR-11 | **Konfirmasi & Handoff WL** — sukses order; enqueue WL (A & C); B tanpa WL (hold) | PAGE-11 |
| FR-12 | **Manajemen Sesi & Error Lintas-halaman** — QR invalid/kedaluwarsa, sesi habis, gangguan koneksi | Semua |

---

## 7. Spesifikasi Halaman

### PAGE-01 — Landing / QR Entry

- **Route / entry point:** URL hasil scan QR, mis. `https://order.accuratepos.id/s/{venueId}/{qrToken}` (statis) atau `…/d/{venueId}/{sessionToken}` (dinamis). Halaman pertama yang dibuka browser HP.
- **Tujuan:** Memvalidasi QR, men-*resolve* konteks (venue, meja/sesi, tipe QR), memuat menu live, lalu mengarahkan tamu ke alur yang benar.
- **Aktor:** Pelanggan (guest).
- **Element Inventory:**
    1. Logo/nama restoran — tipe: gambar/teks; copy: dinamis dari venue; posisi: tengah atas; perilaku: tampil setelah resolve sukses.
    2. Indikator konteks — tipe: chip/teks; copy: untuk dinamis "Meja {nomorMeja}", untuk statis "Pesan Mandiri"; posisi: bawah logo.
    3. Spinner + pesan loading — tipe: loader; copy: "Menyiapkan menu…"; posisi: tengah.
    4. Tombol "Lihat Menu" — tipe: primary button; copy: "Lihat Menu"; posisi: bawah; perilaku: ke PAGE-04 (muncul bila auto-redirect dimatikan / setelah resolve).
    5. Area error — tipe: panel; copy: lihat States→error; posisi: tengah.
- **States:**
    - default: setelah resolve sukses → tampil logo + konteks + auto-redirect ke PAGE-04 (atau tombol "Lihat Menu").
    - empty: tidak relevan (selalu ada konteks venue bila token valid).
    - loading: spinner + "Menyiapkan menu…" selama resolve QR & muat katalog.
    - error: QR tidak valid → "QR tidak dikenali. Minta bantuan staf, ya." ; QR kedaluwarsa (dinamis) → "Sesi meja ini sudah berakhir. Pindai ulang QR di meja atau hubungi staf." ; venue nonaktif → "Pemesanan mandiri sedang tidak tersedia di restoran ini."
    - success: redirect ke PAGE-04.
    - disabled: tombol "Lihat Menu" disabled selama loading.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | qrToken / sessionToken | Wajib ada & valid di server | "QR tidak dikenali. Minta bantuan staf, ya." |
    | sessionToken (dinamis) | Belum kedaluwarsa | "Sesi meja ini sudah berakhir. Pindai ulang QR di meja atau hubungi staf." |
    | venue status | Aktif & Self Order menyala | "Pemesanan mandiri sedang tidak tersedia di restoran ini." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | loading_msg | "Menyiapkan menu…" |
    | ctx_static | "Pesan Mandiri" |
    | ctx_dynamic | "Meja {nomorMeja}" |
    | btn_view_menu | "Lihat Menu" |
    | err_invalid_qr | "QR tidak dikenali. Minta bantuan staf, ya." |
    | err_expired_session | "Sesi meja ini sudah berakhir. Pindai ulang QR di meja atau hubungi staf." |
    | err_venue_off | "Pemesanan mandiri sedang tidak tersedia di restoran ini." |
    | btn_retry | "Coba Lagi" |

- **Edge Cases:**
    - Resolve > 10 detik (koneksi lambat) → tetap di loading; bila timeout, tampilkan error + tombol "Coba Lagi".
    - Tamu membuka kembali URL statis lama → resolver tetap memuat menu terbaru (Pola B: static QR via resolver).
    - QR dinamis sudah ditutup kasir → error kedaluwarsa.
- **Acceptance Criteria:**
    - **AC-01.1** — Given tamu memindai QR statis valid, When halaman dimuat dan resolve sukses, Then sistem memuat menu live dan mengarahkan ke PAGE-04 dengan konteks "Pesan Mandiri".
    - **AC-01.2** — Given tamu memindai QR dinamis valid, When resolve sukses, Then PAGE-04 terbuka dengan konteks "Meja {nomorMeja}".
    - **AC-01.3** — Given token QR tidak dikenali server, When resolve gagal, Then tampil pesan "QR tidak dikenali. Minta bantuan staf, ya." dan tombol "Coba Lagi".
    - **AC-01.4** — Given QR dinamis kedaluwarsa, When resolve, Then tampil pesan err_expired_session dan tamu tidak dapat lanjut ke menu.
    - **AC-01.5** — Given resolve melebihi 10 detik, When timeout terjadi, Then tampil error koneksi dengan tombol "Coba Lagi" tanpa kehilangan URL konteks.

---

### PAGE-02 — Login Nomor HP

> **⚠️ Revisi 2026-07-14 — perlu dikonfirmasi ulang ke PM:** login **bukan** input nomor HP manual + kode OTP 6 digit seperti dispesifikasikan di bawah — mekanisme aktual lewat **WhatsApp langsung** (tanpa field nomor HP bebas-ketik). Konsekuensinya, skenario negatif "format nomor HP salah", "gagal kirim OTP", dan "rate-limit percobaan OTP" **kemungkinan besar tidak berlaku**. Spesifikasi di bawah dipertahankan sebagai draft lama sampai mekanisme WhatsApp yang sebenarnya didefinisikan ulang — lihat [[SO_PRD#10. Open Questions / TBD|OQ-SO-10]].

- **Route / entry point:** Bottom sheet kontekstual; dipicu saat tamu **Metode A** menekan "Cek Stok & Promo" di PAGE-06 dalam keadaan belum login. **Tidak** muncul di awal.
- **Tujuan:** Mengumpulkan nomor HP tamu sebagai identitas pesanan & pembayaran (wajib untuk Metode A), dengan friksi minimal (Pola A: deferred login).
- **Aktor:** Pelanggan (guest → teridentifikasi).
- **Element Inventory:**
    1. Judul sheet — tipe: teks; copy: "Masuk untuk lanjut pesan"; posisi: atas sheet.
    2. Subjudul manfaat — tipe: teks; copy: "Pakai nomor HP buat konfirmasi pesanan & pantau antreanmu. Cuma sekali, kok."; posisi: bawah judul.
    3. Field Nomor HP — tipe: input tel; label: "Nomor HP"; prefix "+62"/format 08; placeholder "Contoh: 0812xxxxxxx"; perilaku: numeric keypad, auto-strip spasi.
    4. Tombol "Kirim Kode OTP" — tipe: primary button; copy: "Kirim Kode OTP"; perilaku: validasi → kirim OTP WhatsApp → ke PAGE-03; disabled sampai format valid.
    5. Catatan privasi — tipe: teks kecil; copy: "Nomormu hanya dipakai untuk pesanan ini."; posisi: bawah tombol.
    6. Tombol tutup (X) — tipe: icon button; perilaku: tutup sheet, kembali ke PAGE-06 (tamu tetap bisa edit keranjang).
- **States:**
    - default: field kosong, tombol "Kirim Kode OTP" disabled.
    - empty: field nomor kosong → tombol disabled.
    - loading: setelah tap kirim → tombol jadi spinner "Mengirim…", field terkunci.
    - error: nomor tidak valid (inline); gagal kirim OTP → "Gagal mengirim kode. Coba lagi sebentar lagi." ; nomor diblokir/limit → "Terlalu banyak percobaan. Coba lagi dalam beberapa menit."
    - success: OTP terkirim → transisi ke PAGE-03.
    - disabled: tombol disabled selama format invalid / loading.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Nomor HP | Wajib diisi | "Nomor HP wajib diisi." |
    | Nomor HP | Format Indonesia valid (diawali 08 atau +62), 9–13 digit angka | "Format nomor HP belum benar. Contoh: 0812xxxxxxx." |
    | Nomor HP | Lolos rate-limit pengiriman OTP | "Terlalu banyak percobaan. Coba lagi dalam beberapa menit." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | sheet_title | "Masuk untuk lanjut pesan" |
    | sheet_benefit | "Pakai nomor HP buat konfirmasi pesanan & pantau antreanmu. Cuma sekali, kok." |
    | label_phone | "Nomor HP" |
    | ph_phone | "Contoh: 0812xxxxxxx" |
    | btn_send_otp | "Kirim Kode OTP" |
    | btn_send_otp_loading | "Mengirim…" |
    | privacy_note | "Nomormu hanya dipakai untuk pesanan ini." |
    | err_phone_required | "Nomor HP wajib diisi." |
    | err_phone_format | "Format nomor HP belum benar. Contoh: 0812xxxxxxx." |
    | err_send_failed | "Gagal mengirim kode. Coba lagi sebentar lagi." |
    | err_rate_limit | "Terlalu banyak percobaan. Coba lagi dalam beberapa menit." |

- **Edge Cases:**
    - Tamu menutup sheet → kembali ke PAGE-06; isi keranjang & diskon tetap utuh.
    - Tamu metode B/C tidak pernah melihat sheet ini (tanpa login).
    - Nomor sudah pernah dipakai di sesi yang sama → tetap kirim OTP normal.
- **Acceptance Criteria:**
    - **AC-02.1** — Given tamu Metode A menekan "Cek Stok & Promo" dan belum login, When sheet terbuka, Then field "Nomor HP" kosong dan tombol "Kirim Kode OTP" disabled.
    - **AC-02.2** — Given tamu mengisi nomor berformat tidak valid, When mengetik/blur, Then tampil "Format nomor HP belum benar. Contoh: 0812xxxxxxx." dan tombol tetap disabled.
    - **AC-02.3** — Given nomor valid, When tamu menekan "Kirim Kode OTP", Then sistem mengirim OTP via WhatsApp dan berpindah ke PAGE-03.
    - **AC-02.4** — Given pengiriman OTP gagal, When respons error diterima, Then tampil "Gagal mengirim kode. Coba lagi sebentar lagi." dan tamu tetap di sheet.
    - **AC-02.5** — Given tamu menutup sheet, When sheet ditutup, Then tamu kembali ke PAGE-06 tanpa kehilangan isi keranjang & diskon.

---

### PAGE-03 — Verifikasi OTP

> **⚠️ Revisi 2026-07-14:** sama seperti catatan di PAGE-02 — verifikasi 6-digit manual di bawah ini kemungkinan **tidak berlaku** kalau login sepenuhnya lewat WhatsApp. Skenario negatif "kode salah/kedaluwarsa/percobaan berlebih" perlu ditinjau ulang begitu mekanisme final dikonfirmasi (lihat OQ-SO-10).

- **Route / entry point:** Lanjutan sheet dari PAGE-02 (Metode A).
- **Tujuan:** Memverifikasi kepemilikan nomor HP via kode OTP WhatsApp.
- **Aktor:** Pelanggan.
- **Element Inventory:**
    1. Judul — copy: "Masukkan kode OTP"; posisi: atas.
    2. Subjudul — copy: "Kami kirim 6 digit kode ke WhatsApp {nomorTersamar}."; nomor ditampilkan tersamar (mis. 0812****789).
    3. Input OTP — tipe: 6 kotak digit; perilaku: numeric, auto-advance, auto-submit saat 6 digit terisi.
    4. Timer & Resend — copy idle: "Kirim ulang kode dalam {detik}s"; copy aktif: "Kirim Ulang Kode"; perilaku: tombol aktif setelah cooldown 60 detik.
    5. Tautan ubah nomor — copy: "Ganti nomor HP"; perilaku: kembali ke PAGE-02.
    6. Tombol "Verifikasi" — copy: "Verifikasi"; disabled sampai 6 digit.
- **States:**
    - default: 6 kotak kosong, timer berjalan 60s, "Verifikasi" disabled.
    - empty: kode kosong → "Verifikasi" disabled.
    - loading: setelah submit → "Memverifikasi…".
    - error: kode salah → "Kode OTP salah. Coba lagi." ; kode kedaluwarsa → "Kode sudah kedaluwarsa. Kirim ulang kode." ; melebihi batas percobaan → "Terlalu banyak percobaan. Tunggu beberapa menit."
    - success: verifikasi sukses → sheet tertutup, lanjut ke PAGE-08 (Review).
    - disabled: "Kirim Ulang Kode" disabled selama timer > 0; "Verifikasi" disabled bila < 6 digit / loading.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Kode OTP | 6 digit angka | "Kode OTP harus 6 digit angka." |
    | Kode OTP | Cocok dengan kode aktif | "Kode OTP salah. Coba lagi." |
    | Kode OTP | Belum kedaluwarsa (maks 5 menit) | "Kode sudah kedaluwarsa. Kirim ulang kode." |
    | Percobaan | Maks 5 percobaan / kode | "Terlalu banyak percobaan. Tunggu beberapa menit." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | title | "Masukkan kode OTP" |
    | subtitle | "Kami kirim 6 digit kode ke WhatsApp {nomorTersamar}." |
    | resend_idle | "Kirim ulang kode dalam {detik}s" |
    | resend_active | "Kirim Ulang Kode" |
    | change_number | "Ganti nomor HP" |
    | btn_verify | "Verifikasi" |
    | btn_verify_loading | "Memverifikasi…" |
    | err_len | "Kode OTP harus 6 digit angka." |
    | err_wrong | "Kode OTP salah. Coba lagi." |
    | err_expired | "Kode sudah kedaluwarsa. Kirim ulang kode." |
    | err_attempts | "Terlalu banyak percobaan. Tunggu beberapa menit." |
    | toast_resent | "Kode baru sudah dikirim ke WhatsApp-mu." |

- **Edge Cases:**
    - Tamu menempel (paste) kode dari WhatsApp → terisi otomatis & auto-submit.
    - Auto-read OTP (bila didukung browser) → field terisi otomatis.
    - Tamu menekan "Ganti nomor HP" → kembali ke PAGE-02, timer di-reset saat kirim ulang.
    - Tamu menutup sheet → kembali ke PAGE-06 (belum login).
- **Acceptance Criteria:**
    - **AC-03.1** — Given OTP terkirim, When PAGE-03 tampil, Then 6 kotak kosong, timer 60 detik berjalan, dan "Kirim Ulang Kode" disabled.
    - **AC-03.2** — Given tamu mengisi 6 digit benar, When kode terverifikasi, Then sheet tertutup dan tamu diarahkan ke PAGE-08.
    - **AC-03.3** — Given tamu mengisi kode salah, When verifikasi, Then tampil "Kode OTP salah. Coba lagi." dan input dapat diisi ulang.
    - **AC-03.4** — Given timer mencapai 0, When cooldown selesai, Then "Kirim Ulang Kode" aktif; menekannya mengirim kode baru dan menampilkan toast "Kode baru sudah dikirim ke WhatsApp-mu."
    - **AC-03.5** — Given kode kedaluwarsa (>5 menit), When verifikasi, Then tampil "Kode sudah kedaluwarsa. Kirim ulang kode."

---

### PAGE-04 — Menu / Katalog

- **Route / entry point:** Dari PAGE-01 (setelah resolve), ikon "Menu" global, atau PAGE-10 (tambah order open bill).
- **Tujuan:** Menampilkan katalog menu **live** (kategori, harga, ketersediaan) dan memfasilitasi pencarian serta penambahan item.
- **Aktor:** Pelanggan (guest atau teridentifikasi).
- **Element Inventory:**
    1. Header konteks — copy: "Pesan Mandiri" / "Meja {nomorMeja}"; posisi: atas.
    2. **Strip ekspektasi login** (hanya Metode A, guest) — copy: "Lihat-lihat dulu aja. Nanti login pakai nomor HP pas checkout."; posisi: bawah header; perilaku: dismissible.
    3. Search bar — placeholder: "Cari menu…"; perilaku: filter real-time.
    4. Tab/chip kategori — tipe: chip horizontal scroll; copy: nama kategori dinamis; perilaku: jump/filter ke kategori.
    5. Kartu item — menampilkan foto, nama, harga, badge promo (bila ada), tombol "Tambah"; item habis → badge "Habis" + kartu redup, tombol diganti "Habis" (disabled).
    6. Floating cart bar — copy: "{n} item · Rp{subtotal}" + "Lihat Keranjang"; posisi: bawah; perilaku: ke PAGE-06; tampil bila keranjang berisi.
- **States:**
    - default: daftar kategori & item live tampil; floating cart muncul bila ada isi.
    - empty: kategori tanpa item / hasil cari kosong → "Menu tidak ditemukan. Coba kata kunci lain." ; menu venue kosong → "Menu belum tersedia. Hubungi staf, ya."
    - loading: skeleton kartu item saat memuat/refresh harga & stok.
    - error: gagal memuat menu → "Gagal memuat menu. Coba lagi." + tombol "Coba Lagi".
    - success: item berhasil ditambah → toast "Ditambahkan ke keranjang" + badge cart bertambah.
    - disabled: kartu/tombol item habis → tombol "Habis" disabled.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Pencarian | Maks 50 karakter | "Kata kunci terlalu panjang." |
    | Ketersediaan item | Item habis tidak dapat ditambah | "Menu ini sedang habis." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | login_strip | "Lihat-lihat dulu aja. Nanti login pakai nomor HP pas checkout." |
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

- **Edge Cases:**
    - Item menjadi habis (86) saat tamu melihat menu → badge "Habis" muncul real-time (Pola C); jika sedang dibuka di PAGE-05, lihat edge case PAGE-05.
    - Harga berubah dari server → kartu memperbarui harga live; perubahan yang memengaruhi keranjang ditegaskan ulang di PAGE-08.
    - Item dengan varian wajib → tombol "Tambah" membuka PAGE-05 (tidak quick-add).
- **Acceptance Criteria:**
    - **AC-04.1** — Given menu berhasil dimuat, When PAGE-04 tampil, Then kategori & item ditampilkan dengan harga dan ketersediaan terkini.
    - **AC-04.2** — Given sebuah item berstatus habis, When ditampilkan, Then kartu menampilkan badge "Habis" dan tombolnya "Habis" (disabled).
    - **AC-04.3** — Given tamu mengetik kata kunci tanpa hasil, When pencarian dijalankan, Then tampil "Menu tidak ditemukan. Coba kata kunci lain."
    - **AC-04.4** — Given keranjang berisi ≥1 item, When PAGE-04 tampil, Then floating cart bar menampilkan jumlah item & subtotal dan dapat menuju PAGE-06.
    - **AC-04.5** — Given tamu Metode A masih guest, When PAGE-04 tampil pertama kali, Then strip "Lihat-lihat dulu aja…" muncul dan dapat ditutup.

---

### PAGE-05 — Detail Item & Tambah ke Keranjang

- **Route / entry point:** Bottom sheet/halaman dari kartu item di PAGE-04.
- **Tujuan:** Menampilkan detail item dan mengonfigurasi pesanan (varian/opsi, jumlah, catatan) sebelum masuk keranjang.
- **Aktor:** Pelanggan.
- **Element Inventory:**
    1. Foto item — posisi: atas.
    2. Nama, deskripsi, harga dasar — posisi: bawah foto.
    3. Grup opsi/varian — tipe: radio (wajib pilih satu) / checkbox (add-on); copy: nama grup + tanda "Wajib"; perilaku: harga total menyesuaikan.
    4. Stepper jumlah — copy: kontrol "−" / "+" dengan angka; default 1; min 1.
    5. Catatan untuk dapur — tipe: textarea; placeholder: "Contoh: tanpa sambal"; opsional; maks 140 karakter.
    6. Tombol tambah — copy: "Tambah • Rp{totalItem}"; perilaku: validasi opsi wajib → tambah ke keranjang → tutup sheet + toast.
- **States:**
    - default: opsi default terpilih bila ada, qty 1, tombol menampilkan total.
    - empty: tidak relevan.
    - loading: memuat detail item / harga opsi.
    - error: gagal memuat detail → "Gagal memuat detail menu. Coba lagi." ; opsi wajib belum dipilih → inline "Pilih dulu {namaGrup}."
    - success: ditambahkan → toast "Ditambahkan ke keranjang" + kembali ke PAGE-04.
    - disabled: tombol "Tambah" disabled bila opsi wajib belum lengkap; stepper "−" disabled di qty 1.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Opsi wajib | Setiap grup "Wajib" harus dipilih | "Pilih dulu {namaGrup}." |
    | Jumlah | Min 1; maks = stok tersisa | "Jumlah melebihi stok tersedia ({sisa})." |
    | Catatan | Maks 140 karakter | "Catatan maksimal 140 karakter." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | label_required | "Wajib" |
    | ph_note | "Contoh: tanpa sambal" |
    | btn_add_total | "Tambah • Rp{totalItem}" |
    | err_required_opt | "Pilih dulu {namaGrup}." |
    | err_qty_stock | "Jumlah melebihi stok tersedia ({sisa})." |
    | err_note_len | "Catatan maksimal 140 karakter." |
    | err_load_detail | "Gagal memuat detail menu. Coba lagi." |
    | toast_added | "Ditambahkan ke keranjang" |
    | toast_soldout | "Yah, menu ini baru saja habis." |

- **Edge Cases:**
    - Item menjadi habis saat sheet terbuka → tombol "Tambah" berubah disabled + toast "Yah, menu ini baru saja habis."; sheet dapat ditutup.
    - Stok tersisa < qty yang dipilih → batasi qty & tampilkan pesan err_qty_stock.
    - Perubahan harga opsi dari server → total pada tombol diperbarui sebelum ditambah.
- **Acceptance Criteria:**
    - **AC-05.1** — Given item punya grup opsi "Wajib", When tamu belum memilihnya, Then tombol "Tambah" disabled dan tampil "Pilih dulu {namaGrup}." saat mencoba menambah.
    - **AC-05.2** — Given tamu mengatur opsi & jumlah valid, When menekan "Tambah", Then item masuk keranjang dengan konfigurasi tepat dan tampil toast "Ditambahkan ke keranjang".
    - **AC-05.3** — Given jumlah melebihi stok tersisa, When tamu menaikkan qty, Then qty dibatasi dan tampil "Jumlah melebihi stok tersedia ({sisa})."
    - **AC-05.4** — Given item menjadi habis saat sheet terbuka, When status berubah, Then tombol "Tambah" disabled dan tampil toast "Yah, menu ini baru saja habis."
    - **AC-05.5** — Given catatan > 140 karakter, When mengetik, Then input dibatasi dan tampil "Catatan maksimal 140 karakter."

---

### PAGE-06 — Keranjang

> **Revisi 2026-07-14:** fitur **kode diskon manual** (field "Punya kode diskon?") **dihapus dari scope** — tidak dipakai di implementasi aktual. Yang berlaku hanya **promo otomatis** (FR-06). AC-06.2 & AC-06.3 (kode diskon) dihapus; FR-05 dinonaktifkan.

- **Route / entry point:** Floating cart bar / ikon keranjang dari PAGE-04 atau PAGE-05.
- **Tujuan:** Mengelola isi pesanan, melihat subtotal, dan memulai checkout ("Cek Stok & Promo").
- **Aktor:** Pelanggan.
- **Element Inventory:**
    1. Daftar item keranjang — tiap baris: nama + opsi terpilih, catatan, harga, stepper qty, tombol hapus.
    2. Daftar promo otomatis (bila ada) — copy: "Promo: {namaPromo}" + nilai; read-only.
    3. Ringkasan biaya — Subtotal, Diskon (−Rp), (estimasi) Total; catatan "Pajak & total final dihitung saat Cek Stok & Promo".
    4. Tombol utama — copy: "Cek Stok & Promo"; posisi: sticky bawah; perilaku: lihat alur metode.
    5. Tautan lanjut pesan — copy: "Tambah Menu Lain"; ke PAGE-04.
    6. **Baris item stok habis (real-time, saat validasi)** — `LineRow`/`FreeChildRow` variant `Stok=Habis`: foto redup 45% + badge "Habis" nempel foto, nama jadi muted, baris harga/opsi diganti pesan italic "Hapus item ini untuk melanjutkan pesanan.", kontrol qty diganti `Icon/trash` — lihat [[SO_Case_FreeChildRowStokHabis]].
- **States:**
    - default: item, promo otomatis (bila ada), subtotal tampil; tombol "Cek Stok & Promo" aktif.
    - empty: keranjang kosong → ilustrasi + "Keranjangmu masih kosong." + tombol "Lihat Menu".
    - loading: menghitung ulang subtotal/promo.
    - success: item ditambah/diubah → subtotal & promo otomatis ter-update.
    - **stok-habis (2026-08-10):** tamu menekan "Cek Stok & Promo" → server validasi → satu atau lebih item (berbayar via `LineRow` atau gratis-klaim-promo via `FreeChildRow`) ternyata abis stok → tamu **tetap di PAGE-06** (tidak lanjut ke PAGE-08): row item itu berubah ke variant `Stok=Habis`, dan `ValidationPopup`/`IssueRow Type=Stock` muncul menandai jumlah item bermasalah (lihat [[SO_Case_ValidasiKeranjangRedesign]]). Tombol "Cek Stok & Promo" hanya bisa lanjut lagi setelah SEMUA row `Stok=Habis` dihapus manual (tap trash).
    - disabled: tombol "Cek Stok & Promo" disabled saat keranjang kosong / sedang menghitung / masih ada row `Stok=Habis` yang belum dihapus.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Qty item | Min 1 (0 = hapus) | — |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | row_subtotal | "Subtotal" |
    | row_discount | "Diskon" |
    | row_total_est | "Perkiraan Total" |
    | note_tax | "Pajak & total final dihitung saat Cek Stok & Promo." |
    | btn_checkout | "Cek Stok & Promo" |
    | link_add_more | "Tambah Menu Lain" |
    | empty_cart | "Keranjangmu masih kosong." |
    | btn_see_menu | "Lihat Menu" |

- **Edge Cases:**
    - Menghapus item terakhir → keranjang kembali ke state empty.
    - Promo otomatis memberi **item hadiah pilihan** → memicu PAGE-07 sebelum lanjut (lihat PAGE-07).
    - Tamu Metode A menekan "Cek Stok & Promo" tapi belum login → memicu PAGE-02 (login) lalu lanjut ke PAGE-08.
    - **Item gratis (klaim promo) ikut kena validasi stok sama seperti item berbayar** — kalau item sumber promo itu abis, `FreeChildRow`-nya (bukan cuma `LineRow`) yang berubah ke `Stok=Habis`; tetap wajib dihapus sebelum lanjut, sama seperti item berbayar.
    - Tamu menghapus semua row `Stok=Habis` lalu menekan "Cek Stok & Promo" lagi → validasi ulang dari awal (bisa saja ketemu item lain yang baru abis di antara waktu itu).
- **Acceptance Criteria:**
    - **AC-06.1** — Given keranjang berisi item, When PAGE-06 tampil, Then daftar item, subtotal, dan tombol "Cek Stok & Promo" (aktif) tampil.
    - ~~AC-06.2, AC-06.3~~ — dihapus (kode diskon manual tidak dipakai, lihat catatan revisi di atas).
    - **AC-06.4** — Given keranjang kosong, When PAGE-06 tampil, Then tampil state empty dengan tombol "Lihat Menu" dan "Cek Stok & Promo" disabled.
    - **AC-06.5** — Given tamu Metode A belum login menekan "Cek Stok & Promo", When ditekan, Then PAGE-02 (login) dipicu sebelum PAGE-08.
    - **AC-06.6** — Given tamu Metode B/C menekan "Cek Stok & Promo", When ditekan, Then sistem langsung memvalidasi dan membuka PAGE-08 tanpa login.
    - **AC-06.7** *(baru, 2026-08-10)* — Given tamu menekan "Cek Stok & Promo", When validasi server menemukan satu atau lebih item (berbayar/gratis-klaim-promo) abis stok, Then tamu **tetap di PAGE-06**, row item itu berubah ke variant `Stok=Habis`, dan `ValidationPopup`/`IssueRow Type=Stock` muncul — TIDAK lanjut ke PAGE-08.
    - **AC-06.8** *(baru, 2026-08-10)* — Given ada row `Stok=Habis` di keranjang, When tamu belum menghapusnya, Then tombol "Cek Stok & Promo" tidak bisa membawa tamu lanjut (tetap divalidasi ulang dan diblokir) sampai row itu dihapus (tap trash).

---

### PAGE-07 — Pilih Item Hadiah Promo

- **Route / entry point:** Kondisional — disisipkan dari PAGE-06/PAGE-08 ketika promo aktif memberi **item hadiah yang harus dipilih** tamu (FR-06, OQ3).
- **Tujuan:** Membiarkan tamu memilih item/varian hadiah dari promo "dapat item".
- **Aktor:** Pelanggan.
- **Element Inventory:**
    1. Judul — copy: "Pilih hadiah promomu"; subjudul: "{namaPromo} — pilih {jumlahHadiah} item gratis".
    2. Daftar item hadiah yang memenuhi syarat — tiap item: foto, nama, varian (bila perlu), penanda "Gratis"; item habis → disabled.
    3. Penghitung pilihan — copy: "{terpilih}/{kuota} dipilih".
    4. Tombol konfirmasi — copy: "Pakai Hadiah"; disabled sampai kuota terpenuhi.
    5. Tautan lewati (bila promo opsional) — copy: "Lewati hadiah".
- **States:**
    - default: daftar hadiah tampil, 0 terpilih, tombol disabled.
    - empty: tidak ada item hadiah memenuhi syarat/semua habis → "Hadiah promo sedang tidak tersedia." + tombol "Lanjut Tanpa Hadiah".
    - loading: memuat daftar item hadiah.
    - error: gagal memuat → "Gagal memuat hadiah promo. Coba lagi."
    - success: hadiah dipilih → ditambahkan sebagai baris gratis di keranjang/review.
    - disabled: tombol "Pakai Hadiah" disabled sampai kuota terpenuhi; item habis disabled.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Pilihan hadiah | Tepat sebanyak kuota promo | "Pilih {kuota} item hadiah dulu, ya." |
    | Item hadiah | Tidak habis | "Item ini sedang habis." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | title | "Pilih hadiah promomu" |
    | subtitle | "{namaPromo} — pilih {jumlahHadiah} item gratis" |
    | badge_free | "Gratis" |
    | counter | "{terpilih}/{kuota} dipilih" |
    | btn_confirm | "Pakai Hadiah" |
    | link_skip | "Lewati hadiah" |
    | empty_gift | "Hadiah promo sedang tidak tersedia." |
    | btn_continue_nogift | "Lanjut Tanpa Hadiah" |
    | err_quota | "Pilih {kuota} item hadiah dulu, ya." |
    | err_gift_soldout | "Item ini sedang habis." |
    | err_load | "Gagal memuat hadiah promo. Coba lagi." |

- **Edge Cases:**
    - Promo "dapat item" tipe **otomatis** (bukan pilihan) → PAGE-07 dilewati; item hadiah langsung ditambahkan & ditampilkan di PAGE-08.
    - Pada **open bill**, promo dihitung per-order; hadiah hanya berlaku untuk order yang memenuhi syarat (tidak diakumulasi lintas-order) — lihat PAGE-10.
    - Tamu mengubah keranjang sehingga syarat promo gugur → pilihan hadiah dibatalkan otomatis dengan notifikasi di PAGE-08.
- **Acceptance Criteria:**
    - **AC-07.1** — Given promo aktif memberi item hadiah pilihan, When syarat promo terpenuhi, Then PAGE-07 tampil dengan daftar item hadiah yang memenuhi syarat.
    - **AC-07.2** — Given tamu memilih item sesuai kuota, When menekan "Pakai Hadiah", Then item hadiah ditambahkan sebagai baris "Gratis" dan tamu lanjut ke PAGE-08.
    - **AC-07.3** — Given promo bertipe otomatis, When syarat terpenuhi, Then PAGE-07 dilewati dan item hadiah otomatis muncul di PAGE-08.
    - **AC-07.4** — Given semua item hadiah habis, When PAGE-07 dimuat, Then tampil "Hadiah promo sedang tidak tersedia." dengan tombol "Lanjut Tanpa Hadiah".
    - **AC-07.5** — Given kuota belum terpenuhi, When tamu menekan "Pakai Hadiah", Then tombol tetap disabled / tampil "Pilih {kuota} item hadiah dulu, ya."

---

### PAGE-08 — Review Read-only (Cek Stok & Promo)

- **Route / entry point:** Dari PAGE-06 ("Cek Stok & Promo") — untuk Metode A setelah login (PAGE-03); untuk Metode B/C langsung. Juga dari PAGE-10 saat menambah order (mode "Tambah ke Bill").
- **Tujuan:** Menampilkan **ringkasan pesanan final yang terkunci** setelah server **memvalidasi stok & menghitung promo/diskon** (OQ2, Pola C). Tamu tidak bisa mengedit di sini; untuk ubah harus kembali ke keranjang.
- **Aktor:** Pelanggan.
- **Element Inventory:**
    1. Banner konteks — copy: "Ringkasan terkunci — sudah dicek stok & promo".
    2. Daftar item (read-only) — nama, opsi, qty, harga; baris hadiah promo ditandai "Gratis".
    3. Rincian biaya — Subtotal, Diskon, Promo, Pajak/Service (bila ada), **Total**.
    4. Panel peringatan validasi (bila ada) — mis. "1 item habis dan dihapus" / "Harga {item} berubah".
    5. Tombol "Ubah Pesanan" — copy: "Ubah Pesanan"; perilaku: kembali ke PAGE-06 (membuka kunci).
    6. **Tombol aksi metode:**
        - Metode A: "Bayar" → PAGE-09.
        - Metode C (dinamis): "Bayar Sekarang" → PAGE-09 **dan** "Buka Bill (Bayar Nanti)" → PAGE-10.
        - Mode tambah order (dari PAGE-10): "Tambahkan ke Bill" → kembali ke PAGE-10.
- **States:**
    - default: ringkasan tervalidasi & terkunci, total final tampil, tombol aksi aktif.
    - empty: semua item gugur saat validasi → "Pesananmu kosong setelah pengecekan. Yuk pesan lagi." + tombol "Kembali ke Menu".
    - loading: "Mengecek stok & promo…" saat validasi server.
    - error: validasi gagal/koneksi → "Gagal mengecek pesanan. Coba lagi." + "Coba Lagi".
    - success: validasi sukses tanpa perubahan → ringkasan bersih tanpa banner peringatan.
    - disabled: tombol aksi disabled selama loading atau bila ada item bermasalah yang belum diselesaikan.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Stok tiap item | Tersedia ≥ qty saat validasi | "{item} habis dan dihapus dari pesanan." |
    | Stok tiap item | Sisa < qty → qty disesuaikan | "Stok {item} tersisa {sisa}, jumlah disesuaikan." |
    | Promo/diskon | Masih berlaku saat validasi | "Promo {nama} sudah tidak berlaku dan dilepas." |
    | Harga | Sinkron dengan server | "Harga {item} diperbarui menjadi Rp{harga}." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | banner_locked | "Ringkasan terkunci — sudah dicek stok & promo" |
    | row_subtotal | "Subtotal" |
    | row_discount | "Diskon" |
    | row_promo | "Promo" |
    | row_tax | "Pajak & Layanan" |
    | row_total | "Total" |
    | badge_free | "Gratis" |
    | loading_msg | "Mengecek stok & promo…" |
    | btn_edit | "Ubah Pesanan" |
    | btn_pay_A | "Bayar" |
    | btn_pay_now | "Bayar Sekarang" |
    | btn_open_bill | "Buka Bill (Bayar Nanti)" |
    | btn_add_to_bill | "Tambahkan ke Bill" |
    | warn_item_removed | "{item} habis dan dihapus dari pesanan." |
    | warn_qty_adjusted | "Stok {item} tersisa {sisa}, jumlah disesuaikan." |
    | warn_promo_dropped | "Promo {nama} sudah tidak berlaku dan dilepas." |
    | warn_price_changed | "Harga {item} diperbarui menjadi Rp{harga}." |
    | empty_after_check | "Pesananmu kosong setelah pengecekan. Yuk pesan lagi." |
    | btn_back_menu | "Kembali ke Menu" |
    | err_validate | "Gagal mengecek pesanan. Coba lagi." |
    | btn_retry | "Coba Lagi" |

- **Edge Cases:**
    - Perubahan saat validasi (item habis/harga/promo) → tampilkan banner peringatan; tamu wajib menyadari sebelum lanjut (total diperbarui).
    - Metode A: bila sesi login kedaluwarsa sebelum bayar → minta verifikasi ulang (PAGE-02/03).
    - Open bill (PAGE-10) menambah order → promo dihitung **hanya untuk order ini** (per-order), bukan akumulasi bill (OQ4).
    - Tamu menekan "Ubah Pesanan" → ringkasan ter-unlock, kembali ke PAGE-06.
- **Acceptance Criteria:**
    - **AC-08.1** — Given tamu menekan "Cek Stok & Promo", When server selesai memvalidasi, Then PAGE-08 menampilkan ringkasan read-only dengan total final (subtotal, diskon, promo, pajak).
    - **AC-08.2** — ~~Given sebuah item habis saat validasi, When PAGE-08 tampil, Then item tersebut dihapus, banner "{item} habis dan dihapus dari pesanan." muncul, dan total diperbarui.~~ **Direvisi 2026-08-10:** gerbang utama item-habis sekarang di PAGE-06 (lihat AC-06.7/AC-06.8) — tamu gak akan sampai PAGE-08 kalau masih ada item abis di keranjang. AC ini cuma relevan buat race condition (stok berubah lagi di jeda singkat antara lolos validasi PAGE-06 dan render PAGE-08) — belum diputuskan apa perilakunya tetap auto-hapus+banner (fallback) atau dilempar balik ke PAGE-06.
    - **AC-08.3** — Given Metode A telah login, When PAGE-08 tampil, Then tombol aksi adalah "Bayar" menuju PAGE-09.
    - **AC-08.4** — Given Metode C (QR dinamis), When PAGE-08 tampil, Then tersedia "Bayar Sekarang" (→PAGE-09) dan "Buka Bill (Bayar Nanti)" (→PAGE-10).
    - **AC-08.5** — Given tamu menekan "Ubah Pesanan", When ditekan, Then tamu kembali ke PAGE-06 dan ringkasan tidak lagi terkunci.
    - **AC-08.6** — Given semua item gugur saat validasi, When PAGE-08 tampil, Then tampil "Pesananmu kosong setelah pengecekan. Yuk pesan lagi." dengan tombol "Kembali ke Menu".

---

### PAGE-09 — Pembayaran

- **Route / entry point:** Dari PAGE-08 (bayar di muka, Metode A & C) atau PAGE-10 ("Tutup & Bayar" open bill).
- **Tujuan:** Memproses pembayaran via **Bayar Langsung** atau **Bayar Online (QRIS)** dengan **auto-detect status sukses** (polling).
- **Aktor:** Pelanggan.
- **Element Inventory:**
    1. Ringkasan total — copy: "Total yang dibayar: Rp{total}".
    2. Pilihan metode bayar — tipe: kartu pilihan:
        - "Bayar Langsung (di kasir/staf)"
        - "Bayar Online — QRIS"
        - "Bayar Online — Transfer Bank (segera hadir)" → disabled (future).
    3. Panel QRIS (bila dipilih) — QR image, nominal, hitung mundur kedaluwarsa, status "Menunggu pembayaran…", tombol "Cek Status" (manual fallback).
    4. Instruksi Bayar Langsung (bila dipilih) — copy: "Tunjukkan layar ini ke staf/kasir untuk menyelesaikan pembayaran."
    5. Tombol konfirmasi — Bayar Langsung: "Konfirmasi & Kirim Pesanan"; QRIS: tidak perlu tombol (auto-detect).
- **States:**
    - default: pilihan metode tampil, total jelas.
    - empty: tidak relevan.
    - loading: membuat transaksi/QRIS → "Menyiapkan pembayaran…"; QRIS aktif → "Menunggu pembayaran…".
    - error: gagal buat QRIS → "Gagal membuat kode QRIS. Coba lagi." ; QRIS kedaluwarsa → "Kode QRIS kedaluwarsa. Buat kode baru." ; pembayaran gagal/ditolak → "Pembayaran gagal. Coba metode lain atau ulangi."
    - success: terdeteksi lunas (QRIS auto-detect) / dikonfirmasi staf (Bayar Langsung) → ke PAGE-11.
    - disabled: tombol konfirmasi disabled sebelum metode dipilih / selama proses; metode Transfer Bank disabled (future).
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Metode bayar | Wajib dipilih | "Pilih metode pembayaran dulu." |
    | QRIS | Belum kedaluwarsa (mis. 5 menit) | "Kode QRIS kedaluwarsa. Buat kode baru." |
    | Status transaksi | Lunas terverifikasi server sebelum lanjut | "Pembayaran belum diterima." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | total_label | "Total yang dibayar: Rp{total}" |
    | opt_direct | "Bayar Langsung (di kasir/staf)" |
    | opt_qris | "Bayar Online — QRIS" |
    | opt_bank_soon | "Bayar Online — Transfer Bank (segera hadir)" |
    | qris_waiting | "Menunggu pembayaran…" |
    | qris_countdown | "Kode berlaku {mm:ss}" |
    | btn_check_status | "Cek Status" |
    | direct_instruction | "Tunjukkan layar ini ke staf/kasir untuk menyelesaikan pembayaran." |
    | btn_confirm_direct | "Konfirmasi & Kirim Pesanan" |
    | loading_prep | "Menyiapkan pembayaran…" |
    | err_qris_create | "Gagal membuat kode QRIS. Coba lagi." |
    | err_qris_expired | "Kode QRIS kedaluwarsa. Buat kode baru." |
    | err_pay_failed | "Pembayaran gagal. Coba metode lain atau ulangi." |
    | err_method_required | "Pilih metode pembayaran dulu." |
    | err_not_paid | "Pembayaran belum diterima." |

- **Edge Cases:**
    - **QRIS auto-detect:** sistem polling status; saat lunas → otomatis ke PAGE-11 tanpa tamu menekan apa pun; "Cek Status" tersedia sebagai fallback manual.
    - Tamu menutup/refresh halaman saat QRIS menunggu → status dipulihkan dari server saat kembali (idempoten).
    - Bayar Langsung: pesanan dikirim ke POS sebagai "menunggu pembayaran di kasir"; konfirmasi lunas dilakukan staf — status sukses bergantung konfirmasi POS (lihat Open Questions OQ-SO-03).
    - Double-payment guard: bila transaksi sudah lunas, percobaan bayar ulang ditolak & langsung diarahkan ke PAGE-11.
- **Acceptance Criteria:**
    - **AC-09.1** — Given tamu di PAGE-09, When halaman tampil, Then total final dan pilihan metode (Bayar Langsung, QRIS; Transfer Bank disabled) ditampilkan.
    - **AC-09.2** — Given tamu memilih QRIS, When kode dibuat, Then QR + nominal + hitung mundur tampil dengan status "Menunggu pembayaran…".
    - **AC-09.3** — Given QRIS dibayar, When server mendeteksi status lunas (polling), Then tamu otomatis diarahkan ke PAGE-11 tanpa aksi tambahan.
    - **AC-09.4** — Given kode QRIS kedaluwarsa, When waktu habis, Then tampil "Kode QRIS kedaluwarsa. Buat kode baru." dan tamu dapat membuat kode baru.
    - **AC-09.5** — Given tamu memilih Bayar Langsung, When menekan "Konfirmasi & Kirim Pesanan", Then pesanan dikirim ke POS sebagai menunggu pembayaran di kasir dan status mengikuti konfirmasi staf.
    - **AC-09.6** — Given transaksi sudah lunas, When tamu mencoba membayar lagi, Then sistem menolak pembayaran ganda dan mengarahkan ke PAGE-11. *(⚠️ perlu konfirmasi PM 2026-07-14 — kemungkinan double-payment guard belum di-handle di implementasi aktual, lihat OQ-SO-11.)*

---

### PAGE-10 — Open Bill (Ringkasan Sesi & Tambah Order)

- **Route / entry point:** Dari PAGE-08 (Metode B, "Buka Bill"). Hanya QR **dinamis**.
- **Tujuan:** Menampilkan **bill terbuka** untuk satu sesi meja, menampung **penambahan order bertahap**, dengan promo dihitung **per-order (tidak lintas-order)** (OQ4), dan opsi menutup & membayar.
- **Aktor:** Pelanggan.
- **Element Inventory:**
    1. Header bill — copy: "Bill Meja {nomorMeja}" + status "Terbuka".
    2. Daftar order (per batch) — tiap batch: waktu, item, diskon/promo batch, subtotal batch.
    3. Running total — copy: "Total berjalan: Rp{total}" (sticky).
    4. Tombol "Tambah Order" — perilaku: ke PAGE-04 → … → PAGE-08 (mode "Tambahkan ke Bill") → kembali ke PAGE-10.
    5. Tombol "Tutup & Bayar" — perilaku: ke PAGE-09 untuk membayar seluruh bill.
    6. Catatan promo per-order — copy: "Promo dihitung per order. Promo tidak bisa digabung antar order."
- **States:**
    - default: daftar batch order + running total tampil; tombol "Tambah Order" & "Tutup & Bayar" aktif.
    - empty: bill baru tanpa batch (sesaat setelah buka) → menampilkan order pertama; tidak ada state benar-benar kosong karena buka bill butuh ≥1 order.
    - loading: memuat/menyegarkan bill; menutup bill.
    - error: gagal memuat bill → "Gagal memuat bill. Coba lagi." ; bill ditutup kasir → "Bill ini sudah ditutup oleh staf."
    - success: order tambahan masuk → toast "Order ditambahkan ke bill."
    - disabled: "Tutup & Bayar" disabled selama ada order yang belum tersinkron / saat loading.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Promo per-order | Promo hanya berlaku dalam satu order; tidak lintas-order | "Promo tidak bisa digabung antar order." |
    | Status bill | Masih "Terbuka" untuk menambah/menutup | "Bill ini sudah ditutup oleh staf." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | header_bill | "Bill Meja {nomorMeja}" |
    | status_open | "Terbuka" |
    | running_total | "Total berjalan: Rp{total}" |
    | btn_add_order | "Tambah Order" |
    | btn_close_pay | "Tutup & Bayar" |
    | note_promo_per_order | "Promo dihitung per order. Promo tidak bisa digabung antar order." |
    | toast_order_added | "Order ditambahkan ke bill." |
    | err_load_bill | "Gagal memuat bill. Coba lagi." |
    | err_bill_closed | "Bill ini sudah ditutup oleh staf." |

- **Edge Cases:**
    - Promo yang butuh akumulasi lintas-order → ditolak; hanya promo yang terpenuhi dalam satu order yang berlaku (OQ4).
    - Kasir menutup bill dari sisi POS saat tamu menambah order → tampilkan err_bill_closed dan hentikan penambahan.
    - **Handoff WL untuk open bill di-hold** — PAGE-10 **tidak** men-enqueue ke WL (lihat Open Questions OQ-SO-01).
    - Multi-perangkat pada satu meja (beberapa tamu menambah ke bill yang sama) → bill tersinkron dari server (TBD aturan kepemilikan, OQ-SO-04).
- **Acceptance Criteria:**
    - **AC-10.1** — Given tamu memilih "Buka Bill" di PAGE-08, When bill dibuka, Then PAGE-10 menampilkan order pertama, status "Terbuka", dan running total.
    - **AC-10.2** — Given tamu menekan "Tambah Order", When menyelesaikan PAGE-04→PAGE-08 (mode tambah), Then order baru muncul sebagai batch terpisah dan running total bertambah.
    - **AC-10.3** — Given sebuah order memenuhi syarat promo, When promo dihitung, Then promo hanya diterapkan pada order tersebut dan tidak diakumulasi dengan order lain.
    - **AC-10.4** — Given tamu menekan "Tutup & Bayar", When ditekan, Then tamu diarahkan ke PAGE-09 untuk membayar seluruh bill.
    - **AC-10.5** — Given kasir menutup bill dari POS, When tamu mencoba menambah order, Then tampil "Bill ini sudah ditutup oleh staf." dan penambahan dihentikan.
    - **AC-10.6** — Given sesi open bill, When bill dibuka/ditambah, Then tamu **tidak** di-enqueue ke Waiting List (handoff open bill di-hold).

---

### PAGE-11 — Konfirmasi Sukses & Handoff WL

- **Route / entry point:** Dari PAGE-09 setelah pembayaran sukses (Metode A & C; juga penutupan bill Metode B).
- **Tujuan:** Mengonfirmasi pesanan berhasil dan — untuk metode **bayar di muka (A & C)** — menampilkan **handoff ke Waiting List** ([[WL_Overview]]).
- **Aktor:** Pelanggan.
- **Element Inventory:**
    1. Ikon & judul sukses — copy: "Pesanan berhasil!"; subjudul: "Terima kasih, pesananmu sedang diproses."
    2. Ringkasan singkat — nomor pesanan, total dibayar, metode bayar.
    3. **Blok Handoff WL (Metode A & C):** copy: "Kamu masuk antrean. Pantau posisi antreanmu di sini." + tombol "Lihat Antrean" → halaman live tracking WL.
    4. Tombol sekunder — "Pesan Lagi" (ke PAGE-04, bila relevan) / "Selesai".
    5. Catatan struk — copy: "Bukti pesanan dikirim sesuai pengaturan restoran." (TBD kanal struk).
- **States:**
    - default: konfirmasi sukses + ringkasan; blok WL tampil untuk A & C.
    - empty: tidak relevan.
    - loading: men-enqueue WL → "Mendaftarkan antrean…".
    - error: enqueue WL gagal → "Pesanan berhasil, tapi pendaftaran antrean gagal. Tunjukkan layar ini ke staf." (pembayaran tetap sah).
    - success: enqueue sukses → tampil nomor antrean + tombol "Lihat Antrean".
    - disabled: tombol "Lihat Antrean" disabled selama enqueue berlangsung.
- **Validation Rules:**

    | Field | Aturan | Pesan error (persis) |
    |-------|--------|----------------------|
    | Status pembayaran | Harus lunas/terkonfirmasi sebelum halaman ini | "Pembayaran belum selesai." |
    | Enqueue WL (A & C) | Order terkirim ke modul WL | "Pendaftaran antrean gagal." |

- **Copy Bank:**

    | Key | Teks final |
    |-----|-----------|
    | title_success | "Pesanan berhasil!" |
    | subtitle_success | "Terima kasih, pesananmu sedang diproses." |
    | row_order_no | "No. Pesanan" |
    | row_total_paid | "Total Dibayar" |
    | row_pay_method | "Metode" |
    | wl_block | "Kamu masuk antrean. Pantau posisi antreanmu di sini." |
    | btn_view_queue | "Lihat Antrean" |
    | btn_order_again | "Pesan Lagi" |
    | btn_done | "Selesai" |
    | note_receipt | "Bukti pesanan dikirim sesuai pengaturan restoran." |
    | loading_enqueue | "Mendaftarkan antrean…" |
    | err_enqueue | "Pesanan berhasil, tapi pendaftaran antrean gagal. Tunjukkan layar ini ke staf." |

- **Edge Cases:**
    - **Metode B (open bill):** PAGE-11 menampilkan konfirmasi pembayaran bill **tanpa** blok WL (handoff open bill di-hold, OQ-SO-01).
    - Enqueue WL gagal sementara pembayaran sukses → tampilkan pesan err_enqueue; pembayaran tidak dibatalkan; sediakan jalur retry/escalasi ke staf.
    - Tamu menutup halaman lalu kembali via link → status sukses dipulihkan dari server.
- **Acceptance Criteria:**
    - **AC-11.1** — Given pembayaran Metode A/C sukses, When PAGE-11 tampil, Then konfirmasi sukses + ringkasan pesanan tampil dan sistem men-enqueue tamu ke Waiting List.
    - **AC-11.2** — Given enqueue WL sukses, When selesai, Then blok "Kamu masuk antrean…" + tombol "Lihat Antrean" (menuju live tracking WL) tampil.
    - **AC-11.3** — Given enqueue WL gagal, When error terjadi, Then tampil "Pesanan berhasil, tapi pendaftaran antrean gagal. Tunjukkan layar ini ke staf." dan pembayaran tetap sah.
    - **AC-11.4** — Given pembayaran penutupan bill Metode B sukses, When PAGE-11 tampil, Then konfirmasi tampil **tanpa** blok WL.
    - **AC-11.5** — Given tamu membuka ulang link konfirmasi, When halaman dimuat, Then status sukses dipulihkan dari server (tidak menggandakan pesanan).

---

## 8. Cross-Cutting

### Navigasi Global
- **Persistensi konteks:** venueId + tipe QR + (sessionToken untuk dinamis) dipertahankan di seluruh halaman; keranjang & diskon bertahan selama sesi.
- **Tombol kembali:** mengikuti alur Page Map; "Ubah Pesanan" di PAGE-08 adalah satu-satunya jalan membuka kunci ringkasan.
- **Floating cart bar:** muncul di PAGE-04/05 saat keranjang berisi.
- **Indikator metode:** header menampilkan konteks "Pesan Mandiri" (statis) atau "Meja {nomorMeja}" (dinamis).

### Role / Permission
- **Pelanggan (guest):** boleh browse menu, kelola keranjang, apply diskon. Untuk Metode A, tindakan checkout memerlukan **identifikasi via OTP**.
- **Pelanggan (teridentifikasi, Metode A):** sama seperti guest + dapat menyelesaikan pembayaran & enqueue WL.
- **Metode B/C (QR dinamis):** identitas terikat ke **sesi meja**, tanpa login.
- Tidak ada peran operator/admin dalam dokumen ini (out of scope).

### Theming & Mode
- **Mode tampilan:** **Light mode only** (untuk saat ini). Dark mode di luar scope.
- **Primary color:** token brand merchant, **default `#1799A5`**. **Hanya primary color yang dapat diubah**; warna lain, tipografi, ukuran, dan elemen lain tetap.
- **Sumber konfigurasi:** primary color diatur merchant di **Accurate Online**; Self Order **membaca** nilai warna saat halaman dimuat. Tamu (end-user) tidak mengubah warna.
- **Penggunaan token:** seluruh elemen ber-aksen primary (tombol utama, tautan/teks aktif, highlight, ikon aktif, indikator progress, badge terpilih) memakai **satu token primary** yang sama agar otomatis ikut berubah saat merchant mengganti warna.
- **Aksesibilitas:** karena primary dapat diganti merchant, warna teks/ikon di atas primary harus menjaga kontras memadai — rekomendasi: pilih foreground (putih/gelap) otomatis sesuai luminance primary, target WCAG AA. Warna semantik (sukses/error/peringatan) **tidak** mengikuti primary.

**Design Tokens (default — set `/prd-agent`, dapat disesuaikan; sumber: [[context-map#Design System / Pola UI|Design System di context-map]]):**
- **Netral (light):** bg `#FFFFFF` · surface `#F9FAFB` · border `#E5E7EB` · teks `#111827` · teks sekunder `#6B7280` · disabled `#9CA3AF`.
- **Semantik (tetap, tidak ikut primary):** sukses `#16A34A` · error `#DC2626` · warning `#F59E0B` · info = primary.
- **Tipografi:** `Inter, system-ui, sans-serif` — H1 24/bold · H2 20/semibold · H3 16/semibold · body 14 · caption 12 · label tombol 14–16/semibold.
- **Spacing & radius:** grid 8pt; padding halaman 16, jarak kartu 12; radius kartu/sheet 12–16, input/tombol 8–12.
- **Tombol:** primer = solid primary (foreground auto-kontras, tinggi 48, full-width CTA); sekunder = outline/ghost primary; destruktif = error; disabled = bg `#E5E7EB` / teks `#9CA3AF`.
- **Sheet/dialog:** bottom sheet sudut atas 16 + drag handle + scrim hitam 40%.
- **Input:** tinggi 44–48, border `#D1D5DB`, radius 8; focus = border primary + ring tipis; error = border `#DC2626` + helper merah 12.

### Non-Functional Requirements
- **Tanpa instalasi aplikasi:** seluruh alur berjalan di browser HP standar.
- **Performa:** menu (PAGE-04) tampil < 3 detik pada koneksi normal; skeleton saat loading; toleransi koneksi lambat (timeout & retry seperti dispesifikasikan per halaman).
- **Resolusi & sentuh:** mobile-first, tap target memadai, responsif (selaras Constraints WL).
- **Reliabilitas pembayaran:** idempoten terhadap refresh/putus koneksi; double-payment guard (AC-09.6).
- **Keamanan OTP:** kode 6 digit, kedaluwarsa 5 menit, cooldown resend 60 detik, maks 5 percobaan, rate-limit pengiriman.
- **Ketersediaan data live:** harga & stok bersumber dari POS secara real-time (Pola B & C).
- **Privasi:** nomor HP hanya untuk keperluan pesanan & enqueue WL.

## 9. Data & Integrasi

**Entitas utama (konseptual):**
- **SO Session** — venueId, tipe QR (statis/dinamis), sessionToken (dinamis), nomorMeja, status, identitas tamu (nomor HP bila Metode A).
- **Cart / CartItem** — itemId, opsi terpilih, qty, catatan, harga snapshot.
- **Discount** — kode, tipe, nilai, syarat.
- **Promo** — id, tipe (otomatis/dapat-item: auto/pilih), kuota hadiah, aturan per-order (open bill).
- **Order / OrderBatch** — daftar item tervalidasi, total, relasi ke bill (open bill).
- **OpenBill** — billId, nomorMeja, daftar OrderBatch, running total, status (Terbuka/Ditutup).
- **OTPVerification** — nomor HP, kode (hash), expiry, attempts.
- **Payment** — metode (Bayar Langsung/QRIS), nominal, status, referensi gateway.

**Integrasi sistem:**
- **Katalog & Stok POS** — sumber menu, harga, ketersediaan live; validasi stok saat PAGE-08 (Pola C); penanda 86 real-time (Pola B/C).
- **Engine Diskon & Promo POS** — validasi kode diskon (PAGE-06), hitung promo & promo-dapat-item (PAGE-07/08), aturan per-order untuk open bill (PAGE-10).
- **Gateway Pembayaran (QRIS)** — pembuatan kode QRIS, polling status (auto-detect sukses), pencatatan transaksi ke POS.
- **Pengirim OTP (WhatsApp)** — kirim & verifikasi kode (PAGE-02/03).
- **Modul Waiting List** — enqueue tamu untuk Metode A & C setelah pembayaran sukses (PAGE-11); detail antrean ada di [[WL_Overview]]. Handoff open bill **di-hold**.
- **QR Resolver** — memetakan token QR (statis/dinamis) → konteks venue/sesi + menu live (Pola B).
- **Accurate Online (Konfigurasi Tema)** — sumber pengaturan **primary color** merchant; Self Order membaca token warna saat memuat. Hanya primary color yang dinamis; mode = light only. Lihat [[SO_PRD#Theming & Mode|Theming & Mode]].

## 10. Open Questions / TBD

- **OQ-SO-01** — Handoff WL untuk **Open Bill (Metode B)** masih **di-hold**: kapan & dengan syarat apa tamu open bill masuk antrean WL (saat bill dibuka, saat ditutup/lunas, atau tidak sama sekali)?
- **OQ-SO-02** — **Aturan stacking** diskon (kode) dengan promo otomatis: boleh digabung atau saling eksklusif? (Memengaruhi pesan di PAGE-06.)
- **OQ-SO-03** — **Konfirmasi "Bayar Langsung"**: status sukses bergantung konfirmasi staf di POS — bagaimana alur & SLA-nya, dan apa tampilan tamu selama menunggu konfirmasi?
- **OQ-SO-04** — **Multi-perangkat pada satu open bill** (beberapa tamu di satu meja): siapa pemilik bill & bagaimana sinkronisasi/penambahan dari banyak HP?
- **OQ-SO-05** — **Kanal & format bukti/struk** pesanan ke tamu (PAGE-11): email, WhatsApp, atau tampil di layar saja?
- **OQ-SO-06** — **Batas maksimum qty per item / per order** dan kebijakan kuota (sejalan TBD OQ-04 di [[WL_Case1_SelfScan]]).
- **OQ-SO-07** — **Channel Bayar Online non-QRIS** (bank VA BCA/Mandiri dll) sebagai *future*: kapan diaktifkan & cakupannya.
- **OQ-SO-08** — **Login multi-device**: apakah 1 nomor HP/tamu bisa login Self Order di 2 device berbeda secara bersamaan? Memengaruhi desain sesi & handoff WL.
- **OQ-SO-09** — *(ditambahkan 2026-07-14, deferred — bukan prioritas)* No-connection/network-error state: ilustrasi sudah tersedia di Arsip, sudah dipasang jadi 1 case referensi di Menu & Katalog — detail copy & pemicu pastinya masih perlu difinalkan PM.
- **OQ-SO-10** — **Mekanisme login WhatsApp yang sebenarnya**: PAGE-02/03 saat ini mendeskripsikan input nomor HP manual + OTP 6 digit, tapi menurut klarifikasi PM (2026-07-14) login sepenuhnya lewat WhatsApp tanpa input manual. Perlu didefinisikan ulang: apa trigger-nya, apa yang tamu lihat, bagaimana verifikasi terjadi.
- **OQ-SO-11** — **Double-payment guard** (AC-09.6): perlu konfirmasi apakah benar belum di-handle di implementasi aktual — kalau iya, apa mitigasinya (mis. idempotency key di gateway)?
- ~~**OQ-SO-12** — Pesanan campuran Dine In + Take Away dalam satu keranjang~~ — **Dijawab PM 2026-07-14**: fitur ini DIDUKUNG. Mekanisme: OrderTypePills men-tag tipe pesanan pada item BARU yang ditambahkan setelah tipe diganti — item lama TIDAK ikut berubah/reset. Di Keranjang, item otomatis dikelompokkan per section "Dine In · N item" / "Take Away · N item" (subtotal/PPN/total tetap gabungan, tidak dipecah per grup), mengikuti pola desain lama (Arsip). Sudah dibangun flow lengkapnya: `↳ Menu & Katalog` → `Case: Ganti Tipe Pesanan` (sisi Menu — ganti tipe via OrderTypeSheet, cart tidak reset) dan `↳ Keranjang` → `Case: Pesanan Campuran Dine In + Take Away` (sisi Keranjang — tampilan grouped). **Belum digarap**: dampak ke Konfirmasi/Checkout (PAGE-08/09), tiket dapur, dan handoff kasir/WL (PAGE-11) — kemungkinan besar butuh tampilan terpisah per grup tipe pesanan di sana juga, menyusul.

## 11. Appendix — Referensi (Web Research)

- **Nielsen Norman Group — "Don't Force Users to Register Before They Can Buy"** — https://www.nngroup.com/articles/optional-registration/ → dasar pola **deferred/contextual login** & microcopy berbasis manfaat (diadopsi di PAGE-02/03/04).
- **Baymard Institute — "Make Guest Checkout Prominent"** — https://baymard.com/blog/make-guest-checkout-prominent → prominence & penandaan opsional (mendukung Pola A).
- **Deliverect — "How QR Code Menus and Self-Serve Systems are Transforming Restaurants"** — https://www.deliverect.com/en/blog/omni-channel-restaurant/how-qr-code-menus-and-self-serve-systems-are-transforming-restaurants → pola QR statis vs dinamis, scan-order-pay, menu live (mendukung Pola B & C).
- **Supercode — "QR Codes for Restaurants: Menus & Ordering (2026)"** — https://www.supercode.com/blog/qr-codes-for-restaurants → static vs dynamic QR & best practice penempatan/mobile (Pola B).
- **klikit — "QRIS Payment untuk Restoran Indonesia"** — https://klikit.io/en/learn/qris-payment-restaurant-indonesia → integrasi QRIS + pencatatan POS (PAGE-09).
- **Bank Indonesia — QRIS** — https://www.bi.go.id/en/fungsi-utama/sistem-pembayaran/ritel/kanal-layanan/qris/default.aspx → standar QRIS satu kode untuk semua e-wallet/bank (PAGE-09).

## 12. Traceability

| FR ID | Page ID | AC ID |
|-------|---------|-------|
| FR-01 | PAGE-01 | AC-01.1, AC-01.2, AC-01.3, AC-01.4, AC-01.5 |
| FR-02 | PAGE-04 | AC-04.1, AC-04.2, AC-04.3, AC-04.4, AC-04.5 |
| FR-03 | PAGE-05 | AC-05.1, AC-05.2, AC-05.3, AC-05.4, AC-05.5 |
| FR-04 | PAGE-06 | AC-06.1, AC-06.4 |
| FR-05 | ~~PAGE-06~~ | **dihapus** (revisi 2026-07-14) |
| FR-06 | PAGE-07, PAGE-08 | AC-07.1, AC-07.2, AC-07.3, AC-07.4, AC-07.5, AC-08.2 |
| FR-07 | PAGE-02, PAGE-03 | AC-02.1, AC-02.2, AC-02.3, AC-02.4, AC-02.5, AC-03.1, AC-03.2, AC-03.3, AC-03.4, AC-03.5, AC-06.5 |
| FR-08 | PAGE-08 | AC-08.1, AC-08.2, AC-08.3, AC-08.4, AC-08.5, AC-08.6, AC-06.6 |
| FR-09 | PAGE-09 | AC-09.1, AC-09.2, AC-09.3, AC-09.4, AC-09.5, AC-09.6 |
| FR-10 | PAGE-10 | AC-10.1, AC-10.2, AC-10.3, AC-10.4, AC-10.5, AC-10.6 |
| FR-11 | PAGE-11 | AC-11.1, AC-11.2, AC-11.3, AC-11.4, AC-11.5 |
| FR-12 | PAGE-01, PAGE-08, PAGE-09, PAGE-10 | AC-01.3, AC-01.4, AC-01.5, AC-08.6, AC-09.4, AC-10.5 |

## 13. Case Tambahan (di luar siklus PRD utama)

> Spec desain yang dihasilkan lewat `superpowers:brainstorming` di luar update PRD ini — perubahan/penambahan alur spesifik, bukan revisi seluruh PRD. Sinkron ke sini biar ke-track dari index.

| Case | Ringkas | Status |
|---|---|---|
| [[SO_Case_LoginOpsionalKonfirmasiMember]] | Login dipindah jadi opsional di Konfirmasi (No. HP tanpa OTP), member POS + poin pasca-transaksi | Approved |
| [[SO_Case_ValidasiKeranjangRedesign]] | Redesign popup validasi keranjang (`IssueRow` adaptif per Type: Stock/Harga/Promo/SPA) | Approved |
| [[SO_Case_BagikanStrukNegative]] | Negative case sheet Bagikan Struk — validasi format input + gagal kirim | Approved |
| [[SO_Case_ToastSuksesBagikanStruk]] | Toast konfirmasi sukses kirim struk (gap ditemuin pas review negative case) | Review |
| [[SO_Case_PromoTidakBerlaku]] | Diskon Transaksi gugur saat konfirmasi — `PromoCard Status=Bermasalah` di halaman Promo, CTA Keranjang balik netral | Draft |
| [[SO_Case_FreeChildRowStokHabis]] | `FreeChildRow` diubah jadi component set, nambah variant `Stok=Habis` (item gratis klaim promo yang kehabisan stok di cart) | Approved |

---

*Dokumen ini dibuat oleh `/prd-agent` pada 2026-06-09. Status: Review v0.2 (v0.2: tambah spesifikasi Theming & Mode — primary color dinamis dari Accurate Online, light mode only). Terkait: [[WL_Overview]] (titik handoff Waiting List).*
