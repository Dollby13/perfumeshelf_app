<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register_with_default_user_role()
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Atep Mania',
            'email' => 'atepmania@gmail.com',
            'password' => 'secret123',
        ]);

        $response
            ->assertCreated()
            ->assertJsonStructure(['token'])
            ->assertJsonPath('user.email', 'atepmania@gmail.com')
            ->assertJsonPath('user.role', 'user');

        $this->assertDatabaseHas('users', [
            'email' => 'atepmania@gmail.com',
            'role' => 'user',
        ]);
    }

    public function test_user_can_login_and_receive_role()
    {
        User::create([
            'name' => 'Admin PerfumeShelf',
            'email' => 'admin@gmail.com',
            'password' => Hash::make('admin123'),
            'role' => 'admin',
        ]);

        $response = $this->postJson('/api/login', [
            'email' => 'admin@gmail.com',
            'password' => 'admin123',
        ]);

        $response
            ->assertOk()
            ->assertJsonStructure(['token'])
            ->assertJsonPath('user.email', 'admin@gmail.com')
            ->assertJsonPath('user.role', 'admin');
    }

    public function test_demo_user_can_login()
    {
        User::create([
            'name' => 'Tes User',
            'email' => 'tesuser@example.com',
            'password' => Hash::make('123456'),
            'role' => 'user',
        ]);

        $response = $this->postJson('/api/login', [
            'email' => 'tesuser@example.com',
            'password' => '123456',
        ]);

        $response
            ->assertOk()
            ->assertJsonStructure(['token'])
            ->assertJsonPath('user.email', 'tesuser@example.com')
            ->assertJsonPath('user.role', 'user');
    }

    public function test_profile_requires_token()
    {
        $this->getJson('/api/profile')->assertUnauthorized();
    }

    public function test_authenticated_user_can_update_profile()
    {
        $user = User::create([
            'name' => 'User PerfumeShelf',
            'email' => 'user@perfumeshelf.com',
            'password' => Hash::make('secret123'),
            'role' => 'user',
        ]);

        $token = $user->createToken('test-token')->plainTextToken;

        $response = $this
            ->withHeader('Authorization', "Bearer {$token}")
            ->putJson('/api/profile', [
                'name' => 'User Updated',
                'phone' => '081234567890',
                'bio' => 'Suka parfum fresh dan woody.',
            ]);

        $response
            ->assertOk()
            ->assertJsonPath('user.name', 'User Updated')
            ->assertJsonPath('user.phone', '081234567890');
    }

    public function test_admin_can_create_perfume_with_user_relation()
    {
        $admin = User::create([
            'name' => 'Admin PerfumeShelf',
            'email' => 'admin@perfumeshelf.com',
            'password' => Hash::make('admin123'),
            'role' => 'admin',
        ]);

        $token = $admin->createToken('test-token')->plainTextToken;

        $response = $this
            ->withHeader('Authorization', "Bearer {$token}")
            ->postJson('/api/perfumes', [
                'nama_parfum' => 'Ocean Bloom',
                'merek' => 'PerfumeShelf Lab',
                'aroma' => 'Marine Floral',
                'ukuran' => 'Compact Bottle - 50ml',
                'konsentrasi' => 'EDP - tahan lama',
                'status' => 'Tersedia',
                'catatan' => 'Segar untuk aktivitas harian.',
                'image_url' => 'https://example.com/ocean-bloom.jpg',
            ]);

        $response
            ->assertCreated()
            ->assertJsonPath('data.user_id', $admin->id);

        $this->assertDatabaseHas('perfumes', [
            'nama_parfum' => 'Ocean Bloom',
            'user_id' => $admin->id,
        ]);
    }
}
