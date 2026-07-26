# TESTING RULES

Testing priority:

1. Critical business logic
2. Authentication
3. Payments
4. Database operations
5. API endpoints
6. Integrations
7. UI

## Before declaring completion

Run when available:

- Unit tests
- Integration tests
- Type checking
- Lint
- Build

## Bug Fixes

Every significant bug fix should consider adding a regression test.

## External APIs

Use mocks for unit tests.

Do not depend on live external APIs for basic test execution.

## AI

AI output should be validated.

Tests should not assume that LLM responses are always deterministic.
