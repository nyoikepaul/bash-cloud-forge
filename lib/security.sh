#!/usr/bin/env bash
# --- Expert Mode: Security Hardening Module ---
set -euo pipefail

apply_hardening() {
    log_info "Initiating enterprise security hardening protocol..."
    
    # 1. System Refresh
    log_info "Synchronizing package repositories and upgrading core components..."
    apt-get update && apt-get upgrade -y

    # 2. Firewall Lockdown (UFW)
    log_info "Configuring Uncomplicated Firewall (UFW)..."
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow http
    ufw allow https
    log_warn "Enabling firewall. This will drop all non-essential incoming connections."
    echo "y" | ufw enable

    # 3. SSH Fortification
    log_info "Hardening SSH configuration (Disabling Root & Password Auth)..."
    # Ensure backup before editing
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    
    log_info "Restarting SSH service to apply changes..."
    systemctl restart ssh

    log_info "✅ Hardening complete. Server is now locked down."
}
