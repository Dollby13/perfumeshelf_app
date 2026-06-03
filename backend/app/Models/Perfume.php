<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Perfume extends Model
{
    use HasFactory;

    protected $fillable = [
        'nama_parfum',
        'merek',
        'aroma',
        'ukuran',
        'konsentrasi',
        'status',
        'catatan',
        'image_url',
    ];
}
