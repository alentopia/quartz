# Self Order — Case: Tab Self Order di Detail Meja (POS)

**Status:** Review (desain disetujui PM, sudah digambar di Figma sebagai usulan handoff)
**Tanggal:** 2026-08-04 (revisi total dari versi 2026-08-01)
**Fitur:** Self Order (dampak ke layar POS)
**Prefix:** SO
**Referensi:** [[SO_PRD_MVP]], [[SO_Case_NomorRefQRIS]], [[SO_Case_RincianPesananCampuran]]
**Layar:** POS — "Detail Meja Terisi". Layar ini **bukan** bagian file Figma Self Order — frame di file ini statusnya usulan handoff, eksekusi finalnya di tim POS.
**Figma:** file `mAZuRze02w906M6u2EwVWh`, page `MVP — Close Bill · QR Statis · Table Management`, section `Case : Detail Meja — Pendekatan Penempatan Self Order (3 varian pembanding)` (`2935:27455`). Rancangan final = **V4a** (`2940:404`) & **V4b** (`2940:69990`). V1–V3 di section yang sama sengaja dipertahankan sebagai jejak pembanding — bukan rancangan yang dipakai.

---

## Latar belakang

Layar "Detail Meja Terisi" merender seluruh item pesanan sebagai satu flat list tanpa jejak asal-usul maupun status bayar. Begitu Self Order jalan, satu meja bisa berisi dua hal yang secara keuangan berbeda jenis:

| | Self Order | Pesan di kasir |
|---|---|---|
| Waktu bayar | **Di muka**, sebelum masuk dapur | **Di akhir**, saat tamu selesai |
| Status saat meja masih terisi | Sudah lunas, transaksi tertutup | Masih berjalan (open bill) |
| Jejak | Punya nomor REF + struk sendiri | Menempel di bill meja |

Menggabungkan keduanya dalam satu list bukan cuma janggal secara visual — **ada risiko salah tagih**. Contoh di rancangan: Self Order Rp130.000 (lunas) + kasir Rp675.000 (belum). Tombol `Bayar` tanpa nominal tidak pernah menyatakan yang mana yang ditagih. Kalau sistem menagih Rp805.000, tamu kena tagih dua kali untuk item yang sudah dibayar di muka.

Masalah ini **sudah ada sebelum Self Order** — flat list lama juga tidak pernah menampilkan status bayar. Self Order hanya membuatnya nyata.

## Keputusan produk (dikonfirmasi PM via brainstorming)

| Topik | Keputusan |
|---|---|
| Pendekatan | **Pisahkan lewat tab**, bukan grouping di dalam satu list. Close bill dan open bill adalah dua objek keuangan berbeda, jadi tidak dicampur. |
| Susunan tab | `Informasi Pesanan` · **`Self Order`** · `Daftar Reservasi` — tab baru disisipkan **di tengah**, masing-masing 200px pada panel 600px. |
| Isi tab `Informasi Pesanan` | **Hanya open bill** (item yang dipesan di kasir). Ini yang akan ditagih. |
| Isi tab `Self Order` | **Hanya transaksi Self Order yang sudah lunas**, satu blok per transaksi. |
| Grouping di tab `Informasi Pesanan` | **Tidak ada.** Seluruh isi tab itu memang dari kasir, jadi header penanda tidak diperlukan. |
| Header per transaksi di tab `Self Order` | `REF-XXXXXX` (aksen teal) + **metode bayar** (`QRIS` / `BAYAR DI KASIR`) + `{n} item · Rp{subtotal}` + chevron `›`. |
| Kenapa metode bayar, bukan channel | Di dalam tab Self Order semuanya memang Self Order — menuliskannya lagi per baris mubazir. Yang membedakan antar transaksi adalah **cara bayarnya**. |
| Kenapa REF, bukan nomor penjualan POS | REF adalah nomor yang **dipegang tamu**, dan ada di kedua alur Self Order (QRIS maupun Bayar di Kasir). Lihat "Konflik nomor" di bawah. |
| Ringkasan pembayaran | Satu baris tepat di atas action bar, tampil di **semua tab**: `Total pesanan Rp805.000` (kiri) · `Sudah dibayar Rp130.000` (kanan). |
| Label tombol bayar | **`Bayar Rp675.000`** — membawa nominal, bukan `Bayar` telanjang. |
| Action bar | Milik **meja**, bukan milik tab. `cetak` / `Pesan` / `Bayar` berlaku sama di tab mana pun dan tidak berubah saat tab berpindah. |

## Kenapa tab, bukan grouping dalam satu list

Tiga varian grouping dibangun dan dibandingkan lebih dulu (V1–V3, masih ada di Figma). Semuanya menambal masalah, bukan menyelesaikannya: item lunas dan belum lunas tetap satu list, lalu ditambahi ringkasan supaya tidak salah tagih.

Tab menyelesaikannya di akar — di tab `Informasi Pesanan`, **satu-satunya angka yang ada di list adalah angka yang akan ditagih**. Tidak ada yang perlu dikecualikan.

Efek sampingnya: dua elemen yang dirancang panjang di versi grouping jadi **tidak terpakai**.

- Header `DIPESAN DI KASIR` — mubazir, karena seluruh isi tab itu dari kasir.
- Prefix `SELF ORDER ·` per baris — mubazir, karena nama tabnya sudah menyatakannya.

Aturan spasi grouping (jarak antar-grup ≈1,5× jarak antar-baris) **tetap dipakai**, tapi cakupannya menyusut: hanya untuk memisahkan antar-transaksi di dalam tab `Self Order`.

## Arah yang ditolak & alasannya

Dicatat supaya iterasinya tidak diulang dari nol.

| Arah | Ditolak karena |
|---|---|
| **Penanda per item** (`1 Pcs · Self Order` di tiap baris) | Redundan — item dari satu transaksi mengulang penanda identik berkali-kali. |
| **Penanda per sesi meja** (1 badge di header meja) | Salah granularitas — satu meja bisa berisi campuran, satu badge jadi menyesatkan. |
| **Card per order round** | Terbaca "nanggung" — satu list punya dua bahasa visual untuk hal yang secara struktur sama. |
| **Card yang bisa di-collapse, default tertutup** | Menyembunyikan data primer di balik interaksi. Staf bisa menekan `Bayar` tanpa sadar ada isi yang belum diperiksa. |
| **Label `Ditambah Staf`** | Framing menyebut pelaku, terbaca operasional. Diganti framing channel (`Dipesan di Kasir`), lalu akhirnya dibuang seluruhnya karena tab sudah memisahkan. |
| **Status sebagai label header grup** (`LUNAS · REF-XXXXXX`) | Kata status di baris paling atas gampang dibaca sebagai status **meja**, padahal meja itu masih punya tagihan. Justru salah baca yang lebih berbahaya. Status akhirnya ditempatkan di ringkasan dekat tombol — satu tempat saja, dekat uangnya. |
| **Dua zona bertingkat** (`SUDAH DIBAYAR` / `BELUM DIBAYAR` + grup di dalamnya) | Makan ~100px tinggi sehingga konten terpotong lebih cepat pada panel 940px, dan angkanya kembar ketika tiap zona berisi satu grup. Lihat V2 di Figma — listnya memang tampil terpotong. |
| **Nomor urut `Order #1/#2`** | Angka display-only, tidak bisa dicocokkan ke struk. Urutan waktu sudah tersampaikan lewat posisi di list. |
| **Bikin section/layar baru khusus Self Order** | **Sudah ada** — lihat "Temuan" di bawah. |

## Temuan selama pengerjaan

Tiga hal ditemukan di file Figma yang mengubah arah desain. Dicatat karena berlaku untuk pekerjaan POS berikutnya, bukan cuma case ini.

**1. Layar riwayat transaksi sudah ada.** Section `Case : Melihat Riwayat Transaksi Self Order` (`2016:77598`) berisi layar **Riwayat Penjualan** — lengkap dengan `Retur`, `Share Struk`, `Cetak Struk`, dan field **`Dibuat Oleh: Self Order`**. Jadi rencana "bikin section khusus Self Order" akan menduplikasi yang sudah ada. Chevron `›` di header transaksi ditujukan untuk membuka layar itu.

**2. Konflik nomor — belum selesai.** Riwayat Penjualan menomori penjualan sebagai **`S.482915637`**, sementara Self Order memberi tamu **`REF-398125`**. Format berbeda, jadi tidak bisa disilangkan. Rancangan ini memilih **REF** karena itu nomor yang dipegang tamu, tapi konsekuensinya: staf tidak bisa melompat dari REF ke penjualannya di Riwayat tanpa pemetaan di sisi sistem. Lihat "Perlu koordinasi".

**3. Layar POS bukan Inter dan bukan palet Self Order.** Font **Fira Sans**, weight hanya `Regular` & `Medium`, ukuran 12/14/16/20. Warna: `#F3F3F3` (primer), `#D7D7D7` (sekunder), `#FFE388` (harga), `#1799A5` (aksen/tab aktif). Tidak ada `Bold`/`Extra Bold`, tidak ada ukuran di bawah 12. Elemen baru wajib mengikuti skala ini — versi awal case ini memakai Inter 10.5px Extra Bold dan salah total.

## Desain elemen

### A. Tab bar

| Properti | Nilai |
|---|---|
| Susunan | `Informasi Pesanan` · `Self Order` · `Daftar Reservasi` |
| Lebar | 200px masing-masing (panel 600px) |
| Komponen | Instance `Tab` (`356:17805`), varian `Tab_on1` (aktif) / `Tab_off1` |
| Aktif | Satu saja; ditandai teks teal `#1799A5` + garis bawah 2px |

### B. Tab `Informasi Pesanan` — open bill

Daftar item polos, **tanpa header grup sama sekali**. Memakai komponen baris item yang sudah ada (thumbnail, nama, qty, detail varian/catatan, harga). Tidak ada perubahan pada baris item.

### C. Tab `Self Order` — transaksi lunas

Satu **header transaksi** per transaksi, lalu baris-baris itemnya di bawahnya.

| Bagian | Isi | Treatment |
|---|---|---|
| Nomor | `REF-398125` | Fira Sans Medium 14, teal `#1799A5` |
| Metode bayar | `QRIS` atau `BAYAR DI KASIR` | Fira Sans Medium 14, uppercase, `#D7D7D7` |
| Meta kanan | `{n} item · Rp{subtotal}` | Fira Sans Regular 14, `#D7D7D7` |
| Chevron | `›` | Teal — menandai baris ini membuka penjualannya di Riwayat Penjualan |
| Garis bawah | 1px | Putih 8% |

Header ini **bukan kontrol collapse** — isi transaksi tidak bisa ditutup. Chevron artinya "buka di Riwayat Penjualan", bukan "expand".

### D. Spasi antar-transaksi (wajib, bukan kosmetik)

Tidak memakai card, jadi pemisahan antar-transaksi bergantung penuh pada jarak.

| Aturan | Nilai di panel POS | Kenapa |
|---|---|---|
| `paddingTop` header transaksi pertama | **10px** | Tidak ada transaksi di atasnya yang perlu dipisah |
| `paddingTop` header transaksi berikutnya | **34px** | Dengan `itemSpacing` list 16px → jarak antar-transaksi 50px vs 32px antar-baris item (≈1,56×) |
| Baris terakhir tiap transaksi | Garis bawah **dihapus** | Transaksi ditutup oleh ruang kosong, bukan garis |

Rasio target **1,5–1,7×**. Di bawah itu batas transaksi ambigu; di atas itu list terasa bolong. Kalau spasi ini "dirapikan" jadi seragam, pemisahannya rusak — dan rusaknya tidak terlihat sebagai bug, hanya terasa sulit dibaca.

### E. Ringkasan pembayaran

Satu baris, tepat di atas action bar, **tampil di semua tab** (informasinya milik meja, bukan milik tab).

| Posisi | Isi | Treatment |
|---|---|---|
| Kiri | `Total pesanan Rp805.000` | Fira Sans Regular 12, `#D7D7D7` |
| Kanan | `Sudah dibayar Rp130.000` | Fira Sans Regular 12, `#D7D7D7` |

Copy-nya **`Total pesanan`**, bukan `Total tagihan` — angka itu mencakup bagian yang sudah dibayar, jadi bukan tagihan. Yang ditagih adalah selisihnya, dan itu ada di tombol.

### F. Action bar

Tidak berubah strukturnya (`cetak` · `Pesan` · `Bayar`), berlaku ke level meja di tab mana pun. Satu perubahan: **label tombol bayar membawa nominal** — `Bayar Rp675.000`.

Ini yang menutup risiko salah tagih. `Bayar` telanjang bisa dibaca sebagai menagih seluruh Rp805.000; `Bayar Rp675.000` tidak bisa.

**Konsistensi angka yang harus dijaga:** `Total pesanan − Sudah dibayar = nominal di tombol`. Ketiganya tampil bersamaan di satu layar, jadi kalau salah satu tidak sinkron, staf langsung melihatnya sebagai kesalahan.

## Yang di luar scope

- **Grouping DINE IN / TAKE AWAY di layar POS ini.** Belum dibahas; kalau dipakai bareng, perlu diputuskan level mana yang di luar.
- **Aksi per transaksi** (retur, cetak struk per transaksi). Sudah tersedia di Riwayat Penjualan — chevron mengarah ke sana, tidak diduplikasi di layar ini.
- **Penomoran order POS untuk item kasir.** Tidak ditampilkan; tab `Informasi Pesanan` tidak punya header sama sekali.
- **Perubahan komponen `OrderCard`** (`591:14992`). Tetap dipakai di Self Order Cart sisi tamu, tidak disentuh — bentuk card-nya justru yang ditinggalkan untuk layar POS.
- **Pembayaran sebagian (split/partial) pada open bill.** Kalau POS mendukungnya, sebagian item kasir bisa lunas sementara meja masih terisi — rancangan ini belum menanganinya.

## Acceptance Criteria

**Tab**

- **AC-1** — Given layar Detail Meja Terisi terbuka, When tab bar tampil, Then ada tiga tab berurutan: `Informasi Pesanan`, `Self Order`, `Daftar Reservasi`.
- **AC-2** — Given tab mana pun aktif, When tab bar dilihat, Then tepat satu tab bertanda aktif (teks teal + garis bawah 2px).

**Tab Informasi Pesanan**

- **AC-3** — Given tab `Informasi Pesanan` aktif, When list tampil, Then hanya item open bill (dipesan di kasir) yang muncul — transaksi Self Order tidak ikut.
- **AC-4** — Given AC-3, When list tampil, Then **tidak ada header grup apa pun** di list itu.

**Tab Self Order**

- **AC-5** — Given meja punya ≥1 transaksi Self Order lunas, When tab `Self Order` aktif, Then setiap transaksi punya header berisi `REF-XXXXXX`, metode bayar, dan `{n} item · Rp{subtotal}`.
- **AC-6** — Given dua transaksi Self Order dengan metode bayar berbeda, When keduanya tampil, Then metode bayarnya tertulis sesuai masing-masing (`QRIS` / `BAYAR DI KASIR`), bukan label channel yang sama.
- **AC-7** — Given meja hanya punya satu transaksi Self Order, When tab tampil, Then headernya **tetap tampil** (tidak di-skip meski cuma satu).
- **AC-8** — Given staf menekan header transaksi, When ditekan, Then penjualan itu dibuka di Riwayat Penjualan — **bukan** meng-collapse isinya.
- **AC-9** — Given ≥2 transaksi Self Order, When list tampil, Then jarak antar-transaksi ≈1,5–1,7× jarak antar-baris item, dan baris terakhir tiap transaksi tidak punya garis bawah.
- **AC-10** — Given meja tidak punya transaksi Self Order sama sekali, When tab `Self Order` dibuka, Then tampil empty state — **copy-nya belum ditentukan, lihat "Perlu diputuskan"**.

**Ringkasan & pembayaran**

- **AC-11** — Given tab mana pun aktif, When layar tampil, Then baris ringkasan `Total pesanan` dan `Sudah dibayar` tetap tampil (tidak berubah saat pindah tab).
- **AC-12** — Given layar tampil, When tombol bayar dilihat, Then labelnya menyertakan nominal yang akan ditagih, mis. `Bayar Rp675.000`.
- **AC-13** — Given ketiga angka tampil, When dihitung, Then `Total pesanan − Sudah dibayar = nominal di tombol`.
- **AC-14** — Given staf menekan tombol bayar, When pembayaran diproses, Then **hanya** bagian open bill yang ditagih — transaksi Self Order yang sudah lunas tidak ditagih ulang.
- **AC-15** — Given tab berpindah, When action bar dilihat, Then isi dan perilakunya tidak berubah (milik meja, bukan milik tab).

**Konsistensi visual**

- **AC-16** — Given elemen baru di layar ini, When diperiksa, Then memakai Fira Sans (`Regular`/`Medium`), ukuran ≥12, dan warna dari palet POS (`#F3F3F3` / `#D7D7D7` / `#FFE388` / `#1799A5`).
- **AC-17** — Given baris item di tab `Informasi Pesanan` dan di tab `Self Order`, When dibandingkan, Then bentuk barisnya identik — tidak ada pembeda visual di level baris.

## Perlu diputuskan

- [ ] **Nama tab `Self Order` vs channel prabayar lain.** PM sempat mengangkat bahwa **Kiosk** juga bayar di muka dan akan masuk kategori yang sama. Kalau nanti Kiosk masuk, `Self Order` jadi nama yang terlalu sempit — pilihannya: rename ke nama netral (mis. `Sudah Dibayar` / `Prabayar`, tapi ini mengubah pasangan nama tab yang sudah ada), atau tab terpisah lagi per channel, atau tetap `Self Order` dan Kiosk menumpang dengan penanda channel per baris. **Belum diputuskan.**
- [ ] **Tab muncul selalu atau kondisional.** Mayoritas meja tidak punya transaksi Self Order. Kalau tab selalu ada, kebanyakan meja punya tab kosong; kalau kondisional, susunan tab berubah antar meja. Terkait AC-10 (copy empty state).
- [ ] **Penamaan tab belum sejajar.** `Informasi Pesanan` vs `Self Order` bukan pasangan setara — Self Order juga informasi pesanan. Pasangan yang jujur `Belum Dibayar` vs `Sudah Dibayar`, tapi itu berarti mengganti nama tab yang sudah ada.

## Perlu koordinasi

- [ ] **Pemetaan REF ↔ nomor penjualan POS.** Header memakai `REF-XXXXXX` sementara Riwayat Penjualan memakai `S.XXXXXXXXX`. Supaya AC-8 (chevron membuka penjualannya) bisa jalan, sistem harus bisa memetakan REF ke penjualan yang benar. Kalau pemetaan itu tidak ada, chevron harus dibatalkan atau nomornya diganti.
- [ ] **Subtotal per transaksi & agregat.** Butuh subtotal per transaksi Self Order (untuk header), total seluruh pesanan meja, dan total yang sudah dibayar (untuk ringkasan). Konfirmasi ketiganya bisa di-expose.
- [ ] **Sumber data pemisah tab.** Sistem harus bisa memisahkan item "dari Self Order" vs "dipesan di kasir" pada satu sesi meja. Kalau pembedanya ada/tidaknya REF, itu sudah cukup.
- [ ] **Siapa yang menggambar final.** Layar ini di luar file Figma Self Order. Frame V4a/V4b di file ini statusnya usulan — perlu dipastikan siapa yang memindahkannya ke file POS.

## Catatan perbaikan kecil di Figma

Ditemukan saat membaca kondisi akhir, belum diperbaiki:

- [ ] Teks nomor di V4b terbaca `REF -398125S` dan `REF -245225` — ada spasi setelah `REF` dan huruf `S` menempel di belakang nomor pertama. Format yang benar: `REF-398125`.
