#!/bin/bash
# Install OpenTofu on macOS
# Usage: ./install-opentofu.sh

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing OpenTofu...${NC}"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${RED}Homebrew is not installed. Please install Homebrew first:${NC}"
    echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Add OpenTofu tap
echo -e "${BLUE}Adding OpenTofu tap...${NC}"
brew tap opentofu/tap

# Install OpenTofu
echo -e "${BLUE}Installing OpenTofu...${NC}"
brew install opentofu

# Verify installation
if command -v tofu &> /dev/null; then
    echo -e "${GREEN}✓ OpenTofu installed successfully!${NC}"
    tofu --version
else
    echo -e "${RED}Installation failed${NC}"
    exit 1
fi

echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "You can now use the 'tofu' command instead of 'terraform'"