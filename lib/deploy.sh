#!/usr/bin/env bash
# --- Expert Mode: Deployment Engine ---
set -euo pipefail

setup_app_dir() {
  local target_dir="$1"
  log_info "Preparing application directory at ${target_dir}..."
  mkdir -p "${target_dir}"
  chown "${USER}:${USER}" "${target_dir}"
}

sync_codebase() {
  local source_dir="$1"
  local remote_host="$2"
  local remote_path="$3"

  log_info "Synchronizing codebase to ${remote_host}..."
  rsync -avz --exclude '.git' --exclude '.env' "${source_dir}/" "${remote_host}:${remote_path}"
}

reload_service() {
  local service_name="$1"
  log_info "Reloading systemd service: ${service_name}..."
  sudo systemctl daemon-reload
  sudo systemctl restart "${service_name}"
  sudo systemctl enable "${service_name}"
}
