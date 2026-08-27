# Self Order — Case: FreeChildRow, State Stok Habis

**Status:** Approved (dibangun langsung di Figma sebagai component set, belum ada di kode)
**Tanggal:** 2026-08-10
**Fitur:** Self Order
**Prefix:** SO
**Referensi:** [[SO_PRD]] · [[SO_Case_HapusEditItemKeranjang]]
**File Figma:** `mAZuRze02w906M6u2EwVWh`, component set `FreeChildRow` (node `3153:76017`, page Komponen Komposit) — variant `Stok=Tersedia` (node `1902:126`, lama) dan `Stok=Habis` (node `3153:817`, baru)

---

## Latar belakang

Tiga tempat state "Habis" (item kehabisan stok) sudah punya desain di Figma sebelum case ini: `MenuCard` (Grid & List, `Stok=Habis`), `LineRow` cart (`List Makanan Di Keranjang=StokHabis`), dan `FreeItemChoice` (`State=Soldout`, dipakai di halaman Pilih Item Hadiah Promo). **Yang belum ada**: `FreeChildRow` — baris item gratis hasil klaim promo yang sudah nempel di keranjang (lihat [[SO_Case_HapusEditItemKeranjang]]) — tidak punya state kalau item gratis itu tiba-tiba kehabisan stok saat masih di cart. Case ini nutup gap itu.

`FreeChildRow` sebelumnya cuma component tunggal (bukan component set) dengan 2 property boolean (`Ada Modifier`, `Ada Catatan`). Untuk nambah state Habis, `FreeChildRow` diubah jadi **component set** dengan property variant baru `Stok` (`Tersedia` / `Habis`) — pola penamaan yang sama seperti `MenuCard`, biar konsisten dengan komponen lain yang sudah punya state ini.

## Keputusan perilaku

Item gratis yang kehabisan stok di cart **wajib dihapus manual oleh user** sebelum bisa lanjut checkout — sama seperti item berbayar di `LineRow StokHabis`, **bukan** auto-dilepas dari klaim promo / dicariin gantinya otomatis.

## Desain — variant `Stok=Habis`

Pola diambil langsung dari `LineRow` `List Makanan Di Keranjang=StokHabis`, di-scale ke ukuran `FreeChildRow` (foto 48 bukan 60):

- **FoodImg** (48×48, r8) dibungkus frame baru `FoodImgWrap` (clip r8) → opacity **45%**.
- **Badge "Habis"** nempel di bawah foto, full-width 48, danger 0.8 opacity, teks putih 9 Bold, radius bawah 8 (rounded-top 0) — menyatu visual dengan foto.
- **Nama item** tetap Bold 13, warna berubah dari `ink` jadi `muted`.
- **Baris harga (coret + Rp0), baris opsi/modifier, baris catatan** — semua dihapus dari variant ini, diganti 1 baris pesan italic faint 12px: *"Hapus item ini untuk melanjutkan pesanan."* (copy identik dengan `LineRow StokHabis`).
- **Badge qty bulat primer** diganti `Icon/trash` 16px (instance dari component `491:23`), tetap di slot absolute flush-kanan yang sama (`x = innerWidth - iconWidth`, `y = 10`) — mengikuti aturan komponen ini sendiri: "jangan kasih inset tambahan, biar kolom badge lurus antar row-type".
- **Connector** 3px kiri (penanda child row) — tidak berubah, itu penanda struktur bukan status stok.
- Behavior: baris **wajib dihapus** (tap trash) sebelum lanjut checkout, **dikecualikan dari subtotal** selama masih nempel di cart.

Konten variant `Stok=Tersedia` (lama) tidak berubah sama sekali — deskripsi asli soal kenapa pakai badge qty bulat (bukan trash) untuk item yang masih tersedia, termasuk alasan "qty gratis bisa kelipatan & butuh edit modifier", tetap berlaku dan tidak kontradiksi dengan keputusan di variant Habis (trash di sini masuk akal karena baris memang dihapus total, bukan diedit qty-nya).

Detail lengkap sudah ditulis di properti *description* component set & masing-masing variant di Figma, supaya kebaca AI/dev tanpa perlu buka dokumen ini.

## Keputusan trigger & alur (2026-08-10)

Sempat ambigu apa "real-time" di description `LineRow StokHabis` berarti live-polling selagi cart dibuka. **Diputuskan bukan** — triggernya cukup validasi yang sudah ada, dipicu pas tamu menekan **"Cek Stok & Promo"** di PAGE-06:

1. Tamu tekan "Cek Stok & Promo".
2. Server validasi menemukan item (berbayar via `LineRow` atau gratis-klaim-promo via `FreeChildRow`) abis stok.
3. Tamu **tetap di PAGE-06** (tidak lanjut ke PAGE-08) — row item itu berubah ke variant `Stok=Habis`, dan `ValidationPopup`/`IssueRow Type=Stock` muncul bareng (lihat [[SO_Case_ValidasiKeranjangRedesign]]) memberi tahu jumlah item bermasalah secara generik, sementara row-nya sendiri nunjuk **item mana**.
4. Tamu wajib hapus row `Stok=Habis` (tap trash) sebelum bisa lanjut.
5. Tekan "Cek Stok & Promo" lagi → kalau bersih, baru masuk PAGE-08.

Konsekuensi: [[SO_PRD]] PAGE-06 ditambah state `stok-habis` + AC-06.7/AC-06.8; PAGE-08 AC-08.2 (auto-hapus otomatis) direvisi karena gerbangnya sekarang di PAGE-06 — AC-08.2 cuma relevan buat race condition, belum diputuskan fallback-nya.

## Yang di luar scope / belum diputuskan

- **Kode belum ada** — `CartScreen.jsx` belum punya logic validasi ini, dan belum ada versi React untuk variant `Habis` ini maupun `ValidationPopup`/`IssueRow`.
- **Race condition PAGE-08** (stok berubah lagi di jeda antara lolos validasi PAGE-06 dan render PAGE-08) — fallback-nya belum diputuskan, lihat AC-08.2 di [[SO_PRD]].
