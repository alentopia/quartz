# language: id
#
# Sumber kebenaran : Features/SelfOrder/Cases/SO_Case_QRManagementNegative.md
# Kamus langkah    : _meta/Kamus_Langkah_Gherkin.md
# Cara pakai       : copy file ini ke repo Selenium (src/test/resources/features/),
#                    step definition-nya ambil dari kamus langkah.
#
# Aturan: kalau copy di sini beda dengan spec, SPEC yang menang. Ubah spec dulu,
# baru file ini. Jangan pernah sebaliknya.
#
# Semua kasus di spec sudah punya scenario di file ini. SO-QRN-E3 masuk sejak
# 2026-07-30 (perilakunya baru diputuskan): hak akses dicabut -> halaman baru hilang
# setelah sinkronisasi. Tiga detailnya masih pertanyaan terbuka (diarahkan ke mana,
# ada pemberitahuan atau senyap, dan bagaimana kalau popup sedang terbuka), jadi
# scenario-nya baru menguji yang sudah pasti.
#
@fitur:self-order @area:qr-management @app:setup-apos
Fitur: QR Management - negative case (Setup APOS)

  Latar Belakang:
    Diketahui fitur "Table Management" dan "QR Self Order" aktif di Setup AOL
    Dan karyawan "kasir-a" punya hak akses "Mengelola QR Self Order"
    Dan karyawan "kasir-b" punya hak akses "Mengelola QR Self Order"

  # ---------------------------------------------------------------- A. Generate & unduh PDF

  @SO-QRN-A1 @negative @tanpa-pesan
  Skenario: A1 - tombol Generate QR tetap disabled saat belum ada meja dipilih
    Diketahui meja "AA - 01" belum punya QR
    Dan "kasir-a" membuka halaman QR Management
    Ketika "kasir-a" membuka Popup Pilih Meja
    Maka counter meja terpilih menunjukkan angka 0
    Dan tombol "Generate QR" di Popup Pilih Meja dalam kondisi disabled
    Ketika "kasir-a" mencentang meja "AA - 01" di Popup Pilih Meja
    Maka counter meja terpilih menunjukkan angka 1
    Dan tombol "Generate QR" di Popup Pilih Meja dalam kondisi aktif

  @SO-QRN-A2 @negative @kontrol-hilang
  Skenario: A2 - link Pilih Semua hilang saat semua meja di kategori sudah ber-QR
    Diketahui semua meja di kategori "Area Dalam" sudah punya QR
    Dan kategori "Area Luar" masih punya meja tanpa QR
    Dan "kasir-a" membuka halaman QR Management
    Ketika "kasir-a" membuka Popup Pilih Meja
    Maka link "Pilih Semua" pada kategori "Area Dalam" tidak tampil
    Dan link "Pilih Semua" pada kategori "Area Luar" tampil
    Dan semua kartu meja di kategori "Area Dalam" dalam kondisi disabled

  @SO-QRN-A2 @negative @kontrol-hilang
  Skenario: A2b - seluruh area habis, tidak ada empty state khusus
    Diketahui semua meja di semua kategori sudah punya QR
    Dan "kasir-a" membuka halaman QR Management
    Ketika "kasir-a" membuka Popup Pilih Meja
    Maka tidak ada link "Pilih Semua" yang tampil
    Dan grid meja tetap tampil dengan semua kartu dalam kondisi disabled
    Dan tombol "Generate QR" di Popup Pilih Meja dalam kondisi disabled

  @SO-QRN-A3 @negative @race-condition @multi-sesi @modal-satu-tombol
  Skenario: A3 - unduh PDF gagal karena QR-nya sudah dihapus device lain
    Diketahui QR meja "AA - 01, AA - 02" sudah ada di Daftar QR Aktif
    Dan "kasir-b" masuk mode seleksi lalu mencentang meja "AA - 01"
    Ketika "kasir-a" menghapus QR meja "AA - 01"
    Dan "kasir-b" menekan "Unduh PDF"
    Maka "kasir-b" melihat modal error berjudul "Gagal Mengunduh PDF"
    Dan deskripsi modal error berbunyi "PDF tidak dapat diunduh karena data QR sudah dihapus oleh pengguna lain. Data ini akan dihapus dari Daftar QR Aktif Anda."
    Dan modal error hanya punya tombol "Baik, Saya mengerti"
    Ketika "kasir-b" menekan "Baik, Saya mengerti"
    Maka data di Daftar QR Aktif dimuat ulang
    Dan QR meja "AA - 01" tidak lagi tampil di Daftar QR Aktif

  # ---------------------------------------------------------------- B. Bentrok antar-device

  @SO-QRN-B1 @negative @race-condition @multi-sesi
  Skenario: B1 - generate sebagian bentrok, hitungan modal sukses ikut turun
    Diketahui meja "AA - 01" sampai "AA - 12" belum punya QR
    Dan "kasir-b" sudah membuka Popup Pilih Meja
    Ketika "kasir-a" generate QR untuk meja "AA - 12"
    Dan "kasir-b" mencentang meja "AA - 01" sampai "AA - 12" lalu menekan "Generate QR"
    Maka "kasir-b" melihat modal sukses berjudul "11 QR meja berhasil dibuat"
    Dan modal sukses menampilkan 11 chip nama meja
    Dan chip nama meja tidak memuat "AA - 12"
    Dan modal sukses punya tombol "Selesai" dan "Download PDF"
    Dan tidak ada toast peringatan yang muncul

  @SO-QRN-B2 @negative @race-condition @multi-sesi @modal-satu-tombol
  Garis-Besar Skenario: B2 - generate gagal total karena didahului device lain
    Diketahui meja "<meja>" belum punya QR
    Dan "kasir-b" sudah membuka Popup Pilih Meja
    Ketika "kasir-a" generate QR untuk meja "<meja>"
    Dan "kasir-b" mencentang meja "<meja>" lalu menekan "Generate QR"
    Maka "kasir-b" melihat modal error berjudul "QR Meja Gagal Digenerate"
    Dan deskripsi modal error berbunyi "<deskripsi>"
    Dan modal error hanya punya tombol "Baik, Saya mengerti"
    Ketika "kasir-b" menekan "Baik, Saya mengerti"
    Maka data di Popup Pilih Meja dimuat ulang
    Dan kartu meja "<meja>" dalam kondisi disabled

    Contoh:
      | varian  | meja                                                                                                                  | deskripsi                                                                                                             |
      | 1 meja  | AA - 01                                                                                                               | QR Meja AA - 01 gagal digenerate karena sudah digenerate lebih dulu oleh pengguna lain.                                |
      | 2 meja  | AA - 01, AA - 02                                                                                                      | QR Meja AA - 01 dan AA - 02 gagal digenerate karena sudah digenerate lebih dulu oleh pengguna lain.                    |
      | 3 meja  | AA - 01, AA - 02, AA - 03                                                                                             | QR Meja AA - 01, AA - 02 dan AA - 03 gagal digenerate karena sudah digenerate lebih dulu oleh pengguna lain.           |
      | 12 meja | AA - 01, AA - 02, AA - 03, AA - 04, AA - 05, AA - 06, AA - 07, AA - 08, AA - 09, AA - 10, AA - 11, AA - 12             | QR Meja AA - 01, AA - 02 dan 10 meja lainnya gagal digenerate karena sudah digenerate lebih dulu oleh pengguna lain.   |

  @SO-QRN-B3 @negative @race-condition @multi-sesi
  Skenario: B3 - hapus sebagian bentrok, hitungan toast sukses ikut turun
    Diketahui QR meja "AA - 01" sampai "AA - 12" sudah ada di Daftar QR Aktif
    Dan tidak ada QR meja lain selain 12 meja itu
    Dan "kasir-b" masuk mode seleksi lalu mencentang meja "AA - 01" sampai "AA - 12"
    Ketika "kasir-a" menghapus QR meja "AA - 12"
    Dan "kasir-b" menekan "Hapus" lalu mengonfirmasi
    Maka "kasir-b" melihat toast sukses berbunyi "11 QR Statis Berhasil Dihapus"
    Dan Daftar QR Aktif menampilkan empty state "Belum ada QR yang aktif"
    Dan tidak ada modal error yang muncul

  @SO-QRN-B4 @negative @race-condition @multi-sesi @modal-satu-tombol
  Garis-Besar Skenario: B4 - hapus gagal total karena didahului device lain
    Diketahui QR meja "<meja>" sudah ada di Daftar QR Aktif
    Dan "kasir-b" masuk mode seleksi lalu mencentang meja "<meja>"
    Ketika "kasir-a" menghapus QR meja "<meja>"
    Dan "kasir-b" menekan "Hapus" lalu mengonfirmasi
    Maka "kasir-b" melihat modal error berjudul "QR Meja Gagal Dihapus"
    Dan deskripsi modal error berbunyi "<deskripsi>"
    Dan modal error hanya punya tombol "Baik, Saya mengerti"
    Ketika "kasir-b" menekan "Baik, Saya mengerti"
    Maka data di Daftar QR Aktif dimuat ulang
    Dan QR meja "<meja>" tidak lagi tampil di Daftar QR Aktif

    Contoh:
      | varian  | meja                                                                                                      | deskripsi                                                                                                    |
      | 1 meja  | AA - 01                                                                                                   | QR Meja AA - 01 gagal dihapus karena sudah dihapus lebih dulu oleh pengguna lain.                             |
      | 2 meja  | AA - 01, AA - 02                                                                                          | QR Meja AA - 01 dan AA - 02 gagal dihapus karena sudah dihapus lebih dulu oleh pengguna lain.                 |
      | 3 meja  | AA - 01, AA - 02, AA - 03                                                                                 | QR Meja AA - 01, AA - 02 dan AA - 03 gagal dihapus karena sudah dihapus lebih dulu oleh pengguna lain.        |
      | 12 meja | AA - 01, AA - 02, AA - 03, AA - 04, AA - 05, AA - 06, AA - 07, AA - 08, AA - 09, AA - 10, AA - 11, AA - 12 | QR Meja AA - 01, AA - 02 dan 10 meja lainnya gagal dihapus karena sudah dihapus lebih dulu oleh pengguna lain. |

  @SO-QRN-B5 @negative @race-condition @multi-sesi @modal-satu-tombol
  Skenario: B5 - cetak QR yang sudah dihapus device lain
    Diketahui QR meja "AA - 01" sudah ada di Daftar QR Aktif
    Dan printer sudah terhubung di perangkat "kasir-b"
    Dan "kasir-b" membuka halaman QR Management
    Ketika "kasir-a" menghapus QR meja "AA - 01"
    Dan "kasir-b" memilih "Cetak QR" dari kebab menu pada baris "AA - 01"
    Maka tidak ada perintah cetak yang dikirim ke printer
    Dan "kasir-b" melihat modal error berjudul "QR Meja Gagal Dicetak"
    Dan deskripsi modal error berbunyi "QR Meja AA - 01 gagal dicetak karena sudah dihapus lebih dulu oleh pengguna lain."
    Dan modal error hanya punya tombol "Baik, Saya mengerti"
    Ketika "kasir-b" menekan "Baik, Saya mengerti"
    Maka data di Daftar QR Aktif dimuat ulang
    Dan QR meja "AA - 01" tidak lagi tampil di Daftar QR Aktif

  # ---------------------------------------------------------------- C. Hapus QR yang sedang dipakai

  # Perilaku yang BENAR di sini: hapus hanya menutup pintu masuk pesanan BARU.
  # Sesi pelanggan yang sedang jalan TIDAK terputus - jangan dilaporkan sebagai bug.
  # Butuh sesi pelanggan aktif, jadi ditandai manual sampai ada fixture yang bisa
  # membuka sesi Self Order dari sisi pelanggan.
  @SO-QRN-C @negative @manual-dulu
  Skenario: C - hapus QR meja yang sedang dipakai order berjalan
    Diketahui QR meja "AA - 01" sudah ada di Daftar QR Aktif
    Dan ada sesi pelanggan aktif yang memakai QR meja "AA - 01"
    Dan "kasir-a" membuka halaman QR Management
    Ketika "kasir-a" menghapus QR meja "AA - 01"
    Maka tidak ada peringatan tambahan yang muncul selain konfirmasi hapus biasa
    Dan QR meja "AA - 01" tidak lagi tampil di Daftar QR Aktif
    Dan sesi pelanggan pada meja "AA - 01" tetap berjalan sampai selesai
    Dan QR meja "AA - 01" tidak bisa dipakai lagi untuk pesanan baru

  # ---------------------------------------------------------------- D. Printer tidak terhubung

  @SO-QRN-D @negative @modal-dua-tombol @butuh-frame
  Skenario: D - cetak QR tanpa printer terhubung
    Diketahui QR meja "AA - 01" sudah ada di Daftar QR Aktif
    Dan tidak ada printer yang terhubung ke perangkat "kasir-a"
    Dan "kasir-a" membuka halaman QR Management
    Ketika "kasir-a" memilih "Cetak QR" dari kebab menu pada baris "AA - 01"
    Maka "kasir-a" melihat modal error berjudul "Gagal melakukan cetak otomatis"
    Dan deskripsi modal error berbunyi "Belum ada printer terhubung ke perangkat Anda. Silahkan hubungkan printer untuk dapat mencetak."
    Dan modal error punya tombol "Lewati" dan "Hubungkan printer"
    Ketika "kasir-a" menekan "Hubungkan printer"
    Maka "kasir-a" diarahkan ke halaman "Pengaturan > Printer"

  # ---------------------------------------------------------------- E. Hak akses

  @SO-QRN-E1 @negative @permission @kontrol-hilang
  Skenario: E1 - QR Management tanpa hak akses Mengelola QR Self Order
    Diketahui karyawan "waiter-x" tidak punya hak akses "Mengelola QR Self Order"
    Dan QR meja "AA - 01, AA - 02" sudah ada di Daftar QR Aktif
    Ketika "waiter-x" membuka halaman QR Management
    Maka halaman QR Management terbuka dengan judul "QR Management"
    Dan blok "Generate QR untuk meja terpilih" tidak tampil
    Dan link "Pilih" di header Daftar QR Aktif tidak tampil
    Dan tidak ada kebab menu pada baris Daftar QR Aktif
    Dan blok "Ekspor data ke Self Order" tampil dan bisa dipakai
    Dan kolom pencarian "Cari daftar QR" tampil

  @SO-QRN-E1 @negative @permission @api
  Skenario: E1b - permission juga ditolak di sisi server, bukan hanya UI
    Diketahui karyawan "waiter-x" tidak punya hak akses "Mengelola QR Self Order"
    Ketika "waiter-x" mengirim request generate QR langsung ke endpoint
    Maka server menolak request dengan status 403

  @SO-QRN-E3 @negative @permission @butuh-frame
  Skenario: E3 - hak akses dicabut saat halaman QR Management sedang terbuka
    Diketahui karyawan "waiter-x" punya hak akses "Mengelola QR Self Order"
    Dan QR meja "AA - 01, AA - 02" sudah ada di Daftar QR Aktif
    Dan "waiter-x" membuka halaman QR Management
    Ketika hak akses "Mengelola QR Self Order" dicabut dari karyawan "waiter-x"
    Maka halaman QR Management masih tampil untuk "waiter-x"
    Ketika "waiter-x" mengirim request generate QR langsung ke endpoint
    Maka server menolak request dengan status 403
    Dan halaman QR Management masih tampil untuk "waiter-x"
    Ketika "waiter-x" menekan tombol sinkronisasi data terbaru
    Dan sinkronisasi selesai
    Maka halaman ter-refresh
    Dan menu "QR Management" tidak lagi tersedia untuk "waiter-x"
    Dan halaman QR Management tidak bisa dibuka lagi oleh "waiter-x"
    Dan tidak ada modal atau toast peringatan yang muncul

  @SO-QRN-E2 @negative @tanpa-pesan
  Skenario: E2 - permission aktif tapi fitur global belum aktif di Setup AOL
    Diketahui karyawan "kasir-a" punya hak akses "Mengelola QR Self Order"
    Dan fitur "QR Self Order" belum aktif di Setup AOL
    Ketika "kasir-a" membuka menu Pengaturan
    Maka tidak ada modal atau toast peringatan yang muncul
