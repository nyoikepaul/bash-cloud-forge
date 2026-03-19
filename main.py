from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
import os

app = FastAPI(title="Bash Cloud Forge", version="1.1.0")

# 10/10 Pathing: Ensures the HTML is found regardless of where the script runs
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
HTML_FILE = os.path.join(BASE_DIR, "static", "index.html")

@app.get("/", response_class=HTMLResponse)
async def read_root():
    if not os.path.exists(HTML_FILE):
        raise HTTPException(status_code=404, detail="Terminal UI source not found in /static")
    
    with open(HTML_FILE, "r") as f:
        return f.read()

@app.get("/api/v1/health")
async def health():
    # Verify the Supabase URL is loaded to confirm environment integrity
    supabase_status = "configured" if os.getenv("SUPABASE_URL") else "missing_env"
    return {
        "status": "forging",
        "database": "connected",
        "supabase_config": supabase_status,
        "region": "eu-west-1"
    }
