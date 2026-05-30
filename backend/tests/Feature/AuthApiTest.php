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
            'email' => 'admin@perfumeshelf.com',
            'password' => Hash::make('admin123'),
            'role' => 'admin',
        ]);

        $response = $this->postJson('/api/login', [
            'email' => 'admin@perfumeshelf.com',
            'password' => 'admin123',
        ]);

        $response
            ->assertOk()
            ->assertJsonPath('user.email', 'admin@perfumeshelf.com')
            ->assertJsonPath('user.role', 'admin');
    }
}
