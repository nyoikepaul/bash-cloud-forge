#!/usr/bin/env bash
# ===============================================
# bash-cloud-forge — Main CLI (bulletproof version)
# ===============================================

VERSION="0.1.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_usage() {
    echo -e "${CYAN}🛠️  bash-cloud-forge v${VERSION}${NC}"
    echo -e "Lightning-fast Bash toolkit for cloud provisioning & deployments\n"
    echo -e "${BLUE}USAGE:${NC}"
    echo -e "    ./bin/bash-cloud-forge.sh <command> [options]\n"
    echo -e "${BLUE}COMMANDS:${NC}"
    echo -e "    provision-do     Create DigitalOcean droplet + full setup"
    echo -e "    deploy-flask     One-command Flask/FastAPI deployment"
    echo -e "    monitor          Health checks + Telegram alerts"
    echo -e "    help             Show this help\n"
    echo -e "${BLUE}EXAMPLES:${NC}"
    echo -e "    ./bin/bash-cloud-forge.sh provision-do --name myapi"
    echo -e "    ./bin/bash-cloud-forge.sh --help\n"
    echo -e "${GREEN}Made with ❤️ in Kenya 🇰🇪   @nyoikepaul${NC}"
}

COMMAND="${1:-help}"

case "$COMMAND" in
    help|--help|-h)
        print_usage
        ;;
    provision-do|deploy-flask|monitor)
        echo -e "${BLUE}[INFO]${NC} $COMMAND module ready — we'll build it next!"
        ;;
    *)
        echo -e "${RED}[ERROR]${NC} Unknown command: $COMMAND"
        print_usage
        exit 1
        ;;
esac
