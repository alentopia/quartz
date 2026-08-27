# Self Order — Case: Flow Hapus & Edit Item di Keranjang (ManageCustomizationSheet)

**Status:** Approved (didokumentasikan; komponen sudah ada & terpakai di Figma, belum ada di kode)
**Tanggal:** 2026-07-28
**Fitur:** Self Order
**Prefix:** SO
**Referensi:** [[SO_PRD]]
**File Figma:** `mAZuRze02w906M6u2EwVWh`, component `ManageCustomizationSheet` (node `2008:54067`, page Komponen Komposit), demo instance di scrim (node `1998:75194`, page Konfirmasi Pesanan/Keranjang)

---

## Latar belakang

Cart (`532:503`) render tiap item pakai `LineRow` (badge qty bulat) atau `FreeChildRow` (untuk item gratis dari promo). Sebelumnya belum ada dokumentasi jelas: kalau user mau **hapus** atau **edit** item dari keranjang, tap apa dan kejadian apa selanjutnya. Flow ini menutup gap itu, sekalian nutup case item gratis yang bisa kelipatan (mis. promo beli-1-gratis-1 yang berlaku N kali).

## Flow: Hapus/Edit Item Berbayar

1. User punya item (mis. "Ayam Goreng Kremes") qty 1 di keranjang.
2. User mau hapus item itu.
3. User tap **badge qty (bulet angka)** ATAU tap **LineRow item itu langsung** — dua-duanya trigger aksi yang sama.
4. Terbuka **bottom sheet detail item** = `ManageCustomizationSheet` (lihat referensi Figma di atas).
5. Di sheet ini user bisa:
   - **Edit** → buka `ItemScreen` dengan modifier kombinasi itu udah ke-isi, buat diubah.
   - **Turunin qty via QtyStepper.** Kalau qty lagi 1 dan user tekan "−" → muncul `ConfirmDialog` ("Hapus item ini?", tombol Ghost "Batal" + Primary "Hapus", node `500:12220`) dulu, baru row itu beneran ke-remove kalau user confirm. **Bukan** hapus langsung tanpa konfirmasi.
   - **Nambah qty dengan modifier SAMA** → langsung naikin qty di LineKartu itu, gak perlu langkah tambahan.
   - **Nambah dengan modifier BEDA** → tap "Buat kustomisasi baru" → terarahkan ke `ItemScreen` dengan modifier KOSONG/belum keisi (fresh customization), jadi baris cart baru yang terpisah dari yang lama.

Kalau item yang sama di keranjang punya lebih dari 1 kombinasi modifier (hasil dari "Buat kustomisasi baru" berkali-kali), `ManageCustomizationSheet` nampilin **N `LineKartu`**, satu per kombinasi — bukan cuma 1 row. `body` sheet ini auto-layout vertical (hug height), jadi nambah row otomatis nambah tinggi sheet, gak perlu redesign per kasus.

## Flow: Item Gratis (promo kelipatan, mis. beli-N-gratis-N)

Pola sheet & tap-trigger-nya **sama persis** kayak item berbayar di atas, tapi ada 2 aturan tambahan:

1. **Total qty di semua `LineKartu` item gratis itu (dijumlah lintas modifier apa pun) gak boleh melebihi jatah gratis dari promo.** Mis. beli 10 → jatah gratis 10. User boleh split 10 itu jadi beberapa kombinasi modifier beda (mis. 6 original + 4 pedas), tapi totalnya tetap harus persis 10 — gak bisa nambah lebih dari jatah.
2. **Tombol "Buat kustomisasi baru" disabled/disembunyikan kalau jatah gratis udah habis ke-assign** ke `LineKartu` yang ada (mis. jatah cuma 1 dan itu udah jadi 1 row — gak ada sisa buat dipecah). Aktif lagi selama jatah > total ter-assign (mis. jatah 10, baru 6 ke-assign → sisa 4 boleh dibikin kombinasi baru — tapi qty yang bisa diisi di `ItemScreen` saat itu di-cap ke sisa jatah, bukan bebas isi angka apa pun).
3. **QtyStepper "+" di tiap `LineKartu` item gratis juga di-cap** aturan yang sama — gak bisa nambah kalau total lintas semua `LineKartu` item itu udah nyentuh batas jatah gratis.

**Terkait, dibenerin 2026-08-06:** frame demo **Case: Klaim Item Gratis** (page Keranjang) sempat nunjukin baris "Diskon transaksi" utk item gratis di `OrderSummary` walau item itu **belum diklaim** (kartu masih nunjukin tombol "Klaim promo", `LineKartu`-nya belum ada). Baris itu sudah disembunyikan + Subtotal disesuaikan supaya cuma ngitung item yang beneran ada di keranjang — lihat [[SO_Case_RincianPesananCampuran]] buat detail audit `OrderSummary` menyeluruh.

Badge qty di `FreeChildRow` Cart (bulet teal, sama gaya kayak `LineRow` berbayar) murni **indikator + tap-target**, BUKAN stepper inline (gak ada +/- langsung di badge itu, baik di item berbayar maupun gratis) — tap badge ATAU tap row-nya, dua-duanya buka `ManageCustomizationSheet` yang sama. Semua edit qty/modifier/hapus kejadian DI DALAM sheet itu (QtyStepper beneran ada di `LineKartu`, bukan di badge Cart). Ini penting supaya gak salah baca: badge yang keliatan "sama kayak berbayar" itu **disengaja** dan benar — bukan bug/kelupaan, karena keduanya sama-sama cuma entry point ke sheet yang sama, bukan kontrol langsung.

## Desain komponen (existing, bukan komponen baru)

### `ManageCustomizationSheet` — node `2008:54067`
Deskripsi lengkap (termasuk 2 aturan item-gratis di atas) sudah ditulis langsung di properti *description* komponennya di Figma, supaya kebaca AI/dev tanpa perlu buka dokumen ini. Struktur: handle → header (nama item + harga dasar + close) → body (N `LineKartu`) → footer (Button "Buat kustomisasi baru").

### `LineKartu` — node `2008:54025`
1 baris kombinasi modifier di dalam sheet: FoodImg + nama + harga + [Edit] + `QtyStepper` (Expanded, SM). Deskripsi juga sudah ditulis di komponennya.

### `ConfirmDialog` — node `500:12220` (reuse, bukan komponen baru)
Sudah ada & sudah didokumentasikan sebelumnya khusus buat "aksi destruktif/tak-bisa-dibatalkan (hapus item, ...)" — dipakai apa adanya buat konfirmasi hapus di flow ini, gak perlu bikin dialog baru.

## Yang di luar scope / belum diputuskan

*Diverifikasi ulang 2026-08-06 — ketiga gap di bawah masih terbuka, belum ada yang digarap sejak 2026-07-28.*

- **Kode/prototype React belum implement flow ini sama sekali** — `CartScreen.jsx` belum ada `onOpenManageSheet`/handler buka sheet ini dari tap badge atau LineRow, dan `ManageCustomizationSheet`/`LineKartu` belum ada versi kodenya di `prototype/src`.
- **Visual state "jatah gratis habis" (tombol "Buat kustomisasi baru" disabled) belum ada mockup-nya** di Figma — komponen `ManageCustomizationSheet` (`2008:54067`) cuma 1 component polos (bukan component set dengan variant per state), dan tombol footer-nya masih di-set `Disabled=false` di satu-satunya demo instance (`1998:75194`, scrim di section **Hapus Item dari Keranjang**). Primitif `Button`-nya sendiri sudah support variant `Disabled=true`, cuma belum ada instance yang di-override buat nunjukin state ini. Perlu diputuskan kalau mau digambar (opacity? tersembunyi total? ada tooltip alasan?).
- **Pesan error/validasi kalau user coba split qty gratis melebihi jatah** (mis. di `ItemScreen` pas "Buat kustomisasi baru") belum dirancang sama sekali — dicek ke seluruh page **Menu & Katalog**, gak ada teks copy soal "jatah"/"kuota"/"melebihi" sama sekali. Baru aturan cap-nya (tertulis di description component), belum copy/state error-nya.
