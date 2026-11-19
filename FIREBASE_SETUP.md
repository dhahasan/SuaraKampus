# ðŸš€ Panduan Integrasi Database Firebase â€” SuaraKampus

Aplikasi **SuaraKampus** telah berhasil dimigrasikan dan disempurnakan menggunakan ekosistem **Google Firebase** lengkap (Authentication, Cloud Firestore, dan Firebase Storage).

---

## ðŸ“Œ Arsitektur & Fitur Firebase yang Telah Terintegrasi

| Layanan Firebase | Fungsi dalam Aplikasi SuaraKampus |
| :--- | :--- |
| **Firebase Authentication** | Autentikasi email kampus (`@mahasiswa.kampus.ac.id`) & password, pembagian peran Mahasiswa vs Admin. |
| **Cloud Firestore** | Database NoSQL realtime untuk koleksi: `users`, `menfess`, `reports`, `dispositions`, `instagram_queue`. Menggunakan **Stream/Snapshots Realtime** sehingga postingan atau moderasi langsung ter-update di layar tanpa reload manual. |
| **Firebase Storage** | Penyimpanan awan aman untuk foto KTM verifikasi (`users_ktm/`) dan lampiran bukti aspirasi (`menfess_attachments/`). |
| **Proteksi Fallback** | Dilengkapi sistem *fail-safe* di mana aplikasi tetap berjalan 100% normal dengan data lokal apabila perangkat sedang offline atau belum dihubungkan ke akun Google Cloud. |

---

## ðŸ› ï¸ Struktur Koleksi Firestore

### 1. Koleksi `users`
* `id` (String): ID / UID Pengguna
* `email` (String): Email kampus pengguna
* `role` (String): `'student'` atau `'admin'`
* `verificationStatus` (String): `'pending'`, `'verified'`, atau `'rejected'`
* `ktmUrl` (String?): Tautan URL foto KTM di Firebase Storage
* `monthlyQuotaUsed` (int): Jumlah menfess terpakai bulan ini (maksimal 5)
* `monthlyQuotaMax` (int): Batas kuota bulanan (default 5)

### 2. Koleksi `menfess`
* `id` (String): ID Dokumen
* `code` (String): Kode tiket publik (contoh: `#MNF-1042`)
* `category` (String): `'akademik'`, `'sarpras'`, `'keuangan'`, `'layananIt'`
* `body` (String): Teks keluhan / aspirasi
* `attachmentUrl` (String?): URL gambar bukti di Firebase Storage
* `attachmentName` (String?): Nama berkas lampiran
* `status` (String): `'pending'`, `'approved'`, `'rejected'`, `'inProgress'`, `'resolved'`
* `allowInstagram` (bool): Apakah diizinkan masuk kurasi Instagram
* `isAnonymous` (bool): Tampil sebagai anonim di feed publik
* `supportCount` (int): Jumlah dukungan *"Saya juga"*
* `reportCount` (int): Jumlah pelaporan pelanggaran
* `isSensitive` (bool): Penanda jika menyebut nama dosen / perlu sensor
* `createdAt` (String / Timestamp): Waktu pengiriman

### 3. Koleksi `dispositions` & `instagram_queue`
* Menangani alur tindak lanjut birokrasi kampus dan kurasi sosial media Instagram oleh Admin.

---

## âš™ï¸ Cara Menghubungkan Firebase Project Sendiri

Jika Anda ingin menghubungkan aplikasi ke Firebase Project milik Anda di Firebase Console:

### Opsi A: Menggunakan FlutterFire CLI (Direkomendasikan)
1. Buka terminal di folder `SuaraKampus`:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
2. Pilih project Firebase Anda. Perintah ini akan memperbarui berkas `lib/firebase_options.dart` secara otomatis.

### Opsi B: Memasukkan Kunci Manual di `lib/firebase_options.dart`
Buka berkas `lib/firebase_options.dart`, lalu ganti nilai konstanta berikut dengan kredensial project Firebase Anda:
* `apiKey`
* `appId`
* `messagingSenderId`
* `projectId`
* `storageBucket`

Untuk platform Android, Anda juga dapat mengunduh berkas `google-services.json` dari Firebase Console dan meletakkannya di folder:
`SuaraKampus/android/app/google-services.json`.

---

## ðŸ”’ Aturan Keamanan (Firestore Security Rules)

Di Firebase Console > **Firestore Database** > tab **Rules**, gunakan aturan berikut untuk pengujian:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // Ubah sesuai kebutuhan produksi
    }
  }
}
```

Dan untuk **Firebase Storage** > tab **Rules**:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```
