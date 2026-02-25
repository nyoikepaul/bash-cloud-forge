#!/bin/bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: ./deploy.sh <droplet-name>"
  exit 1
fi

DROPLET=$1
IP=$(doctl compute droplet get "$DROPLET" -o json | jq -r '.[0].networks.v4[0].ip_address' 2>/dev/null || echo "IP not found")

echo "🚀 Deploying to $DROPLET ($IP)..."

# Create app directory on server if missing
ssh -o StrictHostKeyChecking=no deploy@"$IP" '
  sudo mkdir -p /var/www/myapp
  sudo chown deploy:deploy /var/www/myapp
'

# Sync the app
rsync -avz --delete app/ deploy@"$IP":/var/www/myapp/

ssh -o StrictHostKeyChecking=no deploy@"$IP" '
  cd /var/www/myapp
  python3 -m venv venv
  venv/bin/pip install -r requirements.txt
  venv/bin/pip install gunicorn

  # Systemd service
  sudo tee /etc/systemd/system/gunicorn.service > /dev/null <<EOG
[Unit]
Description=Gunicorn instance for myapp
After=network.target

[Service]
User=deploy
Group=www-data
WorkingDirectory=/var/www/myapp
Environment="PATH=/var/www/myapp/venv/bin"
ExecStart=/var/www/myapp/venv/bin/gunicorn --workers 3 --bind unix:/var/www/myapp/myapp.sock app:app

[Install]
WantedBy=multi-user.target
EOG

  sudo systemctl daemon-reload
  sudo systemctl restart gunicorn
  sudo systemctl enable gunicorn

  # Nginx
  sudo tee /etc/nginx/sites-available/myapp > /dev/null <<EON
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://unix:/var/www/myapp/myapp.sock;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /static/ {
        alias /var/www/myapp/static/;
    }
}
EON

  sudo ln -sf /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/
  sudo rm -f /etc/nginx/sites-enabled/default
  sudo nginx -t && sudo systemctl restart nginx
'

echo "✅ Deployment complete!"
echo "🌐 Your app is live at http://$IP"
