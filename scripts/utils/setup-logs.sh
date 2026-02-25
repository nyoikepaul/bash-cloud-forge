#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../lib/logger.sh"

log_info "Setting up log rotation..."

# Create the log directory if it doesn't exist
sudo mkdir -p /var/log/bash-cloud-forge
sudo chown -R $USER:$USER /var/log/bash-cloud-forge

# Deploy the logrotate config
sudo cp bash-cloud-forge.logrotate /etc/logrotate.d/bash-cloud-forge
sudo chmod 644 /etc/logrotate.d/bash-cloud-forge

log_info "✅ Log rotation installed to /etc/logrotate.d/bash-cloud-forge"
