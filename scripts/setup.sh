#!/bin/bash
# setup.sh — Project initialization script
# Run: ./scripts/setup.sh

set -e

echo "=== Project Setup ==="
echo ""

# Environment
if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi

# Git
if [ ! -d .git ]; then
  git init
  echo "Initialized Git repository"
fi

echo ""
echo "=== Setup Complete ==="
echo "Next steps:"
echo "  1. Edit .env with your configuration"
echo "  2. Install dependencies"
echo "  3. Start developing"
