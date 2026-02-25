#!/usr/bin/env bash
set -euo pipefail

show_dashboard() {
    clear
    echo -e "${GREEN}==========================================${NC}"
    echo -e "${GREEN}      BASH-CLOUD-FORGE SYSTEM STATUS      ${NC}"
    echo -e "${GREEN}==========================================${NC}"
    echo -e "Timestamp: $(date)"
    echo -e "Hostname:  $(hostname)"
    echo -e "Uptime:    $(uptime -p)"
    echo -e "------------------------------------------"
    
    # Run the checks without triggering Telegram for the dashboard view
    local cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    local mem=$(free -m | awk '/Mem:/ { printf("%3.1f%%", $3/$2*100) }')
    local disk=$(df -h / | awk 'NR==2 {print $5}')
    
    echo -e "CPU Load:  [${cpu}%]"
    echo -e "Memory:    [${mem}]"
    echo -e "Disk Use:  [${disk}]"
    echo -e "------------------------------------------"
    log_info "Dashboard refresh complete."
}
