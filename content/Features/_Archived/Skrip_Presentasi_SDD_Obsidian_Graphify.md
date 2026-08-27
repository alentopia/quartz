# Skrip Presentasi — SDD, Obsidian, Graphify

> Durasi 120 menit. Audiens UI/UX + Developer.
> Pendamping: [[Materi_Sharing_SDD_Obsidian_Graphify]] (bahan rujukan lengkap).
> Cara pakai: `[LAYAR]` apa yang tampil · `[LAKUKAN]` aksimu · `[KATAKAN]` naskah bicara · `[JEDA]` diam sejenak.
> Naskahnya ditulis buat diucapkan, bukan dibaca. Baca sekali biar dapat nadanya, terus ngomong pakai kalimatmu sendiri. Yang penting urutan dan poinnya.

---

## Sebelum mulai — 15 menit sebelum orang masuk

- [ ] **Jalankan `_meta\scripts\graphify-selfcontain.ps1`.** Wajib. graphify nulis `graph.html` yang narik pustaka dari CDN unpkg.com — tanpa langkah ini, halamannya kosong kalau internet mati atau CDN diblokir jaringan kantor. Ulangi tiap habis build ulang.
- [ ] `graph.html` udah kebuka di tab browser, udah di-zoom pas
- [ ] Obsidian kebuka: `graph.canvas` di satu tab, `context-map.md` di tab lain
- [ ] **Graph View bawaan Obsidian udah dicoba sekali.** Pastikan kotak Search-nya ketemu dan filter `-path:graphify-out` beneran nyusutin graph — ini demo di menit 01:29. Sekalian cek Settings > Files and links > Excluded files, biar kamu ngomongnya yakin, bukan ngutip aku.
- [ ] `SO_Case_QRManagementNegative.md` dan `SO_QRManagement.feature` udah dibuka bersebelahan
- [ ] Terminal kebuka di folder vault, font udah digedein
- [ ] Video rekaman "Claude baca vault" siap diputar
- [ ] Folder tangkapan layar cadangan siap dibuka
- [ ] Notifikasi dimatiin
- [ ] Air minum

---

# [00:00 – 00:08] PEMBUKA

**[LAYAR]** Slide judul aja. Jangan tampilin apa pun yang narik perhatian.

**[LAKUKAN]** Berdiri, jangan ngumpet di belakang laptop.

**[KATAKAN]**

> Sebelum mulai, aku mau nanya dua hal. Jawab santai aja, nggak ada yang dicatat.
>
> Pertama. Siapa yang pernah nanya ke AI soal fitur produk kita — terus jawabannya kedengeran yakin banget, tapi ternyata ngarang?

**[LAKUKAN]** Tunggu tangan naik. Hitung. Sebut angkanya.

**[KATAKAN]**

> Nah. Yang kedua. Kalau kalian mau tahu satu keputusan desain lama itu kenapa diambil, biasanya makan waktu berapa lama? Bukan dokumennya ya — alasannya.

**[LAKUKAN]** Tunggu jawaban. Biasanya keluar "seminggu", "tanya orangnya", "nggak ketemu".

**[KATAKAN]**

> Oke. Dua jam ini aku nggak jualan tool. Aku mau nunjukin kalau dua masalah itu sebenernya satu masalah yang sama, dan ada yang bisa kita lakuin.
>
> Bagiannya tiga. Pertama aturan mainnya — spec-driven development. Kedua, tempat aturan itu tinggal — Obsidian. Ketiga, cara mastiin aturannya masih nyambung — graphify.
>
> Semua contohnya dari vault kita sendiri. Bukan demo yang aku bikin biar kelihatan bagus.

**[JEDA]** Tarik napas. Lanjut.

---

# [00:08 – 00:30] BAGIAN 1 — SPEC-DRIVEN DEVELOPMENT

## [00:08 – 00:12] Konsep pengikat: spec itu kode sumber

**[LAYAR]** Slide tabel pemetaan: Source code / Compiler / Build artifact / Deploy.

**[LAKUKAN]** Ini fondasi seluruh sesi. Santai aja, jangan dikebut. Kalau bagian ini nyantol, sisanya ngalir sendiri.

**[KATAKAN]**

> Sebelum masuk detail, aku kasih satu kerangka dulu. Kalau ini nyantol, dua jam ke depan gampang.
>
> Intinya satu kalimat: **spec kita perlakuin kayak kode sumber.**

**[LAKUKAN]** Tunjuk tabel, baris per baris.

**[KATAKAN]**

> File markdown yang kita tulis, itu source code-nya.
>
> Graphify, itu compiler-nya.
>
> Isi folder graphify-out — graph, laporan, wiki — itu build artifact.
>
> GitLab Wiki, itu deploy-nya.
>
> Dan yang udah kita punya: file Gherkin itu test-nya. Wikilink yang wajib valid itu linter-nya.

**[JEDA]** Dua detik.

**[KATAKAN]**

> Begitu kerangka ini masuk, aturan-aturan lain nggak perlu dihafal. Jatuh sendiri.
>
> Contohnya, arahnya cuma satu — sumber, build, terbit. Nggak pernah balik. Jadi kalau isi wiki-nya salah, yang dibenerin spec-nya, bukan wiki-nya.
>
> Kayak... ya nggak ada orang benerin bug dengan ngedit file exe, kan?

**[LAKUKAN]** Biarkan itu mendarat sebentar.

**[KATAKAN]**

> Terus, hasil build boleh dibuang. Folder graphify-out itu bisa dihapus total, tinggal build lagi. Makanya dia masuk gitignore.
>
> Dan terbit itu artinya nyalin. Bukan nulis. GitLab Wiki cuma etalase.

**[LAKUKAN]** Poin berikutnya buat UI/UX. Lihat ke arah mereka.

**[KATAKAN]**

> Nah ini yang penting buat teman-teman desain. Kerangka ini jawab satu pertanyaan yang biasanya nggak diucapin: ngapain aku capek-capek nulis lima state kalau Figma-nya udah jadi?
>
> Jawabannya: Figma itu artifact. Spec itu sumbernya.

## [00:12 – 00:15] Kenapa sekarang beda

**[LAYAR]** Slide: *"Pembaca spec bukan lagi manusia."*

**[KATAKAN]**

> Dulu kan spec ditulis, dibaca pas kickoff, terus udah. Ngendon di folder. Basi pun nggak masalah, soalnya yang butuh udah tahu duluan.
>
> Sekarang beda. Spec dibaca ulang tiap kali AI nulis kode. Bukan sekali. Tiap kali.

**[JEDA]** Dua detik.

**[KATAKAN]**

> Jadi dokumen yang salah sekarang bukan cuma bikin orang bingung. Dia langsung jadi kode yang salah.
>
> Dan ini sekaligus jawaban kenapa AI ngarang. Bukan karena modelnya bego. Tapi karena model nggak bisa bedain mana yang "lupa kita tulis" dan mana yang "bebas, terserah dia".

**[LAKUKAN]** Ini poin kuncinya. Pelan.

**[KATAKAN]**

> Dua-duanya kelihatan sama aja dari sisi dia. Jadi tiap ada yang bolong, dia isi pakai tebakan yang paling umum. Bukan yang bener buat produk kita.
>
> Makanya kalau kalian ganti model — dari Sonnet ke Opus, dari GPT ke Claude — bolongnya tetep di situ. Yang harus ditutup itu bolongnya, bukan modelnya.

## [00:15 – 00:17] Kenapa ini jadi mendesak

**[LAYAR]** Slide: dua bar, satu panjang, satu pendek.

**[KATAKAN]**

> Satu hal lagi yang berubah, dan ini sering kelewat.
>
> AI nulis kode yang valid secara sintaksis itu cepet banget. Tapi valid nggak sama dengan bener. Kode bisa jalan sempurna dan tetep salah maksudnya.
>
> Masalahnya, kecepatan produksinya naik berkali-kali lipat. Kecepatan review kita? Ya segitu-gitu aja. Nggak kekejar.

**[LAKUKAN]** Tunjuk bar yang pendek.

**[KATAKAN]**

> Jadi yang bisa ngejar cuma satu: spec. Asal spec-nya nulis maksudnya cukup tegas, kita bisa bandingin hasil AI sama maksudnya.
>
> Yang ngejar bukan orangnya. Dokumennya.

## [00:17 – 00:24] Spec yang bagus isinya apa

**[LAYAR]** Slide tabel buruk vs baik.

**[LAKUKAN]** Baca kolom kiri dengan nada datar, kolom kanan dengan nada tegas. Bedanya harus kedengeran.

**[KATAKAN]**

> Oke, jadi spec yang bagus itu isinya apa. Aku nggak akan sebut tiga belas komponen, tenang. Lima aja, yang paling nanggung beban.

**[LAKUKAN]** Sebutkan satu-satu. Satu poin satu tarikan napas, jangan diborong.

**[KATAKAN]**

> **Satu. Kalimatnya harus bisa dijawab bener atau salah.**
>
> "Harus user friendly" itu bukan spec. Coba, siapa yang bisa bilang itu lulus atau gagal? Nggak ada.
>
> Bandingin sama ini: "nomor HP kurang dari sepuluh digit, tombol Konfirmasi mati, muncul pesan Nomor HP belum lengkap." Itu baru spec. Bisa dicek, bisa dites, bisa dibandingin sama hasil AI.
>
> **Dua. ID yang stabil.**
>
> SO-JRN-C7. BR-01. PAGE-04. Kelihatannya sepele ya, tapi ID inilah yang nyambungin spec ke test case ke kode ke laporan coverage. Kalau nggak ada ID, tiap lapisan nulis ulang pemahamannya masing-masing, terus nggak ada yang bisa dicocokin.
>
> Aturannya: ID nggak pernah dipake ulang. Kasusnya mati, ID-nya pensiun.
>
> **Tiga. Lima state per halaman.**

**[LAKUKAN]** Ini buat UI/UX. Pelan.

**[KATAKAN]**

> Happy, empty, loading, error, recovery.
>
> Figma cuma gambar yang happy. Empat sisanya cuma ada di spec.
>
> Jadi kalau AI disuruh bangun UI cuma dari Figma, dia ngirim satu dari lima state — dan kelihatannya udah kelar.
>
> Ini bukan AI-nya kurang pinter ya. Empat state itu emang nggak ada di file yang dia baca.
>
> **Empat. Copy-nya ditulis persis.**
>
> Jangan diparafrase. Kalau tombolnya "Konfirmasi Pesanan", ya tulis "Konfirmasi Pesanan". Jangan ditulis "tombol konfirmasi". Yang diparafrase itu udah pasti berubah pas diimplementasi.
>
> **Lima. Acceptance criteria Given/When/Then.**
>
> Ini yang nanti langsung jadi test. Kalau kosakatanya sama dengan kamus langkah, bisa langsung diturunin jadi file Gherkin tanpa diterjemahin lagi.

**[JEDA]**

**[KATAKAN]**

> Sisanya — konteks, non-tujuan, aktor, business rule — penting semua. Tapi lima tadi yang bikin spec bisa dieksekusi.

## [00:24 – 00:28] Demo: rantainya udah nutup

**[LAYAR]** Obsidian, dua panel bersebelahan.

**[LAKUKAN]** Buka `SO_Case_QRManagementNegative.md` di kiri.

**[KATAKAN]**

> Ini dokumen case negatif dari vault kita. Perhatiin strukturnya — tiap kasus lima blok. Kondisi awal, aksi, hasil yang diharapkan, pesannya persis, terus jalan keluarnya.

**[LAKUKAN]** Buka `SO_QRManagement.feature` di kanan.

**[JEDA]** Diam tiga detik. Biarin mereka bandingin sendiri.

**[KATAKAN]**

> Dan ini file test-nya. Nggak ditulis ulang manual — diturunin dari dokumen sebelahnya.
>
> Kalimat yang sama muncul dua kali. Sekali buat manusia, sekali buat mesin.

**[LAKUKAN]** Tunjuk terminal atau sebut aja.

**[KATAKAN]**

> Terus ada script coverage-matrix yang nyocokin ID kasus di vault sama ID yang muncul di repo otomasi. Jadi kalau ada spec yang belum ada test-nya, ketahuan. Ada test yang nggak ada spec-nya, ketahuan juga.
>
> Spec bikin test. Test balik ngecek spec masih dipatuhi. Nutup.

## [00:28 – 00:30] Satu peringatan

**[LAYAR]** Slide: dua kotak PRD bersebelahan.

**[KATAKAN]**

> Satu peringatan sebelum lanjut, dan ini serius.
>
> Spec basi itu lebih bahaya daripada nggak ada spec. Kenapa? Karena AI percaya aja. Dia nggak curiga.
>
> Contohnya ada di vault kita, sekarang. Kita punya SO_PRD versi 0.2 dan SO_PRD_MVP. Dua-duanya punya PAGE-01 sampai PAGE-11, isinya beda.

**[JEDA]**

**[KATAKAN]**

> Kalau AI diarahin ke vault tanpa dikasih tahu mana yang berlaku, dia bakal nyampur dua-duanya. Dengan pede.
>
> Jadi SDD ini bukan sekali nulis terus kelar. Ada ongkos rawatnya. Nanti aku balik ke sini.

**[LAYAR]** Slide kutipan.

**[KATAKAN]**

> Yang aku pengin kalian bawa dari bagian ini: spec itu bukan formalitas sebelum kerja. Spec itu kerjanya.

---

# [00:30 – 00:52] BAGIAN 2 — OBSIDIAN

## [00:30 – 00:35] Kenapa Obsidian

**[LAYAR]** Slide: *"Yang penting formatnya, bukan aplikasinya."*

**[KATAKAN]**

> Oke, sekarang spec-nya tinggal di mana.
>
> Aku lurusin dulu satu hal biar nggak salah paham: ini bukan promosi Obsidian. Yang penting itu file markdown biasa di disk lokal. Obsidian cuma cara nyaman bacanya.
>
> Kalau besok Obsidian tutup, foldernya ya tetep folder markdown. Nggak ada yang hilang.

**[LAKUKAN]** Empat sifat. Kalau waktu mepet, potong jadi dua pertama aja.

**[KATAKAN]**

> Ada empat hal yang bikin format ini menang buat kerja bareng AI.
>
> **Teks polos.** Bisa di-grep, bisa di-diff, bisa masuk git. AI baca file yang persis sama dengan yang kita lihat. Nggak ada lapisan API, nggak ada yang ilang di tengah jalan.
>
> **Wikilink yang dipaksa valid.** Kalau aku nulis link ke dokumen yang nggak ada, langsung kelihatan. Ini bukan fitur navigasi ya — ini pengecekan yang jalan terus tanpa disuruh.
>
> **Lokal.** Nggak ada rate limit, nggak ada login, nggak ada minta izin server pas AI mau baca tujuh puluh dokumen sekaligus. Kedengeran remeh, sampai kalian nyoba pake Notion sebagai sumber konteks.
>
> **Nggak kekunci vendor.** Udah aku sebut, tapi aku ulang — soalnya ini yang biasanya jadi alasan tim nolak pindah tool.

**[LAKUKAN]** Sebut ini kalau ada yang nanya soal plugin.

**[KATAKAN]**

> Oh iya, vault kita jalan tanpa satu pun community plugin. Obsidian polos.

## [00:35 – 00:40] Cara yang beneran jalan

**[LAYAR]** Slide diagram: `CLAUDE.md → context-map.md → spec`

**[KATAKAN]**

> Nah, ada satu salah kaprah yang mau aku benerin.
>
> Orang sering mikir caranya itu jejelin semua spec ke satu prompt gede. Itu malah bikin hasilnya jelek. Konteks kepanjangan bikin perhatian modelnya melebar, detail pentingnya ketelen.
>
> Yang beneran jalan itu beda: **indeks dibaca di awal, detailnya ditarik pas disebut.**

**[LAKUKAN]** Tunjuk diagram.

**[KATAKAN]**

> Alurnya gini. Sesi mulai, CLAUDE.md kebaca otomatis — itu aturan mainnya, tipis, satu layar. Terus context-map kebaca — itu peta wilayahnya, daftar fitur sama statusnya.
>
> Baru pas aku nyebut Self Order, dia narik SO_PRD. Nggak sebelumnya.

**[LAKUKAN]** Framing ini buat audiens dev. Sebut eksplisit.

**[KATAKAN]**

> Jadi framing-nya bukan "spec sebagai prompt raksasa". Tapi "spec sebagai basis pengetahuan yang bisa dinavigasi".
>
> Bedanya penting. Yang pertama kedengeran boros token. Yang kedua kedengeran kayak arsitektur.

## [00:40 – 00:47] Demo: vault dan cara AI bacanya

**[LAYAR]** Obsidian, `_meta/context-map.md`.

**[LAKUKAN]** Scroll ke tabel Feature Index.

**[KATAKAN]**

> Ini indeksnya. Feature Index — prefix, nama fitur, status, link ke spec utamanya.
>
> Tabel ini yang jawab pertanyaan "spec mana yang berlaku". Kalau ada dokumen yang nggak kedaftar di sini, dia nggak punya status resmi. Nanti aku tunjukin kenapa itu beneran masalah, bukan kelalaian kecil.

**[LAKUKAN]** Putar rekaman: Claude ditanya soal alur Self Order, narik file sendiri. Jangan narasiin tiap detik.

**[KATAKAN]** (sambil video jalan)

> Perhatiin — aku nggak nempel dokumen apa pun. Aku cuma nanya.
>
> Dia baca indeks, nemu Self Order, terus narik file spesifiknya sendiri.

**[JEDA]** Sampai video selesai.

**[KATAKAN]**

> Bedanya sama nanya ke chatbot biasa: jawaban ini bisa dicek sumbernya. Dia nyebut file mana yang dia baca. Kalau salah, kita tahu salahnya di dokumen mana.

## [00:47 – 00:52] Yang Obsidian nggak bisa

**[LAYAR]** Slide: dua kotak.

**[LAKUKAN]** Ini engsel ke bagian 3. Pelan, jangan dikebut.

**[KATAKAN]**

> Tapi ada batasnya. Dan ini yang bikin aku lanjut ke bagian tiga.
>
> Obsidian cuma nyimpen relasi yang **kita tulis sendiri**. Dia nggak tahu relasi yang kita sendiri nggak sadar.
>
> Graph View bawaannya itu cuma gambar wikilink. Jadi kalau dua fitur pake pola yang sama persis tapi nggak pernah saling ditautkan — Graph View diem aja. Nggak ada garisnya.

**[JEDA]**

**[KATAKAN]**

> Dan Obsidian nggak bisa deteksi dokumen yang saling bertentangan. ONBOARDING kita masih promosiin skill yang udah deprecated di CLAUDE.md. Nggak ada yang protes.
>
> Jadi gini: vault bikin konteks jadi tersedia. Tapi dia nggak bikin konteks jadi konsisten.
>
> Kita rehat sepuluh menit. Habis rehat aku tunjukin cara ngeceknya.

---

# [00:52 – 01:02] REHAT

**[LAKUKAN]**
- Buka `graph.html` kalau belum, biarin ke-render
- Cek tab canvas di Obsidian
- Minum
- Pasang timer, jangan kelewat gara-gara ngobrol

---

# [01:02 – 01:32] BAGIAN 3 — GRAPHIFY

## [01:02 – 01:07] Ini apa dan cara kerjanya

**[LAYAR]** Slide alur tujuh langkah.

**[KATAKAN]**

> Graphify itu baca satu folder, hasilnya peta relasi. Bukan ringkasan, bukan pencarian. Peta.
>
> Dan yang dia tunjukin itu bukan pengetahuan baru. Dia nunjukin yang udah kita tulis sendiri, tapi belum pernah kita lihat bareng-bareng.

**[LAKUKAN]** Bagian teknis, buat audiens dev.

**[KATAKAN]**

> Cara kerjanya dua jalur, dan bedanya penting.
>
> Jalur pertama, struktural. Parsing AST, deterministik, lokal, nggak pake LLM, nggak pake API key. Kode dibaca apa adanya. Jalanin dua kali, hasilnya sama persis. Dua puluh enam bahasa.
>
> Jalur kedua, semantik. Buat dokumen, PDF, gambar. Ini yang pake LLM, dan ini yang ada biayanya.
>
> Nggak ada vector store. Nggak ada embedding. Tiap garis di graph ini punya alasan yang bisa ditunjuk — nanti aku buktiin.

**[LAKUKAN]** Tunjuk slide alur.

**[KATAKAN]**

> Prosesnya tujuh langkah. Deteksi file, ekstrak AST, ekstrak semantik, bangun graph, deteksi komunitas, cek integritas, tulis output.
>
> Aku nggak jalanin live ya. Buat vault kita ini makan dua puluh dua menit. Kita langsung ke hasilnya.

## [01:07 – 01:12] Angkanya

**[LAYAR]** Slide angka besar.

**[KATAKAN]**

> Vault kita punya lima puluh lima note asli. Tulisan tangan manusia.
>
> Hasilnya: **tiga ratus delapan puluh lima node. Lima ratus enam puluh delapan garis. Dua puluh empat komunitas.**

**[JEDA]** Beneran diam. Biarin angkanya mendarat.

**[KATAKAN]**

> Lima puluh lima jadi tiga ratus delapan puluh lima. Bukan karena mesinnya nambahin karangan ya — tapi karena tiap dokumen isinya banyak konsep, dan konsep-konsepnya nyambung dengan cara yang belum pernah kita petakan.

## [01:12 – 01:20] Demo: peta, god node, koneksi tak terduga

**[LAYAR]** Browser, `graph.html`.

> Pastikan `graphify-selfcontain.ps1` udah dijalanin (lihat daftar persiapan). Kalau belum, halaman ini butuh internet dan bisa muncul kosong — persis di bagian puncak.

**[LAKUKAN]** Tampilkan penuh. Diam tiga detik sebelum ngomong.

**[KATAKAN]**

> Ini vault kita.

**[JEDA]** Beneran diam. Biarin mereka mindai.

**[LAKUKAN]** Zoom ke satu gugus.

**[KATAKAN]**

> Warna-warna ini komunitas. Nggak ada yang nentuin, kebentuk sendiri dari strukturnya.
>
> Ini Waiting List. Ini KDS Lite. Ini QA Test Case. Yang ini kritik desain keranjang.
>
> Dua puluh empat kelompok. Ini peta wilayah dokumentasi kita, digambar oleh dokumennya sendiri.

**[LAYAR]** Slide god node.

**[KATAKAN]**

> Berikutnya, god node. Simpul yang paling banyak koneksinya.
>
> Nomor satu, dokumen Riset Workflow Handoff, sembilan belas garis. Kedua, Workflow Test Case ke Google Sheet, dua belas. Ketiga, ValidationPopup, sebelas. Keempat, Context Map, sebelas.

**[LAKUKAN]** Jelasin cara bacanya, jangan cuma sebut angka.

**[KATAKAN]**

> Cara bacanya gini: kalau salah satu dari empat ini berubah, banyak dokumen lain ikut goyah.
>
> Itu informasi yang berguna **sebelum** kita ngubah sesuatu. Bukan sesudah ada yang komplain.

**[LAYAR]** Slide tiga koneksi.

**[LAKUKAN]** Ini puncaknya. Pelan banget.

**[KATAKAN]**

> Nah, sekarang bagian yang bikin aku berhenti pas pertama lihat.
>
> Graphify nemu tiga koneksi yang nggak ada di dokumen mana pun.

**[JEDA]** Satu detik.

**[KATAKAN]**

> **Satu.** QR Statis per Meja di Self Order, sama Struk Fisik dengan Nomor Antrian dan QR di Waiting List. Dua fitur beda, pola QR-nya sama persis. Nggak ada satu dokumen pun yang nautin keduanya.
>
> **Dua.** Multi-Device Satu Open Bill, sama Pool Antrian Terintegrasi. Masalah state bareng yang identik. Dipecahin dua kali, terpisah, sama-sama nggak tahu.
>
> **Tiga.** Kitchen Ticket Berlabel PAID, sama Fallback QR saat Printer Error. Dua fitur ini gantung ke printer yang sama. Printernya mati, dua-duanya kena — dan itu nggak tertulis di mana pun.

**[JEDA]** Empat detik. Jangan buru-buru nyelamatin keheningan — ini bagian di mana keheningan yang kerja.

**[KATAKAN]**

> Nggak ada yang nyari ini. Graph-nya yang nabrak.

## [01:20 – 01:26] Tiap garis bisa dilacak

**[LAYAR]** Obsidian, satu note hasil ekspor.

**[LAKUKAN]** Pilih note yang punya EXTRACTED dan INFERRED bersebelahan.

**[KATAKAN]**

> Pertanyaan yang wajar muncul sekarang: dari mana mesin tahu? Ini beneran, atau ngarang?
>
> Lihat ini.

**[LAKUKAN]** Tunjuk daftar Connections.

**[KATAKAN]**

> Tiap garis dikasih label.
>
> **EXTRACTED** artinya tertulis eksplisit di dokumen. Skornya satu koma nol.
>
> **INFERRED** artinya dugaan mesin, ada skor keyakinannya. Nol koma lima lima sampai nol koma sembilan lima.
>
> **AMBIGUOUS** artinya mesinnya ragu — dan sengaja nggak dibuang, biar kita yang mutusin.

**[JEDA]**

**[KATAKAN]**

> Ini yang bedain graph dari jawaban chatbot. Graph ini nggak minta dipercaya bulat-bulat. Tiap garisnya bisa dilacak sumbernya.
>
> Oh iya — tiga koneksi yang aku sebut tadi statusnya INFERRED. Jadi dugaan. Tapi dugaan yang bisa dicek dalam lima menit. Dan pas aku cek, tiganya bener.

## [01:26 – 01:29] Demo: nanya ke graph

**[LAYAR]** Terminal.

**[LAKUKAN]** Ketik dan jalankan:

```
graphify query "bagaimana alur pembayaran QRIS sampai meja terisi"
```

**[KATAKAN]** (sambil jalan)

> Habis graph-nya ada, pertanyaan dijawab dari graph. Bukan dengan baca ulang semua file.
>
> Ini lokal, cepet, nggak manggil LLM.

**[LAKUKAN]** Tunjukin hasilnya. Kalau masih ada waktu, jalanin satu lagi:

```
graphify explain "Pool Antrian Terintegrasi"
```

## [01:29 – 01:31] Demo: cara matiin tampilan graphify

**[LAYAR]** Obsidian, Graph View bawaan. Bukan canvas, bukan graph.html.

**[LAKUKAN]** Buka Graph View. Biarin yang padat itu tampil dulu tiga detik sebelum ngomong.

**[KATAKAN]**

> Satu hal praktis sebelum kita lanjut, soalnya ini yang biasanya bikin orang ragu nyoba.
>
> Ini vault-ku sekarang. Padet banget kan. Dari lima ratus tujuh puluh note di sini, empat ratus lima belas itu buatan mesin. Cuma lima puluh lima yang tulisan kita.

**[LAKUKAN]** Biarkan mereka lihat kepadatannya. Jangan buru-buru.

**[KATAKAN]**

> Nah, pertanyaannya: kalau aku pengin balik ke vault asliku, gimana?

**[LAKUKAN]** Klik kotak Search di panel Graph View. Ketik pelan-pelan biar kelihatan diketik, jangan di-paste.

```
-path:graphify-out
```

**[KATAKAN]**

> Satu baris doang.

**[JEDA]** Biarin graph-nya nyusut. Diam dua detik. Jangan dijelasin, biar mereka lihat sendiri.

**[KATAKAN]**

> Itu vault kita yang asli. Lima puluh lima note. Dan garis-garis di sini itu wikilink yang kita tulis sendiri — bukan tebakan mesin.

**[LAKUKAN]** Hapus filternya. Biarkan membengkak lagi.

**[KATAKAN]**

> Dinyalain lagi kalau butuh.
>
> Jadi hasil mesinnya nggak nyampur permanen sama tulisan kita. Bisa dimatiin kapan aja, dalam dua detik.

**[LAKUKAN]** Sebut versi permanennya, tapi jangan dibuka setting-nya di depan orang — makan waktu dan nggak visual.

**[KATAKAN]**

> Buat sehari-hari ada versi permanennya, di Settings, Files and links, Excluded files. Tambahin folder graphify-out di situ, terus dia diredupin terus — nggak cuma di Graph View, tapi juga di pencarian sama quick switcher.
>
> Filenya nggak kehapus ya, cuma diredupin.

## [01:31 – 01:32] Tutup bagian

**[LAYAR]** Slide kutipan.

**[KATAKAN]**

> Penutup bagian ini: graph nggak nyiptain pengetahuan. Dia nagih janji yang udah kita tulis sendiri.

---

# [01:32 – 01:50] BAGIAN 4 — BATAS, BIAYA, DAN YANG TETEP BUTUH MANUSIA

**[LAYAR]** **Tutup laptop.** Atau slide kosong.

**[LAKUKAN]** Maju selangkah. Bagian ini tanpa layar — biar energi ruangan pulih setelah tiga puluh menit natap graph.

## [01:32 – 01:38] Yang gagal beneran

**[KATAKAN]**

> Sampai sini kedengerannya mulus ya. Sekarang aku ceritain yang nggak mulusnya. Aku ngerjain ini kemarin, dan gagalnya berkali-kali.
>
> **Satu.** Aku ketik `pip install graphify`. Gagal. Nggak ada paketnya. Ternyata nama paketnya `graphifyy`, pake dua huruf y. Sementara perintahnya `graphify`, satu y. Dan itu nggak ditulis di halaman depan dokumentasinya.
>
> **Dua.** Aku sambung dua perintah pake `&&` kayak biasa. Error. PowerShell 5.1 nggak kenal `&&`. Harus pake titik koma.
>
> **Tiga.** Perintah install-nya diblokir sistem izin, gara-gara mau nyentuh file konfigurasi.
>
> **Empat, dan ini yang paling penting.**

**[JEDA]**

**[KATAKAN]**

> Build pertama hasilnya tiga ribu lima ratus delapan puluh delapan node. Aku sempet seneng.
>
> Terus aku cek dari mana asalnya. Tiga ribu seratus sembilan puluh satu node — **delapan puluh sembilan persen** — datang dari satu file doang. Bundle JavaScript plugin Excalidraw. Lima koma satu megabyte. Di folder titik-obsidian.

**[LAKUKAN]** Biarkan itu mendarat.

**[KATAKAN]**

> Jadi graph pertamaku itu peta isi plugin orang lain. Bukan peta pengetahuan kita.
>
> Aku harus build ulang dengan folder itu dikecualiin. Baru dapet tiga ratus delapan puluh lima node yang tadi kalian lihat.
>
> Pelajarannya bukan "graphify jelek" ya. Pelajarannya: sampah masuk, peta sampah keluar.
>
> Dan cara nyegahnya itu satu file kecil namanya titik-graphifyignore, sintaksnya sama kayak gitignore. Lima baris. Itu langkah yang paling sering dilewat, dan paling mahal akibatnya.

## [01:38 – 01:43] Biayanya

**[KATAKAN]**

> Sekarang biaya. Ini yang biasanya nggak disebut di blog-blog.
>
> Ekstraksi semantik vault kita habis **delapan ratus lima belas ribu token**. Sekali build.
>
> Buat proyek yang isinya kode murni, biayanya nol — soalnya AST nggak butuh LLM sama sekali. Tapi vault spec isinya dokumen semua, jadi kena penuh.

**[LAKUKAN]** Bagian ini penting buat kredibilitas. Jangan dilewat.

**[KATAKAN]**

> Terus soal klaim yang beredar. Ada tulisan yang bilang graphify ngirit token tujuh puluh kali lipat. Aku cari sumbernya — itu angka dari tulisan blog promosi. Bukan pengukuran.
>
> Aku nggak akan pake angka itu, dan saranku kalian juga jangan. Kalau mau dipake, ukur sendiri di tempat kita.

**[KATAKAN]**

> Ada biaya lain yang lebih halus. Ekspor Obsidian tadi ngasilin empat ratus lima belas note buatan mesin. Masuk ke vault yang isinya lima puluh lima note asli kita.
>
> Jadi sekarang delapan puluh delapan persen isi vault bukan tulisan kita. Graph View jadi padet, pencarian kecampur.
>
> Tadi udah aku tunjukin cara matiinnya, dan emang gampang. Tapi tetep aja itu biaya — bedanya, ini biaya yang kelihatan dan bisa kita kendaliin. Yang bahaya itu biaya yang nggak kelihatan.

## [01:43 – 01:48] Yang tetep kerjaan kita

**[KATAKAN]**

> Terus apa yang tetep jadi kerjaan kita.
>
> Mutusin spec mana yang berlaku kalau ada dua versi. Mesin nggak bisa.
>
> Nilai garis INFERRED itu bener apa cuma kebetulan. Mesin ngasih skor, kita yang mutusin.
>
> Nulis kalimat yang bisa dijawab bener-salah. Itu skill nulis, bukan skill tool.
>
> Dan ngerawat status dokumen. Draft, review, approved. Nggak ada tool yang bisa maksa kita jujur soal ini.

**[JEDA]**

**[KATAKAN]**

> Satu hal terakhir, dan ini saran serius.
>
> Spec basi lebih bahaya daripada nggak ada spec, karena AI percaya aja tanpa curiga.
>
> Jadi kalau tim belum sanggup ngerawat spec — jangan mulai SDD. Setengah jalan itu lebih buruk daripada nggak sama sekali.

## [01:48 – 01:50] Jembatan ke penutup

**[KATAKAN]**

> Oke. Aku udah kasih kalian versi yang jujur. Sekarang aku tutup.

---

# [01:50 – 02:00] PENUTUP + TANYA JAWAB

## [01:50 – 01:55] Balik ke pembuka

**[LAYAR]** Slide dua pertanyaan pembuka.

**[LAKUKAN]** Tunjuk jawaban yang tadi ditulis di papan.

**[KATAKAN]**

> Di awal aku nanya dua hal.
>
> Pertama, kenapa AI ngarang soal produk kita. Jawabannya: karena dia nggak pernah bacanya. Dan itu bisa kita benerin — bukan dengan ganti model, tapi dengan naruh spec di tempat yang bisa dia baca.
>
> Kedua, berapa lama nyari tahu keputusan lama. Tadi ada yang jawab seminggu.

**[LAKUKAN]** Tunjuk layar graph kalau masih kebuka.

**[KATAKAN]**

> Barusan graph nemu tiga koneksi lintas fitur yang nggak satu orang pun di tim ini tahu. Dalam sekali build.
>
> Bukan karena mesinnya pinter. Tapi karena kita udah nulis semuanya — cuma belum pernah lihat bareng.

## [01:55 – 01:57] Langkah paling kecil

**[LAYAR]** Slide tiga baris.

**[KATAKAN]**

> Kalau kalian mau mulai besok, jangan mulai dari graphify.
>
> Mulai dari tiga ini. Satu, satu folder markdown. Dua, satu file indeks. Tiga, satu konvensi penamaan yang disepakatin sebelum dokumen kedua ditulis.
>
> Udah, itu aja. Graphify nyusul belakangan, setelah ada yang layak dipetakan.

**[JEDA]**

**[KATAKAN]**

> Soalnya kalau mulai dari tool-nya, yang kalian dapet cuma peta kekacauan yang lebih rapi.

## [01:57 – 02:00] Tanya jawab

**[KATAKAN]**

> Oke, aku buka pertanyaan.

**[LAKUKAN]** Kalau hening lebih dari lima detik, pancing sendiri:

**[KATAKAN]**

> Kalau belum ada, aku mulai dari yang biasanya ditanya. "Ini nggak nambah kerjaan?"
>
> Jawabannya: iya, nambah. Di depan. Biayanya di awal, hasilnya belakangan. Yang perlu dihitung itu: berapa sering kita rework gara-gara salah paham spec. Kalau angkanya kecil, ya nggak perlu. Kalau sering, ini murah.

---

# Lampiran — Kalau ada masalah

## Demo macet

Buka folder tangkapan layar. Bilang: *"Ini hasilnya waktu aku coba tadi pagi."* Lanjut.

**Jangan debug di depan orang.** Lima menit kebakar, plus kepercayaan.

## Waktu mepet

Yang boleh dipotong, urut dari paling aman:

1. Demo `graphify query` di 01:26 — potong, cukup disebut ada
2. Lima komponen spec di 00:17 — jadi tiga (kalimat bisa dijawab bener-salah, ID stabil, lima state)
3. Empat sifat Obsidian di 00:30 — jadi dua (teks polos, lokal)

**Jangan dipotong:** tiga koneksi tak terduga (01:12), cerita 89% sampah (01:32), dan langkah terkecil di penutup (01:55). Tiga itu yang mereka bawa pulang.

## Ada yang nyerang "ini cuma hype AI"

Jangan bertahan. Setujui sebagian dulu:

> "Sebagian besar emang hype. Makanya aku ceritain yang gagalnya juga. Yang aku klaim cuma satu: tiga koneksi tadi nyata, dan sebelumnya nggak ada yang tahu. Silakan cek sendiri, file-nya ada."

## Ditanya "berapa lama setupnya"

> "Install graphify lima menit. Bikin vault yang layak dipetakan — itu berbulan-bulan, dan itu emang kerjaannya. Tool-nya bagian yang gampang."

## Ditanya biaya token

Angka jujurnya: 815 ribu token untuk 81 file / 276 ribu kata, sekali build penuh. Build berikutnya jauh lebih murah karena ada cache dan mode `--update`. Untuk korpus kode murni: nol.

## Ditanya "bisa otomatis nggak?"

Bisa, tapi butuh API key. Deteksi perubahan file dan ekstraksi kode itu gratis; ekstraksi makna dokumen butuh LLM. Tanpa API key, ada satu langkah manual yang dijalankan setelah selesai nulis spec. Dengan API key, bisa dijadwalkan harian. Jangan per-file-save — waktu nulis spec kita nyimpen puluhan kali, dan tiap build makan token.
