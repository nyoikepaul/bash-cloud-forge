#!/bin/bash
# --- Expert Mode: Strict Execution & Error Trapping ---
set -euo pipefail
IFS=$'
	'

trap 'echo "[❌ ERROR] Command failed at line $LINENO" >&2' ERR


provision_droplet() {
    local NAME=$1
    if [[ -z "$DO_TOKEN" || "$DO_TOKEN" == "your_token_here" ]]; then
        log_error "DigitalOcean Token missing! Set DO_TOKEN in .env"
        exit 1
    fi

    log_info "Requesting new Droplet: $NAME..."
    
    # This is the actual API call logic
    # We use jq to extract the 'id' of the creation request
    RESPONSE=$(curl -s -X POST -H "Authorization: Bearer $DO_TOKEN" \
        -H "Content-Type: application/json" \
        -d "{\"name\":\"$NAME\",\"region\":\"nyc3\",\"size\":\"s-1vcpu-1gb\",\"image\":\"ubuntu-24-04-x64\"}" \
        "https://api.digitalocean.com/v2/droplets")

    DROPLET_ID=$(echo $RESPONSE | jq -r '.droplet.id // empty')

    if [ -z "$DROPLET_ID" ]; then
        log_error "Provisioning failed. API Response: $RESPONSE"
        exit 1
    fi

    log_info "Droplet $NAME created successfully (ID: $DROPLET_ID)"
    log_info "Waiting for IP address assignment..."
    # In a real script, we would loop here until the IP is ready
}
