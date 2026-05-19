---
description: Scaffold a Strapi v5 admin UI component (settings | table | form | modal | dashboard) using the Strapi Design System
argument-hint: <type> [name]
allowed-tools: Read, Edit, Write, Glob, Grep, mcp__context7__query-docs
model: claude-sonnet-4-5
---

Scaffold an admin UI component of type `$1` (one of: `settings`, `table`, `form`, `modal`, `dashboard`) named `$2`.

## Steps

1. **Validate** `$1` is one of the supported types. If not, list the valid options and stop.

2. **Locate** the template in the strapi-ui-design skill's `examples.md`:
   - `settings` → "Complete Settings Page with Tabs"
   - `table` → "Data Management Page" (table + pagination + filters)
   - `form` → forms in "Complete Plugin Walkthrough" + `patterns.md` "Forms" section
   - `modal` → `patterns.md` "Modals" section
   - `dashboard` → "Dashboard with Charts and Stats"

3. **Choose the destination path**:
   - `settings`, `dashboard`, `table` → `admin/src/pages/$2.tsx`
   - `form`, `modal` → `admin/src/components/$2.tsx`

4. **Generate the file** using ONLY `@strapi/design-system` v2 components and the `Page.Main` + `Layouts.*` shell. Use:
   - `Field.Root` for every input
   - `Modal.Root`/`Modal.Content`/`Modal.Header`/`Modal.Body`/`Modal.Footer` (NEVER `ModalLayout`)
   - `react-hook-form` + `zod` for forms
   - `@tanstack/react-query` v5 + `useFetchClient` for data
   - `useNotification` for feedback
   - `useRBAC` if the page should be permission-gated

5. **If wiring is needed** (e.g., menu link or route registration), edit `admin/src/index.tsx` to register the new page/component.

6. **Report** the file created and any registration edits.

Defer to the strapi-ui-design skill for visual decisions. Verify uncertain DS APIs against Context7 (`/strapi/design-system`).
