#!/usr/bin/env bash
# lib/logger.sh — Production logger (JSON + file + syslog) v3.0

LOG_LEVEL="${LOG_LEVEL:-INFO}"
LOG_FILE="${LOG_FILE:-/var/log/bash-cloud-forge.log}"
LOG_JSON="${LOG_JSON:-false}"
USE_SYSLOG="${USE_SYSLOG:-false}"

# ANSI colors (fixed)
readonly RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' BLUE='\033[0;34m' NC='\033[0m'

priority() {
    case "$1" in
        DEBUG) echo 0 ;;
        INFO)  echo 1 ;;
        WARN)  echo 2 ;;
        ERROR) echo 3 ;;
        FATAL) echo 4 ;;
        *)     echo 1 ;;
    esac
}

log() {
    local level="$1" color="$2" msg="${*:3}"
    [[ $(priority "$level") -lt $(priority "$LOG_LEVEL") ]] && return 0

    local ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local line="[$ts] [$level] $msg"

    # Console
    echo -e "${color}$line${NC}"

    # File
    echo "$line" >> "$LOG_FILE"

    # JSON
    if [[ "$LOG_JSON" == true ]]; then
        printf '{"time":"%s","level":"%s","msg":"%s"}\n' \
            "$ts" "$level" "${msg//\"/\\\"}" >> "${LOG_FILE%.log}.json"
    fi

    # Syslog
    if [[ "$USE_SYSLOG" == true ]]; then
        logger -t bash-cloud-forge -p user."${level,,}" "$msg"
    fi
}

log_debug() { log DEBUG "$BLUE"    "$@"; }
log_info()  { log INFO  "$GREEN"   "$@"; }
log_warn()  { log WARN  "$YELLOW"  "$@"; }
log_err()   { log ERROR "$RED"     "$@"; }
log_fatal() { log FATAL "$RED"     "$@"; fatal "$@"; }

fatal() {
    log_fatal "$@"
    exit 1
}

# Auto-trap
trap 'log_err "Script failed at line $LINENO (exit code $?)"' ERR
