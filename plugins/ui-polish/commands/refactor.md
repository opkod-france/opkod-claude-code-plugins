---
description: Refactor a UI component applying Refactoring UI design principles
argument-hint: [file-path]
allowed-tools: Read, Edit, Write, Glob, Grep
---

Refactor the UI component at @$1 applying Refactoring UI principles and the refactoring-ui skill.

## Refactoring Process

1. **Read and Understand**: First, read the component to understand its purpose and current implementation.

2. **Identify Improvements**: Look for these common issues:
   - Poor visual hierarchy (everything competing for attention)
   - Inconsistent or inadequate spacing
   - Incorrect button variant usage
   - Missing form labels
   - Arbitrary Tailwind values instead of scale
   - Grey text on colored backgrounds
   - Overridden shadcn styles

3. **Apply Changes**: Make targeted improvements following these priorities:

   **High Priority:**
   - Fix button hierarchy (one primary per section)
   - Add missing Labels to form inputs
   - Replace arbitrary values with Tailwind scale
   - Fix grey text on colored backgrounds

   **Medium Priority:**
   - Improve spacing consistency (use `space-y-*`, `gap-*`)
   - Establish clear text color hierarchy (gray-900, gray-600, gray-400)
   - Add appropriate max-width constraints

   **Lower Priority:**
   - De-emphasize labels when values are self-evident
   - Soften icon colors to balance with text
   - Add subtle polish (borders, shadows, rounded corners)

4. **Preserve Functionality**: Do not change component logic, state management, or data handling. Only modify styling and layout.

## Guidelines

- Use Tailwind's spacing scale, not arbitrary values
- Use shadcn/ui component variants as intended
- Prefer `text-muted-foreground` for secondary text
- Use `space-y-*` for vertical rhythm, `gap-*` for flex/grid
- Keep changes focused and minimal - don't over-engineer

## Output

After making changes:

1. Briefly explain the key changes made (2-4 bullet points)
2. Highlight any trade-offs or decisions that might need user review
3. If you couldn't improve something due to missing context, mention it

Focus on high-impact changes. A few meaningful improvements are better than many minor tweaks.
