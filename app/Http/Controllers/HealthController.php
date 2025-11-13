<?php

namespace App\Http\Controllers;

use App\Enums\JobName;
use App\Jobs\OrderAutoCancelJob;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class HealthController extends Controller
{
    public function order(Request $request)
    {
        $orderId = Str::random(10);

        OrderAutoCancelJob::dispatch($orderId)->onQueue(JobName::ORDER_CANCEL->value);

        return response()->json(['code' => 0, 'message' => 'success', 'data' => [
            'order_id' => $orderId,
        ]]);
    }

    public function test()
    {
        $data = ['code' => 0, 'message' => 'success', 'data' => []];

        return response()->json($data);
    }
}
