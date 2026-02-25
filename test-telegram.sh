#!/usr/bin/env bash
set -euo pipefail

# Load core libraries
source "$(dirname "$0")/lib/logger.sh"
source "$(dirname "$0")/lib/telegram.sh"

log_info "Initiating Telegram Watchdog Connectivity Test..."

# Check if .env exists and load it
if [[ -f .env ]]; then
  export "$(grep -v '^#' .env | xargs)"
else
  fatal ".env file not found. Please create one with TELEGRAM_TOKEN and TELEGRAM_CHAT_ID."
fi

MESSAGE="🚀 <b>Bash-Cloud-Forge Alert</b>%0AStatus: <code>Online</code>%0AHost: <code>$(hostname)</code>%0AMessage: Connectivity test successful."

send_telegram_msg "$MESSAGE"
