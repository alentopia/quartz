# Self Order — Negative Case: Diskon Transaksi (Promo) Gugur Saat Konfirmasi Pesanan

**Status:** Draft
**Tanggal:** 2026-07-30
**Fitur:** Self Order — sisi pelanggan (menu, keranjang, promo).
**Prefix ID kasus:** `SO-PRM`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · PM (keputusan produk)
**Referensi:** [[SO_PRD_MVP]] (§6 Kategori Promo, §6 PAGE-06V), [[SO_Case_ValidasiKeranjangRedesign]] (`ValidationPopup` + `IssueRow`, sudah Approved)
**Format dokumen ini mengikuti:** [[Riset_Workflow_Handoff_UIUX_QA_DEV]] (5 blok per kasus, link Figma per kasus)
**Desain:**
- CTA Promo di Keranjang — `PromoCTA` [Status=Kosong](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1990-1156) · [Status=Terpakai](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2078-258)
- Kartu di halaman Promo (PAGE-06V) — `PromoCard` [Status=Aktif](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1978-53100) · [Status=Nonaktif](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1978-53101) · [Status=Terpakai](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2076-19059) · [Status=Bermasalah](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2581-64371) (baru, sudah digambar sesuai spec ini)
- Popup konfirmasi (existing, tidak diubah) — [ValidationPopup](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1163-9025) · ~~[IssueRow Type=Promo](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1808-165)~~ **(link nyasar, diverifikasi 2026-08-06 — node ini sekarang isinya teks Type=Stock "Ayam Goreng Lengkuas habis", bukan Type=Promo. Perlu dicari ulang instance Type=Promo yang benar sebelum dipakai sebagai referensi.)** · [IssueRow Type=SPA](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1808-180)

---

## Latar belakang

Tamu bisa pasang **Diskon Transaksi** (dulu disebut Voucher, lihat §6 Kategori Promo di [[SO_PRD_MVP]]) dari halaman Promo (PAGE-06V). Begitu dipasang, CTA di Keranjang berubah dari `PromoCTA Status=Kosong` jadi `Status=Terpakai`.

Antara saat dipasang dan saat tamu menekan **"Konfirmasi Pesanan"**, diskon itu bisa jadi tidak berlaku lagi di sisi server — dua pemicu yang dibahas PM:

1. **Waktu promo habis** (jam/periode promo berakhir).
2. **Perubahan aturan promo** dari sisi merchant/POS (syarat berubah, promo ditarik, dsb).

**Ini beda dengan** aturan yang sudah ada di [[SO_PRD_MVP]] baris "Mengubah keranjang sehingga syarat promo gugur → dilepas otomatis" — itu dipicu tamu sendiri mengubah isi keranjang (real-time, client tahu langsung kenapa). Kasus di dokumen ini dipicu dari sisi server/waktu, tamu tidak punya cara tahu sebelum konfirmasi.

**Titik deteksinya sudah ada dan sudah disetujui**: `ValidationPopup` + `IssueRow` ([[SO_Case_ValidasiKeranjangRedesign]]) muncul saat "Konfirmasi Pesanan" ditekan, jelasin promo yang gugur dengan nada tenang (bukan alarm), tombol **"Lanjut Bayar"** (karena sudah auto-resolve, tidak butuh keputusan manual — beda dengan isu Stock).

**Gap yang ditutup dokumen ini:** setelah popup itu ditutup, apa yang tersisa di UI supaya tamu yang penasaran/lupa isi popup bisa cek ulang kenapa diskonnya hilang — tanpa mengulang notifikasi yang sama seperti masalah yang belum kelar.

## Keputusan produk

| Topik | Keputusan |
|---|---|
| Titik deteksi & notifikasi utama | **Tidak berubah.** `ValidationPopup` saat "Konfirmasi Pesanan" tetap satu-satunya momen konfirmasi wajib-dibaca. Dokumen ini tidak menambah popup atau toast baru. |
| CTA Promo di Keranjang setelah popup ditutup | **Balik ke `Status=Kosong` biasa.** Tidak dapat variant/teks tambahan — informasinya sudah selesai disampaikan oleh popup, menambah penanda lagi di sini jadi mengulang pesan yang sama. |
| Kartu promo yang gugur di halaman Promo | **Tetap tampil**, dengan status baru `Status=Bermasalah` (lihat desain komponen di bawah) — bukan dihapus dari daftar, bukan juga dibiarkan seperti kartu Aktif/Nonaktif biasa. |
| Posisi kartu `Bermasalah` di daftar | **Selalu paling bawah**, di bawah kartu Aktif maupun Nonaktif — yang masih bisa dipakai didahulukan, yang udah gak relevan disingkirkan ke akhir. |
| Umur/lifetime state `Bermasalah` | **Seumur sesi keranjang/order yang sedang berjalan.** Bertahan selama order ini belum selesai. Begitu transaksi selesai (bayar/order baru), sesi baru tidak menampilkan kartu ini lagi — datanya sudah tidak relevan untuk order baru. |
| Kontrol di kartu `Bermasalah` | **Tombol "Pakai" dihilangkan, bukan diganti badge bertulis.** Tidak ada teks status kayak "Tidak berlaku" di sisi kanan kartu — cukup dengan menghilangkan elemen yang bisa ditekan, kesan "tidak bisa diklik" muncul dari ketidakhadirannya, bukan dari tulisan. |

## Prinsip

- **Jangan ulang notifikasi yang sudah selesai di-acknowledge.** Popup sudah minta konfirmasi eksplisit ("Lanjut Bayar") — itu adalah bukti tamu sudah tahu. CTA boleh balik ke state sebenarnya (Kosong) tanpa perlu "mengingatkan lagi".
- **Sediakan jejak buat yang butuh cek ulang, bukan alarm yang menunggu direspon.** Kartu di halaman Promo adalah cadangan informasi kalau tamu penasaran — bukan kewajiban baru yang harus di-dismiss.
- **Hilangkan kontrol yang tidak valid, jangan ganti jadi label.** Konsisten dengan prinsip yang sama di [[SO_Case_QRManagementNegative]] ("Hilangkan, jangan matikan") — tombol "Pakai" pada kartu yang sudah gugur dihilangkan total. Badge teks seperti "Tidak berlaku" sengaja tidak dipakai supaya kartu ini tidak menambah kosakata status baru; ketidakadaan tombol saja sudah cukup memberi kesan "tidak bisa diapa-apakan".

## Desain komponen

### `PromoCard` — variant baru `Status=Bermasalah`

**Sudah digambar di Figma**, kloning dari `Status=Nonaktif` lalu diubah:

| Bagian | Status=Nonaktif (existing) | Status=Bermasalah (baru) |
|---|---|---|
| Chip icon (kiri, 60×60) | bg `primarySoft`, icon+label `primary` | **sama persis** — gak perlu warna/token baru |
| Opacity container | 50% (frame-level) | **sama persis, 50%** — bahasa "gak bisa dipakai" yang udah dikenal dari Nonaktif |
| Judul | nama promo (mis. "Diskon 20%") | **tetap tampil** — tamu masih perlu tahu promo mana yang dimaksud |
| Baris `conds` (Min. belanja / Maks. potongan) | tampil, 2 baris + bullet dot | **diganti** 1 baris teks netral tanpa bullet, warna `muted`: **"Promo ini sudah tidak bisa dipakai."** |
| Slot kanan (bekas tombol "Pakai") | tombol solid (ikut redup 50%) | **dihilangkan total** (node dihapus). Nonaktif masih punya tombol (cuma gak ke-tap krn kondisi belum terpenuhi, bisa berubah jadi aktif kalau syarat kepenuhi); Bermasalah gak punya jalan balik sama sekali di sesi ini, jadi tombolnya dicabut. |
| Border/shadow | tidak ada | **tidak ada** — sama seperti Nonaktif |

**Riwayat revisi (proses brainstorming dengan PM):**
1. Draf awal: border tipis netral, posisi paling atas. Feedback: "gak menonjol."
2. Revisi 2: wash+border+shadow+chip solid biru (`info`), level penekanan sama seperti Terpakai, posisi tetap atas. Feedback: "kesannya kayak dipilih" — border+wash+chip solid ternyata bahasa visual "selected", bukan "bermasalah".
3. Revisi 3: disamakan dengan bahasa "disabled" yang sudah ada (Nonaktif) — dim 50%, tanpa border/wash/shadow, tombol dihilangkan total. Posisi dipindah ke paling bawah (yang masih bisa dipakai didahulukan).
4. Revisi 4: coba pertahankan posisi paling atas + tambah 1 label section "Sudah tidak bisa dipakai" di atas kartu sebagai pembeda struktural, kartu tetap dim. Feedback: **gak jalan** — posisi atas vs tampilan dim itu kontradiksi. Dim secara visual malah bikin kartu ini kalah kontras sama kartu Aktif di bawahnya (yang solid/terang), padahal harusnya dialah yang paling perlu diperhatikan duluan. "Menonjol lewat posisi" gak nolong kalau "gayanya bikin pudar".
5. **Final (dikonfirmasi PM):** balik ke Revisi 3 — **paling bawah + dim 50%, tanpa tombol**, tanpa label section tambahan. Posisi dan gaya konsisten satu sama lain: yang gak kepake didorong ke akhir daftar DAN keliatan pudar, dua sinyal yang searah bukan yang saling melawan.

Node hasil: [`Status=Bermasalah`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2581-64371) di dalam component set `PromoCard` (`1978:53119`).

### Urutan render daftar PAGE-06V

`Terpakai` (kalau ada, maks 1) → `Aktif` → `Nonaktif` → `Bermasalah` (kalau ada, selalu paling akhir).

---

## SO-PRM-1 — Diskon Transaksi gugur saat konfirmasi, kartu tampil status Bermasalah di posisi teratas

**Frame Figma:** [Case: Promo Sudah Tidak Berlaku (Gugur Saat Konfirmasi)](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2588-397) — section demo lengkap (Cart screen + Promo screen bersebelahan, halaman **Keranjang**), berdampingan dengan case sejenis lain seperti [[SO_Case_ValidasiKeranjangRedesign]]. Titik masuk popupnya tetap [ValidationPopup](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1163-9025) yang existing.

**Prasyarat**

- Tamu punya sesi Self Order aktif dengan minimal 1 item di keranjang.
- Tamu sudah memasang 1 **Diskon Transaksi** dari halaman Promo (CTA di Keranjang sudah `Status=Terpakai`).
- Kondisi gugur bisa disimulasikan: waktu berlaku promo diset habis di sisi POS, atau promo diedit/ditarik dari sisi POS, tepat setelah tamu memasangnya di keranjang.

**Langkah reproduksi**

1. Di Keranjang, pastikan CTA Promo menunjukkan diskon yang sudah dipasang (`Status=Terpakai`, mis. "Diskon 20% · Kamu hemat Rp30.000").
2. Dari sisi POS/merchant, buat promo itu gugur (habis waktu, atau ditarik/diedit).
3. Tamu menekan tombol **"Konfirmasi Pesanan"**.
4. Amati `ValidationPopup` yang muncul — pastikan `IssueRow Type=Promo` (atau `Type=SPA`, sesuai jenis promo) menjelaskan promo yang gugur.
5. Tekan tombol **"Lanjut Bayar"** pada popup.
6. Perhatikan CTA Promo di Keranjang.
7. Tap CTA Promo untuk masuk ke halaman Promo (PAGE-06V), perhatikan urutan dan tampilan kartu.

**Hasil yang diharapkan**

- Langkah 4: popup menjelaskan promo yang gugur dengan nada informatif (sesuai [[SO_Case_ValidasiKeranjangRedesign]]), tombol utama **"Lanjut Bayar"** (bukan "Kembali ke keranjang" — tidak ada isu Stock yang butuh keputusan manual).
- Langkah 6: CTA Promo balik ke `Status=Kosong` biasa ("Promo dan Diskon · Lihat promo yang bisa dipakai"). **Tidak ada teks atau badge tambahan** di CTA ini.
- Langkah 7: di halaman Promo, kartu promo yang baru gugur tadi **masih tampil**, dalam `Status=Bermasalah`:
  - Tampilan dim 50% — sama persis bahasa "gak bisa dipakai" yang dipakai `Status=Nonaktif`.
  - Judul tetap nama promonya.
  - Baris syarat lama sudah tidak tampil, diganti teks **"Promo ini sudah tidak bisa dipakai."**
  - **Tidak ada tombol** di sisi kanan card (dihilangkan total, beda dari Nonaktif yang tombolnya masih ada walau redup).
  - Card ini **berada paling bawah**, di bawah kartu Aktif/Nonaktif lain yang masih berlaku.
- Kartu ini tetap tampil di posisi teratas selama sesi order ini berjalan. Setelah transaksi selesai (bayar/order baru), sesi baru tidak lagi menampilkan kartu tersebut.

**Hasil aktual (per 2026-07-30)**

**Sudah digambar lengkap.** Mekanisme popup (`ValidationPopup`/`IssueRow`) sudah digambar dan Approved di case lain. Variant [`PromoCard Status=Bermasalah`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2581-64371) dibangun sesuai spec tabel "Desain komponen" di atas (chip `infoSoft`/`info`, 1 baris alasan `muted`, tanpa tombol, border `line` 1px), dan section demo [Case: Promo Sudah Tidak Berlaku](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2588-397) menunjukkan alur lengkapnya: Cart screen dengan CTA balik `Status=Kosong`, dan Promo screen dengan kartu Bermasalah di posisi teratas di atas kartu Aktif/Nonaktif lain.

---

## Di luar scope

- **Promo Produk** (barang gratis/diskon otomatis, lihat §6 Kategori Promo) — tidak punya kartu pilihan di PAGE-06V, jadi tidak kena mekanisme `PromoCard Status=Bermasalah` ini. Kalau Promo Produk gugur saat konfirmasi, penanganannya tetap lewat `IssueRow` di popup saja (title tetap sebut nama produk pemicu, bukan judul promo).
- **Syarat promo gugur akibat tamu mengubah keranjang sendiri** (baris existing di [[SO_PRD_MVP]] §7 Acceptance Criteria PAGE-06) — itu real-time dan tamu tahu sebab-akibatnya langsung; tidak lewat `ValidationPopup` maupun mekanisme `Status=Bermasalah` di dokumen ini.
- Copy/wording final untuk `IssueRow Type=Promo`/`Type=SPA` saat kasus ini terjadi — dokumen [[SO_Case_ValidasiKeranjangRedesign]] menulis contoh generik ("Promo berakhir · −Rp30.000 gak berlaku"); belum diverifikasi apakah copy itu perlu disesuaikan dengan istilah "Diskon Transaksi" pasca-rename Voucher→Promo di [[SO_PRD_MVP]]. Perlu dicek oleh PM sebelum implementasi. **Update 2026-08-06:** makin sulit dicek sekarang karena link node `IssueRow Type=Promo` di atas juga nyasar (lihat bagian Desain) — perlu cari instance Type=Promo yang benar dulu di canvas sebelum bisa verifikasi copy-nya.
