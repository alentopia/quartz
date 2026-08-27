# Self Order — Case: Login Opsional di Konfirmasi + Member POS & Poin

**Status:** Approved
**Tanggal:** 2026-07-21
**Fitur:** Self Order
**Prefix:** SO
**Referensi:** [[SO_PRD]]
**File Figma:** `mAZuRze02w906M6u2EwVWh`, branch kode `redesign/self-order`

---

## Latar belakang

User ingin mengubah alur autentikasi Self Order:

1. **Login yang tadinya di awal dipindah** — tidak lagi jadi gerbang sebelum melihat menu.
2. Login jadi **opsional** dan muncul di **layar Konfirmasi Pesanan**.
3. Login = **isi No. HP saja, tanpa OTP**. Nomor dicek ke data member POS.
4. Kalau **member POS** → nama pelanggan **ketarik otomatis** (read-only) + konteks poin.
5. **Poin didapat setelah transaksi berhasil**, jadi bukan ditampilkan sebagai "bakal dapat" di Konfirmasi.

Catatan kondisi kode saat ini (hasil eksplorasi):
- `app.jsx` **sudah** tidak menaruh login di awal — `startSession()` langsung ke `menu` (komentar: "phone/OTP collected at payment time"). Gerbang login-di-awal yang dimaksud user ada di **alur Figma**, bukan di kode prototype. Jadi untuk kode, poin (1) sebagian besar sudah terpenuhi; yang berubah adalah bentuk pengumpulan data di Konfirmasi.
- `ConfirmScreen` (`screens-checkout.jsx`) saat ini punya blok **"Informasi Pelanggan"** dengan field **Nama + No. WhatsApp + OTP inline** (`verifyOtp`). Desain baru **membuang OTP dan membuang field Nama**.
- State auth global: `phone`, `loggedIn`, `login(num)`, `setPhone` di `app.jsx`. Belum ada konsep **member** maupun **poin**.
- `SO_PRD.md` **tidak** punya konsep member/loyalty/poin — ini fitur baru, di luar PRD sekarang.

## Keputusan produk (dikonfirmasi user via brainstorming)

| Topik | Keputusan |
|---|---|
| Gerbang login di awal | **Dihapus.** Scan QR → langsung Menu. Browsing & keranjang tanpa login. |
| Sifat login | **Opsional.** Guest bisa Bayar / Kirim ke Dapur tanpa login. |
| Verifikasi | **Tanpa OTP.** Cukup isi No. HP → cek data member POS. |
| Wadah login | **Inline** di Konfirmasi (bukan bottom sheet). |
| Bobot & posisi pemicu | **Ringan** (link/dashed, framing "kumpulin poin", bukan tombol solid "Login") dan diletakkan **di paling atas** section Konfirmasi. |
| Field Nama | **Dihapus.** Tidak ada input nama. Nama hanya tampil **read-only** kalau user member. |
| Identitas & poin | Diikat ke **No. HP**, bukan ke nama. |
| Kapan poin didapat | **Di layar Sukses** (setelah bayar). Open Bill: di Sukses **Bayar Semua**, bukan saat Kirim ke Dapur. |
| Nomor untuk struk | **Sekali isi.** No. HP dari Konfirmasi kebawa ke Bagikan Struk (tidak isi ulang). Guest yang skip → diminta di Bagikan Struk. |
| Kasus "bukan member" | **Bukan error.** Nomor tetap disimpan untuk struk, tanpa nama, tanpa peringatan. |

## Prinsip yang bikin desain tidak "ribet"

- **No. HP = identitas + poin.** Yang mengikat akun member adalah nomornya.
- **Nama = read-only** dari akun POS, hanya untuk member; **tidak ada input nama** untuk siapa pun. Ini menghapus konflik "nama manual vs nama data POS" sejak akar.
- **Semua opsional.** Login, nomor, semuanya boleh dilewati.
- **Poin bersifat pasca-transaksi.** Konfirmasi hanya menampilkan konteks (member + saldo), bukan proyeksi perolehan.

## Alur (before → after)

**Sebelum (alur Figma lama):**
```
Scan QR → Login (wajib) → Menu → Keranjang → Konfirmasi → Sukses
```

**Sesudah:**
```
Scan QR → Menu → Keranjang → Konfirmasi [Login opsional inline] → (Bayar/Kirim) → Sukses [+poin bila member]
```

## Desain layar

### A. Konfirmasi Pesanan — blok login di paling atas

Blok pemicu login ada **paling atas** body Konfirmasi (di atas Ringkasan Pesanan & Metode Pembayaran). Bobot ringan supaya jelas opsional.

**State 1 — default (guest, belum login):**
- Baris perk **ringan** (border dashed `t.primary`, bukan tombol solid): ikon `gift/discount` + teks **"Member? Masuk buat kumpulin poin"** + subteks **"Opsional · pakai No. HP"** + chevron ke bawah.
- Di bawahnya hairline, lalu Ringkasan Pesanan + Metode Pembayaran seperti biasa.
- Guest bisa abaikan dan langsung **Bayar**.

**State 2 — dibuka (tap baris perk):**
- Baris perk berubah jadi header collapsible (chevron ke atas).
- Muncul field **No. HP** (`+62` prefix, tabular) + tombol aksi **"Masuk"** bergaya **ghost** (outline `t.primary`, bukan fill).
- Belum ada nama.

**State 3a — member masuk (nomor cocok data POS):**
- Blok berubah jadi **kartu member** (bg `t.primarySoft`): avatar inisial + **"Halo, [Nama]"** (read-only dari akun) + baris **"Member · [saldo] poin"** + aksi teks **"Keluar"**.
- Baris kecil: **"Struk dikirim ke +62 …"**.
- **Tidak ada** angka "bakal dapat poin" (transaksi belum jadi).

**State 3b — bukan member (nomor tidak cocok):**
- **Bukan error.** Tidak ada teks warning/amber.
- Nomor tetap tersimpan (dipakai untuk struk). Tidak ada nama. Boleh lanjut Bayar.
- Idealnya blok kembali tenang / menampilkan konfirmasi netral tipis (mis. "Nomor disimpan untuk struk"), tanpa nuansa kegagalan.

**Aturan CTA:** primary tunggal per layar tetap **Bayar** / **Kirim ke Dapur** (Open Bill). Aksi "Masuk" selalu **sekunder/ghost** → tidak bertabrakan.

**Token/visual:** ikut Design System — `t.primary`, `t.primarySoft`, `t.onPrimary`, `t.faint`, `t.line`, `radius`. Tidak ada hardcode warna.

### B. Layar Sukses — perolehan poin (khusus member)

- Setelah pembayaran berhasil, tampilkan blok poin: **"+[N] poin didapat"** + **"Saldo baru: [saldo+N]"** (bg `t.primarySoft`, ikon gift).
- **Non-member / guest:** layar Sukses normal, tanpa blok poin.
- **Open Bill:** blok poin muncul di layar Sukses **Bayar Semua (Settle)**, bukan saat Kirim ke Dapur (order individual belum jadi transaksi selesai).

### C. Bagikan Struk — nomor kebawa

- Jika No. HP sudah ada dari Konfirmasi (login member **atau** — bila kelak ada input manual — ketikan) → field WhatsApp **prefilled**, user tinggal "Kirim struk". Ada aksi "Ubah" untuk nomor lain.
- Guest yang tidak pernah kasih nomor → field kosong, baru diminta di sini.

## Model data & state (kode prototype)

Tambahan pada store `app.jsx`:

- `member` — objek member yang sedang login, atau `null`. Bentuk: `{ phone, name, points }`. Diisi saat lookup nomor cocok.
- `lookupMember(phone) → member | null` — cek nomor ke "data POS". Di prototype: dataset dummy di `data.jsx` (mis. beberapa nomor terdaftar). Tidak ada OTP.
- `pointsEarned(total) → N` — aturan perolehan poin dari nilai transaksi (mis. 1 poin / Rp1.000, dibulatkan). Dipakai di layar Sukses.
- `phone` global tetap jadi **satu sumber nomor** (Konfirmasi → Bagikan Struk). `login()` lama (set `loggedIn`) dipertahankan/diselaraskan; `member` jadi turunannya.
- `submitOrder(info)` sudah menerima `{ name, phone }` untuk `customer` — sesuaikan agar `name` diisi dari `member.name` bila ada, `phone` dari state. **Field nama manual dibuang** dari UI.

Poin **tidak** dikreditkan di Konfirmasi — hanya dihitung/ditampilkan di Sukses (dan disimpan ke `member.points` secara simulasi).

## Dampak Figma

- **Konfirmasi**: perbarui frame Konfirmasi → hapus field Nama & OTP; tambah blok login-opsional di atas dengan state default / dibuka / member / bukan-member.
- **Komponen baru**: kartu member (avatar + nama + poin + Keluar) sebagai komponen; baris perk "kumpulin poin" (dashed) sebagai komponen/varian.
- **Sukses**: tambah blok "poin didapat" (varian member) + varian non-member.
- **Bagikan Struk**: state nomor prefilled vs kosong.
- Reuse token & primitif yang ada (mis. TextField bila sudah ada dari migrasi sebelumnya).

## Kasus & edge cases

| Kasus | Perilaku |
|---|---|
| Guest tidak login, tidak isi nomor | Bayar langsung. Struk: nomor diminta di Bagikan Struk. |
| Guest isi nomor tapi bukan member | Nomor disimpan untuk struk. Tanpa nama, tanpa poin, tanpa error. |
| Member login | Nama read-only + saldo di Konfirmasi. Poin dikreditkan di Sukses. |
| Member login lalu "Keluar" | Kembali ke state default (guest). Nomor ikut dilepas atau dipertahankan untuk struk — **default: dilepas** (biar jelas keluar). |
| Ganti nomor setelah member masuk | Lookup ulang; kartu member ter-update / kembali guest bila nomor baru bukan member. |
| Open Bill (Kirim ke Dapur) | Login opsional sama. Poin **belum** dikredit; menyusul di Sukses Bayar Semua. |
| Nomor member dipakai orang lain | Lihat Risiko. |

## Risiko & keputusan yang disadari

- **Tanpa OTP → tidak ada verifikasi kepemilikan nomor.** Siapa pun yang tahu nomor member bisa "menarik" nama + mengaitkan poin ke akun tersebut. Untuk konteks self-order poin, risiko dinilai kecil & diterima **untuk sekarang**. Jika kelak butuh aman, OTP bisa ditambah sebagai langkah di dalam alur "Masuk" (dan wadah bisa berubah jadi bottom sheet) tanpa membongkar model data (nomor tetap identitas).
- **Poin/member belum ada di PRD.** Perlu ditambahkan ke `SO_PRD.md` bila jadi fitur resmi (di luar scope spec ini kecuali diminta).

## Non-goals

- Tidak membangun sistem loyalty/poin sungguhan (integrasi POS nyata) — cukup simulasi di prototype.
- Tidak menambah OTP.
- Tidak menambah field nama manual.
- Tidak mengubah alur pembayaran, pajak, promo, atau Open Bill selain penempatan poin di Sukses.
- Tidak retrofit login ke layar lain (menu/keranjang) — login hanya di Konfirmasi.

## Pertanyaan terbuka

1. Aturan perolehan poin persisnya (rasio Rp→poin, pembulatan)? — default sementara 1 poin / Rp1.000, bisa disesuaikan.
2. Saat "Keluar", nomor untuk struk dilepas atau dipertahankan? — default spec: dilepas.
3. Sumber "data POS" di prototype (dataset dummy di `data.jsx`) — daftar nomor member contoh perlu ditentukan.
