# WL_Overview — Waiting List

**Status:** Draft
**Versi:** 0.2
**Tanggal:** 2026-05-20
**Author:** Doc Orchestrator (PRD Agent)

---

## Daftar Isi

- [[WL_Overview#1. Executive Summary|1. Executive Summary]]
- [[WL_Overview#2. Problem Statement|2. Problem Statement]]
- [[WL_Overview#3. Goals & Success Metrics|3. Goals & Success Metrics]]
- [[WL_Overview#4. Scope Fitur|4. Scope Fitur]]
- [[WL_Overview#5. Use Cases|5. Use Cases]]
- [[WL_Overview#6. Aktor & Stakeholder|6. Aktor & Stakeholder]]
- [[WL_Overview#7. Integrasi Sistem|7. Integrasi Sistem]]
- [[WL_Overview#8. Constraints & Assumptions|8. Constraints & Assumptions]]
- [[WL_Overview#9. Open Questions (TBD)|9. Open Questions (TBD)]]
- [[WL_Overview#10. Dokumen Terkait|10. Dokumen Terkait]]

---

## 1. Executive Summary

Fitur **Waiting List** adalah sistem manajemen antrean untuk restoran yang memungkinkan tamu mendapatkan nomor antrian secara mandiri maupun melalui bantuan waiter. Fitur ini dirancang untuk mengurangi antrean fisik di pintu masuk, meningkatkan pengalaman tamu selama menunggu, dan memberi fleksibilitas operasional kepada staf restoran.

Terdapat tiga skenario utama:
1. Tamu mandiri via scan barcode (self-service)
2. Tamu dibantu waiter, nomor antrian tampil di monitor
3. Tamu dibantu waiter, mendapat struk fisik dengan QR Code untuk memantau antrian real-time (Walk-In & Smart Queuing)

---

## 2. Problem Statement

Restoran dengan antrean tinggi menghadapi masalah:
- Tamu harus berdiri mengantri di depan restoran → pengalaman buruk
- Staf harus mengelola antrian secara manual → tidak efisien
- Tidak ada cara bagi tamu untuk mengetahui estimasi waktu tunggu secara real-time

Fitur Waiting List hadir sebagai solusi digital untuk permasalahan di atas.

---

## 3. Goals & Success Metrics

### Goals
| # | Goal |
|---|------|
| G1 | Tamu dapat mendaftar antrian tanpa harus berbicara langsung ke staf (Case 1) |
| G2 | Waiter dapat mendaftarkan antrian untuk tamu yang tidak familiar teknologi (Case 2) |
| G3 | Tamu dapat melihat status antrian real-time via ponsel atau monitor restoran |
| G4 | Tamu dapat memantau posisi antrian secara real-time via QR Code di struk fisik (Case 3) |
| G5 | Proses antrian terintegrasi dengan sistem POS restoran |

---

## 4. Scope Fitur

### Out of Scope (saat ini)
- Integrasi dengan platform reservasi pihak ketiga (mis. GoFood, GrabFood)
- Notifikasi push/SMS ke tamu
- Fitur pembayaran dari antrean
- Loyalty program atau gamifikasi antrean

---

## 5. Use Cases

| Kode  | Nama                       | Deskripsi Singkat                                         | File Detail                 |
| ----- | -------------------------- | --------------------------------------------------------- | --------------------------- |
| UC-01 | Self-Service QR Scan       | Tamu scan barcode, input data, terima nomor antrian di HP | [[WL_Case1_SelfScan]]       |
| UC-02 | Waiter-Assisted Monitor    | Waiter input data tamu, nomor antrian tampil di monitor   | [[WL_Case2_WaiterMonitor]]  |
| UC-03 | Walk-In & Smart Queuing    | Waiter input data tamu, sistem cetak struk dengan nomor antrian dan QR Code untuk live tracking | [[WL_Case3_WalkInSmartQueue]] |

---

## 6. Constraints & Assumptions

### Constraints
- Sistem harus dapat diakses dari perangkat mobile tamu tanpa instalasi aplikasi
- QR/barcode harus dapat di-scan menggunakan kamera standar smartphone
- Tampilan monitor restoran berjalan di layar yang sudah tersedia di restoran
- Sistem harus tetap berfungsi jika koneksi internet tamu lambat (toleransi latensi)

### Assumptions
- Setiap tamu yang ingin menggunakan live tracking memiliki smartphone dengan kemampuan scan QR (Case 1 & 3)
- Monitor restoran sudah tersedia dan terhubung ke sistem (Case 2)
- Waiter memiliki akses ke perangkat (tablet/POS terminal) untuk input data
- Satu sesi antrian = satu kelompok tamu (bukan per individu)
- Nomor antrian bersifat unik per hari operasional restoran

---

## 7. Dokumen Terkait

- [[WL_Case1_SelfScan]] — Use Case 1: Self-Service QR Scan
- [[WL_Case2_WaiterMonitor]] — Use Case 2: Waiter-Assisted Monitor
- [[WL_Case3_WalkInSmartQueue]] — Use Case 3: Walk-In & Smart Queuing System
- [[WL_Requirements]] — Functional & Non-Functional Requirements
- [[WL_UserStories]] — User Stories
- [[WL_UISpec]] — UI/UX Specification

---

*Dokumen ini dibuat secara otomatis oleh PRD Agent pada 2026-05-18. Diperbarui oleh Doc Orchestrator pada 2026-05-20: UC-03 diganti dari Waiter Pre-Order menjadi Walk-In & Smart Queuing System.*
