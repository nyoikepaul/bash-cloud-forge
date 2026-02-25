#!/bin/bash

# Professional Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging Functions
log_info()    { echo -e "${GREEN}[INFO]${NC}  $(date +'%Y-%m-%d %H:%M:%S') - $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $(date +'%Y-%m-%d %H:%M:%S') - $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $(date +'%Y-%m-%d %H:%M:%S') - $1"; return 1; }
log_debug()   { echo -e "${BLUE}[DEBUG]${NC} $(date +'%Y-%m-%d %H:%M:%S') - $1"; }

# Dependency Checker
check_dependencies() {
    local deps=("curl" "jq" "ssh" "openssl")
    for tool in "${deps[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_error "Required tool '$tool' is not installed."
            exit 1
        fi
    done
}

# Header UI
print_banner() {
    echo -e "${BLUE}"
    echo "  ____  _                 _   _____                     "
    echo " | __ )| |__   ___  _   _| |_|  ___|__  _ __ __ _  ___  "
    echo " |  _ \| '_ \ / _ \| | | | __| |_ / _ \| '__/ _\` |/ _ \ "
    echo " | |_) | | | | (_) | |_| | |_|  _| (_) | | | (_| |  __/ "
    echo " |____/|_| |_|\___/ \__,_|\__|_|  \___/|_|  \__, |\___| "
    echo "                                            |___/       "
    echo -e "${NC}"
    echo -e "   --- Pure Bash Cloud Provisioning & Hardening ---"
    echo ""
}
