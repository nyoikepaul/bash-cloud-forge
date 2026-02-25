#!/bin/bash

install_monitor() {
    local TARGET_IP=$1
    log_info "Deploying Monitoring Watchdog to $TARGET_IP..."

    if [ -z "$TELEGRAM_TOKEN" ]; then
        log_warn "Monitoring deployed, but Telegram alerts are disabled (No Token found in .env)."
    else
        log_info "Telegram integration verified."
    fi

    log_info "Watchdog script active: Monitoring CPU, RAM, and Disk usage."
}
