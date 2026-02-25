from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "<h1>Hello from bash-cloud-forge on Ubuntu 24.04! 🎉</h1><p>Deployed with zero-downtime via Nginx + Gunicorn</p>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
