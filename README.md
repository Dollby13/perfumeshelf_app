# PerfumeShelf

PerfumeShelf adalah aplikasi mobile full-stack untuk mengelola katalog parfum. Aplikasi ini dibuat dengan Flutter sebagai frontend, Laravel sebagai RESTful API, dan MySQL sebagai database relasional.

Project ini disusun untuk memenuhi Tugas Besar pengembangan aplikasi mobile full-stack: autentikasi pengguna, manajemen profil, dan CRUD data utama melalui backend API.

## Fitur Utama

- Register user dengan validasi email dan password minimum.
- Login menggunakan akun terdaftar dan token Laravel Sanctum.
- Logout dengan penghapusan token dari secure local storage.
- Profil user: tampilkan data, update nama, nomor telepon, bio, dan foto profil.
- CRUD katalog parfum untuk admin: tambah, lihat daftar, lihat detail, edit, dan hapus data.
- Dialog konfirmasi sebelum data parfum dihapus.
- Role admin dan user.
- Mode guest untuk preview katalog.
- UI responsif dengan loading indicator, snackbar, hero image, card list, dan navigasi bawah.

## Teknologi

| Bagian | Teknologi |
| --- | --- |
| Frontend | Flutter, Dart |
| Backend | Laravel 9, PHP |
| Database | MySQL |
| Auth API | Laravel Sanctum Bearer Token |
| HTTP Client | package `http` |
| Local Token Storage | `flutter_secure_storage` |

## Struktur Project

```text
perfumeshelf_app/
|-- backend/     # Laravel REST API
|-- frontend/    # Flutter mobile app
+-- README.md
```

## Skema Database

Minimal tabel utama:

- `users`: data akun, role, profil, status banned, dan token Sanctum.
- `perfumes`: data katalog parfum.
- `personal_access_tokens`: token autentikasi Laravel Sanctum.

Relasi:

- `users.id` memiliki banyak `perfumes.user_id`.
- `perfumes.user_id` adalah foreign key ke tabel `users`.

## Endpoint API

Base URL default:

```text
http://127.0.0.1:8000/api
```

Endpoint publik:

| Method | Endpoint | Fungsi |
| --- | --- | --- |
| POST | `/register` | Register user baru |
| POST | `/login` | Login dan mendapatkan token |

Endpoint protected, wajib header:

```text
Authorization: Bearer <token>
Accept: application/json
```

| Method | Endpoint | Fungsi |
| --- | --- | --- |
| GET | `/profile` | Menampilkan profil user login |
| PUT | `/profile` | Update profil user login |
| POST | `/logout` | Logout dan hapus token aktif |
| GET | `/perfumes` | Menampilkan daftar parfum |
| GET | `/perfumes/{id}` | Menampilkan detail parfum |
| POST | `/perfumes` | Tambah parfum, admin only |
| PUT | `/perfumes/{id}` | Update parfum, admin only |
| DELETE | `/perfumes/{id}` | Hapus parfum, admin only |

## Cara Menjalankan Backend

Masuk ke folder backend:

```powershell
cd backend
composer install
copy .env.example .env
php artisan key:generate
```

Atur database MySQL di file `.env`:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=perfumeshelf_db
DB_USERNAME=root
DB_PASSWORD=
```

Buat database `perfumeshelf_db`, lalu jalankan migration dan seeder:

```powershell
php artisan migrate --seed
php artisan serve
```

Backend berjalan di:

```text
http://127.0.0.1:8000
```

## Cara Menjalankan Frontend

Masuk ke folder frontend:

```powershell
cd frontend
flutter pub get
flutter run
```

Catatan URL API:

- Android Emulator otomatis memakai:

```text
http://10.0.2.2:8000/api
```

- Platform lain otomatis memakai:

```text
http://127.0.0.1:8000/api
```

Jika memakai HP fisik, sesuaikan `frontend/lib/services/api_config.dart` ke IP laptop dalam jaringan yang sama.

## Akun Demo

Seeder backend membuat akun demo:

```text
Email    : admin@gmail.com
Password : admin123
Role     : admin

Email    : tesuser@example.com
Password : 123456
Role     : user
```

User biasa lain tetap dapat dibuat melalui halaman Register.

## Checklist Kesesuaian Tugas

| Ketentuan | Status |
| --- | --- |
| Flutter sebagai frontend | Sesuai |
| Laravel sebagai backend RESTful API | Sesuai |
| MySQL sebagai database | Sesuai |
| Register, login, logout | Sesuai |
| Token auth dan endpoint protected | Sesuai |
| Profil read dan update | Sesuai |
| CRUD entitas utama | Sesuai, entitas `perfumes` |
| List view dan detail view | Sesuai |
| Dialog konfirmasi delete | Sesuai |
| Minimal 2 tabel berelasi | Sesuai, `users` dan `perfumes` |
| Feedback UI loading/snackbar | Sesuai |

## Testing

Backend:

```powershell
cd backend
php artisan test
```

Frontend:

```powershell
cd frontend
flutter test
```

## Catatan

Project menggunakan Laravel 9 karena environment lokal memakai PHP 8.0.30. Jika ingin memakai Laravel versi terbaru, upgrade PHP terlebih dahulu.
