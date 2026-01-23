---
description: Analyze a UI component for design improvements using Refactoring UI principles
argument-hint: [file-path]
allowed-tools: Read, Glob, Grep
---

Review the UI component at @$1 using Refactoring UI principles and the refactoring-ui skill.

Analyze the component against these design principles:

## 1. Visual Hierarchy
- Are there multiple competing primary actions?
- Is there clear distinction between primary, secondary, and tertiary elements?
- Are labels de-emphasized when the value/format is self-evident?
- Are icons balanced with text (softer colors for heavy elements)?

## 2. Spacing & Layout
- Is whitespace generous and intentional?
- Are related elements grouped with tighter spacing than unrelated ones?
- Is fixed vs fluid width used appropriately (sidebars fixed, content fluid)?
- Does content have appropriate max-width constraints?

## 3. Typography
- Is there clear type hierarchy (size, weight, color)?
- Are font weights in usable range (400-700)?
- Is line-height appropriate for the font size?

## 4. Color Usage
- Is grey text avoided on colored backgrounds?
- Are same-hue shades used for secondary text on colored backgrounds?
- Is color used purposefully (not decoratively)?

## 5. shadcn/ui Patterns (if applicable)
- Are correct Button variants used for the action hierarchy?
- Are form inputs paired with Labels?
- Are components composed correctly (Card with Header/Content/Footer)?

## 6. Anti-Patterns Check
- Arbitrary Tailwind values like `w-[423px]` instead of scale values
- Multiple primary buttons in one section
- Missing Labels on form inputs
- Overriding shadcn styles instead of using variants
- Inconsistent spacing (no `space-y-*` or `gap-*`)

## Output Format

Provide a structured review with:

1. **Summary**: One-sentence assessment of the component's current state
2. **Strengths**: What the component does well (be specific)
3. **Issues Found**: List each issue with:
   - Location (line number or element description)
   - Problem description
   - Severity (Critical / Important / Minor)
   - Suggested fix with code example
4. **Quick Wins**: 2-3 highest-impact changes that would improve the design most

Do NOT modify any files. This is a read-only review.
