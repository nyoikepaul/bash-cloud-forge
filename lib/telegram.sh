#!/usr/bin/env bash
# --- Expert Mode: Telegram Alert Module ---
set -euo pipefail

# Ensure environment validator is available
source "$(dirname "$0")/lib/env_check.sh"

send_telegram_msg() {
  local message="$1"

  # Pre-flight check for credentials
  require_envs "TELEGRAM_TOKEN" "TELEGRAM_CHAT_ID"

  log_info "Dispatching Telegram alert..."

  local url="https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage"

  # Send the request
  local status_code
  status_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$url" \
    -d chat_id="${TELEGRAM_CHAT_ID}" \
    -d text="${message}" \
    -d parse_mode="HTML")

  if [[ "$status_code" -eq 200 ]]; then
    log_info "✅ Telegram alert sent successfully."
  else
    log_err "❌ Failed to send Telegram alert (HTTP $status_code)."
  fi
}
