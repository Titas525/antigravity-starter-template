# Contributing

## Development Process

1. Create a branch from `main`.
2. Implement one logical change.
3. Add tests where appropriate.
4. Run validation (`./scripts/health-check.sh`).
5. Review the diff.
6. Create a pull request.

## Commit Format

Use conventional prefixes:

```
feat:     New feature
fix:      Bug fix
refactor: Code restructuring
docs:     Documentation only
test:     Test additions or fixes
chore:    Maintenance, dependencies
security: Security fix
```

Examples:
```
feat(integrations): add Telegram webhook support
fix(ci): resolve template-validate trigger condition
docs(contributing): add integration guide
```

## Pull Requests

Include:

- **Summary** — What changed and why
- **Testing** — How it was tested
- **Risks** — Potential side effects
- **Checklist**:
  - [ ] `./scripts/health-check.sh` passes
  - [ ] No secrets committed
  - [ ] Documentation updated
  - [ ] `.env.example` updated (if new env vars)

## Code Quality

Follow the project rules in `.antigravity/`.

---

# How to Add a New Integration

This guide explains how to add a new external service integration to the
ANTIGRAVITY-STARTER template.

## Overview

Each integration lives in its own directory under `integrations/`.

Example structure after adding a new integration:

```
integrations/
├── ai/             # Existing: OpenAI + Gemini
├── google/         # Existing: Google APIs
├── telegram/       # Existing: Telegram Bot
├── webhooks/       # Existing: Webhook handlers
└── your-service/   # NEW: Your integration here
```

## Step-by-Step

### 1. Create the integration directory

```bash
mkdir -p integrations/your-service
```

### 2. Create README.md

Every integration must have a `README.md` that documents:

```markdown
# [Service Name] Integration

## Overview

Briefly describe what this integration does.

## Features

- Feature 1
- Feature 2

## Prerequisites

- Account with [Service]
- API key or access token

## Configuration

Add these variables to `.env.example`:

```env
YOUR_SERVICE_API_KEY=
YOUR_SERVICE_SECRET=
```

## Usage

Describe how to use the integration in code.

## API Reference

Document the main functions or endpoints.

## Troubleshooting

Common issues and solutions.
```

### 3. Create manifest.json (recommended)

Each integration should have a manifest that describes it:

```json
{
  "name": "integration-your-service",
  "description": "Short description of what this integration does",
  "type": "integration",
  "dependencies": [],
  "files": [
    "README.md",
    "manifest.json"
  ],
  "env_vars": [
    "YOUR_SERVICE_API_KEY",
    "YOUR_SERVICE_SECRET"
  ],
  "commands": {}
}
```

### 4. Update .env.example

Add all required environment variables to `.env.example`:

```env
# ==========================================
# [SERVICE NAME]
# ==========================================

YOUR_SERVICE_API_KEY=
YOUR_SERVICE_SECRET=
```

### 5. Create integration code (optional)

If the integration has reusable code, add it in the same directory:

```
integrations/your-service/
├── README.md           # Required
├── manifest.json       # Recommended
├── client.py           # Python client (optional)
├── client.ts           # TypeScript client (optional)
└── types.ts            # Type definitions (optional)
```

### 6. Update docs

If the integration affects architecture, update:

- `docs/architecture.md` — Add to "External Integrations" section
- `README.md` — Mention in "Tech Stack" or "Integrations" section

### 7. Test

```bash
./scripts/health-check.sh
```

---

# Rules for Integration Design

## 1. Isolation

External services must be isolated.

Do not spread provider-specific logic throughout the application.

Each integration should have its own module with:

- Configuration
- Client initialization
- Error handling
- Retry logic

## 2. Provider Abstraction

When multiple providers offer the same service (e.g., OpenAI + Gemini for AI),
create an abstraction layer:

```
integrations/ai/
├── README.md
├── client.py           ← Unified interface
├── providers/
│   ├── openai.py       ← OpenAI implementation
│   └── gemini.py       ← Gemini implementation
└── manifest.json
```

## 3. Environment Variables

- All configuration goes through `.env`
- No hardcoded API keys, tokens, or secrets
- Every new variable is added to `.env.example`
- Prefix variables with the service name: `YOUR_SERVICE_API_KEY`

## 4. Error Handling

Every integration must handle:

```python
try:
    result = await client.call()
except AuthenticationError:
    log.error("Invalid API key")
    raise
except RateLimitError:
    await asyncio.sleep(retry_after)
    return await retry()
except ServiceError as e:
    log.error(f"Service unavailable: {e}")
    return fallback()
```

## 5. Testing

- Use mocks for external services
- Test error scenarios (timeouts, auth failures, rate limits)
- Do not depend on live APIs for basic test execution

---

# CI/CD Pipeline

The template includes two CI workflows:

| Workflow | When | What |
|----------|------|------|
| `ci.yml` | Every push/PR | Structure validation, lint, manifest checks |
| `template-validate.yml` | PRs changing structure + manual | Full integrity check, structure report |

Before pushing, always run:

```bash
./scripts/health-check.sh
```
