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
    echo "  configure-workspace <name>   Configure workspace variables"
    echo "  list-vars <workspace>        List workspace variables"
    echo "  set-var <workspace>          Set a workspace variable"
    echo ""
    echo "Examples:"
    echo "  $0 list-workspaces"
    echo "  $0 workspace development-digitalocean"
    echo "  $0 plan development-digitalocean"
    echo "  $0 apply production-proxmox-vm"
    echo "  $0 configure-workspace development-digitalocean"
    echo "  $0 set-var development-digitalocean ssh_fingerprint"
    exit 1
}

# Parse command
COMMAND=$1
shift || true

case $COMMAND in
    list-workspaces)
        echo -e "${BLUE}Listing all workspaces...${NC}"
        scalr get-workspaces
        ;;
        
    workspace)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${BLUE}Showing workspace: $WORKSPACE${NC}"
        # Find workspace ID by name
        WORKSPACE_ID=$(scalr get-workspaces -query="$WORKSPACE" | grep -oE 'ws-[a-zA-Z0-9]+' | head -1)
        if [ -z "$WORKSPACE_ID" ]; then
            echo -e "${RED}Workspace not found: $WORKSPACE${NC}"
            exit 1
        fi
        scalr get-workspace -workspace="$WORKSPACE_ID"
        ;;
        
    plan)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${BLUE}Creating plan run for workspace: $WORKSPACE${NC}"
        # Find workspace ID by name
        WORKSPACE_ID=$(scalr get-workspaces -query="$WORKSPACE" | grep -oE 'ws-[a-zA-Z0-9]+' | head -1)
        if [ -z "$WORKSPACE_ID" ]; then
            echo -e "${RED}Workspace not found: $WORKSPACE${NC}"
            exit 1
        fi
        RUN_ID=$(scalr create-run -workspace="$WORKSPACE_ID" -is-confirm-apply=false | grep -oE 'run-[a-zA-Z0-9]+' | head -1)
        echo -e "${GREEN}Created run: $RUN_ID${NC}"
        echo "View run: scalr get-run -run=$RUN_ID"
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
            # Find workspace ID by name
            WORKSPACE_ID=$(scalr get-workspaces -query="$WORKSPACE" | grep -oE 'ws-[a-zA-Z0-9]+' | head -1)
            if [ -z "$WORKSPACE_ID" ]; then
                echo -e "${RED}Workspace not found: $WORKSPACE${NC}"
                exit 1
            fi
            RUN_ID=$(scalr create-run -workspace="$WORKSPACE_ID" -is-confirm-apply=true | grep -oE 'run-[a-zA-Z0-9]+' | head -1)
            echo -e "${GREEN}Created auto-apply run: $RUN_ID${NC}"
            echo "Monitor run: scalr get-run -run=$RUN_ID"
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
        # Find workspace ID by name
        WORKSPACE_ID=$(scalr get-workspaces -query="$WORKSPACE" | grep -oE 'ws-[a-zA-Z0-9]+' | head -1)
        if [ -z "$WORKSPACE_ID" ]; then
            echo -e "${RED}Workspace not found: $WORKSPACE${NC}"
            exit 1
        fi
        scalr get-runs -filter-workspace="$WORKSPACE_ID"
        ;;
        
    run-status)
        RUN_ID=$1
        if [ -z "$RUN_ID" ]; then
            echo -e "${RED}Error: Run ID required${NC}"
            usage
        fi
        echo -e "${BLUE}Status for run: $RUN_ID${NC}"
        scalr get-run -run="$RUN_ID" | grep -E "Status:|Created:|Message:"
        ;;
        
    cancel)
        RUN_ID=$1
        if [ -z "$RUN_ID" ]; then
            echo -e "${RED}Error: Run ID required${NC}"
            usage
        fi
        echo -e "${YELLOW}Cancelling run: $RUN_ID${NC}"
        scalr cancel-run -run="$RUN_ID"
        ;;
        
    logs)
        RUN_ID=$1
        if [ -z "$RUN_ID" ]; then
            echo -e "${RED}Error: Run ID required${NC}"
            usage
        fi
        echo -e "${BLUE}Plan log for run: $RUN_ID${NC}"
        scalr get-plan-log -run="$RUN_ID"
        ;;
        
    cost)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${BLUE}Getting workspace details for: $WORKSPACE${NC}"
        # Find workspace ID by name
        WORKSPACE_ID=$(scalr get-workspaces -query="$WORKSPACE" | grep -oE 'ws-[a-zA-Z0-9]+' | head -1)
        if [ -z "$WORKSPACE_ID" ]; then
            echo -e "${RED}Workspace not found: $WORKSPACE${NC}"
            exit 1
        fi
        scalr get-workspace -workspace="$WORKSPACE_ID" | grep -E "cost-estimation-enabled:|latest-run:"
        echo -e "${YELLOW}Note: For detailed cost estimates, check specific runs with cost estimation enabled${NC}"
        ;;
        
    configure-workspace)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${BLUE}Configuring workspace: $WORKSPACE${NC}"
        # Find workspace ID by name
        WORKSPACE_ID=$(scalr get-workspaces -query="$WORKSPACE" | grep -oE 'ws-[a-zA-Z0-9]+' | head -1)
        if [ -z "$WORKSPACE_ID" ]; then
            echo -e "${RED}Workspace not found: $WORKSPACE${NC}"
            exit 1
        fi
        
        # Determine if it's a DigitalOcean workspace
        if [[ "$WORKSPACE" == *"digitalocean"* ]]; then
            echo -e "${BLUE}Configuring DigitalOcean workspace variables...${NC}"
            
            # SSH fingerprint
            echo -e "${YELLOW}Enter SSH fingerprint (sensitive):${NC}"
            read -rs SSH_FINGERPRINT
            if [ -n "$SSH_FINGERPRINT" ]; then
                scalr create-variable \
                    -workspace="$WORKSPACE_ID" \
                    -key="ssh_fingerprint" \
                    -value="$SSH_FINGERPRINT" \
                    -category="terraform" \
                    -hcl=false \
                    -sensitive=true || echo "Variable may already exist"
            fi
            
            # Development public key
            echo -e "${YELLOW}Enter development public key (sensitive):${NC}"
            read -rs DEV_PUBLIC_KEY
            if [ -n "$DEV_PUBLIC_KEY" ]; then
                scalr create-variable \
                    -workspace="$WORKSPACE_ID" \
                    -key="development_public_key" \
                    -value="$DEV_PUBLIC_KEY" \
                    -category="terraform" \
                    -hcl=false \
                    -sensitive=true || echo "Variable may already exist"
            fi
        fi
        
        echo -e "${GREEN}✓ Workspace configuration complete${NC}"
        ;;
        
    list-vars)
        WORKSPACE=$1
        if [ -z "$WORKSPACE" ]; then
            echo -e "${RED}Error: Workspace name required${NC}"
            usage
        fi
        echo -e "${BLUE}Variables for workspace: $WORKSPACE${NC}"
        # Find workspace ID by name
        WORKSPACE_ID=$(scalr get-workspaces -query="$WORKSPACE" | grep -oE 'ws-[a-zA-Z0-9]+' | head -1)
        if [ -z "$WORKSPACE_ID" ]; then
            echo -e "${RED}Workspace not found: $WORKSPACE${NC}"
            exit 1
        fi
        scalr get-variables -filter-workspace="$WORKSPACE_ID"
        ;;
        
    set-var)
        WORKSPACE=$1
        VAR_KEY=$2
        if [ -z "$WORKSPACE" ] || [ -z "$VAR_KEY" ]; then
            echo -e "${RED}Error: Workspace name and variable key required${NC}"
            echo "Usage: $0 set-var <workspace> <variable-key>"
            exit 1
        fi
        
        # Find workspace ID by name
        WORKSPACE_ID=$(scalr get-workspaces -query="$WORKSPACE" | grep -oE 'ws-[a-zA-Z0-9]+' | head -1)
        if [ -z "$WORKSPACE_ID" ]; then
            echo -e "${RED}Workspace not found: $WORKSPACE${NC}"
            exit 1
        fi
        
        echo -e "${YELLOW}Is this a sensitive variable? (y/N)${NC}"
        read -r IS_SENSITIVE
        
        if [ "$IS_SENSITIVE" = "y" ] || [ "$IS_SENSITIVE" = "Y" ]; then
            echo -e "${YELLOW}Enter value for $VAR_KEY (hidden):${NC}"
            read -rs VAR_VALUE
            SENSITIVE_FLAG=true
        else
            echo -e "${YELLOW}Enter value for $VAR_KEY:${NC}"
            read -r VAR_VALUE
            SENSITIVE_FLAG=false
        fi
        
        echo -e "${BLUE}Setting variable $VAR_KEY for workspace $WORKSPACE...${NC}"
        scalr create-variable \
            -workspace="$WORKSPACE_ID" \
            -key="$VAR_KEY" \
            -value="$VAR_VALUE" \
            -category="terraform" \
            -hcl=false \
            -sensitive=$SENSITIVE_FLAG
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Variable set successfully${NC}"
        else
            echo -e "${YELLOW}Variable may already exist. Trying to update...${NC}"
            # Get variable ID
            VAR_ID=$(scalr get-variables -filter-workspace="$WORKSPACE_ID" | grep -B2 "\"$VAR_KEY\"" | grep -oE 'var-[a-zA-Z0-9]+' | head -1)
            if [ -n "$VAR_ID" ]; then
                scalr update-variable \
                    -variable="$VAR_ID" \
                    -value="$VAR_VALUE"
                echo -e "${GREEN}✓ Variable updated successfully${NC}"
            else
                echo -e "${RED}Failed to set or update variable${NC}"
            fi
        fi
        ;;
        
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        usage
        ;;
esac