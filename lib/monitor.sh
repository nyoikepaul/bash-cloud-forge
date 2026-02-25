#!/bin/bash
send_tg_msg() {
    local message=$1
    if [ -z "${TELEGRAM_TOKEN:-}" ] || [ -z "${TELEGRAM_CHAT_ID:-}" ]; then
        log_warn "Telegram credentials missing. Skipping notification."
        return
    fi
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d text="🚀 [Forge Alert]: $message" > /dev/null
}

install_monitor() {
    local target_ip=$1
    log_info "📡 Deploying Monitoring Agent to $target_ip..."
    ssh "root@$target_ip" 'bash -s' << INNER_EOF
        cat << 'HEALTH' > /usr/local/bin/health-check.sh
#!/bin/bash
THRESHOLD=90
DISK_USAGE=\$(df / | grep / | awk '{ print \$5 }' | sed 's/%//')
CPU_LOAD=\$(top -bn1 | grep "Cpu(s)" | awk '{print \$2 + \$4}' | cut -d. -f1)

if [ "\$DISK_USAGE" -gt "\$THRESHOLD" ] || [ "\$CPU_LOAD" -gt "\$THRESHOLD" ]; then
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d text="⚠️ ALARM: Server $target_ip is struggling! CPU: \$CPU_LOAD% Disk: \$DISK_USAGE%"
fi
HEALTH
        chmod +x /usr/local/bin/health-check.sh
        (crontab -l 2>/dev/null; echo "0 * * * * /usr/local/bin/health-check.sh") | crontab -
INNER_EOF
    log_info "✅ Monitoring active. Notifications set for >90% usage."
}
