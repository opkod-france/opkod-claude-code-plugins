---
name: strapi-ui-design
description: Create polished, accessible Strapi v5 plugin admin interfaces using the Strapi Design System exclusively. Use this skill when building, revamping, or refactoring plugin admin pages including settings pages, custom panels, modals, forms, tables, and dashboards. Also invoke when the user mentions Strapi design guidelines, Layouts, LayoutHeader, LayoutContent, Main, Box, or any Strapi Design System components.
allowed-tools: Read, Grep, Glob, Edit, Write, WebFetch, mcp__context7__resolve-library-id, mcp__context7__query-docs
---

This skill guides creation of production-grade Strapi v5 plugin interfaces using the Strapi Design System v2 exclusively. Implement real working code with exceptional attention to consistency, accessibility, and Strapi's visual language.

The user provides admin interface requirements: a settings page, data table, form, modal, dashboard, or custom panel. They may include context about the plugin's purpose and user workflow.

## Live Documentation Verification (Context7)

You have access to Context7 for verifying component APIs and patterns against the latest Strapi Design System documentation.

**When to query Context7:**
- Before using a Design System component whose props you're uncertain about
- When the user asks about a component not covered in the bundled patterns
- When checking for new or renamed components in the latest DS version
- When verifying compound component slot patterns (Field.Root, Modal.Root, Dialog.Root, etc.)

**Pre-resolved library IDs (skip resolve-library-id for these):**
- `/strapi/design-system` — Strapi Design System v2 component docs
- `/strapi/documentation` — Official Strapi v5 docs (for admin hooks like `useFetchClient`, `useNotification`, `Layouts`, `Page`)

**Example queries:**
- `query-docs("/strapi/design-system", "Table component props columns rows")` — verify Table API
- `query-docs("/strapi/design-system", "Field compound component Label Hint Error")` — check Field pattern
- `query-docs("/strapi/design-system", "Modal Root Content Header Body Footer")` — verify Modal slots
- `query-docs("/strapi/documentation", "admin panel useFetchClient useNotification hooks")` — check admin hooks

**Important:** The patterns in this skill's `patterns.md` and `examples.md` are your primary reference. Use Context7 to **supplement and verify**, not as a first resort — it adds latency. Prefer the bundled patterns for common operations.

For the **exact API of an individual component** (props, compound sub-components, gotchas, and the symbols that no longer exist in v2), consult [component-catalog.md](component-catalog.md) — a reference derived directly from the `@strapi/design-system` v2.2.1 source. Reach for it before Context7 when you just need to confirm a prop name or which sub-components a compound exposes.

## Design Thinking for Strapi Admin

Before coding, understand the context and commit to a CONSISTENT Strapi experience:

- **Purpose**: What does this interface help the admin accomplish? What content or settings does it manage?
- **Workflow**: Is this a create/read/update/delete flow? A configuration page? A dashboard overview?
- **Integration**: How does this fit within Content Manager? Is it a sidebar panel, standalone page, or modal?
- **Data Density**: Is this data-heavy (tables, lists) or action-focused (forms, settings)?

**CRITICAL**: Strapi admin interfaces must feel native to Strapi. Users should not notice they're using a plugin - it should feel like a core feature. Consistency over creativity.

Then implement working code (React + TypeScript) that is:
- Built exclusively with `@strapi/design-system` components
- Accessible and keyboard-navigable
- Consistent with Strapi's visual language
- Properly integrated with React Query and Strapi admin hooks

## Strapi Design System v2 Guidelines

### Component Library (46 Components)

> Full per-component API reference: [component-catalog.md](component-catalog.md).

**Layout & Structure:**
- `Main` - Page wrapper with proper padding
- `Box` - Flexible container with spacing props
- `Flex` - Flexbox container
- `Grid.Root` / `Grid.Item` - CSS Grid layouts
- `Divider` - Visual separator
- `Card` - Elevated content container

**Page Shell (from `@strapi/strapi/admin`):**
- `Page.Main` - Top-level admin page wrapper (includes loading/error boundary)
- `Page.Title` - Sets document title (preferred over `<title>`)
- `Page.Error` - Renders the admin-standard error page
- `Page.NoPermissions` - Renders the admin-standard "no access" page
- `Page.Loading` - Renders the admin-standard loading state
- `Page.Protect` - Permission gate, pair with `useRBAC()`

**Layouts (from `@strapi/strapi/admin`):**
- `Layouts.Root` - Main layout wrapper
- `Layouts.Header` - Page header with title/subtitle/actions
- `Layouts.Content` - Main content area with proper padding
- `Layouts.Action` - Action buttons slot in the header

Prefer `Page.Main` + `Layouts.*` over hand-rolled `<Main>` + `<Box>` wrappers — they ensure consistency with Strapi's core pages.

**Typography:**
- `Typography` - Text with variant prop (alpha, beta, omega, pi, sigma, epsilon, delta)
- Use `variant="alpha"` for page titles
- Use `variant="beta"` for section headers
- Default color is `currentColor`

**Forms & Inputs:**
- `Field` - Wrapper for form controls (provides label, hint, error)
- `TextInput` - Single-line text
- `Textarea` - Multi-line text
- `NumberInput` - Numeric values
- `DatePicker` / `TimePicker` / `DateTimePicker` - Date/time selection
- `Select` - Single selection dropdown
- `Combobox` - Searchable dropdown
- `Checkbox` / `Radio` - Boolean/choice inputs
- `Toggle` / `Switch` - On/off toggles
- `JSONInput` - JSON editing

**Buttons & Actions:**
- `Button` - Primary actions (variant: default, secondary, tertiary, danger, success)
- `IconButton` - Icon-only actions
- `TextButton` - Text link-style button
- `LinkButton` - Button that navigates

**Feedback & Status:**
- `Alert` - Contextual messages (variant: default, success, warning, danger)
- `Badge` - Status indicators
- `Status` - Inline status with icon
- `Loader` - Loading spinner
- `ProgressBar` - Progress indication

**Navigation:**
- `Tabs` - Tabbed navigation
- `SubNav` - Secondary navigation
- `Breadcrumbs` - Location hierarchy
- `Link` / `BaseLink` - Navigation links
- `Pagination` - Page navigation

**Overlays & Dialogs:**
- `Modal` - Dialog windows (Root, Content, Header, Body, Footer)
- `Dialog` - Confirmation dialogs
- `Popover` - Floating content
- `Tooltip` - Hover hints

**Data Display:**
- `Table` / `Thead` / `Tbody` / `Tr` / `Td` / `Th` - Data tables
- `RawTable` - Unstyled table base
- `Accordion` - Collapsible sections
- `Avatar` - User/entity images
- `Tag` - Categorical labels
- `EmptyStateLayout` - No-data states

**Menu & Selection:**
- `SimpleMenu` - Dropdown menus
- `Searchbar` - Search input with icon

### Import Pattern

Always use root imports:

```typescript
// CORRECT
import {
  Button,
  TextInput,
  Typography,
  Box,
  Field,
  Modal,
} from '@strapi/design-system';

import { Plus, Pencil, Trash } from '@strapi/icons';

// WRONG - Never use path imports
import { Button } from '@strapi/design-system/Button';
```

### Provider Setup

```typescript
import { DesignSystemProvider } from '@strapi/design-system';

// Already provided by Strapi admin - don't wrap again in plugins
```

### Spacing & Layout

Base font-size is 62.5% (10px), so 1rem = 10px:

```tsx
<Box padding={8}>       {/* 80px padding */}
<Box paddingTop={4}>    {/* 40px padding-top */}
<Flex gap={2}>          {/* 20px gap */}
```

Common spacing values: 1, 2, 3, 4, 5, 6, 7, 8, 10 (multiply by 10 for px)

### Form Pattern with Field API

```tsx
<Field.Root name="title" error={errors.title}>
  <Field.Label>Title</Field.Label>
  <TextInput
    value={value}
    onChange={(e) => setValue(e.target.value)}
  />
  <Field.Hint>Enter a descriptive title</Field.Hint>
  <Field.Error />
</Field.Root>
```

### Data Fetching Pattern

Always use React Query with Strapi's useFetchClient:

```tsx
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, useNotification, useAPIErrorHandler } from '@strapi/strapi/admin';

const { get, post, put, del } = useFetchClient();
const { toggleNotification } = useNotification();
const { formatAPIError } = useAPIErrorHandler();
```

### Permission-Gated UI

Use `useRBAC()` for admin-side permission checks. Wrap protected routes with `Page.Protect`:

```tsx
import { useRBAC, Page } from '@strapi/strapi/admin';

const { allowedActions: { canRead, canUpdate } } = useRBAC({
  read: [{ action: 'plugin::my-plugin.read', subject: null }],
  update: [{ action: 'plugin::my-plugin.update', subject: null }],
});
```

## Anti-Patterns to Avoid

| Anti-Pattern | Correct Approach |
|--------------|------------------|
| Custom styled-components | Use Box, Flex, Grid with props |
| Inline styles (`style={{...}}`) | Use spacing/color props |
| Custom colors / hex codes | Use theme colors via props |
| Native HTML buttons | Use Button, IconButton, TextButton |
| Native HTML inputs | Use TextInput, Select, Checkbox |
| Custom modals | Use `Modal.Root` + `Modal.Content` + `Modal.Header` + `Modal.Body` + `Modal.Footer` |
| **`ModalLayout` / `ModalHeader` / `ModalBody` / `ModalFooter`** | **REMOVED** in DS v2 (absent from v2.2.1 source) — use `Modal.Root/Content/Header/Title/Body/Footer` |
| `Layouts` / `Page` from `@strapi/design-system` | Import from `@strapi/strapi/admin` — the DS does not export them |
| `Tooltip` `description` prop | **Deprecated** — use `label` |
| `Th` `action` prop | **Deprecated** — pass as children |
| `NumberInput` `onChange` | Use `onValueChange(value: number \| undefined)` |
| `alert()` or `console.*` for UX | Use `useNotification()` hook |
| `window.confirm` | Use `Dialog` component |
| Custom loading spinners | Use `Loader` component |
| Hardcoded spacing | Use spacing scale (1–10) |
| Raw `Badge` with `backgroundColor`/`textColor` | Prefer `Status` for semantic status (success/danger/warning), use `Badge` only for non-semantic tags |
| Hand-rolled `<Main>` + page header | Use `Page.Main` + `Layouts.Header` + `Layouts.Content` |

## Page Structure Template

```tsx
import { Main, Box, Typography, Button, Flex } from '@strapi/design-system';
import { Plus } from '@strapi/icons';

const MyPluginPage = () => {
  return (
    <Main>
      {/* Header */}
      <Box paddingLeft={10} paddingRight={10} paddingTop={8} paddingBottom={6}>
        <Flex justifyContent="space-between" alignItems="center">
          <Typography variant="alpha">Page Title</Typography>
          <Button startIcon={<Plus />}>Add New</Button>
        </Flex>
      </Box>

      {/* Content */}
      <Box paddingLeft={10} paddingRight={10}>
        {/* Your content here */}
      </Box>
    </Main>
  );
};
```

## Visual Consistency Rules

1. **Page titles**: Always `variant="alpha"` Typography
2. **Section headers**: Always `variant="beta"` Typography
3. **Primary actions**: `Button` (default variant)
4. **Secondary actions**: `Button variant="secondary"`
5. **Destructive actions**: `Button variant="danger"`
6. **Page padding**: `paddingLeft={10} paddingRight={10}` for main content
7. **Section spacing**: `marginBottom={6}` between sections
8. **Card padding**: `padding={6}` inside cards
9. **Form field gaps**: `gap={4}` between form fields
10. **Table actions**: `IconButton` with Tooltip

## Accessibility Requirements

- All interactive elements must be keyboard accessible
- Use `Field.Label` for all form inputs
- Provide `Field.Hint` for complex inputs
- Use `aria-label` on IconButton components
- Modal focus should trap inside when open
- Use `Status` component for dynamic status changes
- Announce loading states with `LiveRegions`

Remember: The goal is seamless integration with Strapi's admin experience. A well-designed plugin interface is invisible - it just works exactly as users expect.

For detailed component patterns, see [patterns.md](patterns.md).
For complete interface examples, see [examples.md](examples.md).
