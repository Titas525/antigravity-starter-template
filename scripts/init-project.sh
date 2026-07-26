#!/bin/bash
# ===========================================
# init-project.sh — ANTIGRAVITY-STARTER Generator
# ===========================================
# Interactive project initializer.
# Select project type → configure stack → generate.
#
# Usage:
#   ./scripts/init-project.sh                    # Interactive wizard
#   ./scripts/init-project.sh --quick my-project  # Quick defaults
#   ./scripts/init-project.sh --help              # Show help
# ===========================================

set -e

TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# ==========================================
# HELP
# ==========================================
show_help() {
  echo "ANTIGRAVITY-STARTER v1.1 — Project Generator"
  echo ""
  echo "Usage:"
  echo "  ./scripts/init-project.sh                    Interactive wizard"
  echo "  ./scripts/init-project.sh --quick <name>      Quick mode (all defaults)"
  echo "  ./scripts/init-project.sh --type <type> <name>  Preset type"
  echo "  ./scripts/init-project.sh --help              This help"
  echo ""
  echo "Project types:"
  echo "  saas        — Next.js + FastAPI + PostgreSQL + Stripe"
  echo "  ai-saas     — SaaS + OpenAI/Gemini"
  echo "  lead-gen    — Next.js + FastAPI + LinkedIn + Google Sheets"
  echo "  data        — FastAPI + PostgreSQL/PostGIS + Analytics"
  echo "  automation  — Python + n8n + Webhooks"
  echo "  api         — FastAPI + PostgreSQL only"
  echo "  web         — Next.js only"
  echo ""
  echo "Examples:"
  echo "  ./scripts/init-project.sh"
  echo "  ./scripts/init-project.sh --quick my-api"
  echo "  ./scripts/init-project.sh --type ai-saas my-ai-app"
  exit 0
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  show_help
fi

# ==========================================
# BANNER
# ==========================================
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BLUE}ANTIGRAVITY-STARTER${NC} v1.1                       ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Project Generator                               ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ==========================================
# QUICK MODE (--quick <name>)
# ==========================================
if [ "$1" = "--quick" ] && [ -n "$2" ]; then
  PROJECT_NAME="$2"
  PROJECT_DESC="Quick-generated project"
  PROJECT_TYPE="api"
  FRONTEND="none"
  BACKEND="fastapi"
  DB_TYPE="none"
  AI_PROVIDER="none"
  NEED_AUTH="n"
  NEED_TELEGRAM="n"
  NEED_GOOGLE="n"
  DEPLOY_TYPE="none"
  INIT_GIT="y"
  RUN_SETUP="y"
  echo -e "${YELLOW}Quick mode:${NC} $PROJECT_NAME (API)"
  echo ""
  SKIP_QUESTIONS=true

# PRESET MODE (--type <type> <name>)
elif [ "$1" = "--type" ] && [ -n "$2" ] && [ -n "$3" ]; then
  PROJECT_NAME="$3"
  case "$2" in
    saas)
      PROJECT_DESC="SaaS application"
      PROJECT_TYPE="saas"; FRONTEND="nextjs"; BACKEND="fastapi"
      DB_TYPE="postgresql"; AI_PROVIDER="none"; NEED_AUTH="y"
      NEED_TELEGRAM="n"; NEED_GOOGLE="n"; DEPLOY_TYPE="docker"
      ;;
    ai-saas)
      PROJECT_DESC="AI-powered SaaS"
      PROJECT_TYPE="ai-saas"; FRONTEND="nextjs"; BACKEND="fastapi"
      DB_TYPE="postgresql"; AI_PROVIDER="openai"; NEED_AUTH="y"
      NEED_TELEGRAM="n"; NEED_GOOGLE="n"; DEPLOY_TYPE="docker"
      ;;
    lead-gen)
      PROJECT_DESC="Lead generation platform"
      PROJECT_TYPE="lead-gen"; FRONTEND="nextjs"; BACKEND="fastapi"
      DB_TYPE="postgresql"; AI_PROVIDER="openai"; NEED_AUTH="y"
      NEED_TELEGRAM="y"; NEED_GOOGLE="y"; DEPLOY_TYPE="docker"
      ;;
    data)
      PROJECT_DESC="Data platform"
      PROJECT_TYPE="data"; FRONTEND="none"; BACKEND="fastapi"
      DB_TYPE="postgresql"; AI_PROVIDER="none"; NEED_AUTH="n"
      NEED_TELEGRAM="n"; NEED_GOOGLE="n"; DEPLOY_TYPE="docker"
      ;;
    automation)
      PROJECT_DESC="Automation bot"
      PROJECT_TYPE="automation"; FRONTEND="none"; BACKEND="fastapi"
      DB_TYPE="none"; AI_PROVIDER="openai"; NEED_AUTH="n"
      NEED_TELEGRAM="y"; NEED_GOOGLE="n"; DEPLOY_TYPE="none"
      ;;
    api)
      PROJECT_DESC="REST API"
      PROJECT_TYPE="api"; FRONTEND="none"; BACKEND="fastapi"
      DB_TYPE="postgresql"; AI_PROVIDER="none"; NEED_AUTH="y"
      NEED_TELEGRAM="n"; NEED_GOOGLE="n"; DEPLOY_TYPE="docker"
      ;;
    web)
      PROJECT_DESC="Web application"
      PROJECT_TYPE="web"; FRONTEND="nextjs"; BACKEND="none"
      DB_TYPE="none"; AI_PROVIDER="none"; NEED_AUTH="n"
      NEED_TELEGRAM="n"; NEED_GOOGLE="n"; DEPLOY_TYPE="vercel"
      ;;
    *)
      echo -e "${RED}Unknown type: $2${NC}"
      show_help
      ;;
  esac
  INIT_GIT="y"; RUN_SETUP="y"
  echo -e "${YELLOW}Type:${NC} $2 → $PROJECT_NAME"
  echo ""
  SKIP_QUESTIONS=true

else
  SKIP_QUESTIONS=false
fi

# ==========================================
# INTERACTIVE QUESTIONS
# ==========================================
if [ "$SKIP_QUESTIONS" = false ]; then

  echo -e "${BLUE}Step 1/10:${NC} Project name"
  read -p "  Name (e.g., my-awesome-app): " PROJECT_NAME
  PROJECT_NAME="${PROJECT_NAME:-my-project}"
  echo ""

  echo -e "${BLUE}Step 2/10:${NC} Description"
  read -p "  Description: " PROJECT_DESC
  PROJECT_DESC="${PROJECT_DESC:-A project built with ANTIGRAVITY-STARTER}"
  echo ""

  echo -e "${BLUE}Step 3/10:${NC} Project type"
  echo "  1) SaaS         — Next.js + FastAPI + PostgreSQL"
  echo "  2) AI SaaS      — SaaS + OpenAI/Gemini"
  echo "  3) Lead Gen     — LinkedIn + Google Sheets + AI"
  echo "  4) Data Platform — FastAPI + PostgreSQL/PostGIS"
  echo "  5) Automation   — Python + n8n + Webhooks"
  echo "  6) Custom       — Choose your own stack"
  read -p "  Choice [1-6] (default: 6): " PTYPE_CHOICE

  case "$PTYPE_CHOICE" in
    1) PROJECT_TYPE="saas"; FRONTEND="nextjs"; BACKEND="fastapi"; DB_TYPE="postgresql"; AI_PROVIDER="none"; NEED_AUTH="y"; NEED_TELEGRAM="n"; NEED_GOOGLE="n"; DEPLOY_TYPE="docker" ;;
    2) PROJECT_TYPE="ai-saas"; FRONTEND="nextjs"; BACKEND="fastapi"; DB_TYPE="postgresql"; AI_PROVIDER="openai"; NEED_AUTH="y"; NEED_TELEGRAM="n"; NEED_GOOGLE="n"; DEPLOY_TYPE="docker" ;;
    3) PROJECT_TYPE="lead-gen"; FRONTEND="nextjs"; BACKEND="fastapi"; DB_TYPE="postgresql"; AI_PROVIDER="openai"; NEED_AUTH="y"; NEED_TELEGRAM="y"; NEED_GOOGLE="y"; DEPLOY_TYPE="docker" ;;
    4) PROJECT_TYPE="data"; FRONTEND="none"; BACKEND="fastapi"; DB_TYPE="postgresql"; AI_PROVIDER="none"; NEED_AUTH="n"; NEED_TELEGRAM="n"; NEED_GOOGLE="n"; DEPLOY_TYPE="docker" ;;
    5) PROJECT_TYPE="automation"; FRONTEND="none"; BACKEND="fastapi"; DB_TYPE="none"; AI_PROVIDER="openai"; NEED_AUTH="n"; NEED_TELEGRAM="y"; NEED_GOOGLE="n"; DEPLOY_TYPE="none" ;;
    *) PROJECT_TYPE="custom" ;;
  esac

  if [ "$PROJECT_TYPE" = "custom" ]; then
    echo ""
    # Frontend
    echo -e "${BLUE}Step 4/10:${NC} Frontend"
    echo "  1) Next.js + TypeScript + Tailwind"
    echo "  2) None (API-only)"
    read -p "  Choice [1-2] (default: 1): " FE_CHOICE
    FRONTEND=$([ "$FE_CHOICE" = "2" ] && echo "none" || echo "nextjs")
    echo ""

    # Backend
    echo -e "${BLUE}Step 5/10:${NC} Backend"
    echo "  1) FastAPI + Python"
    echo "  2) None (frontend-only)"
    read -p "  Choice [1-2] (default: 1): " BE_CHOICE
    BACKEND=$([ "$BE_CHOICE" = "2" ] && echo "none" || echo "fastapi")
    echo ""

    # Database
    echo -e "${BLUE}Step 6/10:${NC} Database"
    echo "  1) PostgreSQL"
    echo "  2) PostgreSQL + PostGIS"
    echo "  3) None"
    read -p "  Choice [1-3] (default: 1): " DB_CHOICE
    case "$DB_CHOICE" in
      2) DB_TYPE="postgresql+postgis" ;;
      ""|1) DB_TYPE="postgresql" ;;
      *) DB_TYPE="none" ;;
    esac
    echo ""

    # AI
    echo -e "${BLUE}Step 7/10:${NC} AI / LLM"
    echo "  1) OpenAI"
    echo "  2) Gemini"
    echo "  3) Both (OpenAI + Gemini fallback)"
    echo "  4) None"
    read -p "  Choice [1-4] (default: 1): " AI_CHOICE
    case "$AI_CHOICE" in
      ""|1) AI_PROVIDER="openai" ;;
      2) AI_PROVIDER="gemini" ;;
      3) AI_PROVIDER="both" ;;
      *) AI_PROVIDER="none" ;;
    esac
    echo ""

    # Auth
    echo -e "${BLUE}Step 8/10:${NC} Authentication"
    read -p "  Add auth? [Y/n]: " NEED_AUTH
    NEED_AUTH="${NEED_AUTH:-y}"
    echo ""

    # Integrations
    echo -e "${BLUE}Step 9/10:${NC} Integrations"
    read -p "  Telegram notifications? [y/N]: " NEED_TELEGRAM
    NEED_TELEGRAM="${NEED_TELEGRAM:-n}"
    read -p "  Google Sheets/OAuth? [y/N]: " NEED_GOOGLE
    NEED_GOOGLE="${NEED_GOOGLE:-n}"
    echo ""

    # Deployment
    echo -e "${BLUE}Step 10/10:${NC} Deployment"
    echo "  1) Docker Compose (App + DB + Redis)"
    echo "  2) Vercel (frontend only)"
    echo "  3) None"
    read -p "  Choice [1-3] (default: 1): " DEPLOY_CHOICE
    case "$DEPLOY_CHOICE" in
      ""|1) DEPLOY_TYPE="docker" ;;
      2) DEPLOY_TYPE="vercel" ;;
      *) DEPLOY_TYPE="none" ;;
    esac
  fi

  echo ""
  read -p "  Initialize Git? [Y/n]: " INIT_GIT
  INIT_GIT="${INIT_GIT:-y}"
  read -p "  Run setup? [Y/n]: " RUN_SETUP
  RUN_SETUP="${RUN_SETUP:-y}"
fi

# ==========================================
# GENERATE PROJECT
# ==========================================
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  Generating project...                          ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Name:${NC}        $PROJECT_NAME"
echo -e "${GREEN}Type:${NC}        ${PROJECT_TYPE:-custom}"
echo -e "${GREEN}Frontend:${NC}    ${FRONTEND:-none}"
echo -e "${GREEN}Backend:${NC}     ${BACKEND:-none}"
echo -e "${GREEN}Database:${NC}    ${DB_TYPE:-none}"
echo -e "${GREEN}AI:${NC}          ${AI_PROVIDER:-none}"
echo -e "${GREEN}Auth:${NC}        $NEED_AUTH"
echo -e "${GREEN}Telegram:${NC}    $NEED_TELEGRAM"
echo -e "${GREEN}Google:${NC}      $NEED_GOOGLE"
echo -e "${GREEN}Deploy:${NC}       ${DEPLOY_TYPE:-none}"
echo ""

TARGET_DIR="./$PROJECT_NAME"
if [ -d "$TARGET_DIR" ]; then
  echo -e "${RED}❌ Directory '$TARGET_DIR' already exists!${NC}"
  exit 1
fi

echo -e "${BLUE}Creating project structure...${NC}"

# --- CORE (always) ---
mkdir -p "$TARGET_DIR/.antigravity/rules" \
         "$TARGET_DIR/.antigravity/workflows" \
         "$TARGET_DIR/docs/decisions" \
         "$TARGET_DIR/scripts" \
         "$TARGET_DIR/database/migrations" \
         "$TARGET_DIR/database/seeds" \
         "$TARGET_DIR/infrastructure/docker" \
         "$TARGET_DIR/infrastructure/github" \
         "$TARGET_DIR/packages/shared" \
         "$TARGET_DIR/packages/types" \
         "$TARGET_DIR/packages/config" \
         "$TARGET_DIR/packages/ui"

# Copy root files
cp "$TEMPLATE_DIR/.gitignore" "$TARGET_DIR/" 2>/dev/null || true
cp "$TEMPLATE_DIR/.editorconfig" "$TARGET_DIR/" 2>/dev/null || true
cp "$TEMPLATE_DIR/.env.example" "$TARGET_DIR/.env" 2>/dev/null || true
cp "$TEMPLATE_DIR/CONTRIBUTING.md" "$TARGET_DIR/" 2>/dev/null || true
echo -e "  ${GREEN}✅${NC} Core config files"

# Copy .antigravity
cp "$TEMPLATE_DIR/.antigravity/AGENTS.md" "$TARGET_DIR/.antigravity/" 2>/dev/null || true
for f in 00-core 01-architecture 02-security 03-git 04-testing 05-documentation; do
  cp "$TEMPLATE_DIR/.antigravity/rules/$f.md" "$TARGET_DIR/.antigravity/rules/" 2>/dev/null || true
done
for f in feature bugfix refactor deployment; do
  cp "$TEMPLATE_DIR/.antigravity/workflows/$f.md" "$TARGET_DIR/.antigravity/workflows/" 2>/dev/null || true
done
echo -e "  ${GREEN}✅${NC} .antigravity/ — AI agent OS"

# Copy docs
for f in architecture setup deployment; do
  cp "$TEMPLATE_DIR/docs/$f.md" "$TARGET_DIR/docs/" 2>/dev/null || true
done
cp "$TEMPLATE_DIR/docs/decisions/README.md" "$TARGET_DIR/docs/decisions/" 2>/dev/null || true
echo -e "  ${GREEN}✅${NC} docs/ — documentation"

# Copy .github
mkdir -p "$TARGET_DIR/.github/workflows" "$TARGET_DIR/.github/ISSUE_TEMPLATE"
cp "$TEMPLATE_DIR/.github/pull_request_template.md" "$TARGET_DIR/.github/" 2>/dev/null || true
cp "$TEMPLATE_DIR/.github/ISSUE_TEMPLATE/bug_report.md" "$TARGET_DIR/.github/ISSUE_TEMPLATE/" 2>/dev/null || true
cp "$TEMPLATE_DIR/.github/ISSUE_TEMPLATE/feature_request.md" "$TARGET_DIR/.github/ISSUE_TEMPLATE/" 2>/dev/null || true
cp "$TEMPLATE_DIR/.github/workflows/ci.yml" "$TARGET_DIR/.github/workflows/" 2>/dev/null || true
echo -e "  ${GREEN}✅${NC} .github/ — CI + templates"

# Copy scripts
cp "$TEMPLATE_DIR/scripts/setup.sh" "$TARGET_DIR/scripts/" 2>/dev/null || true
cp "$TEMPLATE_DIR/scripts/health-check.sh" "$TARGET_DIR/scripts/" 2>/dev/null || true
echo -e "  ${GREEN}✅${NC} scripts/ — utilities"

# Copy infrastructure
cp "$TEMPLATE_DIR/infrastructure/docker/README.md" "$TARGET_DIR/infrastructure/docker/" 2>/dev/null || true
cp "$TEMPLATE_DIR/infrastructure/github/README.md" "$TARGET_DIR/infrastructure/github/" 2>/dev/null || true
echo -e "  ${GREEN}✅${NC} infrastructure/ — Docker + GitHub"

# Copy gitkeep files for empty dirs
for d in packages/shared packages/types packages/config packages/ui database/migrations database/seeds; do
  touch "$TARGET_DIR/$d/.gitkeep" 2>/dev/null || true
done

# --- FRONTEND ---
if [ "$FRONTEND" = "nextjs" ]; then
  mkdir -p "$TARGET_DIR/apps/web/app"
  echo "# Next.js app" > "$TARGET_DIR/apps/web/README.md"
  echo -e "  ${GREEN}✅${NC} apps/web/ — Next.js ready"
fi

# --- BACKEND ---
if [ "$BACKEND" = "fastapi" ]; then
  mkdir -p "$TARGET_DIR/apps/api/core" \
           "$TARGET_DIR/apps/api/modules" \
           "$TARGET_DIR/apps/api/tests"
  touch "$TARGET_DIR/apps/api/__init__.py" \
        "$TARGET_DIR/apps/api/core/__init__.py" \
        "$TARGET_DIR/apps/api/modules/__init__.py" \
        "$TARGET_DIR/apps/api/tests/__init__.py"
  echo -e "  ${GREEN}✅${NC} apps/api/ — FastAPI backend"
fi

# --- INTEGRATIONS ---
cp -r "$TEMPLATE_DIR/integrations/ai" "$TARGET_DIR/integrations/" 2>/dev/null || true
cp -r "$TEMPLATE_DIR/integrations/webhooks" "$TARGET_DIR/integrations/" 2>/dev/null || true
if [ "$NEED_TELEGRAM" = "y" ] || [ "$NEED_TELEGRAM" = "Y" ]; then
  cp -r "$TEMPLATE_DIR/integrations/telegram" "$TARGET_DIR/integrations/" 2>/dev/null || true
fi
if [ "$NEED_GOOGLE" = "y" ] || [ "$NEED_GOOGLE" = "Y" ]; then
  cp -r "$TEMPLATE_DIR/integrations/google" "$TARGET_DIR/integrations/" 2>/dev/null || true
fi
echo -e "  ${GREEN}✅${NC} integrations/ — external services"

# --- DEPLOYMENT ---
if [ "$DEPLOY_TYPE" = "docker" ]; then
  cp "$TEMPLATE_DIR/docker-compose.yml" "$TARGET_DIR/" 2>/dev/null || true
  # Customize compose for PostGIS
  if [ "$DB_TYPE" = "postgresql+postgis" ]; then
    echo -e "  ${GREEN}✅${NC} docker-compose.yml — with PostGIS"
  else
    echo -e "  ${GREEN}✅${NC} docker-compose.yml"
  fi
fi

# --- CUSTOMIZE ---
# README
cat > "$TARGET_DIR/README.md" << README_EOF
# $PROJECT_NAME

> $PROJECT_DESC
> Generated with ANTIGRAVITY-STARTER v1.1

## Stack

$(if [ "$FRONTEND" = "nextjs" ]; then echo "- Frontend: Next.js + TypeScript + Tailwind"; fi)
$(if [ "$BACKEND" = "fastapi" ]; then echo "- Backend: FastAPI + Python"; fi)
$(if [ "$DB_TYPE" != "none" ]; then echo "- Database: $DB_TYPE"; fi)
$(if [ "$AI_PROVIDER" != "none" ]; then echo "- AI: $AI_PROVIDER"; fi)

## Structure

\`\`\`
.antigravity/   ← AI agent instructions
apps/           ← Application code
packages/       ← Shared packages
integrations/   ← External services
docs/           ← Documentation
scripts/        ← Utility scripts
\`\`\`

## Quick Start

\`\`\`bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn apps.api.main:app --reload
\`\`\`

## Deployment

See docs/deployment.md

## AI Agent

See .antigravity/AGENTS.md for AI development instructions.
README_EOF
echo -e "  ${GREEN}✅${NC} Customized README.md"

# .env customization
sed -i "s/APP_NAME=antigravity-starter/APP_NAME=$PROJECT_NAME/g" "$TARGET_DIR/.env" 2>/dev/null || true
if [ "$AI_PROVIDER" = "openai" ] || [ "$AI_PROVIDER" = "both" ]; then
  sed -i "s/# OPENAI_API_KEY=/OPENAI_API_KEY=/g" "$TARGET_DIR/.env" 2>/dev/null || true
fi
if [ "$AI_PROVIDER" = "gemini" ] || [ "$AI_PROVIDER" = "both" ]; then
  sed -i "s/# GEMINI_API_KEY=/GEMINI_API_KEY=/g" "$TARGET_DIR/.env" 2>/dev/null || true
fi
echo -e "  ${GREEN}✅${NC} Customized .env"

# --- GIT ---
if [ "$INIT_GIT" = "y" ] || [ "$INIT_GIT" = "Y" ]; then
  (cd "$TARGET_DIR" && git init 2>/dev/null && git add . 2>/dev/null && \
   git commit -m "Initial project setup from ANTIGRAVITY-STARTER v1.1

Generated with init-project.sh

🤖 Generated with Codebuff
Co-Authored-By: Codebuff <noreply@codebuff.com>" 2>/dev/null || true)
  echo -e "  ${GREEN}✅${NC} Git repository initialized"
fi

# --- SETUP ---
if [ "$RUN_SETUP" = "y" ] || [ "$RUN_SETUP" = "Y" ]; then
  (cd "$TARGET_DIR" && bash scripts/setup.sh 2>/dev/null || true)
fi

# ==========================================
# SUMMARY
# ==========================================
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ✅ Project '$PROJECT_NAME' created successfully!  ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo ""
echo "  cd $PROJECT_NAME"
echo "  cat README.md              # View project docs"
echo "  cat .antigravity/AGENTS.md  # View AI instructions"
echo "  code .                     # Open in editor"
echo ""
echo -e "${BLUE}Stack:${NC}"
echo "  Type:       ${PROJECT_TYPE:-custom}"
echo "  Frontend:   ${FRONTEND:-none}"
echo "  Backend:    ${BACKEND:-none}"
echo "  Database:   ${DB_TYPE:-none}"
echo "  AI:         ${AI_PROVIDER:-none}"
echo ""
