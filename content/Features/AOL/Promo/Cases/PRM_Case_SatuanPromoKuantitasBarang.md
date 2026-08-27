# Promo — Satuan Promo pada Syarat Berdasarkan Kuantitas Barang (AOL)

**Status:** Draft
**Tanggal:** 2026-08-20
**Fitur:** Pengisian otomatis field Satuan pada form Promo di AOL, untuk tipe syarat **Berdasarkan Kuantitas Barang**, di sisi **Syarat Promo** maupun **Hasil Promo**. Tidak mencakup evaluasi promo di sisi POS/kasir, tidak mencakup tipe syarat promo lain, tidak mencakup perhitungan nominal diskon.
**Prefix ID kasus:** `PRM-SAT`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · PM (keputusan produk)
**Referensi:** [[Riset_Workflow_Handoff_UIUX_QA_DEV]], [[Template_Case_Negative]]
**Format dokumen ini mengikuti:** [[Riset_Workflow_Handoff_UIUX_QA_DEV]]
**Desain:** Belum ada frame Figma untuk area ini. Kolom "Frame Figma" sengaja dikosongkan sampai desain tersedia.

---

## Cara membaca dokumen ini

Setiap kasus ditulis dengan lima bagian yang selalu sama: **Judul**, **Prasyarat**, **Langkah**, **Hasil yang diharapkan**, **Hasil aktual**.

Kolom "Hasil aktual" berisi kondisi terakhir yang diketahui saat dokumen ditulis. QA menimpanya dengan hasil uji nyata saat build tersedia: tulis "Sesuai", atau gejala sebenarnya.

Semua kasus memakai satu set data uji yang sama, didefinisikan sekali di bagian **Data uji**. Jangan mengganti barang di tengah pengujian — beberapa kasus bergantung pada angka konversi yang spesifik.

---

## Latar belakang

Di AOL, tiap barang di master **Barang & Jasa** punya satu atau lebih satuan. **Satuan pertama yang diinput otomatis menjadi satuan terkecil** barang tersebut, dan satuan berikutnya adalah satuan konversi (mis. 1 Box = 24 PCS).

Pada form Promo dengan tipe syarat **Berdasarkan Kuantitas Barang**, user memilih sejumlah barang lalu mengisi angka kuantitas. Angka itu butuh satuan supaya punya arti — "beli minimal 10" itu 10 apa.

Perubahan yang dispesifikasikan dokumen ini: **field Satuan terisi otomatis** berdasarkan satuan barang yang dipilih, tidak lagi diisi manual dari nol.

Celah yang ditutup dokumen ini adalah perilaku saat barang-barang yang dipilih **tidak punya satuan yang seragam** — kondisi yang tidak punya jawaban jelas sebelumnya, dan yang paling mungkin menghasilkan promo salah hitung kalau dibiarkan ditebak developer.

Yang **tidak** dibahas: bagaimana promo dievaluasi di kasir, apakah kuantitas dijumlah lintas barang atau dicek per barang (lihat Pertanyaan terbuka #1), dan perhitungan nominal potongan.

---

## Keputusan produk

Ini sumber kebenaran kalau ada beda tafsir saat implementasi atau pengujian.

| Topik | Keputusan |
|---|---|
| Satuan terkecil | Satuan pertama yang diinput di master Barang & Jasa. Tidak bisa dipilih ulang di form promo. |
| Satu promo, satu satuan | Satu syarat promo hanya punya satu satuan aktif, berlaku untuk semua barang di daftarnya. |
| Penentuan satuan aktif | Satuan **terkecil** dari **irisan** satuan seluruh barang bersatuan di daftar. Bukan satuan terkecil barang pertama saja. |
| Menambah barang | Tidak pernah ditolak saat ditambahkan. Barang bebas masuk daftar; validasi terjadi di titik Simpan. |
| Identitas satuan | Dicocokkan **by ID satuan**, bukan by tulisan. "PCS" dan "pcs" dengan ID berbeda adalah dua satuan berbeda. |
| Field Satuan | Boleh diubah user. Satuan terkecil hanya nilai awal, bukan kunci. |
| Isi dropdown | Irisan satuan seluruh barang bersatuan di daftar. Nilai field selalu ada di dropdown-nya. |
| Nilai pilihan user | Dipertahankan selama masih ada di irisan. Kalau gugur, turun ke satuan terkecil irisan disertai peringatan. |
| Kuantitas saat satuan berubah | **Tidak dikonversi.** Angka tetap apa adanya. Peringatan wajib menyebut angka sekaligus satuan barunya. |
| Barang tanpa satuan | Selalu diterima, dikecualikan dari perhitungan irisan, tidak pernah mengunci satuan. Kalau semua barang tanpa satuan → Satuan = "Tanpa satuan". |
| Hasil Promo | Aturan identik dengan Syarat Promo, tapi dihitung terpisah. Satuan Hasil tidak harus sama dengan Satuan Syarat. |
| Promo lama | Promo yang dibuat sebelum fitur ini dibiarkan apa adanya. Tidak ada migrasi, tidak ada pengisian ulang saat dibuka. |
| Master Barang & Jasa | Satuan yang sedang dipakai promo aktif tidak bisa diubah atau dihapus. Ditolak dengan pesan menyebut nama promonya. |
| Teks pesan | Teks pada dokumen ini adalah **usulan**, belum final. Usulan PM semula berbunyi *"Item {Nama item} memiliki satuan yang berbeda dengan satuan item pertama"* — teks itu tidak lagi akurat karena acuannya bukan barang pertama melainkan irisan. Menunggu keputusan copy final. |

---

## Prinsip

Empat aturan ini menjelaskan **kenapa** kasus-kasus di bawah dirancang begitu. Kalau QA menemukan kasus baru yang belum tertulis, perilaku benarnya bisa diperkirakan dari sini tanpa bertanya.

1. **Auto-isi boleh menebak kalau tebakan salah cuma bikin repot; tidak boleh menebak kalau tebakan salah mengubah nilai uang.** Sistem tidak pernah menebak angka kuantitas, dan setiap perubahan satuan otomatis wajib membawa peringatan yang menyebut angkanya.
2. **Nilai field selalu ada di dropdown-nya.** Field yang menampilkan nilai yang tidak ada di daftar pilihannya sendiri adalah bug, bukan keadaan sah.
3. **Dropdown kosong hanya sah kalau memang tidak ada satuan bersama.** Di semua kondisi lain, dropdown kosong adalah bug.
4. **Barang tanpa satuan tidak pernah membatasi apa pun.** Dia ikut ke mana pun satuan aktif pergi, dan tidak pernah menentukannya kecuali seluruh daftar tidak bersatuan.

---

## Data uji

Setup master **Barang & Jasa** yang dipakai seluruh kasus di dokumen ini. Buat sekali sebelum eksekusi.

| Barang | Satuan (urut input) | Konversi ke satuan terkecil |
|---|---|---|
| Kopi Susu | PCS | — |
| Nasi Goreng | PCS | — |
| Mie Goreng | PCS | — |
| Es Teh | PCS | — |
| Ayam Bakar | PCS | — |
| Roti Tawar | PCS, Box | 1 Box = 10 PCS |
| Air Mineral | PCS, Box, Lusin | 1 Box = 24 PCS · 1 Lusin = 12 PCS |
| Teh Botol | PCS, Lusin | 1 Lusin = 12 PCS |
| Snack Kiloan | Box | — |
| Susu Kotak | Lusin | — |
| Keripik A | pcs *(huruf kecil, ID satuan berbeda dari PCS)* | — |
| Biaya Layanan | *(tanpa satuan)* | — |
| Biaya Kemasan | *(tanpa satuan)* | — |

**Catatan penting untuk QA:** "PCS" pada barang lain dan "pcs" pada Keripik A harus benar-benar dua record satuan berbeda di master. Kalau di lingkungan uji keduanya ternyata satu record yang sama, kasus `PRM-SAT-B6` tidak valid dan harus dilaporkan sebagai blocker data, bukan sebagai lolos.

---

## Daftar kasus

| ID | Judul singkat | Wadah pesan | Status desain |
|---|---|---|---|
| `PRM-SAT-A1` | Daftar kosong — field nonaktif | tidak ada | belum |
| `PRM-SAT-A2` | Satu barang satuan tunggal | tidak ada | belum |
| `PRM-SAT-A3` | Lima barang satuan tunggal sama | tidak ada | belum |
| `PRM-SAT-A4` | Satu barang multi-satuan | tidak ada | belum |
| `PRM-SAT-A5` | Semua barang tanpa satuan | tidak ada | belum |
| `PRM-SAT-A6` | Tanpa satuan duluan, lalu bersatuan | tidak ada | belum |
| `PRM-SAT-A7` | Bersatuan duluan, lalu tanpa satuan | tidak ada | belum |
| `PRM-SAT-B1` | Irisan menyusut, satuan aktif bertahan | tidak ada | belum |
| `PRM-SAT-B2` | Irisan menyusut, satuan aktif gugur | inline warning | belum |
| `PRM-SAT-B3` | Tidak ada satuan bersama | modal saat Simpan | belum |
| `PRM-SAT-B4` | Irisan melebar setelah barang dihapus | tidak ada | belum |
| `PRM-SAT-B5` | Barang tanpa satuan tidak mengubah irisan | tidak ada | belum |
| `PRM-SAT-B6` | "PCS" vs "pcs" — ID satuan berbeda | modal saat Simpan | belum |
| `PRM-SAT-C1` | Pilihan user bertahan | tidak ada | belum |
| `PRM-SAT-C2` | Pilihan user gugur dari irisan | inline warning | belum |
| `PRM-SAT-C3` | Barang penyebab dihapus — tidak naik balik | tidak ada | belum |
| `PRM-SAT-C4` | Daftar dikosongkan — auto-isi hidup lagi | tidak ada | belum |
| `PRM-SAT-D1` | Ganti satuan manual — angka tidak dikonversi | inline warning | belum |
| `PRM-SAT-D2` | Satuan turun otomatis — angka tidak dikonversi | inline warning | belum |
| `PRM-SAT-D3` | Isi wajib pada teks peringatan | inline warning | belum |
| `PRM-SAT-E1` | Simpan berhasil | toast | belum |
| `PRM-SAT-E2` | Simpan diblokir — tidak ada satuan bersama | modal | belum |
| `PRM-SAT-E3` | Modal memblokir, promo tidak tersimpan | modal | belum |
| `PRM-SAT-E4` | Modal menyebut semua barang bermasalah | modal | belum |
| `PRM-SAT-F1` | Hasil Promo punya satuan sendiri | tidak ada | belum |
| `PRM-SAT-F2` | Satuan Hasil beda dari Syarat | tidak ada | belum |
| `PRM-SAT-F3` | Irisan Hasil dihitung terpisah | tidak ada | belum |
| `PRM-SAT-F4` | Simpan diblokir karena sisi Hasil | modal | belum |
| `PRM-SAT-G1` | Buka ulang — satuan tidak dihitung ulang | tidak ada | belum |
| `PRM-SAT-G2` | Buka ulang lalu tambah barang | inline warning | belum |
| `PRM-SAT-H1` | Promo lama dibuka — nilai dipertahankan | tidak ada | belum |
| `PRM-SAT-H2` | Promo lama disimpan ulang tanpa perubahan | tidak ada | belum |
| `PRM-SAT-H3` | Promo lama ditambah barang baru | inline warning | belum |
| `PRM-SAT-I1` | Master menolak ubah satuan terpakai | modal | belum |
| `PRM-SAT-I2` | Master menolak hapus satuan terpakai | modal | belum |
| `PRM-SAT-I3` | Promo non-aktif — master mengizinkan | tidak ada | belum |
| `PRM-SAT-I4` | Tambah satuan baru ke barang — diizinkan | tidak ada | belum |

---

## A. Nilai awal auto-isi

### PRM-SAT-A1 — Form Promo, daftar barang masih kosong, field Satuan harus nonaktif

**Prasyarat**
- User berada di form buat Promo baru
- Tipe syarat dipilih: Berdasarkan Kuantitas Barang
- Belum ada barang yang ditambahkan

**Langkah**
1. Buka form Promo baru
2. Pilih tipe syarat Berdasarkan Kuantitas Barang
3. Perhatikan field Satuan pada blok Syarat Promo

**Hasil yang diharapkan**
- Field Satuan kosong dan **nonaktif** — tidak bisa diklik, dropdown tidak bisa dibuka
- Tombol Simpan tidak aktif

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-A2 — Satu barang bersatuan tunggal, Satuan terisi otomatis tanpa aksi user

**Prasyarat**
- Form Promo baru, tipe syarat Berdasarkan Kuantitas Barang
- Daftar barang kosong

**Langkah**
1. Tambahkan barang **Kopi Susu** (satuan: PCS)
2. Perhatikan field Satuan tanpa menyentuhnya

**Hasil yang diharapkan**
- Field Satuan otomatis terisi **PCS**
- Field aktif dan bisa diklik
- Dropdown berisi tepat satu pilihan: `PCS`
- Tidak ada pesan peringatan apa pun

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-A3 — Lima barang bersatuan sama, jumlah barang tidak mengubah perilaku

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Kopi Susu**, **Nasi Goreng**, **Mie Goreng**, **Es Teh**, **Ayam Bakar** (semuanya PCS saja)
2. Perhatikan field Satuan setelah tiap penambahan

**Hasil yang diharapkan**
- Field Satuan terisi **PCS** sejak barang pertama dan tidak berubah sampai barang kelima
- Dropdown tetap berisi `PCS` saja di setiap tahap
- Tidak ada peringatan di tahap mana pun

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-A4 — Satu barang multi-satuan, yang terisi adalah satuan terkecilnya

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Air Mineral** (satuan: PCS, Box, Lusin — PCS adalah satuan terkecil)
2. Perhatikan field Satuan, lalu buka dropdown-nya

**Hasil yang diharapkan**
- Field Satuan terisi **PCS**, bukan Box dan bukan Lusin
- Dropdown berisi tiga pilihan: `PCS`, `Box`, `Lusin`
- Urutan tampil dropdown mengikuti urutan input di master

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-A5 — Semua barang tanpa satuan, field terisi "Tanpa satuan"

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Biaya Layanan** (tanpa satuan)
2. Tambahkan **Biaya Kemasan** (tanpa satuan)
3. Perhatikan field Satuan

**Hasil yang diharapkan**
- Field Satuan terisi **Tanpa satuan**
- Dropdown berisi tepat satu pilihan: `Tanpa satuan`
- Tombol Simpan aktif — kondisi ini sah, bukan error

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-A6 — Barang tanpa satuan dipilih duluan, barang bersatuan menetapkan satuan aktif

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Biaya Layanan** (tanpa satuan) — pastikan field Satuan menampilkan "Tanpa satuan"
2. Tambahkan **Kopi Susu** (PCS)
3. Perhatikan field Satuan

**Hasil yang diharapkan**
- Field Satuan berubah dari "Tanpa satuan" menjadi **PCS**
- Dropdown berisi `PCS` saja
- Biaya Layanan **tetap ada** di daftar barang, tidak dikeluarkan
- Barang tanpa satuan tidak pernah mengunci satuan aktif

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-A7 — Barang bersatuan duluan, barang tanpa satuan tidak mengubah apa pun

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Kopi Susu** (PCS) — field Satuan terisi PCS
2. Tambahkan **Biaya Layanan** (tanpa satuan)
3. Perhatikan field Satuan dan dropdown

**Hasil yang diharapkan**
- Field Satuan tetap **PCS**
- Dropdown tetap berisi `PCS` saja
- Tidak ada peringatan
- Biaya Layanan masuk daftar tanpa pesan apa pun

**Hasil aktual**
Belum diuji.

---

## B. Irisan satuan dan isi dropdown

### PRM-SAT-B1 — Barang kedua menyusutkan dropdown, satuan aktif tetap bertahan

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Air Mineral** (PCS, Box, Lusin) — field Satuan terisi PCS, dropdown berisi 3 pilihan
2. Tambahkan **Roti Tawar** (PCS, Box)
3. Perhatikan field Satuan dan buka dropdown

**Hasil yang diharapkan**
- Satuan yang dimiliki keduanya: PCS dan Box. Lusin gugur karena Roti Tawar tidak punya
- Field Satuan **tetap PCS** — PCS masih satuan terkecil dari irisan
- Dropdown menyusut menjadi `PCS`, `Box`. **Lusin tidak lagi muncul**
- Tidak ada peringatan — nilai field tidak berubah

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-B2 — Barang kedua menggugurkan satuan aktif, field turun disertai peringatan

Ini kasus inti dari fitur ini. Kalau hanya satu kasus yang sempat diuji, uji yang ini.

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Air Mineral** (PCS, Box, Lusin) — field Satuan terisi PCS
2. Isi Kuantitas dengan **3**
3. Tambahkan **Snack Kiloan** (Box saja)
4. Perhatikan field Satuan, field Kuantitas, dropdown, dan pesan yang muncul

**Hasil yang diharapkan**
- Satuan yang dimiliki keduanya hanya **Box**. PCS gugur karena Snack Kiloan tidak punya PCS
- Field Satuan berubah otomatis menjadi **Box**
- Dropdown berisi `Box` saja
- Field Kuantitas **tetap 3** — angka tidak dikonversi menjadi 1 atau 72
- Muncul peringatan yang memuat ketiganya: nama barang penyebab, satuan baru, dan pembacaan syarat lengkap dengan angkanya. Usulan teks:
  > *"Satuan promo berubah menjadi **Box** karena Snack Kiloan tidak memiliki satuan PCS. Syarat sekarang terbaca **3 Box**. Periksa kembali kuantitasnya."*
- Snack Kiloan **tetap masuk** ke daftar barang — tidak ditolak

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-B3 — Tidak ada satuan yang dimiliki bersama, dropdown mati dan Simpan diblokir

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Kopi Susu** (PCS saja) — field Satuan terisi PCS
2. Tambahkan **Snack Kiloan** (Box saja)
3. Perhatikan field Satuan dan dropdown
4. Klik **Simpan**

**Hasil yang diharapkan**
- Tidak ada satuan yang dimiliki kedua barang — irisan kosong
- Field Satuan menjadi **kosong**
- Dropdown **kosong dan nonaktif** — tidak ada yang bisa dipilih
- Kedua barang **tetap ada** di daftar
- Saat Simpan ditekan: promo **tidak tersimpan**, muncul modal yang menyebut barang penyebabnya. Usulan teks:
  > *"Tidak dapat menyimpan. Barang berikut tidak memiliki satuan yang sama dengan barang lain di daftar: **Snack Kiloan**."*

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-B4 — Dropdown melebar kembali setelah barang pembatas dihapus

**Prasyarat**
- Lanjutan kondisi `PRM-SAT-B1`: daftar berisi Air Mineral + Roti Tawar, Satuan = PCS, dropdown `PCS, Box`

**Langkah**
1. Hapus **Roti Tawar** dari daftar
2. Buka dropdown Satuan

**Hasil yang diharapkan**
- Dropdown kembali berisi `PCS`, `Box`, `Lusin`
- Field Satuan **tetap PCS** — tidak berubah karena PCS masih satuan terkecil irisan
- Tidak ada peringatan

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-B5 — Barang tanpa satuan tidak ikut menyusutkan dropdown

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Air Mineral** (PCS, Box, Lusin)
2. Tambahkan **Biaya Layanan** (tanpa satuan)
3. Buka dropdown Satuan

**Hasil yang diharapkan**
- Dropdown **tetap** berisi `PCS`, `Box`, `Lusin` — tidak menyusut
- Field Satuan tetap PCS
- Barang tanpa satuan dikecualikan dari perhitungan irisan. Kalau dropdown menyusut jadi kosong, itu bug

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-B6 — Dua satuan bertulisan sama tapi ID berbeda diperlakukan sebagai satuan berbeda

**Prasyarat**
- Master Barang & Jasa punya dua record satuan terpisah: "PCS" dan "pcs"
- **Kopi Susu** memakai record "PCS", **Keripik A** memakai record "pcs"

**Langkah**
1. Tambahkan **Kopi Susu** — field Satuan terisi PCS
2. Tambahkan **Keripik A**
3. Perhatikan field Satuan dan dropdown
4. Klik **Simpan**

**Hasil yang diharapkan**
- Sistem memperlakukan "PCS" dan "pcs" sebagai satuan berbeda — irisan kosong
- Field Satuan kosong, dropdown nonaktif
- Simpan diblokir dengan modal menyebut **Keripik A**
- Pesan harus cukup menjelaskan supaya user tidak menyimpulkan ini bug tampilan. Usulan teks:
  > *"Tidak dapat menyimpan. Barang berikut tidak memiliki satuan yang sama dengan barang lain di daftar: **Keripik A**. Satuan dibedakan berdasarkan data di Barang & Jasa, bukan berdasarkan penulisannya."*

**Catatan QA:** kalau di lingkungan uji "PCS" dan "pcs" ternyata satu record yang sama, kasus ini tidak dapat dieksekusi. Laporkan sebagai blocker data, bukan sebagai lolos.

**Hasil aktual**
Belum diuji.

---

## C. Nilai pilihan user

### PRM-SAT-C1 — Pilihan manual user bertahan selama masih ada di irisan

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Air Mineral** (PCS, Box, Lusin) — field terisi PCS otomatis
2. Ubah Satuan secara manual menjadi **Box**
3. Tambahkan **Roti Tawar** (PCS, Box)
4. Perhatikan field Satuan

**Hasil yang diharapkan**
- Irisan sekarang `PCS, Box` — Box masih di dalamnya
- Field Satuan **tetap Box** — pilihan user tidak ditimpa oleh auto-isi
- Dropdown berisi `PCS`, `Box`
- Tidak ada peringatan

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-C2 — Pilihan manual user gugur dari irisan, turun ke satuan terkecil disertai peringatan

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Air Mineral** (PCS, Box, Lusin)
2. Ubah Satuan secara manual menjadi **Lusin**
3. Isi Kuantitas dengan **2**
4. Tambahkan **Roti Tawar** (PCS, Box) — tidak punya Lusin
5. Perhatikan field Satuan, Kuantitas, dan pesan

**Hasil yang diharapkan**
- Irisan menjadi `PCS, Box`. Lusin gugur
- Field Satuan turun ke **PCS** — satuan terkecil dari irisan, bukan Box
- Kuantitas **tetap 2**
- Peringatan muncul menyebut nama barang penyebab, satuan baru, dan pembacaan syarat berikut angkanya

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-C3 — Barang penyebab dihapus, satuan tidak naik kembali sendiri

**Prasyarat**
- Lanjutan kondisi `PRM-SAT-C2`: daftar berisi Air Mineral + Roti Tawar, Satuan = PCS setelah turun dari Lusin

**Langkah**
1. Hapus **Roti Tawar** dari daftar
2. Perhatikan field Satuan dan dropdown

**Hasil yang diharapkan**
- Dropdown kembali berisi `PCS`, `Box`, `Lusin`
- Field Satuan **tetap PCS** — tidak kembali ke Lusin secara otomatis
- Tidak ada peringatan
- Kalau user menginginkan Lusin lagi, dia memilihnya sendiri

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-C4 — Daftar dikosongkan total, auto-isi aktif kembali

**Prasyarat**
- Daftar berisi minimal satu barang, dan user sudah pernah mengubah Satuan secara manual

**Langkah**
1. Hapus **semua** barang dari daftar
2. Perhatikan field Satuan
3. Tambahkan **Air Mineral** (PCS, Box, Lusin)
4. Perhatikan field Satuan

**Hasil yang diharapkan**
- Setelah langkah 1: field Satuan kosong dan nonaktif, status "sudah diubah user" ikut ter-reset
- Setelah langkah 3: field terisi **PCS** secara otomatis — auto-isi berjalan lagi seperti form baru
- Nilai manual yang lama tidak muncul kembali

**Hasil aktual**
Belum diuji.

---

## D. Kuantitas tidak dikonversi

### PRM-SAT-D1 — Ganti satuan manual, angka Kuantitas tidak ikut dikonversi

**Prasyarat**
- Daftar berisi **Air Mineral** saja (PCS, Box, Lusin). 1 Box = 24 PCS

**Langkah**
1. Isi Kuantitas dengan **24**, Satuan = PCS. Syarat terbaca "24 PCS"
2. Ubah Satuan menjadi **Box**
3. Perhatikan field Kuantitas

**Hasil yang diharapkan**
- Kuantitas **tetap 24**, tidak berubah menjadi 1
- Syarat sekarang terbaca "24 Box"
- Sistem tidak melakukan konversi otomatis dalam kondisi apa pun

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-D2 — Satuan turun otomatis, angka Kuantitas tetap dan peringatan menyebut angka

**Prasyarat**
- Form Promo baru, daftar barang kosong

**Langkah**
1. Tambahkan **Air Mineral**, Satuan otomatis PCS
2. Isi Kuantitas dengan **3**
3. Tambahkan **Snack Kiloan** (Box saja)
4. Baca teks peringatan yang muncul

**Hasil yang diharapkan**
- Satuan berubah ke **Box**, Kuantitas **tetap 3**
- Teks peringatan memuat pembacaan lengkap "**3 Box**", bukan hanya menyebut kata Box
- Peringatan tidak hilang sendiri sebelum user membacanya — kalau berupa toast, durasinya harus cukup atau diganti banner yang menetap

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-D3 — Teks peringatan memuat tiga unsur wajib

**Prasyarat**
- Kondisi apa pun yang memicu satuan berubah otomatis (mis. `PRM-SAT-B2` atau `PRM-SAT-C2`)

**Langkah**
1. Picu perubahan satuan otomatis
2. Periksa teks peringatan satu per satu terhadap daftar di bawah

**Hasil yang diharapkan**
Teks peringatan wajib memuat **ketiga** unsur ini. Kurang satu = gagal:
1. **Nama barang penyebab** — bukan "sebuah barang" atau "barang yang dipilih"
2. **Satuan baru** yang sekarang aktif
3. **Pembacaan syarat lengkap** berisi angka + satuan baru, mis. "3 Box"

**Hasil aktual**
Belum diuji.

---

## E. Validasi saat Simpan

### PRM-SAT-E1 — Semua barang punya satuan aktif, promo tersimpan

**Prasyarat**
- Form Promo terisi lengkap (nama, periode, dll)
- Daftar barang: **Air Mineral** + **Roti Tawar**. Satuan = PCS, Kuantitas = 10

**Langkah**
1. Klik **Simpan**

**Hasil yang diharapkan**
- Promo tersimpan
- Tidak ada modal peringatan satuan
- Nilai Satuan yang tersimpan adalah PCS

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-E2 — Tidak ada satuan bersama, Simpan diblokir dengan modal

**Prasyarat**
- Daftar barang: **Kopi Susu** (PCS) + **Snack Kiloan** (Box). Field Satuan kosong, dropdown nonaktif

**Langkah**
1. Isi seluruh field lain sampai valid
2. Klik **Simpan**

**Hasil yang diharapkan**
- Muncul modal yang menyebut **Snack Kiloan** sebagai barang bermasalah
- Promo **tidak tersimpan**
- Setelah modal ditutup, seluruh isian form **tidak hilang** — user kembali ke form dengan data utuh

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-E3 — Modal bersifat memblokir, tidak ada jalan memaksa simpan

**Prasyarat**
- Kondisi `PRM-SAT-E2`, modal sedang tampil

**Langkah**
1. Periksa tombol yang tersedia di modal
2. Tutup modal
3. Periksa daftar promo untuk memastikan tidak ada data baru

**Hasil yang diharapkan**
- Modal hanya punya tombol **Tutup** (atau setara). **Tidak ada** tombol "Simpan Saja", "Lanjutkan", atau sejenisnya
- Setelah modal ditutup, tidak ada promo baru di daftar promo
- Tidak ada promo tersimpan dalam keadaan cacat

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-E4 — Lebih dari satu barang bermasalah, semuanya disebut

**Prasyarat**
- Daftar barang: **Kopi Susu** (PCS) + **Snack Kiloan** (Box) + **Susu Kotak** (Lusin)

**Langkah**
1. Klik **Simpan**
2. Baca isi modal

**Hasil yang diharapkan**
- Modal menyebut **semua** barang yang bermasalah, bukan hanya yang pertama ditemukan
- Nama barang ditampilkan sebagai daftar yang bisa dibaca, bukan digabung jadi satu kalimat panjang
- Kalau jumlah barang bermasalah sangat banyak, modal tetap bisa di-scroll dan tidak memotong daftar tanpa keterangan

**Hasil aktual**
Belum diuji.

---

## F. Hasil Promo

### PRM-SAT-F1 — Hasil Promo punya field Satuan sendiri dengan perilaku identik

**Prasyarat**
- Form Promo baru, tipe syarat Berdasarkan Kuantitas Barang
- Blok Syarat Promo sudah terisi

**Langkah**
1. Pada blok **Hasil Promo**, tambahkan **Air Mineral** (PCS, Box, Lusin)
2. Perhatikan field Satuan pada blok Hasil Promo

**Hasil yang diharapkan**
- Blok Hasil Promo punya field Satuan **terpisah** dari blok Syarat
- Field terisi otomatis **PCS**
- Dropdown berisi `PCS`, `Box`, `Lusin`
- Semua perilaku pada kelompok A–E berlaku sama di sisi ini

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-F2 — Satuan Hasil boleh berbeda dari Satuan Syarat

**Prasyarat**
- Blok Syarat: **Air Mineral**, Satuan PCS, Kuantitas 10
- Blok Hasil: **Roti Tawar** (PCS, Box)

**Langkah**
1. Pada blok Hasil, ubah Satuan menjadi **Box**, Kuantitas **1**
2. Klik **Simpan**
3. Buka kembali promo yang baru disimpan

**Hasil yang diharapkan**
- Promo tersimpan tanpa peringatan apa pun soal perbedaan satuan antar blok
- Promo terbaca "beli 10 PCS → gratis 1 Box"
- Setelah dibuka ulang, Syarat tetap PCS dan Hasil tetap Box

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-F3 — Irisan sisi Hasil dihitung hanya dari barang sisi Hasil

**Prasyarat**
- Blok Syarat: **Kopi Susu** (PCS saja)
- Blok Hasil: **Air Mineral** (PCS, Box, Lusin)

**Langkah**
1. Buka dropdown Satuan pada blok **Hasil**

**Hasil yang diharapkan**
- Dropdown Hasil berisi `PCS`, `Box`, `Lusin` — tidak menyusut karena Kopi Susu di blok Syarat
- Barang di blok Syarat tidak pernah ikut menghitung irisan blok Hasil, dan sebaliknya

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-F4 — Simpan diblokir karena masalah di sisi Hasil

**Prasyarat**
- Blok Syarat valid: **Air Mineral**, Satuan PCS
- Blok Hasil bermasalah: **Kopi Susu** (PCS) + **Snack Kiloan** (Box) — irisan kosong

**Langkah**
1. Klik **Simpan**
2. Baca isi modal

**Hasil yang diharapkan**
- Simpan diblokir
- Modal menyebut **blok mana** yang bermasalah, bukan hanya nama barangnya — user harus tahu harus melihat ke Syarat atau ke Hasil
- Promo tidak tersimpan

**Hasil aktual**
Belum diuji.

---

## G. Simpan dan buka ulang

### PRM-SAT-G1 — Promo dibuka ulang, satuan tidak dihitung ulang

**Prasyarat**
- Promo tersimpan dengan daftar **Air Mineral** + **Roti Tawar**, Satuan diubah manual menjadi **Box**

**Langkah**
1. Tutup form
2. Buka kembali promo tersebut untuk diedit
3. Perhatikan field Satuan

**Hasil yang diharapkan**
- Field Satuan menampilkan **Box** — nilai yang tersimpan
- Sistem **tidak** menghitung ulang dan **tidak** menurunkannya ke PCS
- Tidak ada peringatan saat form dibuka

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-G2 — Promo dibuka ulang lalu ditambah barang, aturan berlaku normal

**Prasyarat**
- Lanjutan `PRM-SAT-G1`: promo terbuka, Satuan = Box

**Langkah**
1. Tambahkan **Teh Botol** (PCS, Lusin) — tidak punya Box
2. Perhatikan field Satuan dan pesan

**Hasil yang diharapkan**
- Irisan menjadi `PCS` saja (Air Mineral ∩ Roti Tawar ∩ Teh Botol)
- Field Satuan turun ke **PCS** disertai peringatan lengkap tiga unsur
- Kuantitas tidak berubah

**Hasil aktual**
Belum diuji.

---

## H. Promo yang dibuat sebelum fitur ini

### PRM-SAT-H1 — Promo lama dibuka, nilai satuan lama dipertahankan

**Prasyarat**
- Ada promo yang dibuat **sebelum** fitur auto-isi dirilis, dengan nilai Satuan apa pun (termasuk kosong)

**Langkah**
1. Buka promo lama tersebut untuk diedit
2. Perhatikan field Satuan tanpa mengubah apa pun

**Hasil yang diharapkan**
- Field Satuan menampilkan nilai lama apa adanya
- Kalau nilai lamanya kosong, field tetap kosong — **tidak** diisi otomatis
- Tidak ada peringatan, tidak ada perubahan data

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-H2 — Promo lama disimpan ulang tanpa perubahan, data tidak berubah

**Prasyarat**
- Lanjutan `PRM-SAT-H1`

**Langkah**
1. Tanpa mengubah apa pun, klik **Simpan**
2. Buka kembali promo tersebut
3. Bandingkan nilai Satuan sebelum dan sesudah

**Hasil yang diharapkan**
- Nilai Satuan **identik** dengan sebelum disimpan
- Membuka lalu menyimpan promo lama tidak boleh mengubah nilainya secara diam-diam

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-H3 — Promo lama ditambah barang baru, aturan baru mulai berlaku

**Prasyarat**
- Promo lama dengan daftar **Air Mineral**, Satuan tersimpan **Lusin**

**Langkah**
1. Buka promo lama
2. Tambahkan **Roti Tawar** (PCS, Box) — tidak punya Lusin
3. Perhatikan field Satuan dan pesan

**Hasil yang diharapkan**
- Irisan dihitung dari **seluruh** daftar, termasuk barang lama
- Lusin gugur, field turun ke **PCS** disertai peringatan lengkap
- Kuantitas tidak dikonversi

**Hasil aktual**
Belum diuji.

---

## I. Master Barang & Jasa

### PRM-SAT-I1 — Master menolak perubahan satuan yang sedang dipakai promo aktif

**Prasyarat**
- Ada promo **aktif** bernama "Promo Akhir Bulan" yang memakai Satuan **PCS** dengan barang **Air Mineral**

**Langkah**
1. Buka master Barang & Jasa → **Air Mineral**
2. Ubah satuan PCS (mis. ganti namanya, atau ganti urutannya sehingga satuan terkecil berubah)
3. Klik Simpan

**Hasil yang diharapkan**
- Perubahan **ditolak**
- Muncul pesan yang menyebut **nama promonya**, mis. *"Satuan PCS sedang digunakan oleh promo aktif: Promo Akhir Bulan."*
- Data master tidak berubah

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-I2 — Master menolak penghapusan satuan yang sedang dipakai promo aktif

**Prasyarat**
- Sama dengan `PRM-SAT-I1`

**Langkah**
1. Buka master Barang & Jasa → **Air Mineral**
2. Hapus satuan **PCS**
3. Klik Simpan

**Hasil yang diharapkan**
- Penghapusan **ditolak** dengan pesan menyebut nama promonya
- Data master tidak berubah

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-I3 — Promo non-aktif tidak mengunci master

**Prasyarat**
- Promo "Promo Akhir Bulan" diubah statusnya menjadi **non-aktif**

**Langkah**
1. Buka master Barang & Jasa → **Air Mineral**
2. Ubah atau hapus satuan PCS
3. Klik Simpan

**Hasil yang diharapkan**
- Perubahan **diizinkan**
- Tidak ada pesan penolakan

**Catatan:** definisi "aktif" belum final — lihat Pertanyaan terbuka #4. Kasus ini harus diuji ulang setelah definisinya ditetapkan.

**Hasil aktual**
Belum diuji.

---

### PRM-SAT-I4 — Menambah satuan baru ke barang tetap diizinkan

**Prasyarat**
- Ada promo aktif memakai **Air Mineral** dengan Satuan PCS

**Langkah**
1. Buka master Barang & Jasa → **Air Mineral**
2. Tambahkan satuan baru, mis. **Karton** (1 Karton = 48 PCS)
3. Klik Simpan

**Hasil yang diharapkan**
- Penambahan **diizinkan** — menambah satuan tidak merusak promo mana pun
- Promo yang sudah tersimpan tidak berubah nilainya
- Saat promo dibuka lagi, Karton ikut muncul di dropdown kalau semua barang di daftar memilikinya

**Hasil aktual**
Belum diuji.

---

## Pertanyaan terbuka

Belum diputuskan. **Jangan ditebak saat implementasi** — angkat ke PM dulu.

| # | Pertanyaan | Kenapa penting |
|---|---|---|
| 1 | Kuantitas syarat dihitung **agregat** lintas barang (6 Nasi Goreng + 4 Mie Goreng = 10) atau **per barang** (harus ada satu barang yang mencapai 10)? | Menentukan arti promo di kasir. Tanpa ini QA tidak bisa menulis expected untuk pengujian evaluasi promo di POS. Aturan satuan di dokumen ini tetap sah untuk kedua jawaban. |
| 2 | Barang yang sama dipilih **dua kali** — ditolak, digabung, atau dibiarkan jadi dua baris? | Belum pernah dibahas. Berpengaruh ke perhitungan irisan dan ke pesan modal saat Simpan. |
| 3 | Barang **dinonaktifkan** di master sementara dipakai promo aktif — diblokir seperti satuan, atau dibiarkan? | Keputusan `R12` baru menutup ubah/hapus satuan, belum menonaktifkan barangnya. |
| 4 | Definisi **"promo aktif"** untuk penguncian master: berdasarkan status aktif, atau rentang tanggal yang sedang berjalan? Promo terjadwal bulan depan ikut mengunci? Promo yang tanggalnya sudah lewat tapi statusnya masih aktif? | Menentukan kapan `PRM-SAT-I1`–`I3` berlaku. Tanpa definisi, ketiga kasus itu tidak punya expected yang pasti. |
| 5 | **Pembulatan** saat pembelian tidak genap satu satuan. Satuan Box, 1 Box = 12 PCS, pelanggan beli 6 PCS = 0,5 Box. Syarat "beli 1 Box" terpenuhi atau tidak? | Berpengaruh langsung ke apakah promo jalan atau tidak di kasir. |
| 6 | Penentuan "satuan terkecil dari irisan" saat **urutan konversi antar barang tidak sepakat**. Contoh: barang X punya Box = 10 PCS dan Lusin = 12 PCS (Box lebih kecil), barang Y punya Box = 24 PCS dan Lusin = 12 PCS (Lusin lebih kecil). Irisan `{Box, Lusin}` — mana yang "terkecil"? | Jarang, tapi hasilnya tidak deterministik kalau tidak ditetapkan. Usulan: pakai urutan konversi barang pertama di daftar. |
| 7 | **Teks final** semua pesan di dokumen ini. Yang tertulis masih usulan. | Teks usulan PM semula menyebut "satuan item pertama", yang tidak lagi akurat karena acuannya adalah irisan. |
| 8 | Saat irisan kosong, apakah ada **petunjuk inline** di bawah field Satuan, atau user baru tahu saat menekan Simpan? | Tanpa petunjuk inline, user melihat dropdown mati tanpa penjelasan. Usulan: tampilkan petunjuk inline, modal saat Simpan tetap ada sebagai pengaman terakhir. |

---

## Risiko yang diterima

Dicatat supaya tidak dilaporkan sebagai bug di kemudian hari.

| Risiko | Kenapa diterima |
|---|---|
| Satuan bisa berubah otomatis tanpa user menyentuh field, dan angka Kuantitas tidak ikut dikonversi — arti promo bisa berubah drastis (mis. "3 PCS" → "3 Box" = 72 botol) | Konversi otomatis butuh aturan pembulatan yang belum diputuskan (Pertanyaan terbuka #5). Pengamannya adalah peringatan wajib tiga unsur (`PRM-SAT-D3`). **Ini jalur satu-satunya di desain ini yang bisa mengubah nilai promo tanpa user sengaja** — kalau ada satu kasus yang tidak boleh gagal, itu `PRM-SAT-D3`. |
| Dua barang dengan satuan bertulisan sama ("PCS" vs "pcs") ditolak walau terlihat identik | Pencocokan by ID adalah satu-satunya cara yang konsisten dengan data master. Ditambal lewat teks pesan di `PRM-SAT-B6`. |
| Promo lama dan promo baru punya dua perilaku berdampingan | Migrasi massal akan mengubah promo aktif tanpa persetujuan pemiliknya. Harus disebut di catatan rilis, kalau tidak QA akan melaporkan promo lama sebagai bug. |
| Penguncian di master (`R12`) butuh pengecekan lintas modul, dan user master sering tidak punya akses ke modul promo | Alternatifnya adalah membiarkan promo rusak diam-diam, yang lebih mahal. Pesannya perlu mengarahkan user harus menghubungi siapa. |

---

## Lampiran

**Node Figma:** belum ada.

**Riwayat keputusan:** seluruh keputusan produk pada dokumen ini diambil dalam satu sesi brainstorming PM–QA pada 2026-08-20. Dua keputusan sempat direvisi di tengah sesi dan versi finalnya yang tercatat di sini:

- Penolakan barang saat ditambahkan → **direvisi** menjadi barang bebas ditambahkan, validasi di titik Simpan
- Acuan satuan = satuan terkecil barang pertama → **direvisi** menjadi satuan terkecil dari irisan seluruh barang
