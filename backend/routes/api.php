<?php

use App\Models\User;
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
        ],
    ], 201);
});

Route::post('/login', function (Request $request): JsonResponse {
    $data = $request->validate([
        'email' => ['required', 'email'],
        'password' => ['required', 'string'],
    ]);

    $user = User::where('email', strtolower($data['email']))->first();

    if (! $user || ! Hash::check($data['password'], $user->password)) {
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
        ],
    ]);
});

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
