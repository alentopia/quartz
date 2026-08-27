# Self Order — Case: Nomor Ref di Layar QRIS

**Status:** Review (desain disetujui, belum diimplementasi di Figma)
**Tanggal:** 2026-07-31
**Fitur:** Self Order
**Prefix:** SO
**Referensi:** [[SO_PRD_MVP]], [[SO_Case_QRManagementNegative]] (pola ref-card di `CashStatusScreen`)
**File Figma:** `mAZuRze02w906M6u2EwVWh`, node `1223:1655` ("Processing QRIS — ProcessingScreen"), sheet PAGE-09 varian QRIS

---

## Latar belakang

`CashStatusScreen` (Bayar di Kasir) punya kartu `ref-card` yang nampilin nomor referensi pesanan besar ("REF-398125") dengan instruksi "Tunjukkan kode ini ke kasir" — dipakai tamu buat verifikasi manual ke kasir. `ProcessingScreen` (QRIS) sama sekali gak nampilin nomor referensi ini ke tamu, padahal field referensi pesanan yang sama tetap ada di data (`Order.referensi` — lihat `SO_PRD_MVP §9 Data Model`).

Gap ini nongol pas PM mau supaya pesanan QRIS juga gampang dikenali/disebut di daftar pesanan POS, sama kayak pesanan Bayar di Kasir.

## Keputusan produk (dikonfirmasi user via brainstorming)

| Topik | Keputusan |
|---|---|
| Tujuan tampilan | Murni **identifier di daftar pesanan POS** — bukan instruksi aksi ke tamu. Beda dari `ref-card` Kasir yang punya aksi "tunjukkan ke kasir" buat verifikasi manual pembayaran. |
| Format nomor | **Sama** dengan Kasir — `REF-` + 6 digit angka random. Field referensi yang sudah ada di `Order`, cuma di-expose juga di UI QRIS. Tidak ada field/mekanisme baru. |
| Pembeda metode bayar di POS | **Sudah ada di sisi POS** (badge/kolom metode bayar terpisah dari nomor ref) — di luar scope desain Figma ini. |
| Placement di layar | **Footnote di bagian bawah `qr-card`**, setelah tombol "Download QR" — dipilih lewat 2 ronde mockup (lihat di bawah), supaya gak motong ritme status → timer → aksi yang udah ada. |
| Visual weight | **Kalem** — teks kecil, warna muted, tanpa background card. Sengaja beda dari `ref-card` Kasir (32px bold, warna aksen `primary`) karena di sini tamu gak perlu ngapa-ngapain soal nomor ini. |
| Reuse `ref-card` | **Tidak** dipakai apa adanya. Copy "Tunjukkan kode ini ke kasir" gak relevan di alur QRIS yang mandiri lewat e-wallet — kalau dipaksa reuse component itu, copy-nya nyasar. |

## Proses eksplorasi (ringkas)

1. **Opsi kasar (3):** baris kecil di bawah status, card kecil terpisah (echo `ref-card` diperkecil), atau nempel di topbar. Topbar (C) ditolak — kasih bobot visual berlebih buat info yang tamu gak perlu tindaklanjuti, dan geser dari konvensi `TopBar` (judul + back doang).
2. **Slot persis di dalam `qr-card`** (setelah opsi kasar mengerucut ke "dalam kartu, kalem"): dicoba 3 titik — setelah status (sebelum timer), antara timer & tombol download, atau paling bawah kartu setelah tombol download. **Dipilih: paling bawah**, karena gak motong ritme dua elemen aksi (timer countdown, tombol download) yang tamu benar-benar perlu perhatikan.

## Prinsip yang bikin desain ini gak "kelewatan"

- **Reuse data, bukan reinvent.** `Order.referensi` udah ada di data model — ini murni nambah exposure di satu layar lagi, bukan field/API baru.
- **Gak reuse component secara buta.** `ref-card` cocok buat Kasir (ada aksi tamu), tapi maksa dipakai di QRIS bikin copy-nya nyasar. Elemen baru di sini cukup 1 baris teks, bukan component baru.
- **Visual weight ikutin kebutuhan aksi tamu, bukan disamain asal konsisten.** Kasir = besar+bold+aksen (ada instruksi aksi). QRIS = kecil+muted+tanpa card (murni informasi pasif).

## Desain elemen

### A. Teks baru di `qr-card` (node `1223:1658`)

Ditambah 1 text node baru sebagai child terakhir di frame `qr-card`, setelah `btn-download` (`1223:1669`):

| Properti | Nilai |
|---|---|
| Isi | `No. Ref REF-398125` (satu baris, angka mengikuti `Order.referensi` pesanan berjalan) |
| Ukuran | ~11–12px |
| Warna | Token muted (senada `text-muted` yang dipakai di timestamp `ref-card`, bukan token `primary`) |
| Align | Center, mengikuti kartu |
| Spacing | margin-top ~10px dari tombol "Download QR" |
| Background | Tidak ada — teks polos, bukan card/badge |

### B. Sumber data

Nomor sama persis dengan yang dipakai `ref-card` Kasir (`Order.referensi`, format `REF-XXXXXX`) — tidak ada field baru, tidak ada mekanisme generate baru. QRIS cuma menampilkan field yang sudah ada.

### C. Frame yang perlu diupdate di Figma

Update node "Processing QRIS — ProcessingScreen" (`1223:1655`) — tambah teks ref di dalam `qr-card`, posisi paling bawah (setelah tombol Download QR).

## Yang di luar scope (sengaja gak dikerjain)

- **Pembeda metode bayar (badge/kolom) di daftar pesanan POS** — sudah ada di sisi POS, bukan bagian desain Figma Self Order ini.
- **Verifikasi manual pembayaran pakai nomor ref ini** — QRIS tetap auto-lunas lewat polling gateway (lihat `SO_PRD_MVP §7A`); nomor ref di sini murni identifier, bukan alat verifikasi.
- **Perubahan `ref-card` di `CashStatusScreen`** — tetap sama persis, tidak disentuh.
- **Component/variant baru** — cukup 1 text node, tidak menambah component set baru ke Komponen Primitif/Komposit.

## Acceptance Criteria

- **AC-1** — Given tamu di `ProcessingScreen` QRIS, When layar tampil, Then ada baris kecil "No. Ref REF-XXXXXX" di bagian bawah `qr-card`, setelah tombol "Download QR".
- **AC-2** — Given AC-1, Then teks TIDAK mengandung instruksi aksi (mis. "tunjukkan ke kasir") — murni informasi ref, konsisten dengan sifat QRIS yang mandiri.
- **AC-3** — Given nomor referensi yang sama tercatat di POS, When staff buka daftar pesanan, Then nomor ref yang tampil ke tamu di QRIS match dengan yang muncul di POS untuk pesanan tsb.
