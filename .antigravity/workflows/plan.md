# PLAN WORKFLOW

Use this workflow BEFORE starting any non-trivial implementation.

## When to Create a PLAN.md

- New features
- Bug fixes
- Refactoring
- Architecture changes
- Database migrations
- API changes

## Steps

1. Create `.antigravity/templates/PLAN.md` and copy it to the project root as `PLAN.md`.
2. Fill in each section based on the current task.
3. Submit PLAN.md for review if the task is complex.
4. Only start coding after PLAN.md is approved.
5. Update PLAN.md as you go if the approach changes.
6. Mark PLAN.md as "Completed" when the task is done.
7. Archive or delete PLAN.md after completion.

## PLAN.md Structure

```
1. Goal           — one clear sentence
2. Context        — files, patterns, dependencies
3. Approach       — chosen solution + reasoning
4. Steps          — checklist of implementation steps
5. Risks          — edge cases, out-of-scope items
6. Verification   — how to confirm it works
7. Changes        — file-by-file summary table
```

## Rules

- Never start coding before PLAN.md is written (for non-trivial tasks).
- If the plan changes during implementation, update PLAN.md first.
- Keep PLAN.md concise — maximum one page.
- Delete PLAN.md when the task is complete to keep the root clean.
