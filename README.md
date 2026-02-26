# 🔥 Bash Cloud Forge Pro – Now Available!

**Brand new (launched Feb 26 2026)** – Pure Bash toolkit for Kenyan freelancers & agencies.

**Free version** = personal use only  
**Pro subscription (KSh 1,099/mo)** = Commercial license + extra templates + priority support + monthly updates

[Get Pro Now →](https://your-carrd-link.carrd.co)

Perfect for DigitalOcean + AWS + Telegram alerts. Provision + harden + deploy + backup in minutes.# 🛠️ Bash-Cloud-Forge 2.0
**Enterprise-Grade Cloud Provisioning & Monitoring Framework**

[![Bash Expert CI](https://github.com/nyoikepaul/bash-cloud-forge/actions/workflows/bash-ci.yml/badge.svg)](https://github.com/nyoikepaul/bash-cloud-forge/actions)
![License](https://img.shields.io/github/license/nyoikepaul/bash-cloud-forge)
![Bash Version](https://img.shields.io/badge/bash-4.4+-blue.svg)

Bash-Cloud-Forge is a high-performance, modular toolkit designed for DevOps engineers who demand speed without sacrificing security. Built on **Strict Bash Principles**, it provides a dependency-free way to manage cloud infrastructure.

---

## 🏗️ Architecture Overview

The framework follows a modular "Core & Library" pattern:
* **`forge.sh`**: The unified CLI entry point.
* **`lib/`**: Reusable modules for logging, environment validation, and core logic.
* **`scripts/`**: Atomic task scripts called by the orchestrator.
* **`.github/workflows/`**: Continuous Integration via ShellCheck and shfmt.

---

## 🛡️ Enterprise Safety Features

This toolkit implements **Strict Mode** execution:
* **Fail-Fast (`set -e`)**: Scripts terminate immediately on any command failure.
* **Undefined Variable Protection (`set -u`)**: Prevents execution if a variable is missing.
* **Pipeline Integrity (`set -o pipefail`)**: Ensures errors in piped commands are caught.
* **Structured Logging**: Timestamped, color-coded output for observability.

---

## 🚀 Getting Started

### 1. Prerequisites
Ensure your `.env` file is configured based on `.env.example`.

### 2. Usage
```bash
# Provision a new instance
./forge.sh provision my-web-server

# Deploy an application
./forge.sh deploy production

# Run the Telegram Watchdog test
# Backup application data
./forge.sh backup /var/www/flask-api
* **Automated Backups:** Timestamped archives with configurable retention.
./forge.sh test
* **Automated Backups:** Timestamped archives with configurable retention.
\```

---

## 🛠️ Development & CI/CD

To maintain code quality, this repo uses:
1.  **ShellCheck**: Static analysis to find bugs and bad practices.
2.  **shfmt**: Enforces a consistent Google-style shell format.

Run local linting:
\```bash
find . -type f -name "*.sh" -exec shellcheck {} +
\```

