#!/usr/bin/env bash

# ANSI Color Codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[$(date +'%Y-%m-%dT%H:%M:%S%z')] [INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[$(date +'%Y-%m-%dT%H:%M:%S%z')] [WARN]${NC} $*" >&2; }
log_err() { echo -e "${RED}[$(date +'%Y-%m-%dT%H:%M:%S%z')] [ERROR]${NC} $*" >&2; }
fatal() {
  log_err "$*"
  exit 1
}
