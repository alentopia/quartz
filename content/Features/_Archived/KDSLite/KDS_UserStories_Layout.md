# KDS_UserStories_Layout — Tab vs Split (Staff App)

> [!warning] Arsip — KDS Lite tidak jadi dipakai
> Diputuskan 2026-08-14: merchant pakai **KDS penuh** (Figma `Kitchen Display Sistem (KDS)`, file `8Uf9bMrBiCf8sQjkX5sUMl`), bukan KDS Lite. Dokumen ini dan seisi folder `KDSLite_Archived/` disimpan sebagai referensi historis, bukan spec aktif. Spec KDS penuh menyusul di `Features/KDS/`.

**Status:** Draft (Archived)
**Versi:** 0.1
**Tanggal:** 2026-08-05
**Author:** PM & Claude Code
**Sumber:** [[KDS_Overview]] · [[KDS_UserScenario]]

---

## Tujuan Dokumen

Memutuskan layout staff app KDS Lite (**2 tab terpisah** vs **split view satu layar**) lewat user story, bukan preferensi visual. Caranya:

1. Story ditulis **netral terhadap layout** — hanya kebutuhan staff + Acceptance Criteria terukur.
2. Tiap kandidat layout dinilai terhadap AC yang sama (§Matriks Evaluasi).
3. Layout yang lolos paling banyak AC = pemenang. Validasi akhir lewat usability test ([[KDS_UserScenario]] §Protokol, prototype `Prototype/KDS_Prototype.html`).

Kandidat yang dinilai:

| Kode  | Layout                                                                           | Ada di Prototype |
| ----- | -------------------------------------------------------------------------------- | ---------------- |
| **T** | 2 tab terpisah (Diproses / Siap), satu list per tab, badge count + snackbar Undo | Versi A          |
| **S** | Split asimetris satu layar — Diproses dominan (±65%), Siap rail sempit (±35%)    | Versi B          |

---

## User Stories — Aktor: Staff

### US-L1 — Menjawab customer tanpa menyentuh layar

> **Sebagai** staff counter yang sedang sibuk (tangan kotor/penuh),
> **saya ingin** tahu status dan jumlah order di kedua status hanya dengan melirik layar,
> **agar** bisa menjawab customer yang bertanya "pesanan saya sudah siap?" tanpa berhenti kerja.

**Acceptance Criteria:**
- **Given** layar KDS Lite dalam keadaan apapun (posisi terakhir manapun),
  **When** staff melirik layar tanpa menyentuhnya,
  **Then** staff bisa menyebutkan order apa saja yang berstatus Siap **dan** berapa yang masih Diproses.
- **Given** customer menanyakan satu nomor spesifik,
  **When** staff melirik layar,
  **Then** staff bisa mengonfirmasi status nomor itu dalam ≤3 detik, **tanpa tap**.

**Skenario terkait:** S4. **Prioritas:** Must.

---

### US-L2 — Yakin tap-nya benar

> **Sebagai** staff yang menandai order sambil multitasking,
> **saya ingin** melihat bukti langsung bahwa order yang barusan saya tandai adalah order yang benar,
> **agar** tidak perlu mengecek ulang atau ragu setiap habis tap.

**Acceptance Criteria:**
- **Given** kartu order X berstatus Diproses,
  **When** staff tap **Tandai Siap** pada X,
  **Then** dalam layar yang sama staff melihat konfirmasi eksplisit bahwa **X** (bukan order lain) kini berstatus Siap — tanpa navigasi tambahan.
- **Given** staff baru menandai X,
  **When** staff ragu "tadi kepencet yang mana?",
  **Then** jawaban terlihat di layar saat itu juga (posisi X di area Siap, atau konfirmasi bernomor).

**Skenario terkait:** S1, S2. **Prioritas:** Must.

---

### US-L3 — Koreksi salah tap secepatnya (Goal G3)

> **Sebagai** staff yang salah tap saat counter ramai,
> **saya ingin** membatalkan tanda Siap yang keliru dengan aksi seminimal mungkin,
> **agar** customer di Monitor Antrian tidak keburu berdiri untuk pesanan yang belum jadi.

**Acceptance Criteria:**
- **Given** staff baru saja salah tap **Tandai Siap** pada order Y,
  **When** staff menyadarinya (kapanpun selama Y masih Siap),
  **Then** Y bisa dikembalikan ke Diproses dengan **maksimal 1 tap aksi + 0 navigasi** (tanpa pindah tab/layar/scroll panjang).
- **Given** Y dikembalikan,
  **Then** Y hilang dari kolom Ready Monitor Antrian dan urutan FIFO-nya tidak hilang (BR-03).

**Skenario terkait:** S3, S9. **Prioritas:** Must.

---

### US-L4 — Serah terima 1 tap

> **Sebagai** staff yang sedang menyerahkan pesanan ke customer di depan counter,
> **saya ingin** menuntaskan order itu dengan satu aksi,
> **agar** antrean serah terima tidak tertahan oleh saya mengoperasikan layar.

**Acceptance Criteria:**
- **Given** customer datang menyebut nomor yang berstatus Siap,
  **When** staff menyerahkan pesanan,
  **Then** menandai **Selesai** butuh **maksimal 1 tap aksi + maksimal 1 navigasi** dari posisi layar manapun.

**Skenario terkait:** S1, S4. **Prioritas:** Must.

---

### US-L5 — Fokus kerja tetap satu

> **Sebagai** staff yang 90% waktunya memproses antrean masak,
> **saya ingin** area kerja utama (Diproses) tampil dominan dan tidak bersaing dengan informasi lain,
> **agar** mata saya tidak lelah memilah layar setiap kali melirik.

**Acceptance Criteria:**
- **Given** layar utama KDS Lite,
  **Then** area Diproses mendapat porsi visual terbesar, dan "kartu yang harus dikerjakan berikutnya" (FIFO teratas) selalu di posisi yang sama dan mudah diprediksi.
- **Given** kedua status tampil,
  **Then** area Siap dibedakan tegas (warna aksen + posisi konsisten) sehingga tidak pernah tertukar dengan Diproses dalam lirikan cepat.

**Skenario terkait:** S2. **Prioritas:** Should.
**Catatan:** story ini menampung kekhawatiran "split bikin fokus terbagi" — AC-nya bisa dipenuhi split **asimetris**, tidak mensyaratkan tab.

---

### US-L6 — Layar sempit tetap sadar dua status

> **Sebagai** staff kios yang memakai HP,
> **saya ingin** tetap tahu keadaan status yang sedang tidak tampil,
> **agar** tidak ada order Siap yang terlupakan saat saya bekerja di list Diproses.

**Acceptance Criteria:**
- **Given** layar hanya memuat satu list (lebar < tablet),
  **Then** jumlah order di status yang tersembunyi selalu terlihat (badge count di tab).
- **Given** staff tap **Tandai Siap** dan kartunya keluar dari list yang sedang tampil,
  **Then** muncul konfirmasi bernomor + aksi **Urungkan** yang bertahan ≥3 detik, berfungsi tanpa pindah tab.

**Skenario terkait:** S7. **Prioritas:** Must (khusus breakpoint HP).

---

## Matriks Evaluasi — AC × Layout

Penilaian analitis (pra-usability-test), di lebar tablet/desktop kecuali US-L6:

| Story | AC inti | **T** — Tab | **S** — Split asimetris |
|---|---|---|---|
| US-L1 | Lihat isi kedua status tanpa tap | ✗ — isi tab nonaktif tersembunyi; badge hanya beri *jumlah*, bukan *nomor order* | ✓ — kedua kolom selalu terlihat |
| US-L2 | Konfirmasi tap tanpa navigasi | ~ — butuh tambalan snackbar; konfirmasi verbal, bukan spasial | ✓ — kartu terlihat pindah kolom |
| US-L3 | Undo ≤1 tap + 0 navigasi | ✗ — pindah tab dulu (1 navigasi) baru Undo; via snackbar hanya selama ≤5 detik | ✓ — tombol Undo selalu terlihat di rail Siap |
| US-L4 | Selesai ≤1 tap + ≤1 navigasi | ✓ — 1 pindah tab + 1 tap (pas di batas AC) | ✓ — 0 navigasi + 1 tap |
| US-L5 | Fokus utama tunggal, next-action jelas | ✓ — satu list per waktu | ✓ — Diproses dominan, Siap rail sempit beraksen |
| US-L6 | Awareness di layar HP | ✓ — memang desain untuk HP | n/a — di HP, split collapse jadi tab (T) |

**Kesimpulan analitis:** di tablet/desktop, **S** memenuhi semua AC; **T** gagal US-L1 dan US-L3 (dua-duanya Must, dan US-L3 = Goal G3 spec). **T** tetap dipakai — hanya di breakpoint HP (US-L6), lengkap dengan badge + snackbar.

Matriks ini hipotesis — dikonfirmasi/dibantah oleh usability test ([[KDS_UserScenario]] §Protokol). Kalau hasil tes bertentangan (mis. peserta di versi S justru lebih sering salah tap), matriks direvisi dari data.

---

## Definition of Done

- [ ] Usability test S1–S4 dijalankan pada kedua versi prototype, ≥2 peserta per versi.
- [ ] Metrik terkumpul: tap aksi, pindah tab, waktu per skenario, salah tap, jawaban awareness (S2/S4).
- [ ] Keputusan layout final dicatat di [[KDS_Overview]] (§8 Layar KDS Lite) dengan rujukan ke matriks ini.
- [ ] Story yang layout-nya sudah final diturunkan ke Cases (`Features/KDSLite/Cases/`) untuk QA.

---

## Dokumen Terkait

- [[KDS_Overview]] — spec induk.
- [[KDS_UserScenario]] — skenario naratif + protokol usability test.
- `Prototype/KDS_Prototype.html` — prototype klik-able versi T (A · Tab) dan S (B · Split).
