#!/bin/bash
# Install Scalr CLI
# Usage: ./install-scalr-cli.sh

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Map architecture names
case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        ;;
    *)
        echo -e "${RED}Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

# Get latest version (with v prefix)
LATEST_VERSION=$(curl -s https://api.github.com/repos/Scalr/scalr-cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Version without v prefix for filename
VERSION_NO_V=${LATEST_VERSION#v}

# Construct download filename
FILENAME="scalr-cli_${VERSION_NO_V}_${OS}_${ARCH}.zip"

echo -e "${GREEN}Installing Scalr CLI ${LATEST_VERSION} for ${OS}/${ARCH}...${NC}"

# Construct download URL
DOWNLOAD_URL="https://github.com/Scalr/scalr-cli/releases/download/${LATEST_VERSION}/${FILENAME}"

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and extract
echo "Downloading from: $DOWNLOAD_URL"
curl -L -f -o scalr-cli.zip "$DOWNLOAD_URL"

# Check if download was successful and is a valid zip file
if [ ! -f scalr-cli.zip ]; then
    echo -e "${RED}Download failed${NC}"
    exit 1
fi

# Check file size (should be more than 1KB)
FILE_SIZE=$(stat -f%z scalr-cli.zip 2>/dev/null || stat -c%s scalr-cli.zip 2>/dev/null)
if [ "$FILE_SIZE" -lt 1000 ]; then
    echo -e "${RED}Downloaded file is too small (${FILE_SIZE} bytes). Download may have failed.${NC}"
    echo "Please check the URL: $DOWNLOAD_URL"
    exit 1
fi

# Extract zip file
unzip -q scalr-cli.zip

# Install to /usr/local/bin (may require sudo)
if [ -w /usr/local/bin ]; then
    mv scalr /usr/local/bin/
else
    echo -e "${YELLOW}Installing to /usr/local/bin requires sudo${NC}"
    sudo mv scalr /usr/local/bin/
fi

# Cleanup
cd - > /dev/null
rm -rf "$TEMP_DIR"

# Verify installation
if command -v scalr &> /dev/null; then
    echo -e "${GREEN}✓ Scalr CLI installed successfully!${NC}"
    scalr --version
    
    echo -e "\n${GREEN}Next steps:${NC}"
    echo "1. Configure Scalr CLI: scalr -configure"
    echo "2. Or set environment variables:"
    echo "   export SCALR_HOSTNAME='the-mothership.scalr.io'"
    echo "   export SCALR_TOKEN='your-api-token'"
    echo "3. Enable auto-completion: scalr -autocomplete"
else
    echo -e "${RED}Installation failed${NC}"
    exit 1
fi