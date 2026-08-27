# Self Order — Test Scenario

<!-- Turunan dari [[SO_PRD]] (AC per halaman). ID skenario = ID AC terkait; skenario tambahan (belum bernomor AC) ditandai (tambahan). -->

**Status:** Draft
**Sumber:** [[SO_PRD]] — Element Inventory, States, Validation Rules, Edge Cases, Acceptance Criteria per halaman.
**Bahasa:** Indonesia

- **Objective** (per halaman) — apa yang dipastikan berfungsi benar oleh kumpulan skenario di bawahnya.
- **Prasyarat/Precondition** (per skenario) — kondisi yang harus terpenuhi sebelum skenario dijalankan.
- **Expected Result** — hasil yang terlihat tamu (UI/copy).
- **Post Condition** — state sistem/data setelah skenario selesai.
- **System Validation** — pengecekan server/business-rule yang terjadi di balik layar.
- **Catatan** — dependensi, referensi desain, atau Open Question terkait.

---

## PAGE-01 — Landing / QR Entry

**Objective:** Memastikan sistem bisa memvalidasi QR (statis & dinamis), me-resolve konteks venue/meja dengan benar, dan menangani semua kondisi gagal (invalid, kedaluwarsa, venue nonaktif, timeout) tanpa salah arah.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-01.1 | Scan QR **statis** valid | Venue aktif, QR statis terdaftar | Loading singkat → auto-redirect PAGE-04, konteks "Pesan Mandiri" | Sesi guest terbentuk (venueId + tipe=statis); keranjang kosong | Server resolve `qrToken` → venue aktif → load menu live | QR statis tetap lewat resolver tiap dibuka (Pola B) — menu selalu terbaru walau URL lama disimpan tamu |
| AC-01.2 | Scan QR **dinamis** valid | Sesi meja aktif, belum kedaluwarsa | Auto-redirect PAGE-04, konteks "Meja {nomorMeja}" | `sessionToken` tersimpan, persist ke seluruh halaman (dipakai Open Bill) | Server cek `sessionToken` valid + belum expired | — |
| AC-01.3 | **[Negatif]** Token QR tidak dikenali | qrToken/sessionToken salah/tidak ada di server | "QR tidak dikenali. Minta bantuan staf, ya." + tombol "Coba Lagi" | Tetap di PAGE-01 error state, tidak ada sesi terbentuk | Lookup token → not found | Negative case utama; tidak ada file desain khusus di repo saat ini |
| AC-01.4 | **[Negatif]** QR dinamis kedaluwarsa | Sesi meja sudah ditutup/timeout | "Sesi meja ini sudah berakhir. Pindai ulang QR di meja atau hubungi staf." | Tetap di PAGE-01, tidak lanjut ke menu | Server cek `sessionToken.expiredAt` terlampaui | Sudah ada desain: `Self Order - QR Kedaluwarsa.html` |
| AC-01.5 | **[Negatif]** Timeout resolve >10 detik | Koneksi lambat/server tidak respons | Error koneksi + tombol "Coba Lagi", parameter URL tidak hilang | Tetap di PAGE-01, retry memakai token yang sama | Client-side timeout guard (no response dari server) | Edge case jaringan |
| (tambahan) | **[Negatif]** Venue nonaktif / Self Order dimatikan merchant | Venue di-nonaktifkan dari admin POS | "Pemesanan mandiri sedang tidak tersedia di restoran ini." | Tidak ada sesi terbentuk | Server cek flag `venue.selfOrderEnabled` | Tidak ada tombol retry yang berguna — perlu keputusan UX (tampilkan kontak staf?) |

---

## PAGE-02 — Login Nomor HP

> **⚠️ Revisi 2026-07-14:** login aktual lewat WhatsApp langsung (bukan input nomor HP manual). Skenario AC-02.2 (format salah), AC-02.4 (gagal kirim), dan tambahan rate-limit di bawah **kemungkinan besar tidak berlaku** — dipertahankan sbg draft sampai mekanisme WhatsApp final dikonfirmasi (lihat `SO_PRD.md` OQ-SO-10).

**Objective:** Memastikan tamu Metode A bisa login pakai nomor HP dengan validasi format benar, OTP terkirim, dan semua kegagalan (format salah, gagal kirim, rate-limit) tertangani tanpa tamu kehilangan isi keranjang.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-02.1 | Sheet login terbuka pertama kali | Metode A, guest, tekan "Cek Stok & Promo" | Field nomor kosong, tombol "Kirim Kode OTP" disabled | Belum ada sesi teridentifikasi | — (client-side only) | Hanya muncul Metode A |
| AC-02.2 | **[Negatif]** Format nomor HP invalid | Input tidak diawali 08/+62 atau bukan 9–13 digit | Inline "Format nomor HP belum benar. Contoh: 0812xxxxxxx." tombol tetap disabled | Tidak ada OTP terkirim | Validasi format client-side (regex) | — |
| AC-02.3 | Nomor valid → kirim OTP | Format benar, belum melewati rate-limit | Tombol jadi "Mengirim…" → transisi ke PAGE-03 | OTP tersimpan server (hash) dgn expiry 5 menit | Server generate & kirim OTP via WhatsApp gateway | — |
| AC-02.4 | **[Negatif]** Gagal kirim OTP | Gateway WhatsApp error/down | "Gagal mengirim kode. Coba lagi sebentar lagi." | Tetap di PAGE-02, tidak ada OTP aktif | Server terima error dari gateway WA | — |
| AC-02.5 | Tutup sheet (X) | Sheet terbuka | Kembali ke PAGE-06 | Keranjang & diskon tetap utuh, belum login | — | — |
| (tambahan) | **[Negatif]** Rate-limit — terlalu banyak percobaan kirim OTP | Nomor sama request OTP berkali-kali dlm waktu singkat | "Terlalu banyak percobaan. Coba lagi dalam beberapa menit." | Tidak ada OTP baru terkirim sampai cooldown lewat | Server cek counter rate-limit per nomor HP | Terkait keamanan OTP (NFR) |

---

## PAGE-03 — Verifikasi OTP

> **⚠️ Revisi 2026-07-14:** sama seperti PAGE-02 — kalau login sepenuhnya via WhatsApp tanpa OTP manual, seluruh case di halaman ini (kode salah/kedaluwarsa/resend/percobaan berlebih) **kemungkinan besar tidak berlaku**. Dipertahankan sbg draft sampai OQ-SO-10 (`SO_PRD.md`) terjawab.

**Objective:** Memastikan verifikasi OTP berjalan benar (kode benar/salah/kedaluwarsa/resend/percobaan berlebih) dan tamu hanya lanjut ke Review setelah verifikasi sah.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-03.1 | OTP baru terkirim | Lanjutan PAGE-02 sukses | 6 kotak kosong, timer 60s jalan, "Kirim Ulang Kode" disabled | OTP aktif tersimpan server | — | — |
| AC-03.2 | Isi 6 digit benar | Kode sesuai & belum expired | "Memverifikasi…" → sheet tutup → PAGE-08 | Nomor HP terverifikasi, tamu jadi "teridentifikasi" | Server cocokkan hash kode + cek expiry | — |
| AC-03.3 | **[Negatif]** Kode salah | Kode tidak cocok | "Kode OTP salah. Coba lagi." input bisa diisi ulang | Attempt counter bertambah 1 | Server bandingkan kode → mismatch | Maks 5 percobaan/kode |
| AC-03.4 | Resend setelah cooldown | Timer mencapai 0 | "Kirim Ulang Kode" aktif → tap → toast "Kode baru sudah dikirim ke WhatsApp-mu." | Kode lama invalid, kode baru aktif, timer reset 60s | Server invalidasi kode lama, generate baru | — |
| AC-03.5 | **[Negatif]** Kode kedaluwarsa | >5 menit sejak kode dikirim | "Kode sudah kedaluwarsa. Kirim ulang kode." | Kode lama tidak bisa dipakai lagi | Server cek `expiry` kode | — |
| (tambahan) | **[Negatif]** Melebihi 5 percobaan | 5x salah berturut-turut pada 1 kode | "Terlalu banyak percobaan. Tunggu beberapa menit." | Verifikasi terkunci sementara utk kode ini | Server cek `attempts >= 5` | Kena juga rate-limit resend? — perlu dipastikan interaksi kedua counter |

---

## PAGE-04 — Menu / Katalog

**Objective:** Memastikan katalog selalu menampilkan harga/stok terkini, pencarian & kategori bekerja, dan item habis tidak bisa ditambahkan ke keranjang.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-04.1 | Menu berhasil dimuat | Sesi valid (dari PAGE-01) | Kategori & item tampil dgn harga/ketersediaan terkini | Katalog live ter-render | Server return katalog + stok real-time | — |
| AC-04.2 | Item berstatus habis | Item stok = 0 | Badge "Habis", kartu redup, tombol "Habis" disabled | Item tidak bisa ditambahkan ke keranjang | Server flag `soldOut=true` per item | — |
| AC-04.3 | **[Negatif]** Pencarian tanpa hasil | Kata kunci tidak match item apa pun | "Menu tidak ditemukan. Coba kata kunci lain." | Tidak ada perubahan keranjang | Filter client/server-side, hasil kosong | — |
| AC-04.4 | Floating cart bar muncul | Keranjang berisi ≥1 item | "{n} item · Rp{subtotal}" + tombol "Lihat Keranjang" | — | Client-side re-render dari state cart | — |
| AC-04.5 | Strip ekspektasi login (guest, Metode A) | Pertama kali buka PAGE-04, belum login | Strip "Lihat-lihat dulu aja…" tampil, dismissible | Strip tidak muncul lagi setelah ditutup (per sesi) | — | Hanya Metode A |
| (tambahan) | **[Negatif]** Gagal memuat menu | Server/katalog error | "Gagal memuat menu. Coba lagi." + tombol retry | Katalog kosong sampai retry sukses | Request katalog gagal (5xx/timeout) | — |
| (tambahan) | **[Negatif]** Kata kunci pencarian >50 karakter | Input search kepanjangan | "Kata kunci terlalu panjang." input dibatasi | — | Validasi panjang client-side | — |

---

## PAGE-05 — Detail Item & Tambah ke Keranjang

**Objective:** Memastikan validasi opsi wajib, batas qty vs stok, dan batas panjang catatan bekerja sebelum item masuk keranjang — termasuk saat stok berubah real-time selagi tamu masih di halaman ini.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-05.1 | **[Negatif]** Opsi wajib belum dipilih | Item punya grup opsi "Wajib" | Tombol "Tambah" disabled; saat dicoba → "Pilih dulu {namaGrup}." | Item belum masuk keranjang | Validasi client: semua grup wajib terisi | — |
| AC-05.2 | Opsi & qty valid → tambah | Konfigurasi lengkap | Sheet tutup + toast "Ditambahkan ke keranjang" | Item baru di keranjang dgn snapshot harga & opsi | Server hitung total item (opsi + qty) | — |
| AC-05.3 | **[Negatif]** Qty melebihi stok tersisa | Tamu menaikkan qty > sisa stok | Qty dibatasi otomatis + "Jumlah melebihi stok tersedia ({sisa})." | Qty ter-cap ke sisa stok | Server return `stockRemaining` | — |
| AC-05.4 | **[Negatif]** Item jadi habis saat sheet terbuka | Stok berubah 0 real-time saat tamu masih di PAGE-05 | Tombol "Tambah" disabled + toast "Yah, menu ini baru saja habis." | Item tidak masuk keranjang | Push/poll status stok live | Race condition — perlu dipastikan mekanisme live update (WebSocket/poll) |
| AC-05.5 | **[Negatif]** Catatan >140 karakter | Textarea catatan dapur | Input dibatasi + "Catatan maksimal 140 karakter." | — | Validasi panjang client-side | — |
| (tambahan) | **[Negatif]** Gagal memuat detail item | Network/server error saat buka sheet | "Gagal memuat detail menu. Coba lagi." | Sheet tidak menampilkan konfigurasi opsi | Request detail item gagal | — |

---

## PAGE-06 — Keranjang

**Objective:** Memastikan pengelolaan keranjang (ubah qty/hapus item) dan pemicu login (Metode A) vs langsung checkout (Metode B/C) berjalan sesuai metode.

> **⚠️ Revisi 2026-07-14:** kode diskon manual dihapus dari scope (tidak dipakai). AC-06.2, AC-06.3, dan 4 baris "tambahan" terkait kode diskon di bawah **dihapus** dari tabel ini — lihat `SO_PRD.md` PAGE-06 untuk detail revisi.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-06.1 | Keranjang berisi item | ≥1 item di cart | Daftar item + subtotal + tombol "Cek Stok & Promo" aktif | — | — | — |
| AC-06.4 | Keranjang kosong | Semua item dihapus | Ilustrasi + "Keranjangmu masih kosong." + tombol "Lihat Menu" | "Cek Stok & Promo" disabled | — | Terjadi juga saat menghapus item terakhir |
| AC-06.5 | Metode A belum login tekan "Cek Stok & Promo" | Guest, Metode A | Sheet PAGE-02 (login) terpicu | Checkout tertunda sampai login selesai | — | — |
| AC-06.6 | Metode B/C tekan "Cek Stok & Promo" | QR dinamis, tanpa syarat login | Langsung validasi → PAGE-08 | — | Server mulai proses validasi stok & promo | — |

---

## PAGE-07 — Pilih Item Hadiah Promo *(kondisional)*

**Objective:** Memastikan alur pilih hadiah (manual/otomatis), kuota, item hadiah habis, dan syarat promo yang gugur ditangani tanpa memblokir tamu untuk lanjut checkout.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-07.1 | Promo aktif dgn hadiah pilihan | Syarat promo terpenuhi, tipe "pilih" | PAGE-07 tampil, daftar item hadiah eligible | — | Server hitung promo & daftar item eligible | Disisipkan dari PAGE-06/08 |
| AC-07.2 | Pilih hadiah sesuai kuota | Jumlah terpilih = kuota | Tombol "Pakai Hadiah" aktif → item masuk sbg baris "Gratis" → PAGE-08 | Item hadiah terikat ke order ini | Server catat item hadiah terpilih | — |
| AC-07.3 | Promo tipe otomatis (bukan pilihan) | Syarat terpenuhi, tipe "auto" | PAGE-07 dilewati, hadiah otomatis muncul di PAGE-08 | — | Server auto-assign item hadiah | — |
| AC-07.4 | **[Negatif]** Semua item hadiah habis | Stok item eligible = 0 semua | "Hadiah promo sedang tidak tersedia." + tombol "Lanjut Tanpa Hadiah" | Order lanjut tanpa hadiah | Server cek stok semua item eligible = 0 | — |
| AC-07.5 | **[Negatif]** Kuota belum terpenuhi, coba konfirmasi | Terpilih < kuota | Tombol tetap disabled / "Pilih {kuota} item hadiah dulu, ya." | Belum lanjut ke PAGE-08 | Validasi client: `terpilih < kuota` | — |
| (tambahan) | **[Negatif]** Syarat promo gugur setelah cart berubah | Tamu ubah cart selagi di PAGE-07 (mis. balik & hapus item) | Pilihan hadiah dibatalkan otomatis, notifikasi di PAGE-08 | Hadiah dilepas dari order | Server re-evaluasi syarat promo | Race condition antar-halaman |

---

## PAGE-08 — Review Read-only (Cek Stok & Promo)

**Objective:** Memastikan validasi server (stok, harga, promo) akurat dan ditampilkan ke tamu sebelum bayar — termasuk semua skenario perubahan (item habis, harga naik, promo gugur) — dan tombol aksi sesuai metode (A/B/C).

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-08.1 | Validasi server sukses, tanpa perubahan | Semua item tersedia, promo/diskon valid | Ringkasan read-only + total final (subtotal, diskon, promo, pajak) | Order "terkunci" siap bayar | Server validasi stok + hitung ulang promo/pajak | — |
| AC-08.2 | **[Negatif]** Item habis saat validasi | Stok item jadi 0 di antara PAGE-06 → PAGE-08 | Item dihapus otomatis + banner "{item} habis dan dihapus dari pesanan." total update | Cart server-side ter-update (item hilang) | Server re-cek stok saat validasi | Sudah ada desain: popup negative-case adaptif (`screen-negcase.jsx`) |
| AC-08.3 | Metode A telah login | OTP terverifikasi | Tombol aksi = "Bayar" → PAGE-09 | — | — | — |
| AC-08.4 | Metode C (QR dinamis) | Bayar di muka | Tombol "Bayar Sekarang" (→PAGE-09) & "Buka Bill (Bayar Nanti)" (→PAGE-10) | — | — | — |
| AC-08.5 | Tekan "Ubah Pesanan" | Ringkasan terkunci tampil | Kembali ke PAGE-06 | Ringkasan ter-unlock (batal terkunci) | — | — |
| AC-08.6 | **[Negatif]** Semua item gugur validasi | Semua item di cart habis stok | "Pesananmu kosong setelah pengecekan. Yuk pesan lagi." + tombol "Kembali ke Menu" | Cart kosong | Server: hasil validasi = 0 item valid | — |
| (tambahan) | **[Negatif]** Gagal validasi (koneksi/server error) | Request cek stok & promo gagal | "Gagal mengecek pesanan. Coba lagi." + tombol retry | Tetap di PAGE-06 (belum terkunci) atau PAGE-08 error state | Request gagal (5xx/timeout) | — |
| (tambahan) | **[Negatif]** Harga item berubah saat validasi | Harga server ≠ harga snapshot cart | Banner "Harga {item} diperbarui menjadi Rp{harga}." total menyesuaikan | Harga cart ter-sync ke harga server | Server bandingkan harga snapshot vs harga live | Price drift — tamu harus sadar sebelum bayar |
| (tambahan) | **[Negatif]** Promo/diskon jadi tidak berlaku saat validasi | Promo habis kuota / expired di antara langkah | Banner "Promo {nama} sudah tidak berlaku dan dilepas." total naik | Promo dilepas dari order | Server re-validasi promo saat checkout | — |
| (tambahan) | **[Negatif]** Sesi login (Metode A) kedaluwarsa sebelum bayar | Token OTP/sesi expired di antara PAGE-03 → PAGE-09 | Diminta verifikasi ulang (kembali ke PAGE-02/03) | Order tertahan sampai re-auth | Server cek validitas token sesi | — |

---

## PAGE-09 — Pembayaran

**Objective:** Memastikan kedua metode bayar (Bayar Langsung & QRIS) berjalan aman (idempoten, anti double-payment), status QRIS ter-update real-time via polling, dan semua kegagalan (kedaluwarsa/gagal buat kode/ditolak gateway) tertangani.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-09.1 | Halaman tampil | Dari PAGE-08/PAGE-10 | Total final + pilihan metode (Bayar Langsung, QRIS; Transfer Bank disabled) | — | — | — |
| AC-09.2 | Pilih QRIS | Metode QRIS dipilih | QR + nominal + hitung mundur + "Menunggu pembayaran…" | Transaksi QRIS dibuat di gateway | Server request kode QRIS ke gateway | — |
| AC-09.3 | QRIS dibayar → auto-detect lunas | Pembayaran QRIS sukses di sisi gateway | Otomatis redirect ke PAGE-11 tanpa aksi tamu | Status transaksi = lunas | Server polling status gateway | — |
| AC-09.4 | **[Negatif]** QRIS kedaluwarsa | Waktu QR habis (mis. 5 menit) sebelum dibayar | "Kode QRIS kedaluwarsa. Buat kode baru." | Kode lama invalid | Server cek `expiredAt` kode QRIS | Sudah ada desain: `Self Order - QRIS Kedaluwarsa.html` |
| AC-09.5 | Pilih Bayar Langsung | Metode direct dipilih | "Konfirmasi & Kirim Pesanan" → instruksi tunjuk layar ke staf | Order terkirim ke POS status "menunggu bayar di kasir" | Server kirim order ke POS; status bergantung konfirmasi staf | Alur & SLA konfirmasi staf — [[SO_PRD#10. Open Questions|OQ-SO-03]] |
| AC-09.6 | **[Negatif]** Percobaan bayar ganda | Transaksi sudah lunas, tamu ulangi proses bayar | Ditolak, langsung diarahkan ke PAGE-11 | Tidak ada transaksi duplikat | Server cek status transaksi sebelum proses ulang (double-payment guard) | **⚠️ Perlu konfirmasi PM (2026-07-14) — kemungkinan belum di-handle di implementasi aktual, lihat OQ-SO-11.** |
| (tambahan) | **[Negatif]** Gagal membuat kode QRIS | Gateway error saat generate | "Gagal membuat kode QRIS. Coba lagi." | Tidak ada kode QRIS aktif | Server terima error dari gateway | — |
| (tambahan) | **[Negatif]** Pembayaran ditolak gateway | QRIS dibayar tapi ditolak (saldo/limit dll) | "Pembayaran gagal. Coba metode lain atau ulangi." | Transaksi berstatus gagal | Server terima callback gagal dari gateway | — |
| (tambahan) | **[Negatif]** Refresh/tutup halaman saat QRIS pending | Tamu menutup tab lalu buka lagi | Status dipulihkan dari server (bukan mulai dari 0) | Idempoten — tidak membuat transaksi baru | Server return status transaksi existing by session | NFR reliabilitas pembayaran |
| (tambahan) | **[Negatif]** Belum pilih metode bayar, coba lanjut | Tidak ada metode dipilih | Tombol konfirmasi disabled / "Pilih metode pembayaran dulu." | — | Validasi client-side | — |

---

## PAGE-10 — Open Bill (Ringkasan Sesi & Tambah Order)

**Objective:** Memastikan open bill bisa menampung banyak order bertahap, promo dihitung scoped per-order (tidak lintas-order), dan bill yang ditutup kasir langsung menghentikan penambahan order dari sisi tamu.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-10.1 | Buka bill (Metode B) | Tekan "Buka Bill" di PAGE-08 | PAGE-10 tampil order pertama, status "Terbuka", running total | Bill baru dibuat server (billId, status=Terbuka) | Server create OpenBill + OrderBatch pertama | — |
| AC-10.2 | Tambah order | Tekan "Tambah Order" → selesai PAGE-04→PAGE-08 (mode tambah) | Order baru sbg batch terpisah, running total nambah | Batch baru tersimpan di bill yang sama | Server append OrderBatch ke bill | — |
| AC-10.3 | Promo per-order | Salah satu order penuhi syarat promo | Promo hanya berlaku pada order itu, tidak diakumulasi | — | Server hitung promo scoped per OrderBatch | — |
| AC-10.4 | Tutup & Bayar | Tekan "Tutup & Bayar" | Diarahkan ke PAGE-09 utk bayar seluruh bill | Bill masuk proses closing | — | — |
| AC-10.5 | **[Negatif]** Kasir tutup bill dari POS | Staf close bill selagi tamu masih nambah order | "Bill ini sudah ditutup oleh staf." penambahan dihentikan | Bill status = Ditutup (server-side), tidak bisa ditambah lagi | Server cek status bill sebelum terima order baru | **Reuse layar QR Kedaluwarsa yang sama (klarifikasi PM 2026-07-14) — lihat Case: Scan QR Dinamis → Kedaluwarsa di page Menu & Katalog.** |
| AC-10.6 | Bill terbuka **tidak** enqueue WL | Sesi open bill berjalan | Tidak ada aksi WL sampai bill ditutup+bayar | — | — | Handoff WL Open Bill di-hold — [[SO_PRD#10. Open Questions|OQ-SO-01]] |
| (tambahan) | **[Negatif]** Promo butuh akumulasi lintas-order | Promo hanya terpenuhi jika digabung >1 order | Ditolak — hanya promo yg terpenuhi dlm satu order yg berlaku | — | Server tolak evaluasi lintas-batch | — |
| (tambahan) | **[Negatif]** Gagal memuat bill | Network/server error saat buka PAGE-10 | "Gagal memuat bill. Coba lagi." | — | Request gagal | — |
| (tambahan) | **[Negatif]** Multi-device pada 1 meja | 2 HP menambah order ke bill sama bersamaan | Tidak boleh terjadi data race/duplikat | Bill tersinkron dari server (mekanisme lock/merge belum final) | — | **Belum ada aturan kepemilikan bill — [[SO_PRD#10. Open Questions|OQ-SO-04]]** |

---

## PAGE-11 — Konfirmasi Sukses & Handoff WL

**Objective:** Memastikan konfirmasi & enqueue Waiting List berjalan untuk Metode A/C, tidak untuk Metode B, dan kegagalan enqueue tidak ikut membatalkan pembayaran yang sudah sah.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|----|----------|-----------|------------------|-----------------|--------------------|---------|
| AC-11.1 | Bayar Metode A/C sukses | Pembayaran terkonfirmasi lunas | Konfirmasi sukses + ringkasan; proses enqueue WL berjalan | Order berstatus sukses; enqueue diproses | Server kirim order ke modul WL | — |
| AC-11.2 | Enqueue WL sukses | Enqueue selesai tanpa error | Blok "Kamu masuk antrean…" + tombol "Lihat Antrean" | Tamu terdaftar di WL dgn nomor antrean | Server terima ack dari modul WL | — |
| AC-11.3 | **[Negatif]** Enqueue WL gagal | Modul WL error/down | "Pesanan berhasil, tapi pendaftaran antrean gagal. Tunjukkan layar ini ke staf." | Pembayaran tetap sah, tamu tidak masuk antrean otomatis | Server terima error dari modul WL; pembayaran tidak dirollback | Perlu jalur retry/eskalasi manual ke staf |
| AC-11.4 | Bayar Metode B (tutup bill) sukses | Penutupan open bill lunas | Konfirmasi tampil **tanpa** blok WL | — | — | Konsisten dgn AC-10.6 (hold) |
| AC-11.5 | Buka ulang link konfirmasi | Tamu tutup halaman lalu kembali via link | Status sukses dipulihkan dari server | Tidak ada order duplikat | Server return status by order/session id | Idempotensi |
| (tambahan) | **[Negatif]** Refresh saat "Mendaftarkan antrean…" | Tamu refresh selagi enqueue diproses | Status dipulihkan (bukan enqueue ulang) | Tidak ada entri WL duplikat | Server cek apakah enqueue sudah pernah diproses utk order ini | Terkait idempotency PAGE-09 |

---

## Ringkasan Negative Case per Kategori

Dikelompokkan ulang lintas-halaman supaya mudah dipakai sbg checklist eksekusi test.

> **⚠️ Revisi 2026-07-14 (klarifikasi PM):** kategori 1 & 3 (bagian kode diskon) dan sebagian kategori 4 (OTP) di-drop — lihat detail di bawah tabel status per item.

1. **Stok & harga real-time (race condition)** — item habis saat sheet detail terbuka (PAGE-05, → jadi toast "Yah, menu ini baru saja habis", bukan popup terpisah), habis saat validasi (PAGE-08), harga berubah antara cart→checkout (PAGE-08), hadiah promo habis (PAGE-07 — sudah ter-spec penuh di PRD, belum ada desain visual).
2. **Promo edge** — promo gugur setelah cart berubah (PAGE-07), promo butuh akumulasi lintas-order pada open bill (PAGE-10), promo dilepas saat validasi (PAGE-08).
3. **Sesi & QR** — QR dinamis kedaluwarsa (PAGE-01) — **sudah ada desain, dipakai ulang (reuse) utk 2 skenario lain**: kasir tutup bill dari POS (PAGE-10 AC-10.5) & (kalau relevan) sesi lain yang invalid. Ditaruh sbg `Case: Scan QR Dinamis → Kedaluwarsa` di page Menu & Katalog.
4. **Pembayaran** — QRIS kedaluwarsa/gagal dibuat/ditolak gateway (PAGE-09), refresh saat pending (PAGE-09/11), status "Bayar Langsung" bergantung konfirmasi staf yang alurnya belum final (OQ-SO-03). Double-payment (AC-09.6) **perlu konfirmasi ulang** (OQ-SO-11).
5. **Open Bill** — multi-device satu meja (OQ-SO-04, terkait juga OQ-SO-08 utk login umum), handoff WL untuk open bill masih hold (OQ-SO-01).
6. **Jaringan/infrastruktur** — gagal load menu/detail/bill (berbagai halaman), timeout resolve QR, gagal enqueue WL (PAGE-11). No-connection state: ilustrasi sudah ada, sudah jadi 1 case referensi (lihat Menu & Katalog) — copy/trigger final masih OQ-SO-09.
7. **Konsistensi lintas-halaman** — buka ulang link konfirmasi tanpa duplikasi order, kembali dari sheet tanpa kehilangan isi keranjang.

**Di-drop dari scope (klarifikasi PM 2026-07-14):**
- Nomor HP salah format / OTP salah-expired-rate-limit (PAGE-02/03) — login ternyata via WhatsApp langsung, bukan input manual. Lihat OQ-SO-10 kalau mekanisme final berbeda dari ini.
- Kode diskon manual salah format/tidak valid/expired/ineligible/bentrok promo (PAGE-06) — fitur kode diskon dihapus dari scope.
- QR "tidak dikenali" (invalid token) — dianggap kegagalan level device/scan, bukan tanggung jawab app.

**Belum tercakup di PRD, perlu keputusan PM sebelum bisa diuji:**
- Perilaku saat qty/order melebihi batas maksimum per item — batas belum ditentukan (OQ-SO-06).
- Format & channel pengiriman struk/bukti (OQ-SO-05) — mempengaruhi skenario "cek struk setelah selesai".
- Kanal Bayar Online non-QRIS (VA bank) — di luar scope saat ini, jadi belum ada skenario negatif untuknya.
- Login multi-device (OQ-SO-08) — belum ada keputusan apakah didukung.

---

*Dokumen ini turunan manual dari [[SO_PRD]] (bukan output otomatis sub-agent doc). Update PRD → tinjau ulang tabel ini agar tetap sinkron.*
