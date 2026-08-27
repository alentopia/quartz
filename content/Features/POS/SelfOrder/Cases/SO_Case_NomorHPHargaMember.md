# Self Order — Case: Nomor HP di Keranjang untuk Cek Harga Member (SPA)

**Status:** Draft (placement Cart udah dieksekusi di Figma; feedback state di Confirm BELUM dirancang)
**Tanggal:** 2026-07-28
**Fitur:** Self Order
**Prefix:** SO
**Referensi:** [[SO_PRD]], [[SO_Case_ValidasiKeranjangRedesign]]
**File Figma:** `mAZuRze02w906M6u2EwVWh`, node `532:503` (Cart — CartScreen, section `promo-dan-harga-member`)

---

## Latar belakang

Field "Nomor HP" di Cart kelihatannya kayak pengumpulan data pelanggan biasa, tapi sebenarnya fungsinya spesifik: **cek harga SPA** (*Special Price Adjustment* — kategori penjualan yang udah dipilih di AOL). Kalau nomor yang diisi ternyata terdaftar sebagai member POS yang eligible SPA, harga di **Konfirmasi Pesanan** bisa berubah (biasanya turun). Ini nyambung ke `ValidationPopup` Type=SPA yang udah ada (lihat [[SO_Case_ValidasiKeranjangRedesign]]), tapi case itu baru cover skenario "SPA yang TADINYA berlaku, terus gak berlaku lagi" — belum cover skenario di case ini (user baru pertama kali isi nomor di Cart).

## Keputusan: Placement di Cart

Nomor HP awalnya keliatan "mendadak" (nyempil di tengah review item, gak ada alasan). Iterasi keputusan:
1. ~~Full card sendiri, shadow sama kayak ItemsCard~~ — kelewat berat buat field opsional.
2. ~~Dipindah ke paling bawah (sebelum CTA)~~ — malah kerasa kayak "gerbang" sebelum commit, nambah anxiety pas mau confirm.
3. **Digabung 1 section sama Promo** ("PROMO & HARGA MEMBER"), field Nomor HP jadi flat/gak elevated (beda bobot dari card penting), caption jelasin tujuan. ✅ Dipakai — karena Nomor HP & Promo itu **kategori sama**: sama-sama opsional, sama-sama "mungkin bikin lebih murah", sama-sama baru keliatan hasilnya belakangan (Promo pas dipilih, Nomor HP pas Konfirmasi). Constraint dari PM: **pengisian nomor HP gak boleh ganggu flow utama** — makanya harus opsional-terasa, bukan form wajib, gak ada validasi blocking di Cart.

Caption final: *"Opsional — dicek otomatis pas Konfirmasi Pesanan, gak ada efek langsung di sini"* — sengaja bilang eksplisit **"gak ada efek langsung di sini"** biar user gak nunggu perubahan di Cart yang emang gak bakal kejadian di layar ini.

## Mekanisme pengecekan: bareng validasi tap-tombol yang udah ada

**Dikonfirmasi PM (2026-07-28):** SPA gak butuh mekanisme terpisah. Pengecekan kejadian bersamaan dengan tap tombol **"Konfirmasi Pesanan"**, dibundel sama validasi Stock/Harga/Promo yang udah ada (lihat [[SO_Case_ValidasiKeranjangRedesign]]) — pakai `ValidationPopup` + `IssueRow` yang SAMA, tinggal tambah kejadian Type=SPA ke kombinasi yang di-cek, bukan bikin sistem baru.

Konsekuensi buat 3 state:
1. **Gak eligible / gak isi nomor HP** — **silent, lanjut normal ke pembayaran.** Ini KONSISTEN sama perilaku Stock/Promo yang udah ada (gak nongolin apa pun kalau semua aman) — bukan kasus khusus yang butuh UI baru. Caption Cart yang udah di-set ("dicek otomatis pas Konfirmasi Pesanan") cukup buat nyetel ekspektasi; gak perlu acknowledgment tambahan di Confirm.
2. **Eligible, harga berubah (biasanya turun)** — masuk ke `ValidationPopup` sebagai `IssueRow` Type=SPA, gabung sama issue lain kalau ada (kombinasi campur per pola yang udah didesain).

## Loading state & popup SPA — sudah dibuat (2026-07-28)

Dua hal dari flow di atas udah digambar di Figma, section `Case: Negative Case — Validasi Keranjang` (node `860:200`, page Komponen Komposit):

- **Step 2 (loading):** instance `Button` (node `2471:17175`) di-set `Loading=true`, `Show Icon=false`, `Label=" "` — pola yang UDAH ada di component Button, gak perlu screen baru. Ini yang dipakai pas tombol "Konfirmasi Pesanan" lagi proses cek Stock+Harga+Promo+SPA.
- **Step 3a (SPA ketemu):** frame baru `Cart — Harga Member/SPA Diterapkan (Popup)` (node `2471:287`), instance `ValidationPopup` (node `2471:350`) di-clone dari kasus "Harga & Promo Berubah" yang udah ada, teks di-custom: heading "Harga member diterapkan", paragraph "1 barang dapat harga khusus. Detail ada di keranjang.", reason "Nomor HP kamu terdaftar sebagai member POS yang eligible harga khusus.", `hasStockIssue=false` → tombol "Lanjut Bayar" (non-blocking, sesuai keputusan sebelumnya bukan "Kembali ke keranjang").

**Keputusan "kabar baik" (resolve dari opsi A/B sebelumnya):** dipilih **Opsi A** — tetep 1 sistem `ValidationPopup` yang sama, gak bikin komponen positif terpisah. Alasannya: `ValidationPopup` per desainnya sendiri udah netral-informatif buat SEMUA type (bukan mode alarm), termasuk yang "buruk" (stok habis) — jadi kabar baik gak perlu dibedain sistemnya, cukup beda teks & CTA (non-blocking).

**Temuan baru, belum di-fix:** icon header `ValidationPopup` (`warning-icon` / `illustration/warning-receipt`) masih ilustrasi kertas+lambang seru merah — kesannya alarm/error. Buat kasus SPA (kabar baik, harga turun) ini kerasa mismatch: visualnya bilang "ada masalah" padahal isinya "kamu hemat". **Bukan regresi dari kerjaan sesi ini** — komponen `ValidationPopup` master (`1163:9025`) sendiri emang cuma py 1 icon tetap ("bukan swap", per deskripsi komponennya), dipakai apa adanya di semua scenario termasuk yang lama (Stok Habis, Harga Naik). Perlu diputuskan: bikin icon alternatif buat kasus non-negatif (perlu aset baru, di luar scope teks-doang), atau terima icon netral apa adanya buat semua kasus (termasuk yang baik).

## Yang di luar scope / belum diputuskan

- Desain konkret state #2 di atas (baris/badge/copy persisnya) — baru diidentifikasi sbg gap, belum ada mockup.
- Apakah nomor HP yang salah format / gak valid butuh validasi di Cart — belum dibahas, constraint "gak ganggu flow utama" cenderung mengarah ke "jangan blocking sama sekali", tapi belum jadi keputusan eksplisit.
- Kode React — belum ada implementasi field ini maupun logic cek SPA-nya sama sekali.
