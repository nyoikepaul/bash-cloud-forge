#!/bin/bash
# --- Expert Mode: Strict Execution & Error Trapping ---
set -euo pipefail
IFS=$'
	'

trap 'echo "[❌ ERROR] Command failed at line $LINENO" >&2' ERR

source .env
source lib/monitor.sh
source scripts/utils/common.sh

log_info "🧪 Testing Telegram Notification..."
send_tg_msg "✅ Forge Watchdog is active! Test alert from $HOSTNAME."

if [ $? -eq 0 ]; then
    log_info "Message sent! Check your Telegram phone app."
else
    log_error "Failed to send. Check your TOKEN and CHAT_ID in .env"
fi
