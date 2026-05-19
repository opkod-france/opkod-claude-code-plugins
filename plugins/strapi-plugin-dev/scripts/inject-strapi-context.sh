#!/usr/bin/env bash
# UserPromptSubmit hook: if the cwd looks like a Strapi v5 plugin, prepend a
# short context preamble so Claude reaches for the right APIs without the user
# having to spell "Strapi" in every prompt.
set -euo pipefail

# Drain stdin so the parent doesn't block.
cat >/dev/null || true

cwd="$(pwd)"

is_strapi_plugin=0

# Heuristic 1: package.json declares strapi.kind = "plugin"
if [[ -f "$cwd/package.json" ]] && grep -qE '"kind"[[:space:]]*:[[:space:]]*"plugin"' "$cwd/package.json"; then
  is_strapi_plugin=1
fi

# Heuristic 2: classic plugin entry files at the root
if [[ -f "$cwd/strapi-server.js" || -f "$cwd/strapi-admin.js" ]]; then
  is_strapi_plugin=1
fi

# Heuristic 3: server/src and admin/src co-exist
if [[ -d "$cwd/server/src" && -d "$cwd/admin/src" ]]; then
  is_strapi_plugin=1
fi

if [[ $is_strapi_plugin -eq 0 ]]; then
  exit 0
fi

cat <<'EOF'
[strapi-plugin-dev] Detected Strapi v5 plugin context. When editing:
• Server: use `strapi.documents(uid)` (Document Service API), not `entityService` or `query`.
• Admin: use `@strapi/design-system` v2 compound components, `react-hook-form` + `zod`, and `@tanstack/react-query` v5.
• Load the strapi-plugin-dev and strapi-ui-design skills as needed for full patterns.
EOF
