#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FCT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
WORKSPACE_ROOT="$(cd "$FCT_ROOT/.." && pwd)"
PX4_ROOT="$WORKSPACE_ROOT/PX4-Autopilot"

BUILD_DIR="$PX4_ROOT/build/px4_sitl_default"
PX4_BIN="$BUILD_DIR/bin/px4"
ROOTFS_DIR="$BUILD_DIR/rootfs"
LOG_DIR="$FCT_ROOT/logs/two_drones_gz"

AUTOSTART_ID=4001
MODEL="gz_x500"
DRONE_2_POSE="0,1"

cleanup() {
  echo "[cleanup] stopping previous PX4/Gazebo processes..."
  pkill -9 -f "$PX4_BIN" || true
  pkill -9 -f 'gz sim' || true
  pkill -9 -f 'gz-server' || true

  echo "[cleanup] removing PX4 runtime leftovers..."
  find "$ROOTFS_DIR" -maxdepth 1 -type d -name 'instance_*' -exec rm -rf {} + 2>/dev/null || true
  find /tmp -maxdepth 1 \( -name 'px4*' -o -name '.px4*' \) -exec rm -f {} + 2>/dev/null || true
}

if [[ ! -x "$PX4_BIN" ]]; then
  echo "[error] PX4 binary not found: $PX4_BIN"
  echo "[hint] Build first with: cd $PX4_ROOT && make px4_sitl gz_x500"
  exit 1
fi

mkdir -p "$LOG_DIR"

cleanup

cd "$PX4_ROOT"

echo "[start] launching drone 1 (instance 0)..."
PX4_SYS_AUTOSTART=$AUTOSTART_ID \
PX4_SIM_MODEL=$MODEL \
"$PX4_BIN" -i 0 \
  > "$LOG_DIR/drone_0.log" 2>&1 &
DRONE_0_PID=$!

sleep 5

echo "[start] launching drone 2 (instance 1)..."
PX4_GZ_STANDALONE=1 \
PX4_SYS_AUTOSTART=$AUTOSTART_ID \
PX4_GZ_MODEL_POSE="$DRONE_2_POSE" \
PX4_SIM_MODEL=$MODEL \
"$PX4_BIN" -i 1 \
  > "$LOG_DIR/drone_1.log" 2>&1 &
DRONE_1_PID=$!

echo "[ok] two PX4 instances launched"
echo "[info] drone 1 pid: $DRONE_0_PID"
echo "[info] drone 2 pid: $DRONE_1_PID"
echo "[info] logs:"
echo "  - $LOG_DIR/drone_0.log"
echo "  - $LOG_DIR/drone_1.log"
echo
echo "[info] press Ctrl+C to stop everything"

trap cleanup INT TERM EXIT

wait "$DRONE_0_PID" "$DRONE_1_PID"