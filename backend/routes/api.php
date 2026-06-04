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
        'password' => ['required', 'string', 'min:6'],
    ]);

    $user = User::create([
        'name' => $data['name'],
        'email' => strtolower($data['email']),
        'password' => Hash::make($data['password']),
        'role' => 'user',
    ]);

    return response()->json([
        'message' => 'Register berhasil',
        'token' => $user->createToken('mobile-token')->plainTextToken,
        'user' => userPayload($user),
    ], 201);
});

Route::post('/login', function (Request $request): JsonResponse {
    ensureDemoAccounts();

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

    if (! Hash::check(trim($data['password']), $user->password)) {
        throw ValidationException::withMessages([
            'email' => ['Email atau password salah'],
        ]);
    }

    return response()->json([
        'message' => 'Login berhasil',
        'token' => $user->createToken('mobile-token')->plainTextToken,
        'user' => userPayload($user),
    ]);
});

Route::middleware('auth:sanctum')->group(function (): void {
    Route::get('/profile', function (Request $request): JsonResponse {
        return response()->json([
            'user' => userPayload($request->user()),
        ]);
    });

    Route::put('/profile', function (Request $request): JsonResponse {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'phone' => ['nullable', 'string', 'max:30'],
            'bio' => ['nullable', 'string'],
            'profile_photo' => ['nullable', 'string'],
        ]);

        $user = $request->user();

        $user->update([
            'name' => $data['name'],
            'phone' => $data['phone'] ?? null,
            'bio' => $data['bio'] ?? null,
            'profile_photo' => $data['profile_photo'] ?? null,
        ]);

        return response()->json([
            'message' => 'Profil berhasil diperbarui',
            'user' => userPayload($user->fresh()),
        ]);
    });

    Route::post('/logout', function (Request $request): JsonResponse {
        $request->user()->currentAccessToken()?->delete();

        return response()->json([
            'message' => 'Logout berhasil',
        ]);
    });

    Route::delete('/users/by-name', function (Request $request): JsonResponse {
        abort_if($request->user()->role !== 'admin', 403, 'Hanya admin yang boleh menghapus user');

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
        ensureDefaultPerfumes();

        return response()->json([
            'data' => Perfume::with('user:id,name,email')->latest()->get(),
        ]);
    });

    Route::get('/perfumes/{perfume}', function (Perfume $perfume): JsonResponse {
        return response()->json([
            'data' => $perfume->load('user:id,name,email'),
        ]);
    });

    Route::post('/perfumes', function (Request $request): JsonResponse {
        abort_if($request->user()->role !== 'admin', 403, 'Hanya admin yang boleh menambah parfum');

        $data = perfumePayload($request);

        $perfume = $request->user()->perfumes()->create($data);

        return response()->json([
            'message' => 'Parfum berhasil ditambahkan',
            'data' => $perfume->load('user:id,name,email'),
        ], 201);
    });

    Route::put('/perfumes/{perfume}', function (Request $request, Perfume $perfume): JsonResponse {
        abort_if($request->user()->role !== 'admin', 403, 'Hanya admin yang boleh mengubah parfum');

        $data = perfumePayload($request);

        $perfume->update($data);

        return response()->json([
            'message' => 'Parfum berhasil diperbarui',
            'data' => $perfume->fresh()->load('user:id,name,email'),
        ]);
    });

    Route::delete('/perfumes/{perfume}', function (Request $request, Perfume $perfume): JsonResponse {
        abort_if($request->user()->role !== 'admin', 403, 'Hanya admin yang boleh menghapus parfum');

        $perfume->delete();

        return response()->json([
            'message' => 'Parfum berhasil dihapus',
        ]);
    });

    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});

if (! function_exists('userPayload')) {
    function userPayload(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'role' => $user->role,
            'phone' => $user->phone,
            'bio' => $user->bio,
            'profile_photo' => $user->profile_photo,
        ];
    }
}

if (! function_exists('perfumePayload')) {
    function perfumePayload(Request $request): array
    {
        return $request->validate([
            'nama_parfum' => ['required', 'string', 'max:255'],
            'merek' => ['required', 'string', 'max:255'],
            'aroma' => ['required', 'string', 'max:255'],
            'ukuran' => ['required', 'string', 'max:255'],
            'konsentrasi' => ['required', 'string', 'max:255'],
            'status' => ['required', 'string', 'max:255'],
            'catatan' => ['nullable', 'string'],
            'image_url' => ['nullable', 'string'],
        ]);
    }
}

if (! function_exists('ensureDemoAccounts')) {
    function ensureDemoAccounts(): void
    {
        User::updateOrCreate(
            ['email' => 'admin@gmail.com'],
            [
                'name' => 'Admin PerfumeShelf',
                'password' => Hash::make('admin123'),
                'role' => 'admin',
                'is_banned' => false,
            ]
        );

        User::updateOrCreate(
            ['email' => 'tesuser@example.com'],
            [
                'name' => 'Tes User',
                'password' => Hash::make('123456'),
                'role' => 'user',
                'is_banned' => false,
            ]
        );
    }
}

if (! function_exists('ensureDefaultPerfumes')) {
    function ensureDefaultPerfumes(): void
    {
        if (Perfume::count() > 0) {
            return;
        }

        ensureDemoAccounts();

        $admin = User::where('email', 'admin@gmail.com')->first();

        foreach (defaultPerfumes() as $perfume) {
            Perfume::updateOrCreate(
                ['nama_parfum' => $perfume['nama_parfum']],
                array_merge($perfume, ['user_id' => $admin?->id])
            );
        }
    }
}

if (! function_exists('defaultPerfumes')) {
    function defaultPerfumes(): array
    {
        return [
            [
                'nama_parfum' => 'Dior Sauvage',
                'merek' => 'Dior',
                'aroma' => 'Fresh Spicy',
                'ukuran' => 'Full Bottle - 100ml',
                'konsentrasi' => 'EDT - harian',
                'status' => 'Favorit Admin',
                'catatan' => 'Cocok digunakan untuk acara malam dan kegiatan outdoor.',
                'image_url' => 'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=500&q=80',
            ],
            [
                'nama_parfum' => 'Bleu de Chanel',
                'merek' => 'Chanel',
                'aroma' => 'Woody Aromatic',
                'ukuran' => 'Full Bottle - 100ml',
                'konsentrasi' => 'EDP - tahan lama',
                'status' => 'Rekomendasi',
                'catatan' => 'Aromanya elegan, clean, dan tahan lama.',
                'image_url' => 'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=500&q=80',
            ],
            [
                'nama_parfum' => 'YSL Y',
                'merek' => 'Yves Saint Laurent',
                'aroma' => 'Fresh Aromatic',
                'ukuran' => 'Compact Bottle - 50ml',
                'konsentrasi' => 'EDP - tahan lama',
                'status' => 'Tersedia',
                'catatan' => 'Cocok untuk pemakaian harian.',
                'image_url' => 'https://images.unsplash.com/photo-1587017539504-67cfbddac569?auto=format&fit=crop&w=500&q=80',
            ],
            [
                'nama_parfum' => 'California',
                'merek' => 'Mykonos',
                'aroma' => 'Citrus Aquatic',
                'ukuran' => 'Compact Bottle - 50ml',
                'konsentrasi' => 'EDP - tahan lama',
                'status' => 'Guest Preview',
                'catatan' => 'Aroma citrus yang segar, akuatik, dan nyaman untuk siang hari.',
                'image_url' => 'https://images.unsplash.com/photo-1595425970377-c9703cf48b6d?auto=format&fit=crop&w=500&q=80',
            ],
        ];
    }
}
