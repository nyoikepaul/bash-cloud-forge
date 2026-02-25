#!/usr/bin/env bash
set -euo pipefail

check_resources() {
    log_info "Scanning system vitals..."
    local cpu_load
    cpu_load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    cpu_load_int=${cpu_load%.*}

    if [[ "$cpu_load_int" -gt 90 ]]; then
        log_warn "High CPU Load detected: ${cpu_load}%"
        send_telegram_msg "⚠️ <b>High CPU Alert</b>%0AHost: <code>$(hostname)</code>%0ALoad: <code>${cpu_load}%</code>"
    else
        log_info "CPU Load is healthy: ${cpu_load}%"
    fi

    local disk_usage
    disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    if [[ "$disk_usage" -gt 90 ]]; then
        log_warn "Low Disk Space detected: ${disk_usage}%"
        send_telegram_msg "🚨 <b>Low Disk Space Alert</b>%0AHost: <code>$(hostname)</code>%0AUsage: <code>${disk_usage}%</code>"
    else
        log_info "Disk usage is healthy: ${disk_usage}%"
    fi
}

check_uptime() {
    local url="${1:-http://localhost}"
    log_info "Performing health check on: ${url}..."

    # We use '|| true' to prevent set -e from killing the script on connection failure
    local status_code
    status_code=$(curl -s -o /dev/null -L -w "%{http_code}" --connect-timeout 5 "${url}" || echo "000")

    if [[ "$status_code" -eq 200 ]]; then
        log_info "✅ Service is UP (HTTP ${status_code})"
    else
        log_err "🚨 Service is DOWN or unstable (HTTP ${status_code})"
        send_telegram_msg "🔴 <b>Uptime Alert</b>%0AURL: <code>${url}</code>%0AStatus: <code>HTTP ${status_code}</code>%0AAction: <code>Immediate Check Required</code>"
    fi
}
