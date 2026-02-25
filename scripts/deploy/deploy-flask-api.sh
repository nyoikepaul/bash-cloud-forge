#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../../lib/logger.sh"
source "$(dirname "$0")/../../lib/deploy.sh"

DEPLOY_PATH="/var/www/flask-api"
SERVICE_NAME="flask-api.service"

log_info "🚀 Starting Flask API Deployment..."

# 1. Prepare environment
setup_app_dir "${DEPLOY_PATH}"

# 2. Setup Virtual Environment (Expert move: Isolated dependencies)
if [[ ! -d "${DEPLOY_PATH}/venv" ]]; then
  log_info "Creating Python Virtual Environment..."
  python3 -m venv "${DEPLOY_PATH}/venv"
fi

# 3. Install/Update Dependencies
log_info "Installing dependencies from requirements.txt..."
"${DEPLOY_PATH}/venv/bin/pip" install -r "${DEPLOY_PATH}/requirements.txt"

# 4. Trigger systemd reload
reload_service "${SERVICE_NAME}"

log_info "✨ Deployment successful!"
