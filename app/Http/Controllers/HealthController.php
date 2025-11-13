<?php

namespace App\Http\Controllers;

class HealthController extends Controller
{
    public function test()
    {
        $data = ['code' => 0, 'message' => 'success', 'data' => []];

        return response()->json($data);
    }
}
