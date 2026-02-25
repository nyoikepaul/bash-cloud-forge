#!/usr/bin/env bash
# Validates required environment variables are set

require_envs() {
    local missing=0
    for var in "$@"; do
        if [[ -z "${!var:-}" ]]; then
            log_err "Required environment variable '$var' is not set."
            missing=1
        fi
    done
    [[ $missing -eq 1 ]] && fatal "Missing required configuration. Exiting."
}
