#!/usr/bin/env bash
# --- Expert Mode: Unified CLI Orchestrator ---
set -euo pipefail
source "$(dirname "$0")/lib/logger.sh"

usage() {
  cat <<USAGE
Usage: $(basename "$0") <command> [options]

Commands:
    provision   Provision a new cloud server
    deploy      Deploy application to target
    harden      Apply enterprise security hardening
    monitor     Scan system vitals & send alerts
    backup      Create timestamped archive
    test        Run Telegram watchdog tests

Options:
    -h, --help  Show this help message
USAGE
  exit 0
}

[[ $# -eq 0 ]] && usage

COMMAND=$1
shift

case "$COMMAND" in
  -h | --help) usage ;;

  provision)
    log_info "Starting provisioning phase..."
    bash ./provision.sh "$@"
    ;;

  deploy)
    log_info "Starting deployment phase..."
    source "$(dirname "$0")/lib/deploy.sh"
    bash ./scripts/deploy/deploy-flask-api.sh "$@"
    ;;

  harden)
    source "$(dirname "$0")/lib/security.sh"
    apply_hardening
    ;;

  monitor)
    source "$(dirname "$0")/lib/monitor.sh"
    source "$(dirname "$0")/lib/telegram.sh"
    check_resources
    ;;

  backup)
    source "$(dirname "$0")/lib/backup.sh"
    perform_backup "$@"
    ;;

  test)
    log_info "Running system checks..."
    bash ./test-telegram.sh "$@"
    ;;

  *)
    log_err "Unknown command: $COMMAND"
    usage
    ;;
esac
