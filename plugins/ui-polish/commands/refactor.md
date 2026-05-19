---
description: Refactor a UI component applying Refactoring UI design principles
argument-hint: [file-path]
allowed-tools: Read, Edit, Glob, Grep
model: claude-sonnet-4-5
---

Refactor the UI component at @$1 using the **refactoring-ui** skill (load it for full criteria, anti-patterns, and component patterns).

## Process

1. Read the component and understand its purpose.
2. Apply Refactoring UI priorities from the skill:
   - **High**: button hierarchy, missing form labels, arbitrary Tailwind values, grey-on-color text.
   - **Medium**: spacing consistency (`space-y-*`, `gap-*`), text color hierarchy, max-width.
   - **Low**: de-emphasis, icon balance, polish.
3. Preserve all logic — only modify styling and layout.

## Output

After editing:
- 2–4 bullets summarizing key changes.
- Trade-offs that need user review.
- Anything you couldn't fix due to missing context.

Focus on high-impact changes. A few meaningful improvements beat many minor tweaks. Read-only refactoring of styling — do NOT create new files.
