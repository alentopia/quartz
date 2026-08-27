# Nomor Antrian Pick Up — Case: Penomoran "Gabung semua channel" (AOL)

**Status:** Draft
**Tanggal:** 2026-08-27
**Fitur:** Nomor Antrian Pick Up — sisi **AOL (backoffice)**, kartu **Buat Daftar Pick Up** pada record **Customer Display** bertipe `Nomor antrian`, khusus saat opsi **Penomoran antrean = "Gabung semua channel"** dipilih. **Bukan cakupan:** mode `Pisah Per Channel` (dibahas terpisah), tampilan nomor antrean di perangkat Customer Display, dan pemakaian nomor di sisi pelanggan — itu ada di [[SO_Case_NomorPickUpDiSukses]].
**Prefix ID kasus:** `AOL-PCK`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · UI/UX (eksekusi desain) · PM (keputusan produk)
**Referensi:** [[SO_Case_NomorPickUpDiSukses]] (konsumen nomornya, prefix `SO-PCK`) · [[SO_Case_SetupAOLFiturOpsional]] (pola setup di sisi AOL) · [[SST_Case_SettingSalestypeDataLama]] (contoh format case sisi AOL) · [[WL_Overview]], [[WL_Requirements]] (nomor Waiting List — **beda deret**, lihat §Prinsip)
**Format dokumen ini mengikuti:** [[Template_Case_Negative]] · alasannya di [[Riset_Workflow_Handoff_UIUX_QA_DEV]]
**Peta cepat di Figma:** [Flow & Catatan — Customer Display (AOL)](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=337-896) (`337:896`) — diagram alur dua tipe record plus catatan per frame, dibuat 2026-08-27 di sebelah kiri section `291:2106`. Nomor 1–6 pada catatan itu sama dengan badge yang ditempel di selasar kiri tiap frame; frame mode Gabung ditandai badge `G`. Baca itu dulu kalau baru masuk ke fitur ini.
**Desain:** [CD · Data Baru — Tipe Nomor antrian — Gabung semua channel](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=131-17642) (`131:17642`) dan [Customer Display — dua tipe record (AOL)](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=291-2106) (`291:2106`). File `hl2CORgtDUUUo7A1Gj86mz`. Node lengkap di [[#Lampiran B — Peta node Figma|Lampiran B]].

**Perubahan desain (2026-08-27).** Frame mode Gabung tadinya berdiri sebagai layar sendiri dengan chrome berbeda (tab `Nomor Antrian`, baris `Nama :` + `Pilih Outlet POS*`). Atas keputusan PM, frame itu **disamakan dengan frame mode Pisah**: tab `Customer Display`, baris `Nama *` + `Tipe *` = `Nomor antrian`, layout kartu dua kolom dengan preview di panel kanan, rail tiga langkah. Field `Pilih Outlet POS*` **dihapus** — pemilihan outlet memang sudah punya tempat sendiri di **tab Outlet**. Perubahan sudah dieksekusi di Figma pada node `131:17642`; frame juga di-rename mengikuti pola nama frame Pisah. Konsekuensinya terhadap kasus: `AOL-PCK-A1` dan `AOL-PCK-D1` ditulis ulang, pertanyaan terbuka no. 1, 6, 11, dan 12 ditutup.

**Revisi kedua (2026-08-27, setelah penyamaan).** Atas acuan gambar dari PM, **rail kiri** ditata ulang: langkah aktif pindah ke **atas**, dan ketiga ikonnya diganti menjadi dokumen berbaris (aktif, pink) · dokumen `INFORMASI` · kantong uang `RP`. Ikon diambil dari component set library `131:2578` lewat variant swap, bukan gambar tempel. Karena rail frame Pisah belum diubah, penyamaan rail antar frame **belum tuntas** — pertanyaan terbuka no. 16.

---

## Cara membaca dokumen ini

Setiap kasus punya lima bagian tetap: **Judul** · **Prasyarat** · **Langkah reproduksi** · **Hasil yang diharapkan** · **Hasil aktual**. Kasus yang punya beberapa varian data ditulis **sekali** dengan tabel **Varian** — nilai di tabel itu menggantikan `<placeholder>` di langkah dan expected. Satu baris varian = satu baris di sheet test case QA.

Kolom **Hasil aktual** berisi kondisi terakhir yang diketahui saat dokumen ditulis (sudah digambar / belum ada frame / ada drift). QA menimpanya dengan hasil uji nyata saat build tersedia.

Yang **tidak** terbaca dari desain tidak dikarang di sini. Semuanya dikumpulkan di [[#Pertanyaan terbuka|Pertanyaan terbuka]], dan kasus yang bergantung padanya ditandai **menunggu keputusan**.

### Daftar kasus

| ID | Judul singkat | Wadah pesan | Status desain |
|---|---|---|---|
| `AOL-PCK-A1` | Data Baru: `Gabung semua channel` terpilih, satu baris field | tidak ada | sudah (`131:17642`) |
| `AOL-PCK-A2` | Pindah `Pisah Per Channel` → `Gabung semua channel` | tidak ada | sebagian (dua state ada, transisinya tidak) |
| `AOL-PCK-A3` | Pindah balik `Gabung` → `Pisah` setelah baris per-channel sempat diisi | belum diputuskan (no. 17) | belum ada — aturannya sudah diputuskan |
| `AOL-PCK-A4` | Preview **Contoh hasil penomoran** mengikuti isi field | tidak ada | sudah (dua frame) |
| `AOL-PCK-B1` | `No Mulai Dari` dikosongkan → simpan ditolak | belum ada | belum ada |
| `AOL-PCK-B2` | `Inisial Antrian` dikosongkan → boleh simpan, preview tanpa inisial | tidak ada | belum ada |
| `AOL-PCK-B3` | `No Akhir Sampai` < `No Mulai Dari` → harus ditolak | belum ada | belum ada |
| `AOL-PCK-B4` | `No Akhir Sampai` dikosongkan | belum ada | belum ada |
| `AOL-PCK-C1` | Satu deret dipakai bersama Self Order dan POS, tanpa nomor kembar | tidak ada | belum ada |
| `AOL-PCK-C2` | Deret habis di `No Akhir Sampai` | belum diputuskan | belum ada |
| `AOL-PCK-C3` | Ganti mode di tengah hari operasional yang deretnya sudah jalan | belum diputuskan | belum ada |
| `AOL-PCK-D1` | Satu record dipetakan ke beberapa outlet lewat tab Outlet | tidak ada | sebagian (`291:3193`) |

## Latar belakang

Kartu **Buat Daftar Pick Up** di AOL memutuskan **bagaimana nomor pick up dibentuk**. Satu radio dengan dua pilihan, dan dua pilihan itu memunculkan **bentuk form yang berbeda**:

| Mode | Field yang muncul | Preview |
|---|---|---|
| **Gabung semua channel** | satu baris: `Inisial Antrian` · `No Mulai Dari*` · `No Akhir Sampai` | satu nilai — `A - 0001` |
| `Pisah Per Channel` | baris berulang: `Asal Transaksi*` · `Inisial Antrian*` · `No Mulai Dari*` + ikon hapus, plus link `+ Tambah Daftar Antrian` | satu nilai per baris — `CC - 1`  `AA - 1` |

Dokumen ini menutup **mode Gabung semua channel** saja. Di Figma mode Gabung baru digambar **satu frame**, yaitu form kosong Data Baru (`131:17642`). Mode Pisah digambar lebih lengkap: Data Baru (`291:2478`) dan Terisi (`292:1149`). Jadi celah terbesar yang ditutup spec ini adalah **state yang belum digambar untuk mode Gabung**: validasi, state tersimpan, dan perilaku deret setelah dipakai.

Nomor yang dihasilkan di sini adalah nomor yang muncul di layar sukses pelanggan pada [[SO_Case_NomorPickUpDiSukses]]. Kalau aturan penomoran di AOL berubah, case itu ikut berubah — bukan sebaliknya.

## Keputusan produk

Sumber kebenaran kalau ada beda tafsir saat implementasi atau pengujian. Kolom **Dasar** menunjukkan apakah keputusan sudah terbaca dari desain atau masih usulan.

| Topik | Keputusan | Dasar |
|---|---|---|
| Default mode saat form Data Baru dibuka | `Gabung semua channel` **terpilih** | dari desain (`131:17642` — radio pertama aktif) |
| Arti mode Gabung | **satu deret untuk semua channel**, tidak ada nomor kembar dalam sehari | dari desain (helper text, kutipan persis di A1) |
| Field wajib pada mode Gabung | hanya **`No Mulai Dari`** (bertanda `*` merah). `Inisial Antrian` dan `No Akhir Sampai` tidak wajib | dari desain (`131:17770`) |
| Format preview | `<Inisial Antrian>` + ` - ` + `<No Mulai Dari>`, **apa adanya sesuai yang diketik** — tidak ditambah/dikurangi nol | dari desain (dua frame konsisten: `A` + `0001` → `A - 0001`; `CC` + `1` → `CC - 1`) |
| Lebar nomor (nol di depan) | ditentukan **oleh yang diketik user** di `No Mulai Dari`, bukan oleh sistem. `0001` → deret 4 digit; `1` → deret tanpa padding | turunan dari baris di atas — **usulan, belum dikonfirmasi PM** |
| Field `Asal Transaksi` pada mode Gabung | **tidak ada**. Tidak disabled, tidak kosong — hilang dari form | dari desain (`131:17642` tidak punya baris `Asal Transaksi`) |
| Link `+ Tambah Daftar Antrian` pada mode Gabung | **tidak ada** | dari desain |
| Ikon hapus baris pada mode Gabung | **tidak ada** (tidak ada baris untuk dihapus) | dari desain |
| Nomor pick up ≠ nomor Waiting List | dua deret berbeda, tidak boleh saling mengambil nomor | dari [[SO_Case_NomorPickUpDiSukses]] |
| Pindah radio `Penomoran antrean` | isi field mode yang ditinggalkan **hilang** — tidak disimpan sebagai draft, tidak dipulihkan kalau merchant pindah balik. Mode yang dituju selalu mulai dari keadaan kosong | keputusan PM 2026-08-27 |
| Pintu masuk kartu Buat Daftar Pick Up | **satu saja**: AOL → **Customer Display** → Data Baru → `Tipe` = `Nomor antrian`. Tidak ada layar `Nomor Antrian` terpisah | keputusan PM 2026-08-27 — sudah dieksekusi di Figma |
| Gerbang fitur | Seluruh dokumen ini baru berlaku kalau toggle **`Queue Number`** di **Setup AOL › Pengaturan POS › Fitur Opsional** (kolom Manajemen Fitur, baris ke-9, node `258:2821`) **ON**. Kata PM: kalau dihidupkan, baru ada setelan untuk nomor antrean | info PM 2026-08-27 — alur ON→OFF belum tergambar, lihat pertanyaan terbuka no. 19 |
| Chrome layar (tab browser + baris atas) | **sama untuk kedua mode**: tab aktif `Customer Display`, baris `Nama *` lalu `Tipe *` | keputusan PM 2026-08-27 — sudah dieksekusi di Figma |
| Field `Pilih Outlet POS*` di kartu | **dihapus**. Outlet dipilih di **tab Outlet** pada record yang sama | keputusan PM 2026-08-27 — sudah dieksekusi di Figma |
| Letak blok preview | **panel kanan** kartu, sama seperti mode Pisah — bukan di bawah field | keputusan PM 2026-08-27 — sudah dieksekusi di Figma |
| Rail langkah di kiri kartu | **tiga** langkah, aktif = langkah **pertama** (kartu Buat Daftar Pick Up) | keputusan PM 2026-08-27 (revisi kedua, dari acuan gambar) — sudah dieksekusi di Figma |
| Ikon rail | 1 = dokumen berbaris (`Rincian Barang`, tampil **pink** saat aktif) · 2 = dokumen `INFORMASI` (`Info Lainnya 2`) · 3 = kantong uang `RP` (`Variant15`) | keputusan PM 2026-08-27 (revisi kedua, dari acuan gambar) — sudah dieksekusi di Figma |

## Prinsip

- **Mode menentukan bentuk form, bukan sekadar mengaktifkan field.** Pindah radio harus **menukar** blok field, bukan men-disable-nya. Kalau ada field mode lain yang masih terlihat (walau disabled), itu bug.
- **Yang tidak bertanda `*` benar-benar boleh kosong.** `Inisial Antrian` tidak wajib di mode Gabung, padahal **wajib** di mode Pisah. Perbedaan itu disengaja: di mode Pisah inisial adalah satu-satunya pembeda antar channel, di mode Gabung tidak ada yang perlu dibedakan.
- **Preview adalah kontrak yang bisa dilihat merchant.** Apa pun yang tampil di **Contoh hasil penomoran** harus benar-benar sama dengan nomor pertama yang keluar setelah disimpan. Preview yang tidak cocok dengan hasil nyata lebih berbahaya daripada preview yang tidak ada.
- **"Tidak ada nomor kembar dalam sehari" adalah janji yang tertulis di layar.** Helper text itu dibaca merchant sebelum memilih. Setiap kasus di grup C menguji janji itu, bukan menguji field.
- **Nomor pick up bukan nomor Waiting List.** Keduanya antrean, tapi tujuannya beda: pick up = ambil pesanan, waiting list = tunggu meja. Deretnya tidak boleh dicampur, walau outletnya sama. Lihat [[WL_Overview]].

---

## A. Bentuk form saat "Gabung semua channel" dipilih

### AOL-PCK-A1 — Form Data Baru: mode Gabung terpilih, hanya satu baris field penomoran

**Frame Figma:** [CD · Data Baru — Tipe Nomor antrian — Gabung semua channel](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=131-17642)

**Prasyarat**

- Toggle **`Queue Number`** di **Setup AOL › Pengaturan POS › Fitur Opsional** sudah **ON** (node `258:2821` — lihat [[SO_Case_SetupAOLFiturOpsional]]). Selama OFF, kartu ini tidak diuji.
- User punya hak akses membuat record Customer Display di AOL.
- Minimal satu Outlet POS tersedia untuk diambil di **tab Outlet** (lihat `AOL-PCK-D1`).
- Belum ada record Customer Display bertipe `Nomor antrian` untuk outlet itu (form benar-benar baru).

**Langkah reproduksi**

1. Masuk AOL.
2. Buka menu **Customer Display**.
3. Buka tab **Data Baru**.
4. Pada `Tipe *`, pilih **`Nomor antrian`**.
5. Perhatikan kartu **Buat Daftar Pick Up** tanpa menyentuh apa pun.

**Hasil yang diharapkan**

Chrome layar — **harus sama persis dengan frame mode Pisah**:

| Elemen | Isi |
|---|---|
| Tab browser aktif | **"Customer Display"** (pink) |
| Tab dokumen | **"Data Baru"** |
| Baris 1 | **"Nama *"** — placeholder **"Cth: Display 1"** |
| Baris 2 | **"Tipe *"** — dropdown, terisi **"Nomor antrian"** |
| Rail langkah (kiri kartu) | **tiga** ikon, dari atas: **dokumen berbaris** (aktif — kartu ini, ikon **pink** + bar pink di kiri), **dokumen `INFORMASI`**, **kantong uang `RP`** |

Tidak boleh ada field **`Pilih Outlet POS`** di layar ini — sudah dihapus, outlet diambil di tab Outlet.

Kartu berjudul **"Buat Daftar Pick Up"**. Baris radio:

| Elemen | Isi | State |
|---|---|---|
| Label grup | **"Penomoran antrean*"** | — |
| Opsi 1 | **"Gabung semua channel"** | **terpilih** |
| Helper opsi 1 | **"Satu deret untuk semua channel, tidak ada nomor kembar dalam sehari"** | — |
| Opsi 2 | **"Pisah Per Channel"** | tidak terpilih |
| Helper opsi 2 | **"Tiap channel punya deret sendiri"** | — |

Di bawah pemisah, muncul **satu baris** field — bukan baris berulang:

| # | Label | Wajib | Nilai contoh di desain |
|---|---|---|---|
| 1 | **"Inisial Antrian"** | tidak | `A` |
| 2 | **"No Mulai Dari*"** | **ya** (`*` merah) | `0001` |
| 3 | **"No Akhir Sampai"** | tidak | `9999` |

Di **panel kanan kartu** — bukan di bawah field — label **"Contoh hasil penomoran"** dan hasilnya dalam angka besar: **"A - 0001"**. Kolom kiri berisi form, kolom kanan berisi preview, dipisah garis vertikal. Letaknya sama dengan mode Pisah; yang beda hanya jumlah nilai preview (satu, bukan satu per channel).

Yang **tidak boleh** ada di layar saat mode ini terpilih:

- field **`Asal Transaksi`** (dropdown Self Order / POS) — dalam bentuk apa pun, termasuk disabled
- link **`+ Tambah Daftar Antrian`**
- ikon hapus baris
- baris field penomoran kedua dan seterusnya
- field **`Pilih Outlet POS`** (sudah dihapus dari desain)

Tombol **Simpan** (ikon disket, panel kanan atas) tersedia.

> **Titik rawan untuk DEV dan QA.** Di Figma, blok field mode Pisah ada di frame yang sama tapi disembunyikan (`131:17782` dan empat baris kembarannya). Gampang sekali blok itu ikut ter-render dengan `visibility` salah. Cek pakai inspect element, jangan cuma pakai mata: field yang ada di DOM tapi `display:none` masih bisa terkirim saat simpan.

**Hasil aktual (2026-08-27)**

Sudah digambar utuh di `131:17642`, dan **sudah disamakan dengan frame mode Pisah** pada tanggal yang sama: chrome (tab + `Nama *` + `Tipe *`), rail tiga langkah, dan preview di panel kanan. Pemeriksaan struktur setelah perubahan itu: daftar node tingkat atas frame Gabung dan frame Pisah **identik** — nama, urutan, posisi, dan ukuran sama.

Setelah itu, pada tanggal yang sama, **rail kiri ditata ulang** mengikuti acuan gambar dari PM: langkah aktif dipindah dari tengah ke **atas**, dan ketiga ikon diganti (`Rincian Barang` pink untuk yang aktif, `Info Lainnya 2` / `INFORMASI`, `Variant15` / kantong `RP`). Akibatnya **rail frame Gabung sekarang berbeda dari frame Pisah** — frame Pisah masih memakai rail lama. Ini inkonsistensi yang belum ditutup; lihat pertanyaan terbuka no. 16.

Sisa drift copy di frame ini: asterisk `Penomoran antrean*` masih hitam sedangkan `No Mulai Dari*` merah, dan kapitalisasi `Gabung semua channel` vs `Pisah Per Channel` masih tidak konsisten — lihat pertanyaan terbuka no. 5. Kedua drift itu **ada di dua frame**, jadi bukan ketidaksamaan antar mode.

---

### AOL-PCK-A2 — Pindah dari "Pisah Per Channel" ke "Gabung semua channel": baris per-channel hilang

**Frame Figma:** state sebelum → [Pisah Per Channel](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=291-2478) · state sesudah → [Gabung semua channel](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=131-17642)

**Prasyarat**

- Form Data Baru terbuka, radio **`Pisah Per Channel`** sedang terpilih.
- Ada **dua** baris channel terisi: (`Self Order`, `CC`, `1`) dan (`POS`, `AA`, `1`) — sama seperti desain.
- Preview kanan menampilkan dua nilai: `CC - 1` dan `AA - 1`.

**Langkah reproduksi**

1. Klik radio **"Gabung semua channel"**.
2. Perhatikan seluruh isi kartu, termasuk area preview.

**Hasil yang diharapkan**

- Radio pindah ke **"Gabung semua channel"**; `Pisah Per Channel` tidak lagi terpilih.
- Kedua baris channel **hilang dari layar** — beserta dropdown `Asal Transaksi`, ikon hapus, dan link `+ Tambah Daftar Antrian`.
- Muncul **satu** baris `Inisial Antrian` · `No Mulai Dari*` · `No Akhir Sampai`.
- Preview berubah dari **dua** nilai menjadi **satu** nilai.
- Tidak ada modal konfirmasi dan tidak ada toast — desain tidak menggambarkan keduanya.

Isi baris mode Pisah yang ditinggalkan (`Self Order`/`CC`/`1` dan `POS`/`AA`/`1`) **hilang** — tidak disimpan sebagai draft. Baris mode Gabung yang muncul **tidak membawa nilai apa pun** dari baris channel: tidak ada `CC` yang pindah ke `Inisial Antrian`, tidak ada `1` yang pindah ke `No Mulai Dari`.

Keadaan baris Gabung saat pertama muncul harus sama dengan keadaannya di form yang benar-benar baru. Itu berarti satu hal yang perlu dipastikan lebih dulu: apakah `A` / `0001` / `9999` di desain itu **nilai default sistem** atau cuma **contoh isian yang digambar desainer** — lihat pertanyaan terbuka no. 18. Kalau default, baris Gabung muncul dengan ketiga nilai itu; kalau contoh, baris Gabung muncul kosong.

> **Titik rawan untuk DEV dan QA.** Perpindahan ini membuang input yang sudah diketik merchant, dan itu **keputusan sadar** — bukan bug. Yang harus diuji: tidak ada nilai mode Pisah yang menyelip ke field mode Gabung, dan tidak ada nilai mode Pisah yang masih terkirim saat Simpan. Apakah pembuangan itu perlu didahului konfirmasi masih terbuka — pertanyaan no. 17.

**Hasil aktual (2026-08-27)**

Dua state ujungnya sudah digambar, **transisinya belum**. Tidak ada frame yang menunjukkan apa yang terjadi pada data baris per-channel.

---

### AOL-PCK-A3 — Pindah balik ke "Pisah Per Channel" setelah sempat di mode Gabung

**Frame Figma:** *(belum ada frame untuk kasus ini)*

**Prasyarat**

- Lanjutan langsung dari `AOL-PCK-A2` — belum pernah menekan Simpan.

**Langkah reproduksi**

1. Isi baris mode Gabung: `Inisial Antrian` = `A`, `No Mulai Dari` = `0001`, `No Akhir Sampai` = `9999`.
2. Klik radio **"Pisah Per Channel"**.
3. Perhatikan baris channel yang muncul.

**Hasil yang diharapkan**

Aturannya berlaku dua arah, jadi hasilnya bisa dipastikan:

- Nilai mode Gabung yang baru diisi (`A`, `0001`, `9999`) **hilang** — dibuang, bukan disimpan.
- Baris mode Pisah muncul kembali dalam keadaan **kosong**. Nilai lama (`Self Order`/`CC`/`1` dan `POS`/`AA`/`1`) **tidak dipulihkan**, walaupun tadi sempat diisi sebelum pindah ke Gabung. Form tidak menyimpan draft mode mana pun.
- Jumlah baris channel yang muncul kembali mengikuti keadaan form baru — bukan dua baris seperti sebelumnya. Berapa baris yang tampil di form baru belum tergambar; lihat pertanyaan terbuka no. 18.

Yang **tidak boleh** terjadi: nilai mode Gabung (`A`, `0001`, `9999`) bocor ke kolom baris channel, atau ikut terkirim saat Simpan padahal mode aktifnya `Pisah`.

> **Titik rawan untuk DEV dan QA.** Implementasi yang cuma menyembunyikan blok field (`display:none`) akan **lulus uji tampilan tapi gagal aturan ini** — nilainya masih ada di form dan bisa terkirim. Pembuangan harus benar-benar mengosongkan datanya, bukan menyembunyikannya.

**Hasil aktual (2026-08-27)**

Belum ada frame, tapi **aturannya sudah diputuskan** PM pada tanggal ini (isi field mode lama dibuang), jadi kasus ini sudah bisa diuji tanpa menunggu desain. Yang masih menunggu desain hanya wadah konfirmasinya — kalau nanti diputuskan perlu (no. 17).

---

### AOL-PCK-A4 — Preview "Contoh hasil penomoran" mengikuti isi field, apa adanya

**Frame Figma:** [Gabung semua channel — preview `A - 0001`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=131-17717)

**Varian:**

| inisial | mulai | preview |
|---|---|---|
| `A` | `0001` | `A - 0001` |
| `CC` | `1` | `CC - 1` |
| `B` | `100` | `B - 100` |

**Prasyarat**

- Form Data Baru terbuka, mode **`Gabung semua channel`** terpilih.

**Langkah reproduksi**

1. Isi `Inisial Antrian` = `<inisial>`.
2. Isi `No Mulai Dari` = `<mulai>`.
3. Perhatikan blok **Contoh hasil penomoran** di **panel kanan kartu**.

**Hasil yang diharapkan**

- Label **"Contoh hasil penomoran"** tampil di atas hasil.
- Hasil = **`<preview>`** — persis, termasuk spasi di kiri dan kanan tanda hubung.
- **Nol di depan tidak ditambahkan dan tidak dihilangkan** oleh sistem. `0001` tetap `0001`; `1` tetap `1`.
- Hanya **satu** nilai preview yang tampil (mode Pisah menampilkan satu nilai per baris channel — itu bukan mode ini).
- `No Akhir Sampai` **tidak** ikut muncul di preview.

> **Titik rawan untuk DEV dan QA.** Padding adalah satu-satunya alasan merchant mengetik `0001` alih-alih `1`. Sistem yang "membetulkan" input jadi `1` akan mengubah bentuk nomor yang dicetak di struk tanpa merchant tahu.

**Hasil aktual (2026-08-27)**

Aturannya diturunkan dari dua frame yang konsisten (`131:17720` menampilkan `A - 0001` untuk input `0001`; frame mode Pisah menampilkan `CC - 1` untuk input `1`). Varian `B` / `100` belum ada di desain — ditambahkan untuk menguji aturannya, bukan menyalin frame.

---

## B. Validasi field pada mode Gabung

Seluruh grup ini **belum punya frame**. Yang pasti dari desain hanyalah **field mana yang wajib**. Bentuk dan copy pesan errornya belum ada — lihat pertanyaan terbuka no. 3.

### AOL-PCK-B1 — `No Mulai Dari` dikosongkan: simpan harus ditolak

**Frame Figma:** *(belum ada frame — state error belum digambar)*

**Prasyarat**

- Form Data Baru, mode **`Gabung semua channel`**.
- `Nama *` dan `Tipe *` sudah terisi valid, outlet sudah diambil di tab Outlet.

**Langkah reproduksi**

1. Isi `Inisial Antrian` = `A`.
2. Kosongkan `No Mulai Dari`.
3. Isi `No Akhir Sampai` = `9999`.
4. Klik tombol **Simpan**.

**Hasil yang diharapkan**

- Simpan **ditolak**. Setelan tidak tersimpan.
- Field `No Mulai Dari` ditandai sebagai penyebab — konsisten dengan pola field wajib AOL lainnya.
- Isi field lain (`Nama *`, `Tipe *`, `Inisial Antrian`, `No Akhir Sampai`, dan daftar outlet di tab Outlet) **tetap ada**, tidak ikut dibersihkan.
- Mode radio tetap `Gabung semua channel`.

Copy persis pesan error **belum ditentukan** (pertanyaan terbuka no. 3). QA mencatat copy yang benar-benar muncul supaya bisa dibandingkan saat copy final turun.

**Hasil aktual (2026-08-27)**

Belum ada frame. Yang bisa dipastikan dari desain: `No Mulai Dari` satu-satunya field bertanda `*` merah di blok ini, jadi ia **harus** memblokir simpan.

---

### AOL-PCK-B2 — `Inisial Antrian` dikosongkan: boleh disimpan

**Frame Figma:** *(belum ada frame — preview tanpa inisial belum digambar)*

**Prasyarat**

- Form Data Baru, mode **`Gabung semua channel`**, `Nama *` dan `Tipe *` sudah valid, outlet sudah diambil di tab Outlet.

**Langkah reproduksi**

1. Kosongkan `Inisial Antrian`.
2. Isi `No Mulai Dari` = `0001`.
3. Perhatikan blok **Contoh hasil penomoran**.
4. Klik **Simpan**.

**Hasil yang diharapkan**

- Simpan **berhasil**. `Inisial Antrian` tidak bertanda `*`, jadi kosong itu sah.
- Nomor yang keluar nanti **tanpa inisial**: `0001`, `0002`, dst.
- Bentuk preview saat inisial kosong **belum diputuskan**: `0001` saja, atau `- 0001` dengan tanda hubung menggantung. Yang kedua jelas tidak boleh — tapi belum ada frame yang menyatakannya. Lihat pertanyaan terbuka no. 4.

> **Titik rawan untuk DEV dan QA.** Tanda hubung di preview adalah pemisah, bukan bagian dari nomor. Kalau inisial kosong, pemisahnya harus ikut hilang — di preview **dan** di nomor yang dicetak.

**Hasil aktual (2026-08-27)**

Belum ada frame. Kewajiban field terbaca dari desain, tampilan preview-nya tidak.

---

### AOL-PCK-B3 — `No Akhir Sampai` lebih kecil dari `No Mulai Dari`: harus ditolak

**Frame Figma:** *(belum ada frame)*

**Prasyarat**

- Form Data Baru, mode **`Gabung semua channel`**, `Nama *` dan `Tipe *` sudah valid, outlet sudah diambil di tab Outlet.

**Langkah reproduksi**

1. Isi `No Mulai Dari` = `9999`.
2. Isi `No Akhir Sampai` = `0001`.
3. Klik **Simpan**.

**Hasil yang diharapkan**

- Simpan **ditolak** — rentang yang tidak mungkin dijalankan tidak boleh tersimpan. Setelan yang tersimpan dengan rentang terbalik berarti deret pick up mati sejak nomor pertama.
- Field penyebab ditandai.
- Copy pesan **belum ditentukan** (pertanyaan terbuka no. 3).

**Hasil aktual (2026-08-27)**

Belum ada frame. Aturan ini **usulan**, bukan bacaan desain — ditulis karena tanpa aturan ini `No Akhir Sampai` tidak punya arti.

---

### AOL-PCK-B4 — `No Akhir Sampai` dikosongkan

**Frame Figma:** *(belum ada frame)*

**Prasyarat**

- Form Data Baru, mode **`Gabung semua channel`**, `Nama *` dan `Tipe *` sudah valid, outlet sudah diambil di tab Outlet.

**Langkah reproduksi**

1. Isi `Inisial Antrian` = `A`, `No Mulai Dari` = `0001`.
2. Kosongkan `No Akhir Sampai`.
3. Klik **Simpan**.

**Hasil yang diharapkan**

- Simpan **berhasil** — field tidak bertanda `*`.
- Arti "kosong" **belum diputuskan**: deret tanpa batas atas, atau batas default (mis. mengikuti lebar `No Mulai Dari`, `0001` → `9999`). Lihat pertanyaan terbuka no. 7.
- Perhatikan bahwa mode `Pisah Per Channel` **tidak punya** field `No Akhir Sampai` sama sekali. Jadi apa pun arti "kosong" di mode Gabung, arti itu juga menjadi perilaku default mode Pisah — jangan diputuskan sendirian.

**Hasil aktual (2026-08-27)**

Belum ada frame.

---

## C. Perilaku deret setelah disimpan

Grup ini menguji **janji helper text**, bukan field: *"Satu deret untuk semua channel, tidak ada nomor kembar dalam sehari"*. Belum ada frame untuk grup ini — yang diuji perilaku sistem, bukan tampilan.

### AOL-PCK-C1 — Self Order dan POS memakai satu deret yang sama, tanpa nomor kembar

**Frame Figma:** *(perilaku sistem — tidak digambarkan di Figma. Tampilan nomornya di sisi pelanggan: [[SO_Case_NomorPickUpDiSukses]])*

**Prasyarat**

- Setelan Daftar Pick Up tersimpan dengan mode **`Gabung semua channel`**, `Inisial Antrian` = `A`, `No Mulai Dari` = `0001`, `No Akhir Sampai` = `9999`.
- Setelan terpasang pada satu Outlet POS.
- Belum ada transaksi pick up sama sekali di hari operasional itu.
- Dua kanal siap dipakai: Self Order (aplikasi pelanggan) dan POS (kasir).

**Langkah reproduksi**

1. **Self Order:** selesaikan satu pesanan pick up. Catat nomornya.
2. **POS:** selesaikan satu pesanan pick up. Catat nomornya.
3. **Self Order:** selesaikan satu pesanan pick up lagi. Catat nomornya.
4. Bandingkan ketiga nomor.

**Hasil yang diharapkan**

| Urutan | Kanal | Nomor |
|---|---|---|
| 1 | Self Order | `A - 0001` |
| 2 | POS | `A - 0002` |
| 3 | Self Order | `A - 0003` |

- Deret **berlanjut lintas kanal** — POS tidak memulai deret sendiri.
- **Tidak ada nomor kembar** di antara ketiganya.
- Inisial sama (`A`) untuk semua kanal — di mode Gabung tidak ada inisial per channel.
- Nomor pertama **sama persis** dengan yang tampil di preview saat setelan disimpan.

> **Titik rawan untuk DEV dan QA.** Ini kasus paling penting di dokumen ini dan paling gampang lolos dari pengujian, karena butuh dua aplikasi berjalan bergantian. Menguji satu kanal saja akan selalu lulus — dan tidak membuktikan apa pun.

**Hasil aktual (2026-08-27)**

Belum diuji. Janjinya tertulis di helper text desain; mekanismenya belum terdokumentasi.

---

### AOL-PCK-C2 — Deret mencapai `No Akhir Sampai`

**Frame Figma:** *(belum ada frame)*

**Prasyarat**

- Setelan mode **Gabung**, `No Mulai Dari` = `0001`, `No Akhir Sampai` = `0003` (dipersingkat supaya bisa diuji).
- Tiga transaksi pick up sudah keluar: `A - 0001`, `A - 0002`, `A - 0003`.

**Langkah reproduksi**

1. Selesaikan satu pesanan pick up lagi (transaksi keempat).
2. Catat nomor yang keluar, atau pesan yang muncul.

**Hasil yang diharapkan**

**Menunggu keputusan** (pertanyaan terbuka no. 8). Pilihannya:

| Perilaku | Risiko |
|---|---|
| Kembali ke `No Mulai Dari` (`A - 0001`) | melanggar janji "tidak ada nomor kembar dalam sehari" |
| Transaksi diblokir sampai reset harian | kasir berhenti melayani — tidak bisa diterima |
| Lanjut melewati batas (`A - 0004`) | `No Akhir Sampai` jadi tidak ada artinya |

Yang **tidak boleh** terjadi dalam kondisi apa pun: transaksi selesai tetapi **tanpa nomor**, atau nomor kembar dengan transaksi yang masih aktif di hari yang sama.

**Hasil aktual (2026-08-27)**

Belum ada frame dan belum ada keputusan. Kasus ini ditulis karena `No Akhir Sampai` = `9999` di desain membuat batas itu terasa mustahil tercapai — padahal outlet ramai dengan `No Akhir Sampai` kecil bisa mencapainya dalam sehari.

---

### AOL-PCK-C3 — Ganti mode saat deret hari itu sudah jalan

**Frame Figma:** *(belum ada frame)*

**Prasyarat**

- Setelan tersimpan mode **`Pisah Per Channel`**, sudah dipakai hari ini: Self Order sampai `CC - 5`, POS sampai `AA - 3`.
- User punya hak akses mengubah setelan.

**Langkah reproduksi**

1. Buka setelan Daftar Pick Up yang sudah tersimpan itu.
2. Ubah radio ke **"Gabung semua channel"**.
3. Isi `Inisial Antrian` = `A`, `No Mulai Dari` = `0001`.
4. Klik **Simpan**.
5. Selesaikan satu pesanan pick up dari Self Order.

**Hasil yang diharapkan**

**Menunggu keputusan** (pertanyaan terbuka no. 9). Yang harus dijawab: apakah deret baru mulai dari `A - 0001` di hari yang sama, padahal `CC - 1` … `CC - 5` masih beredar di tangan pelanggan.

Yang **tidak boleh** terjadi: dua pesanan aktif di outlet yang sama memegang nomor yang sama sekali tidak bisa dibedakan operator.

**Hasil aktual (2026-08-27)**

Belum ada frame. Perlu diperhatikan bahwa **tidak ada frame state "Terisi" untuk mode Gabung** — frame Terisi yang ada (`292:1149`) menampilkan mode `Pisah Per Channel`. Jadi tampilan setelan Gabung yang sudah tersimpan pun belum digambar.

---

## D. Cakupan outlet

### AOL-PCK-D1 — Satu record dipetakan ke beberapa outlet lewat tab Outlet

**Frame Figma:** [CD · Data Baru — Tipe Nomor antrian — tab Outlet](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=291-3193)

**Prasyarat**

- Ada **dua** Outlet POS berbeda, keduanya melayani pick up.
- Belum ada record Customer Display bertipe `Nomor antrian` untuk keduanya.

**Langkah reproduksi**

1. Buka **Customer Display** → tab **Data Baru**.
2. Isi `Nama *` = `Antrian Pick Up`, `Tipe *` = `Nomor antrian`.
3. Pada kartu **Buat Daftar Pick Up**, pilih mode **`Gabung semua channel`**, `Inisial Antrian` = `A`, `No Mulai Dari` = `0001`.
4. Buka **tab Outlet** (rail langkah ketiga).
5. Pada `Cari/Pilih Outlet`, cari outlet pertama lalu klik **Ambil**. Ulangi untuk outlet kedua — sampai tabel `Nama outlet` berisi **dua** baris.
6. Klik **Simpan**.
7. Selesaikan satu pesanan pick up di **Outlet 1**, lalu satu di **Outlet 2**.
8. Bandingkan kedua nomor.

**Hasil yang diharapkan**

**Menunggu keputusan** (pertanyaan terbuka no. 10). "Gabung semua channel" jelas artinya menggabungkan **channel**; apakah ia juga menggabungkan **outlet** tidak dinyatakan di mana pun.

| Tafsir | Hasil langkah 7 |
|---|---|
| Deret per outlet | Outlet 1 → `A - 0001`, Outlet 2 → `A - 0001` |
| Deret per record (dibagi antar outlet) | Outlet 1 → `A - 0001`, Outlet 2 → `A - 0002` |

Tafsir pertama menghasilkan nomor kembar di hari yang sama pada satu record — bertabrakan dengan bunyi helper text kalau dibaca lurus. Tafsir kedua membuat dua outlet berbeda saling menggeser nomor. Keduanya punya konsekuensi operasional nyata, jadi ini keputusan PM, bukan keputusan implementasi.

Yang sudah pasti dari desain tab Outlet: field bertanda **`Outlet *`** — wajib. Jadi record `Nomor antrian` **tidak bisa** disimpan tanpa outlet, dan pertanyaan di atas tidak bisa dihindari.

> **Titik rawan untuk DEV dan QA.** Jangan uji ini dengan dua outlet yang dipetakan ke **dua record berbeda** — itu kasus lain dan selalu lulus.

**Hasil aktual (2026-08-27)**

Tab Outlet sudah digambar (`291:3193`): search **`Cari/Pilih Outlet`**, tombol hijau **`Ambil`**, tabel berkolom **`Nama outlet`** dengan empty state **`Belum ada data`**, dan judul panel kanan **`Outlet *`**. Karena tabel, satu record memang bisa memuat **lebih dari satu** outlet — jadi kasus ini pasti terjadi. Aturan deretnya belum ada.

Catatan riwayat: sebelum 2026-08-27 frame mode Gabung punya field `Pilih Outlet POS*` sendiri di kartu (multi-chip). Field itu sudah dihapus saat frame disamakan dengan mode Pisah; pemilihan outlet sepenuhnya lewat tab Outlet.

---

## Yang di luar scope (sengaja tidak dikerjakan)

- **Mode `Pisah Per Channel`** — dibahas di dokumen terpisah. Di sini ia hanya muncul sebagai state asal/tujuan perpindahan (A2, A3, C3).
- **Tampilan nomor antrean di perangkat Customer Display** (layar yang dilihat pelanggan) — frame `291:2107`, `292:751` tidak dibedah di sini. Tab **Outlet** (`291:3193`) dibahas sebatas `AOL-PCK-D1`; aturan pemilihan outlet sendiri belum ditutup spec ini.
- **Nomor pick up di layar sukses pelanggan** — sudah ditutup [[SO_Case_NomorPickUpDiSukses]].
- **Nomor Waiting List** — deret berbeda, lihat [[WL_Overview]] dan [[WL_Requirements]].
- **Hak akses per role** untuk membuka menu Nomor Antrian — belum ada bahannya.
- **Hapus dan non-aktifkan setelan** — ikon `hapus` ada di desain (`131:17711`) tapi dalam kondisi tersembunyi; alurnya belum digambar.

## Status desain di Figma

| ID | Kasus | Status | Frame / node |
|---|---|---|---|
| `AOL-PCK-A1` | Data Baru mode Gabung | **sudah** — chrome sudah sama dengan mode Pisah (2026-08-27) | `131:17642` |
| `AOL-PCK-A2` | Pisah → Gabung | **sebagian** — dua ujung ada, transisi tidak | `291:2478` → `131:17642` |
| `AOL-PCK-A3` | Gabung → Pisah | belum ada | — |
| `AOL-PCK-A4` | Preview | **sudah** — sekarang di panel kanan | `131:17717`, `131:17720` |
| `AOL-PCK-B1`…`B4` | Validasi | belum ada | — |
| `AOL-PCK-C1`…`C3` | Perilaku deret | belum ada (perilaku sistem) | — |
| `AOL-PCK-D1` | Cakupan outlet | **sebagian** — tab Outlet ada, aturan deret tidak | `291:3193` |

**Catatan menyeluruh:** setelah penyamaan 2026-08-27, mode Gabung dan mode Pisah memakai chrome dan layout kartu yang identik — bedanya tinggal isi kartu, dan itu memang disengaja. Yang masih kurang: mode Gabung punya **satu** frame (form kosong Data Baru), sedangkan mode Pisah punya Data Baru **dan** Terisi. Sebelum grup B dan C bisa diuji, mode Gabung butuh minimal satu frame Terisi dan satu frame state error.

## Pertanyaan terbuka

Nomor tidak pernah dipakai ulang. Pertanyaan yang sudah dijawab tetap di tabel dengan status **ditutup** supaya jejak keputusannya terbaca.

| No | Pertanyaan | Menunggu | Terkait | Status |
|---|---|---|---|---|
| 1 | Layar **Nomor Antrian** dibuka dari jalur menu mana? Frame `131:17642` punya layer tersembunyi bernama `Pengaturan Waiting List` dan teks `Waiting List` di header — apakah menu ini anak dari Waiting List, atau menu sendiri? | — | A1 | **ditutup 2026-08-27** — tidak ada layar terpisah. Pintu masuknya AOL → **Customer Display** → Data Baru → `Tipe` = `Nomor antrian` |
| 2 | Saat radio dipindah, isi field mode lama **dibuang atau disimpan sebagai draft**? | — | A2, A3 | **ditutup 2026-08-27** — **dibuang**. Isi field mode yang ditinggalkan hilang, tidak dipulihkan saat pindah balik. Sisi konfirmasinya dipisah ke no. 17 |
| 3 | Copy persis pesan error untuk `No Mulai Dari` kosong dan rentang terbalik, beserta wadahnya (inline di bawah field / toast / modal) | keputusan PM + copy UI/UX | B1, B3 | terbuka |
| 4 | Bentuk preview saat `Inisial Antrian` kosong — `0001`, atau `- 0001`? | keputusan PM | B2 | terbuka |
| 5 | Dua drift copy, **ada di kedua frame** (Gabung dan Pisah): (a) `Penomoran antrean*` memakai asterisk **hitam**, sedangkan `No Mulai Dari*` merah; (b) kapitalisasi tidak konsisten — `Gabung semua channel` (sentence case) vs `Pisah Per Channel` (title case). Mana yang benar? | perbaikan Figma + copy UI/UX | A1 | terbuka |
| 6 | Pada `131:18216` chip outlet tergambar **"Outlet BSD" dua kali**, dan ada chip tersembunyi `[100191] Pembelian Aset`. Placeholder atau memang boleh outlet kembar? | — | A1, D1 | **ditutup 2026-08-27** — field `Pilih Outlet POS` beserta chip-nya sudah dihapus dari desain; outlet diambil di tab Outlet |
| 7 | `No Akhir Sampai` dikosongkan artinya apa — tanpa batas, atau ada default? Dan kenapa field ini **tidak ada** di mode `Pisah Per Channel`? | keputusan PM | B4 | terbuka |
| 8 | Deret habis di `No Akhir Sampai`: kembali ke awal, blokir, atau lanjut melewati batas? | keputusan PM | C2 | terbuka |
| 9 | Ganti mode pada record yang deretnya sudah jalan hari itu — deret baru mulai hari ini atau besok? | keputusan PM | C3 | terbuka |
| 10 | Satu record ke beberapa outlet: deret **dibagi** antar outlet, atau **per outlet**? | keputusan PM | D1 | terbuka |
| 11 | Letak blok preview berbeda antar frame: mode Gabung menaruh **Contoh hasil penomoran** di bawah field (kolom kiri), mode Pisah menaruhnya di **panel kanan** kartu. Mana yang final? | — | A1, A4 | **ditutup 2026-08-27** — panel kanan, mengikuti mode Pisah |
| 12 | Dua layar berbeda memuat kartu **Buat Daftar Pick Up** dengan header yang tidak sama: `131:17642` memakai `Nama :` + `Pilih Outlet POS*`, sedangkan `291:2478` memakai `Nama *` + `Tipe *` = `Nomor antrian` di bawah tab **Customer Display**. Satu fitur dua pintu masuk, atau dua iterasi desain? | — | A1, A2 | **ditutup 2026-08-27** — dua iterasi desain. Versi Customer Display yang dipakai; frame Gabung sudah disamakan |
| 13 | Rail langkah punya **tiga** tab; yang kedua = kartu Buat Daftar Pick Up, ketiga = Outlet. **Tab pertama isinya apa?** Nama layer di frame lama menyebut `Icon Info Utama`, tapi belum ada frame yang menggambarkannya | perbaikan Figma / info DEV | A1 | **ditutup 2026-08-27** — rail ditata ulang: langkah **pertama** = kartu Buat Daftar Pick Up (aktif). Isi langkah 2 dan 3 masih pertanyaan no. 15 |
| 14 | Frame Gabung memakai font **`Arial Bold`** pada teks preview `A - 0001`, dan font itu **tidak ada** di file (missing font). Frame Pisah memakai teks preview yang sama. Ganti ke font design system (`Be Vietnam Pro`)? | perbaikan Figma | A1, A4 | terbuka |
| 15 | Rail baru: langkah 2 berikon dokumen **`INFORMASI`** dan langkah 3 berikon kantong uang **`RP`**. **Dua langkah itu layar apa?** Sebelumnya langkah ke-3 adalah **tab Outlet** (`291:3193`) — ikon kantong `RP` tidak menggambarkan pemilihan outlet | keputusan PM | A1, D1 | terbuka |
| 16 | Rail versi baru baru dipasang di **frame Gabung** (`131:17642`). Frame `291:2478`, `292:1149`, `291:3193`, `294:832` masih memakai rail lama (tiga ikon `Rincian Barang`, aktif di tengah). Terapkan rail baru ke frame-frame itu juga? | keputusan PM + perbaikan Figma | A1, A2, C3, D1 | terbuka |
| 17 | Pembuangan isi field saat pindah radio (no. 2) **perlu konfirmasi lebih dulu atau langsung**? Kalau perlu, wadahnya modal (butuh pilihan Lanjut/Batal), bukan toast — dan copy-nya belum ada. Catatan: risikonya kecil kalau field mode lama masih kosong, tapi nyata kalau merchant sudah mengetik beberapa baris channel | keputusan PM | A2, A3 | terbuka |
| 18 | `Inisial Antrian` = `A`, `No Mulai Dari` = `0001`, `No Akhir Sampai` = `9999` pada frame `131:17642`: itu **nilai default sistem** atau cuma **contoh isian yang digambar desainer**? Jawabannya menentukan keadaan baris Gabung tepat setelah pindah radio (A2) dan keadaan form baru (A1). Pertanyaan yang sama berlaku untuk jumlah baris channel di form baru mode Pisah | keputusan PM | A1, A2, A3 | terbuka |

| 19 | Toggle `Queue Number` **OFF** menutup apa? Record Customer Display bertipe `Nomor antrian` masih boleh dibuat dan disimpan, atau tipe itu ikut hilang dari `Tipe *`? Dan kalau toggle dimatikan setelah record terisi — record-nya diapakan? | keputusan PM + DEV | semua |
| 20 | Tiga nama untuk satu fitur: `Queue Number` (toggle Fitur Opsional), `Nomor antrian` (nilai `Tipe` record), **Nomor Pick Up** (keputusan produk di [[SO_Case_NomorPickUpDiSukses]]). PM 2026-08-27: sementara pakai **Nomor Pick Up**, nama final belum diputus. | keputusan PM | semua |

---

## Lampiran A — Kamus layar

| Nama layar | Isinya | Cara membuka |
|---|---|---|
| **Pengaturan POS › Fitur Opsional** (Setup AOL) | Dua kolom setelan. Yang dipakai di sini: kolom **Manajemen Fitur**, baris toggle `Queue Number` (baris ke-9) yang menyalakan fitur nomor antrian | AOL → **Pengaturan POS** → **Fitur Opsional** |
| **Customer Display — Data Baru, Tipe `Nomor antrian`** | `Nama *`, `Tipe *`, rail tiga langkah, kartu isi sesuai langkah aktif, tombol Simpan | AOL → **Customer Display** → tab **Data Baru** → `Tipe *` = `Nomor antrian` |
| **Buat Daftar Pick Up** (kartu, rail langkah **ke-1**, ikon dokumen berbaris) | radio `Penomoran antrean*`, blok field penomoran sesuai mode di kolom kiri, blok **Contoh hasil penomoran** di panel kanan | langkah pertama pada layar di atas |
| **Outlet** (kartu) | search `Cari/Pilih Outlet`, tombol `Ambil`, tabel `Nama outlet` (empty state `Belum ada data`), judul panel kanan `Outlet *` | frame `291:3193` menggambarkannya sebagai langkah **ke-3**; setelah rail diganti, ikon langkah ke-3 jadi kantong `RP` — lihat pertanyaan terbuka no. 15 |

Layar **Nomor Antrian** yang berdiri sendiri (versi lama frame Gabung) **sudah tidak ada** — lihat pertanyaan terbuka no. 1 dan no. 12.

## Lampiran B — Peta node Figma

Hanya untuk desainer dan DEV. **Tidak perlu dibaca QA.** File: `hl2CORgtDUUUo7A1Gj86mz` (`Pick-Up`).
Pola link: `https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=<node>` (titik dua pada node diganti tanda hubung).

Node yang ditandai **baru (2026-08-27)** lahir dari penyamaan frame Gabung ke frame Pisah.

| Nama section / frame | Node | Terkait |
|---|---|---|
| `CD · Data Baru — Tipe Nomor antrian — Gabung semua channel` (frame utama; di-rename 2026-08-27, sebelumnya `Nomor Antrian`) | [`131:17642`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=131-17642) | A1, A2, A3, A4 |
| Kartu `Pengaturan Antrian` (Buat Daftar Pick Up) | [`131:17717`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=131-17717) | A1, A4 |
| `Container` — auto-layout HORIZONTAL: kolom kiri form, panel kanan preview | [`131:17743`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=131-17743) | A1, A4 |
| Baris field mode Gabung (`Inisial` · `Mulai` · `Akhir`) | [`131:17770`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=131-17770) | A1, B1–B4 |
| Baris field mode Pisah — **tersembunyi** di frame Gabung (5 baris) | `131:17782`, `131:17826`, `131:17870`, `131:17914`, `131:17958` | A1 (titik rawan) |
| Label `Contoh hasil penomoran` di panel kanan — **baru (2026-08-27)** | `311:946` | A1, A4 |
| Teks preview `A - 0001` (dipindah ke panel kanan, `layoutPositioning = ABSOLUTE`; font `Arial Bold` missing) | [`131:17720`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=131-17720) | A4, pertanyaan 14 |
| Baris header `Nama *` / spacer / `Tipe *` — **baru (2026-08-27)** | `311:7`, `311:13`, `311:14` | A1 |
| Tab browser aktif `Customer Display` — **baru (2026-08-27)** | `311:2` | A1 |
| Rail tiga langkah — **baru (2026-08-27)**. Aktif = `311:905` (langkah 1). Ikon: `Info Lainnya 2` di `311:912`, `Variant15` di `311:927` | `311:905`, `311:912`, `311:927` | A1 |
| Ikon aktif pink (instance `Rincian Barang`, fill vector dioverride ke `#ED3A6A`) — **baru (2026-08-27)** | `331:8` | A1 |
| Component set ikon rail — **dari library eksternal**, tidak ada di canvas file ini. 15 variant lewat property `Property 1` | `131:2578` | A1 |
| Section **Flow & Catatan — Customer Display (AOL)** — diagram alur + catatan per frame, dibuat 2026-08-27 di sebelah kiri section `291:2106` | [`337:896`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=337-896) | semua |
| Badge nomor 1–6 di selasar kiri section `291:2106`, dan badge `G` di frame Gabung | `341:896`, `341:898`, `341:900`, `341:902`, `341:904`, `341:906`, `341:908` | semua |
| Ikon Simpan / Hapus (hapus tersembunyi) | `131:17698` / `131:17711` | A1, luar scope |
| Section **Customer Display — dua tipe record (AOL)** | [`291:2106`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=291-2106) | konteks |
| CD — Data Baru — Tipe `Nomor antrian` (**state Pisah Per Channel**, acuan penyamaan) | [`291:2478`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=291-2478) | A2, A3 |
| CD — **Terisi** — Tipe `Nomor antrian` (masih mode Pisah) | [`292:1149`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=292-1149) | C3 (bukti celah) |
| CD — Data Baru — **tab `Outlet`** | [`291:3193`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=291-3193) | D1 |
| CD — Terisi — tab `Outlet` | `294:832` | D1 |
| CD — Data Baru / Terisi — Tipe `Customer display`, tab Banner | `291:2107`, `292:751` | luar scope |

| Baris toggle `Queue Number` di **Fitur Opsional** — gerbang fitur; ada di halaman `Setup AOL`, bukan di halaman Customer Display | [`258:2821`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=258-2821) | prasyarat semua |
| Kartu `Feature Management` (kolom **Manajemen Fitur**). Urutan baris: Pesanan Draft · Tipe Penjualan · Transaksi Piutang · Split Payment · Open Bill · Table Management · Kitchen Display System · Uang Muka · **Queue Number** · Bliss | [`258:2732`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=258-2732) | prasyarat semua |
| Frame `Fitur Opsional`, di dalam section `Case : Journey Pelajari Lebih Lanjut Di Order Status Display` (`258:2644`) | [`258:2645`](https://www.figma.com/design/hl2CORgtDUUUo7A1Gj86mz/Pick-Up?node-id=258-2645) | prasyarat semua |

**Node yang sudah tidak ada** (dihapus 2026-08-27, jangan dicari lagi): `131:18216` (header `Nama :` + `Pilih Outlet POS*`), `131:18018` (tab `Nomor Antrian`), `131:17719` (label preview versi lebar penuh), `131:17721` + `131:17736` (rail dua langkah), `131:18010` (`Frame 3195`, frame kosong tanpa isi), `311:915` (ikon aktif lama `Icon Info Utama`, frame vektor lepas).
