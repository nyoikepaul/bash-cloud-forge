#!/usr/bin/env bash
set -euo pipefail

setup_remote_dir() {
    local target_dir="$1"
    log_info "Preparing remote directory ${target_dir} on ${SERVER_IP}..."
    ssh paul@${SERVER_IP} "sudo mkdir -p ${target_dir} && sudo chown ${USER}:${USER} ${target_dir}" || true
}

sync_to_remote() {
    local target_dir="$1"
    log_info "Syncing files to ${SERVER_IP}:${target_dir}..."
    # rsync is the industry standard for moving code to servers
    rsync -avz -e ssh --exclude '.git' --exclude 'venv' ./ paul@${SERVER_IP}:${target_dir}
}

remote_service_reload() {
    local service_name="$1"
    log_info "Reloading ${service_name} on remote..."
    ssh paul@${SERVER_IP} "systemctl daemon-reload && systemctl restart ${service_name} || true"
}
