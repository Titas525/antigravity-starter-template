#!/bin/bash
# ===========================================
# init-project.sh — ANTIGRAVITY-STARTER Generator
# ===========================================
# Interactive project initializer.
# Asks questions about stack, integrations, deployment,
# then generates a complete project from the template.
#
# Usage:
#   ./scripts/init-project.sh                    # Interactive mode
#   ./scripts/init-project.sh --quick my-project  # Quick mode (defaults)
#   ./scripts/init-project.sh --help              # Show help
# ===========================================

set -e

TEMPLATE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ==========================================
# HELP
# ==========================================
show_help() {
  echo "ANTIGRAVITY-STARTER v1.0 — Project Generator"
  echo ""
  echo "Usage:"
  echo "  ./scripts/init-project.sh                     Interactive mode"
  echo "  ./scripts/init-project.sh --quick <name>      Quick mode (all defaults)"
  echo "  ./scripts/init-project.sh --help              This help"
  echo ""
  echo "Examples:"
  echo "  ./scripts/init-project.sh"
  echo "  ./scripts/init-project.sh --quick my-api"
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
echo -e "${CYAN}║${NC}  ${BLUE}ANTIGRAVITY-STARTER${NC} v1.0                       ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Project Generator                               ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ==========================================
# QUICK MODE
# ==========================================
if [ "$1" = "--quick" ] && [ -n "$2" ]; then
  PROJECT_NAME="$2"
  PROJECT_DESCRIPTION="Project generated from ANTIGRAVITY-STARTER template"
  STACK_TYPE="monorepo"
  DB_TYPE="none"
  AI_PROVIDER="none"
  NEED_TELEGRAM="n"
  NEED_GOOGLE="n"
  DEPLOY_TYPE="none"
  INIT_GIT="y"
  RUN_SETUP="y"

  echo -e "${YELLOW}Quick mode:${NC} $PROJECT_NAME"
  echo ""

  # Skip questions, use above defaults
  SKIP_QUESTIONS=true
else
  SKIP_QUESTIONS=false
fi

# ==========================================
# QUESTIONS
# ==========================================
if [ "$SKIP_QUESTIONS" = false ]; then

  # 1. Project name
  echo -e "${BLUE}Step 1/9:${NC} Project name"
  read -p "  Name (e.g., my-awesome-app): " PROJECT_NAME
  PROJECT_NAME="${PROJECT_NAME:-my-project}"
  echo ""

  # 2. Description
  echo -e "${BLUE}Step 2/9:${NC} Project description"
  read -p "  Description: " PROJECT_DESCRIPTION
  PROJECT_DESCRIPTION="${PROJECT_DESCRIPTION:-A project built with ANTIGRAVITY-STARTER}"
  echo ""

  # 3. Stack type
  echo -e "${BLUE}Step 3/9:${NC} Stack type"
  echo "  1) Python API     — FastAPI + Pydantic + SQLAlchemy"
  echo "  2) Next.js App    — Next.js + TypeScript + Tailwind"
  echo "  3) Monorepo       — apps/web (Next.js) + apps/api (FastAPI)"
  echo "  4) Minimal        — Basic Python project"
  read -p "  Choice [1-4] (default: 3): " STACK_CHOICE
  case "$STACK_CHOICE" in
    1) STACK_TYPE="api" ;;
    2) STACK_TYPE="nextjs" ;;
    3|"") STACK_TYPE="monorepo" ;;
    *) STACK_TYPE="minimal" ;;
  esac
  echo ""

  # 4. Database
  echo -e "${BLUE}Step 4/9:${NC} Database"
  echo "  1) PostgreSQL (recommended)"
  echo "  2) MySQL"
  echo "  3) SQLite (local dev)"
  echo "  4) None"
  read -p "  Choice [1-4] (default: 1): " DB_CHOICE
  case "$DB_CHOICE" in
    1|"") DB_TYPE="postgresql" ;;
    2) DB_TYPE="mysql" ;;
    3) DB_TYPE="sqlite" ;;
    *) DB_TYPE="none" ;;
  esac
  echo ""

  # 5. AI Provider
  echo -e "${BLUE}Step 5/9:${NC} AI / LLM Provider"
  echo "  1) OpenAI"
  echo "  2) Gemini"
  echo "  3) Both (OpenAI + Gemini fallback)"
  echo "  4) None"
  read -p "  Choice [1-4] (default: 1): " AI_CHOICE
  case "$AI_CHOICE" in
    1|"") AI_PROVIDER="openai" ;;
    2) AI_PROVIDER="gemini" ;;
    3) AI_PROVIDER="both" ;;
    *) AI_PROVIDER="none" ;;
  esac
  echo ""

  # 6. Telegram
  echo -e "${BLUE}Step 6/9:${NC} Telegram notifications"
  read -p "  Add Telegram bot support? [y/N]: " NEED_TELEGRAM
  NEED_TELEGRAM="${NEED_TELEGRAM:-n}"
  echo ""

  # 7. Google integration
  echo -e "${BLUE}Step 7/9:${NC} Google integration"
  read -p "  Add Google Sheets/OAuth support? [y/N]: " NEED_GOOGLE
  NEED_GOOGLE="${NEED_GOOGLE:-n}"
  echo ""

  # 8. Deployment
  echo -e "${BLUE}Step 8/9:${NC} Deployment"
  echo "  1) Docker Compose (App + DB + Redis)"
  echo "  2) VPS / Plesk (SSH-based)"
  echo "  3) None (will configure later)"
  read -p "  Choice [1-3] (default: 1): " DEPLOY_CHOICE
  case "$DEPLOY_CHOICE" in
    1|"") DEPLOY_TYPE="docker" ;;
    2) DEPLOY_TYPE="plesk" ;;
    *) DEPLOY_TYPE="none" ;;
  esac
  echo ""

  # 9. Git
  echo -e "${BLUE}Step 9/9:${NC} Initialization"
  read -p "  Initialize Git repository? [Y/n]: " INIT_GIT
  INIT_GIT="${INIT_GIT:-y}"
  echo ""

  read -p "  Run setup (cp .env, init git)? [Y/n]: " RUN_SETUP
  RUN_SETUP="${RUN_SETUP:-y}"

fi

# ==========================================
# SUMMARY
# ==========================================
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  Generating project...                          ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Name:${NC}        $PROJECT_NAME"
echo -e "${GREEN}Description:${NC} ${PROJECT_DESCRIPTION:0:60}..."
echo -e "${GREEN}Stack:${NC}        $STACK_TYPE"
echo -e "${GREEN}Database:${NC}     $DB_TYPE"
echo -e "${GREEN}AI:${NC}           $AI_PROVIDER"
echo -e "${GREEN}Telegram:${NC}     $NEED_TELEGRAM"
echo -e "${GREEN}Google:${NC}       $NEED_GOOGLE"
echo -e "${GREEN}Deployment:${NC}   $DEPLOY_TYPE"
echo -e "${GREEN}Git:${NC}          $INIT_GIT"
echo ""

TARGET_DIR="./$PROJECT_NAME"

if [ -d "$TARGET_DIR" ]; then
  echo -e "${YELLOW}❌ Directory '$TARGET_DIR' already exists!${NC}"
  exit 1
fi

# ==========================================
# GENERATE PROJECT
# ==========================================

echo -e "${BLUE}Creating project structure...${NC}"

# Create main directories
mkdir -p "$TARGET_DIR/.antigravity/rules"
mkdir -p "$TARGET_DIR/.antigravity/workflows"
mkdir -p "$TARGET_DIR/docs/decisions"

# Copy root files
cp "$TEMPLATE_DIR/.gitignore" "$TARGET_DIR/"
cp "$TEMPLATE_DIR/.editorconfig" "$TARGET_DIR/"
cp "$TEMPLATE_DIR/README.md" "$TARGET_DIR/"
cp "$TEMPLATE_DIR/CONTRIBUTING.md" "$TARGET_DIR/"

# Copy .env.example as .env
cp "$TEMPLATE_DIR/.env.example" "$TARGET_DIR/.env"
echo -e "  ${GREEN}✅${NC} .env created from template"

# Copy .antigravity (AI agent instructions)
cp "$TEMPLATE_DIR/.antigravity/AGENTS.md" "$TARGET_DIR/.antigravity/"
for f in 00-core 01-architecture 02-security 03-git 04-testing 05-documentation; do
  cp "$TEMPLATE_DIR/.antigravity/rules/$f.md" "$TARGET_DIR/.antigravity/rules/"
done
for f in feature bugfix refactor deployment; do
  cp "$TEMPLATE_DIR/.antigravity/workflows/$f.md" "$TARGET_DIR/.antigravity/workflows/"
done
echo -e "  ${GREEN}✅${NC} .antigravity/ — AI agent OS"

# Copy docs/
cp "$TEMPLATE_DIR/docs/architecture.md" "$TARGET_DIR/docs/"
cp "$TEMPLATE_DIR/docs/setup.md" "$TARGET_DIR/docs/"
cp "$TEMPLATE_DIR/docs/deployment.md" "$TARGET_DIR/docs/"
cp "$TEMPLATE_DIR/docs/decisions/README.md" "$TARGET_DIR/docs/decisions/"
echo -e "  ${GREEN}✅${NC} docs/ — documentation templates"

# Copy .github/
mkdir -p "$TARGET_DIR/.github/workflows"
mkdir -p "$TARGET_DIR/.github/ISSUE_TEMPLATE"
cp "$TEMPLATE_DIR/.github/workflows/ci.yml" "$TARGET_DIR/.github/workflows/"
cp "$TEMPLATE_DIR/.github/ISSUE_TEMPLATE/bug_report.md" "$TARGET_DIR/.github/ISSUE_TEMPLATE/"
cp "$TEMPLATE_DIR/.github/ISSUE_TEMPLATE/feature_request.md" "$TARGET_DIR/.github/ISSUE_TEMPLATE/"
cp "$TEMPLATE_DIR/.github/pull_request_template.md" "$TARGET_DIR/.github/"
echo -e "  ${GREEN}✅${NC} .github/ — CI + issue templates"

# Copy scripts/
mkdir -p "$TARGET_DIR/scripts"
cp "$TEMPLATE_DIR/scripts/setup.sh" "$TARGET_DIR/scripts/"
cp "$TEMPLATE_DIR/scripts/health-check.sh" "$TARGET_DIR/scripts/"
echo -e "  ${GREEN}✅${NC} scripts/ — utility scripts"

# ==========================================
# STACK-SPECIFIC SETUP
# ==========================================

# Always create packages/ (shared workspace)
mkdir -p "$TARGET_DIR/packages/shared"
mkdir -p "$TARGET_DIR/packages/types"
mkdir -p "$TARGET_DIR/packages/config"
mkdir -p "$TARGET_DIR/packages/ui"
touch "$TARGET_DIR/packages/shared/.gitkeep"
touch "$TARGET_DIR/packages/types/.gitkeep"
touch "$TARGET_DIR/packages/config/.gitkeep"
touch "$TARGET_DIR/packages/ui/.gitkeep"

# Databases
mkdir -p "$TARGET_DIR/database/migrations"
mkdir -p "$TARGET_DIR/database/seeds"
touch "$TARGET_DIR/database/migrations/.gitkeep"
touch "$TARGET_DIR/database/seeds/.gitkeep"

case "$STACK_TYPE" in
  api|monorepo)
    # Python API structure
    mkdir -p "$TARGET_DIR/apps/api/core"
    mkdir -p "$TARGET_DIR/apps/api/modules"
    mkdir -p "$TARGET_DIR/apps/api/tests"

    # Create __init__.py files
    touch "$TARGET_DIR/apps/api/__init__.py"
    touch "$TARGET_DIR/apps/api/core/__init__.py"
    touch "$TARGET_DIR/apps/api/modules/__init__.py"
    touch "$TARGET_DIR/apps/api/tests/__init__.py"

    echo -e "  ${GREEN}✅${NC} apps/api/ — Python backend"
    ;;
esac

case "$STACK_TYPE" in
  nextjs|monorepo)
    # Next.js structure
    mkdir -p "$TARGET_DIR/apps/web/app"
    # Placeholder — in real use, this would run `npx create-next-app`
    echo "# Next.js app" > "$TARGET_DIR/apps/web/README.md"
    echo -e "  ${GREEN}✅${NC} apps/web/ — Next.js ready (run: cd apps/web && npx create-next-app@latest .)"
    ;;
esac

if [ "$STACK_TYPE" = "minimal" ]; then
  mkdir -p "$TARGET_DIR/apps"
  touch "$TARGET_DIR/apps/.gitkeep"
  echo -e "  ${GREEN}✅${NC} apps/ — empty (minimal project)"
fi

# Always create apps/web and apps/api .gitkeep for structure
touch "$TARGET_DIR/apps/web/.gitkeep" 2>/dev/null || true
touch "$TARGET_DIR/apps/api/.gitkeep" 2>/dev/null || true

# ==========================================
# INTEGRATIONS
# ==========================================
mkdir -p "$TARGET_DIR/integrations"

# Copy all integration templates
cp -r "$TEMPLATE_DIR/integrations/ai" "$TARGET_DIR/integrations/"
cp -r "$TEMPLATE_DIR/integrations/webhooks" "$TARGET_DIR/integrations/"

# Conditionally add selected integrations
if [ "$NEED_TELEGRAM" = "y" ] || [ "$NEED_TELEGRAM" = "Y" ]; then
  cp -r "$TEMPLATE_DIR/integrations/telegram" "$TARGET_DIR/integrations/"
  echo -e "  ${GREEN}✅${NC} integrations/telegram/ — Telegram bot support"
fi
if [ "$NEED_GOOGLE" = "y" ] || [ "$NEED_GOOGLE" = "Y" ]; then
  cp -r "$TEMPLATE_DIR/integrations/google" "$TARGET_DIR/integrations/"
  echo -e "  ${GREEN}✅${NC} integrations/google/ — Google APIs"
fi

# ==========================================
# INFRASTRUCTURE
# ==========================================
mkdir -p "$TARGET_DIR/infrastructure/docker"
mkdir -p "$TARGET_DIR/infrastructure/github"
cp "$TEMPLATE_DIR/infrastructure/docker/README.md" "$TARGET_DIR/infrastructure/docker/"
cp "$TEMPLATE_DIR/infrastructure/github/README.md" "$TARGET_DIR/infrastructure/github/"
echo -e "  ${GREEN}✅${NC} infrastructure/ — Docker + GitHub configs"

# Docker Compose (always copy, user can remove)
cp "$TEMPLATE_DIR/docker-compose.yml" "$TARGET_DIR/"

# ==========================================
# CUSTOMIZE FILES
# ==========================================

# Update README.md with project name
sed -i "s/PROJECT NAME/$PROJECT_NAME/g" "$TARGET_DIR/README.md"
sed -i "s/Describe the project/$(echo "$PROJECT_DESCRIPTION" | sed 's|/|\\/|g')/g" "$TARGET_DIR/README.md"

# Update .env APP_NAME
sed -i "s/APP_NAME=antigravity-starter/APP_NAME=$PROJECT_NAME/g" "$TARGET_DIR/.env"
sed -i "s/APP_NAME=antigravity-starter/APP_NAME=$PROJECT_NAME/g" "$TARGET_DIR/.env.example"

# Add tech stack badges to README
STACK_BADGES=""
[ "$STACK_TYPE" = "api" ] || [ "$STACK_TYPE" = "monorepo" ] && STACK_BADGES="$STACK_BADGES Python FastAPI"
[ "$STACK_TYPE" = "nextjs" ] || [ "$STACK_TYPE" = "monorepo" ] && STACK_BADGES="$STACK_BADGES Next.js TypeScript"
[ "$DB_TYPE" != "none" ] && STACK_BADGES="$STACK_BADGES $DB_TYPE"
[ "$AI_PROVIDER" != "none" ] && STACK_BADGES="$STACK_BADGES AI"

# Update .env.example AI provider
if [ "$AI_PROVIDER" = "openai" ] || [ "$AI_PROVIDER" = "both" ]; then
  sed -i "s/# OPENAI_API_KEY=/OPENAI_API_KEY=/g" "$TARGET_DIR/.env.example"
fi
if [ "$AI_PROVIDER" = "gemini" ] || [ "$AI_PROVIDER" = "both" ]; then
  sed -i "s/# GEMINI_API_KEY=/GEMINI_API_KEY=/g" "$TARGET_DIR/.env.example"
fi

echo -e "  ${GREEN}✅${NC} Customized files for '$PROJECT_NAME'"

# ==========================================
# GIT INIT
# ==========================================
if [ "$INIT_GIT" = "y" ] || [ "$INIT_GIT" = "Y" ]; then
  cd "$TARGET_DIR"
  git init 2>/dev/null && echo -e "  ${GREEN}✅${NC} Git repository initialized"
  git add . 2>/dev/null
  git commit -m "Initial project setup from ANTIGRAVITY-STARTER v1.0

Generated with init-project.sh

🤖 Generated with Codebuff
Co-Authored-By: Codebuff <noreply@codebuff.com>" 2>/dev/null || true
  cd - > /dev/null
fi

# ==========================================
# RUN SETUP
# ==========================================
if [ "$RUN_SETUP" = "y" ] || [ "$RUN_SETUP" = "Y" ]; then
  cd "$TARGET_DIR"
  bash scripts/setup.sh 2>/dev/null || true
  cd - > /dev/null
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
echo "  code .                     # Open in editor"
echo "  cat README.md              # View project docs"
echo "  cat AGENTS.md              # View AI instructions"
echo ""
echo -e "${BLUE}Key files:${NC}"
echo "  .antigravity/AGENTS.md     — AI agent instructions"
echo "  .antigravity/rules/        — Development rules"
echo "  docs/architecture.md       — Architecture docs"
echo "  .env                       — Environment config"
echo ""
echo -e "${BLUE}Stack:${NC} $STACK_TYPE"
echo -e "${BLUE}Database:${NC} $DB_TYPE"
echo -e "${BLUE}AI:${NC} $AI_PROVIDER"
echo -e "${BLUE}Deployment:${NC} $DEPLOY_TYPE"
echo ""
echo -e "${YELLOW}To add an integration later:${NC}"
echo "  cp -r integrations/<name>/ <project>/integrations/"
echo "  See CONTRIBUTING.md for details"
echo ""
