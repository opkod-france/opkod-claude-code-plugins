---
description: Verify the current Strapi v5 plugin (official verify + anti-pattern grep)
allowed-tools: Bash, Read, Grep, Glob
model: claude-haiku-4-5
---

Verify the Strapi v5 plugin in the current directory. Follow the strapi-plugin-dev skill.

## Steps

1. **Run** `npx @strapi/sdk-plugin@latest verify` and capture output.

2. **Grep for anti-patterns** across `server/src/**/*.{ts,tsx}` and `admin/src/**/*.{ts,tsx}`:
   - `strapi.entityService` (should be `strapi.documents`)
   - `strapi.query` (escape hatch only)
   - `from 'formik'` (should be `react-hook-form`)
   - `from 'yup'` (should be `zod`)
   - `from 'react-query'` (should be `@tanstack/react-query` v5)
   - Native `<button>`, `<input>`, `<select>` in `admin/src/**/*.tsx` (should be DS components)
   - `alert(`, `window.confirm(` (should be `useNotification` / `Dialog`)

3. **Validate** every `server/src/content-types/*/schema.json` has `kind`, `info.singularName`, `info.pluralName`, `collectionName`.

4. **Check** `package.json`:
   - `strapi.kind: "plugin"` is set
   - `@strapi/design-system` is `^2.0.0` (not an `-rc` version)
   - `peerDependencies.react` does NOT include `^17`
   - `@tanstack/react-query` is v5

## Output

Structured report:
- ✅ Passes
- ⚠️  Warnings (anti-patterns, file references with line numbers)
- ❌ Errors (from `verify` or missing required fields)
- Suggested follow-up commands

Read-only — do NOT edit files.
