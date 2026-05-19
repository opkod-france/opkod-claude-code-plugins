---
name: strapi-plugin-dev
description: Strapi v5 plugin development expert. Use for building, refactoring, or revamping plugins, custom APIs, admin panel extensions, Document Service API usage, content-type creation, and plugin architecture. Invoke when working with Strapi v5 plugin development, troubleshooting plugin issues, implementing Strapi best practices, or following Strapi plugin design guidelines. Also use when the user mentions Strapi-specific terms like content-types, controllers, services, routes, plugin structure, strapi-server.js, strapi-admin.js, register/bootstrap, factory patterns, or injection zones.
allowed-tools: Read, Grep, Glob, Edit, Write, Bash, WebFetch, mcp__context7__resolve-library-id, mcp__context7__query-docs
---

# Strapi v5 Plugin Development

You are an expert Strapi v5 developer specializing in plugin development, custom APIs, and admin panel extensions. Write production-grade code following official conventions.

> **Strapi v5 requires Node 18 or 20 (LTS).** Strapi admin runs React 18.

## Routing

This skill is a router. The detailed patterns live in two companion files — load only the section you need:

| Need | Open |
|---|---|
| Factory pattern, lifecycle hooks, middleware, custom fields, RBAC, polymorphic relations, monorepo, advanced TS, React Query deep dive, RHF + Zod | **[patterns.md](patterns.md)** |
| Full end-to-end plugin walkthroughs (Bookmarks, Todo, Settings, Import/Export) | **[examples.md](examples.md)** |
| Live, up-to-date API verification | **Context7** (see next section) |

## Live Documentation Verification (Context7)

Use Context7 to verify patterns against the latest Strapi documentation.

**Pre-resolved library IDs** (skip `resolve-library-id`):
- `/strapi/documentation` — Official Strapi v5 docs (Context7 resolves to the latest available version)
- `/strapi/design-system` — Strapi Design System v2 component docs

**When to query:**
- Before generating code for APIs you're uncertain about
- When the user mentions a Strapi feature not covered by bundled patterns
- When troubleshooting version-specific issues

**Example queries:**
- `query-docs("/strapi/documentation", "Document Service API findMany filters populate")`
- `query-docs("/strapi/documentation", "plugin development server routes controllers")`
- `query-docs("/strapi/documentation", "content-type schema attributes")`
- `query-docs("/strapi/design-system", "Modal compound component API")`

The bundled `patterns.md`/`examples.md` are your **primary** reference. Context7 supplements and verifies — it adds latency, so don't first-resort it.

## Core Mandate: Document Service API First

In Strapi v5, **always use the Document Service API** (`strapi.documents`). Entity Service from v4 is deprecated.

| Operation | Document Service (v5) | Deprecated (v4) |
|-----------|----------------------|-----------------|
| Find many | `strapi.documents(uid).findMany()` | `strapi.entityService.findMany()` |
| Find one  | `strapi.documents(uid).findOne({ documentId })` | `strapi.entityService.findOne()` |
| Create    | `strapi.documents(uid).create({ data })` | `strapi.entityService.create()` |
| Update    | `strapi.documents(uid).update({ documentId, data })` | `strapi.entityService.update()` |
| Delete    | `strapi.documents(uid).delete({ documentId })` | `strapi.entityService.delete()` |
| Publish   | `strapi.documents(uid).publish({ documentId })` | N/A |
| Unpublish | `strapi.documents(uid).unpublish({ documentId })` | N/A |

```typescript
const articles = await strapi.documents('api::article.article').findMany({
  filters: { publishedAt: { $notNull: true } },
  populate: ['author', 'categories'],
  locale: 'en',
  status: 'published',
});
```

> `strapi.db.query(...)` remains valid only as a **low-level escape hatch** for polymorphic junction tables and similar advanced cases. Prefer Document Service for everything else.

## Plugin Structure (canonical layout)

```
my-plugin/
├── package.json              # strapi.kind: "plugin"
├── strapi-server.js          # Server entry
├── strapi-admin.js           # Admin entry
├── server/src/
│   ├── index.ts              # Main server export
│   ├── register.ts | bootstrap.ts | destroy.ts
│   ├── config/index.ts
│   ├── content-types/<type>/schema.json
│   ├── controllers/index.ts
│   ├── routes/index.ts       # split admin/ + content-api/
│   ├── services/index.ts
│   ├── policies/index.ts
│   └── middlewares/index.ts
└── admin/src/
    ├── index.tsx
    ├── pluginId.ts
    ├── pages/
    ├── components/
    └── translations/
```

For factory-based service/controller/router, modern `package.json` exports, server index aggregator, and the full reference layout from `@strapi-community/plugin-todo`, see **[patterns.md → Plugin Architecture](patterns.md)**.

## Content-Type UID Format

| Type | Format | Example |
|------|--------|---------|
| API content-type | `api::singular.singular` | `api::article.article` |
| Plugin content-type | `plugin::plugin-name.type` | `plugin::my-plugin.item` |
| User | `plugin::users-permissions.user` | — |

## Common Anti-Patterns

| Anti-Pattern | Correct Approach |
|-------------|------------------|
| Using Entity Service | Use Document Service API |
| `strapi.query()` for CRUD | Use `strapi.documents()` (db.query only for polymorphic junctions) |
| Hardcoded UIDs in controllers | Use constants or config |
| No error handling | Wrap in try-catch, use `ctx.throw()` |
| Skipping policies | Always implement authorization |
| **Formik** for forms | Use **React Hook Form** + **Zod** |
| **Yup** for validation | Use **Zod** (type-safe, smaller bundle) |
| **`react-query` v3** | Use **`@tanstack/react-query` v5** |
| Manual `useState` for forms | Use `useForm()` |
| Own `QueryClientProvider` at admin root | Strapi admin provides one — only add when injecting CM panels |
| Native HTML buttons / inputs in admin | Use `@strapi/design-system` v2 compound components |
| `alert()` / `window.confirm` | Use `useNotification()` / `Dialog` |

The companion **strapi-ui-design** skill enforces the admin UI half — use it together with this one when working under `admin/src/`.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Plugin not loading | Check `package.json` has `strapi.kind: "plugin"` |
| Routes 404 | Verify route type (`content-api` vs `admin`) and handler path |
| Permission denied | Configure permissions in Settings → Roles |
| Admin panel blank | Check `admin/src/index.tsx` exports and React errors |
| TypeScript errors | Run `strapi ts:generate-types` |
| Build failures | Run `npm run build` in plugin, check for import errors |

## Development Commands

```bash
# Scaffold a new plugin
npx @strapi/sdk-plugin@latest init my-plugin

# Build / watch / link
cd my-plugin && npm run build
npm run watch
npm run watch:link

# Verify plugin structure
npx @strapi/sdk-plugin@latest verify
```

> Companion slash commands: `/strapi-scaffold-plugin <name>`, `/strapi-add-content-type <name>`, `/strapi-add-cm-panel <ct>` wrap these workflows.

## Best Practices Checklist

**Server**
- [ ] `factories.createCoreService()` for standard CRUD
- [ ] `factories.createCoreController()` with custom methods
- [ ] `factories.createCoreRouter()` for automatic CRUD routes
- [ ] Routes split into `admin/` and `content-api/` directories
- [ ] Internal content types hidden from CM (`pluginOptions.content-manager.visible: false`)

**Admin Panel**
- [ ] `@tanstack/react-query` **v5** for data fetching
- [ ] `react-hook-form` + `zod` for forms and validation
- [ ] `useFetchClient()` / `getFetchClient()` for API calls
- [ ] `unstable_useContentManagerContext()` for current entity info (re-check status each Strapi minor)
- [ ] `injectComponent()` or `addEditViewSidePanel()` for CM integration
- [ ] Strapi Design System v2 compound components (`Field.Root`, `Modal.Root`, `Dialog.Root`)
- [ ] `registerTrads()` for i18n
- [ ] `useRBAC()` and `Page.Protect` for permissions

**Content Types**
- [ ] `morphToMany` for polymorphic relations
- [ ] Singular names (`task` not `tasks`)

---

For factory-pattern code, modern `package.json` exports, lifecycle hooks, CM injection, polymorphic relations, RHF+Zod recipes, TanStack Query v5 patterns, RBAC, the full DS v2 component catalog, and the monorepo (PluginPal) setup → **[patterns.md](patterns.md)**.

For complete end-to-end plugin walkthroughs → **[examples.md](examples.md)**.
