<?php

Route::get('test', function () {
    return response()->json([
        'code' => 0,
        'message' => 'OK',
        'data' => "hello world"
    ]);
});