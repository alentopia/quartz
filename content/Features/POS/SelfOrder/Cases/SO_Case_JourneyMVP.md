# Self Order — Case: Journey MVP end-to-end (QR Statis)

**Status:** Draft
**Tanggal:** 2026-07-30
**Fitur:** Self Order MVP — aplikasi pelanggan (QR Statis) dari scan sampai struk, plus sisi POS untuk metode Bayar di Kasir.
**Prefix ID kasus:** `SO-JRN`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · PM (keputusan produk)
**Baseline:** [[SO_PRD_MVP|SO_PRD_MVP.md v1.2]] — **satu-satunya acuan perilaku**. AC di dokumen ini tidak ditulis ulang, hanya dirujuk ID-nya.
**Skenario terkait:** [[SO_TestScenario_MVP]] (tabel skenario per AC) · [[SO_Case_ValidasiKeranjangRedesign]] · [[SO_Case_HapusEditItemKeranjang]] · [[SO_Case_BagikanStrukNegative]] · [[SO_Case_ToastSuksesBagikanStruk]] · [[SO_Case_LoginOpsionalKonfirmasiMember]]
**Format dokumen ini mengikuti:** [[Template_Case_Negative]] — alasannya di [[Riset_Workflow_Handoff_UIUX_QA_DEV]]
**Desain:** canvas MVP — [Journey Close Bill · QRIS](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1395) dan [Journey Close Bill · Bayar di Kasir](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2174)

---

## Cara membaca dokumen ini

Dokumen ini **tidak membuat AC baru**. AC-nya sudah ada di [[SO_PRD_MVP]] (`AC-01.x`, `AC-04.x`, `AC-05.x`, `AC-06.x`, `AC-06V.x`, `AC-07.x`, `AC-NC.x`, `AC-08.x`, `AC-09.x`, `AC-11.x`, `AC-NET.x`). Yang ditambahkan di sini: **cara membuktikannya** — Prasyarat / Langkah / Expected yang bisa langsung dieksekusi QA, dengan link ke frame Figma-nya.

Tiap kasus menyebut AC mana yang dibuktikannya. Kalau expected di dokumen ini berbeda dengan AC di PRD, **PRD yang menang** — laporkan bedanya, jangan pilih sendiri.

**Baseline penting.** Dokumen ini dibangun dari MVP yang sudah ada: `SO_PRD_MVP.md` + canvas MVP. Konsekuensinya, hal-hal berikut **tidak ada** dan tidak perlu diuji: login/OTP (PAGE-02 & PAGE-03 dihapus), Open Bill (PAGE-10 dihapus), halaman "Review Read-only" terpisah (digabung ke PAGE-08), dan antrean Waiting List. Beberapa catatan di canvas masih menyebut hal-hal itu — lihat [Temuan pada canvas](#temuan-pada-canvas).

### Daftar kasus

| ID | Judul singkat | Membuktikan AC | Status desain |
|---|---|---|---|
| `SO-JRN-A1` | Journey lengkap QRIS sampai struk | AC-01.1, 04.1, 05.2, 06.6, 08.1, 08.6, 09.2, 09.3, 11.1 | sudah |
| `SO-JRN-A2` | Promo item gratis 1 varian: auto-apply | AC-07.6 | sudah |
| `SO-JRN-A3` | Promo item gratis ≥2 varian: pilih di FreeItemSheet | AC-07.1, 07.2, 07.5 | sudah |
| `SO-JRN-A4` | Countdown QRIS habis sebelum dibayar | AC-09.4 | **belum** |
| `SO-JRN-B1` | Journey lengkap Bayar di Kasir sampai struk | AC-09.5, 09.6, 11.1 | sudah |
| `SO-JRN-B2` | Tamu cek status sebelum kasir menandai lunas | AC-09.7 | **belum** |
| `SO-JRN-B3` | Merchant menonaktifkan QRIS | AC-08.4 | **belum** |
| `SO-JRN-C1` | Data Pelanggan dibiarkan kosong | AC-08.2, 08.7 | sudah |
| `SO-JRN-C2` | No. HP diisi: pencocokan member tanpa pesan apa pun | AC-08.8, 08.9 | sudah |
| `SO-JRN-C3` | Koneksi putus di tengah journey | AC-NET.1, NET.2 | **belum** |
| `SO-JRN-C4` | Buka ulang link konfirmasi | AC-11.5 | **belum** |
| `SO-JRN-C5` | Kembali ke Menu setelah selesai | AC-11.4 | sudah |
| `SO-JRN-C6` | Field No. HP: prefix +62 dan normalisasi input | AC-08.8 (turunan) | **baru** |
| `SO-JRN-C7` | No. HP terisi tapi belum lengkap: ditahan | AC-08.2, AC-08.8 | sudah |

Yang **tidak** ada di dokumen ini karena sudah punya dokumen sendiri: validasi keranjang (`ValidationPopup`) → [[SO_Case_ValidasiKeranjangRedesign]] · hapus/edit item keranjang → [[SO_Case_HapusEditItemKeranjang]] · bagikan struk → [[SO_Case_BagikanStrukNegative]] & [[SO_Case_ToastSuksesBagikanStruk]] · identitas opsional & konfirmasi member → [[SO_Case_LoginOpsionalKonfirmasiMember]] · setup AOL → [[SO_Case_SetupAOLFiturOpsional]] · QR Management di POS → [[SO_Case_QRManagementNegative]].

## Alur yang diuji

Dari `SO_PRD_MVP.md` §4 — satu-satunya alur MVP:

```
PAGE-01 Landing/QR Entry → PAGE-04 Menu ⇄ PAGE-05 Detail Item → PAGE-06 Keranjang
   ├─ PAGE-06V Promo (kondisional)
   └─ PAGE-07 Klaim Item Gratis (kondisional)
        ↓ tap "Konfirmasi Pesanan" → validasi server
PAGE-08 Konfirmasi Pesanan → PAGE-09 Pembayaran (QRIS / Bayar di Kasir) → PAGE-11 Selesai & Struk
```

Tidak ada gate login di titik mana pun. Tombolnya bernama **"Konfirmasi Pesanan"** — bukan "Cek Stok & Promo" (nama lama di v0.2).

---

## A. Journey QRIS

### SO-JRN-A1 — Journey lengkap: scan QR statis sampai struk, bayar QRIS

**Membuktikan:** AC-01.1, AC-04.1, AC-05.2, AC-06.6, AC-08.1, AC-08.6, AC-09.2, AC-09.3, AC-11.1
**Frame Figma:** [Menu — MenuClassicScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1396) → [Item Detail — ItemScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1442) → [Cart — CartScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1534) → [Confirm — ConfirmScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1586) → [Processing QRIS — ProcessingScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1655) → [Success — SuccessScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1695)

**Prasyarat**

- Outlet aktif, **QR statis** sudah ter-generate dan terdaftar (lihat [[SO_Case_QRManagementNegative]] untuk cara membuatnya).
- Fitur QR Self Order aktif di AOL dan POS sudah disinkronkan ([[SO_Case_SetupAOLFiturOpsional]]).
- Menu punya minimal 2 item tersedia dengan harga jelas; stok normal.
- **QRIS provider terisi di AOL** sehingga metode QRIS aktif.
- Tamu belum pernah membuka sesi (browser bersih). **Tidak ada login apa pun.**

**Langkah reproduksi**

1. Pindai QR statis di meja dengan kamera ponsel, buka tautannya
2. Tunggu menu dimuat — perhatikan konteks yang tampil di layar Menu
3. Tap satu item, pilih opsi kalau ada, atur qty, tap **"Tambah"**
4. Tap **CartDock** (jumlah item + subtotal di bawah) untuk masuk Keranjang
5. Periksa isi keranjang, lalu tap **"Konfirmasi Pesanan"**
6. Tunggu validasi server selesai tanpa masalah, layar Konfirmasi Pesanan terbuka
7. Biarkan field **"Data Pelanggan · opsional"** kosong
8. Pilih metode pembayaran **QRIS**, lalu tap **"Bayar"**
9. Perhatikan kode QRIS, nominal, dan countdown
10. Bayar QRIS dari aplikasi pembayaran sampai berhasil
11. Diamkan layar — jangan tekan apa pun

**Hasil yang diharapkan**

| Langkah | Yang harus terjadi | AC |
|---|---|---|
| 1–2 | Menu live dimuat, tamu diarahkan ke Menu dengan konteks **"Pesan Mandiri"**; kategori & item tampil dengan harga dan ketersediaan terkini | AC-01.1, AC-04.1 |
| 3 | Item masuk keranjang dengan opsi & qty tepat, muncul toast **"Ditambahkan ke keranjang"** | AC-05.2 |
| 4 | CartDock menampilkan jumlah item & subtotal, dan membawa ke Keranjang | AC-04.4 |
| 5–6 | Validasi server jalan; karena bersih, tamu langsung masuk Konfirmasi Pesanan **tanpa diminta login** | AC-06.6, AC-08.1 |
| 7–8 | Tombol "Bayar" **disabled sebelum metode dipilih**, aktif setelah QRIS dipilih | AC-08.6 |
| 9 | Kode QRIS + nominal + **countdown 5 menit** tampil dengan status **"Menunggu pembayaran…"** | AC-09.2 |
| 10–11 | Server mendeteksi lunas lewat polling, tamu **otomatis** diarahkan ke Selesai & Struk **tanpa aksi tambahan** | AC-09.3 |
| 11 | Layar Selesai menampilkan konfirmasi sukses, ringkasan pesanan, dan detail transaksi | AC-11.1 |

Yang **tidak boleh** terjadi di sepanjang jalur ini: permintaan login, permintaan OTP, halaman review read-only terpisah, atau keranjang ter-reset.

**Hasil aktual (2026-07-30)**

Semua layarnya sudah tergambar di canvas MVP. **Catatan pada section ini masih memuat perilaku lama** (login WhatsApp, review read-only, tombol "Cek Stok & Promo") — lihat [Temuan pada canvas](#temuan-pada-canvas) no. 1.

---

### SO-JRN-A2 — Promo item gratis dengan 1 varian: langsung diterapkan tanpa sheet

**Membuktikan:** AC-07.6
**Frame Figma:** [Catatan promo auto-apply](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1357-18441)

**Prasyarat**

- Ada Promo Produk bertipe barang-gratis yang **hanya punya 1 varian hadiah**.
- Keranjang sudah memenuhi syarat promo tersebut (mis. sudah beli Nasi Ayam Bakar).

**Langkah reproduksi**

1. Tambahkan item yang memenuhi syarat promo ke keranjang
2. Buka Keranjang
3. Klaim promonya
4. Perhatikan apakah ada sheet pemilihan hadiah yang terbuka

**Hasil yang diharapkan**

- Item gratis **ditambahkan otomatis** ke keranjang tanpa membuka `FreeItemSheet`.
- Baris item hadiah tampil sebagai **"Gratis"**.
- Tamu tidak perlu memilih apa pun.

**Hasil aktual (2026-07-30)**

Aturannya sudah tercatat di catatan canvas dan **konsisten** dengan AC-07.6: *"Kalau cuma ada 1 barang yang memenuhi syarat promo, promo langsung diterapkan otomatis begitu diklaim — user tidak perlu memilih."*

---

### SO-JRN-A3 — Promo item gratis dengan ≥2 varian: pilih hadiah di FreeItemSheet

**Membuktikan:** AC-07.1, AC-07.2, AC-07.5
**Frame Figma:** [Pilih Item Gratis — FreeItemSheet](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1992)

**Prasyarat**

- Ada Promo Produk barang-gratis dengan **minimal 2 varian hadiah** tersedia (mis. "Beli Nasi Ayam Bakar, gratis 1 Ayam Goreng" dengan beberapa varian).
- Keranjang sudah memenuhi syarat promo.

**Langkah reproduksi**

1. Penuhi syarat promo, buka Keranjang
2. Klaim promonya — `FreeItemSheet` terbuka
3. **Jangan pilih apa pun**, coba tekan **"Pakai Hadiah"**
4. Pilih hadiah sesuai kuota
5. Tekan **"Pakai Hadiah"**

**Hasil yang diharapkan**

| Langkah | Yang harus terjadi | AC |
|---|---|---|
| 2 | Sheet tampil dengan daftar item hadiah | AC-07.1 |
| 3 | Tombol "Pakai Hadiah" **tetap disabled** selama kuota belum terpenuhi | AC-07.5 |
| 4–5 | Item ditambahkan ke keranjang sebagai baris **"Gratis"** | AC-07.2 |

**Hasil aktual (2026-07-30)**

Sheet-nya sudah tergambar di dua journey (QRIS dan Bayar di Kasir). Varian "semua item hadiah habis" (AC-07.4) belum ditemukan frame-nya — perlu dicek terpisah.

---

### SO-JRN-A4 — Countdown QRIS habis sebelum tamu membayar

**Membuktikan:** AC-09.4
**Frame Figma:** **belum digambar** — [Processing QRIS](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1655) hanya punya state menunggu, belum ada state kedaluwarsa.

**Prasyarat**

- Tamu sudah sampai layar Processing QRIS dengan kode aktif.
- Bisa menunggu / mempercepat countdown 5 menit sampai habis.

**Langkah reproduksi**

1. Sampai ke layar Processing QRIS
2. **Jangan bayar.** Biarkan countdown habis
3. Perhatikan pesan yang muncul
4. Tekan **"Kembali ke konfirmasi"**
5. Periksa isi pesanan

**Hasil yang diharapkan**

- Muncul popup **"Kode QRIS kedaluwarsa"** dengan tombol **"Kembali ke konfirmasi"**.
- **Isi pesanan tidak hilang** — tamu kembali ke Konfirmasi Pesanan dengan keranjang dan pilihan yang sama, bisa membuat kode QRIS baru.
- Tidak ada pesanan ganda yang terkirim ke POS.

**Hasil aktual (2026-07-30)**

**Belum ada frame.** Copy popup-nya sudah ditetapkan di AC-09.4, tampilannya belum dirancang.

---

## B. Journey Bayar di Kasir

### SO-JRN-B1 — Journey lengkap: pesan lewat QR statis, bayar di kasir

**Membuktikan:** AC-09.5, AC-09.6, AC-11.1
**Frame Figma:** [Confirm — ConfirmScreen (Bayar di Kasir)](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2322) → [Cash Status — CashStatusScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2553) → [Kondisi POS setelah pesanan masuk](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1841-20483) → [Success — SuccessScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1294-30001)

**Prasyarat**

- Sama seperti `SO-JRN-A1`, kecuali metode pembayarannya.
- Ada kasir yang bisa membuka POS dan menandai pesanan lunas.

**Langkah reproduksi**

1. Pesan seperti langkah 1–6 pada `SO-JRN-A1` sampai layar Konfirmasi Pesanan
2. Pilih metode **Bayar di Kasir**, tap **"Bayar"**
3. Catat **kode referensi (REF)** yang tampil di layar tamu
4. Di POS, buka daftar pesanan baru — periksa pesanan masuk dengan REF yang sama
5. Kasir memproses pembayaran (tunai/kartu) dan menandai **lunas** di POS
6. Di layar tamu, tap **"Cek Status Pesanan"**

**Hasil yang diharapkan**

| Langkah | Yang harus terjadi | AC |
|---|---|---|
| 2–3 | `CashStatusScreen` menampilkan **kode referensi**, instruksi ke kasir, rincian pesanan lengkap, dan tombol **"Cek Status Pesanan"**. Copy pendukungnya: *"Terima kasih atas pesananmu. Silakan selesaikan pembayaran di kasir agar pesanan segera diproses."* | AC-09.5 |
| 3 | Kode REF berupa **6 angka acak** — dipakai kasir untuk mencari pesanan | *(lihat pertanyaan terbuka no. 2)* |
| 4 | Pesanan muncul di POS berstatus **menunggu bayar**, REF-nya sama persis dengan layar tamu | — |
| 6 | Tamu diarahkan ke layar Selesai & Struk dengan ringkasan transaksi | AC-09.6, AC-11.1 |

**Hasil aktual (2026-07-30)**

Sudah tergambar cukup lengkap, termasuk sisi POS ("Kondisi POS setelah Pesanan Self Order Masuk" dan layar Proses Pembayaran). Aturan REF 6 angka acak ada di catatan canvas tapi **belum masuk PRD**.

---

### SO-JRN-B2 — Tamu menekan "Cek Status Pesanan" sebelum kasir menandai lunas

**Membuktikan:** AC-09.7
**Frame Figma:** **belum digambar** — [CashStatusScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2553) belum punya state "belum diterima".

**Prasyarat**

- Tamu sudah di `CashStatusScreen` dengan REF aktif.
- Kasir **belum** menandai pesanan lunas.

**Langkah reproduksi**

1. Di layar tamu, tap **"Cek Status Pesanan"**
2. Perhatikan pesan yang muncul dan posisi layar
3. Ulangi 2–3 kali dengan jeda

**Hasil yang diharapkan**

- Tamu **tetap di layar ini** — tidak berpindah ke layar Selesai.
- Muncul pesan **"Pembayaran belum diterima."**
- REF dan rincian pesanan tidak berubah; menekan berulang tidak membuat pesanan ganda.

**Hasil aktual (2026-07-30)**

**Belum ada frame.** Wadah pesannya (toast atau inline) belum ditetapkan — perlu diputuskan, lihat pertanyaan terbuka no. 3.

---

### SO-JRN-B3 — Merchant menonaktifkan QRIS: opsi QRIS mati, Bayar di Kasir otomatis aktif

**Membuktikan:** AC-08.4
**Frame Figma:** **belum digambar** sebagai state terpisah — [ConfirmScreen (Bayar di Kasir)](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2322) menggambarkan hasil akhirnya, bukan kondisi QRIS yang di-disable.

**Prasyarat**

- **QRIS provider dikosongkan di AOL** sehingga QRIS tidak tersedia.
- Tamu sudah sampai layar Konfirmasi Pesanan.

**Langkah reproduksi**

1. Kosongkan QRIS provider di AOL, sinkronkan
2. Sebagai tamu, pesan sampai layar Konfirmasi Pesanan
3. Periksa kedua opsi metode pembayaran
4. Coba tap opsi QRIS
5. Tap **"Bayar"**

**Hasil yang diharapkan**

- Opsi **QRIS tampil disabled/grayscale**, tidak bisa dipilih.
- **Bayar di Kasir otomatis aktif** (terpilih), sehingga tombol "Bayar" bisa langsung ditekan.
- Tap pada QRIS tidak melakukan apa pun — tidak ada modal error.

**Hasil aktual (2026-07-30)**

Perilakunya sudah ditetapkan di AC-08.4, tapi state QRIS disabled belum tergambar sebagai frame tersendiri.

---

## C. Lintas halaman

### SO-JRN-C1 — Data Pelanggan dibiarkan kosong: pesanan tetap jalan

**Membuktikan:** AC-08.2, AC-08.7
**Frame Figma:** [Confirm — ConfirmScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1586)

**Prasyarat**

- Tamu di layar Konfirmasi Pesanan (QR **Statis**), keranjang berisi item.

**Langkah reproduksi**

1. Jangan isi apa pun di field **"Data Pelanggan · opsional"**
2. Pilih metode pembayaran
3. Tap **"Bayar"**

**Hasil yang diharapkan**

- Tamu **lanjut ke Pembayaran tanpa hambatan** — tidak ada validasi yang memaksa mengisi.
- Tidak ada pesan, tanda wajib, atau highlight pada field tersebut.

**Hasil aktual (2026-07-30)**

Tergambar. Field-nya memang inline di ConfirmScreen, bukan sheet terpisah. Untuk QR **Dinamis**, field-nya masih versi lama ("Nama" + "Nomor HP" + chip "Masuk", AC-08.10) — itu kasus terpisah, lihat [[SO_Case_LoginOpsionalKonfirmasiMember]].

---

### SO-JRN-C2 — No. HP diisi: pencocokan member berjalan tanpa pesan apa pun ke tamu

**Membuktikan:** AC-08.8, AC-08.9
**Frame Figma:** [Confirm — ConfirmScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1586)

**Prasyarat**

- Ada satu nomor HP yang **terdaftar** sebagai member POS, dan satu nomor yang **tidak** terdaftar.
- Tamu di layar Konfirmasi Pesanan (QR Statis).

**Langkah reproduksi**

1. Isi No. HP dengan nomor yang **terdaftar** sebagai member
2. Perhatikan layar tamu — apakah ada perubahan tampilan atau pesan
3. Tap "Bayar" dan selesaikan pesanan
4. Di POS/laporan, periksa apakah status member tercatat
5. Bandingkan total harga, diskon, SPA, dan poin dengan pesanan tanpa No. HP
6. Ulangi langkah 1–3 dengan nomor yang **tidak terdaftar**

**Hasil yang diharapkan**

- **Tidak ada perubahan tampilan dan tidak ada pesan apa pun** ke tamu — baik saat nomornya cocok maupun tidak. Tidak ada badge "Member", tidak ada toast.
- Status member (bila cocok) **tercatat untuk laporan POS internal**.
- **Harga, diskon, SPA, dan poin tidak berubah** oleh pencocokan ini.
- Nomor tidak terdaftar: pesanan tetap jalan normal, tanpa error.

**Hasil aktual (2026-07-30)**

Perilaku "diam-diam" ini yang paling mudah salah dipahami sebagai bug oleh QA — karena itu langkah 5 (bandingkan harga) wajib dijalankan, bukan opsional.

---

### SO-JRN-C3 — Koneksi putus di tengah journey: konteks tidak boleh hilang

**Membuktikan:** AC-NET.1, AC-NET.2
**Frame Figma:** **belum digambar** — komponen error jaringan global belum ada frame-nya di canvas MVP.

**Prasyarat**

- Bisa mematikan koneksi perangkat tamu di tengah proses.
- Keranjang berisi minimal 2 item.

**Langkah reproduksi**

1. Isi keranjang, buka Keranjang
2. Matikan koneksi
3. Tap **"Konfirmasi Pesanan"**
4. Perhatikan komponen error yang muncul
5. Nyalakan koneksi kembali, tap **"Coba Lagi"**
6. Periksa isi keranjang dan sesi

**Hasil yang diharapkan**

- Muncul **komponen error jaringan global** dengan tombol **"Coba Lagi"**.
- Setelah koneksi pulih dan "Coba Lagi" ditekan: request diulang dan **keranjang, sesi, serta isi form tetap utuh**.
- Tidak ada pesanan ganda, tidak ada keranjang yang ter-reset.

**Hasil aktual (2026-07-30)**

**Belum ada frame.** Ini perlu diuji di beberapa titik (Menu, Keranjang, Konfirmasi, Pembayaran) — kandidat kasus berparameter begitu komponennya digambar.

---

### SO-JRN-C4 — Buka ulang link konfirmasi: status dipulihkan, pesanan tidak dobel

**Membuktikan:** AC-11.5
**Frame Figma:** [Success — SuccessScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1695)

**Prasyarat**

- Sudah ada satu pesanan yang **selesai dibayar** dan tamu berada di layar Selesai & Struk.

**Langkah reproduksi**

1. Salin URL layar Selesai & Struk
2. Muat ulang halaman (refresh)
3. Tutup browser, buka lagi URL yang sama
4. Periksa POS: berapa pesanan yang tercatat

**Hasil yang diharapkan**

- Status sukses **dipulihkan dari server** — layar tetap menampilkan konfirmasi sukses dan ringkasan yang sama.
- **Tidak ada pesanan yang tergandakan** di POS.

**Hasil aktual (2026-07-30)**

Layar Selesai sudah ada; perilaku pemulihan dari server belum bisa diverifikasi tanpa build.

---

### SO-JRN-C5 — "Kembali ke Menu" memulai sesi baru

**Membuktikan:** AC-11.4
**Frame Figma:** [Success — SuccessScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1695)

**Prasyarat**

- Tamu di layar Selesai & Struk setelah pesanan sukses.

**Langkah reproduksi**

1. Tap **"Kembali ke Menu"**
2. Periksa keranjang
3. Periksa apakah data pesanan sebelumnya masih terbawa

**Hasil yang diharapkan**

- Tamu kembali ke Menu **dengan sesi baru**: keranjang kosong, tidak ada sisa data pesanan lama.
- Konteks outlet/meja tetap benar — tamu tidak perlu memindai QR ulang.

**Hasil aktual (2026-07-30)**

Tergambar sebagai bagian dari journey. Perlu dipastikan "sesi baru" tidak berarti kehilangan konteks meja.

---

### SO-JRN-C6 — Field No. HP menampilkan prefix +62 dan menormalkan apa pun yang diketik tamu

**Membuktikan:** AC-08.8 (turunan)
**Frame Figma:** [PhoneField — komponen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2642-533) · dipakai di [Confirm — ConfirmScreen](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1586)

> **Baru 2026-07-30.** Field `Nomor HP` diganti komponen **`PhoneField`** yang menampilkan prefix **`+62`** statis. Sebelumnya field ini `TextField` biasa tanpa prefix, sehingga satu field menerima empat bentuk penulisan berbeda.

**Prasyarat**

- Tamu di halaman Konfirmasi Pesanan (QR Statis), keranjang berisi item.
- Field **Data Pelanggan · opsional** tampil dengan prefix `+62`.

**Langkah reproduksi**

1. Perhatikan tampilan awal field: ikon HP, `+62`, garis pemisah, lalu contoh angka abu-abu
2. Ketik `81380012025`
3. Hapus isinya, lalu ketik `081380012025` (pakai angka 0 di depan)
4. Hapus isinya, lalu tempel `+6281380012025`
5. Hapus isinya, lalu tempel `0813-8001-2025` (pakai tanda hubung)
6. Lanjutkan sampai pesanan terkirim, lalu periksa nomor yang tercatat di sisi POS

**Hasil yang diharapkan**

| Langkah | Yang harus terjadi |
|---|---|
| 1 | `+62` tampil statis dan **tidak bisa dihapus**. Contoh angka abu-abu bukan nilai — hilang begitu tamu mulai mengetik. |
| 2 | Tampil `813 8001 2025` — dikelompokkan **3-4-4**. |
| 3 | Angka `0` di depan **dibuang otomatis**, hasilnya `813 8001 2025`. Tidak jadi `0813…` dan tidak jadi `+62 0813…`. |
| 4 | `62` di depan **dibuang otomatis**, tidak jadi `+62 62813…`. |
| 5 | Tanda hubung dan spasi **dibuang otomatis**, hasilnya tetap `813 8001 2025`. |
| 6 | Yang tercatat di server berbentuk **E.164 tanpa spasi**: `+6281380012025`. |

**Panjang yang diterima: 9–12 digit setelah `+62`.** Nomor HP Indonesia `08xx-xxxx-xxxx` panjangnya 10–13 digit termasuk `0`; setelah `0` dibuang sisanya 9–12.

**Kalau nomornya bukan Indonesia.** Untuk MVP field ini **hanya menerima +62**. Tamu asing membiarkannya kosong — field ini opsional dan gunanya mencocokkan data member POS yang memang lokal. Pemilih kode negara adalah kandidat fase berikutnya; kalau nanti ditambahkan, **format simpan tetap E.164** dan hanya tampilannya yang berubah.

**Hasil aktual (2026-07-30)**

Komponen `PhoneField` sudah dibuat di halaman **Komponen Primitif** dengan 3 varian (`State=Default` / `Filled` / `Error`), dan **11 field No. HP di seluruh file sudah ditukar** ke komponen ini. Aturan normalisasi di tabel atas belum bisa diverifikasi tanpa build.

---

### SO-JRN-C7 — No. HP diisi tapi belum lengkap: pesanan ditahan dengan pesan inline

**Membuktikan:** AC-08.2 (batasnya), AC-08.8
**Frame Figma:** [Case: Nomor HP Tidak Valid](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1165-39551)

**Prasyarat**

- Tamu di halaman Konfirmasi Pesanan (QR Statis), metode pembayaran sudah dipilih.

**Langkah reproduksi**

1. Isi field No. HP hanya `813 80` (kurang dari 9 digit)
2. Pindahkan fokus keluar dari field
3. Coba tekan **"Bayar"**
4. Lengkapi nomornya jadi `813 8001 2025`
5. Tekan **"Bayar"**
6. Ulangi dari awal, tapi kali ini **kosongkan** field No. HP lalu tekan **"Bayar"**

**Hasil yang diharapkan**

| Langkah | Yang harus terjadi |
|---|---|
| 2 | Field masuk state error (border danger), tampil pesan **"Nomor HP tidak lengkap. Cek kembali sebelum melanjutkan."** |
| 3 | Pesanan **tidak dikirim** — tamu ditahan di halaman ini. |
| 4–5 | Error hilang, tamu lanjut ke halaman Pembayaran seperti biasa. |
| 6 | Field kosong = **tidak ada error**, tamu lanjut tanpa hambatan (AC-08.2 / AC-08.7). |

**Kosong dan salah itu berbeda.** Kosong berarti tamu memang tidak ingin memberi nomor — itu haknya, dan pesanan harus jalan. Terisi-tapi-kurang berarti dia **berniat** memberi nomor tapi belum selesai; kalau diloloskan, pencocokan member gagal dan gagalnya senyap (AC-08.8), jadi tamu tidak akan pernah tahu.

**Hasil aktual (2026-07-30)**

Copy dan state error-nya **sudah ada di Figma** pada section **Case: Nomor HP Tidak Valid** — jadi keputusan "diblokir, bukan diloloskan" sebenarnya sudah terpegang di desain, cuma belum tertulis di spec. Sekarang sudah.

---

## Yang di luar scope (sengaja tidak dikerjakan)

Semua ini keputusan sadar dari `SO_PRD_MVP.md`, bukan celah yang terlewat. **Jangan dilaporkan sebagai bug.**

- **Login & OTP** (PAGE-02, PAGE-03) — tidak ada mekanisme ini sama sekali di MVP.
- **Open Bill** (PAGE-10) — di luar MVP.
- **Halaman "Review Read-only" terpisah** — digabung ke Konfirmasi Pesanan; validasi keranjang berbentuk popup di atas Keranjang.
- **Antrean Waiting List / handoff WL** — bukan fitur yang sudah ada.
- **QR Dinamis** — memakai alur sama, tapi field identitas di Konfirmasi masih versi lama (AC-08.10). Kasusnya di [[SO_Case_LoginOpsionalKonfirmasiMember]].
- **Detail pengelolaan keranjang** (ubah qty, hapus item, dialog konfirmasi) → [[SO_Case_HapusEditItemKeranjang]].
- **Diskon Transaksi / PAGE-06V** — AC-06V.x belum dibuatkan kasus di dokumen ini; kandidat dokumen terpisah.

## Status desain di Figma

| ID | Kasus | Status | Frame utama |
|---|---|---|---|
| `SO-JRN-A1` | Journey QRIS lengkap | sudah | 6 frame journey QRIS |
| `SO-JRN-A2` | Promo 1 varian auto-apply | sudah (catatan) | Catatan promo |
| `SO-JRN-A3` | Promo ≥2 varian | sudah | FreeItemSheet |
| `SO-JRN-A4` | QRIS kedaluwarsa | **belum** | — |
| `SO-JRN-B1` | Journey Bayar di Kasir | sudah, termasuk sisi POS | CashStatusScreen + Kondisi POS |
| `SO-JRN-B2` | Cek status sebelum lunas | **belum** | — |
| `SO-JRN-B3` | QRIS dinonaktifkan | **belum** (state disabled) | — |
| `SO-JRN-C1` | Data Pelanggan kosong | sudah | ConfirmScreen |
| `SO-JRN-C2` | Pencocokan member diam-diam | sudah | ConfirmScreen |
| `SO-JRN-C3` | Koneksi putus | **belum** | — |
| `SO-JRN-C4` | Buka ulang link | sebagian | SuccessScreen |
| `SO-JRN-C5` | Kembali ke Menu | sudah | SuccessScreen |
| `SO-JRN-C6` | Prefix +62 & normalisasi | sudah $em komponen PhoneField baru | **PhoneField** (Komponen Primitif) |
| `SO-JRN-C7` | No. HP belum lengkap | sudah | **Case: Nomor HP Tidak Valid** |

## Temuan pada canvas

| # | Temuan | Kenapa penting |
|---|---|---|
| 1 | **Catatan journey QRIS (`1223:1840`) masih memuat perilaku lama.** Isinya: *"Belum login → wajib login WhatsApp dulu"*, *"Verifikasi kode balas otomatis di WhatsApp"*, *"review read-only akurat"*, dan tombol *"Cek Stok & Promo"*. Keempatnya sudah dihapus/diganti di `SO_PRD_MVP.md`. | QA yang membaca canvas akan menguji login WhatsApp yang tidak ada, dan mencari tombol dengan nama lama. Ini sumber laporan bug palsu. |
| 2 | **Catatan journey Bayar di Kasir (`1223:2620`) sama masalahnya**, plus menyebut *"masuk antrean WL"*. | WL belum jadi fitur; ekspektasi ini tidak bisa dipenuhi siapa pun. |
| 3 | **Precondition di kedua catatan menyebut "Metode A" dan merujuk `SO_PRD.md`** (bukan `SO_PRD_MVP.md`). | Merujuk baseline lama. Percabangan per-metode sudah tidak ada di MVP. |
| 4 | **Aturan REF 6 angka acak hanya hidup di catatan canvas (`1841:24631`)**, belum masuk PRD maupun AC-09.5. | Kalau catatan canvas diubah/hilang, aturan ini lenyap tanpa jejak. Perlu diangkat ke PRD. |
| 5 | **Nama frame masih memakai istilah "Close Bill"** (mis. "Menu · Close Bill — MenuClassicScreen") padahal alur MVP-nya QR Statis. | Perlu dipastikan apakah "Close Bill" masih istilah yang benar, atau sisa penamaan lama. |
| 6 | **Catatan promo auto-apply (`1357:18441`) sudah benar** dan konsisten dengan AC-07.6. | Dicatat sebagai contoh catatan yang sehat — polanya bisa dipakai untuk memperbaiki no. 1 dan 2. |

## Pertanyaan terbuka

| No | Pertanyaan | Menunggu | Terkait |
|---|---|---|---|
| 1 | Catatan canvas mana yang diperbarui lebih dulu? Usul: journey QRIS & Bayar di Kasir, karena dua itu yang dipakai QA untuk regresi rilis. | UI/UX | temuan 1, 2, 3 |
| 2 | **REF 6 angka acak** — perlu masuk PRD sebagai AC (mis. AC-09.5a)? Apakah benar-benar acak, atau berurutan per outlet? | PM / DEV | B1, temuan 4 |
| 3 | Wadah pesan **"Pembayaran belum diterima."** — toast, inline text, atau modal? | UI/UX | B2 |
| 4 | Istilah **"Close Bill"** pada nama frame: masih dipakai, atau sisa penamaan lama? | PM | temuan 5 |
| 8 | Placeholder field No. HP sekarang `813 8001 2025`. Di field sempit (~180px, layar QR Dinamis) teksnya terpotong jadi `813 8001 2…`. Terima apa adanya, atau pakai contoh lebih pendek? | keputusan UI/UX | SO-JRN-C6 |
| 9 | Dua field di layar **QR Dinamis** (`2230:64`, `2230:118`) ikut ditukar ke PhoneField. Padahal AC-08.10 menyatakan varian Dinamis **belum diselaraskan** dengan QR Statis. Dibiarkan selaras, atau dikembalikan supaya drift-nya tetap terlihat? | keputusan PM | SO-JRN-C6 |
| 5 | Sheet test case QA punya kolom `Mobile` / `Tablet FnB` / `Tablet Retail` — itu device **POS**. Aplikasi Self Order jalan di **ponsel tamu**. Perlu kolom sendiri (mis. `Browser Tamu`), atau ponsel tamu dianggap `Mobile`? | QA | semua |
| 6 | AC-07.4 (semua item hadiah habis) belum ditemukan frame-nya — sudah digambar di tempat lain, atau belum ada? | UI/UX | A3 |
| 7 | PAGE-06V (Diskon Transaksi) belum dibuatkan kasus. Dijadikan dokumen sendiri, atau ditambahkan ke sini? | PM / QA | luar scope |

---

## Lampiran A — Kamus layar

| Nama layar (nama frame Figma) | Isinya | Cara membuka |
|---|---|---|
| **Menu — MenuClassicScreen** | katalog menu: kategori, kartu item, harga, badge "Habis", label "PROMO", CartDock di bawah | otomatis setelah scan QR |
| **Item Detail — ItemScreen** | detail satu item: gambar, opsi (wajib/tambahan), qty, catatan, tombol "Tambah" | tap kartu item di Menu |
| **Cart — CartScreen** | daftar item + qty + catatan, ringkasan biaya, tombol "Konfirmasi Pesanan" | tap CartDock |
| **Pilih Item Gratis — FreeItemSheet** | daftar varian hadiah promo + tombol "Pakai Hadiah" | klaim promo barang-gratis dengan ≥2 varian |
| **Confirm — ConfirmScreen** | ringkasan pesanan, field "Data Pelanggan · opsional", pilihan metode bayar, tombol "Bayar" | tap "Konfirmasi Pesanan" saat validasi bersih |
| **Processing QRIS — ProcessingScreen** | kode QRIS, nominal, countdown 5 menit, status "Menunggu pembayaran…" | pilih QRIS lalu "Bayar" |
| **Cash Status — CashStatusScreen** | kode REF, instruksi ke kasir, rincian pesanan, tombol "Cek Status Pesanan" | pilih Bayar di Kasir lalu "Bayar" |
| **Success — SuccessScreen** | konfirmasi sukses, ringkasan pesanan, detail transaksi, "Kembali ke Menu", akses Bagikan Struk | setelah pembayaran terverifikasi |
| **Kondisi POS setelah Pesanan Self Order Masuk** | tampilan POS saat pesanan Self Order masuk, dipakai kasir mencari REF | aplikasi POS, daftar pesanan baru |

## Lampiran B — Peta node Figma

File: `mAZuRze02w906M6u2EwVWh` (Self-Order), canvas MVP `1223:2`. Pola link: `https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=<node-pakai-tanda-hubung>`.

| Nama section / frame | Node | Terkait |
|---|---|---|
| Case: Journey Close Bill · QRIS (happy path) | [`1223:1395`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1395) | A1–A4 |
| Menu — MenuClassicScreen (journey QRIS) | [`1223:1396`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1396) | A1 |
| Item Detail — ItemScreen | [`1223:1442`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1442) | A1 |
| Cart — CartScreen | [`1223:1534`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1534) | A1 |
| Confirm — ConfirmScreen | [`1223:1586`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1586) | A1, C1, C2 |
| **PhoneField (komponen baru, 3 varian)** | [`2642:533`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2642-533) | C6, C7 |
| Case: Nomor HP Tidak Valid (copy error) | [`1165:39551`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1165-39551) | C7 |
| Processing QRIS — ProcessingScreen | [`1223:1655`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1655) | A1, A4 |
| Success — SuccessScreen | [`1223:1695`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1695) | A1, C4, C5 |
| Pilih Item Gratis — FreeItemSheet | [`1223:1992`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1992) | A3 |
| **catatan journey QRIS — masih perilaku lama** | [`1223:1840`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-1840) | temuan 1 |
| Case: Journey Close Bill · Bayar di Kasir (happy path) | [`1223:2174`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2174) | B1–B3 |
| Confirm — ConfirmScreen (Bayar di Kasir) | [`1223:2322`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2322) | B1, B3 |
| Cash Status — CashStatusScreen | [`1223:2553`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2553) | B1, B2 |
| Success — SuccessScreen (Bayar di Kasir) | [`1294:30001`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1294-30001) | B1 |
| Kondisi POS setelah Pesanan Self Order Masuk | [`1841:20483`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1841-20483) | B1 |
| **catatan journey Bayar di Kasir — masih perilaku lama** | [`1223:2620`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2620) | temuan 2 |
| Catatan promo auto-apply (sudah benar) | [`1357:18441`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1357-18441) | A2, temuan 6 |
| Catatan REF 6 angka acak | [`1841:24631`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1841-24631) | B1, temuan 4 |
| Case: Bayar Di Kasir (sisi POS, lengkap) | [`1841:24626`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1841-24626) | B1 |
| Case: Melihat Riwayat Transaksi Self Order | [`2016:77598`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2016-77598) | luar scope |
