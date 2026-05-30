# PerfumeShelf

Project ini dipisah menjadi dua aplikasi:

- `frontend/`: aplikasi Flutter untuk tampilan PerfumeShelf.
- `backend/`: aplikasi Laravel untuk API/backend.

## Menjalankan Frontend

```powershell
cd frontend
flutter pub get
flutter run
```

## Menjalankan Backend

```powershell
cd backend
composer install
php artisan serve
```

Backend dibuat dengan Laravel 9 karena PHP lokal saat ini versi 8.0.30.
Untuk Laravel terbaru, upgrade PHP ke versi yang lebih baru terlebih dahulu.
