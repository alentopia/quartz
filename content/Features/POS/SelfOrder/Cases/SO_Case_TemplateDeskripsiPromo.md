# Self Order — Case: Template Kalimat Deskripsi Promo (Kartu `PromoCard`)

**Status:** Draft
**Tanggal:** 2026-08-13
**Fitur:** Self Order — kartu promo di PAGE-04V (Promo Hari Ini/Katalog) & PAGE-06V (Promo dari Keranjang), juga `DetailPromoSheet`.
**Referensi:** [[SO_PRD_MVP]] §6 Kategori Promo, PAGE-04V, PAGE-06V. Contoh visual: Figma node `3407:496`.

---

## Keputusan format

**Body kartu pakai 1 paragraf deskriptif, bukan bullet dot.** Sebelumnya kartu nampilin syarat sebagai list bullet terpisah (mis. "• Min. belanja Rp100.000" / "• Maks. potongan Rp30.000"). Diganti jadi **satu kalimat mengalir** di bawah judul, gaya paragraf biasa (font Inter Regular 12px, warna netral/muted, wrap natural — tanpa dot).

**Yang dijelaskan di paragraf ini: hasil + batas (cap), bukan syarat pemicu.** Paragraf menjelaskan *berapa besar diskonnya, kena ke apa, dan batas maksimalnya* — bukan *apa yang harus tamu lakukan buat dapetin promo itu* (syarat/pemicu, mis. "beli 2 Ayam Goreng" atau "min. belanja Rp100.000" sebagai syarat pembuka). Syarat pemicu **tidak disebut di kartu** — kalau tamu butuh tahu itu, itemnya sendiri yang jadi indikasi (di rail Menu / detail item), atau lewat `DetailPromoSheet`.

**Judul tetap terpisah dari paragraf.** Judul = nama hasil yang ramah/singkat (mis. "Gratis Es Jeruk", "Diskon 20%", "Diskon Rp5.000") — bahasa yang enak dibaca cepat. Paragraf di bawahnya = penjelasan presisi pakai bahasa baku "Diskon X pada Y."

**"Gratis" = "Diskon 100%".** Promo barang-gratis (dapat item lain gratis) **tidak punya template kalimat sendiri** — cukup pakai template diskon-produk dengan nilai 100%. Judul tetap boleh bilang "Gratis {nama item}" (lebih ramah), tapi paragraf di bawahnya tetap presisi: "Diskon 100% pada {nama item}. ...". Ini menyatukan kasus "gratis" dan "diskon produk" jadi satu aturan kalimat, gak perlu dua sistem beda.

---

## 4 Template

Placeholder: `{item}` = nama item pemicu diskon (untuk Promo Produk); `{nominal}` = angka rupiah; `{persen}` = angka persen; `{n}` = jumlah barang yang kena diskon per transaksi (biasanya 1); `{cap}` = batas maksimal potongan dalam rupiah.

| # | Kategori | Bentuk hasil | Template | Contoh |
|---|---|---|---|---|
| 1 | Promo Produk | Diskon **nominal** pada 1 item | `Diskon Rp{nominal} pada {item}. Maksimum {n} barang terdiskon dalam satuan pcs.` | "Diskon Rp5.000 pada Acai Bowl. Maksimum 1 barang terdiskon dalam satuan pcs." |
| 2 | Promo Produk | Diskon **persen** pada 1 item (termasuk kasus "gratis" = 100%) | `Diskon {persen}% pada {item}. Maksimum {n} barang terdiskon dalam satuan pcs.` | "Diskon 20% pada Ayam Goreng. Maksimum 1 barang terdiskon dalam satuan pcs." / "Diskon 100% pada Es Jeruk. Maksimum 1 barang terdiskon dalam satuan pcs." (= gratis) |
| 3 | Diskon Transaksi | Diskon **persen** dari subtotal | `Diskon {persen}% pada transaksi. Maksimum potongan Rp{cap}.` | "Diskon 20% pada transaksi. Maksimum potongan Rp30.000." |
| 4 | Diskon Transaksi | Diskon **nominal** tetap | `Diskon Rp{nominal} pada transaksi.` | "Diskon Rp15.000 pada transaksi." |

**Kenapa template #4 (transaksi-nominal) tanpa kalimat "maksimum"?** Potongan nominal tetap (mis. Rp15.000) sudah pasti nilainya — gak butuh batas atas karena nilainya gak bisa membesar sendiri (beda dari persen, yang hasilnya bisa membesar sesuai subtotal sehingga butuh dibatasi). Template #1 & #2 (produk) tetap pakai "maksimum {n} barang" walau nominal, karena itu bukan batas RUPIAH tapi batas KUANTITAS (berapa banyak unit item yang kena diskon dalam satu transaksi) — konsep beda dari cap di template #3.

**Kenapa gak nyebut syarat pemicu ("beli 2 X", "min. belanja Y")?** Keputusan sadar: kartu ini fokus jualan **manfaatnya**, bukan syaratnya. Kalau ke depan dibutuhkan nampilin syarat pemicu juga, itu perubahan terpisah dari case ini — lihat Pertanyaan Terbuka di bawah.

**Batas panjang: maksimal 100 kata.** Teks deskripsi (dan/atau nama promo) **tidak boleh lebih dari 100 kata** — ini batasan **authoring** (dicek saat promo dibuat/diedit di POS/Accurate Online, tempat promo dikonfigurasi), **bukan truncation runtime** di Self Order. Kartu tetap tidak memotong teks (`textTruncation: DISABLED`, lihat [[SO_PRD_MVP]] §9) — batas 100 kata ini yang mencegah teksnya kepanjangan dari sumbernya, supaya kartu gak jadi tinggi banget. Kalau ada promo existing yang deskripsinya lebih dari 100 kata (data lama), itu di luar kendali Self Order — perlu dibenerin dari sisi konfigurasi promo, bukan dari kartunya.

---

## Berlaku di mana

- PAGE-04V ("Promo Hari Ini" katalog, dari Menu) — semua kartu (Promo Produk & Diskon Transaksi campur 1 list) pakai format ini.
- PAGE-06V ("Promo" dari Keranjang) — kartu Diskon Transaksi juga pakai format paragraf yang sama, tombol Pakai/Dipakai tetap ada di kartu.
- `DetailPromoSheet` (sheet yang kebuka pas kartu ditekan) — section "Deskripsi" di sheet itu bisa pakai kalimat yang sama atau versi lebih panjang; tidak berubah dari [[SO_PRD_MVP]] existing.

## Contoh yang sudah dibangun di Figma

Frame `1315:36446` ("Promo Hari Ini — Katalog", PAGE-04V) — 6 kartu, urut alfabetis A→Z berdasar judul, nyakup ke-4 template:

| Judul | Deskripsi |
|---|---|
| Diskon 20% | Diskon 20% pada Ayam Goreng. Maksimum 1 barang terdiskon dalam satuan pcs. |
| Diskon 20% | Diskon 20% pada transaksi. Maksimum potongan Rp30.000. |
| Diskon Rp5.000 | Diskon Rp5.000 pada Acai Bowl. Maksimum 1 barang terdiskon dalam satuan pcs. |
| Gratis Es Jeruk | Diskon 100% pada Es Jeruk. Maksimum 1 barang terdiskon dalam satuan pcs. |
| Gratis Es Teh | Diskon 100% pada Es Teh. Maksimum 1 barang terdiskon dalam satuan pcs. |
| Potongan Rp15.000 | Diskon Rp15.000 pada transaksi. |

## Catatan tambahan (2026-08-14)

Konfirmasi instance lain, cocok Template #2 (persen/gratis, Promo Produk):

| Judul | Deskripsi |
|---|---|
| Diskon 100% / Gratis Ayam Goreng Kremes | Diskon 100% pada Ayam Goreng Kremes. Maksimum 1 barang terdiskon dalam satuan pcs. |

## Pertanyaan terbuka

| No | Pertanyaan | Menunggu |
|---|---|---|
| 1 | Syarat pemicu (mis. "beli 2 Ayam Goreng", "min. belanja Rp100.000") — beneran gak perlu ditampilkan di kartu sama sekali, atau cukup di `DetailPromoSheet` doang? Belum ada instruksi eksplisit soal ini, disimpulkan dari contoh referensi yang memang gak nyebut syarat. | Konfirmasi PM |
| 2 | Kalau Promo Produk kena >1 item pemicu berbeda (mis. beli A atau B, dapat diskon C) — apakah template #1/#2 masih cukup, atau butuh varian kalimat baru? | Konfirmasi PM |
| 4 | Section "Periode Promosi" — kalau admin nambah **>1 rentang jam aktif** per hari ("+ Tambah Jam Aktif" di AOL, mis. 00.00-11.00 dan 13.00-23.59), gimana nampilinnya? Contoh yang dibangun cuma 1 rentang. | Konfirmasi PM |

## Format teks "hari" di Periode Promosi (jawaban Pertanyaan #3, 2026-08-13)

| Kondisi | Format | Contoh |
|---|---|---|
| Semua 7 hari aktif | "Setiap hari" | "Setiap hari" |
| 1 hari doang aktif | "Hari {hari}" | "Hari Rabu" |
| ≥2 hari aktif, **berurutan** (contiguous) | "Hari {hariAwal} Sampai {hariAkhir}" | "Hari Senin Sampai Sabtu" (6 hari, cuma Minggu kosong) |
| ≥2 hari aktif, **gak berurutan** (mis. Senin+Rabu+Jumat) | "Hari {list disingkat, koma}" | "Hari Sen, Rab, Jum" *(belum ada contoh dibangun di Figma — masih asumsi, bukan dari instruksi eksplisit)* |

**Layout note:** baris tanggal + baris hari sejajar di 1 baris **kalau muat**; kalau teks hari kepanjangan (mis. "Hari Senin Sampai Sabtu"), otomatis wrap ke baris baru di bawah tanggal (`layoutWrap: WRAP` di Figma) — bukan kepotong/clip. Sudah dites di Figma node `1315:36503` (tetap 1 baris, "Setiap hari") dan `3360:397` (wrap 2 baris, "Hari Senin Sampai Sabtu").
