---
description: Audit a Strapi v5 plugin's admin/src/ for Design System v2 violations
allowed-tools: Read, Grep, Glob, Bash
model: claude-haiku-4-5
---

Audit `admin/src/**/*.{tsx,jsx}` in the current plugin for Strapi Design System v2 violations. Follow the strapi-ui-design skill.

## Checks

For each file under `admin/src/`, flag:

1. **Native HTML** — `<button>`, `<input>`, `<select>`, `<textarea>` → should be DS components.
2. **`styled-components`** imports → should use `Box`/`Flex`/`Grid` props.
3. **Inline `style={{...}}`** → should use DS spacing/color props.
4. **Hex color literals** (e.g. `"#fff"`, `"#1a1a1a"`) → should use theme tokens.
5. **`alert()` / `window.confirm()`** → should use `useNotification` / `Dialog`.
6. **`ModalLayout`** (deprecated v4 API) → should use `Modal.Root` compound API.
7. **Path imports** from `@strapi/design-system/Button` etc. → should use root imports.
8. **Missing `Field.Root` wrapper** around standalone `TextInput`/`Select`/etc.
9. **`IconButton` without `label`** prop (accessibility).
10. **Hand-rolled `<Main>` + `<Box>` page header** when `Page.Main` + `Layouts.Header` is canonical.

## Output

```
## Strapi UI Audit

Files scanned: <n>

### Violations
- <file>:<line> — <issue> — Severity: HIGH|MED|LOW
  Fix: <one-line suggestion>

### Summary
- <n> HIGH, <n> MED, <n> LOW
- Recommended next: `/strapi-ui-component <type>` to scaffold replacements, or invoke the strapi-ui-reviewer agent for per-file rewrites.
```

Read-only — do NOT edit files.
