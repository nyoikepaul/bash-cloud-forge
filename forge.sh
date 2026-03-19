#!/usr/bin/env bash
# forge.sh — Production CLI v3.0 (getopt + subcommands + dry-run)

set -euo pipefail

# === CONFIG & LOGGER FIRST ===
source "$(dirname "$0")/lib/config.sh"
source "$(dirname "$0")/lib/logger.sh"

# Default flags
DRY_RUN=false
VERBOSE=false
PROVIDER="do"
PROFILE="default"

usage() {
    cat <<EOF
Usage: $(basename "$0") <command> [options]

Commands:
  provision   Provision new server
  deploy      Deploy app
  harden      Apply CIS hardening
  monitor     Health check + Telegram alert
  backup      Create backup
  status      Show dashboard
  test        Run tests

Global options:
  -p, --provider  do|aws|hetzner     (default: do)
  -P, --profile   default|prod|dev   (default: default)
  -d, --dry-run                      Show what would happen
  -v, --verbose                      Verbose output
  -h, --help                         Show this help
  --log-json                         Enable JSON logging
