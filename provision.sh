#!/bin/bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: ./provision.sh <droplet-name>"
  exit 1
fi

DROPLET=$1
REGION=nyc3
SIZE=s-2vcpu-4gb
IMAGE=ubuntu-24-04-x64

echo "🚀 Provisioning droplet $DROPLET on Ubuntu 24.04..."

doctl compute droplet create "$DROPLET" \
  --region "$REGION" \
  --size "$SIZE" \
  --image "$IMAGE" \
  --wait

IP=$(doctl compute droplet get "$DROPLET" -o json | jq -r '.[0].networks.v4[0].ip_address')
echo "✅ Droplet created! IP: $IP"

# Wait for SSH to be ready
echo "Waiting for SSH..."
sleep 20

ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 root@"$IP" '
  apt-get update -qq && apt-get upgrade -y -qq
  apt-get install -y -qq curl git ufw fail2ban nginx python3 python3-pip python3-venv python3-dev build-essential

  # Create deploy user
  useradd -m -s /bin/bash deploy || true
  mkdir -p /home/deploy/.ssh
  cp /root/.ssh/authorized_keys /home/deploy/.ssh/
  chown -R deploy:deploy /home/deploy/.ssh
  chmod 700 /home/deploy/.ssh
  chmod 600 /home/deploy/.ssh/authorized_keys
  usermod -aG sudo deploy
  echo "deploy ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deploy

  # Firewall
  ufw allow OpenSSH
  ufw allow "Nginx Full"
  ufw --force enable

  echo "✅ Provisioning complete! You can now deploy."
'
echo "🎉 Server ready at http://$IP"
echo "Run: ./deploy.sh $DROPLET"
