---
description: Analyze a UI component for design improvements using Refactoring UI principles
argument-hint: [file-path]
allowed-tools: Read, Glob, Grep
model: claude-haiku-4-5
---

Review the UI component at @$1 using the **refactoring-ui** skill (load it for the full criteria set: hierarchy, spacing, typography, color, shadcn patterns, anti-patterns).

For larger reviews spanning multiple files, delegate to the **ui-reviewer** sub-agent for context isolation.

## Output

Structured review:

1. **Summary** — one-sentence assessment.
2. **Strengths** — what the component does well (be specific).
3. **Issues Found** — for each:
   - Location (line number or element)
   - Problem
   - Severity (Critical / Important / Minor)
   - Suggested fix with a small code example
4. **Quick Wins** — 2–3 highest-impact changes.

Read-only — do NOT modify files.
