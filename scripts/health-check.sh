#!/bin/bash
# ===========================================
# health-check.sh — ANTIGRAVITY Project Doctor
# ===========================================
# Checks: structure, config, deps, git, integrations
# Inspired by RDF `rdf doctor`
#
# Usage:
#   ./scripts/health-check.sh              # Full check
#   ./scripts/health-check.sh --quick      # Quick check (structure only)
#   ./scripts/health-check.sh --fix        # Auto-fix common issues
#   ./scripts/health-check.sh --ci         # CI mode (exit on first error)
# ===========================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

MODE="full"
FIX_MODE=false
CI_MODE=false
PASS=0
FAIL=0
WARN=0
FIXES=0

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --quick) MODE="quick" ;;
    --fix)   FIX_MODE=true ;;
    --ci)    CI_MODE=true ;;
    --help)
      echo "ANTIGRAVITY Project Doctor"
      echo ""
      echo "Usage:"
      echo "  ./scripts/health-check.sh              Full check"
      echo "  ./scripts/health-check.sh --quick       Quick (structure only)"
      echo "  ./scripts/health-check.sh --fix         Auto-fix issues"
      echo "  ./scripts/health-check.sh --ci          CI mode"
      exit 0
      ;;
  esac
done

# ==========================================
# HELPERS
# ==========================================
pass_msg()  { echo -e "  ${GREEN}✅${NC} $1"; PASS=$((PASS + 1)); }
fail_msg()  { echo -e "  ${RED}❌${NC} $1"; FAIL=$((FAIL + 1)); }
warn_msg()  { echo -e "  ${YELLOW}⚠️${NC}  $1"; WARN=$((WARN + 1)); }
section()   { echo ""; echo -e "${CYAN}╔══ $1 ══╗${NC}"; }
sub()       { echo -e "  ${BLUE}→${NC} $1"; }

print_banner() {
  echo ""
  echo -e "${CYAN}╔═══════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}  ${BOLD}ANTIGRAVITY Project Doctor${NC}              ${CYAN}║${NC}"
  echo -e "${CYAN}║${NC}  Health check for your project           ${CYAN}║${NC}"
  echo -e "${CYAN}╚═══════════════════════════════════════════╝${NC}"
  echo ""
}

print_summary() {
  echo ""
  echo -e "${CYAN}╔═══════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}  ${BOLD}Summary${NC}                                  ${CYAN}║${NC}"
  echo -e "${CYAN}╚═══════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ${GREEN}Passed:${NC} $PASS"
  echo -e "  ${YELLOW}Warnings:${NC} $WARN"
  echo -e "  ${RED}Failed:${NC} $FAIL"
  if [ "$FIX_MODE" = true ]; then
    echo -e "  ${BLUE}Auto-fixed:${NC} $FIXES"
  fi
  echo ""

  if [ $FAIL -eq 0 ] && [ $WARN -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Your project is healthy.${NC}"
    return 0
  elif [ $FAIL -eq 0 ]; then
    echo -e "${YELLOW}⚠️  All critical checks pass, but review warnings.${NC}"
    return 0
  else
    echo -e "${RED}❌ $FAIL critical check(s) failed. Run --fix or fix manually.${NC}"
    if [ "$CI_MODE" = true ]; then
      exit 1
    fi
    return 1
  fi
}

# ==========================================
# 1. STRUCTURE CHECKS
# ==========================================
check_structure() {
  section "STRUCTURE"
  sub "Checking required files and directories..."

  local required_files=(
    "README.md"
    ".env.example"
    ".gitignore"
    ".editorconfig"
  )

  local required_dirs=(
    ".antigravity"
    "docs"
    "scripts"
    "packages"
  )

  local antigravity_files=(
    ".antigravity/AGENTS.md"
    ".antigravity/project-context.md"
    ".antigravity/rules/00-core.md"
    ".antigravity/rules/01-architecture.md"
    ".antigravity/rules/02-security.md"
    ".antigravity/rules/03-git.md"
    ".antigravity/rules/04-testing.md"
    ".antigravity/rules/05-documentation",
    ".antigravity/rules/06-constraints.md"
    ".antigravity/workflows/feature.md"
    ".antigravity/workflows/bugfix.md"
    ".antigravity/workflows/refactor.md"
    ".antigravity/workflows/deployment.md"
    ".antigravity/workflows/plan.md"
    ".antigravity/templates/PLAN.md"
  )

  local docs_files=(
    "docs/architecture.md"
    "docs/setup.md"
    "docs/deployment.md"
  )

  # Check files
  for f in "${required_files[@]}"; do
    if [ -f "$f" ]; then
      pass_msg "$f exists"
    else
      fail_msg "$f missing"
    fi
  done

  # Check dirs
  for d in "${required_dirs[@]}"; do
    if [ -d "$d" ]; then
      pass_msg "$d/ exists"
    else
      fail_msg "$d/ missing (run init-project.sh)"
    fi
  done

  # Check .antigravity files
  local has_antigravity=false
  for f in "${antigravity_files[@]}"; do
    if [ -f "$f" ]; then
      pass_msg "$f exists"
      has_antigravity=true
    fi
  done

  if [ "$has_antigravity" = false ]; then
    warn_msg "No .antigravity files found — project may not be initialized"
  fi

  # Check docs
  for f in "${docs_files[@]}"; do
    if [ -f "$f" ]; then
      pass_msg "$f exists"
    else
      warn_msg "$f missing — consider documenting your architecture"
    fi
  done

  # Check scripts are executable
  if [ -d "scripts" ]; then
    for script in scripts/*.sh; do
      if [ -f "$script" ]; then
        if [ -x "$script" ]; then
          pass_msg "$script is executable"
        else
          if [ "$FIX_MODE" = true ]; then
            chmod +x "$script"
            pass_msg "$script fixed (chmod +x)"
            FIXES=$((FIXES + 1))
          else
            warn_msg "$script not executable (run: chmod +x $script)"
          fi
        fi
      fi
    done
  fi

  # Check apps/ structure
  if [ -d "apps/web" ]; then
    if [ -f "apps/web/package.json" ]; then
      pass_msg "apps/web/package.json exists"
    else
      warn_msg "apps/web/ exists but no package.json"
    fi
    if [ -f "apps/web/app/layout.tsx" ]; then
      pass_msg "apps/web/app/layout.tsx exists"
    fi
  fi

  if [ -d "apps/api" ]; then
    if [ -f "apps/api/requirements.txt" ]; then
      pass_msg "apps/api/requirements.txt exists"
    else
      warn_msg "apps/api/ exists but no requirements.txt"
    fi
    if [ -f "apps/api/main.py" ]; then
      pass_msg "apps/api/main.py exists"
    fi
  fi

  # Check project.config.json
  if [ -f ".antigravity/project.config.json" ]; then
    pass_msg ".antigravity/project.config.json exists"
  else
    warn_msg "project.config.json not found — run init-project.sh or add-module.sh"
  fi
}

# ==========================================
# 2. CONFIGURATION CHECKS
# ==========================================
check_config() {
  section "CONFIGURATION"
  sub "Checking environment and configuration..."

  # .env
  if [ -f ".env" ]; then
    pass_msg ".env exists"

    # Check for required vars based on project.config.json
    if [ -f ".antigravity/project.config.json" ]; then

      # Read project config vars (we only check existence, not values)
      local has_db_url=false
      local has_auth_secret=false

      if grep -q "database_url" ".env" 2>/dev/null; then
        has_db_url=true
      fi
      if grep -q "auth_secret" ".env" 2>/dev/null || grep -q "AUTH_SECRET" ".env" 2>/dev/null; then
        has_auth_secret=true
      fi

      # Check if config mentions database
      if grep -q '"database": "postgresql"' ".antigravity/project.config.json" 2>/dev/null; then
        if [ "$has_db_url" = true ]; then
          pass_msg "DATABASE_URL configured in .env"
        else
          warn_msg "Project uses PostgreSQL but DATABASE_URL not in .env"
        fi
      fi
    fi

    # Check for placeholder values
    if grep -qi "change-me\|your-key\|sk-your" ".env" 2>/dev/null; then
      warn_msg ".env contains placeholder values — update them"
    fi
  else
    warn_msg ".env not found — copy from .env.example"
    if [ "$FIX_MODE" = true ] && [ -f ".env.example" ]; then
      cp .env.example .env
      pass_msg ".env created from .env.example"
      FIXES=$((FIXES + 1))
    fi
  fi

  # .gitignore
  if [ -f ".gitignore" ]; then
    # Check that .env is ignored
    if grep -q "^\.env$" ".gitignore" 2>/dev/null; then
      pass_msg ".env is in .gitignore"
    else
      warn_msg ".env not in .gitignore — risk of committing secrets"
    fi

    # Check that node_modules is ignored
    if grep -q "node_modules" ".gitignore" 2>/dev/null; then
      pass_msg "node_modules is in .gitignore"
    else
      warn_msg "node_modules not in .gitignore"
    fi

    # Check that venv is ignored
    if grep -q "venv\|.venv" ".gitignore" 2>/dev/null; then
      pass_msg "Python venv is in .gitignore"
    else
      warn_msg "Python virtual environment not in .gitignore"
    fi
  fi

  # .editorconfig
  if [ -f ".editorconfig" ]; then
    pass_msg ".editorconfig exists"
  fi
}

# ==========================================
# 3. DEPENDENCY CHECKS
# ==========================================
check_deps() {
  section "DEPENDENCIES"

  # Python checks
  if [ -f "apps/api/requirements.txt" ]; then
    sub "Checking Python dependencies..."
    if command -v python3 &>/dev/null; then
      pass_msg "Python 3 available"

      # Check if venv exists
      if [ -d "venv" ] || [ -d ".venv" ]; then
        pass_msg "Python virtual environment exists"
      else
        warn_msg "No Python venv found — create one with: python3 -m venv venv"
      fi

      # Check if key packages are installed
      local req_count
      req_count=$(grep -c "^[a-zA-Z]" "apps/api/requirements.txt" 2>/dev/null || echo 0)
      pass_msg "requirements.txt has $req_count packages listed"

      # Quick pip check (non-fatal if pip not available)
      if python3 -m pip list --format=columns 2>/dev/null | grep -qi "fastapi\|uvicorn" 2>/dev/null; then
        pass_msg "Core Python packages appear installed"
      else
        warn_msg "Core Python packages may not be installed (pip install -r apps/api/requirements.txt)"
      fi
    else
      warn_msg "Python 3 not found in PATH"
    fi
  fi

  # Node.js checks
  if [ -f "apps/web/package.json" ]; then
    sub "Checking Node.js dependencies..."
    if command -v node &>/dev/null; then
      pass_msg "Node.js $(node --version 2>/dev/null) available"

      if [ -d "apps/web/node_modules" ]; then
        pass_msg "node_modules exists (npm packages installed)"
      else
        if [ "$FIX_MODE" = true ]; then
          sub "Running npm install..."
          (cd apps/web && npm install --silent 2>/dev/null) && {
            pass_msg "npm install completed"
            FIXES=$((FIXES + 1))
          } || {
            warn_msg "npm install failed — check package.json"
          }
        else
          warn_msg "node_modules not found — run: cd apps/web && npm install"
        fi
      fi

      # Check key dependencies
      if [ -f "apps/web/package.json" ]; then
        pass_msg "package.json has dependencies listed"
      fi
    else
      warn_msg "Node.js not found in PATH"
    fi
  fi

  # Docker checks
  if [ -f "docker-compose.yml" ]; then
    sub "Checking Docker..."
    if command -v docker &>/dev/null; then
      pass_msg "Docker available"
      if docker info &>/dev/null; then
        pass_msg "Docker daemon is running"
      else
        warn_msg "Docker daemon not running"
      fi
    else
      warn_msg "Docker not found in PATH"
    fi
  fi

  # Git checks
  if command -v git &>/dev/null; then
    sub "Checking Git..."
    pass_msg "Git $(git --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo 'available')"

    if [ -d ".git" ]; then
      pass_msg "Git repository initialized"

      # Check remote
      local remote
      remote=$(git remote get-url origin 2>/dev/null || true)
      if [ -n "$remote" ]; then
        pass_msg "Remote origin: $remote"
      else
        warn_msg "No remote configured"
      fi

      # Check for uncommitted changes
      if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null; then
        pass_msg "Working tree is clean"
      else
        local changed
        changed=$(git status --porcelain 2>/dev/null | wc -l)
        warn_msg "$changed uncommitted file(s)"
      fi

      # Check branch name
      local branch
      branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
      if [ "$branch" = "main" ] || [ "$branch" = "master" ] || [ "$branch" = "develop" ]; then
        pass_msg "On branch: $branch"
      else
        pass_msg "On branch: $branch"
      fi
    else
      warn_msg "Not a Git repository — run: git init"
    fi
  fi
}

# ==========================================
# 4. INTEGRATION CHECKS
# ==========================================
check_integrations() {
  section "INTEGRATIONS"

  # Check for AI provider config
  if [ -f ".antigravity/project.config.json" ]; then
    local ai_provider
    ai_provider=$(grep -oP '"ai":\s*"\K[^"]+' ".antigravity/project.config.json" 2>/dev/null || echo "none")

    case "$ai_provider" in
      openai|both)
        if grep -q "OPENAI_API_KEY" ".env" 2>/dev/null; then
          pass_msg "OpenAI API key configured"
        else
          warn_msg "OpenAI selected but OPENAI_API_KEY not in .env"
        fi
        ;;
      gemini|both)
        if grep -q "GEMINI_API_KEY" ".env" 2>/dev/null; then
          pass_msg "Gemini API key configured"
        else
          warn_msg "Gemini selected but GEMINI_API_KEY not in .env"
        fi
        ;;
    esac
  fi

  # Check for integrations/ directories
  if [ -d "integrations" ]; then
    local has_integration=false
    for dir in integrations/*/; do
      if [ -d "$dir" ]; then
        local name
        name=$(basename "$dir")
        pass_msg "Integration: $name/"
        has_integration=true
      fi
    done
    if [ "$has_integration" = false ]; then
      warn_msg "integrations/ directory is empty"
    fi
  fi

  # Check for infrastructure/
  if [ -d "infrastructure" ]; then
    for dir in infrastructure/*/; do
      if [ -d "$dir" ]; then
        local name
        name=$(basename "$dir")
        pass_msg "Infrastructure: $name/"
      fi
    done
  fi

  # Check .github
  if [ -d ".github/workflows" ]; then
    if [ -f ".github/workflows/ci.yml" ]; then
      pass_msg "CI workflow configured"
    fi
  fi
}

# ==========================================
# MAIN
# ==========================================
print_banner

check_structure

if [ "$MODE" != "quick" ]; then
  check_config
  check_deps
  check_integrations
fi

print_summary
