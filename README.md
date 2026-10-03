# OPKOD Claude Code Plugins

Claude Code plugin marketplace by OPKOD France. Two plugins so far: UI refactoring with Tailwind and shadcn, and a Strapi v5 bundle for plugin development, admin UI and testing.

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
| [strapi-skills](#strapi-skills) | Strapi v5 bundle: plugin development, admin UI with Design System v2, and testing at the right level | `/plugin install strapi-skills@opkod-marketplace` |

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

### strapi-skills

Strapi v5 plugin development, admin UI and testing, in one plugin. It replaces the former
`strapi-plugin-dev` and `strapi-ui-design` plugins and adds `strapi-plugin-testing`. It is
developed and versioned in its own repository, [ayhid/strapi-skills](https://github.com/ayhid/strapi-skills);
this marketplace lists it from there.

If you had the old plugins installed, switch over:

```bash
/plugin uninstall strapi-plugin-dev@opkod-marketplace
/plugin uninstall strapi-ui-design@opkod-marketplace
/plugin marketplace update opkod-marketplace
/plugin install strapi-skills@opkod-marketplace
```

Commands are now namespaced: `/strapi-skills:scaffold-plugin`, `/strapi-skills:verify`,
`/strapi-skills:ui-component`, `/strapi-skills:ui-audit`, and so on.

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
fix(ui-polish): keep focus ring on ghost buttons
refactor(ui-polish)!: rename /review to /audit
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
