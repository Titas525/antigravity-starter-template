# CORE DEVELOPMENT RULES

## Principle

Prefer simple, explicit, maintainable solutions.

## Rules

- Do not over-engineer.
- Do not duplicate logic.
- Do not create abstractions without a clear need.
- Prefer composition over inheritance.
- Keep functions focused.
- Keep modules cohesive.
- Keep business logic separate from infrastructure.

## Change Strategy

Always prefer:

SMALL SAFE CHANGE

over:

LARGE REWRITE

unless the user explicitly requests a rewrite.

## Existing Code

Before creating something new:

1. Search for existing implementation.
2. Search for reusable utilities.
3. Search for similar components.
4. Extend existing functionality when appropriate.

## Dependencies

Before adding a dependency:

- Check whether the functionality already exists.
- Check whether an existing dependency can solve the problem.
- Consider maintenance and security implications.

Do not add dependencies unnecessarily.
