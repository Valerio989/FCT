#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FCT_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
PROJECT_PARENT="$(cd -- "${FCT_ROOT}/.." && pwd)"
PX4_AUTOPILOT_DIR="${PROJECT_PARENT}/PX4-Autopilot"
PX4_BIN="${PX4_AUTOPILOT_DIR}/build/px4_sitl_default/bin/px4"

usage() {
  cat <<EOF
Uso:
  ./launch_px4_sitl_3_drones.sh
  ./launch_px4_sitl_3_drones.sh --stop

Note:
- va lanciato da dentro kitty
- il terminale corrente diventa il drone 1
- drone 2 e drone 3 vengono aperti come split nella stessa tab
EOF
}

cleanup_runtime() {
  echo "[cleanup] stop processi residui..."
  pkill -f 'build/px4_sitl_default/bin/px4' || true
  pkill -f 'gz sim|gz-server|gz gui' || true
  pkill -f 'MicroXRCEAgent' || true
  sleep 2
}

check_requirements() {
  if [[ -z "${KITTY_WINDOW_ID:-}" ]]; then
    echo "Errore: questo script deve essere lanciato da dentro kitty."
    exit 1
  fi

  if [[ ! -x "${PX4_BIN}" ]]; then
    echo "Errore: binario PX4 non trovato o non eseguibile:"
    echo "  ${PX4_BIN}"
    exit 1
  fi

  if ! command -v kitten >/dev/null 2>&1; then
    echo "Errore: comando 'kitten' non trovato."
    exit 1
  fi

  if ! kitten @ ls >/dev/null 2>&1; then
    echo "Errore: kitty remote control non disponibile."
    echo "Abilita in kitty.conf:"
    echo "  allow_remote_control yes"
    exit 1
  fi
}

build_px4_command() {
  local instance_id="$1"
  local pose="$2"
  local standalone="$3"
  local log_file="$4"

  cat <<EOF
cd "${PX4_AUTOPILOT_DIR}"

export PX4_SYS_AUTOSTART=4001
export PX4_SIM_MODEL=gz_x500

if [[ "${standalone}" == "1" ]]; then
  export PX4_GZ_STANDALONE=1
fi

if [[ -n "${pose}" ]]; then
  export PX4_GZ_MODEL_POSE="${pose}"
fi

mkdir -p "$(dirname "${log_file}")"
exec > >(tee -a "${log_file}") 2>&1

echo "[info] timestamp: \$(date --iso-8601=seconds)"
echo "[info] instance_id: ${instance_id}"
echo "[info] mav_sys_id_atteso: $((instance_id + 1))"
echo "[info] pose: ${pose:-default}"
echo "[info] standalone: ${standalone}"
echo "[info] log_file: ${log_file}"
echo

./build/px4_sitl_default/bin/px4 -i "${instance_id}"
rc=\$?

echo
echo "[info] PX4 terminato con exit code \$rc"
exec bash
EOF
}

launch_split_drone() {
  local instance_id="$1"
  local pose="$2"
  local standalone="$3"
  local location="$4"
  local drone_number=$((instance_id + 1))
  local log_file="${LOG_ROOT}/drone_${drone_number}.log"
  local window_title="FCT PX4 Drone ${drone_number}"

  local cmd
  cmd="$(build_px4_command "${instance_id}" "${pose}" "${standalone}" "${log_file}")"

  echo "[launch] drone_${drone_number} -> location=${location} | pose=${pose:-default}"
  kitten @ launch \
    --window-title "${window_title}" \
    --location "${location}" \
    bash -lc "${cmd}"
}

if [[ "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--stop" ]]; then
  cleanup_runtime
  echo "[cleanup] completato"
  exit 0
fi

if [[ $# -gt 0 ]]; then
  usage
  exit 1
fi

check_requirements

LOG_ROOT="${FCT_ROOT}/logs/px4_sitl_3_drones/$(date +%Y%m%d_%H%M%S)"
mkdir -p "${LOG_ROOT}"

echo "[info] FCT_ROOT=${FCT_ROOT}"
echo "[info] PX4_AUTOPILOT_DIR=${PX4_AUTOPILOT_DIR}"
echo "[info] LOG_ROOT=${LOG_ROOT}"

cleanup_runtime

# Forza layout splits nella tab corrente
kitten @ set-enabled-layouts splits
kitten @ goto-layout splits

# Scheduler: lancia drone 2 e drone 3 mentre il terminale corrente diventa drone 1
(
  sleep 8
  launch_split_drone 1 "0,1" 1 "vsplit"

  sleep 3
  launch_split_drone 2 "0,2" 1 "hsplit"
) &

echo
echo "=== SUMMARY ==="
echo "drone_1 -> instance_id=0 | mav_sys_id atteso=1 | pose=default | log=${LOG_ROOT}/drone_1.log"
echo "drone_2 -> instance_id=1 | mav_sys_id atteso=2 | pose=0,1     | log=${LOG_ROOT}/drone_2.log"
echo "drone_3 -> instance_id=2 | mav_sys_id atteso=3 | pose=0,2     | log=${LOG_ROOT}/drone_3.log"
echo
echo "Verifica porte:"
echo "  ss -lunp | egrep ':(14580|14581|14582|18570|18571|18572)\b' || true"
echo
echo "Stop completo:"
echo "  ./launch_px4_sitl_3_drones.sh --stop"
echo

# Il terminale corrente diventa drone 1
DRONE1_LOG="${LOG_ROOT}/drone_1.log"
DRONE1_CMD="$(build_px4_command 0 "" 0 "${DRONE1_LOG}")"
bash -lc "${DRONE1_CMD}"