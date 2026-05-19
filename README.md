# OPKOD Claude Code Plugins

Claude Code plugin marketplace by OPKOD France. Three plugins so far: UI refactoring with Tailwind and shadcn, Strapi v5 plugin scaffolding, and Strapi admin UI design.

## Install

```bash
/plugin marketplace add opkod-france/opkod-claude-code-plugins
/plugin marketplace update opkod-marketplace
/plugin install <plugin-name>@opkod-marketplace
```

Or browse with `/plugin` and pick from the Discover tab.

## Plugins

| Plugin | What it does | Install |
|--------|--------------|---------|
| [ui-polish](#ui-polish) | Refactor and review Tailwind + shadcn UI using Refactoring UI principles | `/plugin install ui-polish@opkod-marketplace` |
| [strapi-plugin-dev](#strapi-plugin-dev) | Build Strapi v5 plugins with Document Service, factories, RHF + Zod, TanStack Query | `/plugin install strapi-plugin-dev@opkod-marketplace` |
| [strapi-ui-design](#strapi-ui-design) | Build Strapi v5 admin UI using only the Strapi Design System v2 | `/plugin install strapi-ui-design@opkod-marketplace` |

### ui-polish

For React projects using Tailwind and shadcn/ui. Spots design issues and refactors components in place.

**Usage**

```text
/refactor src/components/SignupForm.tsx
/review src/components/Pricing.tsx
```

Or just describe what you want. The `refactoring-ui` skill auto-triggers on prompts like "make this look better" or "the spacing here feels off."

**What you get**

- Skill `refactoring-ui` covers hierarchy, spacing, typography, color, shadcn patterns, and common anti-patterns
- Commands `/refactor <file>` (edits in place) and `/review <file>` (read-only audit)
- Agent `ui-reviewer` for context-isolated multi-file reviews. Skips Strapi admin code, which has its own reviewer.

### strapi-plugin-dev

For Strapi v5 plugin development. Knows Document Service API, factory patterns, route conventions, and the modern admin stack (RHF + Zod, TanStack Query v5, Content Manager injection). Verifies against the latest docs via Context7.

**Usage**

```text
/strapi-scaffold-plugin my-plugin
/strapi-add-content-type task
/strapi-add-cm-panel TodoPanel
/strapi-verify
```

You can also just ask. Inside a Strapi plugin directory, the plugin auto-injects context on every prompt so Claude reaches for the right APIs without you having to remind it.

**Automatic checks**

When you (or Claude) edit files inside a Strapi plugin, these run automatically:

- On `server/src/**/*.ts`: flags `strapi.entityService`, `strapi.query` for CRUD, Formik, Yup, `react-query` v3
- On `*/content-types/*/schema.json`: checks `kind`, `singularName`, `pluralName`, `collectionName`
- On prompt submit inside a plugin directory: injects a Strapi v5 context preamble

**Reviews**

The `strapi-reviewer` agent runs full v5-conformance reviews. Invoke it explicitly or let the general code reviewer delegate to it for files under `server/src/` or `admin/src/`.

### strapi-ui-design

Companion to `strapi-plugin-dev` for the UI half. Uses `@strapi/design-system` v2 exclusively. Covers `Page.*` and `Layouts.*` shell, Field compound API, tables, modals, RBAC, and the v2 component catalog (47 components). Verifies against live DS docs via Context7.

**Usage**

```text
/strapi-ui-component settings PluginSettings
/strapi-ui-component table TaskList
/strapi-ui-component form CreateTaskForm
/strapi-ui-component modal ConfirmDelete
/strapi-ui-component dashboard Overview
/strapi-ui-audit
```

**Automatic checks**

On every edit to `admin/src/**/*.tsx`, flags:

- Native HTML (`<button>`, `<input>`, `<select>`, `<textarea>`)
- `styled-components` imports
- Inline `style={{...}}`
- Hardcoded hex colors
- `alert()` and `window.confirm()`
- The deprecated v4 `ModalLayout` component
- Path imports like `@strapi/design-system/Button`

**Reviews**

The `strapi-ui-reviewer` agent checks DS conformance and accessibility: `Field.Root` wrapping, `IconButton` labels, `Page.Main` + `Layouts.*` shell, focus trap on modals, semantic `Status` over raw `Badge`.

## Releases

Versioning is per-plugin and automatic. Push to `main` with a conventional-commit scope, and the release workflow bumps that plugin's `plugin.json`, updates `marketplace.json`, tags it as `<plugin>-vX.Y.Z`, and publishes a GitHub release with a scoped changelog. No manual version edits.

The convention:

| Commit subject | Result |
|---|---|
| `feat(<plugin>): ...` | minor bump |
| `fix(<plugin>): ...` | patch bump |
| `perf(<plugin>): ...` | patch bump |
| `refactor(<plugin>): ...` | patch bump |
| `feat(<plugin>)!: ...` or `BREAKING CHANGE:` in body | major bump |
| `docs(<plugin>): ...`, `chore(<plugin>): ...`, `test(<plugin>): ...` | no release |
| No `(<plugin>)` scope | no release. Use the manual `Semantic Release (repo-wide)` workflow if you need a repo-level tag. |

**Examples**

```text
feat(ui-polish): add /preview command for live render
fix(strapi-plugin-dev): handle morphToMany junction lookup
refactor(strapi-ui-design)!: rename Layouts.Action to Layouts.HeaderActions
chore: bump CI Node version
```

The workflow's own release commits include `[skip ci]` so they do not retrigger.

### Enforcement

Four layers stop the convention from drifting:

1. **Local commit-msg hook** at `.githooks/commit-msg`. Rejects bad messages before they exist. Activate once per clone:

   ```bash
   ./.githooks/install.sh
   ```

   Enforces type whitelist, kebab-case scope, scope must match a real plugin or be on the small allowlist (`deps`, `release`, `marketplace`, `hooks`, `workflows`, `readme`), scope required when staged files touch `plugins/<name>/`, no multi-plugin commits, subject under 100 chars.

2. **Local pre-commit hook** at `.githooks/pre-commit`. Runs the plugin lint scripts on staged files, mirroring the PostToolUse checks Claude runs during edits.

3. **CI commitlint** at `.github/workflows/commitlint.yml`. Re-runs the same rules on every PR and push, so contributors who skipped the local install still get caught.

4. **Release workflow summary** in `release-per-plugin.yml`. When a push produces no bumps, the Actions summary lists every commit since the last per-plugin tag and flags which ones missed a scope. Silent skips stay visible.

## Contributing

```bash
git clone https://github.com/opkod-france/opkod-claude-code-plugins.git
cd opkod-claude-code-plugins
./.githooks/install.sh
```

That last step is the one easy thing to forget. The CI commitlint job will tell you if you did.

## License

MIT
