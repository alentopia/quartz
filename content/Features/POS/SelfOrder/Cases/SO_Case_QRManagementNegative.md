# Self Order — Negative Case: QR Management (Setup APOS)

**Status:** Draft
**Tanggal:** 2026-07-29 (format dirapikan untuk QA; isi keputusan produk per 2026-07-28)
**Fitur:** Self Order — sisi **Setup POS** di aplikasi Accurate POS (APOS). Bukan aplikasi Self Order pelanggan, bukan pula Setup Accurate Online (AOL).
**Prefix ID kasus:** `SO-QRN`
**Pembaca:** QA (eksekusi pengujian) · Developer (implementasi) · PM (keputusan produk)
**Referensi:** [[SO_PRD_MVP]], [[SO_TestScenario_MVP]], [[SO_Case_BagikanStrukNegative]]
**Format dokumen ini mengikuti:** [[Riset_Workflow_Handoff_UIUX_QA_DEV]] (ID spine, struktur 5 blok per kasus, link Figma per kasus)
**Desain:** [Buka canvas MVP — Close Bill · QR Statis · Table Management di Figma](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2) (file `mAZuRze02w906M6u2EwVWh`). Di badan dokumen layar selalu disebut **dengan namanya**; tiap kasus punya baris **Frame Figma** yang langsung membuka frame-nya, dan seluruh nomor node dikumpulkan di [[#Lampiran B — Peta node Figma|Lampiran B]].

---

## Cara membaca dokumen ini

Setiap kasus ditulis dengan lima bagian yang selalu sama:

| Bagian | Isi | Dipakai oleh |
|---|---|---|
| **Judul** | Ringkasan masalah dalam satu baris: layar + aksi + gejala | semua |
| **Prasyarat** | Kondisi, data, dan hak akses yang harus disiapkan sebelum langkah dijalankan | QA |
| **Langkah reproduksi** | Langkah operasional bernomor, dari buka aplikasi sampai gejalanya muncul | QA |
| **Hasil yang diharapkan** | Perilaku benar sesuai spec: copy persis, wadah pesan, perilaku tombol, state setelahnya | QA + DEV |
| **Hasil aktual** | Kondisi terakhir yang diketahui saat dokumen ditulis | QA + PM |

**Tentang "Hasil aktual".** Dokumen ini spec desain, bukan laporan bug — jadi kolom ini berisi **kondisi terakhir yang diketahui per 2026-07-28**: apakah state-nya sudah digambar di Figma, belum ada sama sekali, atau ada selisih dengan spec. Saat build tersedia, QA menimpa isinya dengan hasil pengujian nyata: tulis **"Sesuai"** bila cocok dengan Hasil yang Diharapkan, atau tulis gejala sebenarnya bila tidak.

**Cara membuka desainnya.** Tiap kasus punya baris **Frame Figma** tepat di bawah judulnya — klik, langsung terbuka di frame yang benar (butuh akses ke file Figma-nya). Kalau linknya tidak ada, artinya state itu memang belum digambar; alasannya ada di bagian "Hasil aktual".

**Tentang nama layar.** Tidak ada rujukan berupa nomor node telanjang seperti `1629:60773` di badan dokumen — nomor seperti itu tidak bisa dibaca siapa pun selain yang sedang membuka Figma. Setiap layar dirujuk dengan namanya (mis. **Popup Pilih Meja**), dan [[#Lampiran A — Kamus layar|Lampiran A]] menjelaskan layar itu apa serta cara membukanya di aplikasi. Nomor node ada di [[#Lampiran B — Peta node Figma|Lampiran B]] untuk desainer atau DEV yang perlu membuka frame-nya.

### Daftar kasus

| ID                                                                                                                              | Judul singkat                   | Wadah pesan                   | Status desain                   |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- | ----------------------------- | ------------------------------- |
| [[#SO-QRN-A1 — Popup Pilih Meja: tombol Generate QR tetap tidak bisa ditekan saat belum ada meja dipilih\|SO-QRN-A1]]           | Generate tanpa memilih meja     | tidak ada (tombol disabled)   | sudah                           |
| [[#SO-QRN-A2 — Popup Pilih Meja: link Pilih Semua hilang (bukan disabled) saat semua meja di kategori sudah ber-QR\|SO-QRN-A2]] | Semua meja sudah ber-QR         | tidak ada (kontrol hilang)    | sebagian                        |
| [[#SO-QRN-A3 — Unduh PDF gagal karena QR-nya sudah dihapus device lain\|SO-QRN-A3]]              | Unduh PDF gagal                 | modal 2 tombol                | sudah                           |
| [[#SO-QRN-B1 — Generate: sebagian meja sudah didahului device lain, hitungan modal sukses ikut turun\|SO-QRN-B1]]               | Generate, sebagian bentrok      | modal sukses (hitungan turun) | sudah                           |
| [[#SO-QRN-B2 — Generate: semua meja sudah didahului device lain, muncul modal QR Meja Gagal Digenerate\|SO-QRN-B2]]             | Generate, semua bentrok         | modal 1 tombol                | sudah (4 varian)                |
| [[#SO-QRN-B3 — Hapus: sebagian meja sudah dihapus device lain, hitungan toast sukses ikut turun\|SO-QRN-B3]]                    | Hapus, sebagian bentrok         | toast sukses (hitungan turun) | sudah                           |
| [[#SO-QRN-B4 — Hapus: semua meja sudah dihapus device lain, muncul modal QR Meja Gagal Dihapus\|SO-QRN-B4]]                     | Hapus, semua bentrok            | modal 1 tombol                | sudah (4 varian)                |
| [[#SO-QRN-B5 — Cetak QR yang sudah dihapus device lain: cetak tidak jalan, muncul modal QR Meja Gagal Dicetak\|SO-QRN-B5]]      | Cetak QR yang sudah dihapus     | modal 1 tombol                | sudah (copy belum diverifikasi) |
| [[#SO-QRN-C — Hapus QR meja yang sedang dipakai order berjalan: sesi pelanggan tetap jalan sampai selesai\|SO-QRN-C]]                       | Hapus QR yang sedang dipakai    | tidak ada (jalan normal)      | belum                           |
| [[#SO-QRN-D — Cetak QR tanpa printer terhubung: muncul modal Gagal melakukan cetak otomatis\|SO-QRN-D]]                         | Printer tidak terhubung         | modal 2 tombol                | belum                           |
| [[#SO-QRN-E1 — QR Management tanpa hak akses: semua kontrol pengubah data hilang, bukan disabled\|SO-QRN-E1]]                   | Tanpa hak akses                 | tidak ada (kontrol hilang)    | sudah, ada drift judul          |
| [[#SO-QRN-E2 — Permission aktif tapi fitur global belum aktif di Setup AOL: tidak perlu pesan apa pun\|SO-QRN-E2]]              | Permission ON, fitur global OFF | tidak ada                     | non-issue                       |
| [[#SO-QRN-E3 — Permission dicabut saat halaman QR Management sedang terbuka: halaman hilang setelah sinkronisasi\|SO-QRN-E3]] | Permission dicabut saat halaman terbuka | tidak ada (halaman hilang) | **belum** |
| [[#SO-QRN-H1 — Hapus tipe penjualan yang sudah dimapping ke QR Self Order: diblokir modal error\|SO-QRN-H1]] | Hapus tipe penjualan yang dipakai QR Self Order | modal 1 tombol | sudah |
| [[#SO-QRN-I1 — QR QRIS dihapus dari Akun dan Pembayaran saat sedang dipakai di form QR Self Order: gagal simpan\|SO-QRN-I1]] | QR QRIS dihapus device lain saat form QR Self Order belum disimpan | modal 1 tombol | sudah |
| [[#SO-QRN-I2 — Tipe penjualan dihapus saat sedang dipakai di form QR Self Order: gagal simpan\|SO-QRN-I2]] | Tipe penjualan dihapus device lain saat form QR Self Order belum disimpan | modal 1 tombol | belum |

Dua bagian lain tidak berisi kasus uji, hanya keputusan yang perlu dibawa ke spec lain: [[#F. Setup AOL — di luar scope spec ini|F. Setup AOL]] dan [[#G. Ekspor Data ke Self Order — ditahan|G. Ekspor Data]].

---

## Latar belakang

Canvas MVP sudah punya happy path lengkap untuk QR Management di APOS: **Setting QR Management**, **Popup Pilih Meja**, **Cetak QR Satuan**, **Hapus QR Satuan**, **Hapus QR Banyak**, **QR Management Tanpa Hak Akses**, dan **Setup AOL Fitur Opsional**.

Negative case yang sudah ada sebelum spec ini baru satu: **Ekspor Data Gagal — Tidak Ada Internet**. Sisanya belum punya state kegagalan sama sekali.

Spec ini menutup celah tersebut untuk **sisi setup APOS saja**. Aplikasi Self Order pelanggan (menu, keranjang, konfirmasi, bayar) sengaja tidak dibahas di sini.

## Keputusan produk

Dikonfirmasi bersama PM. Baris di tabel ini adalah sumber kebenaran kalau ada perbedaan tafsir saat implementasi atau pengujian.

| Topik | Keputusan |
|---|---|
| Wadah pesan kegagalan | **Modal, tanpa kecuali** — bentrok antar-device (generate/hapus/cetak), unduh PDF gagal, printer belum terhubung. Tidak ada kegagalan yang memakai toast. Toast hanya dipakai untuk pesan sukses. Ekspor Data belum ikut aturan ini karena alurnya sedang ditahan (bagian G). |
| Bentrok antar-device, sebagian berhasil | **Lolosin yang valid.** Yang bentrok di-skip tanpa pesan tambahan; hitungan pada pesan sukses menyesuaikan jumlah yang benar-benar diproses. Berlaku sama untuk Generate maupun Hapus. |
| Bentrok antar-device, tidak ada yang berhasil | **Modal error** yang menyebut meja mana yang gagal dan alasannya. Nama meja diurutkan alfanumerik; lebih dari 3 meja dipotong jadi "2 nama pertama + N meja lainnya". Tombol "Baik, Saya mengerti" memuat ulang data terbaru, bukan sekadar menutup modal. Berlaku sama untuk Generate maupun Hapus. |
| Koneksi putus di tengah proses generate | **Tidak dibuat.** Sudah dikonfirmasi dengan DEV bahwa kasus ini tidak mungkin terjadi. |
| Hapus QR yang sedang dipakai order aktif | **Jalan normal, dan sesi pelanggan tidak terputus.** Hapus hanya menutup pintu masuk untuk pesanan baru; pelanggan yang sudah scan tetap bisa menyelesaikan pesanannya. Tidak ada warning, tidak ada konfirmasi ekstra. |
| Hak akses tidak ada | Tombol "Pilih Meja & Generate QR" **hilang total**, bukan disabled. Daftar QR Aktif jadi read-only (kebab menu hilang). |
| Link "Pilih Semua" saat kategori habis | **Hilang**, bukan disabled — satu aturan untuk semua kondisi, termasuk saat seluruh area habis. Mengganti aturan lama di catatan Figma. |
| Modal sukses generate saat hanya 1 meja | **Tidak ada perubahan.** Tetap tombol "Selesai" · "Download PDF", copy body tetap sama. Tidak dibuat varian per jumlah meja. |
| Ekspor Data gagal | **Ditahan.** Alurnya kemungkinan berubah, belum bisa dipastikan — lihat bagian G. |
| Table Management di-OFF | QR Self Order ikut OFF; QR yang sudah ada **hangus permanen** — harus generate & cetak ulang. Rancangan modal konfirmasinya ditunda karena ada di Setup AOL (bagian F). |

## Prinsip

Lima aturan di bawah menjelaskan **kenapa** kasus-kasus berikut dirancang seperti itu. Kalau menemukan kasus baru yang belum tertulis di dokumen ini, pakai prinsip ini untuk memperkirakan perilaku yang benar sebelum bertanya.

- **Diam kalau tercapai, bicara kalau tidak.** Bentrok antar-device tidak dilaporkan selama sebagian pekerjaan berhasil — hasil akhirnya tetap benar. Baru kalau tidak ada yang berhasil sama sekali, user perlu diberi tahu supaya tidak salah mengira aksinya jalan.
- **Jangan gagalkan pekerjaan yang valid.** Generate dan Hapus memperlakukan tiap meja sebagai unit independen — gagal sebagian tidak membatalkan yang lain. Prinsip ini tidak otomatis berlaku untuk aksi yang datanya saling bergantung (mis. Ekspor Data).
- **Satu aturan untuk semua aksi.** Generate, Hapus, dan Cetak punya bentuk kegagalan yang sama persis saat bentrok antar-device, jadi polanya disamakan. Yang berbeda cuma wadah pesan sukses: modal untuk Generate (ada aksi lanjutan "Download PDF"), toast untuk Hapus (tidak ada aksi lanjutan).
- **Hilangkan, jangan matikan.** Kontrol yang tidak boleh atau tidak bisa dipakai dihapus dari tampilan, bukan ditampilkan abu-abu — supaya tidak memancing user mencoba lalu ditolak.

---

## A. Generate QR & unduh PDF

### SO-QRN-A1 — Popup Pilih Meja: tombol Generate QR tetap tidak bisa ditekan saat belum ada meja dipilih

**Frame Figma:** [Popup Pilih Meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1629-60773)

**Prasyarat**

- User login di APOS dan punya permission **"Mengelola QR Self Order"**.
- Fitur **Table Management** dan **QR Self Order** sudah aktif di Setup AOL.
- Minimal ada 1 meja terdaftar yang belum punya QR.

**Langkah reproduksi**

1. Buka halaman **Setting QR Management** (jalur menunya ada di [[#Lampiran A — Kamus layar|Lampiran A]]).
2. Tap tombol **"Pilih Meja & Generate QR"** — **Popup Pilih Meja** terbuka.
3. Jangan centang meja apa pun. Pastikan counter di header popup berbunyi **"0 Meja Terpilih"**.
4. Coba tap tombol **"Generate QR"** di header popup.

**Hasil yang diharapkan**

- Tombol **"Generate QR"** tampil dalam kondisi **disabled** (muted) selama counter masih "0 Meja Terpilih".
- Tap pada tombol tidak melakukan apa pun: tidak ada request ke server, tidak ada modal, tidak ada toast.
- Begitu satu meja dicentang, counter naik jadi "1 Meja Terpilih" dan tombol jadi aktif.

**Hasil aktual (per 2026-07-28)**

Sudah terpegang di desain existing **Popup Pilih Meja**. Dicatat di sini supaya masuk daftar regresi, bukan karena ada masalah.

---

### SO-QRN-A2 — Popup Pilih Meja: link Pilih Semua hilang (bukan disabled) saat semua meja di kategori sudah ber-QR

**Frame Figma:** [Popup Pilih Meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1629-60773) — aturan barunya **belum** tergambar di frame ini, lihat "Hasil aktual".

**Prasyarat**

- Sama seperti **SO-QRN-A1**.
- Data meja disiapkan supaya **satu kategori/area habis**: seluruh meja di kategori itu (mis. Area Dalam) sudah punya QR aktif, sementara kategori lain masih ada meja tanpa QR.

**Langkah reproduksi**

1. Buka halaman **Setting QR Management**.
2. Tap **"Pilih Meja & Generate QR"** — **Popup Pilih Meja** terbuka.
3. Perhatikan kategori yang sudah habis (semua mejanya ber-QR): cek kartu meja dan link **"Pilih Semua"** pada header kategori itu.
4. Bandingkan dengan kategori lain yang masih ada meja kosong.

**Hasil yang diharapkan**

- Meja yang sudah punya QR aktif tampil **disabled** di grid dan tidak bisa dicentang.
- Link **"Pilih Semua"** pada kategori yang sudah habis **hilang dari tampilan** — bukan tampil abu-abu/disabled.
- Link "Pilih Semua" pada kategori yang masih punya meja kosong tetap tampil, dan hanya mencentang meja yang masih bisa dipilih (yang disabled dilewati).

Satu aturan itu berlaku berjenjang tanpa aturan tambahan:

| Kondisi data | Tampilan yang benar |
|---|---|
| Sebagian meja di kategori masih kosong | "Pilih Semua" tampil normal, hanya mencakup meja yang masih bisa dipilih |
| Satu kategori habis (mis. Area Dalam) | "Pilih Semua" kategori itu hilang; kategori lain tetap tampil |
| Seluruh area habis (semua meja di semua kategori sudah ber-QR) | Semua link "Pilih Semua" hilang; semua kartu meja disabled; tombol "Generate QR" tetap disabled karena counter tidak pernah naik dari 0 |

**Variasi yang perlu diuji terpisah — seluruh area habis.** Siapkan data di mana semua meja di semua kategori sudah ber-QR, lalu ulangi langkah 1–3. Grid **tetap tampil penuh** dalam kondisi disabled semua (bukan empty state khusus), supaya user tetap bisa melihat meja apa saja yang ada.

**Hasil aktual (per 2026-07-28)**

**Sebagian sesuai.** Grid disabled untuk meja yang sudah ber-QR sudah tergambar. Aturan "Pilih Semua hilang" **belum tergambar** di **Popup Pilih Meja**, dan frame catatan pada popup itu masih menuliskan aturan lama: *"Semua meja di satu kategori meja sudah ber-QR → tombol Pilih Semua disabled"*. Aturan itu **diganti** oleh spec ini: hilang, bukan disabled. Catatan di Figma perlu diperbarui.

---

### SO-QRN-A3 — Unduh PDF gagal karena QR-nya sudah dihapus device lain

**Frame Figma:** [Case Negative : Gagal Mendownload PDF](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2362-40068)

> **Direvisi 2026-07-30.** Versi sebelumnya di dokumen ini menyebut penyebabnya koneksi/timeout dengan tombol "Coba Lagi". Itu salah. **Satu-satunya penyebab unduh PDF gagal adalah QR-nya sudah dihapus pengguna lain** — jadi tidak ada yang bisa diulang, dan modalnya satu tombol.

**Prasyarat**

- Dua sesi APOS di outlet yang sama: **kasir A** dan **kasir B**, keduanya punya permission **"Mengelola QR Self Order"**.
- Minimal 2 QR meja ada di **Daftar QR Aktif**, mis. AA - 01 dan AA - 02.
- Daftar di layar kasir B belum ter-update setelah kasir A bertindak (jangan refresh).

**Langkah reproduksi**

1. **Kasir B:** buka halaman **Setting QR Management**
2. **Kasir B:** tap link **"Pilih"** di header Daftar QR Aktif, lalu centang QR meja **AA - 01**
3. **Kasir A:** hapus QR meja **AA - 01** sampai sukses
4. **Kasir B:** tanpa refresh, tap tombol **"Unduh PDF"**
5. Tunggu modal kegagalan muncul
6. **Kasir B:** tap **"Baik, Saya mengerti"**
7. Perhatikan Daftar QR Aktif setelah modal tertutup

**Hasil yang diharapkan**

Muncul **modal** (bukan toast):

| Elemen | Isi |
|---|---|
| Judul | **"Gagal Mengunduh PDF"** |
| Deskripsi | **"PDF tidak dapat diunduh karena data QR sudah dihapus oleh pengguna lain. Data ini akan dihapus dari Daftar QR Aktif Anda."** |
| Aksi | satu tombol teks **"Baik, Saya mengerti"** |

- **Satu tombol, bukan dua.** Tidak ada yang bisa diulang — QR-nya memang sudah tidak ada. Sepola dengan modal bentrok **SO-QRN-B2**, **SO-QRN-B4**, dan **SO-QRN-B5**.
- **Tidak ada PDF yang terunduh**, bahkan sebagian.
- Menekan **"Baik, Saya mengerti"** menutup modal lalu **otomatis memuat ulang halaman**.
- Setelah refresh: QR yang sudah dihapus kasir A **hilang dari Daftar QR Aktif** kasir B.

**Kalau sebagian QR yang dicentang masih valid.** Belum diputuskan. Kasus generate dan hapus memakai aturan "lolosin yang valid" (bagian B), tapi PDF adalah satu file — belum jelas apakah PDF-nya tetap dibuat untuk QR yang masih ada, atau seluruh unduhan digagalkan. Lihat [[#Pertanyaan terbuka|Pertanyaan terbuka]] no. 10.

**Hasil aktual (2026-07-30)**

Sudah digambar di Figma pada section **Case Negative : Gagal Mendownload PDF**, dan **catatan di frame itu sudah benar** — justru dokumen ini yang tadinya salah, sekarang sudah disamakan.

---

## B. Bentrok antar-device (race condition)

Dua user APOS bisa mengelola QR pada meja yang sama secara bersamaan. Popup atau daftar yang sudah terbuka sejak sebelum device lain bertindak masih menampilkan meja itu sebagai bisa dipilih — bentrok baru ketahuan saat submit.

**Aturan tunggal yang berlaku untuk Generate, Hapus, maupun Cetak:**

| Hasil submit | Perilaku |
|---|---|
| Minimal 1 meja berhasil | **Sukses normal.** Meja yang bentrok di-skip diam-diam, tanpa toast atau peringatan tambahan. Hitungan pada pesan sukses menyesuaikan hasil sebenarnya. |
| Tidak ada satu pun berhasil | **Modal error**, menyebut meja mana yang gagal dan alasannya. |

Prinsipnya: selama sebagian pekerjaan tercapai, hasil akhirnya tetap benar (meja itu memang sudah punya / sudah tidak punya QR) — tidak perlu diperlakukan sebagai kesalahan. Baru kalau tidak ada yang tercapai sama sekali, user perlu diberi tahu supaya tidak mengira aksinya berhasil.

> **Implikasi teknis untuk DEV:** hitungan pada pesan sukses harus berasal dari **respons backend** (jumlah yang benar-benar diproses), bukan dari panjang array pilihan di sisi klien.

Cetak hanya punya kondisi kedua — aksinya selalu satu meja, jadi hasilnya selalu berhasil penuh atau gagal penuh (**SO-QRN-B5**).

**Cara menyiapkan pengujian B1–B5.** Butuh **dua perangkat atau sesi APOS** (sebut User A dan User B) yang login ke outlet yang sama dan sama-sama punya permission "Mengelola QR Self Order". Kunci reproduksinya: layar User B harus **sudah terbuka lebih dulu**, lalu User A bertindak, dan User B submit **tanpa menutup atau me-refresh** layarnya.

---

### SO-QRN-B1 — Generate: sebagian meja sudah didahului device lain, hitungan modal sukses ikut turun

**Frame Figma:** [Case Negative : Generate QR Sebagian Bentrok](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2392-22395)

**Prasyarat**

- Dua sesi APOS (User A dan User B) di outlet yang sama, keduanya punya permission "Mengelola QR Self Order".
- Ada 12 meja terdaftar (mis. AA - 01 … AA - 12), semuanya **belum** punya QR.

**Langkah reproduksi**

1. **User B:** buka **Setting QR Management** → tap "Pilih Meja & Generate QR" sehingga **Popup Pilih Meja** terbuka. **Diamkan, jangan ditutup dan jangan di-refresh.**
2. **User A:** buka **Setting QR Management** → generate QR untuk **meja AA - 12** saja, sampai sukses.
3. **User B:** di popup yang masih terbuka, meja AA - 12 masih tampil enabled. Centang **meja AA - 01 sampai AA - 12** (12 meja).
4. **User B:** tap **"Generate QR"**.

**Hasil yang diharapkan**

- Meja AA - 01 sampai AA - 11 ter-generate; meja AA - 12 **di-skip diam-diam** (tanpa pesan tambahan apa pun).
- Muncul **modal sukses existing** dengan hitungan yang menyesuaikan hasil sebenarnya:

  > **"11 QR meja berhasil dibuat"**

- Bukan "12" (jumlah yang dipilih), bukan pula "11 dari 12, 1 dilewati".
- Chip nama meja ikut menyesuaikan — hanya **11 chip** (AA - 01 … AA - 11). Meja yang bentrok tidak ikut ditampilkan.
- Copy body dan tombol **tidak berubah** dari modal sukses biasa: *"Semua QR tersimpan di Daftar QR Aktif. Cetak satuan dari sana, atau Download PDF untuk banyak sekaligus."* · tombol **"Selesai"** · **"Download PDF"**.

**Hasil aktual (per 2026-07-28)**

Sudah digambar di Figma pada section **Case Negative : Generate QR Sebagian Bentrok**.

---

### SO-QRN-B2 — Generate: semua meja sudah didahului device lain, muncul modal QR Meja Gagal Digenerate

**Frame Figma:** [Case Negative : Generate QR Gagal](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17902) — 4 varian jumlah: [1 meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17903) · [2 meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17907) · [3 meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17911) · [12 meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17915)

**Prasyarat**

- Dua sesi APOS (User A dan User B), outlet sama, keduanya punya permission "Mengelola QR Self Order".
- Ada meja terdaftar yang belum punya QR. Untuk menguji keempat varian jumlah, siapkan skenario dengan 1, 2, 3, dan 12 meja yang bentrok.

**Langkah reproduksi** (contoh varian 1 meja)

1. **User B:** buka **Setting QR Management** → tap "Pilih Meja & Generate QR" sehingga **Popup Pilih Meja** terbuka. **Diamkan.**
2. **User A:** generate QR untuk **meja AA - 01** sampai sukses.
3. **User B:** di popup yang masih terbuka, centang **hanya meja AA - 01**.
4. **User B:** tap **"Generate QR"**.

Untuk varian 2 / 3 / lebih dari 3 meja: pada langkah 2 User A meng-generate meja sebanyak itu (mis. AA - 01 … AA - 12), dan pada langkah 3 User B mencentang meja yang sama persis.

**Hasil yang diharapkan**

Muncul **modal error** di atas Popup Pilih Meja yang masih terbuka — **cermin persis dari SO-QRN-B4**: struktur, aturan urutan, aturan pemotongan, dan perilaku tombol sama, hanya kata kerjanya yang berbeda ("digenerate" menggantikan "dihapus").

| Elemen | Isi |
|---|---|
| Judul | **"QR Meja Gagal Digenerate"** |
| Aksi | satu tombol teks **"Baik, Saya mengerti"** |

Deskripsi menyesuaikan jumlah meja yang gagal:

| Jumlah meja gagal | Deskripsi yang benar |
|---|---|
| 1 | "QR Meja AA - 01 gagal digenerate karena sudah digenerate lebih dulu oleh pengguna lain." |
| 2 | "QR Meja AA - 01 dan AA - 02 gagal digenerate karena sudah digenerate lebih dulu oleh pengguna lain." |
| 3 | "QR Meja AA - 01, AA - 02 dan AA - 03 gagal digenerate karena sudah digenerate lebih dulu oleh pengguna lain." |
| lebih dari 3 | "QR Meja AA - 01, AA - 02 dan 10 meja lainnya gagal digenerate karena sudah digenerate lebih dulu oleh pengguna lain." |

Aturan teks yang wajib dicek QA:

- Nama meja diurutkan **alfanumerik ascending (A-Z, 0-9)** sebelum dirangkai — bukan urutan user mencentang.
- **Tidak ada koma sebelum "dan"** pada semua varian.
- Nama meja memakai spasi mengelilingi tanda hubung: **"AA - 01"**, bukan "AA-01".
- Lebih dari 3 meja: hanya **2 nama pertama**, sisanya dihitung ("dan N meja lainnya").

**State setelah menekan tombol.** Menekan **"Baik, Saya mengerti"** **memuat ulang data terbaru** — bukan sekadar menutup modal. Grid meja di popup di-refresh sehingga meja yang bentrok berpindah ke kondisi disabled.

**Hasil aktual (per 2026-07-28)**

Sudah digambar di Figma pada section **Case Negative : Generate QR Gagal**, lengkap 4 varian jumlah (1 / 2 / 3 / 12 meja). Latar frame-nya **Popup Pilih Meja**, bukan Daftar QR Aktif — generate dipicu dari popup itu, jadi modal errornya muncul di atas popup yang masih terbuka. Ini beda dari frame Hapus (SO-QRN-B4) yang latarnya Daftar QR Aktif.

---

### SO-QRN-B3 — Hapus: sebagian meja sudah dihapus device lain, hitungan toast sukses ikut turun

**Frame Figma:** [Case Negative : Hapus QR Sebagian Bentrok](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2393-22720)

**Prasyarat**

- Dua sesi APOS (User A dan User B), outlet sama, keduanya punya permission "Mengelola QR Self Order".
- Ada **12 QR meja aktif** di Daftar QR Aktif (AA - 01 … AA - 12), dan tidak ada QR lain selain 12 itu.

**Langkah reproduksi**

1. **User B:** buka **Setting QR Management**, tap **"Pilih"** di header Daftar QR Aktif untuk masuk mode seleksi. **Diamkan, jangan di-refresh.**
2. **User A:** hapus QR **meja AA - 12** sampai sukses.
3. **User B:** centang **meja AA - 01 sampai AA - 12** (12 entri, karena daftar di layarnya belum ter-update).
4. **User B:** tap **"Hapus"** dan konfirmasi penghapusan.

**Hasil yang diharapkan**

- Meja AA - 01 sampai AA - 11 terhapus; meja AA - 12 **di-skip diam-diam**.
- Muncul **toast** sukses (bukan modal) dengan hitungan yang menyesuaikan:

  > **"11 QR Statis Berhasil Dihapus"**

- Setelah aksi ini **Daftar QR Aktif jadi kosong** — 11 meja dihapus User B, meja ke-12 sudah dihapus User A lebih dulu. Layar menampilkan empty state **"Belum ada QR yang aktif"** plus toast, bukan daftar yang masih terisi.

Catatan pola: sukses Generate memakai **modal** (mengikuti modal sukses existing yang punya aksi lanjutan "Download PDF"), sukses Hapus memakai **toast** (tidak ada aksi lanjutan). Perbedaan wadah ini disengaja.

> **Istilah: "QR Statis", bukan "QR Meja".** Toast sukses existing di alur ini memakai "QR Statis" — "2 QR Statis Berhasil Dihapus", "12 QR Statis Berhasil Dihapus", dan toast cetak "1 QR Statis Berhasil Dicetak". Frame B3 mengikuti konvensi itu supaya seragam dengan tetangganya, walaupun draf spec sebelumnya menulis "QR Meja". **Masih perlu diputuskan** (lihat [[#Pertanyaan terbuka|Pertanyaan terbuka]] no. 2): pakai "QR Statis" di semua toast dan biarkan modal error tetap "QR Meja", atau seragamkan semuanya ke satu istilah.

**Hasil aktual (per 2026-07-28)**

Sudah digambar di Figma pada section **Case Negative : Hapus QR Sebagian Bentrok**.

---

### SO-QRN-B4 — Hapus: semua meja sudah dihapus device lain, muncul modal QR Meja Gagal Dihapus

**Frame Figma:** [Case Negative : Hapus Daftar QR Gagal](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2310-18506) — 4 varian jumlah: [1 meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2310-18507) · [2 meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2346-35894) · [3 meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2351-36868) · [12 meja](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2346-36381)

**Prasyarat**

- Dua sesi APOS (User A dan User B), outlet sama, keduanya punya permission "Mengelola QR Self Order".
- Keduanya membuka halaman **Setting QR Management** dengan data real-time yang sama, koneksi keduanya stabil.
- Ada QR meja aktif. Untuk menguji keempat varian jumlah, siapkan skenario dengan 1, 2, 3, dan 12 meja.

**Langkah reproduksi** (contoh varian 1 meja)

1. **User A dan User B:** buka **Setting QR Management**, tap **"Pilih"**, dan centang **meja AA - 01** yang sama persis di kedua perangkat.
2. **Kedua user** menekan **"Hapus"** pada waktu yang bersamaan, lalu konfirmasi.
3. Request yang masuk beberapa milidetik lebih awal (User A) yang diproses. Perhatikan layar **User B**.

Untuk varian 2 / 3 / lebih dari 3 meja: centang 2, 3, atau 12 meja yang sama di kedua perangkat, lalu ulangi.

Cara reproduksi alternatif yang lebih mudah dikendalikan: User B masuk mode seleksi dan mencentang meja, **diamkan**; User A menghapus meja yang sama sampai sukses; baru User B menekan "Hapus".

**Hasil yang diharapkan**

Muncul **modal error** pada layar User B, di atas Daftar QR Aktif:

| Elemen | Isi |
|---|---|
| Judul | **"QR Meja Gagal Dihapus"** |
| Aksi | satu tombol teks **"Baik, Saya mengerti"** — tanpa tombol batal, karena tidak ada pilihan lain yang masuk akal |

Deskripsi menyesuaikan jumlah meja yang gagal. Nama meja diurutkan **alfanumerik ascending (A-Z, 0-9)** sebelum dirangkai:

| Jumlah meja gagal | Bentuk | Deskripsi yang benar |
|---|---|---|
| 1 | sebut namanya | "QR Meja AA - 01 gagal dihapus karena sudah dihapus lebih dulu oleh pengguna lain." |
| 2 | dua nama, sambung "dan" | "QR Meja AA - 01 dan AA - 02 gagal dihapus karena sudah dihapus lebih dulu oleh pengguna lain." |
| 3 | tiga nama, koma + "dan" | "QR Meja AA - 01, AA - 02 dan AA - 03 gagal dihapus karena sudah dihapus lebih dulu oleh pengguna lain." |
| lebih dari 3 | dua nama pertama + sisa dihitung | "QR Meja AA - 01, AA - 02 dan 10 meja lainnya gagal dihapus karena sudah dihapus lebih dulu oleh pengguna lain." (contoh untuk 12 meja) |

**Tidak ada koma sebelum "dan"** — berlaku untuk semua varian.

**State setelah menekan tombol.** Saat user menekan **"Baik, Saya mengerti"**, sistem **otomatis memuat ulang data terbaru** dan tetap berada di halaman QR Management — meja yang sudah terhapus tidak lagi tampil di Daftar QR Aktif. Bukan sekadar menutup modal.

**Hasil aktual (per 2026-07-28)**

Sudah digambar di Figma pada section **Case Negative : Hapus Daftar QR Gagal**, lengkap 4 varian jumlah. Modal-modalnya sudah benar, tapi **frame catatan pada section itu belum ikut aturan koma**: teksnya masih menulis contoh *"QR Meja AA-01, AA-02, dan AA-03 …"* (pakai koma sebelum "dan", dan nama meja tanpa spasi). Yang perlu diperbaiki hanya teks catatannya.

---

### SO-QRN-B5 — Cetak QR yang sudah dihapus device lain: cetak tidak jalan, muncul modal QR Meja Gagal Dicetak

**Frame Figma:** [Case Negative : Cetak QR Gagal](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2377-41090)

**Prasyarat**

- Dua sesi APOS (User A dan User B), outlet sama, keduanya punya permission "Mengelola QR Self Order".
- Ada QR meja aktif **AA - 01** di Daftar QR Aktif.
- Printer sudah terhubung di perangkat User B, supaya yang diuji benar-benar kasus bentrok, bukan kasus printer (**SO-QRN-D**).

**Langkah reproduksi**

1. **User B:** buka **Setting QR Management** dan biarkan **Daftar QR Aktif** tampil. **Jangan di-refresh.**
2. **User A:** hapus QR **meja AA - 01** sampai sukses.
3. **User B:** entri AA - 01 masih tampil di daftar. Tap **kebab menu (⋮)** pada entri tersebut.
4. **User B:** pilih **"Cetak QR"**.

**Hasil yang diharapkan**

- Cetak **tidak dijalankan** — tidak ada yang keluar dari printer.
- Muncul **modal error**, sepola dengan SO-QRN-B2 dan SO-QRN-B4:

| Elemen | Isi |
|---|---|
| Judul | **"QR Meja Gagal Dicetak"** |
| Deskripsi | **"QR Meja AA - 01 gagal dicetak karena sudah dihapus lebih dulu oleh pengguna lain."** |
| Aksi | satu tombol teks **"Baik, Saya mengerti"** |

- Satu tombol, bukan dua — tidak ada yang bisa diulang, QR-nya memang sudah tidak ada.
- **Selalu satu nama meja.** Cetak QR hanya tersedia lewat kebab per-baris; mode seleksi massal di Daftar QR Aktif hanya menawarkan "Unduh PDF" dan "Hapus", tidak ada cetak massal. Jadi aturan pemotongan teks dan pengurutan alfanumerik di B2/B4 **tidak berlaku di sini**. Kalau nanti cetak massal ditambahkan, aturan itu harus ikut diterapkan.
- **State setelahnya:** menekan "Baik, Saya mengerti" memuat ulang data terbaru; entri yang sudah dihapus hilang dari Daftar QR Aktif.

**Hasil aktual (per 2026-07-28)**

Sudah digambar di Figma pada section **Case Negative : Cetak QR Gagal**. **Copy pada frame belum diverifikasi** terhadap copy di tabel atas — perlu dicek satu per satu sebelum dipakai sebagai acuan implementasi.

---

## C. Hapus QR yang sedang dipakai order aktif

### SO-QRN-C — Hapus QR meja yang sedang dipakai order berjalan: sesi pelanggan tetap jalan sampai selesai

**Frame Figma:** belum ada frame khusus — alurnya memakai [Hapus QR Satuan](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1345-16773) yang sudah ada, tanpa tambahan state.

> **Direvisi 2026-07-30.** Versi sebelumnya di dokumen ini menyebut sesi pelanggan **terputus**. Itu salah. Sesi yang sedang berjalan **tidak terputus** — pelanggan yang sudah scan tetap bisa menyelesaikan pesanannya. Catatan risiko yang menyertai versi lama ikut dihapus, karena risikonya memang tidak ada.

**Prasyarat**

- User APOS punya permission "Mengelola QR Self Order".
- Ada QR meja aktif **AA - 01**, dan ada **pelanggan yang sedang membuka sesi Self Order** dari QR meja itu (mis. sudah scan dan sedang memilih menu, keranjang belum dikirim).

**Langkah reproduksi**

1. Pastikan sesi pelanggan pada meja AA - 01 sedang berjalan (layar pelanggan masih di menu/keranjang).
2. Di APOS, buka **Setting QR Management**.
3. Hapus QR meja AA - 01 — lewat kebab menu (⋮) → "Hapus", atau lewat mode seleksi massal.
4. Konfirmasi penghapusan pada dialog konfirmasi hapus yang biasa.
5. Di layar pelanggan: **lanjutkan pesanan sampai selesai** — tambah item, konfirmasi, bayar.
6. Coba pindai ulang QR meja AA - 01 yang sudah dihapus (mis. dari perangkat lain).
7. Di APOS: generate dan cetak QR baru untuk meja AA - 01.

**Hasil yang diharapkan**

| Langkah | Yang harus terjadi |
|---|---|
| 3–4 | Penghapusan **diproses tanpa warning tambahan**, tanpa konfirmasi ekstra di luar konfirmasi hapus biasa. Tidak ada indikator "meja sedang dipakai". |
| 5 | **Sesi pelanggan tetap berjalan sampai selesai.** Tidak terputus, tidak keluar paksa, tidak ada pesan error. Pesanan bisa dikirim dan dibayar seperti biasa. |
| 6 | QR yang sudah dihapus **tidak bisa dipakai lagi untuk pesanan baru**. |
| 7 | Meja AA - 01 **bebas untuk di-generate dan dicetak QR baru**. |

**Arti "hapus" di sini.** Menghapus QR hanya menutup pintu masuk untuk pesanan **baru** — tidak membunuh sesi yang sudah masuk. Jadi tidak ada risiko yang perlu dimitigasi: operator boleh menghapus QR kapan saja tanpa memeriksa dulu apakah mejanya sedang dipakai.

**Hasil aktual (2026-07-30)**

**Belum ada frame di Figma**, dan memang tidak butuh state baru — alurnya memakai konfirmasi hapus yang sudah ada. Perilaku ini sudah tertulis di catatan canvas pada section **Menghapus Daftar QR yang Aktif (Satuan)**, dan **catatan itu yang benar** — dokumen ini yang tadinya salah.

---

## D. Cetak QR — printer tidak terhubung

### SO-QRN-D — Cetak QR tanpa printer terhubung: muncul modal Gagal melakukan cetak otomatis

**Frame Figma:** **belum digambar.** Titik masuknya ada di [Cetak QR Satuan](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1624-43559); copy modalnya sudah final di bawah.

**Prasyarat**

- User APOS punya permission "Mengelola QR Self Order".
- Ada minimal 1 QR meja aktif di Daftar QR Aktif.
- **Tidak ada printer yang terhubung** ke perangkat (belum di-setup, atau printer dimatikan/diputus).

**Langkah reproduksi**

1. Buka **Setting QR Management**.
2. Pada salah satu entri di **Daftar QR Aktif**, tap **kebab menu (⋮)**.
3. Pilih **"Cetak QR"**.

**Hasil yang diharapkan**

Muncul **modal** (bukan toast) — user perlu melakukan tindakan (menghubungkan printer) sebelum bisa lanjut, dan toast yang hilang sendiri tidak cukup untuk itu:

| Elemen | Isi |
|---|---|
| Judul | **"Gagal melakukan cetak otomatis"** |
| Deskripsi | **"Belum ada printer terhubung ke perangkat Anda. Silahkan hubungkan printer untuk dapat mencetak."** |
| Tombol | **"Lewati"** (sekunder) · **"Hubungkan printer"** (primer) |

Perilaku tombol:

| Tombol | Perilaku |
|---|---|
| Lewati | Modal tertutup, kembali ke halaman QR Management. QR tetap ada di Daftar QR Aktif. |
| Hubungkan printer | Membawa user ke halaman **Pengaturan › Printer**. |

**Ini satu-satunya modal kegagalan dengan dua tombol.** Semua modal gagal lain di dokumen ini (**SO-QRN-A3**, **B2**, **B4**, **B5**) hanya punya satu tombol, karena penyebabnya selalu "orang lain sudah mendahului" — tidak ada yang bisa diulang. Di sini beda: printer bisa dihubungkan, jadi ada jalan keluar yang masuk akal. Label sekundernya **"Lewati"**, bukan "Tutup", karena QR-nya sudah ada dan user memang boleh lanjut tanpa mencetak.

> **Catatan ejaan (belum diputuskan).** Copy memakai **"Silahkan"**; bentuk baku KBBI adalah **"Silakan"** (tanpa h). Perlu dikonfirmasi apakah mengikuti bentuk baku atau menyesuaikan konvensi copy yang sudah dipakai di produk — lihat [[#Pertanyaan terbuka|Pertanyaan terbuka]] no. 3.

**Hasil aktual (per 2026-07-28)**

**Belum ada frame di Figma.** Copy sudah final di spec ini, frame-nya belum masuk canvas.

---

## E. Hak akses

### SO-QRN-E1 — QR Management tanpa hak akses: semua kontrol pengubah data hilang, bukan disabled

**Frame Figma:** [QR Management Tanpa Hak Akses](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1998-75370) · sumber permission-nya di [Peran Karyawan POS — grup QR Self Order](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1604-35570)

Permission yang dimaksud: **"Mengelola QR Self Order"** di Peran Karyawan POS, grup **QR Self Order**.

**Prasyarat**

- Ada karyawan dengan Peran Karyawan POS yang permission **"Mengelola QR Self Order"** **tidak dicentang**.
- Fitur Table Management dan QR Self Order aktif di Setup AOL.
- Sudah ada beberapa QR meja aktif, supaya Daftar QR Aktif tidak kosong.

**Langkah reproduksi**

1. Login APOS memakai karyawan tanpa permission tersebut.
2. Buka halaman **QR Management**.
3. Periksa satu per satu elemen pada tabel di bawah.
4. Bandingkan dengan hasil login memakai karyawan yang punya permission tersebut.

**Hasil yang diharapkan**

Halaman **tetap bisa dibuka**, tapi seluruh kontrol yang mengubah data dihilangkan:

| Elemen | Punya hak akses | Tanpa hak akses |
|---|---|---|
| Blok "Generate QR untuk meja terpilih" (judul + deskripsi + tombol "Pilih Meja & Generate QR") | tampil | **hilang total** |
| Blok "Ekspor data ke Self Order" | tampil | tampil, tetap bisa dipakai |
| Daftar QR Aktif | tampil, tiap baris punya kebab menu (⋮) untuk cetak/hapus | tampil **read-only**, kebab menu (⋮) **hilang** |
| Link "Pilih" (mode seleksi massal di header Daftar QR Aktif) | tampil | **hilang** |
| Kolom pencarian "Cari daftar QR" | tampil | tampil — membaca daftar tetap boleh |

- Kontrol **dihilangkan, bukan di-disable** — supaya user tidak mencoba lalu ditolak.
- Modal kegagalan di bagian A–D **tidak berlaku** di state ini, karena aksinya memang tidak bisa dipicu.
- **Judul halaman tetap "QR Management"**, sama dengan versi yang punya hak akses. Hak akses tidak boleh mengubah nama fitur.

> **Titik rawan untuk DEV.** Penyembunyian ini wajib dicek di **sisi server** juga, bukan hanya di UI. Menghilangkan tombol tidak menghalangi request yang dikirim langsung ke endpoint. QA disarankan menguji ini di level API, bukan hanya di layar.

**Hasil aktual (per 2026-07-28)**

Sudah digambar di Figma pada section **QR Management Tanpa Hak Akses**, tapi ada **drift penamaan**: judul halaman pada frame tanpa hak akses tertulis **"Self QR Management"**, sedangkan versi dengan hak akses memakai **"QR Management"**. Salah satu harus disamakan — lihat [[#Pertanyaan terbuka|Pertanyaan terbuka]] no. 4. Label ekspornya sendiri sudah konsisten, dua-duanya "Ekspor data ke Self Order".

---

### SO-QRN-E2 — Permission aktif tapi fitur global belum aktif di Setup AOL: tidak perlu pesan apa pun

**Frame Figma:** tidak ada dan tidak perlu ada. Toggle sumbernya di [Setup AOL Fitur Opsional](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-70739).

**Prasyarat**

- Karyawan punya permission "Mengelola QR Self Order" di Peran Karyawan POS.
- Fitur QR Self Order **belum diaktifkan** di Setup AOL.

**Hasil yang diharapkan**

**Non-issue, tidak perlu pesan apa pun.** Sinkronisasi dari AOL harus dilakukan lebih dulu; kondisi ini bersifat sementara dan tidak perlu ditangani sebagai state khusus. Tidak ada modal, tidak ada toast, tidak ada empty state khusus yang perlu diuji.

**Hasil aktual (per 2026-07-28)**

Tidak ada yang perlu digambar maupun diuji. Dicatat supaya tidak dilaporkan sebagai celah desain.

---

### SO-QRN-E3 — Permission dicabut saat halaman QR Management sedang terbuka: halaman hilang setelah sinkronisasi

**Frame Figma:** **belum digambar** — perilakunya baru diputuskan 2026-07-30, frame-nya belum ada.

**Prasyarat**

- Karyawan (mis. "waiter X") **punya** permission **"Mengelola QR Self Order"** dan sudah login di APOS.
- Ada admin/user lain yang bisa mengubah Peran Karyawan POS untuk mencabut permission itu.
- Sudah ada beberapa QR meja aktif supaya halaman tidak kosong.

**Langkah reproduksi**

1. Login APOS sebagai waiter X, buka halaman **QR Management**, dan **biarkan halaman itu terbuka**
2. Di sisi lain (admin), **cabut** permission "Mengelola QR Self Order" dari peran waiter X
3. Di perangkat waiter X, **jangan tekan sinkronisasi dulu** — diamkan beberapa saat, perhatikan halaman yang masih terbuka
4. **Tekan tombol sinkronisasi** data terbaru, tunggu sampai prosesnya selesai
5. Perhatikan halaman QR Management dan daftar menu Pengaturan

**Hasil yang diharapkan**

| Langkah | Yang harus terjadi |
|---|---|
| 3 (sebelum sinkronisasi ditekan) | Halaman QR Management **masih tampil apa adanya**, tanpa batas waktu. Pencabutan permission belum terasa di UI — tidak ada halaman yang tiba-tiba tertutup, tidak ada pesan mendadak. |
| 4–5 (setelah sinkronisasi selesai) | Halaman **ter-refresh**, dan setelah refresh itu **halaman QR Management hilang** — menunya tidak lagi tersedia di Pengaturan, dan halamannya tidak bisa dibuka lagi. **Hilang senyap: tidak ada toast, modal, atau pemberitahuan apa pun** tentang perubahan hak akses. |

**Sinkronisasi adalah aksi manual.** Pencabutan permission **tidak** langsung mendorong perubahan ke perangkat waiter X. Selama tombol sinkronisasi belum ditekan, halamannya tetap terbuka — bisa semenit, bisa sejam. Hilangnya halaman terjadi karena **refresh setelah sinkronisasi selesai**, bukan karena push realtime dari server.

**Tanpa pemberitahuan, dan itu disengaja.** Tidak ada toast maupun modal yang menjelaskan kenapa halamannya hilang. Alasannya: user sendiri yang menekan sinkronisasi, jadi hilangnya menu terjadi tepat setelah aksinya sendiri — bukan kejadian acak yang perlu dijelaskan. Menambah pemberitahuan di sini berarti memberi tahu karyawan bahwa hak aksesnya dicabut, dan itu urusan atasannya, bukan urusan aplikasi.

Konsekuensi untuk QA: kasus ini **tidak bisa** diuji dengan cara menunggu. Kalau halaman hilang sendiri tanpa sinkronisasi ditekan, itu justru temuan yang perlu dilaporkan — perilakunya bukan seperti itu.

**Titik rawan untuk DEV.** Di antara langkah 2 dan 4 ada jeda: permission sudah dicabut di data, tapi UI waiter X belum tahu. Selama jeda itu, aksi apa pun yang dia kirim (generate, hapus, cetak) **wajib ditolak server** — sama seperti `SO-QRN-E1`, penyembunyian di UI tidak boleh jadi satu-satunya penjaga. Jadi kasus ini punya dua sisi: UI hilang setelah sinkronisasi, dan server menolak lebih awal dari itu.

**Hasil aktual (2026-07-30)**

Perilaku ini **baru diputuskan** (2026-07-30) dan belum tergambar. Yang sudah pasti: sinkronisasi manual → refresh → halaman hilang, tanpa pemberitahuan apa pun. Sisa satu yang belum ditentukan — pertanyaan terbuka no. 7: **ke mana user diarahkan** setelah halamannya hilang.

---

## F. Setup AOL — di luar scope spec ini

**Status: di luar scope spec ini, tapi sudah ada dokumennya sendiri** — lihat [[SO_Case_SetupAOLFiturOpsional]] (aktivasi QR Self Order, dependency ke Table Management, dan aksi destruktif saat Table Management dimatikan sebagai `SO-SET-B2`).

Fokus dokumen ini tetap Setup POS. Setup AOL adalah aplikasi lain dengan design system sendiri (terang/biru, bukan POS gelap) dan dikerjakan terpisah.

Satu fakta yang sudah diputuskan dan perlu dibawa ke spec Setup AOL nanti:

**QR Self Order adalah child feature dari Table Management.** Catatan pada toggle di layar **Setup AOL Fitur Opsional** berbunyi: *"Hanya bisa diaktifkan jika menggunakan Table Management"*. Saat Table Management di-OFF, toggle QR Self Order ikut OFF dan **QR yang sudah ter-generate hangus permanen** — menyalakan Table Management lagi tidak menghidupkan QR lama; semua meja harus di-generate, diunduh, dan dicetak ulang.

Konsekuensinya: mematikan Table Management adalah **aksi destruktif** dan butuh modal konfirmasi yang menyebut jumlah QR aktif yang akan hangus. Rancangan modalnya tidak dibuat di sini karena harus mengikuti konvensi modal AOL, bukan pola dialog mobile yang dipakai bagian A–D.

---

## G. Ekspor Data ke Self Order — ditahan

**Status: ditahan.** Alur Ekspor Data kemungkinan berubah, bentuk akhirnya belum bisa dipastikan. Bagian ini **tidak diputuskan sekarang dan tidak dijadikan acuan implementasi**.

Yang sudah ada di canvas: section **Ekspor Data Gagal — Tidak Ada Internet** menangani kasus tanpa internet dengan toast merah *"Gagal Melakukan Export — Tidak Ada Internet"*. Dibiarkan apa adanya sampai arah barunya jelas.

Dua hal yang perlu diputuskan ulang begitu alur barunya final:

1. **Gagal sebagian.** Pertimbangan awal: gagalkan semuanya (all-or-nothing), karena ekspor adalah satu paket data yang saling bergantung — menu tanpa harga yang sesuai berarti pelanggan melihat data yang salah, lebih berbahaya daripada tidak ter-update sama sekali. Beda dari bulk generate/hapus yang tiap mejanya independen. Timestamp "Terakhir disinkronkan" tidak berubah kalau ekspor gagal.
2. **Wadah pesan.** Setelah unduh PDF gagal dipindah ke modal (SO-QRN-A3), Ekspor Data jadi satu-satunya kegagalan aksi eksplisit yang masih memakai toast. Perlu diseragamkan atau diberi alasan eksplisit untuk tetap berbeda.

---

## H. Hapus tipe penjualan yang sudah dimapping ke QR Self Order

**Beda layar dari bagian A–G.** Kasus ini terjadi di **Setup AOL, menu Tipe Penjualan** — bukan di Setting QR Management. Dependensinya lintas fitur: tipe penjualan tidak bisa dihapus selama masih dipakai QR Self Order, meskipun aksi hapusnya dipicu dari layar Salestype.

### SO-QRN-H1 — Hapus tipe penjualan yang sudah dimapping ke QR Self Order: diblokir modal error

**Frame Figma:** [Case Negative : Modal Error Jika Sudah Ada Tipe Penjualan Yang Dimapping Ke QR Self Order](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2777-30220)

**Prasyarat**

- Ada tipe penjualan yang sudah **dimapping ke QR Self Order** pada suatu outlet (pengaturan mapping-nya di Setup AOL).
- User berada di **menu Tipe Penjualan** (Setup AOL) dan punya akses untuk menghapus tipe penjualan.

**Langkah reproduksi**

1. Buka **menu Tipe Penjualan** di Setup AOL.
2. Pilih tipe penjualan yang statusnya sudah dimapping ke QR Self Order.
3. Tekan tombol **"Hapus"**.

**Hasil yang diharapkan**

Penghapusan **diblokir**. Muncul **modal error** (bukan toast) — sepola modal blocking lain di fitur Self Order: satu tombol, tanpa opsi lanjut paksa.

| Elemen | Isi |
|---|---|
| Judul | **"Terjadi Permasalahan pada Pemprosesan"** |
| Body (baris 1) | "Silahkan perbaiki permasalahan berikut ini:" |
| Body (baris 2, merah) | **"Sudah ada QR Self Order di outlet "[Nama Outlet]" yang dimapping ke tipe penjualan "[Nama Tipe]". Silakan lepas tautannya dulu."** |
| Aksi | satu tombol **"OK"** |

- **Tidak ada tombol batal atau opsi hapus paksa** — user wajib melepas tautan QR Self Order di outlet tersebut dulu (lewat Setting QR Self Order) sebelum tipe penjualan ini bisa dihapus.
- **Beda dari pola FDS** ("Sudah ada FDS di '[Outlet]' yang dimapping ke tipe penjualan '[Y]'. **Silakan pilih Outlet lain**"): di sini **tidak ada** opsi "pilih tipe lain" atau "pilih outlet lain", karena ini alur **hapus**, bukan alur mapping/assign. Kalimat pertama ("sudah ada X yang dimapping ke Y") dipertahankan supaya konsisten satu produk; kalimat penutupnya diganti jadi instruksi keluar ("lepas tautannya dulu"), bukan instruksi pilih alternatif.
- Ejaan **"Silahkan"** dipakai apa adanya di frame — belum diseragamkan ke "Silakan" baku KBBI, sama seperti catatan ejaan di `SO-QRN-D`.

**Hasil aktual (2026-07-31)**

Sudah digambar di Figma pada section **Case Negative : Modal Error Jika Sudah Ada Tipe Penjualan Yang Dimapping Ke QR Self Order**, copy modal sudah final dan sudah cocok dengan spec ini. Catatan Pre-condition/Steps/Expected Result ditambahkan di sebelah frame modal (node `2780:23684`) mengikuti format catatan yang sama dipakai bagian B.

---

## I. Konflik antar-fitur — entitas dihapus saat sedang dipakai di form QR Self Order

**Beda arah dari bagian H.** Bagian H: hapus tipe penjualan diblokir karena **sudah** dipakai (dimapping dan tersimpan) QR Self Order. Bagian I: entitas lain dihapus oleh satu user, saat user lain sedang menyusun form **Setting QR Self Order** yang merujuknya tapi **belum menyimpan** — jadi belum ada mapping tersimpan yang bisa memblokir penghapusan itu. Ini bentrok antar-device seperti bagian B, tapi lintas fitur — sumber datanya beda dari yang menyimpannya (Setting QR Self Order). Dua entitas yang bisa kena pola ini: **QR QRIS** (menu Akun dan Pembayaran) di **SO-QRN-I1**, dan **tipe penjualan itu sendiri** (menu Tipe Penjualan, Setup AOL) di **SO-QRN-I2**.

### SO-QRN-I1 — QR QRIS dihapus dari Akun dan Pembayaran saat sedang dipakai di form QR Self Order: gagal simpan

**Frame Figma:** [Case Negative : Modal Error Jika Kita Menggunakan QR QRIS yang sudah dihapus](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2788-38312)

**Prasyarat**

- **User A** punya akses ke menu **Akun dan Pembayaran** (pengaturan QR QRIS).
- **User B** sedang membuka **Setting QR Self Order** pada tipe penjualan tertentu (mis. "Dine In"), outlet sama dengan User A.
- Ada satu QR QRIS yang direferensikan di kedua tempat.

**Langkah reproduksi**

1. **User B:** buka **Setting QR Self Order** pada tipe penjualan **"Dine In"**, input/pilih **QR QRIS X** pada field terkait. **Diamkan, jangan tekan Simpan.**
2. **User A:** buka menu **Akun dan Pembayaran**, hapus **QR QRIS X** sampai sukses.
3. **User B:** tanpa refresh, tekan tombol **"Simpan"** pada form Setting QR Self Order-nya.

**Hasil yang diharapkan**

- Penyimpanan User B **gagal** — QR QRIS yang dirujuk sudah tidak ada, bukan disimpan diam-diam dengan data basi.
- Muncul **modal** (bukan toast):

| Elemen | Isi |
|---|---|
| Judul | **"Terjadi Permasalahan pada Pemprosesan"** |
| Body (baris 1) | "Silahkan perbaiki permasalahan berikut ini:" |
| Body (baris 2, merah) | **"Data ini sudah sempat diubah oleh pengguna lain. Batalkan dan ulangi pengubahan anda"** |
| Aksi | satu tombol **"OK"** |

- **Satu tombol, bukan dua** — sepola modal blocking lain di fitur ini: tidak ada yang bisa "disimpan ulang" langsung, karena QR QRIS-nya memang sudah tidak valid.
- **State setelah "OK":** form dimuat ulang dengan data terbaru; User B harus mengulang pemilihan QR QRIS dari data yang masih ada — QR yang sudah dihapus tidak lagi muncul sebagai opsi.
- **Pesan generik, bukan spesifik-QRIS.** Beda dari modal bagian B/H yang menyebut nama entitas persis (nama meja, nama tipe penjualan), modal ini memakai copy generik "data ini sudah sempat diubah" — konsisten dengan pola modal error pemrosesan yang dipakai lintas form di AOL.

**Hasil aktual (2026-07-31)**

Sudah digambar di Figma pada section **Case Negative : Modal Error Jika Kita Menggunakan QR QRIS yang sudah dihapus**, copy modal sudah final. Catatan Pre-condition/Steps/Expected Result ditambahkan di sebelah frame layar "Dine In" (node `2793:24324`) mengikuti format catatan yang sama dipakai bagian B dan H.

---

### SO-QRN-I2 — Tipe penjualan dihapus saat sedang dipakai di form QR Self Order: gagal simpan

**Frame Figma:** belum digambar — pola modalnya identik dengan [Case Negative : Modal Error Jika Kita Menggunakan QR QRIS yang sudah dihapus](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2788-38312) (**SO-QRN-I1**); frame baru tinggal mengganti konteks field, copy modalnya dipakai apa adanya.

**Prasyarat**

- **User A** punya akses ke menu **Tipe Penjualan** (Setup AOL).
- **User B** sedang membuka **Setting QR Self Order**, field **tipe penjualan** pada form itu sudah **diisi/dipilih** (mis. "Dine In") tapi form **belum disimpan**.
- Tipe penjualan yang sedang dipilih User B itu **belum** dimapping secara tersimpan ke QR Self Order mana pun — kalau sudah tersimpan, penghapusannya diblokir lebih dulu oleh **SO-QRN-H1**, bukan kasus ini.

**Langkah reproduksi**

1. **User B:** buka **Setting QR Self Order**, pilih/isi tipe penjualan **"Dine In"** pada field terkait. **Diamkan, jangan tekan Simpan.**
2. **User A:** buka **menu Tipe Penjualan** (Setup AOL), hapus tipe penjualan **"Dine In"** sampai sukses. (Berhasil karena belum ada mapping tersimpan yang memblokirnya — beda dari SO-QRN-H1.)
3. **User B:** tanpa refresh, tekan tombol **"Simpan"** pada form Setting QR Self Order-nya.

**Hasil yang diharapkan**

- Penyimpanan User B **gagal** — tipe penjualan yang dirujuk sudah tidak ada, bukan disimpan diam-diam dengan data basi.
- Muncul **modal** (bukan toast), copy identik dengan SO-QRN-I1:

| Elemen | Isi |
|---|---|
| Judul | **"Terjadi Permasalahan pada Pemprosesan"** |
| Body (baris 1) | "Silahkan perbaiki permasalahan berikut ini:" |
| Body (baris 2, merah) | **"Data ini sudah sempat diubah oleh pengguna lain. Batalkan dan ulangi pengubahan anda"** |
| Aksi | satu tombol **"OK"** |

- **Satu tombol, bukan dua** — sepola modal blocking lain di fitur ini: tidak ada yang bisa "disimpan ulang" langsung, karena tipe penjualannya memang sudah tidak valid.
- **State setelah "OK":** form dimuat ulang dengan data terbaru; User B harus memilih ulang tipe penjualan dari data yang masih ada — tipe penjualan yang sudah dihapus tidak lagi muncul sebagai opsi.
- **Pesan generik, dipakai apa adanya dari SO-QRN-I1** — bukan copy baru khusus tipe penjualan. Modal ini sudah didesain lintas-entitas ("data ini sudah sempat diubah"), jadi tidak perlu varian judul/body per jenis field yang bentrok.

**Beda dari SO-QRN-H1.** H1 memblokir **penghapusan tipe penjualan** itu sendiri, dan hanya berlaku kalau mapping-nya **sudah tersimpan**. Kasus ini (I2) terjadi justru karena mapping-nya **belum tersimpan** saat penghapusan terjadi — jadi penghapusan di User A **berhasil**, dan bentroknya baru ketahuan saat User B menyimpan. Kedua kasus sama-sama soal tipe penjualan, tapi titik pemblokirannya beda: H1 di sisi hapus, I2 di sisi simpan.

**Hasil aktual (2026-08-03)**

**Belum digambar.** Copy modal mengikuti SO-QRN-I1 apa adanya (sudah final di sana), tinggal dibuatkan frame untuk konteks field tipe penjualan.

---

## Yang di luar scope (sengaja tidak dikerjakan)

Daftar ini penting untuk QA: hal-hal di bawah **bukan celah yang terlewat**, tapi keputusan sadar. Jangan dilaporkan sebagai temuan.

- **Aplikasi Self Order pelanggan** — menu, keranjang, konfirmasi pesanan, pembayaran, struk. Spec ini murni sisi setup APOS.
- **Journey Close Bill (QRIS & Bayar di Kasir)** negative case — order nyangkut, double submit, callback gagal, dua kasir rebutan order. Kandidat spec terpisah.
- **Setup AOL** — modal konfirmasi mematikan Table Management dan state lain di web Accurate Online (bagian F).
- **Koneksi putus di tengah proses generate** — dikonfirmasi dengan DEV tidak mungkin terjadi, jadi tidak dibuatkan state.
- **State loading saat generate banyak meja** — 100 meja sekaligus dianggap aman secara fungsional, tidak dibuatkan state khusus. Sisi overflow tampilannya sudah ditangani di frame overflow existing.
- **Varian modal sukses generate per jumlah meja** — modal sukses existing dipakai apa adanya untuk berapa pun jumlahnya, termasuk 1 meja. Tidak ada tombol "Cetak" khusus dan tidak ada varian copy.
- **Riwayat Transaksi Self Order gagal sync ke Accurate Online** — ditunda, kandidat spec terpisah.
- **Variasi pesan per jenis kegagalan** (timeout vs server error vs storage penuh) — satu pesan generik per case.

## Status desain di Figma

Per 2026-07-28, ditinjau terhadap canvas **MVP — Close Bill · QR Statis · Table Management**. Setiap section `Case Negative` punya frame **catatan** berisi Pre-condition / Steps to Reproduce / Expected Result.

| ID | Kasus | Status | Section Figma |
|---|---|---|---|
| SO-QRN-A1 | Generate tanpa memilih meja | sudah | catatan pada **Popup Pilih Meja** |
| SO-QRN-A2 | Semua meja sudah ber-QR | **sebagian** — grid disabled sudah; aturan "Pilih Semua" hilang belum tergambar, catatan lama masih menyebut disabled | **Popup Pilih Meja** |
| SO-QRN-A3 | Unduh PDF gagal (QR sudah dihapus device lain) | sudah | **Case Negative : Gagal Mendownload PDF** |
| SO-QRN-B1 | Generate sebagian bentrok | sudah | **Case Negative : Generate QR Sebagian Bentrok** |
| SO-QRN-B2 | Generate semua bentrok | sudah, 4 varian jumlah | **Case Negative : Generate QR Gagal** |
| SO-QRN-B3 | Hapus sebagian bentrok | sudah | **Case Negative : Hapus QR Sebagian Bentrok** |
| SO-QRN-B4 | Hapus semua bentrok | sudah, 4 varian jumlah — teks catatan belum ikut aturan koma | **Case Negative : Hapus Daftar QR Gagal** |
| SO-QRN-B5 | Cetak QR sudah dihapus device lain | sudah — copy belum diverifikasi terhadap spec | **Case Negative : Cetak QR Gagal** |
| SO-QRN-C | Hapus QR yang sedang dipakai (sesi tetap jalan) | **belum** (tidak butuh state baru) | — |
| SO-QRN-D | Printer tidak terhubung | **belum** — copy sudah final, frame belum masuk canvas | — |
| SO-QRN-E1 | Tanpa hak akses | sudah — ada drift penamaan judul halaman | **QR Management Tanpa Hak Akses** |
| SO-QRN-E2 | Permission ON, fitur global OFF | tidak perlu digambar | — |
| SO-QRN-E3 | Permission dicabut saat halaman terbuka | **belum** — perilaku baru diputuskan 2026-07-30 | — |
| SO-QRN-H1 | Hapus tipe penjualan yang dipakai QR Self Order | sudah, copy final | **Case Negative : Modal Error Jika Sudah Ada Tipe Penjualan Yang Dimapping Ke QR Self Order** |
| SO-QRN-I1 | QR QRIS dihapus device lain saat form QR Self Order belum disimpan | sudah, copy final | **Case Negative : Modal Error Jika Kita Menggunakan QR QRIS yang sudah dihapus** |
| SO-QRN-I2 | Tipe penjualan dihapus device lain saat form QR Self Order belum disimpan | **belum** — copy sama dengan I1, frame belum dibuat | — |

## Pertanyaan terbuka

| No | Pertanyaan | Menunggu | Terkait |
|---|---|---|---|
| 1 | Ekspor Data: aturan gagal-sebagian dan wadah pesannya | alur baru Ekspor Data final | bagian G |
| 2 | Istilah **"QR Statis"** (toast sukses) vs **"QR Meja"** (modal error) — seragamkan atau biarkan berbeda per wadah? | keputusan PM | SO-QRN-B3 |
| 3 | Ejaan **"Silahkan"** vs **"Silakan"** pada modal printer | keputusan PM / konvensi copy produk | SO-QRN-D |
| 4 | Judul halaman **"Self QR Management"** vs **"QR Management"** pada state tanpa hak akses | keputusan PM, lalu perbaikan Figma | SO-QRN-E1 |
| 5 | Teks catatan pada section Hapus Daftar QR Gagal masih memakai koma sebelum "dan" dan nama meja tanpa spasi ("AA-01") | perbaikan Figma | SO-QRN-B4 |
| 6 | Dua frame lepas di canvas, bukan bagian dari section mana pun — dipakai atau dibersihkan? | keputusan desainer | [[#Lampiran B — Peta node Figma\|Lampiran B]] |
| 7 | Setelah halaman QR Management hilang, user **diarahkan ke mana**? Kembali ke daftar menu Pengaturan, atau ke halaman utama POS? | keputusan PM / UI/UX | SO-QRN-E3 |
| 8 | ~~Diberi tahu atau senyap?~~ — **terjawab 2026-07-30: senyap, tanpa notifikasi.** Tidak ada toast maupun modal. Sudah jadi bagian dari Hasil yang Diharapkan, bukan pertanyaan lagi. | selesai | SO-QRN-E3 |
| 9 | ~~Popup Pilih Meja sedang terbuka saat sinkronisasi~~ — **terjawab 2026-07-30:** sinkronisasi adalah aksi manual yang harus ditekan, dan refresh baru terjadi setelah sinkronisasi selesai. Sisa yang perlu dicek: **di mana tombol sinkronisasi berada** — masih bisa ditekan saat Popup Pilih Meja terbuka, atau harus menutup popup dulu? | cek ke DEV | SO-QRN-E3 |
| 10 | **Unduh PDF saat sebagian QR yang dicentang masih valid** — PDF tetap dibuat untuk QR yang masih ada, atau seluruh unduhan digagalkan? Generate dan Hapus memakai aturan "lolosin yang valid", tapi PDF adalah satu file. | keputusan PM / DEV | SO-QRN-A3 |

---

## Lampiran A — Kamus layar

Nama layar yang dipakai di badan dokumen, apa isinya, dan cara membukanya di aplikasi. Semua ada di **aplikasi Accurate POS (APOS)** kecuali disebut lain.

| Nama layar | Isinya | Cara membuka |
|---|---|---|
| **Setting QR Management** | Halaman utama fitur ini. Berisi blok "Generate QR untuk meja terpilih", blok "Ekspor data ke Self Order", dan **Daftar QR Aktif**. | Menu Pengaturan → QR Management (butuh Table Management & QR Self Order aktif di Setup AOL) |
| **Daftar QR Aktif** | Daftar QR meja yang sudah dibuat, satu baris per meja, dengan kolom pencarian "Cari daftar QR", link "Pilih" untuk seleksi massal, dan kebab menu (⋮) per baris untuk cetak/hapus. | bagian bawah halaman **Setting QR Management** |
| **Popup Pilih Meja** | Popup pemilihan meja sebelum generate. Grid kartu meja dikelompokkan per kategori/area, tiap kategori punya link "Pilih Semua", header popup punya counter "N Meja Terpilih" dan tombol "Generate QR". | tap **"Pilih Meja & Generate QR"** di Setting QR Management |
| **Modal sukses generate** | Modal setelah generate berhasil: judul "N QR meja berhasil dibuat", chip nama meja, tombol "Selesai" · "Download PDF". | otomatis setelah generate berhasil |
| **Cetak QR Satuan** | Alur cetak satu QR meja lewat kebab menu (⋮) → "Cetak QR", dengan toast sukses "1 QR Statis Berhasil Dicetak". | kebab menu (⋮) pada baris Daftar QR Aktif |
| **Hapus QR Satuan / Hapus QR Banyak** | Alur hapus satu meja (lewat kebab) atau banyak meja (lewat mode seleksi "Pilih"), dengan dialog konfirmasi dan toast sukses "N QR Statis Berhasil Dihapus". | kebab menu (⋮), atau link "Pilih" → centang → "Hapus" |
| **QR Management Tanpa Hak Akses** | Versi halaman Setting QR Management untuk karyawan tanpa permission "Mengelola QR Self Order" — read-only. | login sebagai karyawan tanpa permission tersebut |
| **Peran Karyawan POS — grup QR Self Order** | Tempat permission "Mengelola QR Self Order" dicentang atau tidak. | Pengaturan → Peran Karyawan → pilih peran → grup **QR Self Order** |
| **Setup AOL Fitur Opsional** | Halaman di **Accurate Online (web)**, tempat toggle Table Management dan QR Self Order. QR Self Order hanya bisa aktif kalau Table Management aktif. | Accurate Online → Setup → Fitur Opsional |
| **Pengaturan › Printer** | Halaman penghubungan printer, tujuan tombol "Hubungkan printer" pada modal SO-QRN-D. | Menu Pengaturan → Printer |

## Lampiran B — Peta node Figma

Hanya untuk desainer dan DEV yang perlu membuka frame aslinya. **Tidak perlu dibaca QA.** File: `mAZuRze02w906M6u2EwVWh`, canvas `1223:2`.

Kolom **Node** bisa diklik — langsung membuka frame-nya di Figma. Pola linknya: `https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=<node>` dengan titik dua pada node diganti tanda hubung (`2310:18506` → `2310-18506`).

| Nama section / frame                                                                                           | Node                                                                                              | Terkait          |
| -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | ---------------- |
| Canvas "MVP — Close Bill · QR Statis · Table Management"                                                       | [`1223:2`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-2)         | —                |
| Setting QR Management                                                                                          | [`1223:6`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-6)         | semua            |
| Popup Pilih Meja                                                                                               | [`1629:60773`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1629-60773) | A1, A2, B1, B2   |
| Modal sukses generate                                                                                          | [`1223:597`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1223-597)     | B1               |
| Frame overflow tampilan generate banyak meja                                                                   | [`1441:2`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1441-2)         | luar scope       |
| Cetak QR Satuan                                                                                                | [`1624:43559`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1624-43559) | B5, D            |
| Hapus QR Satuan                                                                                                | [`1345:16773`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1345-16773) | B3, B4, C        |
| Hapus QR Banyak                                                                                                | [`1482:36539`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1482-36539) | B3, B4           |
| Toast "2 QR Statis Berhasil Dihapus"                                                                           | [`1627:54792`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1627-54792) | B3               |
| Toast "12 QR Statis Berhasil Dihapus"                                                                          | [`1627:55552`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1627-55552) | B3               |
| Peran Karyawan POS — grup QR Self Order                                                                        | [`1604:35570`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1604-35570) | E1               |
| QR Management Tanpa Hak Akses (section)                                                                        | [`1998:75370`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1998-75370) | E1               |
| QR Management Tanpa Hak Akses (frame — judul masih "Self QR Management")                                       | [`1998:75371`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1998-75371) | E1, pertanyaan 4 |
| Setup AOL Fitur Opsional                                                                                       | [`1993:70739`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=1993-70739) | F                |
| Ekspor Data Gagal — Tidak Ada Internet                                                                         | [`2287:16087`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2287-16087) | G                |
| Case Negative : Hapus Daftar QR Gagal (section)                                                                | [`2310:18506`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2310-18506) | B4               |
| — varian 1 meja                                                                                                | [`2310:18507`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2310-18507) | B4               |
| — varian 2 meja                                                                                                | [`2346:35894`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2346-35894) | B4               |
| — varian 3 meja                                                                                                | [`2351:36868`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2351-36868) | B4               |
| — varian lebih dari 3 meja (contoh 12)                                                                         | [`2346:36381`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2346-36381) | B4               |
| — frame catatan pola (acuan format catatan)                                                                    | [`2316:18982`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2316-18982) | semua            |
| — teks catatan yang belum ikut aturan koma                                                                     | [`2316:18986`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2316-18986) | pertanyaan 5     |
| Case Negative : Gagal Mendownload PDF                                                                          | [`2362:40068`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2362-40068) | A3               |
| Case Negative : Generate QR Gagal (section)                                                                    | [`2391:17902`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17902) | B2               |
| — varian 1 meja                                                                                                | [`2391:17903`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17903) | B2               |
| — varian 2 meja                                                                                                | [`2391:17907`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17907) | B2               |
| — varian 3 meja                                                                                                | [`2391:17911`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17911) | B2               |
| — varian lebih dari 3 meja (contoh 12)                                                                         | [`2391:17915`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2391-17915) | B2               |
| Case Negative : Generate QR Sebagian Bentrok (section)                                                         | [`2392:22394`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2392-22394) | B1               |
| — frame utamanya                                                                                               | [`2392:22395`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2392-22395) | B1               |
| Case Negative : Hapus QR Sebagian Bentrok (section)                                                            | [`2392:22621`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2392-22621) | B3               |
| — frame utamanya                                                                                               | [`2393:22720`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2393-22720) | B3               |
| Case Negative : Cetak QR Gagal                                                                                 | [`2377:41090`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2377-41090) | B5               |
| Case Negative : Modal Error Jika Sudah Ada Tipe Penjualan Yang Dimapping Ke QR Self Order (section)             | [`2774:30048`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2774-30048) | H1               |
| — frame modal utamanya                                                                                         | [`2777:30220`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2777-30220) | H1               |
| — frame catatan (ditambahkan 2026-07-31)                                                                       | [`2780:23684`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2780-23684) | H1               |
| Case Negative : Modal Error Jika Kita Menggunakan QR QRIS yang sudah dihapus (section)                         | [`2788:38312`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2788-38312) | I1               |
| — frame layar "Dine In" + modal                                                                                | [`2788:38770`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2788-38770) | I1               |
| — frame catatan (ditambahkan 2026-07-31)                                                                       | [`2793:24324`](https://www.figma.com/design/mAZuRze02w906M6u2EwVWh/Self-Order?node-id=2793-24324) | I1               |

> **Catatan posisi frame lepas.** `2386:46537` sempat tersedot saat section baru dibuat di koordinat itu, lalu dikeluarkan lagi ke posisi semula; section B1 dipindah ke bawah B3 supaya tidak menimpanya.
