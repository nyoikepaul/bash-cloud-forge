#!/bin/bash
harden_server() {
    local target_ip=$1
    log_info "🛡️ Hardening $target_ip: SSH lockdown, Firewall, and Fail2Ban..."
    ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no "root@$target_ip" 'bash -s' << 'INNER_EOF'
        export DEBIAN_FRONTEND=noninteractive
        apt-get update && apt-get upgrade -y
        ufw allow OpenSSH && ufw allow 80 && ufw allow 443
        echo "y" | ufw enable
        sed -i "s/^#\?PasswordAuthentication .*/PasswordAuthentication no/g" /etc/ssh/sshd_config
        systemctl restart ssh
        apt-get install -y fail2ban
        systemctl enable fail2ban && systemctl start fail2ban
INNER_EOF
    log_info "✅ $target_ip is now hardened."
}
