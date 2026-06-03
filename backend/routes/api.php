<?php

use App\Models\User;
use App\Models\Perfume;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Route;
use Illuminate\Validation\ValidationException;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('/register', function (Request $request): JsonResponse {
    $data = $request->validate([
        'name' => ['required', 'string', 'max:255'],
        'email' => ['required', 'email', 'max:255', 'unique:users,email'],
        'password' => ['required', 'string', 'min:3'],
    ]);

    $user = User::create([
        'name' => $data['name'],
        'email' => strtolower($data['email']),
        'password' => Hash::make($data['password']),
        'role' => 'user',
    ]);

    return response()->json([
        'message' => 'Register berhasil',
        'user' => [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'phone' => $user->phone,
            'bio' => $user->bio,
        ],
    ], 201);
});

Route::post('/login', function (Request $request): JsonResponse {
    $data = $request->validate([
        'email' => ['required', 'email'],
        'password' => ['required', 'string'],
    ]);

    $user = User::where('email', strtolower($data['email']))->first();

    if (! $user) {
        throw ValidationException::withMessages([
            'email' => ['Email atau password salah'],
        ]);
    }

    if ($user->is_banned) {
        throw ValidationException::withMessages([
            'email' => ['Akun kamu sudah diban oleh admin'],
        ]);
    }

    if (! Hash::check($data['password'], $user->password)) {
        throw ValidationException::withMessages([
            'email' => ['Email atau password salah'],
        ]);
    }

    return response()->json([
        'message' => 'Login berhasil',
        'user' => [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'phone' => $user->phone,
            'bio' => $user->bio,
        ],
    ]);
});

Route::put('/profile', function (Request $request): JsonResponse {
    $data = $request->validate([
        'email' => ['required', 'email'],
        'name' => ['required', 'string', 'max:255'],
        'phone' => ['nullable', 'string', 'max:30'],
        'bio' => ['nullable', 'string'],
    ]);

    $user = User::where('email', strtolower($data['email']))->first();

    if (! $user) {
        throw ValidationException::withMessages([
            'email' => ['User tidak ditemukan'],
        ]);
    }

    $user->update([
        'name' => $data['name'],
        'phone' => $data['phone'] ?? null,
        'bio' => $data['bio'] ?? null,
    ]);

    return response()->json([
        'message' => 'Profil berhasil diperbarui',
        'user' => [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'phone' => $user->phone,
            'bio' => $user->bio,
        ],
    ]);
});

Route::delete('/users/by-name', function (Request $request): JsonResponse {
    $data = $request->validate([
        'name' => ['required', 'string', 'max:255'],
        'email' => ['nullable', 'email'],
    ]);

    $userQuery = User::where('role', 'user');
    $user = empty($data['email'])
        ? $userQuery->where('name', $data['name'])->first()
        : $userQuery->where('email', strtolower($data['email']))->first();

    if (! $user) {
        throw ValidationException::withMessages([
            'name' => ['User tidak ditemukan'],
        ]);
    }

    $user->update([
        'is_banned' => true,
    ]);

    return response()->json([
        'message' => 'User berhasil diban',
    ]);
});

Route::get('/perfumes', function (): JsonResponse {
    return response()->json([
        'data' => Perfume::latest()->get(),
    ]);
});

Route::post('/perfumes', function (Request $request): JsonResponse {
    $data = $request->validate([
        'nama_parfum' => ['required', 'string', 'max:255'],
        'merek' => ['required', 'string', 'max:255'],
        'aroma' => ['required', 'string', 'max:255'],
        'ukuran' => ['required', 'string', 'max:255'],
        'konsentrasi' => ['required', 'string', 'max:255'],
        'status' => ['required', 'string', 'max:255'],
        'catatan' => ['nullable', 'string'],
        'image_url' => ['nullable', 'string'],
    ]);

    $perfume = Perfume::create($data);

    return response()->json([
        'message' => 'Parfum berhasil ditambahkan',
        'data' => $perfume,
    ], 201);
});

Route::put('/perfumes/{perfume}', function (Request $request, Perfume $perfume): JsonResponse {
    $data = $request->validate([
        'nama_parfum' => ['required', 'string', 'max:255'],
        'merek' => ['required', 'string', 'max:255'],
        'aroma' => ['required', 'string', 'max:255'],
        'ukuran' => ['required', 'string', 'max:255'],
        'konsentrasi' => ['required', 'string', 'max:255'],
        'status' => ['required', 'string', 'max:255'],
        'catatan' => ['nullable', 'string'],
        'image_url' => ['nullable', 'string'],
    ]);

    $perfume->update($data);

    return response()->json([
        'message' => 'Parfum berhasil diperbarui',
        'data' => $perfume->fresh(),
    ]);
});

Route::delete('/perfumes/{perfume}', function (Perfume $perfume): JsonResponse {
    $perfume->delete();

    return response()->json([
        'message' => 'Parfum berhasil dihapus',
    ]);
});

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
