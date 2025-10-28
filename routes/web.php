<?php

use Illuminate\Support\Facades\Route;

Route::get('/test', function () {
    return response()->json([
        'code' => 0,
        'msg' => "hello world"
    ]);
});
