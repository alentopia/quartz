# Materi Sharing — SDD, Obsidian, Graphify

> Status: Draft
> Durasi: 120 menit
> Audiens: UI/UX dan Developer/Engineer
> Angka dan temuan di dokumen ini diambil dari build nyata vault `POS/` per 6 Agustus 2026.

---

## 0. Rangka Waktu

| Menit | Bagian | Inti |
|---|---|---|
| 0–8 | Pembuka | Dua pertanyaan ke audiens |
| 8–30 | **SDD** | Spec sebagai fondasi, bukan dokumentasi pasif |
| 30–52 | **Obsidian** | Tempat spec hidup dan bisa dibaca mesin |
| 52–62 | Rehat | |
| 62–92 | **Graphify** | Memeriksa spec masih koheren |
| 92–110 | Batas & biaya | Yang tetap butuh manusia |
| 110–120 | Penutup + tanya jawab | |

### Pembuka

Tanya audiens dua hal, tulis jawabannya di papan:

1. "Pernah minta AI jelaskan fitur produk kita, lalu jawabannya ngarang?"
2. "Berapa lama nyari tahu satu keputusan desain lama itu kenapa diambil?"

Tagih lagi kedua pertanyaan ini di penutup.

### Rantai argumennya

```
SDD       menetapkan aturan   →  apa yang benar
Obsidian  menyimpan aturan    →  di mana aturannya
Graphify  memeriksa aturan    →  masih nyambung atau tidak
```

Tanpa SDD, Obsidian cuma aplikasi catatan dan graphify cuma gambar bagus.
Tanpa Obsidian, SDD tidak punya tempat yang bisa dibaca mesin.
Tanpa graphify, tidak ada yang tahu kapan spec mulai berbohong.

---

# BAGIAN 1 — Spec-Driven Development

## 1.0 Konsep pengikatnya: spec diperlakukan seperti kode sumber

Sampaikan ini lebih dulu. Sekali diterima, semua aturan lain jatuh sendiri dan tidak perlu dihafal satu per satu.

| Dunia kode | Dunia spec kita |
|---|---|
| Source code | `Features/*.md`, `_meta/*.md` — tulisan manusia |
| Compiler | graphify |
| Build artifact | `graphify-out/` — graph.json, graph.html, wiki, note |
| Deploy | GitLab Wiki |
| Test | `.feature` Gherkin + coverage matrix |
| Linter | wikilink yang wajib valid |

**Aturan yang muncul otomatis dari pemetaan ini:**

*Arahnya satu.* Sumber → build → terbit, tidak pernah balik. Kalau isi wiki salah, yang dibetulkan spec-nya. Sama seperti tidak ada yang menambal bug dengan mengedit file `.exe`.

*Hasil build boleh dibuang.* `graphify-out/` bisa dihapus total tanpa kehilangan apa pun. Itu sebabnya dia layak masuk `.gitignore`, dan sebabnya 415 note mesin di vault bukan aset.

*Build harus bisa diulang.* Input sama, hasil sama. Ekstraksi AST memang begitu; ekstraksi semantik tidak sepenuhnya — akui ini, karena artinya graph punya sedikit ketidakpastian yang kode tidak punya.

*Terbit itu menyalin, bukan menulis.* GitLab Wiki etalase, bukan tempat mengarang.

*Sumbernya diberi versi, hasilnya tidak.* Riwayat git spec = riwayat keputusan produk. Riwayat graph.json = riwayat build, tidak menarik.

### Dua kelas isi, beda perlakuan

Ini pembeda yang paling sering kacau di tim:

| | Ditulis manusia | Dihasilkan mesin |
|---|---|---|
| Jumlah di vault | 55 file | 415 + 35 file |
| Biaya membuat | mahal, lambat | murah, cepat |
| Perlu review? | ya | tidak |
| Perlu status Draft/Review/Approved? | ya | tidak |
| Boleh dihapus? | tidak | ya, kapan saja |

Kalau dua kelas ini tercampur tanpa penanda, orang mulai memperlakukan tebakan mesin seperti keputusan produk. Itu bahaya sesungguhnya — lebih besar daripada soal akurat atau tidaknya graph.

Makanya semua hasil generate ditaruh di `graphify-out/`, dan di GitLab semuanya masuk folder `graph/`. Bukan demi kerapian, tapi supaya batas antara "ini keputusan kami" dan "ini dugaan mesin" tetap terlihat.

### Kenapa framing ini dipakai duluan

Audiens dev langsung paham tanpa penjelasan panjang — mereka hidup dengan model source/build/deploy tiap hari.

Untuk UI/UX, framing ini menjawab pertanyaan yang biasanya tidak terucap: *kenapa saya harus repot menulis lima state kalau Figma-nya sudah jadi?* Jawabannya: Figma itu artifact, spec itu sumber.

Dan ini menutup keberatan paling umum. Kalau ada yang bilang "graph-nya kan bisa salah" — betul, build juga bisa salah. Solusinya bukan berhenti build, tapi memperbaiki sumbernya lalu build ulang.

## 1.1 Kenapa penting

Satu hal berubah: **pembaca spec bukan lagi manusia sekali baca, tapi mesin yang membacanya ulang tiap kali menulis kode.**

Dulu spec ditulis, dibaca sekali saat kickoff, lalu membusuk di folder. Sekarang spec jadi input yang dieksekusi berulang. Dokumen yang salah tidak lagi cuma membingungkan orang — dia langsung berubah jadi kode yang salah.

**Kenapa halusinasi terjadi.** Model tidak bisa membedakan "tidak disebutkan" dari "bebas ditentukan". Tiap celah di kebutuhan diisi dengan default yang masuk akal secara statistik, bukan yang benar untuk produk ini.

**Asimetri yang bikin mendesak.** AI menulis kode yang valid secara sintaksis dengan sangat cepat. Valid ≠ benar. Kecepatan produksi melampaui kecepatan review. Satu-satunya pemeriksaan yang ikut menskala adalah spec yang menyatakan maksud cukup tegas untuk dibandingkan.

## 1.2 Anatomi spec yang bagus

Tiga belas komponen. Yang bertanda **wajib** adalah yang menanggung beban — tanpa itu spec tidak bisa dieksekusi.

### 1. Konteks & masalah — wajib
Satu paragraf: keadaan sekarang, apa yang menyakitkan, siapa yang kesakitan. Bukan solusi.

### 2. Tujuan & non-tujuan — wajib
Non-tujuan lebih penting daripada tujuan. Ini yang menahan AI (dan manusia) melebar.

```markdown
## Tujuan
- Tamu bisa memesan dari meja tanpa memanggil waiter

## Bukan Tujuan
- Pembayaran split bill (di luar MVP)
- Integrasi loyalty pihak ketiga
```

### 3. Aktor — wajib
Siapa yang melakukan apa. Di POS: Pelanggan, Waiter, Kasir, Admin Outlet. Tiap requirement harus punya aktor yang jelas.

### 4. ID spine — wajib
Identitas stabil yang menyambungkan spec → test case → kode → laporan coverage.

```
SO-JRN-A1     journey positif
SO-JRN-C7     journey negatif
SO-QRN-B3     QR management negatif
BR-01         business rule
PAGE-04       halaman
FR-13         functional requirement
```

Aturannya: ID tidak pernah dipakai ulang, tidak pernah diubah artinya. Kalau kasusnya mati, ID-nya ikut pensiun — jangan didaur ulang.

### 5. Functional requirements — wajib
Satu baris satu aturan, tiap baris punya ID. Kalimat harus bisa diputus benar-salahnya.

| Buruk | Baik |
|---|---|
| "Harus user friendly" | "Tombol Konfirmasi nonaktif selama keranjang kosong" |
| "Validasi nomor HP" | "Nomor HP < 10 digit → tombol nonaktif, pesan: `Nomor HP belum lengkap`" |
| "Tampilkan promo" | "Promo Produk tampil di kartu item; Diskon Transaksi tampil di ringkasan bawah" |

### 6. Business rules — wajib
Aturan yang berlaku lintas halaman. Beda dari functional requirement karena tidak terikat satu layar.

Contoh dari vault: `BR-01` sampai `BR-06` KDS Lite; aturan cap jatah item gratis lintas modifier; aturan bentrok antar-device di QR Management.

### 7. Spesifikasi per halaman/komponen — wajib
Untuk tiap halaman: elemen apa saja, urutannya, dan **teks persisnya**. Copy ditulis apa adanya di dalam backtick, bukan diparafrase.

```markdown
### PAGE-06 Keranjang
- Header: `Keranjang`
- Daftar item — tiap baris: nama, qty badge, harga
- Badge qty adalah tap-target, bukan sekadar status
- Tombol bawah: `Konfirmasi Pesanan`
- Kosong → lihat state Empty
```

### 8. Lima state wajib — wajib
Ini yang paling sering hilang, dan paling sering bikin AI mengirim produk setengah jadi.

| State | Pertanyaan yang dijawab |
|---|---|
| Happy | Kalau semua lancar, tampilannya apa |
| Empty | Belum ada data sama sekali |
| Loading | Sedang menunggu, berapa lama sebelum dianggap gagal |
| Error | Gagal — pesannya apa, ditaruh di mana (toast atau modal) |
| Recovery | Setelah gagal, tamu bisa apa |

Figma menggambar happy path. Empat sisanya cuma hidup di spec.

### 9. Acceptance criteria Given/When/Then — wajib
Ini yang nanti jadi test. Ditulis dalam bahasa yang sama dengan kamus langkah supaya bisa langsung diturunkan.

```gherkin
Diberikan keranjang berisi 2 item
Ketika pelanggan menekan Konfirmasi Pesanan
Maka harga dikunci dan halaman Konfirmasi tampil
```

### 10. Kasus negatif
Blok terpisah, jangan diselipkan sebagai catatan. Format lima blok yang sudah dipakai di vault (`_meta/templates/Template_Case_Negative.md`):

1. Kondisi awal
2. Aksi
3. Hasil yang diharapkan
4. Pesan/copy persis
5. Jalur pemulihan

### 11. Data & validasi
Tiap field: tipe, format, batas, wajib atau opsional, apa yang terjadi kalau dilanggar. Termasuk normalisasi — contoh dari vault: prefix `+62` dan normalisasi nomor HP.

### 12. Dependensi & prasyarat
Fitur ini butuh apa dulu. Contoh: Self Order butuh setup AOL; mode KDS butuh diaktifkan di AOL.

### 13. Metadata perawatan — wajib
Status (Draft → Review → Approved), tanggal, pemilik, dan link ke Figma serta test terkait. Tanpa ini tidak ada yang tahu spec sudah basi.

## 1.3 Checklist siap-handoff

Cetak dan tempel. Spec belum boleh diserahkan ke dev/QA/AI kalau ada yang belum tercentang.

- [ ] Tiap requirement punya ID unik dan aktor jelas
- [ ] Tiap halaman punya lima state
- [ ] Semua copy ditulis persis, bukan diparafrase
- [ ] Tiap AC bisa diputus lulus/gagal tanpa tanya orang
- [ ] Kasus negatif punya jalur pemulihan
- [ ] Non-tujuan tertulis
- [ ] Wikilink ke dokumen terkait valid (target ada)
- [ ] Status dan tanggal terisi
- [ ] Kalau menggantikan dokumen lama, dokumen lama ditandai arsip

## 1.4 Anti-pattern

**Spec yang menjelaskan solusi teknis, bukan perilaku.** "Pakai Redis untuk cache" bukan spec, itu keputusan implementasi.

**Dua sumber kebenaran.** Catatan di Figma yang bertentangan dengan spec di vault. Vault ini punya kasusnya: `_meta/Rombak_Catatan_Figma_SelfOrder.md` mencatat dua konflik di mana catatan Figma menang atas spec.

**Versi lama tidak ditandai.** `SO_PRD.md` (v0.2) dan `SO_PRD_MVP.md` sama-sama punya PAGE-01 sampai PAGE-11 dengan isi berbeda. Kalau AI diarahkan ke vault tanpa diberi tahu mana yang berlaku, dia akan mencampur keduanya dengan percaya diri penuh.

**Spec tanpa ID.** Tidak bisa dicocokkan dengan apa pun. Coverage jadi tebakan.

## 1.5 Bukti dari vault

`ValidationPopup` dirujuk empat dokumen case berbeda sebagai satu sumber — muncul di graph sebagai god node dengan 11 edge. Itu SDD yang jalan: aturan ditulis sekali, dipakai berkali-kali.

Rantai yang sudah tertutup di vault ini:

```
spec (.md)
  → skill testcase-from-spec
    → .feature Gherkin bahasa Indonesia
      → coverage-matrix.ps1
        → cocokkan ID vault vs ID repo otomasi
```

Spec menghasilkan test, test balik memeriksa spec masih dipatuhi.

## 1.6 Demo bagian 1 (5 menit)

Buka `Features/POS/SelfOrder/Cases/SO_Case_QRManagementNegative.md`. Tunjukkan lima blok per kasus.
Buka `Features/POS/SelfOrder/Tests/SO_QRManagement.feature` berdampingan.
Audiens melihat kalimat yang sama muncul dua kali — sekali untuk manusia, sekali untuk mesin.

**Kalimat penutup bagian:** spec bukan formalitas sebelum kerja. Spec adalah kerjanya.

---

# BAGIAN 2 — Obsidian sebagai Otak

## 2.1 Prinsip

Obsidian bukan aplikasi catatan yang kebetulan dipakai buat spec. Dia dipilih karena **formatnya**, bukan fiturnya. Yang penting bukan Obsidian-nya — yang penting file `.md` biasa di disk lokal. Obsidian cuma cara nyaman membacanya.

Empat sifat yang menentukan:

**Teks polos.** Bisa di-`grep`, di-`diff`, masuk git. AI membaca file yang sama persis dengan yang kamu lihat.

**Wikilink yang dipaksa valid.** `[[SO_PRD]]` yang targetnya tidak ada akan kelihatan. Ini pemeriksaan integritas yang jalan terus-menerus, bukan sekadar navigasi.

**Lokal.** Tidak ada rate limit, autentikasi, atau izin server saat AI membaca 70 dokumen sekaligus.

**Tidak terkunci vendor.** Kalau besok Obsidian mati, foldernya tetap folder markdown.

### Pola yang sebenarnya bekerja

Bukan "jejalkan semua spec ke prompt". Konteks panjang menurunkan kualitas — perhatian model melebar, detail penting tenggelam.

Yang bekerja: **indeks dibaca di awal, detail ditarik saat disebut.**

Sebut framing ini eksplisit ke audiens dev: bukan "prompt raksasa", tapi "basis pengetahuan yang bisa dinavigasi". Yang pertama terdengar boros token, yang kedua terdengar seperti arsitektur.

## 2.2 Struktur folder

```
POS/
├── CLAUDE.md                    ← aturan kerja, dibaca otomatis tiap sesi
├── _meta/
│   ├── context-map.md           ← indeks: visi produk + daftar fitur + konvensi
│   ├── Kamus_Langkah_Gherkin.md ← kosakata langkah yang boleh dipakai
│   ├── Coverage_Matrix.md       ← dibuat otomatis, jangan diedit manual
│   ├── templates/
│   │   └── Template_Case_Negative.md
│   └── scripts/
│       ├── coverage-matrix.ps1
│       └── spec-to-testcase-csv.ps1
└── Features/
    └── SelfOrder/
        ├── SO_PRD.md
        ├── Cases/
        │   └── SO_Case_QRManagementNegative.md
        └── Tests/
            └── SO_QRManagement.feature
```

## 2.3 Dua file yang menentukan segalanya

### `CLAUDE.md` — aturan main

Dibaca otomatis di awal tiap sesi Claude Code. Isinya **tipis**: routing, konvensi, dan penunjuk ke tempat detail. Jangan duplikasi pengetahuan produk di sini.

Isi minimal:

```markdown
# Nama Proyek — Panduan Vault

## Routing
- Untuk membuat PRD/spec fitur baru → pakai skill `superpowers:brainstorming`
- Skill lama `/prd-agent` sudah tidak dipakai (deprecated)

## Konvensi Dasar
- Bahasa: ikuti bahasa input PM
- Penamaan file: [Prefix]_[Tipe].md
- Folder fitur: Features/<Sisi>/<NamaFitur>/
- Status dokumen: Draft → Review → Approved
- Link antar dokumen: wikilink valid, target wajib ada

## Konteks Produk
Lihat `_meta/context-map.md`
```

Kenapa tipis: file ini masuk ke konteks tiap sesi. Kalau gemuk, dia memakan ruang yang seharusnya dipakai spec yang relevan.

### `_meta/context-map.md` — indeks

Ini otaknya. Dibaca di awal sebagai daftar isi, lalu spec ditarik saat fiturnya benar-benar disebut.

Isi wajib:

```markdown
## Product Vision
Satu paragraf: produk apa, untuk siapa, fokusnya apa.

## Feature Index
| Prefix | Fitur | Status | Spec Utama |
|--------|-------|--------|------------|
| SO | Self Order | Review | [[SO_PRD]] |
| WL | Waiting List | Draft | [[WL_Overview]] |

## Proses & Workflow
Tabel dokumen proses dan isinya masing-masing.

## Conventions
Penamaan, prefix, status, aturan wikilink.
```

Tabel Feature Index inilah yang menjawab pertanyaan "spec mana yang berlaku". Kalau ada dokumen tidak terdaftar di sini, dia tidak punya status resmi — dan itu masalah, bukan kelalaian kecil.

## 2.4 Langkah membangun dari nol

**Langkah 1 — buat folder, buka sebagai vault.**
Obsidian → *Open folder as vault*. Tidak perlu plugin apa pun. Vault POS berjalan tanpa satu pun community plugin.

**Langkah 2 — tulis `CLAUDE.md`.**
Pakai kerangka di atas. Maksimal satu layar.

**Langkah 3 — tulis `_meta/context-map.md`.**
Isi Product Vision dan tabel Feature Index, walau baru satu baris.

**Langkah 4 — tetapkan konvensi penamaan sebelum menulis dokumen kedua.**
Prefix huruf kapital per fitur (`SO`, `WL`, `KDS`). Pola nama `[Prefix]_[Tipe].md`. Ini keputusan yang mahal kalau diubah belakangan.

**Langkah 5 — buat satu template.**
`_meta/templates/Template_Case_Negative.md`. Copy-paste template lebih andal daripada mengandalkan ingatan.

**Langkah 6 — tulis satu spec sungguhan sampai selesai.**
Jangan bikin sepuluh dokumen setengah jadi. Satu spec lengkap jadi teladan untuk sisanya.

**Langkah 7 — masukkan ke git.**
Riwayat perubahan spec adalah riwayat keputusan produk. Ini yang menjawab "kenapa dulu diputuskan begitu".

## 2.5 Cara AI membacanya

```
Sesi mulai
  → CLAUDE.md dibaca otomatis      (aturan main)
  → context-map.md dibaca          (peta wilayah)
  → PM sebut "Self Order"
    → SO_PRD.md ditarik            (detail, on-demand)
      → wikilink ke case diikuti   (kalau perlu)
```

Yang bikin ini bekerja: indeksnya kecil, dan tiap dokumen menunjuk ke dokumen lain dengan tautan yang valid.

## 2.6 Perawatan

| Kapan | Yang di-update |
|---|---|
| Spec baru selesai | Tambah baris di Feature Index |
| Status berubah | Ubah di dokumen dan di Feature Index |
| Dokumen digantikan | Tandai yang lama sebagai arsip, jangan dihapus |
| Konvensi berubah | `CLAUDE.md` dan `context-map.md`, keduanya |
| Skill/proses dihentikan | Cari semua penyebutnya, termasuk `ONBOARDING.md` |

## 2.7 Yang tidak dimasukkan ke vault

- Kredensial, token, API key — apa pun
- File biner besar (bundle plugin, video, dump XML)
- Hasil generate yang bisa dibuat ulang, kecuali sengaja di-commit

## 2.8 Yang Obsidian TIDAK selesaikan

Ini yang menyiapkan panggung untuk bagian 3.

Obsidian menyimpan relasi yang **kamu tulis sendiri**. Dia tidak tahu relasi yang tidak pernah kamu sadari. Graph View bawaannya hanya menggambar wikilink — kalau dua fitur memakai pola yang sama tapi tidak pernah saling ditautkan, Graph View diam saja.

Dan Obsidian tidak mendeteksi drift. `ONBOARDING.md` boleh saja mempromosikan skill yang sudah deprecated di `CLAUDE.md` — tidak ada yang protes.

## 2.9 Demo bagian 2 (5 menit)

Buka `_meta/context-map.md`, tunjukkan tabel Feature Index.
Tanya Claude soal alur Self Order — tunjukkan dia menarik file spesifiknya sendiri, bukan disodori.

**Kalimat penutup bagian:** vault membuat konteks tersedia. Dia tidak membuat konteks konsisten.

---

# BAGIAN 3 — Graphify

## 3.1 Apa dan cara kerjanya

Graphify membaca satu folder dan menghasilkan **peta relasi**. Bukan ringkasan, bukan pencarian — peta.

Dua jalur ekstraksi, dan bedanya penting untuk audiens dev:

**Struktural** — parsing AST deterministik, lokal, tanpa LLM, tanpa API key. Kode dibaca apa adanya. Jalankan dua kali, hasilnya sama persis. Mendukung 26 bahasa lewat tree-sitter.

**Semantik** — untuk dokumen, PDF, dan gambar. Ini pakai LLM, dan di sinilah biayanya.

Tidak ada vector store. Tidak ada embedding. Tiap edge punya alasan yang bisa ditunjuk.

## 3.2 Pemasangan

**Prasyarat:** Python 3.10+, dan Claude Code kalau mau lewat skill `/graphify`.

Nama paketnya `graphifyy` dengan dua huruf y. CLI-nya `graphify` dengan satu y. `pip install graphify` akan gagal.

```bash
pip install graphifyy
```

Daftarkan skill-nya ke Claude Code:

```bash
graphify install --platform claude
```

Perintah ini menyalin skill ke `~/.claude/skills/graphify/`. Skill jadi tersedia di **semua project**, bukan cuma folder tempat kamu menjalankannya.

### Catatan Windows

PowerShell 5.1 tidak mengenal `&&`. Pemisah perintahnya `;`

```bash
cd "C:/path/ke/vault"; graphify install --platform claude
```

Kalau `graphify` tidak dikenali setelah install, panggil lewat path penuh:

```bash
& "$env:APPDATA\Python\Python310\Scripts\graphify.exe" install --platform claude
```

### Dua varian install — bedanya besar

| Perintah | Yang berubah |
|---|---|
| `graphify install --platform claude` | Hanya menyalin skill. Config tidak disentuh. |
| `graphify install` (tanpa flag) | Menurut kode installer: juga menulis section ke `CLAUDE.md` dan memasang dua PreToolUse hook di `.claude/settings.json`, sehingga Claude mampir ke graph sebelum tiap Grep/Read/Glob. |

Varian kedua mengubah perilaku Claude Code secara permanen di project itu. Sadari sebelum menjalankannya.

## 3.3 Sebelum build — buang sampahnya dulu

**Ini langkah yang paling sering dilewat dan paling mahal akibatnya.**

Buat `.graphifyignore` di root folder yang mau dipetakan. Sintaksnya sama dengan `.gitignore`:

```
.obsidian/
.git/
*.min.js
*.bundle.js
graphify-out/
```

Graphify sudah melewati `node_modules`, `__pycache__`, `dist`, `build`, `target`, dan folder venv secara bawaan. Yang tidak dia tahu adalah folder khas domainmu — misal folder plugin Obsidian.

Kenapa penting: build pertama di vault POS menghasilkan 3.588 node, dan **3.191 di antaranya berasal dari satu file** — bundle Excalidraw 5,1 MB di `.obsidian/plugins/`. 89% isinya sampah vendor. Setelah dikecualikan: 385 node.

## 3.4 Build

Di dalam Claude Code:

```
/graphify .
```

Titik itu berarti folder saat ini. Bisa juga diberi path, URL GitHub, atau beberapa repo sekaligus untuk digabung.

Yang terjadi berurutan:
1. Deteksi file dan klasifikasi (kode / dokumen / paper / gambar / video)
2. Ekstraksi AST untuk kode — cepat, gratis
3. Ekstraksi semantik untuk dokumen — paralel, pakai LLM
4. Bangun graph, deteksi komunitas, hitung god node
5. Pemeriksaan integritas
6. Penamaan komunitas
7. Tulis output

Flag yang sering dipakai:

```
/graphify . --mode deep      ekstraksi lebih agresif, lebih banyak edge INFERRED
/graphify . --update         hanya file baru/berubah
/graphify . --obsidian       ekspor jadi vault Obsidian
/graphify . --no-viz         lewati HTML, hemat waktu di graph besar
```

## 3.5 Output

Semuanya masuk ke `graphify-out/`:

| File | Isi |
|---|---|
| `graph.html` | Graph interaktif, buka di browser, tanpa server |
| `graph.json` | Data mentah, siap dipakai program lain |
| `GRAPH_REPORT.md` | Laporan audit: god node, koneksi tak terduga, biaya token |
| `obsidian/` | Satu note per node + `graph.canvas` (kalau `--obsidian`) |
| `cache/` | Cache SHA256 supaya build ulang tidak mengulang kerja |

## 3.6 Membaca laporannya

**Komunitas** — kelompok yang terbentuk sendiri. Di vault POS: 24 komunitas dari 55 note asli. Waiting List, KDS Lite, QA Test Case, Kritik Desain Keranjang, QR Management. Ini peta wilayah dokumentasi, digambar oleh strukturnya sendiri.

**God node** — simpul paling terhubung:

```
Riset Workflow Handoff UI/UX↔QA↔DEV   19 edge
Workflow Test Case: Vault → Sheet     12 edge
ValidationPopup (master component)    11 edge
Context Map                           11 edge
```

Bacaannya: kalau salah satu dari empat ini berubah, banyak dokumen lain ikut goyah. Informasi berguna sebelum mengubah sesuatu.

**Koneksi tak terduga** — bagian yang bikin ruangan diam:

- `QR Statis per Meja` ↔ `Struk Fisik dengan Nomor Antrian dan QR` — Self Order dan Waiting List memakai pola QR yang sama, tidak pernah ada yang menuliskannya
- `Multi-Device Satu Open Bill` ↔ `Pool Antrian Terintegrasi` — masalah state bersama yang identik di dua fitur berbeda
- `Kitchen Ticket Berlabel PAID` ↔ `Fallback QR saat Printer Error` — dua fitur bergantung pada printer yang sama

## 3.7 Jejak audit — jual poin ini keras

Tiap edge diberi label:

| Label | Artinya |
|---|---|
| `EXTRACTED` | Tertulis eksplisit di dokumen. Skor 1.0 |
| `INFERRED` | Dugaan mesin, dengan skor keyakinan 0,55–0,95 |
| `AMBIGUOUS` | Mesin ragu, sengaja tidak dibuang. Skor 0,1–0,3 |

Ini yang membedakan graph dari jawaban chatbot. Graph tidak minta dipercaya bulat-bulat — tiap garis bisa dilacak asalnya. Untuk audiens dev, ini alasan graph layak dipakai sebagai alat kerja.

## 3.8 Bertanya ke graph

Setelah graph ada, pertanyaan dijawab dari graph, bukan dengan membaca ulang semua file:

```bash
graphify query "bagaimana alur pembayaran QRIS sampai meja terisi"
```

```bash
graphify path "ValidationPopup" "SO_PRD_MVP"
```

```bash
graphify explain "Pool Antrian Terintegrasi"
```

`query` menelusuri graph dan menyusun konteks ringkas. `path` mencari rantai terpendek antara dua konsep. `explain` menjelaskan satu node beserta tetangganya.

## 3.9 Melihatnya di dalam Obsidian

```bash
graphify export obsidian
```

Menghasilkan satu note per node plus `graph.canvas`. Tiap note berisi frontmatter (asal file, komunitas, tag) dan daftar Connections berupa wikilink berlabel relasi dan tingkat keyakinan:

```markdown
---
source_file: "_meta/context-map.md"
community: "QA Test Case & Coverage"
---
# Context Map — Accurate POS Indonesia

## Connections
- [[Feature Index (WL, SO, KDS)]] - `references` [EXTRACTED]
- [[ONBOARDING — team guide]] - `semantically_similar_to` [INFERRED]
```

Tiga cara melihat:

1. **Canvas** — buka `graphify-out/obsidian/graph.canvas`. Paling enak untuk presentasi.
2. **Graph View bawaan** — note graphify sudah ikut terindeks. Saring dengan `tag:#community/<nama>`, atau sembunyikan dengan `-path:graphify-out`.
3. **Vault terpisah** — *Open folder as vault* ke `graphify-out/obsidian/` kalau tidak mau vault kerja tercampur.

## 3.9a graph.html butuh internet — perbaiki dulu

`graph.html` **bukan file mandiri**. graphify menulisnya dengan tag yang menarik pustaka vis-network dari `unpkg.com`, lengkap dengan hash `integrity` dan tanpa jalur cadangan. Tanpa internet, atau di jaringan yang memblokir CDN, yang muncul halaman kosong.

Ini mengenai dua hal sekaligus: demo saat presentasi, dan pembaca yang mengakses lewat GitLab nanti.

Obatnya satu langkah:

```bash
.\_meta\scripts\graphify-selfcontain.ps1
```

Script itu mengganti tag CDN dengan isi pustakanya, memakai salinan lokal di `_meta/vendor/vis-network.min.js`. Ukuran file naik dari 373 KB ke 1.059 KB, dan hasilnya bisa dibuka offline, dikirim lewat chat, atau disajikan di balik firewall.

Jalankan ulang tiap kali graph dibangun ulang — build menimpa `graph.html` dengan versi CDN lagi.

Salinan pustaka di `_meta/vendor/` diunduh sekali dari unpkg, dan `sha384`-nya sudah dicocokkan dengan atribut `integrity` yang ditulis graphify sendiri. Kalau suatu saat perlu unduh ulang, cocokkan lagi sebelum dipakai.

## 3.9b Menerbitkan ke GitLab supaya bisa dibaca satu tim

Graph yang cuma ada di laptop satu orang tidak menyelesaikan masalah yang dibahas di bagian 1. Supaya berguna, dia harus bisa dibuka orang lain tanpa memasang apa pun.

Jalur paling tahan banting: **GitLab Wiki**. Markdown dirender langsung di browser, bisa dicari, tanpa syarat Pages, tanpa syarat plugin.

```bash
.\_meta\scripts\publish-wiki-gitlab.ps1 -WikiRemote https://gitlab.perusahaan.com/pos/self-order.wiki.git
```

Yang dikerjakan script itu berurutan:

1. `graphify export wiki` — menghasilkan index plus satu artikel per komunitas (35 halaman untuk vault ini)
2. Membersihkan nama file jadi slug aman GitLab, lalu **menulis ulang semua tautan internal** supaya tetap nyambung. Nama asli hasil ekspor mengandung `&`, tanda kurung, dan em-dash yang merusak slug GitLab — 118 tautan internal diperbaiki di langkah ini
3. Clone atau perbarui repo wiki
4. Menaruh semua halaman di bawah folder `graph/`
5. Commit dan push

**Kenapa semuanya masuk folder `graph/`:** GitLab Wiki memperlakukan folder sebagai hierarki halaman. Dengan pemisahan ini, halaman buatan mesin tidak bercampur dengan halaman tulisan tangan, dan pembaruan cukup mengganti isi `graph/` saja. Tanpa itu, sinkronisasi berisiko menghapus halaman yang ditulis orang.

**Kredensial:** script tidak pernah meminta, membaca, atau menyimpan password maupun token. Autentikasi diserahkan ke git — credential manager Windows atau kunci SSH. Pastikan `git push` ke remote itu sudah bisa jalan manual sebelum menjalankan script.

Dua flag untuk berhati-hati:

```bash
.\_meta\scripts\publish-wiki-gitlab.ps1 -WikiRemote <url> -NoPush
```

Mengerjakan semuanya sampai commit lalu berhenti, supaya hasilnya bisa diperiksa dulu. Tambahkan `-SkipExport` kalau graph belum berubah dan cuma mau menerbitkan ulang.

**Yang sengaja tidak diotomasi:** post-commit hook bawaan graphify (`graphify hook install`) memang membangun ulang graph tiap commit — tapi hook itu **hanya mendeteksi perubahan file kode**, dokumen diabaikan. Vault ini isinya 70 dokumen dan 10 file kode, tujuh di antaranya config `.obsidian` yang justru dikecualikan. Hook itu praktis tidak akan pernah menyala di sini. Jangan dipasang; cuma menciptakan ilusi otomatis.

Begitu juga GitLab CI. Ekstraksi struktural jalan mulus di CI karena deterministik dan gratis, tapi vault ini isinya dokumen — dan ekstraksi semantik butuh LLM, artinya `GEMINI_API_KEY` sebagai CI variable dan token terbakar tiap pipeline. Jalankan manual saat spec berubah signifikan, jangan tiap push.

## 3.10 Perawatan dan pencabutan

```bash
graphify update .          re-ekstrak file yang berubah, tanpa LLM untuk kode
graphify watch .           pantau folder, bangun ulang otomatis
graphify uninstall         cabut dari semua platform yang terdeteksi
graphify uninstall --purge cabut sekaligus hapus graphify-out/
```

## 3.11 Demo bagian 3 (12 menit)

1. Buka `graph.html`, sebar, zoom ke satu komunitas
2. Buka `graph.canvas` di dalam Obsidian — graph dan note asli di aplikasi yang sama
3. Buka satu note hasil ekspor, tunjukkan `EXTRACTED` dan `INFERRED` berdampingan
4. Jalankan satu `graphify query` langsung

**Kalimat penutup bagian:** graph tidak menciptakan pengetahuan. Dia menagih janji yang sudah kalian tulis.

---

# BAGIAN 4 — Batas, Biaya, dan yang Tetap Butuh Manusia

Bagian paling penting untuk audiens dev. Ceritakan apa adanya.

## Yang gagal saat pemasangan sungguhan

- `pip install graphify` gagal — nama paketnya `graphifyy`
- `&&` bikin parser error di PowerShell 5.1
- Perintah install diblokir classifier izin karena menyentuh config
- Build pertama: 3.588 node, 89% dari satu bundle Excalidraw

## Biaya yang nyata

Ekstraksi semantik vault POS: **815 ribu token**. Bukan gratis. Untuk korpus kode murni, biayanya nol karena AST tidak butuh LLM — tapi vault spec isinya dokumen semua.

Klaim "hemat token 70x" yang beredar di blog itu materi promosi, bukan angka terukur. Kalau mau dipakai di depan orang, ukur sendiri dulu.

## Harga yang dibayar vault

415 note mesin sekarang duduk di vault berisi 55 note asli. Graph View jadi padat, pencarian tercampur, backlink note asli dapat rujukan dari note mesin. Bisa dikendalikan lewat Settings → Files & Links → *Excluded files*, tapi harus disadari.

## Yang tetap butuh manusia

- Memutuskan mana spec yang berlaku saat ada dua versi
- Menilai edge `INFERRED` benar atau kebetulan
- Menulis spec yang bisa diputus benar-salahnya
- Merawat status dokumen

## Kalimat yang harus disampaikan

> Sampah masuk, peta sampah keluar. Nilai graph datang dari disiplin menulis, bukan dari alatnya.

> Spec basi lebih berbahaya daripada tidak ada spec, karena AI mempercayainya tanpa curiga.

> Kalau tim tidak sanggup merawat spec, jangan mulai SDD. Setengah jalan lebih buruk daripada tidak sama sekali.

---

# BAGIAN 5 — Penutup

Balik ke dua pertanyaan pembuka. Tunjukkan jawabannya sekarang berbeda.

Tutup dengan langkah adopsi terkecil yang bisa dikerjakan besok:

1. Satu folder markdown
2. Satu file indeks
3. Satu konvensi penamaan

Graphify menyusul setelah ada yang layak dipetakan.

---

# Lampiran A — Persiapan Hari-H

| Item | Kenapa |
|---|---|
| Rekam demo Claude membaca vault | Jangan bergantung koneksi saat presentasi |
| Buka `graph.html` sebelum mulai | Loading 376 KB, jangan tunggu di depan orang |
| Siapkan `graph.canvas` di tab Obsidian | Perpindahan cepat |
| Cetak checklist siap-handoff | Bagikan ke audiens, ini yang mereka bawa pulang |
| Siapkan repo contoh netral | Kalau ada peserta di luar tim Self Order |
| Uji proyektor untuk graph gelap-terang | Warna node bisa hilang di proyektor pucat |

# Lampiran B — Angka Rujukan

Semua dari build nyata vault `POS/`, 6 Agustus 2026.

| Metrik | Nilai |
|---|---|
| File terdeteksi | 81 (70 dokumen, 10 kode, 1 gambar) |
| Total kata | ±276.000 |
| Note markdown asli | 55 |
| Node graph (setelah dibersihkan) | 385 |
| Edge | 568 |
| Komunitas | 24 |
| Node build pertama (kotor) | 3.588 — 3.191 dari bundle Excalidraw |
| Biaya token semantik | 814.997 |
| Note hasil ekspor Obsidian | 409 + 1 canvas |
| Ukuran `graphify-out/` | 3,0 MB |
| Kesehatan graph | 0 dangling, 0 missing, 0 self-loop, 15 edge kolaps |

# Lampiran C — Temuan Nyata untuk Ditunjukkan

**Konflik 1.** `ONBOARDING.md` masih mengarahkan orang ke `/prd-agent`, yang sudah dinyatakan deprecated di `CLAUDE.md` dan `_meta/context-map.md`.

**Konflik 2.** Dua file spec di root — `spec-accurate-pos-self-service-open-bill.md` dan `spec-accurate-pos-self-service-prioritaskan-bayar.md` — tidak terdaftar di Feature Index, padahal Feature Index menunjuk Self Order ke `SO_PRD`.

**Konflik 3.** `_meta/Rombak_Catatan_Figma_SelfOrder.md` mencatat dua kasus di mana catatan di Figma menang atas spec di vault — dua sumber kebenaran untuk hal yang sama.

Tidak ada satu pun yang dicari. Graph yang menabraknya.
