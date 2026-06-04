<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Perfume extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'nama_parfum',
        'merek',
        'aroma',
        'ukuran',
        'konsentrasi',
        'status',
        'catatan',
        'image_url',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
