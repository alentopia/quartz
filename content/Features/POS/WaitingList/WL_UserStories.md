# WL_UserStories — User Stories Waiting List

**Status:** Draft
**Versi:** 0.2
**Tanggal:** 2026-05-20
**Author:** Story Agent

---

## Referensi

- Overview: [[WL_Overview]]
- Requirements: [[WL_Requirements]]
- Use Case 1: [[WL_Case1_SelfScan]]
- Use Case 2: [[WL_Case2_WaiterMonitor]]
- Use Case 3: [[WL_Case3_WalkInSmartQueue]]
- UI Spec: [[WL_UISpec]]

---

## Konvensi Penulisan

Format: **Sebagai [persona], saya ingin [aksi], sehingga [manfaat].**

Skala prioritas: Tinggi / Sedang / Rendah
Status: Draft / Review / Approved / Deferred

---

## Epic 1: Self-Service Antrian via QR (Case 1)

**Deskripsi Epic:** Tamu dapat mendaftar antrian secara mandiri menggunakan smartphone tanpa perlu interaksi dengan staf.

---

### US-01 — Scan QR untuk Daftar Antrian

**Sebagai** tamu restoran,
**Saya ingin** dapat men-scan QR code yang tersedia di area masuk restoran dengan kamera smartphone saya,
**Sehingga** saya dapat langsung membuka halaman pendaftaran antrian tanpa harus mengunduh aplikasi.

**Acceptance Criteria:**
- [ ] QR code dapat di-scan menggunakan aplikasi kamera bawaan iOS dan Android
- [ ] Setelah scan berhasil, browser mobile membuka halaman pendaftaran antrian secara otomatis
- [ ] Halaman terbuka dalam waktu < 5 detik pada jaringan 4G
- [ ] Halaman dapat diakses tanpa login atau instalasi aplikasi

**Prioritas:** Tinggi
**Terkait:** FR-01, FR-02 | SC-C1-01

---

### US-02 — Input Data Rombongan

**Sebagai** tamu yang ingin mendaftar antrian,
**Saya ingin** dapat mengisi nama dan jumlah orang dalam rombongan saya,
**Sehingga** staf restoran tahu identitas dan ukuran kelompok saya untuk persiapan meja.

**Acceptance Criteria:**
- [ ] Form menampilkan field: Nama (text input) dan Jumlah Orang (selector/stepper)
- [ ] Field nama wajib diisi, minimum 2 karakter
- [ ] Field jumlah orang wajib diisi, minimum 1 orang
- [ ] Tombol "Daftar Antrian" hanya aktif jika semua field terisi valid
- [ ] Pesan validasi muncul secara inline di bawah field yang kosong/tidak valid

**Prioritas:** Tinggi
**Terkait:** FR-02, FR-03 | SC-C1-02

---

### US-03 — Terima Nomor Antrian di Smartphone

**Sebagai** tamu yang sudah mengisi form pendaftaran,
**Saya ingin** langsung mendapatkan nomor antrian yang tampil di layar smartphone saya,
**Sehingga** saya tahu giliran saya dan dapat menunggu dengan tenang.

**Acceptance Criteria:**
- [ ] Nomor antrian ditampilkan dalam waktu < 3 detik setelah submit
- [ ] Halaman konfirmasi menampilkan: nomor antrian, estimasi waktu tunggu, dan jumlah rombongan di depan
- [ ] Nomor antrian ditampilkan dengan font besar dan jelas (min 48px equivalent)
- [ ] Tamu dapat menyimpan / screenshot halaman

**Prioritas:** Tinggi
**Terkait:** FR-04, FR-05 | SC-C1-03

---

### US-04 — Pantau Status Antrian Real-time

**Sebagai** tamu yang sudah mendapatkan nomor antrian,
**Saya ingin** dapat memantau posisi antrian saya secara real-time dari smartphone,
**Sehingga** saya tahu kapan giliran saya hampir tiba dan tidak perlu terus bertanya ke staf.

**Acceptance Criteria:**
- [ ] Halaman status antrian dapat diakses kembali melalui halaman yang sama (URL/sesi aktif)
- [ ] Status diperbarui otomatis setiap beberapa detik tanpa perlu refresh manual
- [ ] Menampilkan: nomor antrian, posisi saat ini, estimasi waktu tunggu yang diperbarui
- [ ] Indikator visual/animasi saat antrian berubah posisi

**Prioritas:** Sedang
**Terkait:** FR-06, FR-29 | SC-C1-04

---

### US-05 — Informasi Error yang Jelas

**Sebagai** tamu yang mengalami masalah teknis saat mendaftar,
**Saya ingin** mendapatkan pesan error yang jelas dan opsi untuk mencoba lagi,
**Sehingga** saya tidak bingung dan tahu langkah selanjutnya.

**Acceptance Criteria:**
- [ ] Jika pendaftaran gagal, sistem menampilkan pesan error dalam Bahasa Indonesia yang mudah dipahami
- [ ] Tombol "Coba Lagi" tersedia di halaman error
- [ ] Data yang sudah diisi di form tidak hilang saat retry
- [ ] Jika error berlanjut, tampilkan instruksi untuk menghubungi staf

**Prioritas:** Sedang
**Terkait:** FR-07 | SC-C1-02, SC-C1-03

---

## Epic 2: Waiter-Assisted Antrian (Case 2)

**Deskripsi Epic:** Waiter dapat mendaftarkan tamu ke sistem antrian menggunakan perangkat staf, dan tamu dapat memantau antrean melalui monitor restoran.

---

### US-06 — Waiter Input Data Tamu

**Sebagai** waiter,
**Saya ingin** dapat menginput nama dan jumlah orang dalam rombongan tamu di perangkat saya,
**Sehingga** tamu dapat terdaftar ke sistem antrian tanpa harus mengoperasikan smartphone sendiri.

**Acceptance Criteria:**
- [ ] Modul antrian tersedia di perangkat waiter (tablet/POS) setelah login
- [ ] Form menampilkan field: Nama Tamu, Jumlah Orang, Catatan (opsional)
- [ ] Semua field wajib (kecuali catatan) tervalidasi sebelum submit
- [ ] Setelah submit berhasil, nomor antrian tampil di layar perangkat waiter
- [ ] Proses input selesai dalam < 30 detik dari tamu datang

**Prioritas:** Tinggi
**Terkait:** FR-09, FR-10, FR-11, FR-12 | SC-C2-01

---

### US-07 — Monitor Restoran Tampilkan Antrian Aktif

**Sebagai** tamu yang menunggu,
**Saya ingin** dapat melihat nomor antrian aktif di monitor restoran,
**Sehingga** saya tahu kapan giliran saya hampir tiba tanpa harus menggunakan smartphone.

**Acceptance Criteria:**
- [ ] Monitor menampilkan daftar nomor antrian yang sedang aktif
- [ ] Nomor antrian yang sedang "dipanggil" disorot secara visual (warna berbeda/animasi)
- [ ] Tampilan diperbarui real-time (delay maksimal 2 detik)
- [ ] Teks nomor antrian cukup besar untuk terbaca dari jarak minimal 3 meter

**Prioritas:** Tinggi
**Terkait:** FR-14, FR-15, FR-16 | SC-C2-03

---

### US-08 — Waiter Panggil Nomor Antrian

**Sebagai** waiter / host,
**Saya ingin** dapat memangil nomor antrian tertentu dari perangkat saya,
**Sehingga** tamu tahu giliran mereka dan dapat segera menuju meja.

**Acceptance Criteria:**
- [ ] Tombol "Panggil" tersedia di daftar antrian di perangkat waiter
- [ ] Setelah tombol ditekan, nomor antrian tersebut di-highlight di monitor restoran
- [ ] Sistem mencatat waktu pemanggilan
- [ ] Waiter dapat memanggil ulang jika tamu belum hadir

**Prioritas:** Tinggi
**Terkait:** FR-17 | SC-C2-01

---

### US-09 — Waiter Nonaktifkan Antrian yang Tidak Hadir

**Sebagai** waiter,
**Saya ingin** dapat menghapus atau melewati nomor antrian tamu yang tidak hadir setelah beberapa kali dipanggil,
**Sehingga** antrian tidak tertahan dan tamu berikutnya tidak terlalu lama menunggu.

**Acceptance Criteria:**
- [ ] Opsi "Skip / Tidak Hadir" tersedia untuk setiap nomor antrian aktif
- [ ] Setelah di-skip, antrian otomatis maju ke nomor berikutnya
- [ ] Nomor yang di-skip tercatat di log sistem
- [ ] Konfirmasi dialog muncul sebelum eksekusi skip (mencegah aksi tidak sengaja)

**Prioritas:** Sedang
**Terkait:** FR-30 | SC-C2-01

---

## Epic 3: Walk-In & Smart Queuing (Case 3)

**Deskripsi Epic:** Waiter mendaftarkan tamu walk-in ke sistem antrian, sistem mencetak struk fisik berisi nomor antrian dan QR Code, dan tamu dapat memantau posisi antrian secara real-time melalui halaman web live tracking tanpa instalasi aplikasi.

---

### US-10 — Waiter Daftarkan Tamu Walk-In

**Sebagai** waiter,
**Saya ingin** dapat menginput jumlah orang dan nama tamu (opsional) ke modul antrian, lalu menekan tombol untuk mendaftarkan dan mencetak struk,
**Sehingga** tamu walk-in dapat masuk ke antrian dengan cepat tanpa perlu mengoperasikan perangkat sendiri.

**Acceptance Criteria:**
- [ ] Modul antrian tersedia di perangkat waiter setelah login
- [ ] Field "Jumlah Orang" wajib diisi (minimum 1)
- [ ] Field "Nama Tamu" bersifat opsional (boleh kosong)
- [ ] Tombol "Daftarkan & Cetak Struk" aktif jika jumlah orang sudah terisi
- [ ] Proses pendaftaran selesai dan struk mulai dicetak dalam waktu < 5 detik setelah tombol ditekan

**Prioritas:** Tinggi
**Terkait:** FR-09, FR-10, FR-11, FR-18, FR-19 | SC-C3-01

---

### US-11 — Struk Fisik Dicetak dengan Nomor Antrian dan QR Code

**Sebagai** waiter,
**Saya ingin** sistem mencetak struk fisik secara otomatis setelah pendaftaran berhasil,
**Sehingga** saya dapat langsung menyerahkan struk kepada tamu sebagai bukti antrian.

**Acceptance Criteria:**
- [ ] Struk dicetak otomatis tanpa langkah tambahan dari waiter
- [ ] Struk memuat nomor antrian dengan angka besar dan jelas
- [ ] Struk memuat QR Code yang valid dan dapat di-scan
- [ ] Struk memuat informasi pendukung: nama restoran, tanggal & waktu, jumlah orang, nama tamu (jika diisi)
- [ ] Jika printer error, sistem menampilkan pesan error dan opsi fallback (tampilkan QR Code di layar perangkat)

**Prioritas:** Tinggi
**Terkait:** FR-19, FR-20, FR-25 | SC-C3-02

---

### US-12 — Tamu Scan QR Code untuk Live Tracking

**Sebagai** tamu yang memegang struk antrian,
**Saya ingin** dapat men-scan QR Code di struk untuk membuka halaman web status antrian saya,
**Sehingga** saya bisa memantau posisi antrian dari smartphone tanpa harus terus-menerus bertanya ke staf atau berdiri di depan monitor.

**Acceptance Criteria:**
- [ ] QR Code dapat di-scan menggunakan aplikasi kamera bawaan iOS dan Android
- [ ] Setelah scan, browser membuka halaman live tracking secara otomatis (tanpa download aplikasi)
- [ ] Halaman dapat diakses tanpa login
- [ ] Halaman terbuka dalam waktu < 5 detik pada jaringan 4G

**Prioritas:** Tinggi
**Terkait:** FR-21, FR-24 | SC-C3-03

---

### US-13 — Tamu Pantau Posisi Antrian Real-Time

**Sebagai** tamu yang sudah scan QR Code,
**Saya ingin** melihat posisi antrian saya secara real-time di halaman web yang terbuka,
**Sehingga** saya tahu kapan giliran saya hampir tiba dan dapat bersiap tanpa harus menunggu di lokasi yang tidak nyaman.

**Acceptance Criteria:**
- [ ] Halaman menampilkan: nomor antrian, posisi saat ini, jumlah antrian di depan, estimasi waktu tunggu, dan status (Menunggu / Dipanggil / Selesai)
- [ ] Data diperbarui secara real-time tanpa refresh manual
- [ ] Perubahan posisi atau status ditampilkan dengan jelas (animasi atau indikator visual)
- [ ] Halaman tetap dapat diakses ulang dengan scan QR Code yang sama

**Prioritas:** Tinggi
**Terkait:** FR-22, FR-23 | SC-C3-03

---

## Epic 4: Manajemen & Integrasi Antrian (Umum)

---

### US-16 — Antrian Terintegrasi Lintas Case

**Sebagai** waiter / host,
**Saya ingin** melihat semua antrian (dari self-service dan yang didaftarkan waiter) dalam satu tampilan yang terintegrasi,
**Sehingga** saya dapat mengelola antrian secara menyeluruh tanpa beralih sistem.

**Acceptance Criteria:**
- [ ] Semua pendaftaran dari Case 1, 2, dan 3 masuk ke pool antrian yang sama
- [ ] Urutan antrian berdasarkan FIFO (waktu registrasi)
- [ ] Tampilan di perangkat waiter menunjukkan asal case setiap antrian (ikon/label)
- [ ] Tidak ada duplikasi nomor antrian lintas case

**Prioritas:** Tinggi
**Terkait:** FR-13, FR-27, FR-28 | SC-C2-01

---

### US-17 — Reset Antrian Akhir Hari

**Sebagai** manajer restoran,
**Saya ingin** dapat me-reset daftar antrian pada akhir hari operasional,
**Sehingga** antrian keesokan harinya dimulai dari awal dan nomor tidak bercampur dengan hari sebelumnya.

**Acceptance Criteria:**
- [ ] Fungsi reset antrian tersedia dengan akses terbatas (hanya manajer/admin)
- [ ] Konfirmasi dialog muncul sebelum eksekusi reset
- [ ] Setelah reset, nomor antrian kembali ke awal (mis. 001)
- [ ] Data antrian hari sebelumnya tersimpan untuk keperluan laporan

**Prioritas:** Sedang
**Terkait:** FR-32 | TBD di UISpec

---

## Ringkasan User Stories

| Epic | ID User Story | Prioritas |
|------|--------------|-----------|
| Epic 1: Self-Service QR | US-01 s/d US-05 | 3 Tinggi, 2 Sedang |
| Epic 2: Waiter-Assisted Monitor | US-06 s/d US-09 | 3 Tinggi, 1 Sedang |
| Epic 3: Walk-In & Smart Queuing | US-10 s/d US-13 | 4 Tinggi |
| Epic 4: Manajemen Umum | US-16 s/d US-17 | 1 Tinggi, 1 Sedang |

**Total: 15 user stories** (11 Tinggi, 4 Sedang)

---

*Dibuat oleh Story Agent pada 2026-05-18. Diperbarui oleh Doc Orchestrator pada 2026-05-20: Epic 3 diganti dari Barcode Pre-Order menjadi Walk-In & Smart Queuing. US-12 s/d US-15 (pre-order) dihapus, digantikan US-12 dan US-13 (live tracking).*
