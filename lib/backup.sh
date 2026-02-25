#!/usr/bin/env bash
# --- Expert Mode: Backup & Rotation Module ---
set -euo pipefail

perform_backup() {
  local source_path="${1:-/var/www/flask-api}"
  local backup_dir="/var/backups/forge"
  local timestamp
  timestamp=$(date +%Y%m%d_%H%M%S)
  local archive_name="backup_${timestamp}.tar.gz"
  local retention_days=7

  log_info "Initiating backup for: ${source_path}..."
  mkdir -p "${backup_dir}"

  # 1. Create compressed archive
  if tar -czf "${backup_dir}/${archive_name}" -C "$(dirname "${source_path}")" "$(basename "${source_path}")"; then
    log_info "✅ Backup created: ${backup_dir}/${archive_name}"
  else
    fatal "❌ Backup failed!"
  fi

  # 2. Expert Rotation: Remove archives older than retention period
  log_info "Cleaning up backups older than ${retention_days} days..."
  find "${backup_dir}" -name "backup_*.tar.gz" -type f -mtime +"${retention_days}" -delete
  log_info "Cleanup complete."
}
