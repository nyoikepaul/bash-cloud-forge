#!/usr/bin/env bash
# lib/config.sh — Secure config loader v3.0

load_config() {
    local env_file="${1:-${CONFIG_FILE:-.env}}"
    local profile="${2:-${PROFILE:-default}}"

    [[ -f "$env_file" ]] || {
        log_err "Config not found: $env_file"
        log_info "→ cp .env.example $env_file && chmod 600 $env_file"
        return 1
    }

    # Security check
    if [[ "$(stat -c %a "$env_file" 2>/dev/null || stat -f %Lp "$env_file" 2>/dev/null)" != "600" ]]; then
        log_warn "⚠️  $env_file should be chmod 600 (secrets exposed!)"
    fi

    set -a
    # shellcheck disable=SC1090
    source "$env_file"
    set +a

    # Required vars validation
    : "${DO_TOKEN:?DO_TOKEN missing in config}"
    : "${TELEGRAM_TOKEN:?TELEGRAM_TOKEN missing}"
    : "${TELEGRAM_CHAT_ID:?TELEGRAM_CHAT_ID missing}"

    log_info "✅ Config loaded ($env_file) | Profile: $profile | Provider: ${PROVIDER:-do}"
}

# Optional: load profile-specific overrides
load_profile() {
    local profile_file=".env.${PROFILE:-default}"
    [[ -f "$profile_file" ]] && source "$profile_file"
}
