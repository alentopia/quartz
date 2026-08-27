# WL_Case1_SelfScan — Self-Service QR Scan

**Status:** Draft
**Versi:** 0.1
**Tanggal:** 2026-05-18
**Author:** Doc Agent

---

## Referensi

- Overview: [[WL_Overview]]
- Requirements: [[WL_Requirements]]
- User Stories: [[WL_UserStories]]

---
## 1. Alternative Flows

### AF-01: Koneksi internet tamu lambat
- Sistem menampilkan loading state
- Jika timeout (> 10 detik): tampilkan pesan error dan tombol "Coba Lagi"
- Data form tidak hilang saat retry

### AF-02: Data form tidak lengkap
- Sistem menampilkan pesan validasi inline (mis. "Nama wajib diisi")
- Tamu tidak dapat melanjutkan sampai semua field terisi

### AF-03: QR/barcode rusak atau tidak terbaca
- Tamu menghubungi waiter untuk bantuan → diarahkan ke [[WL_Case2_WaiterMonitor]] atau [[WL_Case3_WalkInSmartQueue]]

---

## 2. Exception Flows

### EX-01: Sistem backend tidak merespons
- Sistem menampilkan halaman error yang ramah pengguna
- Tamu diarahkan untuk menghubungi staf restoran

### EX-02: Nomor antrian gagal di-generate
- Sistem mencoba generate ulang (retry 1x)
- Jika masih gagal: tampilkan error dan sarankan hubungi staf

---

## 3. Business Rules

| Kode  | Aturan                                                       | Status     |
| ----- | ------------------------------------------------------------ | ---------- |
| BR-01 | Satu scan QR menghasilkan satu sesi antrian (satu rombongan) | Confirmed  |
| BR-02 | Nomor antrian bersifat unik per hari operasional             | Confirmed  |
| BR-03 | Nama wajib diisi (minimum 2 karakter)                        | Confirmed  |
| BR-04 | Jumlah orang wajib dipilih (minimum 1, maksimum TBD)         | TBD: OQ-04 |
| BR-05 | Kapasitas maksimum antrian per hari                          | TBD: OQ-08 |
| BR-06 | Waktu kedaluwarsa antrian jika tamu tidak hadir              | TBD: OQ-04 |

---

## 4. Data & Field

### Input Form
| Field        | Tipe            | Wajib | Validasi                        |
| ------------ | --------------- | ----- | ------------------------------- |
| Nama         | Text            | Ya    | Min 2 karakter, max 50 karakter |
| Jumlah Orang | Number/Selector | Ya    | Min 1, max TBD                  |

### Output ke Tamu
| Data                 | Keterangan                                             |
| -------------------- | ------------------------------------------------------ |
| Nomor Antrian        | Format: angka urut (mis. A-001, atau 001) — format TBD |
| Posisi dalam Antrian | Jumlah rombongan di depan tamu                         |

---

## 5. UI Reference

Lihat: [[WL_UISpec#Case1_SelfScan]]

Screen yang diperlukan:
- SC-C1-01: Halaman Landing / Scan Entry
- SC-C1-02: Form Input Data Tamu
- SC-C1-03: Konfirmasi & Tampilan Nomor Antrian
- SC-C1-04: Status Antrian Real-time

---

*Dibuat oleh Doc Agent pada 2026-05-18. Dependensi: [[WL_Overview]] sudah tersedia.*
