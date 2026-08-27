# Self Order — Test Scenario (Versi MVP)

<!-- Turunan dari SO_TestScenario.md (base, dari SO_PRD v0.2), disinkronkan ke SO_PRD_MVP.md v1.2. ID skenario = ID AC terkait di SO_PRD_MVP; skenario tambahan ditandai (tambahan). -->

**Status:** Draft
**Sumber:** [[SO_PRD_MVP|SO_PRD_MVP.md v1.2]] — Element Inventory, States, Validation Rules, Edge Cases, Acceptance Criteria per halaman.
**Baseline test lama:** [[SO_TestScenario|SO_TestScenario.md]] (arsip, berbasis PRD v0.2 — jangan diedit lagi)
**Bahasa:** Indonesia

## Kenapa dokumen ini ada

`SO_TestScenario.md` ditulis berbasis PRD v0.2 sebelum 3 koreksi besar berikut ditemukan. Dokumen ini turunan yang sinkron dengan `SO_PRD_MVP.md`:

1. **Tidak ada login/OTP sama sekali.** PAGE-02 & PAGE-03 (dan semua skenarionya) **dihapus total**, bukan cuma "kemungkinan tidak berlaku" seperti catatan revisi 2026-07-14 di dokumen lama. Identitas tamu pindah jadi opsional di Confirm (PAGE-08).
2. **Open Bill (Metode B) di luar MVP.** PAGE-10 & semua skenarionya **dihapus** dari dokumen ini — bukan "hold", tapi memang belum dibangun untuk rilis ini.
3. **Review(08) + Payment-method(09 lama) digabung jadi Confirm**, dan validasi keranjang (dulu "PAGE-08 Review Read-only") ternyata **popup di atas Keranjang**, bukan halaman. Skenario negative-case terkait dipindah ke bagian tersendiri.

Fitur baru yang belum ada skenarionya di dokumen lama: **Voucher** (PAGE-06V), **auto-apply Klaim Item Gratis**, **Hapus Item (qty→0)**, **QRIS Tidak Tersedia**, **Bagikan Struk** dgn identitas opsional. Semua ditambahkan di sini.

---

## PAGE-01 — Landing / QR Entry

**Tidak berubah dari dokumen lama.** Semua baris AC-01.1–AC-01.5 tetap berlaku — rujuk [[SO_TestScenario|SO_TestScenario.md §PAGE-01]].

---

## ~~PAGE-02 — Login Nomor HP~~ / ~~PAGE-03 — Verifikasi OTP~~

**Dihapus total.** Seluruh baris AC-02.x dan AC-03.x di dokumen lama (format nomor HP, kirim OTP, verifikasi kode, resend, rate-limit, percobaan berlebih) **tidak berlaku untuk MVP** — bukan cuma revisi status "kemungkinan tidak berlaku", tapi memang tidak ada mekanisme ini sama sekali. Jangan dites, jangan dipakai sbg acuan regresi.

Yang menggantikannya: skenario identitas opsional di **PAGE-08 — Confirm** (lihat di bawah).

---

## PAGE-04 — Menu / Katalog

Sebagian besar **tidak berubah** — rujuk AC-04.1, AC-04.2, AC-04.3, AC-04.4 di dokumen lama.

| ID | Skenario | Status |
|---|---|---|
| ~~AC-04.5~~ | ~~Strip ekspektasi login (guest, Metode A)~~ | **Dihapus** — copy "Lihat-lihat dulu aja… nanti login pas checkout" mengasumsikan ada login yang dideferred. Tidak ada login sama sekali di MVP, jadi strip ini tidak relevan; kalau strip serupa tetap ada di desain final, isinya harus ditulis ulang tanpa menyebut "login". |

---

## PAGE-05 — Detail Item & Tambah ke Keranjang

**Tidak berubah dari dokumen lama.** Semua baris AC-05.1–AC-05.5 tetap berlaku — rujuk [[SO_TestScenario|SO_TestScenario.md §PAGE-05]].

---

## PAGE-06 — Keranjang

**Objective (revisi):** Memastikan pengelolaan keranjang (ubah qty/hapus item, voucher, klaim gratis) dan tombol "Konfirmasi Pesanan" langsung memicu validasi server **tanpa syarat login apa pun** — tidak ada lagi percabangan per-metode di titik ini.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|---|---|---|---|---|---|---|
| AC-06.1 | Keranjang berisi item | ≥1 item di cart | Daftar item + subtotal + tombol "Konfirmasi Pesanan" aktif | — | — | Nama tombol berubah dari "Cek Stok & Promo" (v0.2) jadi "Konfirmasi Pesanan" sesuai Figma |
| AC-06.4 | Keranjang kosong | Semua item dihapus | Ilustrasi + "Keranjangmu masih kosong." + tombol "Lihat Menu" | "Konfirmasi Pesanan" disabled | — | Terjadi juga saat menghapus item terakhir (lihat AC-06.8) |
| ~~AC-06.5~~ | ~~Metode A belum login tekan checkout~~ | — | — | — | — | **Dihapus** — tidak ada login, tidak ada gate |
| AC-06.6 | Tekan "Konfirmasi Pesanan" | Keranjang berisi item, tamu guest (semua metode) | Server mulai validasi stok & promo — kalau bersih langsung PAGE-08, kalau ada masalah munculin `ValidationPopup` | — | Server mulai proses validasi stok & promo | Sekarang berlaku sama utk semua metode, tidak ada cabang login |
| AC-06.7 | Hapus item — qty diturunkan ke 0 | Item qty ≥1 | `ConfirmDialog` "Hapus item?" muncul | Item belum terhapus sampai dikonfirmasi | Client-side confirm gate | (tambahan, dari `SO_PRD_MVP.md`) |
| AC-06.8 | Konfirmasi hapus pada item terakhir | Item terakhir di keranjang, dialog dikonfirmasi | Item hilang → keranjang jadi empty state | Cart kosong server-side | Server hapus item dari cart | (tambahan) |
| AC-06.9 | **[Negatif]** Batalkan hapus item | Dialog "Hapus item?" terbuka | Tamu tekan Batal → dialog tutup, qty kembali ke nilai sebelum turun ke 0 | Item tetap di keranjang | — | (tambahan) — pastikan qty tidak nyangkut di 0 kalau dibatalkan |

---

## PAGE-06V — Voucher & Diskon *(baru)*

**Objective:** Memastikan daftar voucher yang eligible tampil dgn syarat jelas, penerapan voucher langsung terhitung di ringkasan, dan empty state muncul kalau tidak ada voucher aktif.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|---|---|---|---|---|---|---|
| AC-06V.1 | Daftar voucher eligible tampil | Ada voucher yang memenuhi syarat belanja saat ini | `VoucherPickCard` per voucher dgn syarat & tombol "Pakai" | — | Server hitung voucher mana yg eligible vs subtotal cart | (tambahan) |
| AC-06V.2 | Pakai voucher | Tekan "Pakai" pada 1 voucher | Diskon voucher langsung terhitung di `SummaryCard` PAGE-06 | Voucher terpasang ke order | Server terapkan diskon voucher terpilih | (tambahan) |
| AC-06V.3 | **[Negatif]** Tidak ada voucher aktif | Tidak ada voucher yang eligible | Empty state "belum ada voucher aktif" | — | — | (tambahan) — Figma `node-id=1092-40427` |
| (tambahan) | **[Negatif]** Voucher jadi tidak eligible setelah cart berubah | Voucher terpasang, lalu tamu hapus item hingga subtotal < syarat min. | Voucher otomatis dilepas, notifikasi ke tamu | Diskon voucher hilang dari ringkasan | Server re-evaluasi syarat voucher tiap cart berubah | Perlu dipastikan kapan re-evaluasi terjadi (real-time vs saat Konfirmasi Pesanan) — **OQ baru, belum ada di PRD** |

---

## PAGE-07 — Klaim Item Gratis (`FreeItemSheet`)

Semua baris AC-07.1–AC-07.5 dari dokumen lama **tetap berlaku** — rujuk [[SO_TestScenario|SO_TestScenario.md §PAGE-07]]. Tambahan:

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|---|---|---|---|---|---|---|
| AC-07.6 | Auto-apply — promo cuma 1 varian hadiah | Promo dapat-item, item eligible cuma 1 varian | Item gratis langsung ditambahkan sbg baris "Gratis", sheet **tidak** dibuka | Item hadiah terikat ke order tanpa interaksi tamu | Server deteksi eligible-count = 1 → auto-assign | (tambahan, dari `SO_PRD_MVP.md`) |
| (tambahan) | **[Negatif]** Auto-apply gagal — varian jadi habis pas cek server | Varian tunggal ternyata stok 0 di sisi server (race) | Fallback ke state "hadiah tidak tersedia" meski cuma 1 varian | Order lanjut tanpa hadiah | Server re-cek stok varian sebelum auto-assign | Edge case race condition — belum ada di PRD, perlu diverifikasi ke desain |

---

## Negative Case — Validasi Keranjang *(popup `ValidationPopup`, dipindah dari "PAGE-08 Review" lama)*

**Objective:** Memastikan popup adaptif menampilkan tiap kombinasi masalah (stok/harga/promo) dgn `IssueRow` bernama item spesifik, keranjang ter-update otomatis, dan tamu bisa lanjut ke Confirm setelah bersih.

> Skenario ini **menggantikan** AC-08.2, AC-08.6, dan 2 baris "tambahan" (harga berubah, promo dilepas) dari dokumen lama — bedanya sekarang munculnya sbg **popup di atas Keranjang**, bukan halaman "Review Read-only" terpisah.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|---|---|---|---|---|---|---|
| AC-NC.1 | Item habis terdeteksi | Tekan "Konfirmasi Pesanan", 1+ item stok jadi 0 | `ValidationPopup` tampil, `IssueRow` sebut nama item yang habis | Item dihapus dari cart setelah popup ditutup | Server re-cek stok saat validasi | Ganti dari AC-08.2 lama |
| AC-NC.2 | Harga/promo berubah terdeteksi | Harga/promo server ≠ snapshot cart | Popup tampil dgn nilai baru per item terdampak | Cart ter-sync ke nilai server | Server bandingkan snapshot vs live | Ganti dari 2 baris "tambahan" lama (harga & promo) |
| AC-NC.3 | Kombinasi banyak masalah (>4 item) | Stok+harga+promo bermasalah pada >4 item sekaligus | Daftar `IssueRow` auto-collapse "Lihat N lainnya" | — | — | (tambahan) — Figma sebut varian "Banyak Perubahan 5+" |
| AC-NC.4 | Lanjut setelah popup bersih | Tamu tutup popup, tekan ulang "Konfirmasi Pesanan" | Validasi bersih → langsung ke PAGE-08 Confirm | — | Server validasi ulang, hasil 0 masalah | — |
| AC-NC.5 | **[Negatif]** Semua item gugur validasi | Semua item di cart habis stok | Popup/keranjang kosong — "Pesananmu kosong setelah pengecekan. Yuk pesan lagi." + "Kembali ke Menu" | Cart kosong | Server: hasil validasi = 0 item valid | Ganti dari AC-08.6 lama — perlu dipastikan ini tampil di popup atau di state Keranjang kosong biasa (belum eksplisit di Figma) |

---

## PAGE-08 — Confirm *(gabungan Review + identitas opsional + Metode Bayar)*

**Objective (revisi total):** Memastikan Confirm menampilkan ringkasan order + identitas opsional (Atas Nama, Kumpulin Poin) + pilihan metode bayar dalam 1 layar, **tanpa syarat login**, dan QRIS otomatis nonaktif kalau merchant mematikannya.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|---|---|---|---|---|---|---|
| AC-08.1 | Confirm tampil setelah validasi bersih | Validasi server sukses / tidak ada masalah | Ringkasan (flat, "Lihat semua N item") + identitas opsional + metode bayar dalam 1 layar | — | — | Ganti dari AC-08.1 lama ("Review Read-only") |
| AC-08.2 | Lanjut tanpa isi identitas apa pun | Field Atas Nama & Kumpulin Poin kosong | Tamu tetap bisa lanjut ke PAGE-09 tanpa hambatan | Order tersimpan tanpa nama/nomor | Server terima order dgn identitas kosong (nullable) | Ganti total dari AC-08.3 lama (dulu: "Metode A telah login") |
| AC-08.3 | Isi Kumpulin Poin — nomor cocok member | Buka `PoinMemberSheet`, isi nomor terdaftar sbg member | Status member (mis. badge Bliss) otomatis aktif, **tanpa verifikasi apa pun** | Order terikat ke member tsb | Server cocokkan nomor ke data member — murni lookup, bukan auth | (tambahan) |
| AC-08.4 | **[Negatif]** Isi Kumpulin Poin — nomor tidak terdaftar | Nomor diisi, tidak cocok member manapun | Tersimpan sbg nomor biasa (buat poin baru/struk), tanpa status member | — | Server: lookup gagal → treat as new/non-member | (tambahan) |
| ~~AC-08.4 (lama)~~ | ~~Metode C — Bayar Sekarang / Buka Bill~~ | — | — | — | — | **Dihapus** — tidak ada opsi "Buka Bill" di Confirm MVP (Open Bill di luar scope) |
| AC-08.5 | Tekan "Ubah Pesanan" | Confirm tampil | Kembali ke PAGE-06 (Keranjang) | Identitas yg sudah diisi tetap tersimpan (opsional — perlu dipastikan ke desain, blm eksplisit) | — | Nomenklatur tombol perlu dicek ulang — masih "Ubah Pesanan" atau sudah beda di Figma? |
| AC-08.6 | Merchant nonaktifkan QRIS | QRIS di-disable dari sisi merchant | Opsi QRIS digrayscale/disabled, Bayar Langsung otomatis satu-satunya aktif | — | Server return flag `qrisEnabled=false` | (tambahan) — Figma `Case: QRIS Tidak Tersedia` |
| AC-08.7 | Tekan "Lihat semua" | Order >1 item, cuma item pertama tampil default | Seluruh item pesanan tampil | — | — | (tambahan) |

---

## PAGE-09 — Pembayaran (Processing)

Semua baris AC-09.1, AC-09.2, AC-09.3, AC-09.5, AC-09.6 dari dokumen lama **tetap berlaku** (ganti rujukan halaman asal dari PAGE-08/PAGE-10 jadi PAGE-08 Confirm saja, karena tidak ada lagi PAGE-10). Perubahan:

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|---|---|---|---|---|---|---|
| AC-09.4 | **[Negatif]** QRIS kedaluwarsa | Kode QRIS lewat batas waktu (mis. 5 menit) | Popup **"Kode QRIS kedaluwarsa"** + tombol **"Kembali ke konfirmasi"** | Kode lama invalid, **pesanan tetap tersimpan** — tamu balik ke Confirm bukan mulai dari 0 | Server cek `expiredAt` kode QRIS | Copy & tombol lebih spesifik dari draf lama ("Buat kode baru" generik) — Figma `Case: QRIS Kedaluwarsa`, popup `ExpiredPopup` |
| AC-09.7 | Bayar Langsung → `CashStatusScreen` | Metode Bayar Langsung dipilih | Ilustrasi menunggu + kode referensi (mis. `REF-001234`) + instruksi tunjuk ke kasir + rincian pesanan lengkap di layar yang sama | Order status "menunggu bayar di kasir" | Server generate kode referensi | Detail lebih lengkap dari draf lama — 1 layar gabungan status+rincian |
| (tambahan) | QRIS otomatis tidak tersedia sbg opsi | Dari AC-08.6 (QRIS di-disable merchant) | Halaman ini cuma diakses via Bayar Langsung, tidak ada opsi QRIS sama sekali | — | — | Konsekuensi lanjutan AC-08.6 |

Baris "tambahan" lain di dokumen lama (gagal buat kode QRIS, ditolak gateway, refresh saat pending, belum pilih metode) **tetap berlaku tanpa perubahan**.

---

## ~~PAGE-10 — Open Bill~~

**Dihapus total dari MVP.** Semua baris AC-10.1–AC-10.6 dan 3 baris "tambahan" (promo lintas-order, gagal load bill, multi-device) di dokumen lama **tidak berlaku** — Open Bill (Metode B) didorong ke rilis berikutnya secara penuh. Skenario ini akan ditulis ulang terpisah waktu Open Bill digarap, bukan dipertahankan di sini sbg draft.

---

## PAGE-11 — Konfirmasi Sukses & Handoff WL

**Objective (revisi):** Memastikan konfirmasi & enqueue WL berjalan untuk **semua** pemesanan (tidak ada lagi cabang Metode B karena Open Bill di luar MVP), kegagalan enqueue tidak membatalkan pembayaran sah, dan Bagikan Struk berperilaku benar tergantung identitas yang diisi (atau tidak) di Confirm.

| ID | Skenario | Prasyarat | Expected Result | Post Condition | System Validation | Catatan |
|---|---|---|---|---|---|---|
| AC-11.1 | Bayar sukses | Pembayaran terkonfirmasi lunas | Konfirmasi sukses + ringkasan; proses enqueue WL berjalan | Order berstatus sukses; enqueue diproses | Server kirim order ke modul WL | Hilangkan spesifik "Metode A/C" — sekarang berlaku semua order MVP |
| AC-11.2 | Enqueue WL sukses | Enqueue selesai tanpa error | Blok "Kamu masuk antrean…" + tombol "Lihat Antrean" | Tamu terdaftar di WL dgn nomor antrean | Server terima ack dari modul WL | **Perlu dipastikan payload identitas ke WL kalau nomor HP kosong — lihat [[SO_PRD_MVP#9. Open Questions|OQ-SO-15]]** |
| AC-11.3 | **[Negatif]** Enqueue WL gagal | Modul WL error/down | "Pesanan berhasil, tapi pendaftaran antrean gagal. Tunjukkan layar ini ke staf." | Pembayaran tetap sah | Server terima error dari modul WL; pembayaran tidak dirollback | — |
| ~~AC-11.4~~ | ~~Bayar Metode B (tutup bill) tanpa WL~~ | — | — | — | — | **Dihapus** — Metode B (Open Bill) tidak ada di MVP |
| AC-11.5 | Buka ulang link konfirmasi | Tamu tutup halaman lalu kembali via link | Status sukses dipulihkan dari server | Tidak ada order duplikat | Server return status by order/session id | — |
| AC-11.6 | Bagikan Struk — nomor sudah keisi | Tamu isi nomor via Kumpulin Poin di Confirm | `ShareReceiptSheet` nomor auto-terisi, ada tombol "Ganti" | — | — | (tambahan, dari `SO_PRD_MVP.md`) |
| AC-11.7 | Bagikan Struk — nomor belum keisi | Tamu tidak isi identitas apa pun di Confirm | Field nomor kosong, wajib isi manual, tombol "Ganti" **tidak ada** | — | — | (tambahan) |
| (tambahan) | **[Negatif]** Refresh saat "Mendaftarkan antrean…" | Tamu refresh selagi enqueue diproses | Status dipulihkan (bukan enqueue ulang) | Tidak ada entri WL duplikat | Server cek apakah enqueue sudah pernah diproses utk order ini | Tetap berlaku dari dokumen lama |

---

## Ringkasan Negative Case per Kategori (MVP)

Dikelompokkan ulang mengikuti scope MVP — kategori terkait login/OTP dan Open Bill **dihapus** (bukan "drop pending", tapi memang tidak dibangun); kategori baru ditambahkan untuk Voucher & popup validasi.

1. **Stok & harga real-time (race condition)** — item habis saat sheet detail terbuka (PAGE-05), habis saat validasi (popup `ValidationPopup`), harga/promo berubah antara cart→checkout (popup), hadiah promo habis (PAGE-07), auto-apply hadiah gagal karena race (PAGE-07, tambahan baru).
2. **Promo & Voucher edge** — promo gugur setelah cart berubah (PAGE-07), promo dilepas saat validasi (popup), voucher jadi tidak eligible setelah cart berubah (PAGE-06V, tambahan baru — **OQ belum ada di PRD**).
3. **Sesi & QR** — QR dinamis kedaluwarsa (PAGE-01). *(Skenario "kasir tutup bill dari POS" di dokumen lama dihapus bersama Open Bill.)*
4. **Pembayaran** — QRIS kedaluwarsa/gagal dibuat/ditolak gateway/tidak tersedia (PAGE-08/09), refresh saat pending, status "Bayar Langsung" bergantung konfirmasi staf yang alurnya belum final (OQ-SO-03). Double-payment (AC-09.6) **masih perlu konfirmasi ulang** (OQ-SO-11).
5. **Identitas opsional** *(kategori baru, ganti "Login & OTP")* — isi/tidak isi Atas Nama, isi Kumpulin Poin dgn nomor cocok/tidak cocok member, Bagikan Struk dgn/tanpa nomor terisi.
6. **Jaringan/infrastruktur** — gagal load menu/detail (berbagai halaman), timeout resolve QR, gagal enqueue WL. No-connection state: masih deferred (OQ-SO-09).
7. **Konsistensi lintas-halaman** — buka ulang link konfirmasi tanpa duplikasi order, kembali dari sheet tanpa kehilangan isi keranjang.

**Dihapus total dari scope (bukan lagi "kemungkinan tidak berlaku" — sudah dikonfirmasi PM):**
- Semua skenario login nomor HP & OTP (PAGE-02/03 lama) — tidak ada mekanisme ini sama sekali di MVP.
- Semua skenario Open Bill (PAGE-10 lama) — Metode B di luar MVP, rilis berikutnya.
- Kode diskon manual (sudah di-drop sejak revisi 2026-07-14, kini diganti Voucher dgn skenario sendiri di §PAGE-06V).
- QR "tidak dikenali" (invalid token) — tetap dianggap kegagalan level device/scan, bukan tanggung jawab app (tidak berubah).

**Belum tercakup di PRD, perlu keputusan PM sebelum bisa diuji:**
- Perilaku saat qty/order melebihi batas maksimum per item (OQ-SO-06).
- Format & channel pengiriman struk/bukti selain WhatsApp (OQ-SO-05).
- Kanal Bayar Online non-QRIS (VA bank) — tetap di luar scope (OQ-SO-07).
- **Identitas minimum utk enqueue WL kalau nomor HP tidak diisi (OQ-SO-15, baru)** — ini pertanyaan paling kritis buat MVP karena langsung mempengaruhi AC-11.2.
- Kapan voucher di-re-evaluasi kalau cart berubah setelah dipasang (real-time vs cuma saat Konfirmasi Pesanan) — belum ada di PRD sama sekali.
- Dedup "Bayar Semua" Open Bill (OQ-SO-14) — N/A untuk MVP, relevan lagi pas Open Bill digarap.

---

*Dokumen ini turunan manual dari [[SO_PRD_MVP|SO_PRD_MVP.md v1.2]] pada 2026-07-23 (bukan output otomatis sub-agent doc). Update PRD MVP → tinjau ulang tabel ini agar tetap sinkron. Untuk skenario halaman yang tidak berubah, dokumen ini menunjuk balik ke [[SO_TestScenario|SO_TestScenario.md]] — jangan duplikasi isi supaya tidak drift saat salah satu diupdate.*
