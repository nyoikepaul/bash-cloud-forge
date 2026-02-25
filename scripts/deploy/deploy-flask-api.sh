#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../lib/logger.sh"
source "$(dirname "$0")/../../lib/deploy.sh"

# Load environment to get SERVER_IP
source .env || true

DEPLOY_PATH="/var/www/flask-api"

log_info "🚀 Starting Remote Flask Deployment to ${SERVER_IP}..."

# 1. Setup Remote Folders
setup_remote_dir "${DEPLOY_PATH}"

# 2. Push Code
sync_to_remote "${DEPLOY_PATH}"

# 3. Remote Python Setup
log_info "Running remote environment setup..."
ssh paul@${SERVER_IP} << REMOTESSH
    cd ${DEPLOY_PATH}
    python3 -m venv venv
    ./venv/bin/pip install -r requirements.txt || echo "No requirements.txt found, skipping pip"
REMOTESSH

log_info "✨ Remote Deployment Complete!"
