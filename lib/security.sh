#!/usr/bin/env bash
set -euo pipefail

apply_hardening() {
    if [[ -z "${SERVER_IP:-}" ]]; then
        fatal "SERVER_IP is not set."
    fi

    log_info "Connecting to ${SERVER_IP} to apply hardening..."

    # Added 'sudo' before system-level commands
    ssh -o ConnectTimeout=10 ${USER}@${SERVER_IP} bash << REMOTESSH
        set -euo pipefail
        echo "[REMOTE] Updating packages..."
        sudo apt-get update
        
        echo "[REMOTE] Installing dependencies..."
        sudo apt-get install -y ufw python3-venv python3-pip rsync
        
        echo "[REMOTE] Configuring Firewall (Note: May fail on WSL)..."
        sudo ufw allow ssh
        sudo ufw allow http
        echo "y" | sudo ufw enable || true
        
        echo "[REMOTE] SSH config check..."
        sudo sshd -t && echo "SSH Config is valid"
REMOTESSH

    log_info "✅ Remote hardening attempt complete."
}
