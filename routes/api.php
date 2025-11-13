<?php

use App\Http\Controllers\HealthController;

Route::group([
    'prefix' => 'v1'
], function () {
    Route::get('order', [HealthController::class, 'order']);
    Route::get('test', [HealthController::class, 'test']);
});