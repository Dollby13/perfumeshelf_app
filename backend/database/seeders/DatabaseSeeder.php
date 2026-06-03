<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Perfume;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        User::updateOrCreate(
            ['email' => 'admin@gmail.com'],
            [
                'name' => 'Admin PerfumeShelf',
                'password' => Hash::make('admin123'),
                'role' => 'admin',
            ]
        );

        $perfumes = [
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

        foreach ($perfumes as $perfume) {
            Perfume::updateOrCreate(
                ['nama_parfum' => $perfume['nama_parfum']],
                $perfume
            );
        }
    }
}
