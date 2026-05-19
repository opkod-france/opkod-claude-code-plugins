# OPKOD Claude Code Plugins

Claude Code plugin marketplace by OPKOD France.

## Setup

```bash
# 1. Add the marketplace
/plugin marketplace add opkod-france/opkod-claude-code-plugins

# 2. Update the marketplace
/plugin marketplace update opkod-marketplace

# 3. Install a plugin
/plugin install <plugin-name>@opkod-marketplace
```

Or browse with `/plugin` → Discover tab.

## Available Plugins

| Plugin | Category | Description |
|--------|----------|-------------|
| [ui-polish](#ui-polish) | Frontend | Refactoring UI methodology with Tailwind CSS and shadcn/ui |
| [strapi-plugin-dev](#strapi-plugin-dev) | Backend | Strapi v5 plugin development patterns |
| [strapi-ui-design](#strapi-ui-design) | Frontend | Strapi v5 admin UI with Design System v2 |

### ui-polish

Professional UI design principles using Tailwind CSS and shadcn/ui. Apply Refactoring UI methodology to create polished, professional interfaces.

```bash
/plugin install ui-polish@opkod-marketplace
```

**Components:**
- **Skill**: `refactoring-ui` — Refactoring UI principles for Tailwind + shadcn (hierarchy, spacing, typography, color, shadcn patterns)
- **Commands**: `/refactor <file>`, `/review <file>`
- **Agent**: `ui-reviewer` — context-isolated UI reviews for `.tsx`/`.jsx` files

### strapi-plugin-dev

Strapi v5 plugin development expert — Document Service API, factory patterns (`createCoreService`, `createCoreController`, `createCoreRouter`), React Hook Form + Zod, TanStack Query v5, Content Manager integration.

Uses **Context7** for live documentation verification against the latest Strapi v5 docs.

```bash
/plugin install strapi-plugin-dev@opkod-marketplace
```

**Components:**
- **Skill**: `strapi-plugin-dev` — router skill pointing to `patterns.md` (factory deep-dive, RHF+Zod, TanStack v5, CM injection, RBAC, polymorphic relations) and `examples.md` (end-to-end walkthroughs)
- **Commands**:
  - `/strapi-scaffold-plugin <name>` — opinionated plugin scaffold on top of `@strapi/sdk-plugin`
  - `/strapi-add-content-type <name>` — schema + factory service/controller/router + registration
  - `/strapi-add-cm-panel <name>` — Content Manager right-links injection panel
  - `/strapi-verify` — runs official verify + anti-pattern grep
- **Hooks** (auto-firing):
  - `PostToolUse` on `server/src/**/*.ts` → flags `entityService`, `strapi.query`, `Formik`, `Yup`, `react-query` v3
  - `PostToolUse` on `*/content-types/*/schema.json` → validates required fields (`kind`, `singularName`, `pluralName`, `collectionName`)
  - `UserPromptSubmit` → injects Strapi v5 context preamble when cwd is a plugin
- **Agent**: `strapi-reviewer` — auto-delegated for reviews under `server/src/` or `admin/src/`

### strapi-ui-design

Create polished, accessible Strapi v5 plugin admin interfaces using the Strapi Design System v2 exclusively. Compound components, `Page.*` + `Layouts.*` shell, tables, forms, modals, RBAC, and accessibility patterns.

Uses **Context7** for live documentation verification against the latest Design System docs.

```bash
/plugin install strapi-ui-design@opkod-marketplace
```

**Components:**
- **Skill**: `strapi-ui-design` — DS v2 component catalog (47 components + `Page.*` + `Layouts.*`), Field/data-fetching/RBAC patterns, anti-patterns
- **Commands**:
  - `/strapi-ui-component <type> [name]` — scaffold a `settings | table | form | modal | dashboard` page using DS v2 templates
  - `/strapi-ui-audit` — one-shot DS-violation report across `admin/src/**/*.tsx`
- **Hook** (auto-firing):
  - `PostToolUse` on `admin/src/**/*.tsx` → flags native HTML, `styled-components`, inline styles, hex colors, `alert()`, deprecated `ModalLayout`, path imports
- **Agent**: `strapi-ui-reviewer` — DS conformance + accessibility reviews (Field.Root wrapping, IconButton labels, Page/Layouts shell)

## Releases

Per-plugin versioning is automated via `.github/workflows/release-per-plugin.yml`.
Each push to `main` is scanned for conventional-commit scopes; matching plugins
get their `plugin.json` + marketplace entry bumped, a `<plugin>-vX.Y.Z` tag is
created, and a GitHub release is published with a scoped changelog.

**Commit message convention (required for releases):**

| Commit | Effect on `<plugin>` |
|---|---|
| `feat(<plugin>): ...` | minor bump |
| `fix(<plugin>): ...` | patch bump |
| `perf(<plugin>): ...` | patch bump |
| `refactor(<plugin>): ...` | patch bump |
| `feat(<plugin>)!: ...` or `BREAKING CHANGE:` in body | major bump |
| `docs(<plugin>): ...`, `chore(<plugin>): ...`, `test(<plugin>): ...` | no release |
| commits without a `(<plugin>)` scope | no release (use the manual `Semantic Release (repo-wide)` workflow if needed) |

The workflow's own commits use `[skip ci]` to avoid recursion. The legacy
repo-wide `release.yml` is now manual-only via `workflow_dispatch`.

### Enforcement (defense in depth)

Three layers prevent the conventions from drifting:

1. **Local git hook** (`.githooks/commit-msg`) — rejects bad messages at commit
   time, before they exist. Activate per clone with:

   ```bash
   ./.githooks/install.sh
   ```

   It enforces: known conventional type, kebab-case scope, scope-must-exist,
   scope-required-when-touching-`plugins/<name>/`, no scope mismatch, header
   ≤100 chars, no multi-plugin commits.

2. **Local pre-commit hook** (`.githooks/pre-commit`) — runs the plugin lint
   scripts (`check-strapi-server.sh`, `check-strapi-schema.sh`,
   `check-admin-tsx.sh`) against staged files so manual commits get the same
   checks Claude's PostToolUse hooks apply.

3. **CI** (`.github/workflows/commitlint.yml`) — runs `@commitlint/cli` against
   PR commits and pushes to main. Catches anyone who didn't install the local
   hook. Config in `.commitlintrc.cjs` mirrors the local rules.

4. **Release workflow degradation** — when a push produces no bumps, the
   release workflow lists every commit since the last per-plugin tag in its
   GitHub Actions summary, highlighting which ones missed a scope. Silent skips
   are visible.

## License

MIT
