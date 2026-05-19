#!/usr/bin/env bash
# PostToolUse hook: validate Strapi v5 content-type schema.json files.
set -euo pipefail

payload="$(cat)"

file_path="$(printf '%s' "$payload" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"
[[ -z "$file_path" ]] && exit 0
[[ "$file_path" != *"/server/src/content-types/"*"/schema.json" ]] && exit 0
[[ ! -f "$file_path" ]] && exit 0

issues=()

if ! grep -q '"kind"' "$file_path"; then
  issues+=("• Missing required \`kind\` field (\"collectionType\" or \"singleType\")")
fi

if ! grep -q '"singularName"' "$file_path"; then
  issues+=("• Missing \`info.singularName\` — must be lowercase singular (e.g. \"task\" not \"tasks\")")
fi

if ! grep -q '"pluralName"' "$file_path"; then
  issues+=("• Missing \`info.pluralName\` — must be lowercase plural")
fi

if ! grep -q '"collectionName"' "$file_path"; then
  issues+=("• Missing \`collectionName\` (database table name)")
fi

# Internal plugin content types should be hidden from CM UI.
if [[ "$file_path" == *"/server/src/content-types/"* ]] && ! grep -q '"content-manager"' "$file_path"; then
  issues+=("• Plugin-internal content type? Consider \`pluginOptions.content-manager.visible: false\` if it shouldn't appear in the Content Manager UI")
fi

if [[ ${#issues[@]} -eq 0 ]]; then
  exit 0
fi

{
  echo "[strapi-plugin-dev] schema.json review for $(basename "$(dirname "$file_path")"):"
  printf '%s\n' "${issues[@]}"
} >&2

exit 2
