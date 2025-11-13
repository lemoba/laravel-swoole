<?php

use Illuminate\Support\Facades\Route;

Route::any('{any}', function () {
    return response()->json([
        'code' => 0,
        'message' => 'API endpoint not found.'
    ]);
})->where('any', '.*');
