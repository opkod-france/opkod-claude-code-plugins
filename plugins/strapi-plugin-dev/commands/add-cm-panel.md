---
description: Add a Content Manager injection panel (right-links sidebar) to the current Strapi v5 plugin
argument-hint: <panel-name>
allowed-tools: Read, Edit, Write, Glob, Grep
model: claude-sonnet-4-5
---

Add a Content Manager injection panel named `$1` to the current Strapi v5 plugin. Follow the strapi-plugin-dev skill.

## Steps

1. **Verify** this is a Strapi plugin and that `admin/src/` exists.

2. **Create** `admin/src/components/$1.tsx` implementing the QueryClient + `unstable_useContentManagerContext()` pattern from `patterns.md`. The panel must:
   - Wrap its content in its own `QueryClientProvider` (CM injection points are outside Strapi admin's root QueryClient).
   - Use `useFetchClient()` for API calls.
   - Use only `@strapi/design-system` v2 compound components.
   - Use `react-hook-form` + `zod` for any forms.

3. **Register** the panel in `admin/src/index.ts` (or `.tsx`) via:
   ```ts
   app.getPlugin('content-manager').injectComponent('editView', 'right-links', {
     name: '$1',
     Component: $1,
   });
   ```
   Use `bootstrap()` (not `register()`) since the content-manager plugin loads after register.

4. **Verify** the panel disables interactions while `id` from `useContentManagerContext()` is undefined (the entity hasn't been saved yet).

5. **Report** every file modified.

The companion **strapi-ui-design** skill governs the visual design — load it for any non-trivial layout work.
