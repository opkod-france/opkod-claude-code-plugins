#!/usr/bin/env bash
# PostToolUse hook: flag Strapi v5 anti-patterns in server/src/**/*.ts files.
# Silent on the happy path; emits a single concise warning when problems found.
set -euo pipefail

payload="$(cat)"

file_path="$(printf '%s' "$payload" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"
[[ -z "$file_path" ]] && exit 0
[[ "$file_path" != *"/server/src/"*".ts" ]] && exit 0
[[ ! -f "$file_path" ]] && exit 0

issues=()

if grep -qE '\bstrapi\.entityService\b' "$file_path"; then
  issues+=("• \`strapi.entityService\` is deprecated in v5 — use \`strapi.documents(uid)\` (see strapi-plugin-dev SKILL.md Document Service section)")
fi

if grep -qE '\bstrapi\.query\b' "$file_path"; then
  issues+=("• \`strapi.query()\` is a low-level escape hatch — prefer \`strapi.documents()\` for CRUD")
fi

if grep -qE "from ['\"]formik['\"]" "$file_path"; then
  issues+=("• Formik detected — Strapi v5 plugins should use \`react-hook-form\` + \`zod\`")
fi

if grep -qE "from ['\"]yup['\"]" "$file_path"; then
  issues+=("• Yup detected — Strapi v5 plugins should use \`zod\` (type-safe, smaller bundle)")
fi

if grep -qE "from ['\"]react-query['\"]" "$file_path"; then
  issues+=("• \`react-query\` v3 detected — Strapi v5 plugins should use \`@tanstack/react-query\` v5")
fi

if [[ ${#issues[@]} -eq 0 ]]; then
  exit 0
fi

{
  echo "[strapi-plugin-dev] Detected Strapi v5 anti-patterns in $(basename "$file_path"):"
  printf '%s\n' "${issues[@]}"
} >&2

exit 2
