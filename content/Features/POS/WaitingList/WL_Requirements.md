# WL_Requirements — Functional & Non-Functional Requirements

**Status:** Draft
**Versi:** 0.2
**Tanggal:** 2026-05-20
**Author:** Req Agent

---

## Referensi

- Overview: [[WL_Overview]]
- Use Case 1: [[WL_Case1_SelfScan]]
- Use Case 2: [[WL_Case2_WaiterMonitor]]
- Use Case 3: [[WL_Case3_WalkInSmartQueue]]
- User Stories: [[WL_UserStories]]
- UI Spec: [[WL_UISpec]]

---

## 1. Functional Requirements

### 1.1 Modul Pendaftaran Antrian — Self-Service (Case 1)

| ID | Requirement | Prioritas | Sumber | Status |
|----|-------------|-----------|--------|--------|
| FR-01 | Sistem HARUS menyediakan QR/barcode statis yang dapat di-scan di area masuk restoran | Tinggi | UC-01 | Confirmed |
| FR-02 | Sistem HARUS menampilkan form input (nama, jumlah orang) setelah QR berhasil di-scan | Tinggi | UC-01 | Confirmed |
| FR-03 | Sistem HARUS memvalidasi bahwa field nama dan jumlah orang terisi sebelum submit | Tinggi | UC-01 | Confirmed |
| FR-04 | Sistem HARUS men-generate nomor antrian unik secara otomatis setelah data tamu disubmit | Tinggi | UC-01 | Confirmed |
| FR-05 | Sistem HARUS menampilkan nomor antrian, estimasi waktu tunggu, dan posisi antrian di smartphone tamu | Tinggi | UC-01 | Confirmed |
| FR-06 | Sistem HARUS memungkinkan tamu memantau status antrian secara real-time dari smartphone | Sedang | UC-01 | Confirmed |
| FR-07 | Sistem HARUS menampilkan pesan error yang informatif jika pendaftaran gagal, beserta opsi retry | Sedang | UC-01 | Confirmed |
| FR-08 | Sistem HARUS menampilkan informasi bahwa antrian penuh jika kapasitas tercapai | Sedang | UC-01 | TBD: OQ-08 |

### 1.2 Modul Pendaftaran Antrian — Waiter-Assisted (Case 2 & 3)

| ID | Requirement | Prioritas | Sumber | Status |
|----|-------------|-----------|--------|--------|
| FR-09 | Sistem HARUS menyediakan modul input antrian di perangkat waiter (tablet/POS terminal) | Tinggi | UC-02, UC-03 | Confirmed |
| FR-10 | Waiter HARUS dapat menginput jumlah orang (wajib) dan nama tamu (opsional) | Tinggi | UC-02, UC-03 | Confirmed |
| FR-11 | Sistem HARUS men-generate nomor antrian setelah waiter mensubmit data | Tinggi | UC-02, UC-03 | Confirmed |
| FR-12 | Sistem HARUS menampilkan nomor antrian yang berhasil di-generate di perangkat waiter | Tinggi | UC-02, UC-03 | Confirmed |
| FR-13 | Antrian dari Case 1, 2, dan 3 HARUS masuk ke pool antrian yang sama (terintegrasi) | Tinggi | UC-01, UC-02, UC-03 | Confirmed |

### 1.3 Modul Monitor Restoran (Case 2)

| ID | Requirement | Prioritas | Sumber | Status |
|----|-------------|-----------|--------|--------|
| FR-14 | Sistem HARUS menampilkan daftar nomor antrian aktif di monitor publik restoran | Tinggi | UC-02 | Confirmed |
| FR-15 | Monitor HARUS menampilkan nomor antrian yang sedang "dipanggil" dengan highlight visual | Tinggi | UC-02 | Confirmed |
| FR-16 | Tampilan monitor HARUS diperbarui secara real-time tanpa refresh manual | Sedang | UC-02 | Confirmed |
| FR-17 | Sistem HARUS mendukung mekanisme "panggil tamu" oleh waiter/host dari perangkat staf | Sedang | UC-02 | Confirmed |

### 1.4 Modul Struk Fisik & Live Tracking (Case 3 — Walk-In & Smart Queuing)

| ID | Requirement | Prioritas | Sumber | Status |
|----|-------------|-----------|--------|--------|
| FR-18 | Sistem HARUS men-generate QR Code unik per sesi antrian yang men-encode URL halaman live tracking | Tinggi | UC-03 | Confirmed |
| FR-19 | Sistem HARUS mencetak struk fisik secara otomatis setelah pendaftaran antrian berhasil | Tinggi | UC-03 | Confirmed |
| FR-20 | Struk fisik WAJIB memuat: Nomor Antrian dan QR Code | Tinggi | UC-03 | Confirmed |
| FR-21 | Setelah scan QR Code, tamu HARUS dapat melihat halaman web live tracking nomor antrian mereka | Tinggi | UC-03 | Confirmed |
| FR-22 | Halaman live tracking HARUS menampilkan: nomor antrian, posisi antrian saat ini, jumlah antrian di depan, estimasi waktu tunggu, dan status antrian | Tinggi | UC-03 | Confirmed |
| FR-23 | Halaman live tracking HARUS memperbarui data secara real-time tanpa refresh manual oleh tamu | Sedang | UC-03 | Confirmed |
| FR-24 | Halaman live tracking HARUS dapat diakses tanpa instalasi aplikasi dan tanpa login | Tinggi | UC-03 | Confirmed |
| FR-25 | Jika printer tidak tersedia, sistem HARUS menyediakan fallback: tampilkan QR Code secara digital di layar perangkat waiter | Sedang | UC-03 | TBD: OQ-05 |

### 1.5 Manajemen Antrian (Umum)

| ID | Requirement | Prioritas | Sumber | Status |
|----|-------------|-----------|--------|--------|
| FR-27 | Sistem HARUS menggunakan urutan FIFO (first in, first out) berdasarkan waktu registrasi | Tinggi | BR-09 | Confirmed |
| FR-28 | Nomor antrian HARUS bersifat unik per hari operasional | Tinggi | BR-02 | Confirmed |
| FR-29 | Sistem HARUS menghitung dan menampilkan estimasi waktu tunggu berdasarkan posisi antrian | Sedang | UC-01, UC-03 | Confirmed |
| FR-30 | Waiter/host HARUS dapat menonaktifkan (skip/remove) nomor antrian yang tidak hadir | Sedang | AF-04 (Case 2) | Confirmed |
| FR-31 | Sistem HARUS mengatur batas waktu kedaluwarsa antrian jika tamu tidak hadir | Sedang | BR-06 | TBD: OQ-04 |
| FR-32 | Sistem HARUS mendukung reset antrian pada akhir hari operasional | Sedang | Operational | Confirmed |

	
---

## 4. Open Questions pada Requirements

| # | Pertanyaan | ID OQ | Berdampak pada |
|---|------------|-------|----------------|
| OQ-04 | Business rules antrian (kapasitas, timeout, format nomor) | OQ-04 | FR-08, FR-31, NFR-04, NFR-09 |
| OQ-05 | Format struk fisik (thermal printer standar atau custom), fallback digital jika printer offline | OQ-05 | FR-19, FR-25 |
| OQ-06 | Target platform (web/PWA/native) | OQ-06 | NFR-13 |
| OQ-08 | Kapasitas maksimum antrian | OQ-08 | FR-08, NFR-04 |

---

*Dibuat oleh Req Agent pada 2026-05-18. Diperbarui oleh Doc Orchestrator pada 2026-05-20: Seksi 1.4 diganti dari Modul Barcode Sesi & Pre-Order menjadi Modul Struk Fisik & Live Tracking (Case 3 — Walk-In & Smart Queuing). Semua FR terkait pre-order (FR-21 s/d FR-26 lama) dihapus dan digantikan dengan FR baru.*
*Total: 31 functional requirements*
