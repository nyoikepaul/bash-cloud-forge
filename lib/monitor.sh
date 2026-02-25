#!/usr/bin/env bash
# --- Expert Mode: Resource Monitoring Module ---
set -euo pipefail

check_resources() {
  log_info "Scanning system vitals..."

  # 1. Check CPU Usage
  local cpu_load
  cpu_load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
  cpu_load_int=${cpu_load%.*}

  if [[ "$cpu_load_int" -gt 90 ]]; then
    log_warn "High CPU Load detected: ${cpu_load}%"
    send_telegram_msg "⚠️ <b>High CPU Alert</b>%0AHost: <code>$(hostname)</code>%0ALoad: <code>${cpu_load}%</code>"
  else
    log_info "CPU Load is healthy: ${cpu_load}%"
  fi

  # 2. Check Disk Usage (Root Partition)
  local disk_usage
  disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

  if [[ "$disk_usage" -gt 90 ]]; then
    log_warn "Low Disk Space detected: ${disk_usage}%"
    send_telegram_msg "🚨 <b>Low Disk Space Alert</b>%0AHost: <code>$(hostname)</code>%0AUsage: <code>${disk_usage}%</code>"
  else
    log_info "Disk usage is healthy: ${disk_usage}%"
  fi
}
