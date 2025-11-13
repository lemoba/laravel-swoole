<?php

use App\Http\Controllers\HealthController;

Route::group([
    'prefix' => 'v1'
], function () {
    Route::get('test', [HealthController::class, 'test']);
});