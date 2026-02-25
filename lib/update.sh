#!/usr/bin/env bash
set -euo pipefail

update_toolkit() {
    log_info "Checking for updates on GitHub..."
    if git pull origin main; then
        log_info "Updating file permissions..."
        find . -type f -name "*.sh" -exec chmod +x {} +
        log_info "✅ Toolkit successfully updated to the latest version."
    else
        log_err "❌ Update failed. Check your internet connection or git status."
    fi
}
