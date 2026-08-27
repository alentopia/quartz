		# KDS_Overview — KDS Lite (Antrean Pickup)

> [!warning] Arsip — KDS Lite tidak jadi dipakai
> Diputuskan 2026-08-14: merchant pakai **KDS penuh** (Figma `Kitchen Display Sistem (KDS)`, file `8Uf9bMrBiCf8sQjkX5sUMl`), bukan KDS Lite. Dokumen ini dan seisi folder `KDSLite_Archived/` disimpan sebagai referensi historis, bukan spec aktif. Spec KDS penuh menyusul di `Features/KDS/`.

**Status:** Draft (Archived)
**Versi:** 0.1
**Tanggal:** 2026-07-15
**Author:** PM & Claude Code (`superpowers:brainstorming`)

---

## Daftar Isi

- [[KDS_Overview#1. Executive Summary|1. Executive Summary]]
- [[KDS_Overview#2. Problem Statement|2. Problem Statement]]
- [[KDS_Overview#3. Goals|3. Goals]]
- [[KDS_Overview#4. Scope Fitur|4. Scope Fitur]]
- [[KDS_Overview#5. Aktor & Aktivasi|5. Aktor & Aktivasi]]
- [[KDS_Overview#6. State Machine|6. State Machine]]
- [[KDS_Overview#7. Identifier Order|7. Identifier Order]]
- [[KDS_Overview#8. Layar KDS Lite (Staff App)|8. Layar KDS Lite (Staff App)]]
- [[KDS_Overview#9. Layar Monitor Antrian (TV Pelanggan)|9. Layar Monitor Antrian (TV Pelanggan)]]
- [[KDS_Overview#10. Business Rules|10. Business Rules]]
- [[KDS_Overview#11. Constraints & Assumptions|11. Constraints & Assumptions]]
- [[KDS_Overview#12. Open Questions (TBD)|12. Open Questions (TBD)]]
- [[KDS_Overview#13. Dokumen Terkait|13. Dokumen Terkait]]

---

## 1. Executive Summary

**KDS Lite** adalah aplikasi standalone untuk mengelola antrean pickup order (nomor antrian atau nomor meja) — ditujukan untuk merchant Accurate POS yang **tidak memakai KDS (Kitchen Display System) penuh**. Berbeda dari KDS penuh yang melacak progres masak per-item/per-station, KDS Lite hanya melacak status pickup di level order: **sedang disiapkan → siap diambil → selesai**.

Aplikasi ini dipasangkan dengan layar **Monitor Antrian** (TV publik) yang dilihat customer sambil menunggu.

## 2. Problem Statement

- Merchant tanpa KDS penuh tidak punya cara digital buat ngasih tau customer kapan pesanan pickup-nya siap — masih andalan panggilan manual/teriak.
- Staff butuh cara sederhana buat nandain order siap diambil, tanpa kerumitan tracking per-item ala KDS penuh yang gak relevan buat resto kecil/kios.
- Perlu recovery cepat kalau staff salah tap (tap nomor yang salah pas dapur/counter lagi sibuk).

## 3. Goals

| # | Goal |
|---|------|
| G1 | Staff bisa tandai order siap diambil dengan 1 tap, tanpa perlu setup KDS penuh |
| G2 | Customer bisa liat status antreannya lewat Monitor Antrian tanpa nunggu dipanggil manual |
| G3 | Staff bisa koreksi salah tap tanpa kehilangan data order |
| G4 | Alur jalan konsisten dari order channel manapun (POS Kasir, Self Order, Kiosk) |
| G5 | Tampilan jalan di device apapun yang staff pakai — HP, tablet, atau desktop |

## 4. Scope Fitur

### In Scope
- Layar KDS Lite (staff app): daftar order aktif, aksi Tandai Siap / Undo / Selesai.
- Layar Monitor Antrian (TV pelanggan): reuse pola desain existing (foto/banner + kolom On Progress & Ready to Pick Up), disambungkan ke data KDS Lite.
- Logic identifier order (nomor antrian vs nomor meja).
- Layout responsif (desktop/tablet 2 kolom, HP 1 kolom + tab).

### Out of Scope (v1)
- Tracking progres masak per-item/per-station (itu domain KDS penuh — app "Display Makanan" yang sudah ada, produk terpisah).
- Kapasitas maksimum antrean / pagination.
- Eskalasi visual (warna berubah) kalau order kelamaan di status Diproses.
- Integrasi speaker/announcement fisik saat Undo atau order baru masuk.
- Timer/elapsed time di kartu order (dipertimbangkan lagi di versi berikutnya).
- Setting aktivasi KDS Lite vs KDS penuh vs tanpa KDS di AOL — dianggap sudah tersedia sebagai precondition, bukan bagian scope UI ini (pola sama seperti `SO_PRD.md` §Out of Scope).

## 5. Aktor & Aktivasi

- **Aktor:** Staff resto (kasir/counter pickup) — pengguna utama KDS Lite. Customer — pengguna pasif Monitor Antrian.
- **Aktivasi:** Merchant memilih mode KDS (KDS Lite / KDS penuh / tanpa KDS) di **AOL**, sama seperti pola setting Self Order lain. Detail form setting ini di luar scope dokumen ini.
- **Sumber order:** Semua channel — POS Kasir, Self Order, Kiosk. Order masuk ke antrean otomatis begitu dikonfirmasi/dibayar, langsung berstatus **Diproses** (tidak ada step "Mulai" manual — beda dari KDS penuh).

## 6. State Machine

```
[order masuk] → DIPROSES → (tap "Tandai Siap") → SIAP → (tap "Selesai") → hilang dari sistem
                              ↑                      │
                              └──────── (tap "Undo") ─┘
```

| Status | Tombol Tersedia | Efek |
|---|---|---|
| Diproses | **Tandai Siap** | Pindah ke Siap; muncul di kolom "Ready to Pick Up" Monitor Antrian |
| Siap | **Undo** | Balik ke Diproses (koreksi salah tap); hilang dari "Ready to Pick Up", muncul lagi di "On Progress" |
| Siap | **Selesai** | Order dihapus dari KDS Lite **dan** Monitor Antrian (customer sudah ambil) |

Urutan dalam tiap kolom: FIFO — order yang paling lama menunggu berada di posisi paling atas/kiri.

## 7. Identifier Order

| Kondisi | Identifier yang Ditampilkan |
|---|---|
| Dine In **+** merchant pakai Table Management | Nomor Meja |
| Dine In, merchant **tidak** pakai Table Management | Nomor Antrian |
| Takeaway (selalu, terlepas dari setting Table Management) | Nomor Antrian |

Setiap kartu juga menampilkan badge channel asal order (POS Kasir / Self Order / Kiosk).


## 9. Layar Monitor Antrian (TV Pelanggan)

Reuse pola desain existing yang sudah dibuat PM di Figma (`Flow Kasir`, section "Flow Display Monitor", frame `Monitor Antrian`): foto/banner ambience di kiri, kolom **"Ready to Pick Up"** dan **"On Progress"** di kanan.

Delta untuk KDS Lite:
- Sumber data kolom = status order dari KDS Lite (bukan dari KDS penuh "Display Makanan").
- Identifier yang ditampilkan ikut logic §7 (nomor antrian atau nomor meja).
- Tap **Tandai Siap** / **Undo** di KDS Lite langsung reflect real-time ke Monitor Antrian (order berpindah kolom On Progress ⇄ Ready to Pick Up).
- Tap **Selesai** menghapus order dari Monitor Antrian juga.

## 10. Business Rules

| Kode | Aturan | Status |
|---|---|---|
| BR-01 | Order baru selalu masuk berstatus Diproses, tanpa step "Mulai" manual | Confirmed |
| BR-02 | Identifier order mengikuti logic Table Management merchant (§7) | Confirmed |
| BR-03 | Undo dari status Siap mengembalikan order ke Diproses tanpa kehilangan data | Confirmed |
| BR-04 | Selesai menghapus order dari KDS Lite dan Monitor Antrian sekaligus | Confirmed |
| BR-05 | Urutan tiap kolom FIFO berdasarkan waktu order masuk/berubah status | Confirmed |
| BR-06 | Semua channel order (POS Kasir, Self Order, Kiosk) masuk ke antrean yang sama | Confirmed |

## 11. Constraints & Assumptions

### Constraints
- Layout harus tetap fungsional di lebar layar HP hingga desktop (responsif).
- Perubahan status harus sinkron real-time antara KDS Lite dan Monitor Antrian tanpa staff perlu refresh manual.

### Assumptions
- Merchant sudah menentukan mode KDS (Lite/penuh/tanpa) sebelum app ini dipakai — precondition dari AOL.
- Setting Table Management merchant (on/off) sudah tersedia dari APOS, KDS Lite hanya membaca settingnya.
- Satu order = satu kartu, terlepas dari berapa banyak item di dalamnya.

## 12. Open Questions (TBD)

| Kode | Pertanyaan | Owner |
|---|---|---|
| OQ-01 | Format nomor antrian (jumlah digit, reset harian atau per shift?) | PM |
| OQ-02 | Perlu auth/login di app KDS Lite, atau bebas akses di device resto? | PM + Engineering |
| OQ-03 | Timer/elapsed time — jadi kapan ditambahkan lagi (v1 sengaja tanpa timer)? | PM |
| OQ-04 | Real-time sync pakai polling atau WebSocket? | Engineering |
| OQ-05 | Target platform teknis — native per-OS atau satu codebase web responsif? | Engineering |

## 13. Dokumen Terkait

- [[WL_Overview]] — Waiting List (konsep antrean terkait, beda kasus: seating/masuk, bukan pickup order).
- [[SO_PRD]] — Self Order, salah satu sumber channel order KDS Lite.
- Referensi desain existing (produk terpisah, bukan bagian KDS Lite): Figma `Flow Kasir` (`hl2CORgtDUUUo7A1Gj86mz`) — frame `Kitchen Display - Pesanan Masuk` ("Display Makanan", KDS penuh) dan frame `Monitor Antrian` (pola TV yang di-reuse di §9).

---

*Dokumen ini dibuat lewat sesi `superpowers:brainstorming` bersama PM pada 2026-07-15.*
