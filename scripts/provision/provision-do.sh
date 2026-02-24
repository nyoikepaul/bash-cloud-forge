#!/usr/bin/env bash
# ===============================================
# provision-do.sh — Create DigitalOcean Droplet + Cloud-Init
# ===============================================

set -euo pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
source "$PROJECT_ROOT/scripts/utils/common.sh" 2>/dev/null || {
    echo -e "\033[31m[ERROR]\033[0m common.sh not found. Run from project root."
    exit 1
}

print_header "🚀 DigitalOcean Droplet Provisioning"

# --------------------- Defaults ---------------------
NAME="my-cloud-server"
REGION="lon1"
SIZE="s-1vcpu-1gb"
IMAGE="ubuntu-24-04-x64"
SSH_KEY_ID=""          # optional: your SSH key fingerprint
USER_DATA_FILE="$PROJECT_ROOT/examples/cloud-init-user-data.yml"

# --------------------- Parse arguments ---------------------
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)    NAME="$2"; shift 2 ;;
        --region)  REGION="$2"; shift 2 ;;
        --size)    SIZE="$2"; shift 2 ;;
        --image)   IMAGE="$2"; shift 2 ;;
        --ssh-key) SSH_KEY_ID="$2"; shift 2 ;;
        --help|-h)
            echo -e "${BLUE}Usage:${NC} ./bin/bash-cloud-forge.sh provision-do --name <name> [--region lon1] [--size s-1vcpu-1gb]"
            exit 0
            ;;
        *) log_error "Unknown option: $1"; exit 1 ;;
    esac
done

# --------------------- Checks ---------------------
check_dependencies doctl jq

if [[ -z "${DO_API_TOKEN:-}" ]]; then
    log_error "DO_API_TOKEN environment variable is required"
    log_info "Export it first: export DO_API_TOKEN=dop_v1_xxxxxxxxxxxxxxxx"
    exit 1
fi

if [[ ! -f "$USER_DATA_FILE" ]]; then
    log_warning "Cloud-Init file not found, using minimal one..."
    cat > "$USER_DATA_FILE" << 'MINIMAL'
#cloud-config
package_update: true
package_upgrade: true
packages:
  - curl
  - git
runcmd:
  - echo "✅ Server provisioned with bash-cloud-forge" > /etc/motd
MINIMAL
fi

# --------------------- Create Droplet ---------------------
log_info "Creating droplet: $NAME ($SIZE) in $REGION ..."

DROPLET_JSON=$(doctl compute droplet create "$NAME" \
    --region "$REGION" \
    --size "$SIZE" \
    --image "$IMAGE" \
    --user-data-file "$USER_DATA_FILE" \
    ${SSH_KEY_ID:+--ssh-keys "$SSH_KEY_ID"} \
    --wait \
    --format ID,Name,PublicIPv4,Status --no-header | head -1)

DROPLET_ID=$(echo "$DROPLET_JSON" | awk '{print $1}')
IP=$(echo "$DROPLET_JSON" | awk '{print $3}')

log_success "Droplet created!"
log_info "ID: $DROPLET_ID"
log_info "IP : $IP"
log_info "SSH: ssh root@$IP"

# --------------------- Telegram Alert ---------------------
send_telegram_alert "🚀 New Droplet created!\nName: $NAME\nIP: $IP\nRegion: $REGION"

log_success "Done! Your server is ready."
echo -e "${GREEN}Connect now:${NC} ssh root@$IP"
