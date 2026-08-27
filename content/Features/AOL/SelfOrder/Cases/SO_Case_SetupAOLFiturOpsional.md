# Self Order — Case: Setup AOL Fitur Opsional (aktivasi QR Self Order)

**Status:** Draft
**Tanggal:** 2026-07-30
**Fitur:** Self Order — sisi **Setup Accurate Online (web)**, halaman **Pengaturan POS › Fitur Opsional**. Bukan aplikasi Accurate POS, bukan aplikasi Self Order pelanggan.
**Prefix ID kasus:** `SO-SET`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · PM (keputusan produk)
**Referensi:** [[SO_PRD_MVP]] · [[SO_Case_QRManagementNegative]] (bagian F & E2 menunjuk ke dokumen ini) · [[Kamus_Langkah_Gherkin]]
**Format dokumen ini mengikuti:** [[Template_Case_Negative]] — alasannya di [[Riset_Workflow_Handoff_UIUX_QA_DEV]]
**Berlaku di:** Web AOL
**Desain:** [Case: Setup AOL Fitur Opsional](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-70739) — file `mAZuRze02w906M6u2EwVWh`, canvas MVP

---

## Cara membaca dokumen ini

Dua lapis:

1. **Acceptance Criteria (AC)** — perilaku yang harus benar, format Given/When/Then. Ini yang dipakai DEV saat implementasi dan jadi patokan sengketa. Nomor ID-nya (`AC-SET.x`) mengikuti konvensi `AC-0X.Y` di [[SO_PRD_MVP]].
2. **Kasus uji** — cara membuktikan AC itu, format Prasyarat / Langkah / Expected / Aktual. Ini yang dieksekusi QA. Setiap kasus menyebut AC mana yang dibuktikannya.

Kenapa dipisah: satu AC bisa butuh beberapa kasus uji (mis. dependency toggle diuji dari dua arah), dan satu kasus uji bisa membuktikan beberapa AC sekaligus. Menggabung keduanya membuat salah satunya selalu tidak lengkap.

**Catatan device.** Halaman ini web AOL, bukan aplikasi POS — jadi kolom `Mobile` / `Tablet FnB` / `Tablet Retail` di sheet test case tidak berlaku (`N/A`). Lihat pertanyaan terbuka no. 7.

### Daftar kasus

| ID | Judul singkat | Membuktikan AC | Status desain |
|---|---|---|---|
| `SO-SET-A1` | State awal: semua fitur OFF, QR Self Order tidak bisa dinyalakan | AC-SET.1, AC-SET.2 | sudah |
| `SO-SET-A2` | Nyalakan Table Management: QR Self Order jadi bisa dinyalakan | AC-SET.2, AC-SET.3 | sudah |
| `SO-SET-A3` | Nyalakan QR Self Order: menu QR muncul di AOL | AC-SET.4, AC-SET.5 | sudah |
| `SO-SET-B1` | Coba nyalakan QR Self Order tanpa Table Management | AC-SET.2 | sudah (state OFF) |
| `SO-SET-B2` | Matikan Table Management saat QR Self Order aktif — aksi destruktif | AC-SET.6 | **belum** |
| `SO-SET-C1` | Sinkronisasi ke aplikasi POS setelah fitur diaktifkan | AC-SET.7 | **belum** |

---

## Acceptance Criteria

| ID | Acceptance Criteria |
|---|---|
| **AC-SET.1** | Given merchant membuka Pengaturan POS › Fitur Opsional pertama kali, When halaman tampil, Then semua toggle di kolom **Manajemen Fitur** dalam kondisi OFF dan semua checkbox di kolom **Pembatasan Fungsi / Flow** tidak tercentang. |
| **AC-SET.2** | Given **Table Management** OFF, When merchant mencoba menyalakan **QR Self Order**, Then toggle tidak berubah menjadi ON dan keterangan "Hanya bisa diaktifkan jika menggunakan Table Management" tetap tampil di bawah labelnya. |
| **AC-SET.3** | Given Table Management OFF, When merchant menyalakan Table Management, Then toggle QR Self Order menjadi bisa dinyalakan tanpa perlu memuat ulang halaman. |
| **AC-SET.4** | Given Table Management ON, When merchant menyalakan QR Self Order, Then kedua toggle tampil ON dan tidak ada toggle lain yang berubah. |
| **AC-SET.5** | Given sebuah fitur opsional baru dinyalakan, When perubahan tersimpan, Then menu fitur itu muncul di sidebar AOL — Table Management dan QR Self Order masing-masing menambah satu ikon menu. |
| **AC-SET.6** | Given QR Self Order ON dan sudah ada QR meja ter-generate, When merchant mematikan Table Management, Then QR Self Order ikut OFF, seluruh QR yang sudah ada **hangus permanen**, dan merchant diberi konfirmasi lebih dulu yang menyebut jumlah QR aktif yang akan hangus. |
| **AC-SET.7** | Given QR Self Order baru dinyalakan di AOL, When aplikasi POS belum melakukan sinkronisasi, Then menu QR Management di POS belum tampil, dan tidak ada pesan error apa pun di kedua sisi — kondisi ini normal dan sementara. |
| **AC-SET.8** | Given merchant hanya punya sebagian hak akses pengaturan, When membuka Fitur Opsional, Then perubahan yang tidak boleh dia lakukan tidak bisa disimpan di sisi server, bukan hanya disembunyikan di UI. |

> **AC-SET.8 belum punya kasus uji di dokumen ini** karena aturan hak akses di sisi AOL belum tertulis di mana pun. Dicatat supaya tidak hilang — lihat pertanyaan terbuka no. 6.

## Prinsip

- **Dependency dinyatakan, bukan disembunyikan.** QR Self Order bergantung pada Table Management. Toggle-nya tetap tampil (tidak dihilangkan) supaya merchant tahu fiturnya ada dan tahu syaratnya — beda dari aturan "hilangkan, jangan matikan" di [[SO_Case_QRManagementNegative]] yang berlaku untuk **hak akses**, bukan untuk dependency fitur.
- **Aksi destruktif wajib dikonfirmasi dengan angka.** Mematikan Table Management menghanguskan QR yang sudah dicetak dan ditempel di meja. Konfirmasinya harus menyebut jumlahnya, karena "beberapa QR" tidak cukup untuk membuat orang berhenti.
- **Sinkronisasi yang belum jalan bukan error.** Jeda antara "diaktifkan di AOL" dan "muncul di POS" adalah keadaan normal. Menampilkan pesan gagal di jeda itu justru membuat merchant mengira ada yang rusak.

---

## A. Menyalakan fitur

### SO-SET-A1 — State awal: semua fitur opsional OFF dan QR Self Order belum bisa dinyalakan

**Membuktikan:** AC-SET.1, AC-SET.2
**Frame Figma:** [Default](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-72511)

**Prasyarat**

- Merchant baru, belum pernah mengubah Fitur Opsional.
- Login AOL sebagai user yang boleh mengubah Pengaturan POS.

**Langkah reproduksi**

1. Buka AOL → tab **Pengaturan POS**
2. Pilih **Kantor Pusat** (atau cabang yang diuji)
3. Buka **Fitur Opsional**
4. Perhatikan kolom **Manajemen Fitur** dan kolom **Pembatasan Fungsi / Flow**

**Hasil yang diharapkan**

Kolom **Manajemen Fitur** menampilkan 10 toggle, semuanya **OFF**, dengan urutan:

| # | Label | Keterangan di bawah label |
|---|---|---|
| 1 | Pesanan Draft | Anda dapat mengatur Hak Akses pada peran karyawan |
| 2 | Tipe Penjualan | (Dine In, Take Away, Gofood, dll) |
| 3 | Transaksi Piutang | Anda dapat mengatur Hak Akses pada peran karyawan |
| 4 | Split Payment | — |
| 5 | Open Bill | — |
| 6 | Table Management | (Pelajari lebih lanjut) |
| 7 | Kitchen Display System | (Pelajari lebih lanjut) |
| 8 | Pembatasan Pesanan | — |
| 9 | **QR Self Order** | Hanya bisa diaktifkan jika menggunakan Table Management |
| 10 | Aktifkan Membership Program (Bliss) | Ciptakan Hubungan yang lebih kuat dengan pelanggan dan mendorong penjualan lebih tinggi |

Kolom **Pembatasan Fungsi / Flow** menampilkan 4 checkbox, semuanya tidak tercentang: Ubah Harga Jual · Diskon Manual Barang & Transaksi · Wajib Menggunakan Nama Pelanggan / Alias · Tampilkan Konfirmasi Pembayaran.

Toggle **QR Self Order** tampil dalam kondisi **tidak bisa ditekan** (visualnya lebih pudar dari toggle lain yang OFF) karena Table Management masih OFF.

**Hasil aktual (2026-07-30)**

Sudah tergambar. Satu hal perlu dikonfirmasi: pada frame ini toggle QR Self Order **memang digambar lebih pudar** dari toggle OFF lainnya — perlu dipastikan itu state `disabled` yang disengaja, bukan sekadar perbedaan render (pertanyaan terbuka no. 2).

---

### SO-SET-A2 — Menyalakan Table Management membuka QR Self Order dan menambah menu di sidebar

**Membuktikan:** AC-SET.2, AC-SET.3
**Frame Figma:** [Table Management ON, QR Self Order masih OFF](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-71236)

**Prasyarat**

- Kondisi awal seperti `SO-SET-A1` (semua toggle OFF).

**Langkah reproduksi**

1. Buka **Pengaturan POS › Fitur Opsional**
2. Nyalakan toggle **Table Management**
3. Perhatikan toggle **QR Self Order** — apakah sudah bisa ditekan
4. Perhatikan sidebar ikon di sisi kiri halaman

**Hasil yang diharapkan**

- Toggle Table Management tampil **ON** (biru).
- Toggle **QR Self Order** kini **bisa ditekan**, tapi masih **OFF** — menyalakan Table Management tidak otomatis menyalakan QR Self Order.
- Keterangan "Hanya bisa diaktifkan jika menggunakan Table Management" **tetap tampil** (keterangan permanen, bukan pesan error).
- Sidebar AOL **menambah satu ikon menu** untuk Table Management.
- Tidak ada toggle lain yang berubah.

**Hasil aktual (2026-07-30)**

Sudah tergambar, termasuk ikon baru di sidebar. Apakah perubahan langsung tersimpan atau menunggu tombol simpan (ikon disket di kanan atas) belum tergambar — pertanyaan terbuka no. 3.

---

### SO-SET-A3 — Menyalakan QR Self Order menambah menu QR di AOL

**Membuktikan:** AC-SET.4, AC-SET.5
**Frame Figma:** [Table Management ON + QR Self Order ON](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-70741)

**Prasyarat**

- Table Management sudah ON (hasil `SO-SET-A2`).

**Langkah reproduksi**

1. Pada **Fitur Opsional**, nyalakan toggle **QR Self Order**
2. Perhatikan kedua toggle
3. Perhatikan sidebar ikon di sisi kiri halaman
4. Simpan (kalau memang butuh disimpan — lihat pertanyaan terbuka no. 3)

**Hasil yang diharapkan**

- **Table Management** dan **QR Self Order** dua-duanya tampil **ON**.
- Sidebar AOL menampilkan **ikon menu QR** (tambahan dari ikon Table Management), jadi ada **dua ikon baru** dibanding state awal.
- Tidak ada toggle atau checkbox lain yang berubah.
- Keterangan di bawah QR Self Order tetap tampil apa adanya.

**Hasil aktual (2026-07-30)**

Sudah tergambar, dua ikon baru terlihat di sidebar.

---

## B. Kasus negatif & aksi destruktif

### SO-SET-B1 — QR Self Order tidak bisa dinyalakan selama Table Management OFF

**Membuktikan:** AC-SET.2
**Frame Figma:** [Default](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-72511) — tidak ada frame khusus untuk percobaan gagalnya

**Prasyarat**

- Table Management dalam kondisi **OFF**.

**Langkah reproduksi**

1. Buka **Pengaturan POS › Fitur Opsional**
2. Pastikan **Table Management** OFF
3. Tekan toggle **QR Self Order**
4. Muat ulang halaman, lalu periksa lagi kondisi toggle QR Self Order

**Hasil yang diharapkan**

- Toggle QR Self Order **tidak berubah** menjadi ON.
- Keterangan "Hanya bisa diaktifkan jika menggunakan Table Management" tetap tampil.
- **Tidak ada modal atau toast error.** Keterangan permanen di bawah label sudah cukup — memberi pesan error untuk sesuatu yang syaratnya sudah tertulis di layar hanya menambah kebisingan.
- Setelah muat ulang, QR Self Order tetap OFF (tidak ada perubahan yang diam-diam tersimpan di server).

**Hasil aktual (2026-07-30)**

Perilaku "tidak bisa ditekan" tergambar lewat state toggle di frame Default, tapi **tidak ada frame khusus** yang menunjukkan percobaan menekannya. Langkah 4 (cek setelah reload) belum pernah diuji dan penting: dependency yang cuma dijaga di UI biasanya tetap bisa ditembus lewat request langsung.

---

### SO-SET-B2 — Mematikan Table Management saat QR Self Order aktif: QR hangus permanen

**Membuktikan:** AC-SET.6
**Frame Figma:** **belum digambar** — rancangan modal konfirmasinya belum ada di canvas mana pun. Konteksnya dicatat di [[SO_Case_QRManagementNegative]] bagian F.

**Prasyarat**

- Table Management ON dan QR Self Order ON.
- Sudah ada minimal 3 QR meja ter-generate di POS (mis. AA - 01, AA - 02, AA - 03), dan idealnya sudah dicetak.

**Langkah reproduksi**

1. Buka **Pengaturan POS › Fitur Opsional**
2. Matikan toggle **Table Management**
3. Perhatikan konfirmasi yang muncul
4. Lanjutkan mematikan
5. Buka aplikasi POS, sinkronkan, lalu buka QR Management
6. Nyalakan kembali Table Management dan QR Self Order di AOL, sinkronkan lagi, lalu periksa Daftar QR Aktif

**Hasil yang diharapkan**

- Pada langkah 3 muncul **konfirmasi destruktif** yang menyebut **jumlah QR aktif yang akan hangus** (mis. "3 QR meja akan hangus dan harus dibuat serta dicetak ulang").
- Setelah dikonfirmasi: toggle **QR Self Order ikut OFF** otomatis.
- Pada langkah 5: menu QR Management tidak lagi tersedia di POS.
- Pada langkah 6: **Daftar QR Aktif kosong** — QR lama tidak kembali. Semua meja harus di-generate, diunduh, dan dicetak ulang.
- Kalau merchant membatalkan konfirmasi: **tidak ada apa pun yang berubah** — Table Management tetap ON, QR Self Order tetap ON, QR tetap ada.

**Hasil aktual (2026-07-30)**

**Belum digambar.** Ini celah paling berisiko di dokumen ini: aksinya menghanguskan QR fisik yang sudah ditempel di meja, tapi belum ada rancangan konfirmasinya. Modalnya harus mengikuti konvensi modal AOL (terang/biru), bukan pola dialog mobile POS.

---

## C. Sinkronisasi ke aplikasi POS

### SO-SET-C1 — Jeda sinkronisasi setelah fitur diaktifkan bukan error

**Membuktikan:** AC-SET.7
**Frame Figma:** **belum digambar** — tidak ada state jeda sinkronisasi di canvas. Sisi POS-nya dicatat sebagai non-issue di [[SO_Case_QRManagementNegative]] (`SO-QRN-E2`).

**Prasyarat**

- Aplikasi POS sudah login ke database yang sama.
- QR Self Order **baru saja** dinyalakan di AOL dan POS **belum** melakukan sinkronisasi.

**Langkah reproduksi**

1. Nyalakan Table Management + QR Self Order di AOL
2. Tanpa menyinkronkan, buka aplikasi POS dan cari menu **QR Management**
3. Jalankan sinkronisasi di POS
4. Cari menu **QR Management** lagi

**Hasil yang diharapkan**

- Langkah 2: menu QR Management **belum tampil**, dan **tidak ada pesan error apa pun** di POS maupun AOL.
- Langkah 4: setelah sinkronisasi, menu QR Management tampil dan bisa dibuka.
- Karyawan yang sudah punya permission "Mengelola QR Self Order" tapi membuka POS sebelum sinkronisasi **tidak** melihat pesan khusus — perilaku ini sengaja, jangan dilaporkan sebagai bug (lihat `SO-QRN-E2`).

**Hasil aktual (2026-07-30)**

Keputusan "tidak perlu pesan apa pun" sudah diambil di sisi POS. Yang belum: **apakah AOL memberi tahu merchant bahwa POS perlu disinkronkan** setelah fitur dinyalakan. Sekarang tidak ada petunjuk apa pun di layar AOL — pertanyaan terbuka no. 4.

---

## Yang di luar scope (sengaja tidak dikerjakan)

- **Fitur opsional lain** (Pesanan Draft, Tipe Penjualan, Transaksi Piutang, Split Payment, Open Bill, KDS, Pembatasan Pesanan, Membership Bliss) — dokumen ini hanya menguji QR Self Order dan dependency-nya ke Table Management. Toggle lain diuji sebagai "tidak berubah".
- **Kolom Pembatasan Fungsi / Flow** — tidak berhubungan dengan Self Order; hanya diuji sebagai "tidak berubah".
- **Pengaturan QR di sisi POS** (generate, cetak, hapus, ekspor) — sudah ada di [[SO_Case_QRManagementNegative]].
- **Aplikasi Self Order pelanggan** — menu, keranjang, konfirmasi, pembayaran.
- **Hak akses di sisi AOL** — belum ada aturannya (AC-SET.8 dicatat, kasusnya belum dibuat).

## Status desain di Figma

| ID | Kasus | Status | Frame |
|---|---|---|---|
| `SO-SET-A1` | State awal semua OFF | sudah | **Default** |
| `SO-SET-A2` | Table Management ON | sudah | **Self Order Dan Table management** (frame pertama) |
| `SO-SET-A3` | Keduanya ON | sudah | **Self Order Dan Table management** (frame kedua) |
| `SO-SET-B1` | Percobaan nyalakan tanpa Table Management | sebagian — state OFF ada, percobaan gagalnya tidak digambar | **Default** |
| `SO-SET-B2` | Matikan Table Management (destruktif) | **belum** | — |
| `SO-SET-C1` | Jeda sinkronisasi | **belum** | — |

## Temuan pada canvas

Hal-hal yang ditemukan saat membaca frame, perlu dibereskan di Figma:

| # | Temuan | Kenapa penting |
|---|---|---|
| 1 | **Nama layer teks tertulis "QR Menu", padahal teks yang tampil "QR Self Order".** | Figma MCP dan alat codegen membaca **nama layer**, bukan piksel. Selama namanya "QR Menu", hasil generate AI akan memakai label yang salah. Ini bukan soal kerapian — ini bug yang menjalar ke kode. |
| 2 | **Dua frame bernama sama: "Self Order Dan Table management"**, padahal state-nya berbeda (satu Table Management saja, satu keduanya ON). | QA dan DEV tidak bisa membedakan keduanya tanpa membuka satu-satu. Usul: ganti jadi "Table Management ON" dan "Table Management + QR Self Order ON". |
| 3 | **Copy: "Hanya Bisa diaktifkan jika menggunakan Table Management"** — huruf B pada "Bisa" kapital di tengah kalimat. | Perlu jadi "Hanya bisa diaktifkan…". Dokumen ini sudah memakai bentuk yang benar di AC dan expected. |
| 4 | **Section ini tidak punya frame catatan** (Precondition / Trigger / Expected Result / System Validation / Post-condition), padahal section di canvas *Flow · Close Bill* punya. | QA yang membuka canvas ini tidak tahu apa yang seharusnya terjadi. Dokumen ini menutup sementara celah itu, tapi catatan di canvas tetap perlu supaya nyambung saat desain dibaca langsung. |
| 5 | **Tidak ada state untuk aksi destruktif** (mematikan Table Management). | Lihat `SO-SET-B2` — ini yang paling berisiko. |
| 6 | **Daftar toggle beda antar file.** Frame `258:2645` (file `hl2CORgtDUUUo7A1Gj86mz` *Pick-Up*, halaman `Setup AOL`) menggambarkan kolom **Manajemen Fitur** dengan **`Uang Muka`** dan **`Queue Number`**, tapi **tanpa `Pembatasan Pesanan` dan tanpa `QR Self Order`** — sedangkan frame acuan dokumen ini (`1993:72511`) sebaliknya. | Dua gambar dipakai jadi acuan spec untuk layar yang sama. QA tidak tahu jumlah dan urutan toggle yang benar, dan `Queue Number` — gerbang fitur nomor pick up ([[SO_Case_NomorPickUpDiSukses]], [[PCK_Case_GabungSemuaChannel]]) — belum masuk daftar mana pun di dokumen ini. |

## Pertanyaan terbuka

| No | Pertanyaan | Menunggu | Terkait |
|---|---|---|---|
| 1 | Nama fitur final: **"QR Self Order"** (yang tampil) atau **"QR Menu"** (nama layer)? Ini juga bertabrakan dengan drift judul halaman "Self QR Management" vs "QR Management" di sisi POS. | PM | A1, temuan 1 |
| 2 | Toggle QR Self Order pada frame Default: benar-benar state `disabled`, atau hanya OFF biasa? Kalau disabled, apakah ada tooltip saat di-hover? | UI/UX | A1, B1 |
| 3 | Perubahan toggle **langsung tersimpan**, atau harus menekan tombol simpan (ikon disket di kanan atas)? Kalau harus disimpan, apa yang terjadi kalau merchant keluar tanpa menyimpan? | DEV / UI/UX | A2, A3 |
| 4 | Apakah AOL perlu memberi tahu bahwa **POS harus disinkronkan** setelah fitur dinyalakan? Sekarang tidak ada petunjuk apa pun. | PM | C1 |
| 5 | Fitur Opsional ini berlaku **per cabang** atau **global**? Di layar ada tab "Kantor Pusat" dan field "Cabang: Alam Sutera". Kalau per cabang, semua kasus di dokumen ini perlu varian cabang. | PM / DEV | semua |
| 6 | Aturan **hak akses di sisi AOL** untuk mengubah Fitur Opsional — siapa yang boleh, dan apakah dicek di server? | PM / DEV | AC-SET.8 |
| 7 | Sheet test case QA belum punya kolom device untuk **web AOL** (yang ada Mobile / Tablet FnB / Tablet Retail). Tambah kolom `Web AOL`, atau pakai baris terpisah? | QA | semua |
| 8 | Saat Table Management dimatikan lalu dinyalakan lagi, **data meja** ikut hangus atau hanya QR-nya? Dokumen ini hanya memastikan QR hangus. | PM / DEV | B2 |
| 9 | Daftar **Manajemen Fitur** yang final yang mana — versi dokumen ini (10 toggle, ada `Pembatasan Pesanan` + `QR Self Order`) atau versi frame `258:2645` (ada `Uang Muka` + `Queue Number`)? Termasuk: `Queue Number` masuk di urutan berapa, dan apakah dia punya dependency seperti QR Self Order. | PM / UI/UX | temuan 6, semua |

---

## Lampiran A — Kamus layar

| Nama layar | Isinya | Cara membuka |
|---|---|---|
| **Pengaturan POS › Fitur Opsional** | dua kolom: **Manajemen Fitur** (10 toggle) dan **Pembatasan Fungsi / Flow** (4 checkbox); tombol simpan & hapus di kanan atas | AOL → tab **Pengaturan POS** → pilih Kantor Pusat/cabang → **Fitur Opsional** |
| **Sidebar ikon AOL** | kolom ikon di sisi kiri; bertambah satu ikon setiap fitur opsional dinyalakan | selalu tampil di halaman Pengaturan POS |
| **QR Management (POS)** | halaman generate/cetak/hapus QR meja di aplikasi Accurate POS — muncul setelah QR Self Order aktif **dan** POS disinkronkan | POS → Pengaturan → QR Management. Detailnya di [[SO_Case_QRManagementNegative]] |

## Lampiran B — Peta node Figma

File: `mAZuRze02w906M6u2EwVWh` (Self-Order). Pola link: `https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=<node-pakai-tanda-hubung>`.

| Nama section / frame | Node | Terkait |
|---|---|---|
| Case: Setup AOL Fitur Opsional (section) | [`1993:70739`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-70739) | semua |
| Default — semua toggle OFF | [`1993:72511`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-72511) | A1, B1 |
| Table Management ON, QR Self Order OFF | [`1993:71236`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-71236) | A2 |
| Table Management + QR Self Order ON | [`1993:70741`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-70741) | A3 |
| Teks toggle (nama layer masih "QR Menu") | [`1993:73405`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-73405) | temuan 1 |

**Node di luar file ini.** Layar Fitur Opsional juga digambar di file `hl2CORgtDUUUo7A1Gj86mz` (`Pick-Up`), halaman `Setup AOL`: frame `Fitur Opsional` [`258:2645`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=258-2645) → kartu `Feature Management` [`258:2732`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=258-2732) → baris toggle `Queue Number` [`258:2821`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=258-2821). Isi daftarnya beda dari frame di file ini — lihat temuan 6.
