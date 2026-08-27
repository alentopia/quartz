# Salestype — Case: Setting Salestype pada Data Lama (AOL + POS)

<!--
CONTOH KONVERSI. Isi dokumen ini diangkat dari sheet test case QA yang sudah ada
("AOL - Setting Salestype Data Lama"), ditulis ulang ke format spec vault supaya bisa
di-generate balik jadi baris sheet. Bagian yang belum jelas dari sheet TIDAK dikarang -
semuanya dikumpulkan di "Pertanyaan terbuka".
-->

**Status:** Draft
**Tanggal:** 2026-07-29
**Fitur:** Salestype (Tipe Penjualan) — sisi **Setup AOL** dan **POS Outlet**, untuk merchant yang datanya sudah ada sebelum fitur salestype dirilis ("data lama").
**Prefix ID kasus:** `AOL-SST`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · PM (keputusan produk)
**Format dokumen ini mengikuti:** [[Template_Case_Negative]] · alasannya di [[Riset_Workflow_Handoff_UIUX_QA_DEV]]
**Sumber awal:** sheet test case QA "AOL - Setting Salestype Data Lama" (kolom Skenario/Deskripsi/Pre Condition/Test Step/Expected Result)
**Desain:** [Buka Sales-type di Figma](https://www.figma.com/design/w73yof0cSoUQIDArV8tmh3/Sales-type?node-id=5309-29179) (file `w73yof0cSoUQIDArV8tmh3`)

---

## Cara membaca dokumen ini

Setiap kasus punya lima bagian tetap: **Judul** · **Prasyarat** · **Langkah reproduksi** · **Hasil yang diharapkan** · **Hasil aktual**. Kasus yang punya beberapa varian data ditulis **sekali** dengan tabel **Varian** — nilai di tabel itu menggantikan `<placeholder>` di langkah dan expected.

Satu baris varian = satu baris di sheet test case QA. Jadi kasus `AOL-SST-A2` di bawah menghasilkan 4 baris sheet (`AOL-SST-A2-01` … `-04`), tapi hanya perlu dirawat di satu tempat.

### Daftar kasus

| ID | Judul singkat | Varian | Sumber di sheet |
|---|---|---|---|
| `AOL-SST-A1` | Cek field form Tambah Tipe Penjualan | — | Cek form |
| `AOL-SST-A2` | View salestype lama dari Outlet POS | 4 tipe | View salestype dari Outlet POS |
| `AOL-SST-A3` | Cek salestype lama dari menu Tipe Penjualan | 4 tipe | Cek salestype dari menu Tipe Penjualan |
| `AOL-SST-B1` | Buat salestype PDT tanpa Pelanggan Default dari Outlet POS | — | Buat salestype |

## Latar belakang

Merchant yang sudah jalan sebelum fitur salestype dirilis punya tipe penjualan bawaan (Dine In, TakeAway, E-Commerce, Gofood IFDS) dengan konfigurasi service charge dan pajak yang berbeda-beda. Yang diuji di sini: **apakah data lama itu tetap terbaca benar** setelah fitur salestype aktif, dan apakah field baru (**Pelanggan Default**) muncul dalam kondisi kosong — bukan terisi nilai asal.

Spec ini menutup sisi **pembacaan data lama** dan **pembuatan salestype baru dari Outlet POS**. Sisi lain (edit, hapus, migrasi) belum masuk.

## Data uji bersama

Dipakai oleh semua kasus di dokumen ini. Siapkan sebelum menjalankan kasus apa pun.

| Tipe penjualan | Service Charge | Pajak |
|---|---|---|
| Dine In | non SC | non pajak |
| TakeAway | SC 10.000 | pajak 10% |
| E-Commerce | SC 10% | non pajak |
| Gofood IFDS | *(belum tercatat di sheet — lihat pertanyaan terbuka no. 1)* | *(belum tercatat)* |

Perhatikan bahwa keempatnya sengaja dibuat berbeda: ada SC nominal (10.000) dan SC persen (10%), ada yang berpajak dan tidak. Kombinasi itulah yang membuat kasus ini bernilai — bukan sekadar membuka form.

## Prinsip

- **Data lama tidak boleh ditebak sistem.** Field baru yang belum pernah diisi merchant harus tampil **kosong**, bukan diisi nilai default diam-diam. Mengisi otomatis berarti mengubah perilaku transaksi merchant tanpa dia tahu.
- **Satu perilaku diuji dari semua pintu masuknya.** Salestype bisa dilihat dari Outlet POS (A2) dan dari menu Tipe Penjualan (A3). Dua-duanya diuji, karena bisa dilayani oleh kode yang berbeda.
- **Varian data bukan kasus baru.** Empat tipe penjualan menjalani langkah yang identik; yang berbeda cuma nilainya.

---

## A. Membaca salestype pada data lama

### AOL-SST-A1 — Form Tambah Tipe Penjualan menampilkan enam field yang benar

**Frame Figma:** *(belum ada link di sheet untuk kasus ini — lihat pertanyaan terbuka no. 2)*

**Prasyarat**

- Outlet POS sudah punya salestype data lama sesuai [Data uji bersama](#data-uji-bersama).
- User bisa masuk menu Kasir.

**Langkah reproduksi**

1. Ke menu Kasir
2. Ke Outlet POS
3. Ke tipe penjualan
4. Klik **+Tambah Tipe Penjualan**

**Hasil yang diharapkan**

Form menampilkan enam field, dalam urutan ini:

| # | Field | Wajib |
|---|---|---|
| 1 | Nama Tipe Penjualan | **ya** (bertanda `*`) |
| 2 | Kategori Penjualan | tidak |
| 3 | Pelanggan Default | tidak |
| 4 | Tipe Transaksi | tidak |
| 5 | Pajak | tidak |
| 6 | Service Charge | tidak |

Hanya **Nama Tipe Penjualan** yang bertanda wajib. Field lain boleh dibiarkan kosong — itu yang membuat kasus `AOL-SST-B1` valid.

**Hasil aktual (2026-07-29)**

Diangkat dari sheet, belum diverifikasi ulang terhadap desain. Urutan field diambil apa adanya dari kolom Expected Result di sheet.

---

### AOL-SST-A2 — View salestype lama dari Outlet POS: Pelanggan Default harus kosong

**Frame Figma:** [Sales-type — list view salestype](https://www.figma.com/design/w73yof0cSoUQIDArV8tmh3/Sales-type?node-id=5309-29179)

**Varian:**

| tipe |
|---|
| Dine In |
| TakeAway |
| E-Commerce |
| Gofood IFDS |

**Prasyarat**

- Outlet POS sudah punya salestype data lama sesuai [Data uji bersama](#data-uji-bersama).
- Salestype `<tipe>` belum pernah diisi Pelanggan Default oleh merchant.

**Langkah reproduksi**

1. Ke menu Kasir
2. Ke Outlet POS
3. Ke tipe penjualan
4. Klik **<tipe>** di list tipe penjualan

**Hasil yang diharapkan**

- Muncul list view salestype `<tipe>`.
- Kolom **Pelanggan Default** masih **kosong** — bukan terisi pelanggan mana pun, bukan tanda hubung, bukan "Umum".
- Konfigurasi Service Charge dan Pajak `<tipe>` tampil sesuai data lama (lihat tabel Data uji bersama).

**Hasil aktual (2026-07-29)**

Sudah ada acuan desainnya di Figma (link di atas, dipakai untuk keempat varian di sheet).

---

### AOL-SST-A3 — Cek salestype lama dari menu Tipe Penjualan: Pelanggan Default harus kosong

**Frame Figma:** *(belum ada link di sheet untuk kasus ini)*

**Varian:**

| tipe |
|---|
| Dine In |
| TakeAway |
| E-Commerce |
| Gofood IFDS |

**Prasyarat**

- Sama seperti `AOL-SST-A2`.

**Langkah reproduksi**

1. Ke menu Kasir
2. Ke tipe penjualan
3. Klik **<tipe>** di list tipe penjualan

**Hasil yang diharapkan**

- Form salestype `<tipe>` terbuka.
- Field **Pelanggan Default** masih **kosong**.
- Isinya identik dengan yang tampil lewat jalur Outlet POS (`AOL-SST-A2`) — dua pintu masuk, satu data.

**Hasil aktual (2026-07-29)**

Diangkat dari sheet. Bedanya dengan A2 hanya jalur masuknya: A3 tidak melewati Outlet POS.

---

## B. Membuat salestype baru

### AOL-SST-B1 — Buat salestype PDT tanpa Pelanggan Default dari Outlet POS

**Frame Figma:** *(belum ada link di sheet untuk kasus ini)*

**Prasyarat**

- Outlet POS sudah punya salestype data lama sesuai [Data uji bersama](#data-uji-bersama).
- Belum ada salestype bernama `dinein` (nama yang dipakai di sheet) supaya tidak bentrok nama.

**Langkah reproduksi**

1. Ke menu Kasir
2. Ke Outlet POS
3. Ke tipe penjualan
4. Klik **+Tambah Tipe Penjualan**
5. Isi form: Nama Tipe Penjualan = `dinein`; Kategori Penjualan = dibiarkan kosong; Pelanggan Default = dibiarkan kosong; Tipe Transaksi = **Pembayaran di Tempat**
6. Simpan

**Hasil yang diharapkan**

- Salestype berhasil disimpan.
- Salestype `dinein` muncul di list tipe penjualan dengan Pelanggan Default kosong.
- Tidak ada validasi yang memaksa Kategori Penjualan atau Pelanggan Default diisi — konsisten dengan `AOL-SST-A1` yang menyatakan hanya Nama Tipe Penjualan wajib.

**Hasil aktual (2026-07-29)**

Diangkat dari sheet; baris sumbernya terpotong di screenshot, jadi **copy pesan sukses belum tercatat** (lihat pertanyaan terbuka no. 3). Langkah 6 ("Simpan") juga belum ada di sheet — nama tombol persisnya perlu dikonfirmasi.

---

## Yang di luar scope (sengaja tidak dikerjakan)

- **Edit dan hapus salestype** — belum ada di sheet sumber, kandidat spec terpisah.
- **Migrasi data lama** (kolom `Migrasi Mobile` / `Migrasi Tablet` di sheet) — alur migrasinya belum tertulis di mana pun.
- **Perilaku salestype saat transaksi berjalan** (bagaimana SC dan pajak dihitung di struk) — ini area transaksi, bukan setting.
- **Kategori Penjualan** sebagai fitur tersendiri — di sini cuma dilewati sebagai field opsional.

## Status desain di Figma

| ID | Kasus | Status | Section Figma |
|---|---|---|---|
| `AOL-SST-A1` | Cek field form | **link belum ada** | — |
| `AOL-SST-A2` | View dari Outlet POS | sudah ada acuan | list view salestype (`5309:29179`) |
| `AOL-SST-A3` | Cek dari menu Tipe Penjualan | **link belum ada** | — |
| `AOL-SST-B1` | Buat salestype PDT | **link belum ada** | — |

## Pertanyaan terbuka

| No | Pertanyaan | Menunggu | Terkait |
|---|---|---|---|
| 1 | Konfigurasi SC dan pajak untuk **Gofood IFDS** tidak tertulis di Pre Condition sheet — apa nilainya? | QA / PM | Data uji bersama |
| 2 | Tiga dari empat kasus belum punya link frame Figma. Apakah desainnya ada tapi belum ditempel, atau memang belum digambar? | UI/UX | A1, A3, B1 |
| 3 | Copy pesan sukses setelah simpan salestype — toast atau modal, dan bunyinya apa? Sheet hanya menulis "Berhasil simpan salestype". | UI/UX | B1 |
| 4 | Kepanjangan **PDT** pada judul "Buat salestype PDT" — istilah internal apa? | QA | B1 |
| 5 | Di sheet, Pelanggan Default kosong ditulis sebagai hasil yang **diharapkan**. Konfirmasi: ini memang perilaku benar untuk data lama (tidak diisi otomatis), bukan bug yang sedang didokumentasikan? | PM | A2, A3 |
| 6 | Apakah keempat kasus berlaku di ketiga device (Mobile, Tablet FnB, Tablet Retail)? Kalau tidak, tambahkan baris `**Berlaku di:**` supaya kolom device otomatis diisi `N/A`. | QA | semua |

---

## Lampiran A — Kamus layar

| Nama layar | Isinya | Cara membuka |
|---|---|---|
| **Menu Kasir** | pintu masuk area kasir di POS | menu utama POS |
| **Outlet POS** | pengaturan per outlet, termasuk tipe penjualan | Kasir → Outlet POS |
| **List Tipe Penjualan** | daftar salestype milik outlet, tiap baris bisa dibuka | Outlet POS → Tipe Penjualan |
| **Form Tambah Tipe Penjualan** | form 6 field: Nama Tipe Penjualan*, Kategori Penjualan, Pelanggan Default, Tipe Transaksi, Pajak, Service Charge | tombol **+Tambah Tipe Penjualan** |
| **Menu Tipe Penjualan** | jalur langsung ke salestype tanpa lewat Outlet POS | Kasir → Tipe Penjualan |

## Lampiran B — Peta node Figma

File: `w73yof0cSoUQIDArV8tmh3` (Sales-type). Pola link: `https://www.figma.com/design/w73yof0cSoUQIDArV8tmh3/Sales-type?node-id=<node-pakai-tanda-hubung>`.

| Nama frame | Node | Terkait |
|---|---|---|
| List view salestype (Pelanggan Default kosong) | [`5309:29179`](https://www.figma.com/design/w73yof0cSoUQIDArV8tmh3/Sales-type?node-id=5309-29179) | A2 |

> **Catatan link.** Link di sheet memuat `&t=yR75zbGJDT0Ahq7J-4` — itu token share per-sesi dan tidak perlu disimpan. Yang dibutuhkan hanya `?node-id=`.
