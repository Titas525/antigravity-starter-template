#!/bin/bash
# health-check.sh — Verify project structure
# Run: ./scripts/health-check.sh

set -e

errors=0

check() {
  if [ -f "$1" ] || [ -d "$1" ]; then
    echo "  ✅ $1"
  else
    echo "  ❌ $1"
    errors=$((errors + 1))
  fi
}

echo "=== Health Check ==="
echo ""

check "README.md"
check ".env.example"
check ".gitignore"
check ".antigravity/AGENTS.md"
check ".antigravity/rules/00-core.md"
check ".antigravity/rules/01-architecture.md"
check ".antigravity/rules/02-security.md"
check ".antigravity/rules/03-git.md"
check ".antigravity/rules/04-testing.md"
check ".antigravity/rules/05-documentation.md"
check ".antigravity/workflows/feature.md"
check ".antigravity/workflows/bugfix.md"
check ".antigravity/workflows/refactor.md"
check ".antigravity/workflows/deployment.md"
check "apps/web"
check "apps/api"
check "docs/architecture.md"
check "docs/setup.md"
check "docs/deployment.md"
check ".github/workflows/ci.yml"
check ".github/pull_request_template.md"
check "integrations"
check "infrastructure"

echo ""
if [ $errors -eq 0 ]; then
  echo "✅ All checks passed!"
else
  echo "❌ $errors check(s) failed"
  exit 1
fi
