# WL_Case3_WalkInSmartQueue — Walk-In & Smart Queuing System

**Status:** Draft
**Versi:** 1.0
**Tanggal:** 2026-05-20
**Author:** Doc Orchestrator

---

## Referensi

- Overview: [[WL_Overview]]
- Requirements: [[WL_Requirements]]
- User Stories: [[WL_UserStories]]

---

## 1. Alternative Flows

### AF-01: Nama tamu tidak diisi
- Waiter hanya mengisi jumlah orang (field wajib)
- Sistem menerima input tanpa nama; struk tetap dicetak
- Nomor antrian tetap ter-generate normal

### AF-02: Tamu tidak men-scan QR Code
- Tamu tetap dapat memantau antrian melalui monitor publik restoran (Case 2)
- Struk berfungsi sebagai bukti fisik nomor antrian
- Tidak ada konsekuensi sistem — QR Code bersifat opsional untuk tamu

### AF-03: Tamu kehilangan struk
- Waiter dapat mencari data antrian tamu berdasarkan nomor urut atau waktu registrasi
- Waiter dapat mencetak ulang struk dari sistem

### AF-04: Printer tidak tersedia atau error
- Sistem menampilkan pesan error di perangkat waiter
- Waiter dapat menampilkan nomor antrian dan QR Code secara digital di layar perangkat (fallback)
- Tamu dapat screenshot tampilan di perangkat waiter sebagai pengganti struk fisik

---

## 2. Exception Flows

### EX-01: Gagal men-generate nomor antrian
- Sistem menampilkan pesan error di perangkat waiter
- Data yang sudah diinput tidak hilang
- Waiter dapat mencoba submit ulang

### EX-02: QR Code tidak dapat di-scan (kamera tamu bermasalah)
- Tamu tetap memiliki nomor antrian di struk fisik
- Tamu dapat memantau antrian melalui monitor restoran

### EX-03: Halaman live tracking tidak dapat diakses
- Sistem menampilkan halaman error yang informatif
- Tamu diarahkan untuk memantau antrian melalui monitor restoran

---

## 3. Business Rules

| Kode  | Aturan                                                                                   | Status     |
| ----- | ---------------------------------------------------------------------------------------- | ---------- |
| BR-14 | Satu struk = satu sesi antrian (satu rombongan tamu)                                     | Confirmed  |
| BR-15 | QR Code di struk hanya valid untuk satu sesi antrian aktif                               | Confirmed  |
| BR-16 | Jumlah orang wajib diisi; nama tamu bersifat opsional                                    | Confirmed  |
| BR-17 | Nomor antrian bersifat unik per hari operasional                                         | Confirmed  |
| BR-18 | Halaman live tracking dapat diakses tanpa login oleh siapa pun yang memiliki URL/QR Code | Confirmed  |
| BR-19 | Struk fisik dicetak otomatis setelah pendaftaran berhasil                                | Confirmed  |
| BR-20 | Jika printer gagal, waiter dapat menyajikan QR Code secara digital sebagai fallback      | TBD: OQ-05 |

---

## 4. Data & Field

### Input Waiter

| Field        | Tipe             | Wajib | Validasi                               |
| ------------ | ---------------- | ----- | -------------------------------------- |
| Jumlah Orang | Number / Stepper | Ya    | Min 1, max TBD (lihat OQ-04)           |
| Nama Tamu    | Text             | Tidak | Maks 50 karakter; kosong diperbolehkan |

### Output Struk Fisik

| Komponen | Keterangan |
|----------|-----------|
| Nomor Antrian | Ditampilkan besar dan jelas; format: angka 3 digit (mis. 023) |
| QR Code | Encode URL halaman live tracking sesi ini; satu sesi satu QR unik |
| Nama Restoran | Header struk |
| Tanggal & Waktu Registrasi | Dicatat di struk |
| Jumlah Orang | Dicatat di struk |
| Nama Tamu | Dicatat di struk jika diisi; kosong jika tidak diisi |

### Data Sesi Live Tracking (ditampilkan di halaman web)

| Field | Keterangan |
|-------|-----------|
| Nomor Antrian | Nomor unik sesi ini |
| Posisi Antrian | Urutan saat ini di antrian aktif |
| Jumlah Antrian di Depan | Berapa sesi yang masih menunggu sebelum sesi ini |
| Estimasi Waktu Tunggu | Kalkulasi berdasarkan posisi dan rata-rata waktu pelayanan |
| Status | Menunggu / Dipanggil / Selesai |

---

*Dibuat oleh Doc Orchestrator pada 2026-05-20. Menggantikan WL_Case3_WaiterPreOrder.md (konsep pre-order dihapus sepenuhnya). Dependensi: [[WL_Overview]] tersedia.*
