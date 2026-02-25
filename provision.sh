#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/lib/logger.sh"
source scripts/utils/common.sh
source lib/security.sh
source lib/monitor.sh

# Load env
export "$(grep -v '^#' .env | xargs)"

SERVER_NAME=${1:-"forge-node"}

log_info "🚀 Starting Full Forge Cycle for $SERVER_NAME..."

# 1. Provision (Call your existing DO script)
# Assuming your script outputs the IP address
IP_ADDRESS=$(bash scripts/provision/provision-do.sh "$SERVER_NAME")

log_info "📍 Server IP: $IP_ADDRESS. Waiting 30s for SSH to warm up..."
sleep 30

# 2. Harden
harden_server "$IP_ADDRESS"

# 3. Monitor
install_monitor "$IP_ADDRESS"

log_info "🎉 FULL DEPLOYMENT COMPLETE!"
send_tg_msg "New node $SERVER_NAME ($IP_ADDRESS) is live and protected."
