#!/bin/bash
# Scalr CLI helper script for common operations
# Usage: ./scalr-helper.sh <command> [options]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Scalr CLI is installed
if ! command -v scalr &> /dev/null; then
    echo -e "${RED}Scalr CLI not found. Please run: ./install-scalr-cli.sh${NC}"
    exit 1
fi

# Check if Scalr is configured
if [ -z "$SCALR_TOKEN" ] && [ ! -f ~/.scalr/scalr.conf ]; then
    echo -e "${YELLOW}Scalr not configured. Please run: scalr -configure${NC}"
    echo "Or set environment variables:"
    echo "  export SCALR_HOSTNAME='the-mothership.scalr.io'"
    echo "  export SCALR_TOKEN='your-api-token'"
    exit 1
fi

# Function to show usage
usage() {
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  list-workspaces              List all workspaces"
    echo "  workspace <name>             Show workspace details"
    echo "  plan <workspace>             Create a plan run"
    echo "  apply <workspace>            Create and auto-apply a run"
    echo "  runs <workspace>             List recent runs for a workspace"
    echo "  run-status <run-id>          Show run status"
    echo "  cancel <run-id>              Cancel a run"
    echo "  logs <run-id>                Show run logs"
    echo "  cost <workspace>             Show cost estimation for workspace"
    echo ""
    echo "Examples:"
    echo "  $0 list-workspaces"
    echo "  $0 workspace development-digitalocean"
    echo "  $0 plan development-digitalocean"
    echo "  $0 apply production-proxmox-vm"
    exit 1
}

# Parse command
COMMAND=$1
shift || true

case $COMMAND in
    list-workspaces)
        echo -e "${BLUE}Listing all workspaces...${NC}"
        scalr workspace list
        ;;
        
    workspace)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${BLUE}Showing workspace: $WORKSPACE${NC}"
        scalr workspace show -workspace="$WORKSPACE"
        ;;
        
    plan)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${BLUE}Creating plan run for workspace: $WORKSPACE${NC}"
        RUN_ID=$(scalr run create -workspace="$WORKSPACE" -auto-apply=false | grep -oE 'run-[a-zA-Z0-9]+' | head -1)
        echo -e "${GREEN}Created run: $RUN_ID${NC}"
        echo "View run: scalr run show -id=$RUN_ID"
        ;;
        
    apply)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${YELLOW}Creating auto-apply run for workspace: $WORKSPACE${NC}"
        echo -e "${YELLOW}This will apply changes automatically. Continue? (y/N)${NC}"
        read -r CONFIRM
        if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
            RUN_ID=$(scalr run create -workspace="$WORKSPACE" -auto-apply=true | grep -oE 'run-[a-zA-Z0-9]+' | head -1)
            echo -e "${GREEN}Created auto-apply run: $RUN_ID${NC}"
            echo "Monitor run: scalr run show -id=$RUN_ID"
        else
            echo "Cancelled"
        fi
        ;;
        
    runs)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${BLUE}Recent runs for workspace: $WORKSPACE${NC}"
        scalr run list -workspace="$WORKSPACE" -limit=10
        ;;
        
    run-status)
        RUN_ID=$1
        if [ -z "$RUN_ID" ]; then
            echo -e "${RED}Error: Run ID required${NC}"
            usage
        fi
        echo -e "${BLUE}Status for run: $RUN_ID${NC}"
        scalr run show -id="$RUN_ID" | grep -E "Status:|Created:|Message:"
        ;;
        
    cancel)
        RUN_ID=$1
        if [ -z "$RUN_ID" ]; then
            echo -e "${RED}Error: Run ID required${NC}"
            usage
        fi
        echo -e "${YELLOW}Cancelling run: $RUN_ID${NC}"
        scalr run cancel -id="$RUN_ID"
        ;;
        
    logs)
        RUN_ID=$1
        if [ -z "$RUN_ID" ]; then
            echo -e "${RED}Error: Run ID required${NC}"
            usage
        fi
        echo -e "${BLUE}Logs for run: $RUN_ID${NC}"
        scalr run logs -id="$RUN_ID"
        ;;
        
    cost)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${BLUE}Cost estimation for workspace: $WORKSPACE${NC}"
        scalr workspace show -workspace="$WORKSPACE" | grep -E "Monthly Cost:|Hourly Cost:"
        ;;
        
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        usage
        ;;
esac