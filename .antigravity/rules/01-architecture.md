# ARCHITECTURE RULES

## General

Use clear separation of concerns.

Recommended logical layers:

Presentation
    ↓
Application
    ↓
Domain
    ↓
Infrastructure

Do not tightly couple business logic to infrastructure.

---

## Frontend

Frontend should separate:

- UI components
- Pages/routes
- State management
- API clients
- Business logic
- Utilities

Do not place complex business logic directly inside UI components.

---

## Backend

Backend should separate:

- API routes
- Schemas
- Services
- Business logic
- Database access
- External integrations

API routes should remain thin.

Business logic belongs in services or domain modules.

---

## Integrations

External services must be isolated.

Examples:

- OpenAI
- Gemini
- Google APIs
- Telegram
- Facebook
- LinkedIn
- Email
- Payment providers

Do not spread provider-specific logic throughout the application.

---

## Database

Database access should be centralized.

Avoid direct database access from presentation layers.

---

## Configuration

Configuration should be centralized and validated at application startup.

Fail fast when required configuration is missing.
