# WL_Case2_WaiterMonitor — Waiter-Assisted dengan Monitor Restoran

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

## 1.  Alternative Flows

### AF-01: Tamu datang ramai bersamaan
- Waiter mendaftarkan satu per satu rombongan secara berurutan
- Sistem mengantri secara FIFO (first in, first out) sesuai urutan input

### AF-02: Tamu tidak bisa/mau memberikan nama
- Waiter dapat menggunakan nama generik / nomor sementara (mis. "Tamu 1")
- *(Business rule untuk nama anonim — TBD: OQ-04)*

### AF-03: Perangkat waiter offline / error
- Waiter melaporkan ke supervisor
- Sementara menggunakan metode manual
- Sistem akan sync ulang saat koneksi pulih

### AF-04: Tamu tidak ada saat nomor mereka dipanggil
- Sistem / waiter memanggil ulang (maksimum TBD kali)
- Jika tidak hadir setelah batas waktu: nomor antrian dinonaktifkan
- *(Business rule timeout antrian — TBD: OQ-04)*

---

## 2 . Exception Flows

### EX-01: Monitor restoran mati / tidak menampilkan antrian
- Waiter memberitahu tamu bahwa monitor sedang gangguan
- Waiter menyampaikan nomor antrian secara lisan
- Tim teknis dihubungi untuk perbaikan monitor

### EX-02: Sistem backend tidak merespons saat waiter mendaftarkan
- Perangkat waiter menampilkan pesan error
- Waiter mencoba kembali
- Jika gagal terus: waiter mencatat manual dan daftarkan ulang saat sistem pulih

---

## 3 . Business Rules

| Kode | Aturan | Status |
|------|--------|--------|
| BR-07 | Hanya waiter (akun staf terautentikasi) yang dapat mendaftarkan tamu di Case 2 | Confirmed |
| BR-08 | Nomor antrian yang sama dengan Case 1 & 3 (pool antrian bersatu) | Confirmed |
| BR-09 | Urutan antrian: FIFO berdasarkan waktu registrasi | Confirmed |
| BR-10 | Nama tamu wajib diisi (boleh nama generik) | Confirmed |
| BR-11 | Jumlah orang wajib dipilih | Confirmed |
| BR-12 | Maksimum pemanggilan ulang tamu yang tidak hadir | TBD: OQ-04 |
| BR-13 | Waktu kedaluwarsa antrian jika tidak hadir | TBD: OQ-04 |

---

## 4. Data & Field

### Input Form (Perangkat Waiter)
| Field | Tipe | Wajib | Validasi |
|-------|------|-------|----------|
| Nama Tamu | Text | Ya | Min 2 karakter, max 50 karakter |
| Jumlah Orang | Number/Selector | Ya | Min 1, max TBD |
| Catatan Khusus | Text | Tidak | Opsional, max 100 karakter |

### Tampilan Monitor Restoran
| Elemen                      | Keterangan                                        |
| --------------------------- | ------------------------------------------------- |
| Daftar nomor antrian aktif  | Nomor yang sedang menunggu dan sudah dipanggil    |
| Nomor yang sedang dipanggil | Highlight/sorot nomor antrian yang sedang giliran |
| Estimasi waktu tunggu       | Per posisi antrian                                |
| Klasifikasi Antrian         | 1-2 orang, 3-4 orang (kategori orang)             |

---

## 5. UI Reference

Lihat: [[WL_UISpec#Case2_WaiterMonitor]]

Screen yang diperlukan:
- SC-C2-01: Tampilan Modul Antrian di Perangkat Waiter (form input)
- SC-C2-02: Konfirmasi Registrasi di Perangkat Waiter
- SC-C2-03: Tampilan Monitor Publik Restoran (mode display)

---

*Dibuat oleh Doc Agent pada 2026-05-18. Dependensi: [[WL_Overview]] sudah tersedia.*
