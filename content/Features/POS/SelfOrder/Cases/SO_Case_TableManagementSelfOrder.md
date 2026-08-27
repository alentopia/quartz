# Self Order — Inkonsistensi: Table Management Saat Dipakai Self Order

**Status:** Draft
**Tanggal:** 2026-08-06
**Fitur:** Self Order — sisi **Table Management** di aplikasi Accurate POS (APOS). Bagaimana kartu meja dan Detail Meja bereaksi terhadap pesanan yang masuk lewat Self Order.
**Prefix ID kasus:** `SO-TM`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · PM (keputusan produk)
**Referensi:** [[SO_PRD_MVP]], [[SO_Case_QRManagementNegative]], [[SO_Case_JourneyMVP]] (sumber order REF-398125 di SO-TM-2 ada di Journey Bayar di Kasir)
**Format dokumen ini mengikuti:** [[Riset_Workflow_Handoff_UIUX_QA_DEV]]
**Desain:** [Buka canvas MVP — Close Bill · QR Statis · Table Management di Figma](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2), section **Case : Kondisi Table Management Jika Menggunakan Self Order**.

---

## Cara membaca dokumen ini

Beda dari case doc lain di folder ini: dokumen ini **bukan spec yang sudah disetujui PM** — isinya temuan hasil menelusuri tiap panah di satu flow yang sama, satu per satu, sampai ke frame tujuannya. Section ini belum punya frame catatan spec sama sekali — satu-satunya "catatan" yang ada cuma placeholder isi mock ("Ini catatan ini catatan...", "Catatan Penjualan") yang memang bagian dari tampilan komponen, bukan penjelasan buat pembaca.

Struktur 5 bagian yang sama dipakai di sini, dengan satu penyesuaian: karena belum ada keputusan PM, kolom **Hasil yang Diharapkan** berisi **perilaku yang paling konsisten dengan bagian lain di flow yang sama** — bukan keputusan final.

### Daftar kasus

| ID | Judul singkat | Status desain |
|---|---|---|
| [[#SO-TM-1 — Judul Detail Meja berubah sesuai tab yang dibuka, bukan status bayar sebenarnya\|SO-TM-1]] | Judul modal ikut tab, bukan status bayar | ada, tapi kontradiksi |
| [[#SO-TM-2 — Total item di tab Self Order tidak cocok dengan rincian barisnya\|SO-TM-2]] | Angka nggak nyambung | ada, salah hitung |

## Latar belakang

Section **Case : Kondisi Table Management Jika Menggunakan Self Order** menggambar satu siklus meja Self Order, dari tamu bayar sampai meja siap dipakai tamu berikutnya. Alur di bawah sudah diverifikasi dengan menelusuri tiap panah connector di canvas satu per satu (bukan menebak dari posisi frame) — supaya jelas frame mana yang benar-benar menyambung ke frame mana:

1. Tamu bayar lewat **Cash Status** (bayar di kasir) atau **Processing QRIS** → kartu meja tampil **"Terisi"** (merah), menunggu pembayaran.
2. Pembayaran lunas → layar tamu pindah ke **Success** ("Pembayaran berhasil") → kartu meja berubah jadi **"Dibayar"** (oranye). *Transisi ini sudah benar di canvas.*
3. Staf tap kartu meja → **Detail Meja** terbuka, tab **Informasi Pesanan** (kosong — "Tidak ada pesanan"), badge tab **Self Order** menunjukkan "2".
4. Staf pindah ke tab **Self Order** pada modal yang sama → tampil riwayat **REF-398125S** (QRIS): Nasi Ayam Bakar Madu + Ayam Goreng Kremes.
5. Dari situ staf punya dua pilihan tombol:
   - **Bersihkan Meja** → kartu meja kembali **"Tersedia"** (kosong). Siklus selesai, ini normal.
   - **Pesan Lagi** → kartu meja kembali **"Terisi"** (merah); jumlah tamu tetap **"-"** karena origin mejanya Self Order (tidak pernah ada input jumlah tamu). Ini juga normal.
6. Kalau staf pilih **Pesan Lagi**: staf tap kartu meja lagi → **Detail Meja** terbuka lagi, tab **Informasi Pesanan** kali ini menampilkan pesanan baru yang staf input manual lewat POS (contoh: "Philips Lampu Smart WiFi LED 9W", Rp675.000, belum lunas) — judul modal di tab ini benar: **"Detail Meja Terisi"**.
7. Staf pindah ke tab **Self Order** — masih di modal yang **sama**, meja yang **sama**, tagihan Rp675.000 yang **sama** — tapi judul modal berubah jadi **"Detail Meja Dibayar"**. Ini yang jadi **SO-TM-1**.

Satu temuan lain (**SO-TM-2**) berdiri sendiri, ditemukan dari mengecek angka di dalam frame langkah 4 — tidak tergantung penelusuran panah.

---

## SO-TM-1 — Judul Detail Meja berubah sesuai tab yang dibuka, bukan status bayar sebenarnya

**Frame Figma:** [Detail Meja — tab Informasi Pesanan (judul "Terisi")](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2977-72302) · [Detail Meja — tab Self Order (judul "Dibayar")](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2977-73463) — **satu sesi modal yang sama**, dua tab

**Prasyarat**

- Meja **AA - 01** sudah lunas satu siklus Self Order (Gellato via QRIS Rp100.000 + Ayam Geprek via Bayar di Kasir Rp30.000), lalu staf menekan **"Pesan Lagi"**.
- Staf menambahkan pesanan baru langsung dari POS (bukan lewat Self Order) — di frame ini "Philips Lampu Smart WiFi LED 9W" seharga Rp675.000, **belum dibayar**.
- Modal **Detail Meja** untuk AA - 01 sedang terbuka.

**Langkah reproduksi**

1. Buka **Detail Meja** untuk AA - 01 (kondisi di atas).
2. Perhatikan judul modal saat tab **Informasi Pesanan** aktif.
3. Tanpa menutup modal atau mengubah data apa pun, pindah ke tab **Self Order**.
4. Perhatikan lagi judul modal.

**Hasil yang Diharapkan**

- Judul modal mencerminkan **status bayar meja secara keseluruhan**, bukan tab mana yang sedang dibuka. Selama masih ada tagihan aktif (di sini: Rp675.000 dari pesanan lampu), judulnya harus tetap **"Detail Meja Terisi"** di kedua tab.
- Tombol bawah tetap **"Bayar Rp[jumlah]"** selama ada tagihan aktif — ini sudah benar di kedua tab, tinggal judulnya yang perlu disamakan.

**Hasil aktual (2026-08-06)**

**Kontradiksi dalam satu sesi modal yang sama.** Tab **Informasi Pesanan** menampilkan judul **"Detail Meja Terisi"** (benar — masih ada tagihan Rp675.000). Pindah ke tab **Self Order** tanpa aksi apa pun lain, judul berubah jadi **"Detail Meja Dibayar"** — padahal tagihan Rp675.000 dan tombol "Bayar"-nya masih persis sama. Judul tampaknya di-bind ke riwayat pembayaran **tab Self Order saja** (yang memang sudah lunas), bukan ke status bayar meja secara keseluruhan. **Perlu diperbaiki di UI/UX**: judul harus satu sumber kebenaran untuk seluruh modal, tidak berubah karena pindah tab.

---

## SO-TM-2 — Total item di tab Self Order tidak cocok dengan rincian barisnya

**Frame Figma:** [Detail Meja — Tab Self Order (riwayat REF-398125S)](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2975-68925) · sumber order: [Pesanan Baru — Detail Pesanan](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1841-20485) di **Case: Journey Close Bill · Bayar di Kasir**

**Prasyarat**

- Meja AA - 01, tab **Self Order** terbuka, ada 1 REF (REF-398125S, QRIS) dengan 2 baris item: **Nasi Ayam Bakar Madu** + **Ayam Goreng Kremes**.
- REF yang sama (REF-398125, item sama persis, meja nomor 5) juga muncul di **Case: Journey Close Bill · Bayar di Kasir**, pada layar kasir **"Pesanan Baru" → Detail Pesanan** — inilah sumber order-nya sebelum masuk ke Table Management.

**Langkah reproduksi**

1. Buka Detail Meja AA - 01 → tab **Self Order**.
2. Baca header REF-398125S: jumlah item dan total harga.
3. Bandingkan dengan **Detail Pesanan** di layar kasir "Pesanan Baru" (sumber order yang sama): Subtotal Pesanan Rp86.000, Diskon/Promo -Rp38.000, **GRAND TOTAL Rp53.000**.

**Hasil yang Diharapkan**

- Total di header REF harus sama dengan **Grand Total order aslinya** dari layar kasir "Pesanan Baru" — **Rp53.000**.

**Hasil aktual (2026-08-06)**

Header REF-398125S di Table Management menulis **"2 item · Rp100.000"** — tidak cocok dengan Grand Total order aslinya (**Rp53.000**, dari layar kasir "Pesanan Baru"), dan juga tidak cocok dengan jumlah baris item yang tampil di situ (**Rp48.000**: Nasi Ayam Bakar Madu Rp48.000 + Ayam Goreng Kremes didiskon jadi Rp0). Kemungkinan besar **Rp100.000 ke-copy dari contoh REF lain** (ada frame terpisah yang memang benar pakai Rp100.000, tapi itu untuk pesanan 1 item Gellato — beda item, beda order). **Perlu diperbaiki**: ganti header jadi Rp53.000 sesuai Grand Total aslinya.

Catatan tambahan: Grand Total Rp53.000 di layar kasir sendiri juga tidak pas-pas amat secara aritmatika (Rp86.000 − Rp38.000 = Rp48.000, bukan Rp53.000, selisih Rp5.000 belum jelas dari mana — kemungkinan ada baris pajak/layanan yang tidak tergambar). Selisih Rp5.000 ini di luar cakupan SO-TM-2, dicatat di Pertanyaan Terbuka no. 3.

---

## Pertanyaan terbuka

| No | Pertanyaan | Menunggu | Terkait |
|---|---|---|---|
| 1 | Judul modal (TM-1) sebaiknya ikut aturan apa persis — selalu "Terisi" kalau ADA tagihan aktif di tab mana pun, terlepas dari tab yang sedang dibuka? Atau ada logika lain yang belum kelihatan dari gambar? | keputusan UI/UX | SO-TM-1 |
| 2 | Header REF-398125S (TM-2) — ganti jadi Rp53.000 (Grand Total order aslinya), atau ada alasan lain kenapa ditulis Rp100.000? | keputusan UI/UX | SO-TM-2 |
| 3 | Grand Total Rp53.000 di layar kasir "Pesanan Baru" sendiri tidak pas sama Subtotal (Rp86.000) dikurangi Diskon (Rp38.000) = Rp48.000 — selisih Rp5.000 dari mana? Ada baris pajak/layanan yang belum digambar? | keputusan UI/UX + DEV | SO-TM-2 |

## Lampiran A — Kamus layar

| Nama layar | Isinya | Cara membuka |
|---|---|---|
| **Meja → tab Seated** | Grid kartu meja per area, tiap kartu punya label status (Tersedia/Terisi/Dibayar), jumlah kursi, dan jumlah tamu. | Menu POS → Meja → tab Seated |
| **Detail Meja** | Modal yang terbuka saat kartu meja ditekan. 3 tab: Informasi Pesanan (order manual dari POS), Self Order (pesanan lewat QR), Daftar Reservasi. | tekan kartu meja mana pun |
| **Cash Status — CashStatusScreen** | Layar pelanggan menunggu konfirmasi pembayaran tunai/kartu di kasir. | otomatis setelah pelanggan pilih "Bayar di Kasir" |
| **Processing QRIS — ProcessingScreen** | Layar pelanggan menunggu pembayaran QRIS (QR + countdown). | otomatis setelah pelanggan pilih QRIS |
| **Success — SuccessScreen** | Layar "Pembayaran berhasil" di sisi pelanggan. | otomatis setelah pembayaran lunas |

## Lampiran B — Peta node Figma

Hanya untuk desainer dan DEV yang perlu membuka frame aslinya. File: `mAZuRze02w906M6u2EwVWh`, canvas `1223:2`.

| Nama section / frame | Node | Terkait |
|---|---|---|
| Case : Kondisi Table Management Jika Menggunakan Self Order (section) | [`2870:68155`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2870-68155) | semua |
| Seated — menunggu pembayaran (Cash Status/Processing QRIS) | [`2874:68302`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2874-68302) | alur |
| Seated — abis Success, sudah "Dibayar" (benar) | [`2967:27738`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2967-27738) | alur |
| Detail Meja Dibayar — tab Informasi Pesanan (kosong) | [`2885:27336`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2885-27336) | alur |
| Detail Meja Dibayar — tab Self Order (riwayat, header Rp100.000 salah) | [`2975:68925`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2975-68925) | SO-TM-2 |
| Pesanan Baru — Detail Pesanan (sumber order REF-398125, Grand Total Rp53.000) | [`1841:20485`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1841-20485) | SO-TM-2 |
| Seated — abis "Bersihkan Meja" (Tersedia, normal) | [`2981:33665`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2981-33665) | alur |
| Seated — abis "Pesan Lagi" (Terisi, tamu "-", normal) | [`2977:71433`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2977-71433) | alur |
| Detail Meja — tab Informasi Pesanan, judul "Terisi" (lampu, belum lunas) | [`2977:72302`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2977-72302) | SO-TM-1 |
| Detail Meja — tab Self Order, judul "Dibayar" (sesi & tagihan sama persis) | [`2977:73463`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2977-73463) | SO-TM-1 |
| Catatan analisis (ditempel 2026-08-06) | [`3067:34796`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3067-34796) | semua |
