# Self Order — Case: Nomor Pick Up di Layar Sukses

**Status:** Draft
**Tanggal:** 2026-08-26
**Fitur:** Self Order — layar **Sukses (PAGE-11)** di aplikasi pelanggan. Penempatan **nomor pick up** saat outlet memakai model ambil-sendiri.
**Prefix ID kasus:** `SO-PCK`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · UI/UX (eksekusi desain) · PM (keputusan produk)
**Referensi:** [[SO_PRD_MVP]], [[SO_PRD]] (PAGE-11), [[SO_Case_RincianPesananCampuran]], [[SO_Case_BagikanStrukNegative]], [[SO_Case_ToastSuksesBagikanStruk]], [[SO_Case_SetupAOLFiturOpsional]] (letak toggle-nya), [[PCK_Case_GabungSemuaChannel]] (aturan penomorannya di AOL)
**Bukan sumber nomor:** [[WL_Overview]], [[WL_Requirements]] — dibedakan sengaja, lihat [[#Nomor Pick Up bukan nomor Waiting List|§Nomor Pick Up bukan nomor Waiting List]].
**Format dokumen ini mengikuti:** [[Riset_Workflow_Handoff_UIUX_QA_DEV]]
**Desain:** [Case: Pembayaran Berhasil — Nomor Pick Up](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3642-708) (`3642:708`), page `↳ Selesai & Struk`, di dalam `Section 1` (`2489:33909`). File `mAZuRze02w906M6u2EwVWh`. Section ini memuat dua layar (Take Away & Dine In) plus frame `catatan`. Node dikumpulkan di [[#Lampiran B — Peta node Figma|Lampiran B]].

---

## Cara membaca dokumen ini

Setiap kasus ditulis dengan lima bagian yang selalu sama:

| Bagian | Isi | Dipakai oleh |
|---|---|---|
| **Judul** | Ringkasan dalam satu baris: layar + kondisi + gejala | semua |
| **Prasyarat** | Kondisi, data, dan setelan yang harus disiapkan | QA |
| **Langkah reproduksi** | Langkah operasional bernomor | QA |
| **Hasil yang diharapkan** | Perilaku benar sesuai spec: copy persis, wadah, perilaku elemen | QA + DEV |
| **Hasil aktual** | Kondisi terakhir yang diketahui saat dokumen ditulis | QA + PM |

### Daftar kasus

| ID | Judul singkat | Membuktikan AC | Status desain |
|---|---|---|---|
| [[#SO-PCK-A1 — Toggle Nomor Pick Up aktif: chip tampil di batas hero↔sheet\|SO-PCK-A1]] | Chip tampil | AC-PCK.1, AC-PCK.5, AC-PCK.6 | **sudah** (`3642:709`) |
| [[#SO-PCK-A2 — Toggle Nomor Pick Up nonaktif: chip tidak tampil dan nomor tidak diterbitkan\|SO-PCK-A2]] | Toggle OFF | AC-PCK.2 | sudah — pakai baseline `543:740` |
| [[#SO-PCK-A3 — Pesanan Dine In di outlet ambil-sendiri: chip tetap tampil\|SO-PCK-A3]] | Dine In tetap dapat nomor | AC-PCK.3 | **sudah** (`3642:759`) |
| [[#SO-PCK-A4 — Pesanan campuran: satu nomor menaungi seluruh pesanan\|SO-PCK-A4]] | Campuran | AC-PCK.4 | **belum** |
| [[#SO-PCK-B1 — Nomor gagal terbit: tidak ada chip, tidak ada pesan error\|SO-PCK-B1]] | Gagal, senyap | AC-PCK.7 | **tidak digambar** (disengaja) |
| [[#SO-PCK-C1 — Nomor pick up ikut di struk yang dibagikan\|SO-PCK-C1]] | Jejak di struk | AC-PCK.8 | **belum** |
| [[#SO-PCK-C2 — Nomor pick up jadi tujuan antar di tiket dapur\|SO-PCK-C2]] | Tiket dapur | AC-PCK.9 | **belum** |
| [[#SO-PCK-D1 — Toggle diubah setelah order dikirim: nomor yang sudah terbit tidak berubah\|SO-PCK-D1]] | Tidak retroaktif | AC-PCK.10 | **belum** |
| [[#SO-PCK-D2 — Dua pesanan lunas hampir bersamaan: nomor tidak boleh dobel\|SO-PCK-D2]] | Nomor unik | AC-PCK.11 | **belum** |

---

## Sumbu yang menentukan: siapa yang menjemput makanannya

Nomor pick up **tidak** bergantung pada tipe fulfillment. Dine In dan Take Away menjawab **di mana tamu makan**; nomor pick up menjawab **siapa yang menjemput makanannya**. Dua pertanyaan berbeda.

| | Diantar | Diambil sendiri |
|---|---|---|
| **Dine In** | waiter membawanya ke meja | tamu ambil di counter, lalu duduk makan di situ |
| **Take Away** | bungkusan diantar ke meja tamu | tamu ambil di counter, lalu pulang |

Kolom kanan itu yang butuh nomor — **kedua barisnya**. Model counter-service (mis. restoran cepat saji) memberi nomor untuk pesanan dine in juga, karena tamunya tetap mengambil sendiri.

Karena itu **satu toggle level outlet** cukup, dan tipe fulfillment tidak ikut menentukan chip sama sekali.

> **Yang belum didukung, sadar dan sengaja.** Toggle tidak bisa menyatakan model hybrid — dine in diantar waiter, tapi take away diambil di counter. Di outlet seperti itu, toggle ON membuat pesanan dine in juga dapat nomor yang sebenarnya tidak dipakai. Berisik, tidak rusak. Kalau nanti perlu didukung, toggle diperluas jadi tiga nilai (*Diantar semua* / *Take Away diambil* / *Semua diambil*) — nilai ON dan OFF sekarang jadi dua di antaranya, jadi perluasan itu bersifat tambahan, bukan bongkar ulang.

**Turunan penting:** di outlet ambil-sendiri, **meja bukan alamat antar — cuma titik scan.** Tamu mengambil sendiri lalu duduk di mana saja. Jangan bangun logika pengantaran di atas relasi QR↔meja untuk outlet seperti ini. Outlet counter-service justru kandidat terkuat untuk **QR Self Order tanpa Table Management**, karena tidak ada meja yang perlu dikelola.

---

## Nomor Pick Up bukan nomor Waiting List

Bentuknya mirip — angka pendek yang dipanggil ke tamu. Siklus hidupnya berbeda seluruhnya.

| | **Nomor Pick Up** | **Nomor Antrian Waiting List** |
|---|---|---|
| Menjawab pertanyaan tamu | "pesananku sudah siap diambil?" | "kapan aku dapat meja?" |
| Terbit saat | pesanan **lunas** | tamu **mendaftar antrean masuk** |
| Selesai saat | pesanan **diambil** | tamu **didudukkan** |
| Tamu sudah punya tempat? | bisa sudah — Take Away dari Meja 5 | belum, itu justru yang ditunggu |
| Dipanggil oleh | counter pick up | host / monitor pintu masuk |
| Rumah aturannya | **belum ada** — lihat Pertanyaan terbuka no. 2 | [[WL_Requirements]] |

**Karena itu pool nomornya wajib terpisah.** Kalau `C-28` bisa berarti dua hal, staf dan tamu sama-sama salah: satu orang maju mengambil makanan, satu orang maju karena mengira mejanya siap.

Konsekuensi yang harus diterima sadar: **aturan penomoran pick up belum punya pemilik.** [[WL_Requirements]] FR-28 (unik per hari operasional) dan FR-32 (reset akhir hari) mengatur nomor WL, dan **tidak berlaku otomatis** di sini.

Ini juga alasan penamaan: toggle dan seluruh copy memakai **"Pick Up"**, bukan "Antrian".

---

## Struktur nomor pick up

Ditetapkan PM 2026-08-26. Nomor dibentuk dari **inisial + nomor urut**, dan setiap **Jenis Antrian** punya konfigurasinya sendiri.

| Field | Batas | Perannya |
|---|---|---|
| **Jenis Antrian** | maks 30 karakter | Nama jenis antrean. **Konfigurasi merchant — tidak pernah tampil ke tamu.** |
| **Inisial Antrian** | maks 2 karakter | Bagian huruf pada nomor. Inilah yang membedakan antar jenis di mata tamu. |
| **No Mulai Dari** | maks 3 karakter | Nomor urut **awal**. Bukan batas nomor berjalan — lihat Pertanyaan terbuka no. 8. |

**Format yang ditampilkan: `[Inisial]-[No]`** — mis. `C-28`, `PU-104`. **Tanda hubungnya dihasilkan sistem**, bukan hiasan yang ditambahkan di sisi desain. Karena itu chip menampilkannya apa adanya: teks di chip identik karakter demi karakter dengan yang dipanggil dan ditampilkan di counter, tanpa satu pun karakter yang diputuskan sendiri oleh UI.

**Jenis Antrian tidak boleh jadi label chip.** 30 karakter pada 9 px ≈ 165 px, plus padding jadi chip ~197 px — hampir separuh lebar layar, dan harus dipotong. Memotong nama yang merchant tulis sendiri lebih buruk daripada tidak menampilkannya. Label chip tetap **tetap** `PICK UP`; kerja pembedaan dilakukan oleh **inisial** di dalam nomornya (`PU28` vs `MN28`).

### Lebar chip — dihitung, bukan ditebak

Diukur langsung di file, pada font dan ukuran chip yang sebenarnya (Hanken Grotesk SemiBold **24 px**, tracking −1,5%):

| String | Lebar teks | Chip yang dibutuhkan |
|---|---|---|
| `C-28` (isi contoh yang digambar) | 51 px | 83 px |
| `AB-999` | 77 px | 109 px |
| `AB-9999` — **kasus terburuk** | **90 px** | **122 px** |
| `AB-99999` (kalau 5 digit mungkin) | 103 px | 135 px |

`min-width` chip **122 px** = teks terpanjang + padding 32. **Jangan dipersempit** walau contoh yang digambar cuma `C-28` (83 px) — lebar chip mengikuti nomor terpanjang, bukan isi per pesanan.

> **Bersyarat pada Pertanyaan terbuka no. 8.** Tiap digit tambahan menambah ~13 px. Kalau nomor berjalan bisa mencapai 5 digit, `min-width` naik ke **135 px** sebelum digambar final.

---

## Keputusan produk (dikonfirmasi PM 2026-08-26)

| Topik | Keputusan |
|---|---|
| Sumber nomor | **Penomoran pick up milik Self Order/POS sendiri.** Bukan enqueue ke modul Waiting List. Pool, format, dan reset-nya berdiri sendiri. |
| Yang menentukan | **Satu toggle: "Nomor Pick Up" (nyala/mati).** Tipe fulfillment (Dine In / Take Away) **tidak** ikut menentukan. |
| Letak toggle | **Setup AOL › Pengaturan POS › Fitur Opsional**, kolom **Manajemen Fitur** — di Figma labelnya `Queue Number` (node `258:2821`, file `hl2CORgtDUUUo7A1Gj86mz`, halaman `Setup AOL`). Toggle ini **gerbang**: baru setelah ON, setelan penomorannya muncul di **Customer Display** record `Tipe` = `Nomor antrian` — lihat [[PCK_Case_GabungSemuaChannel]]. *Info PM 2026-08-27.* Cakupannya (outlet / cabang / global) belum pasti — pertanyaan terbuka no. 13 |
| Nama setelan | **"Nomor Pick Up"** — bukan "Nomor Antrian", supaya tidak bertabrakan dengan Waiting List. |
| Bentuk | **Chip dua tingkat** yang menumpang di batas `Hero` ↔ `Sheet`, rata tengah, di bawah nominal. Label kecil di atas, nomor besar di bawah. Bukan elemen hero, bukan baris di Detail Transaksi. |
| Sifat | **Info-only.** Tidak ada tombol, tidak tappable, tidak ada afordans tap. Konsisten dengan [[SO_PRD_MVP]] — tidak ada pelacakan antrean di baseline yang berlaku. |
| Isi chip | Label `Pick Up` + nomor, contoh **`C-28`**. Tanpa ikon, tanpa posisi antrean, tanpa estimasi waktu. |
| Hero | **Tidak diubah.** Checkmark + "Pembayaran berhasil" + nominal tetap seperti sekarang. |
| Saat nomor gagal terbit | **Tidak ada chip, tidak ada pesan error.** Layar tampil seperti pesanan tanpa nomor. Perilaku disengaja — lihat **SO-PCK-B1**. |
| Pesanan campuran | **Satu nomor menaungi seluruh pesanan.** Tidak ada penanda per grup, karena toggle ON berarti semuanya diambil sendiri. |
| Take Away boleh punya meja | **Ya.** Tipe fulfillment bukan lokasi tamu — tamu bisa duduk di Meja 5 dan minta pesanannya dibungkus. `Take Away · Meja 5` valid, bukan kontradiksi. |

## Prinsip

- **Hero tidak boleh punya nasib.** Slot dominan layar konfirmasi tidak boleh diisi data yang bisa tidak ada. Chip kondisional; hero tidak. Kalau nomor menempati slot nominal, hero punya dua bentuk untuk dirawat — dan sebuah layar konfirmasi kehilangan kepastiannya.
- **Nominal sudah selesai tugasnya, nomor pick up baru mulai.** Keduanya bisa hidup bersama tanpa bersaing karena ada di dua permukaan berbeda: nominal dominan di dalam hero teal, chip menonjol lewat kontras dan posisi di atas putih. Nominal **tidak** dikecilkan.
- **Label kecil, nomor besar.** Hanya nomornya yang dibaca dan dicocokkan di counter. Dua tingkat membuat chip terbaca sebagai label + nilai, bukan satu string — dan mengubahnya dari badge jadi kartu klaim, benda yang memang dia tiru.
- **Detail Transaksi bukan tempatnya.** Itu zona telusur: muted, sejajar Metode dan Tanggal. Nomor pick up bukan metadata — dia alat yang dipakai berdiri di counter.
- **Jangan menambah nomor sejajar.** Layar ini sudah memuat `Meja 5` dan `S.660598603`. Nomor ketiga tanpa label membuat tamu tidak tahu mana yang harus disebut ke petugas.
- **Satu makna satu nomor.** Nomor pick up tidak berbagi pool, prefix, maupun kanal pemanggilan dengan nomor Waiting List.
- **Alamat pesanan disnapshot, tidak dibaca live.** Nomor pick up dan tujuan antar dikunci pada saat order dikirim. Setelan yang berubah setelahnya tidak boleh mengubah pesanan yang sudah ada di dapur.

---

## Copy

Copy di bawah adalah **usulan**, menunggu persetujuan PM. Copy lama di [[SO_PRD]] (*"Mendaftarkan antrean…"*, *"pendaftaran antrean gagal"*) ditulis untuk enqueue Waiting List dan **tidak dipakai** di alur ini — kata "antrean" keluar dari layar ini.

| Kunci | Copy | Wadah |
|---|---|---|
| `chip_pickup_label` | **`Pick Up`** — 9 px, uppercase, +0,13em, teal muda | chip, tingkat atas |
| `chip_pickup_value` | **`C-28`** — 19 px, 700, tabular-nums, teal gelap | chip, tingkat bawah |

Tidak ada copy untuk kondisi gagal. Lihat **SO-PCK-B1**.

---

## Acceptance Criteria

| ID | Acceptance Criteria |
|---|---|
| **AC-PCK.1** | Given toggle **Nomor Pick Up aktif** di outlet, When pembayaran sukses dan nomor berhasil diterbitkan, Then chip tampil di batas `Hero`↔`Sheet` berisi label `Pick Up` + nomor. |
| **AC-PCK.2** | Given toggle **Nomor Pick Up nonaktif**, When pembayaran sukses, Then chip **tidak tampil** dan **tidak ada nomor yang diterbitkan**, apa pun tipe fulfillment pesanan. |
| **AC-PCK.3** | Given toggle **Nomor Pick Up aktif** dan pesanan **Dine In murni**, When pembayaran sukses, Then chip **tetap tampil** — tipe fulfillment tidak ikut menentukan. |
| **AC-PCK.4** | Given toggle aktif dan pesanan **campuran** (ada item Dine In dan Take Away), When chip tampil, Then **satu nomor menaungi seluruh pesanan** dan **tidak ada** penanda nomor per grup di daftar `Pesananmu`. |
| **AC-PCK.5** | Given chip tampil, When nomor yang lebih panjang atau lebih pendek diterbitkan, Then lebar chip **tidak berubah** — chip memakai `min-width` yang dihitung dari nomor terpanjang, dan angkanya `tabular-nums`. |
| **AC-PCK.6** | Given chip tampil, When tamu menekannya, Then **tidak terjadi apa pun** — tidak ada state pressed, tidak ada chevron, tidak ada navigasi. |
| **AC-PCK.7** | Given toggle aktif tapi nomor **gagal diterbitkan**, When layar Sukses dirender, Then chip tidak tampil, **tidak ada pesan error apa pun**, `Hero` tidak berubah, dan pembayaran tetap sah. |
| **AC-PCK.8** | Given pesanan mendapat nomor pick up, When tamu memakai "Bagikan struk", Then nomor pick up ikut termuat di struk yang dikirim. |
| **AC-PCK.9** | Given toggle aktif dan nomor sudah terbit, When tiket dapur dicetak/ditampilkan, Then **nomor pick up** menjadi tujuan antar untuk seluruh grup fulfillment, menggantikan nama meja. |
| **AC-PCK.10** | Given order sudah dikirim dan nomor sudah terbit, When toggle outlet diubah, Then nomor dan tujuan antar order itu **tidak berubah**; setelan baru hanya berlaku untuk order berikutnya. |
| **AC-PCK.11** | Given dua pesanan lunas dalam rentang waktu yang sangat dekat di outlet yang sama, When keduanya menerbitkan nomor, Then keduanya mendapat nomor **berbeda**, dan tidak ada nomor yang terlewat maupun terpakai dua kali. |

---

## A. Terbit & tampil

### SO-PCK-A1 — Toggle Nomor Pick Up aktif: chip tampil di batas hero↔sheet

**Membuktikan:** AC-PCK.1, AC-PCK.5, AC-PCK.6
**Frame Figma:** [Success — Nomor Pick Up · Take Away](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3642-709) (`3642:709`) — **sudah digambar 2026-08-26**

**Prasyarat**

- Outlet aktif, toggle **Nomor Pick Up aktif** — dinyalakan di **Setup AOL › Pengaturan POS › Fitur Opsional**, kolom **Manajemen Fitur** (label Figma `Queue Number`, node `258:2821`).
- Aturan penomoran sudah diisi di AOL → **Customer Display** → record `Tipe` = `Nomor antrian` — lihat [[PCK_Case_GabungSemuaChannel]].
- Layanan penomoran pick up sehat.
- QR Self Order terpasang; pada contoh ini tertaut **Meja 5**.

**Langkah reproduksi**

1. Pindai QR, pilih tipe pesanan **Take Away**, tambahkan 2 item ke keranjang.
2. Lanjut ke Konfirmasi Pesanan, pilih **QRIS**, selesaikan pembayaran.
3. Tunggu layar **Sukses** muncul sepenuhnya.
4. Tekan chip satu kali.
5. Ulangi dengan pesanan lain sampai dapat nomor dengan jumlah digit berbeda; bandingkan lebar chip.

**Hasil yang diharapkan**

| Properti | Nilai |
|---|---|
| Posisi | rata tengah horizontal di (140, 302), **garis batas `Hero`↔`Sheet` melewati pusat chip** |
| Kotak | **122 × 50 px**, radius 999 px, padding 5/16/6 |
| Label | `PICK UP` — Inter Semi Bold **11 px**, +13%, lh 12, `#4FA9A7` |
| Nomor | Hanken Grotesk SemiBold **24 px**, tracking −1,5%, lh 26, `#0A7C79`, tabular |
| Elevasi | shadow dua lapis `rgba(6,40,39,.10) 0/2/4` + `rgba(6,40,39,.20) 0/10/24`, **bukan border** |
| Ikon | **tidak ada** |
| Jarak ke `Pesananmu` | 11 px — separuh chip (25 px) masuk ke `Sheet`, `Sheet.paddingTop` 36 |

**Kenapa nomornya 24 px.** Skala tipografi layar ini `46 · 22 · 16,5 · 13,5 · 13 · 12,5`. Nomor 24 px menempati **slot kedua** — di atas "Pembayaran berhasil" (22), di bawah nominal (46). Itu persis prioritasnya: nomor ini yang akan dipakai tamu, nominal cuma menegaskan yang sudah selesai.

Dua ukuran lain diuji di konteks aslinya dan ditolak: **19 px** terlalu kecil — cuma sedikit di atas harga item (13 px), sehingga chip terbaca sebagai badge sekunder. **28 px** menyisakan jarak cuma 8 px ke baris "Pesananmu" dan membuat label terlihat kerdil dibanding nomornya.

- Aturan posisinya **bukan nilai piksel** tapi relasi: garis batas melewati pusat chip, supaya chip terbaca sebagai objek sendiri — bukan milik hero maupun sheet.
- **Shadow, bukan border.** Putih chip sama dengan putih sheet, jadi tanpa elevasi keduanya melebur di seam. Border tidak dipakai karena di latar teal ia memotong bentuk pill-nya.
- `Hero` tidak berubah: checkmark, "Pembayaran berhasil", dan nominal **tetap 29 px** pada posisi semula.
- Baris `pesananmu-head` menampilkan `Take Away · Meja 5`. **Ini benar dan bukan kontradiksi** — Take Away adalah tipe fulfillment item, Meja 5 adalah tempat tamu memindai.
- Langkah 4 **tidak menghasilkan apa pun**: tidak ada state pressed, tidak ada ripple, tidak ada navigasi.
- Langkah 5: lebar chip **identik** di semua pesanan.

**Hasil aktual (2026-08-26)**

Belum masuk canvas. Usulan desainnya sudah lengkap; `min-width` final menunggu panjang nomor maksimal ditetapkan (Pertanyaan terbuka no. 2).

---

### SO-PCK-A2 — Toggle Nomor Pick Up nonaktif: chip tidak tampil dan nomor tidak diterbitkan

**Membuktikan:** AC-PCK.2
**Frame Figma:** belum ada

**Prasyarat**

- Sama seperti **SO-PCK-A1**, kecuali toggle **Nomor Pick Up nonaktif** (outlet memakai model diantar).

**Langkah reproduksi**

1. Ulangi langkah 1–3 **SO-PCK-A1**.
2. Perhatikan batas `Hero`↔`Sheet`.
3. Periksa log/jaringan: apakah ada permintaan penerbitan nomor.
4. Ulangi seluruhnya dengan pesanan **Dine In**.

**Hasil yang diharapkan**

- Chip **tidak tampil**, dan tidak ada ruang kosong yang tertinggal di batas `Hero`↔`Sheet`. Layar tampil identik dengan versi tanpa fitur pick up.
- **Tidak ada nomor yang diterbitkan.** Nomor tidak boleh dibuat lalu disembunyikan — nomor yang terbit tapi tidak pernah dipanggil menghabiskan urutan nomor hari itu dan mengotori laporan operasional counter.
- Langkah 4 memberi hasil yang sama. Tipe fulfillment tidak mengubah apa pun di sini.
- Tujuan antar untuk seluruh grup tetap **nama meja** (lihat **SO-PCK-C2**).

**Hasil aktual (2026-08-26)**

Belum digambar dan belum diuji.

---

### SO-PCK-A3 — Pesanan Dine In di outlet ambil-sendiri: chip tetap tampil

**Membuktikan:** AC-PCK.3
**Frame Figma:** [Success — Nomor Pick Up · Dine In](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3642-759) (`3642:759`) — **sudah digambar 2026-08-26**, sengaja ditaruh berdampingan dengan varian Take Away supaya perbedaannya kelihatan cuma di baris `pesananmu-head`, bukan di chip

**Prasyarat**

- Toggle **Nomor Pick Up aktif**.
- Pesanan hanya memuat item **Dine In**.

**Langkah reproduksi**

1. Pindai QR, biarkan tipe pesanan **Dine In**, tambahkan item, bayar sampai sukses.
2. Perhatikan batas `Hero`↔`Sheet`.

**Hasil yang diharapkan**

- Chip **tetap tampil**, sama persis dengan **SO-PCK-A1**.
- **Kenapa:** di outlet ambil-sendiri, tamu dine in tetap menjemput makanannya di counter lalu duduk makan di situ. Dia butuh nomornya sama seperti tamu take away.
- **Kasus ini adalah penjagaan terhadap salah paham yang paling mungkin terjadi.** Naluri pertama saat membaca fitur ini adalah mengikat nomor pick up ke Take Away. Kalau itu yang diimplementasikan, seluruh model counter-service pecah. Karena itu kasus ini didaftar terpisah, bukan digabung ke A1.

**Hasil aktual (2026-08-26)**

Belum digambar. Draf spec sebelumnya (versi 2026-08-26 pagi) **salah** di titik ini — menyatakan Dine In tidak pernah dapat chip. Dikoreksi PM di hari yang sama.

---

### SO-PCK-A4 — Pesanan campuran: satu nomor menaungi seluruh pesanan

**Membuktikan:** AC-PCK.4
**Frame Figma:** belum ada

**Prasyarat**

- Toggle **Nomor Pick Up aktif**, layanan penomoran sehat.
- Satu transaksi memuat **item Dine In dan item Take Away sekaligus** — didukung sejak keputusan PM 2026-07-14 (lihat [[SO_PRD]], OQ-SO-12).

**Langkah reproduksi**

1. Tambahkan 2 item sebagai **Dine In**.
2. Ganti tipe pesanan ke **Take Away**, tambahkan 1 item lagi.
3. Bayar sampai layar **Sukses** muncul.
4. Baca chip, lalu baca daftar `Pesananmu`.

**Hasil yang diharapkan**

- Chip tampil dengan **satu** nomor.
- Daftar `Pesananmu` tetap terkelompok **Dine In dulu, baru Take Away**, sesuai aturan urutan grup di [[SO_Case_RincianPesananCampuran]].
- **Tidak ada penanda nomor per grup.** Toggle ON berarti seluruh pesanan diambil sendiri — tamu menjemput semuanya di counter, memakan bagian dine in di situ, membawa pulang bagian take away-nya. Satu nomor sudah cukup, dan penanda per grup justru mengesankan ada dua tempat pengambilan.
- Konsekuensi ini **berbeda dari draf sebelumnya**, yang mensyaratkan penanda di grup `TAKE AWAY`. Syarat itu batal karena toggle tidak lagi membedakan per grup.

**Hasil aktual (2026-08-26)**

Belum digambar.

---

## B. Kondisi tanpa nomor

### SO-PCK-B1 — Nomor gagal terbit: tidak ada chip, tidak ada pesan error

**Membuktikan:** AC-PCK.7
**Frame Figma:** **tidak akan digambar** — keputusan PM 2026-08-26

**Prasyarat**

- Toggle **Nomor Pick Up aktif**.
- **Pembayaran sukses** (QRIS lunas), tapi layanan penomoran dibuat gagal merespons.

**Langkah reproduksi**

1. Selesaikan pembayaran sampai lunas.
2. Buat layanan penomoran gagal (matikan, atau paksa error).
3. Perhatikan layar **Sukses** secara keseluruhan.

**Hasil yang diharapkan**

| Bagian | Kondisi |
|---|---|
| `Hero` | **tidak berubah** — checkmark, "Pembayaran berhasil", nominal, semua normal |
| Chip | **tidak tampil** |
| Pesan error | **tidak ada** — tidak ada modal, tidak ada toast, tidak ada baris peringatan |
| Pembayaran | **tetap sah**, tidak di-rollback |
| Sisa layar | normal seluruhnya |

- **Ini perilaku yang disengaja, bukan bug.** QA perlu tahu bahwa "tidak ada apa-apa" itu **lulus**. Layar tampil sama seperti pesanan di outlet yang toggle-nya mati.
- **Risiko yang diterima sadar:** tamu tidak diberi tahu apa pun, jadi dia menunggu tanpa nomor dan tidak ada yang memanggilnya. Pemulihannya lewat staf, secara manual, tanpa dituntun layar. PM menilai kejadiannya cukup jarang sehingga tidak sebanding dengan biaya menambah satu wadah pesan di layar yang seharusnya menenangkan.
- Tujuan antar di tiket dapur jatuh ke **nama meja** sebagai fallback (lihat **SO-PCK-C2**).

**Hasil aktual (2026-08-26)**

Tidak ada desain, dan tidak akan dibuat. Dicatat di sini supaya keputusannya punya jejak dan QA punya ekspektasi yang jelas.

---

## C. Jejak & pemulihan

### SO-PCK-C1 — Nomor pick up ikut di struk yang dibagikan

**Membuktikan:** AC-PCK.8
**Frame Figma:** belum ada. Alur bagikan struk ada di [[SO_Case_BagikanStrukNegative]] dan [[SO_Case_ToastSuksesBagikanStruk]].

**Prasyarat**

- Pesanan sudah mendapat nomor pick up (kondisi **SO-PCK-A1** terpenuhi).

**Langkah reproduksi**

1. Di layar **Sukses**, tekan **"Bagikan struk"** dan selesaikan pengirimannya.
2. Buka struk yang diterima.
3. Tutup browser Self Order sepenuhnya, lalu coba temukan kembali nomor pick up.

**Hasil yang diharapkan**

- Struk memuat **nomor pick up**, bukan hanya ID Transaksi.
- **Kenapa wajib, bukan opsional:** chip info-only dan tidak ada halaman pelacakan, jadi chip hidup **hanya** di layar Sukses. Tamu yang menutup browser tanpa struk kehilangan nomornya permanen dan tidak punya cara menemukannya kembali selain bertanya ke staf.

**Hasil aktual (2026-08-26)**

Belum dispec. Isi struk yang dibagikan belum pernah didaftar per-field di dokumen mana pun.

---

### SO-PCK-C2 — Nomor pick up jadi tujuan antar di tiket dapur

**Membuktikan:** AC-PCK.9
**Frame Figma:** belum ada. Tiket dapur dinyatakan **belum digarap** di [[SO_PRD]].

**Prasyarat**

- Toggle **Nomor Pick Up aktif**, nomor sudah terbit.

**Langkah reproduksi**

1. Selesaikan pesanan sampai lunas.
2. Periksa tiket dapur yang keluar (kertas atau KDS).
3. Ulangi dengan toggle **nonaktif** dan bandingkan.
4. Ulangi dengan pesanan **Dine In** pada toggle aktif.

**Hasil yang diharapkan**

Tiap tiket membawa **satu tujuan antar** di baris paling atas dan paling besar:

| Toggle Nomor Pick Up | Tujuan antar | Berlaku untuk |
|---|---|---|
| **aktif** | `PICK UP C-28` | seluruh grup, Dine In maupun Take Away |
| **nonaktif** | `MEJA AA - 14` | seluruh grup |
| aktif, tapi nomor gagal terbit | `MEJA AA - 14` (fallback) | seluruh grup |

- Nomor REF dan ID Transaksi tetap ada tapi **kecil** — keduanya identifier telusur, bukan alamat. Dapur tidak bisa mengantar ke `REF-398125`.
- Kanal ditulis eksplisit (`Self Order`), karena tidak ada waiter yang mengonfirmasi item ini — kalau ada keanehan, tidak ada orang yang bisa ditanya.
- Grouping Dine In / Take Away **tetap dicetak** walau tujuan antarnya sama, karena dapur perlu tahu mana yang dipiring dan mana yang dibungkus.

**Hasil aktual (2026-08-26)**

Tiket dapur belum digarap sama sekali. Kasus ini didaftar supaya nomor pick up tidak diputuskan tanpa memikirkan ujung operasionalnya, tapi **eksekusinya milik dokumen tiket dapur** yang belum ada.

---

## D. Batas & negatif

### SO-PCK-D1 — Toggle diubah setelah order dikirim: nomor yang sudah terbit tidak berubah

**Membuktikan:** AC-PCK.10
**Frame Figma:** belum ada

**Prasyarat**

- Ada satu pesanan yang sudah lunas dan **sudah** mendapat nomor pick up.
- Tiket dapurnya sudah keluar.

**Langkah reproduksi**

1. Pastikan pesanan di atas sudah terbit nomornya.
2. **Matikan** toggle Nomor Pick Up di outlet.
3. Buka kembali layar Sukses pesanan itu (kalau tautannya masih hidup), dan periksa data pesanan di sisi POS.
4. Buat pesanan **baru** dan periksa apakah dia dapat nomor.

**Hasil yang diharapkan**

- Nomor pick up dan tujuan antar pesanan lama **tidak berubah.** Nilainya di-snapshot saat order dikirim, bukan dibaca ulang dari setelan.
- Pesanan baru mengikuti setelan baru: **tidak** dapat nomor.
- **Kenapa harus snapshot:** kalau tujuan antar dibaca live, mengubah toggle akan mengubah alamat pesanan yang **sudah ada di dapur** — kertas di tangan koki bilang satu hal, sistem bilang hal lain. Prinsip yang sama dipakai untuk relasi QR↔meja, jadi satu aturan menutup dua jalur.

**Hasil aktual (2026-08-26)**

Belum diuji. Perilaku "buka ulang tautan layar Sukses" sendiri belum pernah dispec — lihat Pertanyaan terbuka no. 5.

---

### SO-PCK-D2 — Dua pesanan lunas hampir bersamaan: nomor tidak boleh dobel

**Membuktikan:** AC-PCK.11
**Frame Figma:** tidak perlu — ini kasus data, bukan kasus tampilan

**Prasyarat**

- Toggle **Nomor Pick Up aktif** di satu outlet.
- Dua perangkat tamu (A dan B), keduanya siap membayar.

**Langkah reproduksi**

1. Bawa perangkat A dan B sampai ke titik tepat sebelum konfirmasi pembayaran.
2. Selesaikan pembayaran keduanya **dalam rentang kurang dari satu detik**.
3. Bandingkan nomor yang tampil di kedua layar Sukses.
4. Bandingkan dengan urutan nomor di sisi counter/POS.

**Hasil yang diharapkan**

- Kedua pesanan mendapat nomor **berbeda**.
- Tidak ada nomor yang **terlewat** dalam urutan, dan tidak ada nomor yang **dipakai dua kali**.
- **Kenapa kasus ini ada:** nomor WL diterbitkan saat tamu mendaftar satu per satu di pintu masuk — bentrok hampir tidak mungkin. Nomor pick up diterbitkan saat pembayaran selesai, dan pembayaran bisa selesai serentak dari banyak meja. Pool nomor yang berdiri sendiri berarti penjagaan keunikannya juga harus dibangun sendiri, tidak mewarisi milik WL.
- Nomor dobel di sini bukan cacat kosmetik: dua tamu maju ke counter untuk nomor yang sama, dan salah satu membawa pesanan orang lain.

**Hasil aktual (2026-08-26)**

Belum ada mekanismenya karena pool nomornya belum dirancang.

---

## Pertanyaan terbuka

| No | Pertanyaan | Menunggu | Terkait |
|---|---|---|---|
| 1 | ~~**Toggle Nomor Pick Up tinggal di mana** — Setup AOL › Fitur Opsional, atau setelan per-outlet di POS?~~ — **dijawab PM 2026-08-27: Setup AOL › Pengaturan POS › Fitur Opsional**, kolom **Manajemen Fitur**, baris ke-9 (antara `Uang Muka` dan `Aktifkan Membership Program (Bliss)`). Label di Figma `Queue Number`, keterangan *"Permudah proses pengambilan pesanan dengan nomor pickup."* — node `258:2821` di file `hl2CORgtDUUUo7A1Gj86mz` (`Pick-Up`), halaman `Setup AOL`. Toggle ini **gerbang**: ON dulu, baru setelan penomorannya ada, dan setelan itu tinggal di **Customer Display** ([[PCK_Case_GabungSemuaChannel]]). Sisanya dipecah jadi no. 11–13. | selesai | semua |
| 2 | ~~**Aturan penomoran pick up** — format, panjang maksimal~~ — **dijawab PM 2026-08-26.** Lihat [[#Struktur nomor pick up\|§Struktur nomor pick up]]. Sisanya pecah jadi no. 7–10 di bawah. | selesai | A1, D2 |
| 3 | **Nomor terbit di respons pembayaran, atau panggilan terpisah?** Kalau ikut respons "pembayaran sukses", nomornya sudah ada saat layar dirender — chip cukup ada-atau-tidak-ada, tanpa state loading. Kalau panggilan terpisah setelah render, chip butuh state loading dengan lebar terkunci supaya `Sheet` tidak tersentak. **Menentukan apakah chip punya satu bentuk atau dua.** | **keputusan PM + DEV — blocking** | A1, B1 |
| 4 | **Bagaimana nomor dipanggil?** WL punya monitor publik ([[WL_Requirements]] FR-14, FR-15). Pick up **belum punya kanal pemanggilan apa pun** — tidak ada monitor, tidak ada notifikasi, tidak ada layar counter. Nomor yang tidak pernah dipanggil tidak berguna. Surface terpisah, belum ada dokumennya. | keputusan PM | semua |
| 5 | **Buka ulang tautan layar Sukses** — chip masih tampil dengan nomor yang sama, atau layar jadi read-only tanpa chip? Menentukan seberapa kritis **SO-PCK-C1**. | keputusan PM + DEV | C1, D1 |
| 6 | **Model hybrid** (dine in diantar, take away diambil) — perlu didukung nanti? Kalau ya, toggle diperluas jadi tiga nilai dan **AC-PCK.3** & **AC-PCK.4** ikut berubah. Ditunda sadar, bukan terlewat. | keputusan PM | A3, A4 |
| 7 | ~~Ada pemisah antara inisial dan nomor?~~ — **dijawab PM 2026-08-26: tanda hubung otomatis dari sistem.** Format `[Inisial]-[No]`. Chip yang sudah digambar (`C-28`) sudah benar apa adanya. | selesai | A1, A3 |
| 8 | **Nomor lewat 4 digit — wrap, reset, atau tumbuh?** "No Mulai Dari maks 3 karakter" membatasi **nomor awal**, bukan nomor berjalan. Mulai dari 1 lalu 1.200 pesanan → `1200`. Perlu aturan wrap/reset — dan ini **mengunci lebar chip**: `min-width` 106 px cuma cukup sampai 4 digit (sisa 2 px). Kalau 5 digit mungkin, chip naik ke 115 px. | **keputusan PM — blocking** | A1, D2 |
| 9 | **Jenis Antrian mana yang dipakai Self Order?** Kalau merchant boleh mendefinisikan lebih dari satu Jenis Antrian, harus jelas jenis mana yang dipakai pesanan Self Order — dipilih di setelan, atau ada jenis khusus? Tanpa ini, dua outlet dengan konfigurasi berbeda menghasilkan nomor yang tidak sebanding. | keputusan PM | semua |
| 10 | ~~**Apakah penomoran ini sudah ada di produk?**~~ — **dijawab 2026-08-27: sudah ada, dan bukan milik Self Order.** Field `Inisial Antrian`, `No Mulai Dari`, `No Akhir Sampai` diisi di AOL → **Customer Display** → record `Tipe` = `Nomor antrian`, kartu **Buat Daftar Pick Up** — dispesifikasi di [[PCK_Case_GabungSemuaChannel]]. Dokumen ini **menautkan** ke aturan itu, tidak menetapkan ulang. Yang masih menggantung: `Jenis Antrian` (no. 9) dan perilaku deret di atas 4 digit (no. 8). | selesai | Prinsip |
| 11 | **Nama final setelan ini apa?** Tiga nama beredar untuk satu fitur: `Queue Number` (label toggle di Figma), `Nomor antrian` (nilai `Tipe` record Customer Display), dan **Nomor Pick Up** (keputusan produk di dokumen ini, alasannya di [[#Nomor Pick Up bukan nomor Waiting List\|§Nomor Pick Up bukan nomor Waiting List]]). PM 2026-08-27: **sementara pakai "Nomor Pick Up", nama final belum diputus.** Kalau akhirnya "antrian" yang menang, pemisahan istilah dari Waiting List harus ditulis ulang — bukan cuma labelnya. | keputusan PM | semua |
| 12 | **Toggle OFF menutup apa saja?** Cuma penerbitan nomor (record Customer Display tetap boleh dibuat dan diisi), atau record `Tipe` = `Nomor antrian` ikut hilang/terkunci? Menentukan prasyarat **SO-PCK-A2** dan seluruh grup kasus di [[PCK_Case_GabungSemuaChannel]]. | keputusan PM + DEV | A2 |
| 13 | **Cakupan toggle** — dokumen ini menyebut "level outlet", tapi Fitur Opsional punya tab **Kantor Pusat** dan field **Cabang** ([[SO_Case_SetupAOLFiturOpsional]] pertanyaan no. 5), sedangkan outlet dipilih di **tab Outlet** pada record Customer Display ([[PCK_Case_GabungSemuaChannel]] `AOL-PCK-D1`). Satu fitur diatur di dua tempat dengan cakupan yang mungkin berbeda. Per cabang, per outlet, atau global? | keputusan PM + DEV | semua |

---

## Lampiran A — Kamus layar

| Nama layar / elemen | Isinya | Cara membuka |
|---|---|---|
| **Success — SuccessScreen** | Layar Sukses Self Order (PAGE-11). Dua bagian: `Hero` (teal — checkmark, "Pembayaran berhasil", nominal) dan `Sheet` (putih — Pesananmu, Rincian Pembayaran, Detail Transaksi, Bagikan struk). `BottomBar` berisi "Kembali ke Menu". | otomatis setelah pembayaran lunas |
| **Chip pick up** | Chip dua tingkat, rata tengah, menumpang di batas `Hero`↔`Sheet`. Label `Pick Up` di atas, nomor besar di bawah. Info-only, tidak tappable. | otomatis, kalau toggle Nomor Pick Up aktif & nomor berhasil terbit |
| **pesananmu-head** | Baris judul daftar pesanan: `Pesananmu` (kiri) + tipe fulfillment & titik scan, mis. `Take Away · Meja 5` (kanan). | bagian dari `Sheet` |
| **Toggle Nomor Pick Up** | Satu baris toggle di kolom **Manajemen Fitur** — baris ke-9, antara `Uang Muka` dan `Aktifkan Membership Program (Bliss)`. Label Figma `Queue Number`, keterangan *"Permudah proses pengambilan pesanan dengan nomor pickup."* Gerbang fitur: selama OFF, nomor tidak diterbitkan. | AOL → **Pengaturan POS** → **Fitur Opsional** → kolom Manajemen Fitur |
| **Buat Daftar Pick Up** (AOL) | Kartu tempat aturan penomoran diisi setelah toggle ON: `Inisial Antrian`, `No Mulai Dari`, `No Akhir Sampai`, plus preview. Bukan cakupan dokumen ini — dispesifikasi di [[PCK_Case_GabungSemuaChannel]]. | AOL → **Customer Display** → Data Baru → `Tipe` = `Nomor antrian` |

## Lampiran B — Peta node Figma

File `mAZuRze02w906M6u2EwVWh`, canvas `1223:2`.

| Nama frame / elemen | Node | Terkait |
|---|---|---|
| **Case: Pembayaran Berhasil — Nomor Pick Up** (section) | [`3642:708`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3642-708) | semua |
| Success — Nomor Pick Up · **Take Away** | [`3642:709`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3642-709) | SO-PCK-A1 |
| Success — Nomor Pick Up · **Dine In** | [`3642:759`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3642-759) | SO-PCK-A3 |
| `chip-pickup` (Take Away) — 122×50 di (140, 302) | [`3644:810`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3644-810) | A1 |
| `chip-pickup` (Dine In) — 122×50 di (140, 302) | [`3644:813`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3644-813) | A3 |
| `catatan` — spec ringkas di canvas | [`3646:810`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=3646-810) | semua |
| Success — SuccessScreen (baseline, tanpa chip) | [`543:740`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-740) | SO-PCK-A2 |
| `Hero` (teal) | [`543:742`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-742) | AC-PCK.1 |
| Teks "Pembayaran berhasil" | [`543:749`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-749) | AC-PCK.7 |
| Nominal — slot yang **tidak** diambil chip, tetap 29 px | [`543:750`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-750) | Prinsip |
| `Sheet` (putih) | [`543:751`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-751) | semua |
| `pesananmu-head` | [`543:752`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-752) | A1, A4 |
| Teks tipe & titik scan ("Dine In · Meja 5") | [`543:754`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-754) | A1, A3 |
| `detail-transaksi` — zona telusur, **bukan** tempat nomor pick up | [`543:785`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-785) | Prinsip |
| Baris ID Transaksi | [`543:793`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-793) | Prinsip |
| Blok `share` ("Bagikan struk") | [`543:801`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=543-801) | SO-PCK-C1 |
| `BottomBar` ("Kembali ke Menu") | [`2024:554`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2024-554) | — |
| Blok poin (case tetangga, untuk rujukan) | [`1762:205`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1762-205) | koeksistensi |

> **Fonts terpakai di chip** — label `PICK UP` Inter Semi Bold 11px letter-spacing +13%, line-height 12px, fill `#4FA9A7`. Nomor Hanken Grotesk SemiBold 24px, tracking −1,5%, line-height 26px, fill `#0A7C79`. Keduanya mengikuti pembagian yang sudah ada di file: Hanken Grotesk untuk angka display (sama seperti nominal), Inter untuk label kecil.
> **Shadow chip** — dua lapis, `rgba(6,40,39,.10) 0/2/4` + `rgba(6,40,39,.20) 0/10/24`. Tidak ada border.
> **`Sheet.paddingTop` 22 → 36** pada kedua layar, supaya separuh chip yang masuk ke Sheet tidak menempel baris `Pesananmu`. Tinggi frame ikut naik 14px (940 → 954) supaya "Bagikan struk" tetap terlihat.
