#!/bin/bash
# Setup all Scalr workspaces for the scalr_do_test project
# Usage: ./setup-scalr-workspaces.sh

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

# Define workspace configurations using arrays (compatible with older bash)
WORKSPACES=(
    "development-digitalocean:env-v0oqi96v6i2ok05dp:pcfg-v0oqaah4gv919laeb"
    "development-proxmox-vm:env-v0oqi96v6i2ok05dp:pcfg-v0oqgn3timevpk4m0"
    "development-proxmox-container:env-v0oqi96v6i2ok05dp:pcfg-v0oqgn3timevpk4m0"
    "staging-digitalocean:env-v0oqi98iuvokklq8p:pcfg-v0oqaah4gv919laeb"
    "staging-proxmox-vm:env-v0oqi98iuvokklq8p:pcfg-v0oqgn3timevpk4m0"
    "staging-proxmox-container:env-v0oqi98iuvokklq8p:pcfg-v0oqgn3timevpk4m0"
    "production-digitalocean:env-v0oqi992t6eb6ehmq:pcfg-v0oqaah4gv919laeb"
    "production-proxmox-vm:env-v0oqi992t6eb6ehmq:pcfg-v0oqgn3timevpk4m0"
    "production-proxmox-container:env-v0oqi992t6eb6ehmq:pcfg-v0oqgn3timevpk4m0"
)

# Function to create a workspace
create_workspace() {
    local WORKSPACE_NAME=$1
    local ENV_ID=$2
    local PROVIDER_CONFIG_ID=$3
    
    echo -e "${BLUE}Creating workspace: $WORKSPACE_NAME${NC}"
    
    # Check if workspace already exists
    EXISTING=$(scalr get-workspaces -query="$WORKSPACE_NAME" | grep -oE 'ws-[a-zA-Z0-9]+' | head -1 || true)
    
    if [ -n "$EXISTING" ]; then
        echo -e "${YELLOW}Workspace $WORKSPACE_NAME already exists (ID: $EXISTING)${NC}"
        return 0
    fi
    
    # Determine VCS working directory based on workspace name
    ENVIRONMENT=$(echo $WORKSPACE_NAME | cut -d'-' -f1)
    PROVIDER=$(echo $WORKSPACE_NAME | cut -d'-' -f2-)
    VCS_WORKING_DIR="scalr_do_test/environments/${ENVIRONMENT}/${PROVIDER}"
    
    # Create workspace
    echo "Creating with: name=$WORKSPACE_NAME, env=$ENV_ID"
    RESULT=$(scalr create-workspace \
        -name="$WORKSPACE_NAME" \
        -environment-id="$ENV_ID" \
        -auto-apply=false 2>&1)
    
    # Extract workspace ID from the result
    WORKSPACE_ID=$(echo "$RESULT" | grep -oE '"id":\s*"ws-[^"]+"' | grep -oE 'ws-[a-zA-Z0-9]+' | head -1)
    
    if [ -n "$WORKSPACE_ID" ]; then
        echo -e "${GREEN}✓ Created workspace: $WORKSPACE_NAME (ID: $WORKSPACE_ID)${NC}"
        
        # Link provider configuration
        echo -e "${BLUE}Linking provider configuration...${NC}"
        LINK_RESULT=$(scalr create-provider-configuration-link \
            -workspace="$WORKSPACE_ID" \
            -provider-configuration-id="$PROVIDER_CONFIG_ID" \
            -alias="" 2>&1)
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Provider configuration linked${NC}"
        else
            echo -e "${YELLOW}Warning: Could not link provider configuration${NC}"
            echo "$LINK_RESULT"
        fi
    else
        echo -e "${RED}✗ Failed to create workspace: $WORKSPACE_NAME${NC}"
        echo "Error output:"
        echo "$RESULT"
        return 1
    fi
}

# Main execution
echo -e "${GREEN}=== Scalr Workspace Setup ===${NC}"
echo ""

# Show current workspaces
echo -e "${BLUE}Current workspaces:${NC}"
scalr get-workspaces || echo "No workspaces found"
echo ""

# Confirm creation
echo -e "${YELLOW}This will create the following workspaces:${NC}"
for WORKSPACE_CONFIG in "${WORKSPACES[@]}"; do
    WORKSPACE_NAME=$(echo "$WORKSPACE_CONFIG" | cut -d':' -f1)
    echo "  - $WORKSPACE_NAME"
done | sort
echo ""

echo -e "${YELLOW}Continue? (y/N)${NC}"
read -r CONFIRM
if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "Cancelled"
    exit 0
fi

# Create workspaces
echo ""
CREATED=0
FAILED=0

for WORKSPACE_CONFIG in "${WORKSPACES[@]}"; do
    IFS=':' read -r WORKSPACE_NAME ENV_ID PROVIDER_CONFIG_ID <<< "$WORKSPACE_CONFIG"
    
    if create_workspace "$WORKSPACE_NAME" "$ENV_ID" "$PROVIDER_CONFIG_ID"; then
        ((CREATED++))
    else
        ((FAILED++))
    fi
    echo ""
done

# Summary
echo -e "${GREEN}=== Summary ===${NC}"
echo -e "Created: ${GREEN}$CREATED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All workspaces created successfully!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Configure workspace variables: ./scalr-helper.sh configure-workspace <workspace-name>"
    echo "2. Initialize backends: ./init-backend.sh <environment> <provider>"
    echo "3. Run plans: ./scalr-helper.sh plan <workspace-name>"
else
    echo -e "${YELLOW}Some workspaces failed to create. Check the errors above.${NC}"
    exit 1
fi