# GIT WORKFLOW

## Branches

Recommended:

main
develop
feature/*
fix/*
refactor/*

For small projects, main + feature branches may be sufficient.

---

## Commits

Use conventional prefixes:

feat:
fix:
refactor:
docs:
test:
chore:
perf:
security:

Examples:

feat: add AI lead scoring
fix: resolve authentication redirect
refactor: simplify webhook service
docs: update setup instructions

---

## Commit Rules

One logical change per commit.

Do not commit:

- .env
- secrets
- debug logs
- temporary files
- generated artifacts unless required

---

## Pull Requests

Every PR should explain:

- What changed
- Why
- How it was tested
- Potential risks

Keep PRs focused.

---

## Before Commit

Check:

- git diff
- git status
- secrets
- tests
- lint
- build

Never commit blindly.
