# SECURITY RULES

## Secrets

Never commit secrets.

Never expose:

- API keys
- Access tokens
- Passwords
- Private keys
- Database credentials

Use environment variables.

---

## Input Validation

Validate all external input.

Treat all external input as untrusted.

This includes:

- HTTP requests
- Webhooks
- User uploads
- Query parameters
- Form data
- Third-party API responses

---

## Authentication

Authentication and authorization must be explicitly separated.

Authentication answers:

"Who are you?"

Authorization answers:

"What are you allowed to do?"

---

## Logging

Never log secrets.

Never log full authentication tokens.

Avoid logging sensitive personal data.

---

## Webhooks

Validate webhook authenticity whenever the provider supports signatures.

Implement:

- signature verification
- replay protection where appropriate
- input validation
- idempotency

---

## Dependencies

Keep dependencies updated.

Avoid known vulnerable packages.

Run security checks where available.

---

## Production

Production configuration must never rely on development defaults.

Disable debug mode in production.
