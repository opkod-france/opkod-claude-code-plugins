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

### strapi-plugin-dev

Strapi v5 plugin development expert — Document Service API, factory patterns (`createCoreService`, `createCoreController`, `createCoreRouter`), React Hook Form + Zod, TanStack Query v5, Content Manager integration, and monorepo plugin structure.

Uses **Context7** for live documentation verification against the latest Strapi v5 docs.

```bash
/plugin install strapi-plugin-dev@opkod-marketplace
```

**Covers:**
- Document Service API (replaces Entity Service from v4)
- Plugin structure, routes, controllers, services
- Content-type schemas and lifecycle hooks
- Admin panel registration and injection zones
- React Query data fetching with `useFetchClient`
- React Hook Form + Zod validation patterns
- Factory pattern deep dive and route composition

### strapi-ui-design

Create polished, accessible Strapi v5 plugin admin interfaces using the Strapi Design System v2 exclusively. Compound components, page layouts, tables, forms, modals, and accessibility patterns.

Uses **Context7** for live documentation verification against the latest Design System docs.

```bash
/plugin install strapi-ui-design@opkod-marketplace
```

**Covers:**
- 47+ Design System v2 components
- Page layouts (`Main`, `Layouts.Header`, `Layouts.Content`)
- Data tables with sorting, selection, and pagination
- Forms with `Field.Root` compound component pattern
- Modals and confirmation dialogs
- Settings pages and dashboards
- Content Manager integration panels
- Loading states, empty states, error handling

## License

MIT
