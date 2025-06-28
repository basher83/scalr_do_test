#!/bin/bash
# Initialize OpenTofu/Terraform backend with Scalr
# Usage: ./init-backend.sh <environment> <provider>

set -e

# Check arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <environment> <provider>"
    echo "Example: $0 development digitalocean"
    echo "         $0 production proxmox-vm"
    exit 1
fi

ENVIRONMENT=$1
PROVIDER=$2
WORKSPACE="${ENVIRONMENT}-${PROVIDER}"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Check if SCALR_TOKEN is set or Scalr is configured
if [ -z "$SCALR_TOKEN" ] && [ ! -f ~/.scalr/scalr.conf ]; then
    echo -e "${YELLOW}Warning: SCALR_TOKEN environment variable is not set and Scalr CLI is not configured${NC}"
    echo "Please either:"
    echo "  1. Set environment variable: export SCALR_TOKEN='your-token'"
    echo "  2. Configure Scalr CLI: scalr -configure"
    exit 1
fi

# Navigate to the environment directory
ENV_DIR="${PROJECT_ROOT}/environments/${ENVIRONMENT}/${PROVIDER}"
if [ ! -d "$ENV_DIR" ]; then
    echo "Error: Directory $ENV_DIR does not exist"
    exit 1
fi

cd "$ENV_DIR"

# Remove any existing backend config
rm -f .terraform/terraform.tfstate

# Get token from Scalr config if available
SCALR_TOKEN_FROM_CONFIG=""
if [ -f ~/.scalr/scalr.conf ]; then
    SCALR_TOKEN_FROM_CONFIG=$(grep -o '"token":\s*"[^"]*"' ~/.scalr/scalr.conf | cut -d'"' -f4)
fi

# Export token if not already set
if [ -z "$SCALR_TOKEN" ] && [ -n "$SCALR_TOKEN_FROM_CONFIG" ]; then
    export SCALR_TOKEN="$SCALR_TOKEN_FROM_CONFIG"
fi

# Map environment name to environment ID
case $ENVIRONMENT in
    development)
        ENV_ID="env-v0oqi96v6i2ok05dp"
        ;;
    staging)
        ENV_ID="env-v0oqi98iuvokklq8p"
        ;;
    production)
        ENV_ID="env-v0oqi992t6eb6ehmq"
        ;;
    *)
        echo -e "${RED}Error: Unknown environment '$ENVIRONMENT'${NC}"
        exit 1
        ;;
esac

# Create a temporary backend config file with workspace name
TEMP_BACKEND_CONFIG=$(mktemp)
cat > "$TEMP_BACKEND_CONFIG" << EOF
hostname     = "the-mothership.scalr.io"
organization = "${ENV_ID}"
workspaces {
  name = "${WORKSPACE}"
}
EOF

# Initialize with backend config
echo -e "${GREEN}Initializing OpenTofu backend for workspace: ${WORKSPACE}${NC}"
tofu init \
    -backend-config="$TEMP_BACKEND_CONFIG" \
    -reconfigure

# Clean up temp file
rm -f "$TEMP_BACKEND_CONFIG"

echo -e "${GREEN}✓ Backend initialized successfully!${NC}"
echo -e "Workspace: ${WORKSPACE}"
echo -e "Directory: ${ENV_DIR}"