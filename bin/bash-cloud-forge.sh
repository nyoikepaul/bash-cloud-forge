#!/bin/bash
# --- Expert Mode: Strict Execution & Error Trapping ---
set -euo pipefail
IFS=$'
	'

trap 'echo "[❌ ERROR] Command failed at line $LINENO" >&2' ERR

# Main Entry Point for bash-cloud-forge

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source the utilities and modules
source "$REPO_ROOT/scripts/utils/common.sh"
source "$REPO_ROOT/lib/monitor.sh"
source "$REPO_ROOT/lib/security.sh"

# Load environment variables
if [ -f "$REPO_ROOT/.env" ]; then
  export $(grep -v '^#' "$REPO_ROOT/.env" | xargs)
else
  # We don't exit here so the user can still see the help menu
  log_warn ".env file not found. API commands may fail."
fi

print_banner
check_dependencies

usage() {
  echo "Usage: forge <command> [arguments]"
  echo ""
  echo "Commands:"
  echo "  harden <ip>    Secure a remote server (SSH, UFW, Fail2Ban)"
  echo "  monitor <ip>   Install the Telegram monitoring watchdog"
  echo "  help           Show this message"
  echo ""
}

case "${1:-}" in
  harden)
    if [ -z "${2:-}" ]; then
      log_error "Missing IP. Usage: forge harden <ip>"
      exit 1
    fi
    harden_server "$2"
    ;;
  monitor)
    if [ -z "${2:-}" ]; then
      log_error "Missing IP. Usage: forge monitor <ip>"
      exit 1
    fi
    install_monitor "$2"
    ;;
  help | *)
    usage
    ;;
esac
