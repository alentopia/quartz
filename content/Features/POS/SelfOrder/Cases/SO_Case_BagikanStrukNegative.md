# Self Order — Case: Negative Case Bagikan Struk (Validasi Input + Gagal Kirim)

**Status:** Approved (diimplementasi di Figma)
**Tanggal:** 2026-07-27
**Fitur:** Self Order
**Prefix:** SO
**Referensi:** [[SO_PRD]], [[SO_Case_ValidasiKeranjangRedesign]]
**File Figma:** `mAZuRze02w906M6u2EwVWh`, node `563:61` ("Selesai & Struk"), sheet `Bagikan Struk — ShareReceiptSheet` (instance di `1603:35509` / `1134:238` / `758:25025`)

---

## Latar belakang

Sheet "Bagikan Struk" (tab Email / WhatsApp) di layar Success saat ini cuma punya happy path: user isi email/nomor, tap "Kirim struk", selesai. Review negative-case atas node `563:61` nemuin 2 celah:

1. Gak ada state kalau user isi email/nomor dengan format salah.
2. Gak ada state kalau submit gagal (network/server error).

Kedua case ini belum ada varian di Figma sama sekali — bukan drift/redesign, murni nambah state baru.

## Keputusan produk (dikonfirmasi user via brainstorming)

| Topik | Keputusan |
|---|---|
| Nada/rasa | **Tenang & informatif**, konsisten sama redesign popup validasi keranjang ([[SO_Case_ValidasiKeranjangRedesign]]) — pakai token `danger` yang emang udah dipakai sistem ini (border `TextField`/`WhatsAppNumberField` State=Error, bg `Toast`), bukan ilustrasi besar/badge alarm baru. |
| Trigger validasi format | **On blur**, bukan tiap keystroke (hindari nge-nag pas ngetik). Re-check juga kalau field belum pernah di-blur tapi user langsung tap kirim. |
| Tombol kirim (state invalid) | **Disabled** (state abu/muted) selama field kosong atau gagal format check. Baru enable begitu lolos validasi dasar. |
| Tombol kirim (state gagal submit) | **Label dinamis**, bukan tombol baru — "Kirim struk" → "Coba lagi", sama pola CTA-dinamis kayak `ValidationPopup`. Saat proses kirim: label "Mengirim..." + disabled. |
| Sheet saat gagal submit | Tetap kebuka, input value **gak di-reset** — user gak perlu ngetik ulang buat retry. |
| Cakupan pesan error | 1 pesan generik per case (bukan variasi kata per jenis error) — biar scope kecil. |

## Prinsip yang bikin desain ini gak "kelewatan"

- **Severity match reality.** Salah format / gagal kirim itu recoverable dengan retry sendiri, bukan kegagalan sistem besar — makanya visual danger kecil, bukan banner besar/illustrasi.
- **Konsisten sama pola existing.** CTA dinamis udah ada presedennya di `ValidationPopup`/`IssueRow` ([[SO_Case_ValidasiKeranjangRedesign]]). Border error pakai pola yang sama kayak component `TextField` State=Error yang udah ada di Komponen Primitif. Banner pakai component `Toast` yang udah ada (bukan bikin banner baru dari nol).
- **Jangan buang input user.** Retry gagal-kirim gak reset field — kesalahan sistem gak boleh jadi beban ketik ulang buat user.

## Desain komponen

### A. Field error state (Email Input / WhatsAppNumberField)

**WhatsAppNumberField** (component set existing, `1136:194`): ditambah variant baru `State=Error` (id `2136:16887`), konsisten sama variant `State=Error` yang udah ada di component `TextField` (Komponen Primitif, `1162:27`) — border `danger` solid, teks nilai yang diketik pakai warna ink netral (bukan abu placeholder), gak ada link "Ganti" (gak ada yang valid buat di-swap).

**Email Input**: gak dipaksa pakai `TextField` apa adanya (bentuknya beda, gak ada circle-icon di kiri). Dibikin custom frame yang **ukurannya ngikutin Email Input asli** (362×54, radius 18, fill neutral sama kayak default), ditambah circle 32×32 + `Icon/mail` di kiri — pola sama kayak `wa-circle` di `WhatsAppNumberField`, biar 2 channel (Email/WA) konsisten visual kiri-kanan.

| Elemen | Default | State error |
|---|---|---|
| Border | netral (~8% dark, sama kayak Email Input asli) | `danger` token (solid) |
| Icon kiri | — (Email Input asli gak ada icon) | Circle 32×32 putih + `Icon/mail` (Email) / `Icon/whatsapp` (WA, reuse yang udah ada) |
| Helper text di bawah field | placeholder/instruksi biasa ("Struk akan dikirim ke alamat email ini.") | diganti pesan error, warna teks tetap netral (bukan merah) — pembeda cukup dari border+icon |
| Pesan final | — | Email: **"Format email belum valid."** · WA: **"Nomor WhatsApp minimal 10 digit."** |

> **Terjawab 2026-07-30.** Aturan panjang nomor sudah ditetapkan lewat komponen `PhoneField` (lihat `SO-JRN-C6` di [[SO_Case_JourneyMVP]]): **9–12 digit setelah `+62`**. Nomor HP Indonesia `08xx-xxxx-xxxx` panjangnya 10–13 digit termasuk `0`; setelah `0` dibuang sisanya 9–12. Jadi copy **"Nomor WhatsApp minimal 10 digit."** menyebut angka yang salah dan perlu diganti — usul: **"Nomor HP tidak lengkap. Cek kembali sebelum melanjutkan."**, sama dengan copy yang sudah dipakai di layar Konfirmasi Pesanan (`Case: Nomor HP Tidak Valid`), supaya satu pesan untuk satu masalah di seluruh produk.

Catatan lama (sudah tidak berlaku): field WA formatnya `+62 813 8001 2025` (prefix `+62` otomatis, user ketik nomor abis `0`-nya) — dengan format ini, angka minimum yang lazim itu ~9 digit, bukan 10. Belum diubah di Figma (nunggu konfirmasi), dicatat di sini biar gak kelupaan pas ada revisi copy berikutnya.

### B. Tombol kirim — state dinamis

Tombol utama sheet (`Button` di frame `share`) dapat 4 state:

1. **Disabled/muted** — field kosong atau invalid, label tetap "Kirim struk", warna muted.
2. **Enabled** — field valid, warna brand token normal.
3. **Loading** — proses kirim, label "Mengirim...", disabled, (opsional spinner kecil).
4. **Retry** — submit gagal, label "Coba lagi", warna brand token normal (bukan danger — kegagalannya ditunjukin banner, bukan tombolnya).

### C. Banner gagal kirim (baru)

Muncul di atas tombol kirim, di dalam footer container sheet. Reuse component **`Toast`** yang udah ada (`928:5`, id `1147:55`) — bukan bikin banner baru dari nol:

- Bg `danger` solid + teks putih bold, 1 baris (component asli sekalinya udah punya struktur ini).
- Icon diganti dari default `Icon/megaphone` → **`Icon/info`** (`491:12247`) — gak ada icon alert/warning di primitives sistem ini; megaphone salah makna (broadcast, bukan error), `Icon/info` paling deket.
- Copy final: **"Gagal Mengirim Struk. Coba lagi, ya."**
- Tidak ada tombol close terpisah — hilang otomatis begitu user tap "Coba lagi" dan submit baru dimulai (masuk state Loading).

**Catatan aksesibilitas (buat dev handoff, bukan Figma):** banner ini muncul dinamis abis submit gagal. Wajib kasih `role="alert"` + `aria-live="assertive"` di kode React nanti, dan `aria-hidden="true"` di icon (dekoratif) — tanpa ini, screen reader gak bakal announce kegagalan submit sama sekali.

### D. Frame demo — sudah dibikin di Figma

Section `Case: Negative Case — Bagikan Struk (Validasi + Gagal Kirim)` (node `2136:349`), isi 3 frame:

1. **Format Salah — Email** (`2136:350`) — sheet tab Email, field custom (circle `Icon/mail` + border `danger`) + helper "Format email belum valid.", tombol disabled.
2. **Format Salah — WhatsApp** (`2136:441`) — sheet tab WhatsApp, field pakai variant baru `WhatsAppNumberField` State=Error (`2136:16887`) + helper "Nomor WhatsApp minimal 10 digit.", tombol disabled.
3. **Gagal Kirim Struk** (`2136:513`) — banner `Toast` (icon `Icon/info`) "Gagal Mengirim Struk. Coba lagi, ya." di atas tombol, tombol label "Coba lagi".

Komponen system yang ditambah/dipakai ulang (bukan cuma frame demo sekali pakai):
- `WhatsAppNumberField` component set nambah variant `State=Error` — otomatis kepakai di instance manapun yang milih variant ini nanti, gak cuma di frame demo.
- `Toast` component dipakai ulang (icon-swap ke `Icon/info`) buat banner gagal kirim.

## Yang di luar scope (sengaja gak dikerjain)

- Variasi pesan per jenis error (format salah vs kosong vs domain gak valid) — disamain 1 pesan per field.
- Beda pesan network-error vs server-error saat gagal kirim — disamain 1 pesan generik.
- Banner "offline" terpisah (device gak ada koneksi) — dianggap sama kayak gagal kirim biasa.
- Kode/prototype React — ini kerjaan desain Figma; `prototype/src` belum ada komponen sheet Bagikan Struk sama sekali.
