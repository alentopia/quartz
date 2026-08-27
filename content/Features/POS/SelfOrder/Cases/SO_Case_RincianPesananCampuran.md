# Self Order — Case: Rincian Pesanan Campuran Dine In & Take Away

**Status:** Draft (keputusan desain didokumentasikan, belum digambar ulang di Figma)
**Tanggal:** 2026-07-29
**Fitur:** Self Order
**Prefix:** SO
**Referensi:** [[SO_PRD]]
**File Figma:** `mAZuRze02w906M6u2EwVWh`, node `2532:5347` (layar/komponen rincian pesanan — flat list, belum ada grouping)

---

## Latar belakang

Node `2532:5347` sekarang render semua item pesanan sebagai **flat list**, tanpa pembeda fulfillment. Ini oke selama semua item di pesanan itu **dine in doang**. Begitu pesanan campur (ada item dine in + ada item take away dalam 1 transaksi/meja), flat list gak kasih sinyal ke operator (dapur/kasir/pelayan) barang mana yang perlu diantar ke meja vs yang perlu di-packing buat dibawa pulang — resiko salah antar/salah packing.

## Keputusan: Grouping per Fulfillment Type

Rincian pesanan dipecah jadi section per fulfillment, dengan header label (mis. "DINE IN" / "TAKE AWAY") di atas tiap grup item-nya.

1. **Header section cuma muncul kalau pesanan punya >1 fulfillment type.** Kalau 100% dine in atau 100% take away → tetap flat list kayak desain lama, gak usah paksa munculin 1 header buat 1 grup (noise, redundan).
2. **Urutan grup konsisten:** Dine In duluan, baru Take Away. Urutan ini dipakai sama di semua tempat yang nampilin breakdown ini — Cart, Confirm, Success, struk cetak, maupun tampilan kasir/KDS. Jangan beda pola antar layar.
3. Header section pakai markup semantik (heading/`role="separator"`), bukan cuma teks abu-abu bergaya — supaya screen reader announce pergantian grup, bukan silent visual divider aja. (lihat [[#Catatan aksesibilitas]])

## Keputusan: Label Diskon Generik

Baris diskon di subtotal section **gak lagi pakai nama promo spesifik** (mis. "Promo Ayam Goreng Kremes"). Diganti jadi label generik, biar gampang di-mapping ke struktur data dan gak nambah baris tiap ada promo baru:

| Label | Isi | Kapan tampil |
|---|---|---|
| **Potongan harga** | Sum semua diskon level-item (promo per barang), digabung jadi 1 angka — bukan 1 baris per promo | Cuma kalau nilainya > 0 |
| **Diskon transaksi** | Sum semua diskon level-transaksi (voucher, diskon member, dll) | Cuma kalau nilainya > 0 |

Detail "diskon dari barang yang mana" (kalau dibutuhkan) ditaruh di level item itu sendiri (mis. badge/caption kecil di bawah nama item), **bukan** di-list ulang di subtotal section — supaya panjang subtotal section tetap konsisten berapa pun jumlah item yang lagi diskon.

## Keputusan: Urutan Baris Rincian Harga (final, 2026-07-29)

Ditambah **Pembulatan** (rounding) yang belum pernah didokumentasikan sebelumnya. Urutan baris **FIXED**, gak boleh reorder tergantung data — baris yang nilainya 0/kosong di-skip (hidden), bukan dipindah posisi:

```
1. Subtotal
2. Potongan harga     (diskon level-item)     — tampil kalau > 0
3. Diskon transaksi    (diskon level-transaksi) — tampil kalau > 0
4. Pajak N%
5. Pembulatan          (+/-)                   — tampil kalau ≠ 0
6. Total
```

**Formula (urutan hitung wajib sama persis):**
```
DPP (dasar pengenaan pajak) = Subtotal − Potongan harga − Diskon transaksi
Pajak                        = N% × DPP
Total                        = DPP + Pajak + Pembulatan
```

Poin kritis buat QA: **pajak dihitung dari DPP net** (subtotal yang udah dikurangi KEDUA diskon), **bukan** dari subtotal kotor. Ini beda dari behavior lama yang cuma punya 1 slot diskon generik — sekarang ada 2 diskon yang harus digabung dulu sebelum pajak dihitung.

### Contoh angka (dipakai sebagai instance referensi di Figma)

```
Subtotal            Rp129.000
Potongan harga        – Rp38.000
Diskon transaksi       – Rp5.500
Pajak (10%)            Rp8.550   ← 10% × (129.000 − 38.000 − 5.500) = 10% × 85.500
Pembulatan              + Rp50
Total                  Rp94.100  ← 85.500 + 8.550 + 50
```

## Build di Figma (dieksekusi 2026-07-29)

Ternyata `node 2532:5347` (instance `PesananCard`) BUKAN komponen breakdown harga yang lengkap — cuma render `Subtotal` doang, gak ada baris diskon/pajak/total sama sekali. Komponen breakdown-harga yang SUDAH lengkap dan reusable ternyata component lain: **`SummaryRow`** (component set, variant `Tone=Default/Promo/Total`) dipakai oleh 2 komponen turunan:

- **`OrderSummary`** (`507:65`, dipakai di layar Keranjang & Konfirmasi Pesanan) — sebelumnya cuma 1 slot diskon ("Diskon voucher").
- **`OrderSummaryFlat`** (`2057:54840`, dipakai di layar Konfirmasi Pesanan) — sebelumnya cuma 1 slot diskon bernama spesifik ("Gratis Ayam Goreng Kremes").

Kedua komponen di-update supaya match urutan final di atas:
1. Row diskon existing di-**relabel generik** (bukan bikin baru): `OrderSummaryFlat` → "Gratis Ayam Goreng Kremes" jadi **"Potongan harga"**; `OrderSummary` → "Diskon voucher" jadi **"Diskon transaksi"**.
2. **Row yang belum ada ditambah** pakai instance baru dari `SummaryRow` (`Tone=Promo` buat diskon, `Tone=Default` buat Pembulatan), disisipin di index yang benar — bukan bikin frame baru dari nol.
3. Value Pajak & Total di-update biar konsisten sama contoh angka di atas.

Auto-layout (`Hug contents`, sudah ada dari awal di kedua komponen) otomatis nge-grow tinggi card pas nambah row — gak perlu resize manual (`OrderSummaryFlat` 272→324px, `OrderSummary` 141→191px).

**Diverifikasi ke semua instance existing** (16× `OrderSummary` di Keranjang, 6× `OrderSummaryFlat` + beberapa `OrderSummary`/`PesananCard` di Konfirmasi Pesanan, beberapa lagi di halaman MVP): semua otomatis ikut struktur baru. Beberapa instance punya tinggi beda (mis. 166px, 313px) — ini **bukan bug**, itu row `Diskon transaksi` yang emang di-hidden per-instance (order itu di dunia nyata gak selalu pakai voucher) — override visibility lama tetap ke-preserve dengan benar, screenshot dicek gak ada clipping/overlap.

## Catatan aksesibilitas

- Header grup (DINE IN/TAKE AWAY) pakai heading/`role="separator"` semantik, bukan teks polos — screen reader perlu tahu ganti konteks grup.
- Cek kontras teks caption abu-abu (label section, "PESANAN", dll) — target minimal 4.5:1 terhadap background putih.
- Tanda minus (`–`) di depan nominal diskon **dipertahankan** sebagai pembeda non-warna (jangan andalkan warna biru/teal doang buat nandain baris ini diskon).

## Update 2026-07-30 — Drift pajak/layanan resolved + audit angka menyeluruh

**Keputusan PM (final):** baris pajak selalu **"Pajak (10%)"** — nama generik, gak nyebut "layanan". Biaya layanan (service charge) **di-take-out dari scope MVP**, belum ada baris terpisah untuknya. `OrderSummary` yang sebelumnya pakai "Pajak & layanan (11%)" **diturunkan jadi 10%, label "Pajak (10%)"** supaya konsisten sama `OrderSummaryFlat`. Kalau nanti service charge masuk lagi, itu jadi baris baru sendiri (`Biaya Layanan`), bukan digabung diam-diam ke rate pajak.

**Audit ditemukan: banyak instance di luar 2 master component drift dari master-nya sendiri** — label ke-override manual jadi salah (baris `Diskon transaksi` ke-typo balik jadi "Potongan harga" duplikat, "PPN 10%" bukan "Pajak (10%)"), dan `Total`/`Pajak` gak pernah dihitung ulang setelah override. Semua instance berikut sudah dibenerin (label + angka, formula DPP-net):

| Halaman | Instance | Sebelum | Sesudah |
|---|---|---|---|
| Keranjang | 15× `OrderSummary` (varian Subtotal Rp114.000/Rp142.000/Rp90.000) | Total gak nyambung (angka Pembulatan/diskon gak ke-hitung) | Total dihitung ulang per instance, formula DPP-net |
| Keranjang | `2014:1398` | Subtotal typo **"Rp142.00"** (kurang 1 nol) | Rp142.000 |
| Keranjang → Case Campuran | `2014:1468` | Bawa diskon -10.000/-38.000 yang gak relevan ke skenario 2-item ini | Diskon di-hidden, Subtotal Rp90.000 → Pajak Rp9.000 → Total Rp99.000 |
| Konfirmasi Pesanan | `2538:34121` (`OrderSummary`) | Sama pola drift di atas | Dibenerin |
| Konfirmasi Pesanan → Case Campuran | breakdown `994:403` | Baris "Gratis Ayam Goreng Kremes -Rp38.000" nyasar (item itu gak ada di skenario ini: cuma Nasi Ayam Bakar Madu + Sate Ayam Bakar Komplit) | Baris dihilangkan, Pajak dihitung dari Subtotal bersih Rp90.000 → Rp9.000, Total Rp99.000 |
| Selesai & Struk → Case Campuran (dibuat 2026-07-29) | Success screen | Item beda sama Cart/Confirm (3 item, bukan 2), label "Diskon promo"/"Pajak & layanan" | Item disamakan persis: Nasi Ayam Bakar Madu (Dine In) + Sate Ayam Bakar Komplit (Take Away), Subtotal/Pajak/Total identik sama Cart & Confirm (90.000/9.000/99.000), label disamakan generik |
| MVP | `1942:52303` (`OrderSummary`) | Pajak & Total ngabaikan baris diskon -38.000 | Dihitung ulang: DPP Rp10.000, Pajak Rp1.000, Total Rp11.000 |
| MVP | `1899:15117` (`OrderSummary`) | Angka udah bener, cuma label "PPN 10%" | Label ke "Pajak (10%)" |

**Dibenerin 2026-08-06 — audit menyeluruh ulang ke semua 17 instance `OrderSummary`/`OrderSummaryFlat` di page Keranjang** (bukan cuma 2 yang disebut draf sebelumnya — ternyata ada 5 instance kena, 2 di antaranya belum pernah tercatat):

| Instance | Section | Sebelum | Sesudah |
|---|---|---|---|
| `1998:74714` | Pakai Voucher dan Tidak Aktif | Subtotal Rp86.000 tapi item Nasi Ayam Bakar Madu di kartunya nulis Rp45.000 (kurang modifier Extra Pedas +Rp3.000), baris diskon Kremes salah label "Potongan harga", Total nulis Rp50 (padahal cuma nyalin angka Pembulatan) | Harga Nasi dibenerin ke Rp48.000, label diganti "Diskon transaksi", **Total Rp47.950** |
| `2630:27642` | Lihat Detail Voucher Promo Screen | Subtotal Rp48.000 (harusnya Rp86.000 dari 2 item di kartu), Pajak Rp0 ikut salah, Total Rp50 | Subtotal **Rp86.000**, Pajak **Rp3.800**, **Total Rp41.750** |
| `2071:89728` *(baru ketemu, gak ada di draf sebelumnya)* | Hapus Item dari Keranjang (cart ke-2, abis item Es Cendol Durian dihapus) | Subtotal masih Rp114.000 — stale, gak ke-update abis 1 item dihapus dari kartu | Subtotal **Rp86.000**, Pajak **Rp3.800**, **Total Rp41.750** (sama kasusnya kayak di atas: 2 item sisa Nasi + Kremes) |
| `1998:74748`/`581:75` | Voucher Sudah Dipakai | Harga Nasi juga salah Rp45.000, Subtotal Rp142.000 (harusnya Rp114.000), dan ada 2 baris kembar sama-sama nulis "Diskon Transaksi"/"Diskon transaksi" | Harga Nasi **Rp48.000**, Subtotal **Rp114.000**, baris dipisah jadi "Diskon Transaksi -Rp30.000" (voucher) + "Potongan harga -Rp38.000" (promo Kremes, level-item — sesuai konvensi §"Keputusan: Label Diskon Generik" di atas), Pajak **Rp4.600**, **Total Rp50.550** |
| `2014:1440` | Klaim Item Gratis | Subtotal Rp114.000 + baris "Diskon transaksi -Rp38.000" ikut tampil, padahal item Ayam Goreng Kremes **belum diklaim** (kartu masih nunjukin tombol "Klaim promo", item itu belum masuk daftar) | Subtotal **Rp76.000** (cuma Nasi + Es Cendol Durian, sesuai isi kartu), baris diskon Kremes disembunyikan (gak relevan sebelum diklaim) — Pajak & Total kebetulan udah bener dari awal (Rp6.600/Rp72.550), gak berubah |
| `2014:1468` | Pesanan Campuran Dine In + Take Away | Baris "Pembulatan -Rp50" tetap tampil walau Total sudah di-fix manual ke Rp99.000 (lihat tabel audit "Update 2026-07-30" di atas) — dua baris ini saling kontradiksi | Baris Pembulatan disembunyikan, Total **Rp99.000** dipertahankan sesuai keputusan yang sudah final |

**Root cause umum:** kemungkinan besar semua instance ini adalah salinan manual dari 1-2 instance "master" (Nasi+Kremes+Cendol/Rp114.000), lalu sebagian baris diubah/dihapus buat skenario masing-masing (item dihapus, promo belum diklaim, dll) tapi baris **Subtotal/Pajak/Total gak ikut dihitung ulang** — sama pola dengan drift yang sudah ditemukan di audit "Update 2026-07-30" sebelumnya, cuma kelewat di 5 instance ini.

**Catatan asumsi yang belum diverifikasi ke PM:** baris "Potongan harga -Rp10.000" di `2071:89728` dan `2630:27642` dipertahankan apa adanya (gak ada bukti itu salah), padahal sumbernya gak jelas terikat ke item mana. Kalau ternyata baris itu harusnya ikut hilang/beda nilai, perlu di-review ulang.

## Catatan QA

Cek berikut pas ada perubahan di komponen `SummaryRow`/`OrderSummary`/`OrderSummaryFlat`, atau pas implementasi kode-nya:

- [ ] Urutan baris selalu: Subtotal → Potongan harga → Diskon transaksi → Pajak → Pembulatan → Total. Gak boleh reorder walau salah satu baris kosong.
- [ ] Baris `Potongan harga`/`Diskon transaksi`/`Pembulatan` hidden kalau nilainya 0 — bukan tampil dengan "Rp0".
- [ ] Pajak dihitung dari DPP **net** (Subtotal − Potongan harga − Diskon transaksi), bukan dari Subtotal kotor. Kasus paling gampang salah: developer lupa kurangin `Diskon transaksi` dari DPP karena baris ini baru ditambah belakangan.
- [ ] Tanda `+`/`–` di depan nominal `Pembulatan` sesuai arah pembulatan (naik = `+`, turun = `–`).
- [ ] `Total` = DPP + Pajak + Pembulatan — verifikasi manual pakai kalkulator, jangan cuma percaya tampilan.
- [ ] **Drift pajak/layanan sudah resolved (lihat "Update 2026-07-30" di atas)** — semua baris pajak sekarang "Pajak (10%)", gak ada baris layanan terpisah.
- [ ] **Instance override adalah sumber drift paling umum** — pas nambah instance baru dari `OrderSummary`/`OrderSummaryFlat`, JANGAN cuma copy instance lama yang keliatan mirip. Cek ulang label row-discount ("Diskon transaksi" bukan "Potongan harga" duplikat) dan hitung ulang Pajak/Total manual sebelum commit.
- [ ] **Subtotal harus cocok sama daftar item yang beneran tampil di kartu di atasnya** (jumlahkan harga tiap `LineRow`/`FreeChildRow`, item gratis dihitung di harga aslinya sebelum diskon). Ini beda dari cek "Total = DPP+Pajak+Pembulatan" — instance bisa lolos cek itu (angkanya konsisten satu sama lain) tapi tetap salah kalau Subtotal-nya sendiri gak nyambung ke item yang ada di kartu (lihat 5 instance yang dibenerin 2026-08-06 di atas).

## Yang di luar scope / belum diputuskan

- **Grouping DINE IN/TAKE AWAY — sudah digambar (2026-07-30)** di ketiga tahap: Keranjang, Konfirmasi Pesanan, dan Success (`Case: Pembayaran Berhasil — Pesanan Campuran Dine In + Take Away` di halaman Selesai & Struk). Item & angka konsisten sepanjang chain.
- **Spacing/visual treatment antar grup fulfillment** (garis putus-putus, jarak) belum ditentukan presisinya di Figma.
- **`PesananCard`** (`2057:54920`, dipakai di antara lain node `2532:5347`) **masih versi lama** — cuma render `Subtotal`, belum dapat baris Potongan harga/Diskon transaksi/Pajak/Pembulatan/Total sama sekali, dan belum dapat grouping DINE IN/TAKE AWAY. Perlu diputuskan: `PesananCard` di-upgrade nyontek pola `OrderSummary`/`OrderSummaryFlat` (reuse `SummaryRow`), atau memang dipakai buat konteks lain yang sengaja ringkas (preview mini, bukan breakdown final)?
- **Struktur data breakdown diskon** (field terpisah `itemDiscountTotal` vs `transactionDiscountTotal`, atau dihitung on-the-fly dari list item+voucher) belum diputuskan — perlu selarasin ke tim backend/kasir.
- Konsistensi pola grouping fulfillment ke tampilan **struk cetak fisik** dan **layar kasir/KDS** disebut sebagai requirement tapi belum dicek apakah layar-layar itu sudah/perlu diupdate juga.
