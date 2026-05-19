---
description: Add a content-type to the current Strapi v5 plugin (schema + factory service/controller/router + register)
argument-hint: <singular-name>
allowed-tools: Bash, Read, Edit, Write, Glob, Grep
model: claude-sonnet-4-5
---

Add a Strapi v5 content-type named `$1` to the current plugin. Follow the strapi-plugin-dev skill.

## Steps

1. **Verify** the current directory is a Strapi plugin (`package.json` with `strapi.kind: "plugin"`, or `server/src/` + `admin/src/` present). If not, abort with a clear error.

2. **Read** the plugin name from `package.json` (`strapi.name`).

3. **Create** `server/src/content-types/$1/schema.json` using the v5 collection-type template (see strapi-plugin-dev SKILL.md "Content-Type Schema"):
   - `kind: "collectionType"`
   - `collectionName`: plural snake_case
   - `info.singularName: "$1"`, `info.pluralName`: plural of $1
   - `info.displayName`: capitalized
   - For plugin-internal types, include `pluginOptions.content-manager.visible: false`
   - Minimal `attributes` (ask the user if unclear)

4. **Create** `server/src/services/$1.ts` using `factories.createCoreService('plugin::<plugin-name>.$1', ...)` (see patterns.md "Factory-Based Service").

5. **Create** `server/src/controllers/$1.ts` using `factories.createCoreController('plugin::<plugin-name>.$1', ...)`.

6. **Create** `server/src/routes/admin/$1.ts` exporting `factories.createCoreRouter('plugin::<plugin-name>.$1')`. Wire it into `server/src/routes/admin/index.ts`.

7. **Register** the content-type in `server/src/content-types/index.ts` and `server/src/index.ts` (services, controllers).

8. **Report** every file created/modified with absolute paths.

Do NOT use `strapi.entityService`. All custom queries must go through `strapi.documents(uid)`. Defer to the strapi-plugin-dev skill for architectural decisions.
