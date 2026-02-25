#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib/logger.sh"

usage() {
    cat <<USAGE
Usage: $(basename "$0") <command> [options]

Commands:
    provision   Provision a new cloud server
    deploy      Deploy application to target
    harden      Apply enterprise security hardening
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
    provision)
        log_info "Starting provisioning phase..."
        bash ./provision.sh "$@"
        ;;
    deploy)
        log_info "Starting deployment phase..."
        bash ./deploy.sh "$@"
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
