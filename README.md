# ANTIGRAVITY-STARTER

> **v1.0 — CORE** — Universal modular project template.
> AI agent instructions, development rules, Git workflow, CI/CD, integrations framework.

## Overview

Central template for all ANTIGRAVITY projects. Every new project starts from here.

## Project Structure

```text
.antigravity/     ← AI agent OS (AGENTS.md, rules, workflows)
apps/             ← Application code (web/ + api/)
packages/         ← Shared packages (shared, types, config, ui)
database/         ← Migrations and seeds
integrations/     ← External service integrations (AI, Google, Telegram, webhooks)
infrastructure/   ← Docker, GitHub configs
docs/             ← Documentation
scripts/          ← Utility scripts (init-project, setup, health-check)
.github/          ← CI, issue templates, PR templates
```

## Roadmap

```
v1.0 — CORE        ✅ AI rules, Git, Security, Testing, Docs, CI/CD
v1.1 — TECH STACK  ⏳ Next.js, FastAPI, PostgreSQL, Docker, GitHub Actions
v1.2 — AI          ⏳ OpenAI, Gemini, LLM abstraction, prompt management
v1.3 — INTEGRATIONS ⏳ Google APIs, Telegram, Webhooks, n8n, Make
v2.0 — GENERATOR   ⏳ Project type selection → automated scaffolding
```

## Quick Start

```bash
# Use this template from GitHub → "Use this template" button
# Or clone and init locally:
./scripts/init-project.sh
# Or quick:
./scripts/init-project.sh --quick my-project
```

## Project Types (v2.0 vision)

Each new project selects a type, and the template generates the appropriate structure:

- **SaaS** — Next.js + FastAPI + PostgreSQL + Stripe
- **AI SaaS** — + OpenAI/Gemini
- **Lead Generation** — + LinkedIn + Google Sheets
- **Data Platform** — + PostgreSQL/PostGIS + Analytics
- **Automation** — + n8n + Webhooks

---

*See CONTRIBUTING.md for adding integrations.*
*See .antigravity/ for AI agent instructions.*
