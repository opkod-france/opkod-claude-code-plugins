#!/usr/bin/env bash
# PostToolUse hook: flag DS v2 anti-patterns in admin/src/**/*.tsx files.
set -euo pipefail

payload="$(cat)"

file_path="$(printf '%s' "$payload" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)"
[[ -z "$file_path" ]] && exit 0
[[ "$file_path" != *"/admin/src/"*".tsx" && "$file_path" != *"/admin/src/"*".jsx" ]] && exit 0
[[ ! -f "$file_path" ]] && exit 0

issues=()

# Native HTML interactive elements
if grep -qE '<(button|input|select|textarea)(\s|>)' "$file_path"; then
  issues+=("• Native HTML \`<button>/<input>/<select>/<textarea>\` — use Strapi DS v2 components (Button, TextInput, Select, Textarea)")
fi

# styled-components
if grep -qE "from ['\"]styled-components['\"]" "$file_path"; then
  issues+=("• \`styled-components\` import — use \`Box\`, \`Flex\`, \`Grid\` with spacing/color props instead")
fi

# alert / window.confirm
if grep -qE '\b(alert|window\.confirm)\s*\(' "$file_path"; then
  issues+=("• \`alert()\` / \`window.confirm()\` — use \`useNotification()\` or \`Dialog\` from DS v2")
fi

# Inline style props
if grep -qE 'style=\{\{' "$file_path"; then
  issues+=("• Inline \`style={{...}}\` — use DS spacing/color props on Box/Flex instead")
fi

# Hex color literals
if grep -qE "['\"]#[0-9a-fA-F]{3,8}['\"]" "$file_path"; then
  issues+=("• Hardcoded hex colors — use DS theme colors via props")
fi

# Removed v4 Modal* components (not just deprecated — absent from DS v2.2.1 source)
if grep -qE '\b(ModalLayout|ModalHeader|ModalBody|ModalFooter)\b' "$file_path"; then
  issues+=("• \`ModalLayout/ModalHeader/ModalBody/ModalFooter\` do NOT exist in DS v2 — use the \`Modal.Root/Content/Header/Title/Body/Footer\` compound API")
fi

# Layouts / Page imported from the DS instead of @strapi/strapi/admin
if grep -qE "import[^;]*\b(Layouts|Page)\b[^;]*from ['\"]@strapi/design-system['\"]" "$file_path"; then
  issues+=("• \`Layouts\`/\`Page\` are not exported by \`@strapi/design-system\` — import them from \`@strapi/strapi/admin\`")
fi

# Deprecated Tooltip `description` prop (v2.2.1: @deprecated, use label)
if grep -qE '<Tooltip[^>]*\bdescription=' "$file_path"; then
  issues+=("• \`Tooltip\` \`description\` prop is deprecated in DS v2 — use \`label\` instead")
fi

# Deprecated Th `action` prop (v2.2.1: @deprecated, pass as children)
if grep -qE '<Th[^>]*\baction=' "$file_path"; then
  issues+=("• \`Th\` \`action\` prop is deprecated in DS v2 — pass everything as children instead")
fi

# NumberInput uses onValueChange, not onChange
if grep -qE '<NumberInput[^>]*\bonChange=' "$file_path"; then
  issues+=("• \`NumberInput\` uses \`onValueChange(value: number | undefined)\`, not \`onChange\`")
fi

# Path imports from @strapi/design-system
if grep -qE "from ['\"]@strapi/design-system/[A-Za-z]" "$file_path"; then
  issues+=("• Path imports from \`@strapi/design-system/...\` — use root imports: \`from '@strapi/design-system'\`")
fi

if [[ ${#issues[@]} -eq 0 ]]; then
  exit 0
fi

{
  echo "[strapi-ui-design] DS v2 anti-patterns in $(basename "$file_path"):"
  printf '%s\n' "${issues[@]}"
} >&2

exit 2
