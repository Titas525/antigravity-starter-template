#!/bin/bash
# ===========================================
# add-module.sh — Add module to existing project
# ===========================================
# Adds a new module or integration to an existing
# ANTIGRAVITY-STARTER generated project.
#
# Usage:
#   ./scripts/add-module.sh auth          # Add auth module
#   ./scripts/add-module.sh telegram      # Add Telegram integration
#   ./scripts/add-module.sh postgis       # Add PostGIS support
#   ./scripts/add-module.sh --list        # List available modules
# ===========================================

set -e

TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

show_available() {
  echo "Available modules:"
  echo ""
  echo "  auth        — JWT authentication (login, register, refresh)"
  echo "  telegram    — Telegram bot integration"
  echo "  google      — Google Sheets/OAuth integration"
  echo "  webhooks    — Webhook receiver with signature validation"
  echo "  postgis     — PostGIS extension for PostgreSQL"
  echo "  docker      — Docker Compose setup (app + db + redis)"
  echo "  ci          — GitHub Actions CI pipeline"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "ANTIGRAVITY-STARTER — Module Installer"
  echo ""
  echo "Usage:"
  echo "  ./scripts/add-module.sh <module>   Add module to current project"
  echo "  ./scripts/add-module.sh --list     List available modules"
  echo ""
  echo "Examples:"
  echo "  ./scripts/add-module.sh auth"
  echo "  ./scripts/add-module.sh telegram"
  exit 0
fi

if [ "$1" = "--list" ]; then
  show_available
  exit 0
fi

MODULE="$1"

if [ -z "$MODULE" ]; then
  echo -e "${RED}❌ No module specified${NC}"
  echo "  Run ./scripts/add-module.sh --list to see available modules"
  echo "  Run ./scripts/add-module.sh --help for usage"
  exit 1
fi

# Check if we're in an ANTIGRAVITY-STARTER project
if [ ! -f ".antigravity/project.config.json" ]; then
  echo -e "${YELLOW}⚠️  No .antigravity/project.config.json found${NC}"
  echo "  This doesn't look like an ANTIGRAVITY-STARTER project."
  read -p "  Continue anyway? [y/N]: " CONFIRM
  if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    exit 1
  fi
fi

echo -e "${BLUE}Installing module:${NC} $MODULE"
echo ""

case "$MODULE" in
  auth)
    mkdir -p apps/api/modules/auth
    cat > apps/api/modules/auth/__init__.py << 'EOF'
"""Auth modulis — autentifikacija ir autorizacija."""
EOF
    cat > apps/api/modules/auth/schemas.py << 'EOF'
"""Auth schemos."""
from pydantic import BaseModel, EmailStr


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str
    name: str | None = None


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    refresh_token: str | None = None
EOF
    cat > apps/api/modules/auth/api.py << 'EOF'
"""Auth API endpoint'ai."""
from fastapi import APIRouter

router = APIRouter(prefix="/api/v1/auth", tags=["auth"])


@router.post("/register")
async def register():
    return {"message": "Register endpoint — implement logic here"}


@router.post("/login")
async def login():
    return {"message": "Login endpoint — implement logic here"}


@router.post("/refresh")
async def refresh():
    return {"message": "Token refresh endpoint — implement logic here"}
EOF
    echo -e "  ${GREEN}✅${NC} apps/api/modules/auth/ — JWT auth module created"
    echo -e "  ${YELLOW}ℹ️  Add to .env:${NC} JWT_SECRET=your-secret"
    ;;

  telegram)
    if [ -d "integrations/telegram" ]; then
      echo -e "${YELLOW}⚠️  Telegram integration already exists${NC}"
    else
      mkdir -p integrations/telegram
      cp "$TEMPLATE_DIR/integrations/telegram/README.md" integrations/telegram/ 2>/dev/null || true
      echo -e "  ${GREEN}✅${NC} integrations/telegram/ — Telegram bot support"
    fi
    ;;

  google)
    if [ -d "integrations/google" ]; then
      echo -e "${YELLOW}⚠️  Google integration already exists${NC}"
    else
      mkdir -p integrations/google
      cp "$TEMPLATE_DIR/integrations/google/README.md" integrations/google/ 2>/dev/null || true
      echo -e "  ${GREEN}✅${NC} integrations/google/ — Google APIs support"
    fi
    ;;

  webhooks)
    if [ -d "integrations/webhooks" ]; then
      echo -e "${YELLOW}⚠️  Webhooks integration already exists${NC}"
    else
      mkdir -p integrations/webhooks
      cp "$TEMPLATE_DIR/integrations/webhooks/README.md" integrations/webhooks/ 2>/dev/null || true
      echo -e "  ${GREEN}✅${NC} integrations/webhooks/ — Webhook handlers"
    fi
    ;;

  postgis)
    echo -e "  ${YELLOW}ℹ️  Updating docker-compose.yml for PostGIS...${NC}"
    if [ -f "docker-compose.yml" ]; then
      sed -i 's|image: postgres:16-alpine|image: postgis/postgis:16-3.4|g' docker-compose.yml
      echo -e "  ${GREEN}✅${NC} docker-compose.yml — PostgreSQL → PostGIS"
    fi
    sed -i 's|DB_TYPE=\"postgresql\"|DB_TYPE=\"postgresql+postgis\"|g' .antigravity/project.config.json 2>/dev/null || true
    echo -e "  ${YELLOW}ℹ️  PostGIS extension requires:${NC} CREATE EXTENSION postgis;"
    ;;

  docker)
    if [ -f "docker-compose.yml" ]; then
      echo -e "${YELLOW}⚠️  docker-compose.yml already exists${NC}"
    else
      cp "$TEMPLATE_DIR/docker-compose.yml" . 2>/dev/null || true
      echo -e "  ${GREEN}✅${NC} docker-compose.yml added"
    fi
    ;;

  ci)
    mkdir -p .github/workflows
    if [ -f ".github/workflows/ci.yml" ]; then
      echo -e "${YELLOW}⚠️  CI workflow already exists${NC}"
    else
      cp "$TEMPLATE_DIR/.github/workflows/ci.yml" .github/workflows/ 2>/dev/null || true
      echo -e "  ${GREEN}✅${NC} .github/workflows/ci.yml added"
    fi
    ;;

  *)
    echo -e "${RED}❌ Unknown module: $MODULE${NC}"
    echo ""
    show_available
    exit 1
    ;;
esac

# Update project.config.json if it exists
if [ -f ".antigravity/project.config.json" ]; then
  case "$MODULE" in
    auth)   python3 -c "import json; d=json.load(open('.antigravity/project.config.json')); d['features']['auth']='y'; json.dump(d, open('.antigravity/project.config.json','w'), indent=2)" 2>/dev/null || true ;;
    telegram) python3 -c "import json; d=json.load(open('.antigravity/project.config.json')); d['features']['telegram']='y'; json.dump(d, open('.antigravity/project.config.json','w'), indent=2)" 2>/dev/null || true ;;
    google) python3 -c "import json; d=json.load(open('.antigravity/project.config.json')); d['features']['google']='y'; json.dump(d, open('.antigravity/project.config.json','w'), indent=2)" 2>/dev/null || true ;;
    postgis) python3 -c "import json; d=json.load(open('.antigravity/project.config.json')); d['stack']['database']='postgresql+postgis'; json.dump(d, open('.antigravity/project.config.json','w'), indent=2)" 2>/dev/null || true ;;
  esac
  echo -e "  ${GREEN}✅${NC} .antigravity/project.config.json updated"
fi

echo ""
echo -e "${GREEN}✅ Module '$MODULE' installed successfully!${NC}"
echo ""
