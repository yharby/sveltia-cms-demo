#!/bin/bash

# Sveltia CMS - GitHub OAuth Setup Helper
# This script helps you set up GitHub OAuth for production deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Repository info
REPO_OWNER="yharby"
REPO_NAME="sveltia-cms-demo"
SITE_URL="https://yharby.github.io/sveltia-cms-demo"
CALLBACK_URL="${SITE_URL}/admin/"

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Sveltia CMS - GitHub OAuth Setup Helper${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}✗ GitHub CLI (gh) is not installed${NC}"
    echo -e "${YELLOW}  Please install it from: https://cli.github.com/${NC}"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}✗ Not authenticated with GitHub CLI${NC}"
    echo -e "${YELLOW}  Run: gh auth login${NC}"
    exit 1
fi

echo -e "${GREEN}✓ GitHub CLI is ready${NC}"
echo ""

echo -e "${YELLOW}GitHub OAuth App Creation${NC}"
echo -e "${YELLOW}─────────────────────────────────────────────────────${NC}"
echo ""
echo "GitHub doesn't allow programmatic OAuth app creation for security reasons."
echo "You'll need to create it manually via the web interface."
echo ""
echo -e "${BLUE}Here's what you need:${NC}"
echo ""
echo "  ${GREEN}Application name:${NC}      Sveltia CMS - ${REPO_NAME}"
echo "  ${GREEN}Homepage URL:${NC}          ${SITE_URL}"
echo "  ${GREEN}Callback URL:${NC}          ${CALLBACK_URL}"
echo ""
echo -e "${YELLOW}─────────────────────────────────────────────────────${NC}"
echo ""

# Ask if user wants to open the browser
read -p "Open GitHub OAuth app creation page in browser? [Y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${BLUE}Opening browser...${NC}"

    # Try to open browser based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        open "https://github.com/settings/applications/new"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        xdg-open "https://github.com/settings/applications/new" 2>/dev/null || \
        sensible-browser "https://github.com/settings/applications/new" 2>/dev/null || \
        echo -e "${YELLOW}Could not open browser automatically.${NC}"
        echo "Please visit: https://github.com/settings/applications/new"
    else
        echo -e "${YELLOW}Unknown OS. Please visit manually:${NC}"
        echo "https://github.com/settings/applications/new"
    fi
fi

echo ""
echo -e "${GREEN}Steps to create OAuth app:${NC}"
echo "  1. Fill in the form with the details shown above"
echo "  2. Click 'Register application'"
echo "  3. Copy the Client ID"
echo "  4. Click 'Generate a new client secret'"
echo "  5. Copy the Client Secret (you won't see it again!)"
echo ""

# Wait for user to complete OAuth app creation
read -p "Press Enter when you have created the OAuth app and have your credentials..."
echo ""

# Ask for credentials
echo -e "${YELLOW}Enter your OAuth app credentials:${NC}"
echo ""
read -p "Client ID: " CLIENT_ID
read -sp "Client Secret: " CLIENT_SECRET
echo ""
echo ""

if [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
    echo -e "${RED}✗ Client ID and Secret are required${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Credentials received${NC}"
echo ""

# Option 1: Store in GitHub Secrets (recommended for workflows)
echo -e "${YELLOW}Option 1: Store as GitHub Repository Secrets (Recommended)${NC}"
echo "This allows GitHub Actions to use them for automated deployments."
echo ""
read -p "Store credentials as GitHub secrets? [Y/n] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${BLUE}Storing secrets...${NC}"

    gh secret set OAUTH_CLIENT_ID --body "$CLIENT_ID" --repo "${REPO_OWNER}/${REPO_NAME}"
    gh secret set OAUTH_CLIENT_SECRET --body "$CLIENT_SECRET" --repo "${REPO_OWNER}/${REPO_NAME}"

    echo -e "${GREEN}✓ Secrets stored successfully${NC}"
    echo ""
fi

# Option 2: Display for manual configuration
echo -e "${YELLOW}Option 2: Manual Configuration${NC}"
echo "You can also configure OAuth directly in your deployment platform:"
echo ""
echo -e "${BLUE}For Netlify:${NC}"
echo "  1. Go to: Site settings → Access control → OAuth"
echo "  2. Install GitHub provider"
echo "  3. Enter Client ID and Secret"
echo ""
echo -e "${BLUE}For Cloudflare Pages:${NC}"
echo "  1. Set environment variables:"
echo "     OAUTH_CLIENT_ID=${CLIENT_ID}"
echo "     OAUTH_CLIENT_SECRET=${CLIENT_SECRET}"
echo ""

# Option 3: Sveltia's free OAuth service
echo ""
echo -e "${GREEN}✨ Or use Sveltia's FREE OAuth service (easiest!):${NC}"
echo ""
echo "Sveltia CMS provides a free OAuth authentication service."
echo "Uncomment this line in public/admin/config.yml:"
echo ""
echo -e "${BLUE}  auth_endpoint: https://sveltia-cms-auth.cloudflare.dev${NC}"
echo ""
echo "No additional setup needed!"
echo ""

echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Setup Complete! 🎉${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}Your site will be available at:${NC}"
echo "  ${SITE_URL}"
echo ""
echo -e "${BLUE}CMS Admin:${NC}"
echo "  ${CALLBACK_URL}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Commit and push changes: git add . && git commit && git push"
echo "  2. Wait for GitHub Actions to deploy (check Actions tab)"
echo "  3. Visit your CMS admin URL"
echo "  4. Sign in with GitHub!"
echo ""
