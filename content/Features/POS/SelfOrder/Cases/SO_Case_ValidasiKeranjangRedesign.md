# Self Order — Case: Redesign Negative Case Validasi Keranjang (Popup Stock/Harga/Promo/SPA)

**Status:** Approved (diimplementasi di Figma) — **direvisi 2026-08-06, popup dirombak lagi jadi lebih ringkas dari versi 2026-07-22 di bawah ini**
**Tanggal:** 2026-07-22 (revisi isi popup: 2026-08-06)
**Fitur:** Self Order
**Prefix:** SO
**Referensi:** [[SO_PRD]]
**File Figma:** `mAZuRze02w906M6u2EwVWh`, section `Case: Negative Case — Validasi Keranjang (Hold Dlu)` (node `860:200`)

## Kenapa dirombak lagi (2026-08-06)

Versi awal (di bawah) menaruh daftar `IssueRow` lengkap di dalam popup buat semua kombinasi. Itu gak scalable — kalau yang bermasalah banyak (misal user pesan 100 item dan belasan kehabisan stok bersamaan), popup jadi tembok teks / scroll panjang. Popup sekarang **selalu ringkas**: 1-2 kalimat + angka ringkasan, gak pernah menyebut satu-satu kecuali kasus 5+ (lihat bagian "Pola sekarang").

Prinsip tombolnya juga disederhanakan: cuma **stok habis** yang benar-benar memblokir checkout (barangnya gak ada, gak ada pilihan lain selain balik ke keranjang). Harga naik atau promo/SPA gak berlaku **tidak** memblokir — user tetap bisa lanjut bayar dengan angka yang sudah ter-update otomatis, makanya tombol utamanya bukan paksa balik ke keranjang.

## Pola sekarang (2026-08-06, verifikasi langsung dari component properties Figma)

`ValidationPopup` isinya `heading` + `paragraph` (ringkasan, bukan daftar) + tombol, dengan 4 varian yang sudah digambar:

| Varian frame | `hasStockIssue` | Isi paragraph | Tombol |
|---|---|---|---|
| **Stok Habis** | true | "3 barang di keranjangmu kehabisan stok. Hapus dulu di keranjang biar bisa checkout." | 1 tombol: **"Kembali ke keranjang"** |
| **Harga & Promo Berubah** | false | "1 barang naik harga, 1 promo gak berlaku lagi. Total selisih +Rp33.000. Detail ada di keranjang." | primer **"Lihat di keranjang"** + link sekunder "Kembali ke keranjang" (opsional, boleh diabaikan) |
| **Stok + Harga + Promo Berubah** | true | "1 barang stok habis, 1 barang naik harga, 1 promo gak berlaku. Cek keranjang buat beresin sebelum lanjut." | 1 tombol: **"Kembali ke keranjang"** |
| **Banyak Perubahan 5+** | true | "Ada beberapa hal yang berubah. Cek dulu sebelum lanjut." + daftar `IssueRow` (maks 4 baris + "Lihat N lainnya") | 1 tombol: **"Kembali ke keranjang"** |

Aturan tombolnya cuma 1: **ada stok habis di dalamnya (sendiri atau digabung apa pun) → cuma 1 tombol "Kembali ke keranjang", wajib benerin dulu.** Gak ada stok habis (cuma harga/promo/SPA) → tombol utama "Lihat di keranjang" (non-blocking, checkout tetap bisa lanjut), link "Kembali ke keranjang" cuma opsi tambahan buat yang mau cek dulu.

**Kasus 5+ itu satu-satunya yang masih nampilin daftar per item** (sampai 4 baris + collapse), karena rangkumannya gak bisa dipadetin jadi 1 kalimat kalau macem-macem sekaligus. Ini bukan sisa desain lama — itu bagian resmi dari pola baru buat kasus yang emang gak muat diringkas.

**Ketidaksesuaian kecil yang perlu dicek:** heading kasus 5+ pakai teks beda ("Pesanan perlu disesuaikan") dari 3 varian lain ("Ada penyesuaian pesanan") — belum jelas ini sengaja atau kelupaan disamain.

**Detail per-item pindah ke Cart, bukan lagi di popup.** `LineRow` di keranjang punya varian `StokHabis` (foto pudar + badge, item wajib dihapus manual, blocking) dan `HargaPromoBerubah` (chip accent di bawah harga, item tetap bisa dipesan, non-blocking) — pengguna cek detail lengkapnya di keranjang, bukan dari popup.

---

## Versi awal (2026-07-22 — sudah tidak berlaku, disimpan sebagai riwayat keputusan)

---

## Latar belakang

Popup validasi keranjang muncul saat customer tekan "Konfirmasi Pesanan" dan validasi server nemuin masalah di keranjang: item habis, harga berubah, promo berakhir, atau **SPA** (*Special Price Adjustment* — diskon produk/harga) udah gak berlaku.

Kondisi sebelum redesign ini (hasil `/impeccable critique` 2 kali jalan, skor 28/40 lalu 24/40):
- 4 frame dibikin manual terpisah (stok-habis-saja, harga+promo-berubah, kombinasi, 5+ issues) — bukan 1 sistem komponen adaptif beneran.
- Frame "Stok Habis" pakai visual grammar sendiri (food-photo tile + teks merah + ilustrasi besar 170×170 dengan sparkle) sementara 3 frame lain pakai `ValidationPopup` master component (icon-tile netral + icon kecil 52×52). Drift ini gak sengaja dan gampang kejadian lagi kalau nambah kombinasi baru.
- Nada visual (ilustrasi gede + badge alarm merah + teks merah bertumpuk) berlebihan buat momen yang sebenernya udah di-auto-resolve sama sistem — user cuma perlu acknowledge, bukan bikin keputusan besar.
- Gak ada penjelasan kenapa ini kejadian, dan setiap kasus dipaksa balik ke keranjang manual meski gak selalu perlu.

## Keputusan produk (dikonfirmasi user via brainstorming)

| Topik | Keputusan |
|---|---|
| Nada/rasa | **Tenang & informatif.** Bukan alarm. Icon kecil netral, bukan ilustrasi besar/badge merah mencolok. |
| Struktur komponen | **1 sistem adaptif.** `IssueRow` jadi component dengan variant `Type=Stock/Harga/Promo/SPA` (icon+warna+label ganti otomatis sesuai type). `ValidationPopup` nampung N `IssueRow` apa aja kombinasinya. |
| Overflow | Lebih dari 3-4 issue → collapse jadi baris "Lihat N lainnya" (pola yang udah dibangun di frame demo 5+, sekarang jadi bagian resmi komponen, bukan contoh terpisah). |
| Tombol aksi | **Dinamis berdasar isi.** Default: "Lanjut bayar" (kalau semua issue Type=Harga/Promo/SPA — keranjang otomatis udah ke-update, gak perlu keputusan manual). Ganti ke "Kembali ke keranjang" **hanya kalau ada minimal 1 issue Type=Stock** (butuh keputusan: ganti item atau lanjut tanpa item itu). |
| Info tambahan | **1 kalimat alasan singkat** kenapa ini bisa kejadian, di bawah judul/sebelum daftar issue. Tidak menampilkan total baru/selisih (sengaja di-skip, bukan lupa). |
| Warna per Type | Semua pakai pola icon-tile + teks netral (bukan teks berwarna alarm). Warna cuma di icon glyph sbg penanda kategori, bukan di teks status berulang. |

## Prinsip yang bikin desain ini gak "kelewatan"

- **Severity match reality.** Karena sistem udah auto-resolve (item dihapus/harga ke-update), visualnya harus terasa kayak notifikasi info, bukan gerbang darurat.
- **1 component, N kombinasi.** Nambah kasus baru (misal kombinasi Promo+SPA) = susun instance `IssueRow` baru, bukan gambar ulang frame.
- **Tombol nyerminin urgensi asli.** Cuma Type=Stock yang beneran butuh keputusan user; sisanya cukup 1 tap lanjut.
- **Skip total/delta.** Keputusan sadar user, bukan kelupaan — biar scope tetep kecil, gak nambah komputasi/format angka yang belum tentu dipake konsisten di semua kombinasi.

## Desain komponen

### A. `IssueRow` (component baru, variant `Type`)

Variant property: `Type` = `Stock` | `Harga` | `Promo` | `SPA`

Struktur tiap variant sama (icon-tile 44×44 di kiri + text block di kanan: nama item bold + status line netral abu-abu), cuma icon glyph + warna icon-tile yang beda per Type:

| Type | Icon | Warna icon-tile | Contoh status text |
|---|---|---|---|
| Stock | Icon/cart (atau serupa) | merah muda soft (danger-soft) | "Habis · dihapus dari pesanan" |
| Harga | Icon/tag | oranye soft | "Harga naik · Rp45.000 → Rp48.000" |
| Promo | Icon/percent | teal soft (primary-soft) | "Promo berakhir · −Rp30.000 gak berlaku" |
| SPA | Icon/percent (dipakai ulang, sama kayak Promo — dibedain lewat label teksnya, bukan icon baru) | teal soft (primary-soft) | "SPA gak berlaku lagi" |

Status text SEMUA pakai warna netral (`muted`/`ink`), bukan warna alarm — pembeda kategori cukup dari warna+bentuk icon-tile.

### B. `ValidationPopup` (rebuild master component)

Struktur tetap: icon kecil (52×52, netral, bukan ilustrasi besar) → heading → **1 baris alasan singkat (baru)** → paragraph → issues-card (isi N `IssueRow` sesuai kombinasi, auto-collapse "Lihat N lainnya" kalau >3-4) → tombol aksi dinamis.

Component property baru yang perlu ditambah di `ValidationPopup`:
- `hasStockIssue` (BOOLEAN) — kalau true, tombol utama = "Kembali ke keranjang". Kalau false, tombol utama = "Lanjut bayar".
- `reasonText` (TEXT) — 1 kalimat alasan singkat, default kosong/hidden kalau gak diisi.

### C. Frame demo yang perlu di-rebuild di section `860:200`

4 frame existing dirapikan ulang pakai sistem baru (bukan bikin frame baru lagi):
1. **Stok Habis saja** — 1-3 `IssueRow` Type=Stock, tombol "Kembali ke keranjang".
2. **Harga/Promo/SPA berubah (tanpa stock)** — campuran `IssueRow` Type=Harga/Promo/SPA, tombol "Lanjut bayar".
3. **Kombinasi (ada Stock + lainnya)** — campuran termasuk minimal 1 Type=Stock, tombol "Kembali ke keranjang".
4. **5+ issues** — contoh overflow, pakai collapse row yang sekarang jadi bagian resmi komponen.

## Bug fix: footer `secondary-link` nabrak ke bawah popup (2026-07-29)

**Ditemukan:** node `1163:9050` (`footer`, child `ValidationPopup` `1163:9025`).

**Gejala:** kalau state `secondary-link` (mis. "Kembali ke keranjang" sebagai link teks di bawah tombol utama) di-toggle visible, teksnya ke-clip/nabrak ke tepi bawah kartu popup — bukan berhenti rapi dengan padding.

**Root cause:** `footer` di-set **Fixed height 78px** (pas buat 1 `Button` doang: 54px + padding bawah ±24px), dan footer ini nempel persis di ujung bawah symbol (`footer.y 460 + height 78 = total popup height 538`). `secondary-link` posisinya **hardcode manual** (`y=62`, bukan lewat auto-layout gap), jadi begitu link muncul dia berakhir di `y=79` — 1px+ ngelewatin batas frame `footer` sekaligus batas bawah popup itu sendiri.

**Fix (sudah dieksekusi di Figma, 2026-07-29):**

`footer` (`1163:9050`) ternyata **sudah** auto-layout vertikal (gap 8, padding-bottom 24) — cuma `primaryAxisSizingMode`-nya `FIXED` (78px), jadi height gak ikut ngitung `secondary-link` pas node itu visible. Fix-nya: ubah `primaryAxisSizingMode` ke `AUTO` (hug contents). Parent `ValidationPopup` udah auto-height dari awal, jadi otomatis ikut melar tanpa perlu disentuh.

Diverifikasi via toggle `secondary-link.visible`:
- Hidden (default): footer 78px, popup 538px — **tidak berubah**, no regresi ke state existing.
- Visible: footer 78px → **103px**, popup 538px → **563px**, link duduk rapi dengan padding-bottom 24px, gak lagi ke-clip.

## Yang di luar scope (sengaja gak dikerjain)

- Total baru / selisih harga di popup — user pilih skip ini.
- Kode/prototype React — ini murni kerjaan desain Figma, `prototype/src` belum ada komponen buat case ini.
- P2 findings dari critique sebelumnya (kontras subtitle, red-vs-destructive-orange) — udah dicek terpisah, keduanya ternyata udah benar, gak butuh perubahan.
- Fix layout footer sudah dieksekusi & diverifikasi langsung di Figma (lihat section di atas).
