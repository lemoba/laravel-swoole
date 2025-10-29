#!/bin/sh
set -e

# -----------------------------
# 环境变量
# -----------------------------
OCTANE_TASK_WORKERS=${OCTANE_TASK_WORKERS:-1}
OCTANE_MAX_REQUESTS=${OCTANE_MAX_REQUESTS:-5000}
OCTANE_PORT=${OCTANE_PORT:-8000}
AUTORUN_OPTIMIZE=${AUTORUN_OPTIMIZE:-false}

# -----------------------------
# 获取 Workers 数量
# -----------------------------
if [ -n "$OCTANE_WORKERS" ]; then
    WORKERS=$OCTANE_WORKERS
else
    # 自动计算容器可用 CPU 核心数
    if [ -f /sys/fs/cgroup/cpu.max ]; then
        # cgroup v2
        CPU_MAX=$(cut -d' ' -f1 /sys/fs/cgroup/cpu.max)
        CPU_PERIOD=$(cut -d' ' -f2 /sys/fs/cgroup/cpu.max)
        if [ "$CPU_MAX" != "max" ]; then
            CPU_COUNT=$(( (CPU_MAX + CPU_PERIOD - 1) / CPU_PERIOD ))
        else
            CPU_COUNT=$(nproc)
        fi
    else
        # cgroup v1 或默认
        CPU_QUOTA=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us 2>/dev/null)
        CPU_PERIOD=$(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us 2>/dev/null)
        if [ -n "$CPU_QUOTA" ] && [ "$CPU_QUOTA" -gt 0 ]; then
            CPU_COUNT=$((CPU_QUOTA / CPU_PERIOD))
        else
            CPU_COUNT=$(nproc)
        fi
    fi

    [ "$CPU_COUNT" -lt 1 ] && CPU_COUNT=1

    # workers = CPU 核心数 * 2
    WORKERS=$(( CPU_COUNT * 2 ))
fi


if [ "$AUTORUN_OPTIMIZE" = "true" ]; then
    echo "⚙️  Running Laravel optimize commands..."
    php artisan optimize || true
else
    echo "⏩  Skipping Laravel optimization (AUTORUN_OPTIMIZE=false)"
fi

# 打印配置信息

echo "-----------------------------------"
echo "🚀 Laravel Octane Swoole"
echo "-----------------------------------"

echo "Workers:        $WORKERS"
echo "Task Workers:   $OCTANE_TASK_WORKERS"
echo "Max Requests:   $OCTANE_MAX_REQUESTS"
echo "Octane Port:    $OCTANE_PORT"

echo "-----------------------------------"

# -----------------------------
# 启动 Octane
# -----------------------------
exec php artisan octane:start \
    --server=swoole \
    --workers=$WORKERS \
    --task-workers=$OCTANE_TASK_WORKERS \
    --max-requests=$OCTANE_MAX_REQUESTS \
    --host=0.0.0.0 \
    --port=$OCTANE_PORT