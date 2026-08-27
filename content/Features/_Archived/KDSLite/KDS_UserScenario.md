# KDS_UserScenario — KDS Lite (Antrean Pickup)

> [!warning] Arsip — KDS Lite tidak jadi dipakai
> Diputuskan 2026-08-14: merchant pakai **KDS penuh** (Figma `Kitchen Display Sistem (KDS)`, file `8Uf9bMrBiCf8sQjkX5sUMl`), bukan KDS Lite. Dokumen ini dan seisi folder `KDSLite_Archived/` disimpan sebagai referensi historis, bukan spec aktif. Spec KDS penuh menyusul di `Features/KDS/`.

**Status:** Draft (Archived)
**Versi:** 0.1
**Tanggal:** 2026-08-05
**Author:** PM & Claude Code
**Sumber:** [[KDS_Overview]]

---

## Tujuan Dokumen

1. Bahan **usability test** untuk memutuskan layout staff app: **2 tab terpisah** vs **split view satu layar** (lihat [[KDS_Overview#12. Open Questions (TBD)|Open Questions]]).
2. Referensi skenario untuk desain Figma & QA — tiap skenario nanti bisa diturunkan jadi case (`Features/KDSLite/Cases/`).

Tiap skenario punya: konteks naratif, langkah, kriteria sukses, dan **metrik yang dicatat saat tes**. Kolom "Menguji" menunjukkan pertanyaan desain mana yang dijawab skenario itu.

---

## Persona

| Kode | Persona | Konteks |
|---|---|---|
| P1 | **Staff kios tunggal** — satu orang merangkap masak + serah terima. Device: HP atau tablet kecil di dekat kompor/counter. Tangan sering basah/berminyak, perhatian utama ke masakan, bukan ke layar. | Kios kecil, ±30–60 order/hari |
| P2 | **Staff counter pickup resto** — dedikasi di counter, pegang tablet/desktop. Jam sibuk bisa 10+ order aktif bersamaan. | Resto kecil–menengah, multi-channel (Kasir, Self Order, Kiosk) |
| P3 | **Customer** — menunggu pesanan sambil lihat Monitor Antrian (TV). Tidak menyentuh sistem apapun. | Jarak pandang ke TV ±3–6 meter |

---

## Skenario Staff App

### S1 — Alur normal satu order (happy path)

**Persona:** P1 · **Menguji:** alur dasar, jumlah tap minimal

> Ani jaga kios sendirian. Order A-041 (Self Order) masuk, otomatis muncul di Diproses. Ani masak. Selesai masak, dia tandai siap sambil tangan masih setengah kotor. Customer datang, cocokkan nomor, Ani serahkan makanan dan tandai selesai.

**Langkah:**
1. Order A-041 masuk → muncul otomatis di Diproses (tanpa aksi staff — BR-01).
2. Ani tap **Tandai Siap** di kartu A-041.
3. Kartu pindah ke Siap; nomor A-041 muncul di kolom Ready Monitor Antrian.
4. Customer datang → Ani tap **Selesai**.
5. Kartu hilang dari staff app dan Monitor Antrian (BR-04).

**Kriteria sukses:** total **2 tap**, nol navigasi, Ani tidak pernah bertanya "kartunya kemana?".
**Metrik tes:** jumlah tap, waktu langkah 2 dan 4, salah tap.

---

### S2 — Jam sibuk, banyak order (glanceability)

**Persona:** P2 · **Menguji:** FIFO, hierarki visual, "fokus kemana"

> Jam makan siang. 6 order di Diproses, 2 di Siap. Dapur menyerahkan 2 makanan jadi sekaligus ke counter: A-043 dan Meja 7. Budi harus menemukan dua kartu itu cepat dan menandainya siap, tanpa salah kartu.

**Langkah:**
1. Kondisi awal: 6 kartu Diproses (campuran nomor antrian & nomor meja, 3 channel), 2 kartu Siap.
2. Budi cari kartu A-043 → tap **Tandai Siap**.
3. Budi cari kartu Meja 7 → tap **Tandai Siap**.

**Kriteria sukses:** kedua kartu ditemukan ≤3 detik masing-masing; tidak ada tap di kartu yang salah; Budi bisa jawab "berapa order yang lagi nunggu diambil?" tanpa navigasi.
**Metrik tes:** waktu cari per kartu, salah tap, jawaban benar/salah pertanyaan jumlah order Siap.
**Catatan pembanding layout:** di versi tab, catat berapa kali Budi pindah tab untuk menjawab pertanyaan terakhir.

---

### S3 — Salah tap → Undo (recovery, Goal G3)

**Persona:** P2 · **Menguji:** kecepatan koreksi, biaya navigasi saat panik

> Budi mau menandai A-044 siap, tapi jarinya kena kartu A-045 di sebelahnya. Dia sadar 2 detik kemudian: A-045 masih digoreng. Di Monitor Antrian, customer A-045 sudah melihat nomornya pindah ke Ready dan mulai berdiri.

**Langkah:**
1. Budi tap **Tandai Siap** di A-045 (salah).
2. Sadar salah → temukan A-045 di Siap → tap **Undo**.
3. A-045 balik ke Diproses (BR-03); hilang dari kolom Ready Monitor.
4. Budi tap **Tandai Siap** di A-044 (yang benar).

**Kriteria sukses:** koreksi (langkah 2–3) selesai ≤5 detik; nol kehilangan data.
**Metrik tes:** waktu dari sadar-salah sampai Undo tertekan; jumlah navigasi (pindah tab/scroll) yang dibutuhkan.
**Catatan pembanding layout:** skenario ini pembeda paling tajam tab vs split — di tab, langkah 2 butuh pindah tab dulu.

---

### S4 — Customer datang saat staff sibuk (visibilitas kolom Siap)

**Persona:** P1 · **Menguji:** awareness status Siap tanpa interaksi

> Ani lagi fokus masak 4 order. Customer A-039 — yang pesanannya sudah 5 menit di Siap — datang ke counter: "Mbak, A-039 udah?". Ani lirik layar dari jarak setengah meter, tangan penuh.

**Langkah:**
1. Kondisi awal: 4 kartu Diproses, 1 kartu Siap (A-039).
2. Ani lirik layar → konfirmasi A-039 ada di Siap → serahkan makanan.
3. Tap **Selesai**.

**Kriteria sukses:** Ani menjawab customer **tanpa menyentuh layar** (cukup lirik). Selesai = 1 tap.
**Metrik tes:** apakah Ani perlu menyentuh/navigasi sebelum bisa menjawab; waktu lirik-ke-jawab.
**Catatan pembanding layout:** di tab, jika posisi terakhir Ani di tab Diproses, dia harus tap dulu sebelum bisa menjawab — catat kejadian ini.

---

### S5 — Salah tap "Selesai" (aksi destruktif) ⚠

**Persona:** P2 · **Menguji:** jaring pengaman aksi destruktif — gap spec, lihat [[KDS_Overview#12. Open Questions (TBD)|OQ]]

> Dua kartu di Siap: A-039 dan A-040. Customer A-039 datang. Budi buru-buru, tap **Selesai** di A-040. Order A-040 lenyap dari sistem — padahal customer A-040 masih duduk menunggu, dan nomornya ikut hilang dari Monitor Antrian.

**Langkah:**
1. Budi tap **Selesai** di A-040 (salah).
2. *(Perilaku diharapkan — belum ada di spec v0.1)*: sistem memberi jalan pulih, mis. snackbar "A-040 selesai · [Urungkan]" 5 detik, atau riwayat "Selesai" dengan tombol kembalikan.
3. Budi kembalikan A-040 ke Siap; tap **Selesai** di A-039 yang benar.

**Kriteria sukses:** A-040 bisa dikembalikan tanpa buat ulang order; customer A-040 tidak kehilangan tempat di antrean.
**Metrik tes:** apakah peserta menyadari kesalahannya; berapa lama; apa yang mereka coba lakukan untuk memulihkan.
**Status:** skenario ini **mengekspos gap** — spec v0.1 belum mendefinisikan recovery Selesai. Hasil tes jadi input keputusan (snackbar undo vs riwayat/recall).

---

### S6 — Order nyangkut (customer tak kunjung ambil)

**Persona:** P2 · **Menguji:** kebijakan order menginap — gap spec

> Tutup toko jam 21:00. A-037 sudah 40 menit di Siap — customer-nya pergi tanpa mengambil. Kalau dibiarkan, besok pagi Monitor Antrian masih menampilkan A-037 di Ready.

**Langkah:**
1. *(Perilaku diharapkan — belum ada di spec v0.1)*: staff menandai Selesai manual saat closing, atau sistem auto-clear pada jam tutup.

**Kriteria sukses:** tidak ada order kemarin yang tampil hari berikutnya.
**Status:** gap — butuh keputusan PM (auto-clear jam tutup / timer / manual saja). Benchmark: Toast auto-remove pada closeout hour.

---

### S7 — Mode HP (tab + badge + snackbar)

**Persona:** P1 · **Menguji:** kompromi layout 1 kolom, feedback tanpa perpindahan kartu terlihat

> Ani pakai HP. Layar hanya muat satu kolom: tab "Diproses (3)" aktif, tab "Siap (1)" di sebelahnya. Dia tandai A-042 siap — kartu hilang dari list yang sedang dilihat.

**Langkah:**
1. Ani tap **Tandai Siap** di A-042 (di tab Diproses).
2. Kartu hilang dari tab Diproses; snackbar "A-042 siap · [Undo]" muncul 3–5 detik; badge tab berubah: Diproses (2), Siap (2).
3. Customer datang → Ani tap tab **Siap** → tap **Selesai** di A-042.

**Kriteria sukses:** Ani tidak bingung kartu "hilang" (snackbar + badge cukup meyakinkan); Undo dari snackbar berfungsi tanpa pindah tab.
**Metrik tes:** reaksi saat kartu hilang (bingung/tidak); apakah badge count diperhatikan.

---

## Skenario Monitor Antrian (Customer)

### S8 — Menunggu dan melihat nomor pindah

**Persona:** P3 · **Menguji:** legibilitas jarak, kejelasan perpindahan status

> Citra pesan lewat Kiosk, dapat nomor A-041. Duduk 5 meter dari TV. Nomornya tampil di On Progress. Beberapa menit kemudian nomornya pindah ke Ready to Pick Up — Citra sadar tanpa ada yang memanggil, berdiri, ambil pesanan.

**Langkah:**
1. Citra menemukan A-041 di kolom On Progress dari jarak 5 m.
2. Staff tandai siap → A-041 pindah ke Ready dengan highlight singkat.
3. Citra menyadari perpindahan ≤10 detik tanpa menatap terus-menerus.
4. Setelah diambil, staff tap Selesai → A-041 hilang dari TV.

**Kriteria sukses:** nomor terbaca jelas dari 5 m (tinggi digit ±5–7 cm); perpindahan kolom tertangkap mata meski Citra sedang main HP (highlight/animasi cukup mencolok).
**Metrik tes:** jarak baca maksimal; waktu sadar-pindah.

---

### S9 — Undo dilihat customer

**Persona:** P3 · **Menguji:** efek koreksi staff di sisi customer (pasangan S3)

> Nomor A-045 muncul di Ready. Dodi berdiri, jalan ke counter. Saat dia sampai, staff sudah Undo — A-045 balik ke On Progress.

**Langkah:**
1. A-045 tampil di Ready (salah tap staff).
2. Staff Undo → A-045 pindah balik ke On Progress.
3. Dodi di counter; staff menjelaskan pesanan belum siap.

**Kriteria sukses:** posisi A-045 di layar konsisten dengan penjelasan staff (tidak hilang total — masih terlihat di On Progress, jadi Dodi percaya ordernya aman).
**Catatan:** momen ini interaksi manusia; sistem hanya wajib memastikan nomor tidak lenyap. Sudah dijamin BR-03.

---

## Matriks Skenario × Pertanyaan Desain

| Skenario | Tab vs Split | Recovery | Mobile | Monitor TV |
|---|---|---|---|---|
| S1 happy path | ✓ (baseline tap) | | | |
| S2 jam sibuk | ✓✓ (glanceability) | | | |
| S3 salah tap → Undo | ✓✓ (biaya navigasi) | ✓ | | |
| S4 customer datang | ✓✓ (awareness Siap) | | | |
| S5 salah Selesai | | ✓✓ (gap spec) | | |
| S6 order nyangkut | | ✓ (gap spec) | | |
| S7 mode HP | | ✓ | ✓✓ | |
| S8 nomor pindah | | | | ✓✓ |
| S9 undo di TV | | ✓ | | ✓ |

**Protokol tes tab-vs-split:** jalankan S1–S4 pada dua prototype (versi tab, versi split asimetris) dengan 2–3 peserta per versi, urutan versi diacak. Catat: total tap, waktu per skenario, salah tap, jumlah pindah-tab/navigasi, dan jawaban pertanyaan awareness (S2, S4). Keputusan layout diambil dari data ini, bukan preferensi.

---

## Dokumen Terkait

- [[KDS_Overview]] — spec induk (state machine, business rules, identifier).

---

*Dokumen ini dibuat 2026-08-05 sebagai bahan usability test layout staff app dan referensi desain.*
