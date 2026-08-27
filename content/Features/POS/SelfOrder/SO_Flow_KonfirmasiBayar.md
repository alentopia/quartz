---
tags: [self-order, flowchart]
status: Draft
---

# Self Order — Alur Keranjang s.d. Berhasil (draft, perlu konfirmasi)

> Prasyarat: setting AOL sudah selesai.
> Simbol: stadium (start/end), diamond (keputusan), rectangle (proses/halaman).

```mermaid
%%{init: {'flowchart': {'useMaxWidth': false}}}%%
flowchart TD
    START([User scan QR]) --> MENU[Halaman Menu<br/>tarik data POS + setting AOL]
    MENU -->|klik Lihat Keranjang| CART[Halaman Keranjang<br/>tarik data APOS: promo, SPA, stock]
    CART -->|klik Konfirmasi Keranjang| CHECK{Stock, SPA, promo<br/>masih valid?}
    CHECK -->|ada yang habis/berubah| POPUP[/Popup Negative/]
    POPUP --> CART
    CHECK -->|semua valid| KONF[Halaman Konfirmasi Pesanan<br/>harga fix, tidak bisa diubah]
    KONF -->|user ubah pesanan| CART
    KONF -->|pilih metode bayar| METODE{QR atau BAYAR DI KASIR?}
    METODE -->|BAYAR DI KASIR| APOSNODE[APOS: order muncul<br/>status Sedang Diproses/Dibayar - REF#]
    METODE -->|QR| QRIS[Bayar QRIS<br/>auto-confirm, tanpa kasir]
    APOSNODE --> KASIR[Bayar ke kasir<br/>konfirmasi manual]
    KASIR --> TABLE[Table Management POS<br/>meja jadi Terisi + no. Order/REF]
    QRIS -->|auto-confirm, table langsung terisi| TABLE
    TABLE -->|jalur REF: POS klaim sudah dibayar| KLAIM[Kirim status ke Self Order/Web]
    KLAIM --> UPDATE[User klik Update Status Pesanan]
    UPDATE --> DONE([Halaman Berhasil<br/>tampil nomor REF])
    TABLE -->|jalur QR: otomatis realtime, tanpa klaim manual| DONE

    style POPUP fill:#e05555,color:#fff
    style CHECK fill:#e0c25c,color:#000
    style METODE fill:#e0c25c,color:#000
    style START fill:#4c8c4c,color:#fff
    style DONE fill:#4c8c4c,color:#fff
```


![[Pasted image 20260804012203.png]]
## Catatan
- **Jalur REF**: APOS munculin order → kasir konfirmasi manual → table terisi → POS klaim dibayar → user klik update status → Berhasil.
- **Jalur QR (QRIS)**: auto-confirm, gak lewat kasir, table langsung terisi → langsung Berhasil (gak perlu klik update status).
- REF# jadi penanda pesanan, ditampilkan di: POS (Detail Meja Terisi) & Self Order (halaman Konfirmasi/Berhasil).
- Versi Canvas (drag-bebas, tapi cuma kotak — gak ada simbol diamond/stadium asli) masih ada di [[SO_Flow_KonfirmasiBayar.canvas]] kalau butuh reposisi manual.
