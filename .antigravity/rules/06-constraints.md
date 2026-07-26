# CONSTRAINTS

Hard rules that must never be violated.

---

## 1. SECURITY

- Never commit secrets, API keys, tokens, passwords, or private credentials.
- Never log secrets or authentication tokens.
- Never expose internal stack traces to end users.
- Always validate and sanitize all external input.
- Never use `eval()` or similar dynamic code execution on untrusted input.

---

## 2. DATABASE

- Never use raw SQL strings. Always use an ORM or query builder.
- Never delete data without a backup or soft-delete mechanism.
- Always use parameterized queries. Never interpolate values into SQL strings.
- All schema changes must be done through migrations, never manual DDL.

---

## 3. API

- Always validate request bodies with a schema (Pydantic, Zod, etc.).
- Never return raw database models directly. Always use response schemas.
- Always set reasonable rate limits on public endpoints.
- Never trust client-supplied IDs for authorization — always verify ownership.

---

## 4. FRONTEND

- Never expose API keys or secrets in client-side code.
- Never disable Content Security Policy headers.
- Always sanitize user-generated content before rendering.
- Never store sensitive data in localStorage without encryption.

---

## 5. INFRASTRUCTURE

- Never hardcode environment-specific values (URLs, ports, credentials).
- Always use environment variables for configuration.
- Never run containers as root in production.
- Never disable health checks or readiness probes.

---

## 6. DEPENDENCIES

- Never pin dependencies to exact versions without a reason (use ranges).
- Never add a dependency if the same functionality exists in the standard library.
- Never use deprecated or unmaintained packages.
- Never introduce circular dependencies between modules.

---

## 7. TESTING

- Never mock what you don't own (external libraries, stdlib).
- Never skip tests because "it works on my machine."
- Never commit commented-out tests or test code.
- Never depend on live external APIs in unit tests.

---

## 8. GIT

- Never force-push to shared branches (`main`, `develop`).
- Never commit generated files, IDE config, or OS metadata.
- Never commit large binary files (>10 MB).
- Never commit with a message that doesn't explain *why*.

---

## 9. AI / LLM

- Never treat AI output as authoritative — always validate.
- Never expose AI prompts or system instructions to end users.
- Never use AI to generate security-critical code without human review.
- Never store raw AI responses in production databases.

---

## 10. GENERAL

- Never catch exceptions without logging them first.
- Never ignore linter warnings or type errors.
- Never disable TypeScript's `strict` mode or Python's type hints.
- Never deploy on a Friday afternoon.
