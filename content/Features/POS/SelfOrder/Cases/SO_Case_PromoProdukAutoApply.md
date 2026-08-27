# Self Order — Case: Promo Produk Full Auto-Apply (Klaim Otomatis & Info Menu)

**Status:** Draft
**Tanggal:** 2026-08-10
**Fitur:** Self Order — sisi pelanggan (Menu, Detail Item, Keranjang, Promo Produk). **Bukan cakupan:** Diskon Transaksi (PAGE-06V) — mekanisme pilih/lepas manual di sana tidak berubah.
**Prefix ID kasus:** `SO-PPA`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · PM (keputusan produk)
**Referensi:** [[SO_PRD_MVP]] (§6 Kategori Promo, PAGE-04, PAGE-05, PAGE-06, PAGE-07), [[SO_Case_PromoTidakBerlaku]] (pola `ValidationPopup`/`IssueRow` dipakai ulang untuk edge case stok habis di dokumen ini)
**Format dokumen ini mengikuti:** [[Riset_Workflow_Handoff_UIUX_QA_DEV]] (5 blok per kasus)
**Desain:** Belum ada frame baru digambar. Row "Informasi Promo" existing di PAGE-05 (Figma node `529:380`, [link](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=529-380)) dipakai sebagai dasar — chevron di row ini akan dihapus sesuai keputusan di bawah.

> **Dokumen ini men-supersede** deskripsi PAGE-07 (`FreeItemSheet`), badge "PROMO", dan bagian terkait di [[SO_PRD_MVP]] (FR-06, AC-04.7, AC-04.8, AC-07.1/07.2/07.4/07.5, elemen "Chip Klaim" di §6.2). PRD belum diedit fisik — perubahan itu jadi tugas implementasi/dokumentasi lanjutan, bukan bagian brainstorming ini.

---

## Latar belakang

[[SO_PRD_MVP]] §6 sudah menetapkan **Promo Produk** (barang gratis/diskon produk) sebagai kategori otomatis — "tamu tidak bisa memilih atau melepasnya". Tapi dua celah belum tertutup:

1. **PAGE-07 (`FreeItemSheet`) masih memberi pilihan manual.** Kalau promo barang-gratis punya ≥2 varian hadiah, sheet ini muncul dan tamu memilih sendiri variannya — bertentangan dengan prinsip "tidak bisa memilih" di atas. Cuma kasus 1-varian yang benar-benar auto-apply hari ini.
2. **Tampilan promo di Menu (PAGE-04) belum tegas soal batas interaksinya.** Row "Informasi Promo" di PAGE-05 punya chevron (tappable) tanpa tujuan yang di-spec, dan badge PROMO di kartu Grid menyiratkan status per-item yang sebetulnya cuma bisa dihitung akurat di level Keranjang.
3. **Belum ada aturan kalau 1 barang ke-match >1 Promo Produk sekaligus** — baik soal tampilan maupun soal promo mana yang benar-benar berlaku kalau syaratnya bentrok.

**Perubahan yang ditutup dokumen ini:**

- PAGE-07 dihapus total. ≥2 varian hadiah diselesaikan otomatis oleh sistem, bukan oleh tamu.
- Badge "PROMO" di kartu Menu **dihapus** — info promo per item cukup lewat rail `PromoRail`/`OfferRail` (deklaratif, tanpa navigasi) dan row "Informasi Promo" di PAGE-05 (chevron dihapus, jadi teks statis).
- Item boleh **tampil** ke-match lebih dari satu Promo Produk sekaligus di "Informasi Promo", tapi kalau syaratnya bentrok di Keranjang, cuma **satu** yang benar-benar diapply — menang lewat prioritas kuantitas-barang > nominal-transaksi, lalu tie-break nilai hasil terkecil kalau sejenis.

**Tidak berubah:** Promo Produk tipe diskon-kuantitas (mis. "Beli 2, diskon 20%") sudah auto-apply sejak awal — tamu manual nambah qty, begitu syarat tercapai diskon otomatis kepotong tanpa ada titik pilihan. Dokumen ini cuma mempertegas copy-nya di Menu, bukan mengubah mekanismenya.

## Keputusan produk

| Topik | Keputusan |
|---|---|
| Sheet PAGE-07 (`FreeItemSheet`) | **Dihapus total.** Berapa pun jumlah varian hadiah (1 atau lebih), alur sama persis: item gratis langsung nempel di Keranjang sebagai baris "Gratis", tanpa sheet, tanpa interupsi. |
| Pemilihan varian hadiah saat ≥2 pilihan | **Otomatis oleh sistem.** Urutkan varian berdasar harga satuan, ascending. Ambil varian pertama yang stoknya tersedia. |
| Dasi harga (2+ varian sama-sama termurah) | Tie-break berdasar **nama item, alfabetis A→Z**. |
| Semua varian hadiah habis stok | **Tidak ada notifikasi baru** di Menu atau Keranjang. Ketahuan lewat `ValidationPopup` (`IssueRow`) saat tamu menekan "Konfirmasi Pesanan" — pola deteksi & nada yang sama dengan [[SO_Case_PromoTidakBerlaku]]. |
| Chip "Klaim" pada baris item pemicu di Keranjang | **Dihapus.** Fungsinya (buka PAGE-07) sudah tidak ada. |
| Promo Produk di Menu (rail `PromoRail`/`OfferRail`, row "Informasi Promo" PAGE-05) | **Murni informasi.** Tap di permukaan mana pun tidak membuka sheet, tidak menambah item, tidak memicu aksi apa pun. Menambah item ke Keranjang tetap lewat tombol "Tambah" biasa di kartu Menu / PAGE-05. |
| Chevron di row "Informasi Promo" (PAGE-05) | **Dihapus.** Row jadi teks statis (bukan tappable) — konsisten dengan prinsip "murni informasi". |
| Copy syarat+hasil di kartu Menu & row "Informasi Promo" | Digabung jadi **satu kalimat: syarat DAN hasil konkret**, mis. "Beli 2, diskon 20%" atau "Beli 1, gratis Ayam Goreng (senilai Rp15.000)" — bukan cuma syarat generik seperti sekarang. |
| Instruksi tambahan di row "Informasi Promo" | Tambah 1 baris kecil: **"Promo diterapkan otomatis di Keranjang saat syarat terpenuhi."** — supaya tamu tahu prosesnya, karena tidak ada lagi titik konfirmasi di tengah jalan. |
| Item ke-match >1 Promo Produk sekaligus — **tampilan** di Menu/PAGE-05 | **Boleh menumpuk, tidak dibatasi 1.** Semua promo yang nempel di item itu ditampilkan sebagai baris terpisah di "Informasi Promo" — ini murni deklaratif ("item ini ikut promo apa aja"), bukan hasil hitungan real-time. |
| Item ke-match >1 Promo Produk sekaligus — **yang benar-benar diapply** di Keranjang | **Cuma 1 yang jalan**, tidak digabung. Menang lewat prioritas: **syarat kuantitas-barang mengalahkan syarat nominal-transaksi.** Promo yang kalah tidak berefek sama sekali ke item itu di transaksi ini (bukan cuma disembunyikan). |
| Dasi antar-promo sejenis (sama-sama kuantitas-barang, atau sama-sama nominal-transaksi) | Tie-break: **nilai hasil promo yang lebih kecil yang menang** (bandingkan rupiah hemat/nilai hadiah — bukan harga item, karena itemnya sama). Selaras dengan prinsip "sistem pilih opsi termurah kalau harus milih sendiri" yang juga dipakai di algoritma pemilihan varian hadiah. |
| Dasi lanjutan (nilai hasil juga persis sama) | Belum pernah ditanyakan eksplisit — diasumsikan tie-break nama promo alfabetis A→Z, konsisten dengan pola tie-break varian hadiah. **Perlu dikonfirmasi PM**, lihat Pertanyaan Terbuka. |
| Badge "PROMO" di kartu Menu (varian Grid) | **Dihapus total.** Kartu Menu polos, tidak ada penanda apa pun soal promo per item — sesuai prinsip Menu = etalase (declaratif di level campaign), Keranjang = tempat hitungan sebenarnya jalan. |
| Info promo di halaman Menu, setelah badge dihapus | **Satu-satunya tempat**: `PromoRail`/`OfferRail` di Hero PAGE-04. Menampilkan promo yang sedang berjalan (nama + syarat + hasil), tapi tidak terikat ke item spesifik di grid. |
| Tap kartu di `PromoRail`/`OfferRail` | **Tidak menavigasi ke mana pun** (tidak scroll/highlight item di grid). Murni tampilan info — alasan: kelayakan promo per-item itu perhitungan Keranjang (cart-aware), Menu tidak punya logika itu dan sengaja tidak dibuatkan. |
| Promo Produk tipe diskon-kuantitas (mis. "Beli 2, diskon 20%") | **Mekanisme tidak berubah.** Tamu tetap manual nambah qty; begitu syarat tercapai, diskon otomatis kepotong tanpa input/pilihan lain. |

## Prinsip

- **Auto-apply berarti tidak ada keputusan manual dari tamu di titik mana pun untuk Promo Produk.** Kalau masih ada pilihan (varian, konfirmasi, klaim), berarti belum benar-benar auto-apply — ini alasan PAGE-07 dihapus, bukan diubah jadi read-only.
- **Kejelasan di depan menggantikan konfirmasi di tengah jalan.** Karena tidak ada lagi sheet/dialog yang menjelaskan promo saat diklaim, syarat & hasil harus sudah jelas sejak tamu pertama kali lihat promo di Menu — copy syarat+hasil gabungan ada di sini karena itu.
- **Keterbatasan (stok habis) ditangani di titik deteksi yang sudah ada, bukan bikin titik baru.** Konsisten dengan prinsip "jangan ulang notifikasi yang sudah selesai di-acknowledge" di [[SO_Case_PromoTidakBerlaku]] — `ValidationPopup` tetap satu-satunya momen wajib-dibaca.
- **Menu itu etalase, Keranjang itu tempat kejadian.** Interaksi apa pun terkait Promo Produk (tambah item, dapat hadiah, dapat diskon) hanya terjadi di alur normal tambah-ke-Keranjang — tidak pernah lewat elemen promo itu sendiri. Menu boleh menampilkan semua promo yang nempel di sebuah item (deklaratif), tapi tidak pernah menghitung mana yang benar-benar akan berlaku — itu wewenang Keranjang.
- **Kalau sistem harus memilih sendiri tanpa nanya tamu, menangkan opsi bernilai paling kecil.** Berlaku konsisten di tiga tempat: varian hadiah termurah yang dipilihkan (bukan yang termahal), promo dengan hasil bernilai lebih kecil yang menang saat dua promo sejenis bentrok di satu barang, dan tie-break alfabetis (netral, tidak menguntungkan pilihan tertentu) kalau nilainya masih seri.

## Perubahan elemen

### PAGE-07 (`FreeItemSheet`) — dihapus

| | Sebelum | Sesudah |
|---|---|---|
| 1 varian hadiah | Auto-apply, sheet dilewati | Tidak berubah |
| ≥2 varian hadiah | Sheet muncul, tamu pilih manual | **Sheet dihapus.** Sistem pilih otomatis (lihat algoritma di bawah) |
| Chip "Klaim" di baris item pemicu (Keranjang) | Ada, membuka PAGE-07 | **Dihapus** |
| Semua varian habis stok | Pesan "Hadiah promo sedang tidak tersedia" tampil di dalam sheet | **Tidak ada pesan di Keranjang/Menu.** Ketahuan lewat `ValidationPopup` saat Konfirmasi Pesanan |

### Algoritma pemilihan varian hadiah otomatis

1. Urutkan varian hadiah berdasarkan harga satuan, ascending.
2. Ambil varian pertama dalam urutan itu yang stoknya tersedia (>0).
3. Kalau ada dasi harga di antara kandidat termurah, tie-break berdasarkan nama item, alfabetis A→Z.
4. Kalau **semua** varian habis stok, promo gratis tidak diklaim saat itu — tidak ada penggantian ke item lain, tidak ada notifikasi baru; status ini baru muncul lewat `ValidationPopup` (`IssueRow`) saat "Konfirmasi Pesanan".

### Row "Informasi Promo" (PAGE-05) — revisi

| Bagian | Sebelum | Sesudah |
|---|---|---|
| Copy | "Item ini diberlakukan Promo: {deskripsi syarat}" | "Item ini diberlakukan Promo: {syarat & hasil dalam 1 kalimat}" |
| Baris instruksi | Tidak ada | Tambah: "Promo diterapkan otomatis di Keranjang saat syarat terpenuhi." |
| Chevron (kanan) | Ada, tujuan belum di-spec | **Dihapus** — row jadi teks statis |
| Item dengan >1 Promo Produk aktif | Tidak ditentukan | **Tampilkan semua** sebagai baris terpisah, satu baris per promo |

### Kartu Menu & rail "Promo Hari Ini" (PAGE-04) — badge dihapus, jadi murni informatif via rail

| Bagian | Sebelum | Sesudah |
|---|---|---|
| Badge "PROMO" di kartu Menu (varian Grid) | Ada, kiri atas foto, item yang punya Promo Produk aktif | **Dihapus total.** Kartu Menu tidak punya penanda promo apa pun lagi. |
| Copy pada `PromoRail`/`OfferRail` | Deskripsi syarat saja (mis. "Beli 1, gratis Ayam Goreng") | Syarat + hasil konkret dalam 1 kalimat (mis. "Beli 1, gratis Ayam Goreng (senilai Rp15.000)") |
| Interaksi tap di `PromoRail`/`OfferRail` | Belum dinyatakan eksplisit | **Murni preview, tanpa navigasi.** Tap tidak menambah item, tidak membuka aksi apa pun, tidak scroll/highlight ke item terkait di grid. Menemukan item dengan promo cukup lewat scroll/search Menu biasa. |

> **Kenapa gak ada badge atau navigasi ke item spesifik:** kelayakan sebuah item terhadap promo (apalagi promo dengan syarat kombinasi item) itu perhitungan yang berbasis isi Keranjang saat itu, bukan properti statis yang bisa ditempel di kartu Menu. Menu sengaja tidak dibuatkan logika baca-Keranjang untuk ini — itu alasan yang sama kenapa promo cuma "kejadian" di Keranjang, bukan di Menu.

---

## SO-PPA-1 — Promo barang-gratis ≥2 varian, sistem auto-pilih varian harga satuan terkecil

**Prasyarat**

- Ada Promo Produk aktif tipe barang-gratis dengan ≥2 varian hadiah berbeda harga (mis. Es Teh Rp8.000, Es Jeruk Rp10.000).
- Semua varian hadiah tersedia stoknya.

**Langkah reproduksi**

1. Tamu menambahkan item pemicu ke Keranjang hingga syarat promo terpenuhi.
2. Perhatikan Keranjang — tidak ada sheet/interupsi apa pun yang muncul.
3. Perhatikan baris "Gratis" yang menempel item pemicu.

**Hasil yang diharapkan**

- Tidak ada PAGE-07 atau sheet pilihan apa pun yang muncul.
- Baris "Gratis" menampilkan varian dengan harga satuan terkecil (Es Teh, Rp8.000) — bukan tamu yang memilih.
- Tidak ada Chip "Klaim" di baris item pemicu.

**Hasil aktual (2026-08-10)**

Belum diimplementasikan/digambar. PAGE-07 masih ada di Figma existing (belum dihapus sesuai keputusan dokumen ini).

---

## SO-PPA-2 — Varian termurah habis stok, sistem lompat ke termurah berikutnya yang tersedia

**Prasyarat**

- Promo barang-gratis punya ≥3 varian hadiah, mis. Es Teh Rp8.000 (habis), Es Jeruk Rp10.000 (tersedia), Es Kopi Rp15.000 (tersedia).

**Langkah reproduksi**

1. Tamu memenuhi syarat promo seperti SO-PPA-1.
2. Perhatikan varian mana yang otomatis nempel sebagai baris "Gratis".

**Hasil yang diharapkan**

- Sistem skip Es Teh (habis), ambil Es Jeruk (Rp10.000) — termurah berikutnya yang stoknya ada.
- Tidak ada pesan error atau notifikasi apa pun ke tamu soal Es Teh yang habis.

**Hasil aktual (2026-08-10)**

Belum diimplementasikan.

---

## SO-PPA-3 — Semua varian hadiah habis stok, ketahuan lewat ValidationPopup saat Konfirmasi Pesanan

**Prasyarat**

- Promo barang-gratis dengan seluruh variannya berstatus habis stok.
- Tamu sudah memenuhi syarat pemicu di Keranjang.

**Langkah reproduksi**

1. Tamu memenuhi syarat promo dengan seluruh varian hadiah habis.
2. Perhatikan Keranjang — pastikan tidak ada indikator apa pun soal hadiah yang gagal diklaim.
3. Tamu menekan "Konfirmasi Pesanan".
4. Amati `ValidationPopup` yang muncul.

**Hasil yang diharapkan**

- Langkah 2: Keranjang tidak menampilkan baris "Gratis" apa pun untuk promo ini, dan tidak ada pesan/badge tambahan yang menjelaskan kenapa.
- Langkah 4: `ValidationPopup` menampilkan `IssueRow Type=Promo` yang menjelaskan hadiah promo tidak tersedia, dengan tombol "Lanjut Bayar" (auto-resolve, bukan keputusan manual — sama nada dengan [[SO_Case_PromoTidakBerlaku]]).

**Hasil aktual (2026-08-10)**

Belum diimplementasikan. Copy pasti untuk `IssueRow` di kasus ini belum final — lihat Pertanyaan Terbuka.

---

## SO-PPA-4 — Item ke-match 2 Promo Produk sekaligus: keduanya tampil di Informasi Promo, tapi cuma 1 yang diapply

**Prasyarat**

- Satu item (Ayam Goreng, Rp25.000) punya 2 Promo Produk aktif bersamaan dengan syarat pemicu **berbeda tipe**: Promo A "Beli 2, gratis Es Teh" (syarat kuantitas-barang) dan Promo B "Belanja Rp50.000, diskon 20% Ayam Goreng" (syarat nominal-transaksi).

**Langkah reproduksi**

1. Tamu membuka detail item tersebut (PAGE-05) sebelum menambah ke Keranjang. Perhatikan section "Informasi Promo".
2. Tamu menambahkan 2 Ayam Goreng ke Keranjang (total Rp50.000 — kedua syarat kepenuhi bersamaan).
3. Perhatikan Keranjang — baris promo apa yang muncul menempel Ayam Goreng.

**Hasil yang diharapkan**

- Langkah 1: **kedua** promo (A dan B) tampil sebagai baris terpisah di "Informasi Promo" — murni deklaratif, belum ada perhitungan menang-kalah di sini.
- Langkah 3: cuma **Promo A** yang diapply (baris "Gratis Es Teh" menempel Ayam Goreng) karena kuantitas-barang menang atas nominal-transaksi. Promo B tidak berefek sama sekali ke transaksi ini — tidak ada diskon 20% yang kepotong.

**Hasil aktual (2026-08-10)**

Belum diimplementasikan.

---

## SO-PPA-5 — Dua Promo Produk sejenis bentrok di 1 barang, nilai hasil terkecil yang menang

**Prasyarat**

- Ayam Goreng (Rp25.000) punya 2 Promo Produk **sama-sama bersyarat kuantitas-barang**: Promo C "Beli 2, gratis Es Teh (nilai Rp8.000)" dan Promo D "Beli 2, diskon 15% Ayam Goreng (nilai ~Rp7.500)".

**Langkah reproduksi**

1. Tamu menambahkan 2 Ayam Goreng ke Keranjang — kedua syarat kuantitas kepenuhi bersamaan.
2. Perhatikan baris promo yang menempel di Keranjang.

**Hasil yang diharapkan**

- Prioritas kuantitas-vs-nominal tidak berlaku (dua-duanya kuantitas-barang) — tie-break jatuh ke **nilai hasil terkecil**.
- Promo D (hemat ~Rp7.500) menang atas Promo C (nilai Rp8.000) karena nilainya lebih kecil. Baris yang tampil: diskon 15%, bukan gratis Es Teh.

**Hasil aktual (2026-08-10)**

Belum diimplementasikan.

---

## SO-PPA-6 — Permukaan promo di Menu murni informatif, tap tidak memicu aksi apa pun

**Prasyarat**

- Ada minimal 1 item dengan Promo Produk aktif, muncul di rail "Promo Hari Ini".

**Langkah reproduksi**

1. Tamu tap kartu di rail "Promo Hari Ini" (`PromoRail`/`OfferRail`).
2. Tamu tap row "Informasi Promo" di PAGE-05.

**Hasil yang diharapkan**

- Tidak ada langkah yang menambah item ke Keranjang, membuka sheet, atau menavigasi ke item tertentu di grid.
- Row "Informasi Promo" tidak lagi punya chevron; visualnya teks statis.
- Satu-satunya cara menambah item tetap tombol "Tambah" di kartu Menu / PAGE-05.

**Hasil aktual (2026-08-10)**

Belum diimplementasikan/digambar.

---

## SO-PPA-7 — Badge PROMO sudah tidak ada, item dengan Promo Produk tampil polos di grid

**Prasyarat**

- Ada item dengan Promo Produk aktif, tampil di varian Grid Menu.

**Langkah reproduksi**

1. Tamu membuka Menu (PAGE-04), lihat grid item.
2. Bandingkan tampilan kartu item yang punya Promo Produk vs yang tidak.

**Hasil yang diharapkan**

- Tidak ada perbedaan visual apa pun di kartu grid antara item yang punya Promo Produk dan yang tidak (kecuali badge "Habis" untuk item stok habis, yang tidak berubah).
- Info promo item tersebut hanya bisa dilihat lewat scroll `PromoRail`/`OfferRail` di Hero, atau buka detail item di PAGE-05.

**Hasil aktual (2026-08-10)**

Belum diimplementasikan/digambar. AC-04.7 dan AC-04.8 di [[SO_PRD_MVP]] (soal badge PROMO) jadi tidak berlaku lagi — perlu dihapus saat PRD diupdate.

---

## Yang di luar scope (sengaja tidak dikerjakan)

- **Promo Produk tipe diskon (bukan barang-gratis)** — tidak pernah punya sheet pilihan, jadi tidak terdampak algoritma pemilihan otomatis. Cuma dapat penegasan copy syarat+hasil di Menu.
- **Mekanisme `PromoCard Status=Bermasalah` di PAGE-06V** — tetap tidak berlaku untuk Promo Produk, sudah didokumentasikan di [[SO_Case_PromoTidakBerlaku]].
- **Diskon Transaksi (PAGE-06V)** — mekanisme pilih/lepas manual via tombol "Pakai"/"Dipakai" tidak berubah sama sekali oleh dokumen ini.
- **Desain visual final di Figma** — dokumen ini spec teks & perilaku dulu; frame Menu/PAGE-05 revisi dan penghapusan PAGE-07 di canvas belum digambar.

## Pertanyaan terbuka

| No | Pertanyaan | Menunggu | Terkait |
|---|---|---|---|
| 1 | Copy pasti `IssueRow` saat "semua varian hadiah promo habis stok" — belum ada teks final. | Keputusan PM | `SO-PPA-3` |
| 2 | Urutan tampil antar-promo di "Informasi Promo" kalau item punya >2 Promo Produk sekaligus (>2, bukan cuma 2) — berdasar urutan dibuat di POS, atau ada aturan lain? | Keputusan PM | `SO-PPA-4` |
| 3 | Kalau dua promo yang bentrok nilainya PERSIS sama (tie-break "nilai terkecil" juga seri) — diasumsikan tie-break nama promo alfabetis A→Z, konsisten dengan pola varian hadiah. Perlu dikonfirmasi ini benar atau ada aturan lain. | Keputusan PM | `SO-PPA-5` |
