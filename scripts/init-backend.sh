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

# Check if SCALR_TOKEN is set
if [ -z "$SCALR_TOKEN" ]; then
    echo -e "${YELLOW}Warning: SCALR_TOKEN environment variable is not set${NC}"
    echo "Please set it with: export SCALR_TOKEN='your-token'"
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

# Initialize with backend config
echo -e "${GREEN}Initializing OpenTofu backend for workspace: ${WORKSPACE}${NC}"
tofu init \
    -backend-config="${PROJECT_ROOT}/shared/backend-config/backend.hcl.template" \
    -backend-config="workspaces={name=\"${WORKSPACE}\"}" \
    -reconfigure

echo -e "${GREEN}✓ Backend initialized successfully!${NC}"
echo -e "Workspace: ${WORKSPACE}"
echo -e "Directory: ${ENV_DIR}"