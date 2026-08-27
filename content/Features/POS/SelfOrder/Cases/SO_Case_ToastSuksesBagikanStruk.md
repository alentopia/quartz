# Self Order — Case: Toast Sukses Bagikan Struk

**Status:** Review (desain disetujui, belum diimplementasi di Figma)
**Tanggal:** 2026-07-27
**Fitur:** Self Order
**Prefix:** SO
**Referensi:** [[SO_PRD]], [[SO_Case_BagikanStrukNegative]]
**File Figma:** `mAZuRze02w906M6u2EwVWh`, node `563:61` ("Selesai & Struk"), sheet `Bagikan Struk — ShareReceiptSheet`

---

## Latar belakang

Review negative-case sheet "Bagikan Struk" ([[SO_Case_BagikanStrukNegative]]) nemuin banner **gagal** kirim udah dibikin, tapi state **sukses** kirim gak ada sama sekali — submit sukses gak ada konfirmasi apa pun ke user. Gap ini ditemuin pas review balik, bukan bagian dari negative-case asli (ini positive-confirmation gap, bukan error state).

## Keputusan produk (dikonfirmasi user via brainstorming)

| Topik | Keputusan |
|---|---|
| Trigger & flow | Submit "Kirim struk" sukses → sheet **langsung nutup** → toast muncul ngambang di Success screen (bukan di dalam sheet, beda sama pola banner-gagal yang nempel di dalam sheet). |
| Copy | **Generik**: "Struk berhasil dikirim." — sama buat Email maupun WhatsApp, gak dibedain per channel. |
| Dismiss | **Auto-dismiss ~3 detik**, gak ada tombol close manual. |
| Component | Reuse `Toast` (`928:5`, id `1147:55`) yang udah dipakai buat banner gagal-kirim — ditambah variant baru `Tone=Success`, bukan bikin component baru. |
| Warna | Bind ke token `primary` (teal brand) — sistem ini gak punya token "success" khusus; `primary` udah jadi warna konfirmasi/normal di `Button` dkk, jadi dipakai ulang, bukan bikin token baru. |
| Icon | `Icon/checkCircle` (udah ada di primitives) — senada sama checkmark di Hero Success screen, bukan icon baru. |

## Prinsip yang bikin desain ini gak "kelewatan"

- **Reuse component, bukan reinvent.** `Toast` udah ada dan udah dipake buat kasus gagal — nambah 1 variant (`Tone=Success`) lebih konsisten daripada bikin komponen notifikasi baru.
- **Gak nambah token baru buat 1 kasus.** `primary` udah cukup nyampein "positif/normal" — nambah token "success" terpisah cuma buat 1 toast itu over-engineering untuk kebutuhan sekarang.
- **Simetris sama pola gagal, tapi gak dipaksa sama persis.** Gagal nempel di dalam sheet (karena user masih perlu retry di situ); sukses floating di Success screen (karena sheet udah gak relevan lagi begitu berhasil) — treatment beda sesuai kebutuhan, bukan disamain asal konsisten.

## Desain komponen

### A. `Toast` — variant baru `Tone=Success`

Component set `Toast` sekarang cuma py 1 bentuk (bg bound ke variable `toast error`, dipake buat kasus gagal). Ditambah variant `Tone=Success`:

| Elemen | Tone=Error (existing) | Tone=Success (baru) |
|---|---|---|
| Bg | `toast error` (= token `danger`) | Token `primary` |
| Icon | `Icon/info` (di-set manual per instance) | `Icon/checkCircle` |
| Teks | Putih bold, 1 baris | Putih bold, 1 baris (sama style) |

Property `icon` (INSTANCE_SWAP) tetap dipertahankan biar fleksibel kalau ada kasus lain nanti.

### B. Perilaku di sheet "Bagikan Struk"

1. User tap "Kirim struk" (state valid, gak lagi disabled).
2. Submit sukses → sheet ditutup (state sama kayak user tap tombol close/X manual).
3. Toast instance (`Tone=Success`, teks "Struk berhasil dikirim.") muncul ngambang di atas Success screen.
4. Toast auto-hilang sendiri ~3 detik, gak ada interaksi user yang dibutuhin.

### C. Frame demo yang perlu dibikin di Figma

Section baru (atau tambahan di section `Case: Negative Case — Bagikan Struk` yang udah ada, direname jadi mencakup positive case juga) berisi 1 frame:

1. **Sukses Kirim Struk** — Success screen (tanpa sheet, sheet udah ketutup) + toast `Tone=Success` "Struk berhasil dikirim." ngambang di posisi standar toast (bottom-anchored).

## Yang di luar scope (sengaja gak dikerjain)

- Beda copy per channel (Email vs WhatsApp) — disamain 1 pesan generik.
- Animasi masuk/keluar toast (slide/fade) — itu detail motion, bukan scope desain visual ini.
- Token warna "success" baru — pakai `primary` yang udah ada.
- Kode/prototype React — ini kerjaan desain Figma; `prototype/src` belum ada komponen sheet Bagikan Struk sama sekali.
