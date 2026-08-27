---
tags: [self-order, flowchart]
status: Draft
---

# Self Order — Flowchart (Scan QR → Checkout)

> Sumber alur: [[SO_PRD#5. Page Map|SO_PRD § Page Map]] & [[SO_PRD#5.1|Alur per Metode]]. Update di sini kalau page map berubah.
> Dipecah 2 diagram (statis / dinamis) biar tiap diagram muat 1 layar.

## Alur A — QR Statis (login + bayar di muka)

```mermaid
%%{init: {'flowchart': {'useMaxWidth': false}}}%%
flowchart TD
    START([Scan QR statis]) --> P01[PAGE-01 Landing<br/>validasi & resolve QR]
    P01 -->|kedaluwarsa/invalid| ERR[err_expired_session]
    P01 --> P04[PAGE-04 Menu / Katalog]
    P04 --> P05[PAGE-05 Detail Item]
    P05 --> P06[PAGE-06 Keranjang]
    P06 -->|"Cek Stok & Promo"| P08[PAGE-08 Review Read-only]
    P08 --> LOGINCHECK{Sudah login?}
    LOGINCHECK -->|Belum| P02[PAGE-02 Login No. HP] --> P03[PAGE-03 Verifikasi OTP] --> P09[PAGE-09 Pembayaran]
    LOGINCHECK -->|Sudah| P09
    P09 --> P11[PAGE-11 Sukses + masuk antrean WL]

    style ERR fill:#f66,color:#fff
    style P11 fill:#6c6,color:#fff
```

- Login HP+OTP dipicu deferred, cuma pas checkout (belum login).
- Bayar di muka wajib. Sukses → masuk WL.

## Alur B & C — QR Dinamis (open bill / bayar di muka)

```mermaid
%%{init: {'flowchart': {'useMaxWidth': false}}}%%
flowchart TD
    START([Scan QR dinamis]) --> P01[PAGE-01 Landing<br/>validasi & resolve QR]
    P01 -->|kedaluwarsa/invalid| ERR[err_expired_session]
    P01 --> P04[PAGE-04 Menu / Katalog]
    P04 --> P05[PAGE-05 Detail Item]
    P05 --> P06[PAGE-06 Keranjang]
    P06 -->|"Cek Stok & Promo"| P08[PAGE-08 Review Read-only]
    P08 --> METHOD{Pilihan bayar}
    METHOD -->|"Bayar Sekarang" - Metode C| P09[PAGE-09 Pembayaran]
    METHOD -->|"Buka Bill" - Metode B| P10[PAGE-10 Open Bill]
    P10 -->|tambah order lagi| P04
    P10 -->|"Tutup & Bayar" opsional| P09
    P09 --> P11C[PAGE-11 Sukses<br/>Metode C → masuk WL]
    P10 -.->|Metode B: tanpa tutup bill| HOLD[Bill tetap terbuka<br/>tanpa WL]

    style ERR fill:#f66,color:#fff
    style P11C fill:#6c6,color:#fff
    style HOLD fill:#999,color:#fff
```

- **Metode C**: "Bayar Sekarang" → langsung bayar, sukses → masuk WL.
- **Metode B**: "Buka Bill" → open bill, bisa tambah order berkali-kali, "Tutup & Bayar" opsional → baru ke pembayaran. Tanpa handoff WL.

## Catatan
- Detail tiap page, copy, & acceptance criteria ada di [[SO_PRD]].
- Kalau butuh drag/reposisi manual bebas (bukan auto-layout), pindah ke Obsidian Canvas (`.canvas`) — bilang aja kalau mau dibikinin versi itu.
