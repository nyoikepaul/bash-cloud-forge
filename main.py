from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.responses import HTMLResponse
import os
import httpx
import asyncio

app = FastAPI(title="Bash Cloud Forge", version="1.3.0")

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
HTML_FILE = os.path.join(BASE_DIR, "static", "index.html")

BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
CHAT_ID = os.getenv("TELEGRAM_CHAT_ID")

@app.get("/", response_class=HTMLResponse)
async def read_root():
    with open(HTML_FILE, "r") as f:
        return f.read()

# --- TERMINAL BUTTON LOGIC ---

@app.get("/api/v1/provision")
async def provision_server():
    await asyncio.sleep(1.5) # Simulate server spin-up
    return {"output": "✅ Droplet created on DigitalOcean (NBO-1)\n✅ Server hardened (fail2ban + UFW)\n✅ SSH keys injected\n⏱️ Total time: 47 seconds"}

@app.get("/api/v1/deploy")
async def deploy_app():
    await asyncio.sleep(2) # Simulate build process
    return {"output": "🚀 Git pull successful (main branch)\n✅ Nginx + Let's Encrypt SSL configured\n✅ Gunicorn worker processes restarted\n🌐 Live at production URL"}

@app.post("/api/v1/notify")
async def send_notification(background_tasks: BackgroundTasks):
    if not BOT_TOKEN or not CHAT_ID:
        return {"output": "⚠️ Telegram credentials missing in Vercel. Alert logged locally."}
    
    msg = "🔥 *Forge Alert*: A client just clicked 'Test Telegram' on bash-cloud-forge.vercel.app!"
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    background_tasks.add_task(httpx.post, url, json={"chat_id": CHAT_ID, "text": msg, "parse_mode": "Markdown"})
    return {"output": "✅ Secure payload sent to Nairobi_HQ via Telegram API\n📡 Bot Status: DISPATCHED"}

@app.get("/api/v1/backup")
async def backup_data():
    await asyncio.sleep(1) # Simulate compression
    return {"output": "📦 Database dumped successfully (PostgreSQL)\n✅ Backup compressed: forge-db-2026.tar.gz\n☁️ Uploaded to AWS S3 / DO Spaces\n🗄️ Retention policy: 30 days applied"}

@app.get("/api/v1/health")
async def health():
    return {"status": "forging", "database": "connected"}
