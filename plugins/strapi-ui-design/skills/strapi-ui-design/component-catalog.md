# Strapi Design System v2 — Component Catalog (API Reference)

> Derived directly from the `@strapi/design-system` **v2.2.1** source
> (`packages/design-system/src/components`). This is the authoritative map of
> **what you can import and how each component is shaped** — props, compound
> sub-components, canonical usage, and gotchas. For task-oriented compositions
> (a full form, a table with selection, a CRUD page), see
> [patterns.md](patterns.md). For complete page examples, see [examples.md](examples.md).
>
> **46 components** ship from `@strapi/design-system`. Page shell primitives
> (`Page.*`, `Layouts.*`) come from `@strapi/strapi/admin`, **not** the DS — see
> the last section. When in doubt about a prop, verify against Context7
> (`/strapi/design-system`) — but this catalog is the source-of-truth snapshot.

## Quick "which component?" index

| Need | Use |
|------|-----|
| Single-line text | `TextInput` |
| Multi-line text | `Textarea` |
| Number (with stepper, locale-aware) | `NumberInput` |
| One choice from a short list | `SingleSelect` |
| One choice, searchable / creatable | `Combobox` |
| Many choices | `MultiSelect` |
| Boolean, two explicit labels (form field) | `Toggle` |
| Boolean, on/off switch (settings) | `Switch` |
| Boolean, simple checkbox / tri-state | `Checkbox` |
| Mutually-exclusive options inline | `Radio.Group` + `Radio.Item` |
| Date / time / both | `DatePicker` / `TimePicker` / `DateTimePicker` |
| JSON editing | `JSONInput` |
| **Every input above** must be wrapped in | `Field.Root` (+ `Field.Label`, `Field.Hint`, `Field.Error`) |
| Primary / secondary / destructive action | `Button` (variant) |
| Icon-only action | `IconButton` (needs `label`) |
| Link styled as a button | `LinkButton` |
| Inline text action | `TextButton` |
| Modal **form / content** | `Modal.*` |
| **Confirm / destructive** prompt | `Dialog.*` |
| Floating panel | `Popover.*` |
| Hover hint | `Tooltip` |
| Dropdown action menu | `SimpleMenu` + `MenuItem` |
| Data table | `Table` + `Thead/Tbody/Tr/Th/Td` |
| Collapsible grouping | `Accordion.*` |
| Status pill (semantic) | `Status` |
| Non-semantic label / count | `Badge` |
| Removable chip | `Tag` |
| Empty / no-results state | `EmptyStateLayout` |
| Loading spinner | `Loader` |
| Search field | `Searchbar` |
| Pagination | `Pagination` + `PageLink` etc. |
| Tabs | `Tabs.*` |
| Plugin sidebar | `SubNav*` |
| Page shell / header / RBAC gate | **`@strapi/strapi/admin`** (`Page.*`, `Layouts.*`) — not the DS |

---

## Forms & Inputs

> **Universal rule:** every input below is wrapped in `Field.Root`. The input
> reads `id`/`name`/`required`/`error` from Field context. Errors render via
> `Field.Error`, hints via `Field.Hint`. Never render a bare input.

### Field
- **Import**: `import { Field, useField } from '@strapi/design-system'`
- **Compound**: `Field.Root`, `Field.Label`, `Field.Input`, `Field.Hint`, `Field.Error`, `Field.Action`
- **Props (Root)**: `error: string | boolean` · `hint?: ReactNode` · `id?: string` (auto-gen) · `required?: boolean` · `name?: string`
- **Props (Input)**: `hasError?: boolean` · `size?: 'S' | 'M'` · `startAction?/endAction?: ReactNode`
- **Usage**:
  ```tsx
  <Field.Root name="email" error={errors.email} hint="user@domain.com" required>
    <Field.Label>Email</Field.Label>
    <TextInput value={v} onChange={(e) => set(e.target.value)} />
    <Field.Hint />
    <Field.Error />
  </Field.Root>
  ```
- **Gotchas**: `Field.Hint`/`Field.Error` read from context — they render nothing if Root has no hint/error. `Field.Label` renders null with no child.

### TextInput
- **Import**: `import { TextInput } from '@strapi/design-system'`
- **Props**: `value?: string` · `onChange?: (e) => void` · `hasError?: boolean` · `disabled?: boolean` · `id/name/required` (Field context) · all `Field.InputProps`
- **Usage**: `<TextInput type="email" value={v} onChange={(e) => set(e.target.value)} />`
- **Gotchas**: thin wrapper over `Field.Input` — effectively an alias; expects a Field parent. Use `type` for email/url/password.

### Textarea
- **Import**: `import { Textarea } from '@strapi/design-system'`
- **Props**: `value?: string` · `disabled?: boolean` · `hasError?: boolean` · `resizable?: boolean` (default true) · `id/name/required`
- **Gotchas**: integrates Field context via `useField`. Min height 10.5rem. `resizable={false}` locks the resize handle.

### NumberInput
- **Import**: `import { NumberInput } from '@strapi/design-system'`
- **Props**: `value?: number` · **`onValueChange?: (value: number | undefined) => void`** · `locale?: string` · `step?: number` (default 1) · `disabled?: boolean` · `startAction?: ReactElement`
- **Usage**: `<NumberInput value={n} onValueChange={set} step={0.5} locale="en-US" />`
- **Gotchas**: uses **`onValueChange`**, NOT `onChange`. Returns `undefined` for empty/invalid. Arrow keys step by `step`.

### SingleSelect / MultiSelect
- **Import**: `import { SingleSelect, MultiSelect, SingleSelectOption, MultiSelectOption, MultiSelectGroup } from '@strapi/design-system'`
- **Props (SingleSelect)**: `value?: string | number | null` · `onChange?: (value) => void` · `placeholder?: string` · `disabled?/hasError?/loading?` · `size?: 'S' | 'M'` · `onClear?` · `clearLabel?` · `customizeContent?: (value) => string` · `onReachEnd?`
- **Props (MultiSelect)**: as above + `value?: string[] | null` · `withTags?: boolean`
- **Props (Option)**: `value: string | number` (required) · `startIcon?: ReactNode`
- **Usage**:
  ```tsx
  <SingleSelect value={v} onChange={set} placeholder="Choose…">
    <SingleSelectOption value="cinema">Cinéma</SingleSelectOption>
  </SingleSelect>
  ```
- **Gotchas**: type is preserved — pass a number, get a number back. `withTags` renders selections as Tags. `onReachEnd` for infinite scroll.

### Combobox
- **Import**: `import { Combobox, ComboboxOption } from '@strapi/design-system'`
- **Props**: `value?: string` · `onChange?: (value) => void` · `creatable?: boolean | 'visible'` · `allowCustomValue?: boolean` · `loading?: boolean` · `onCreateOption?: (value?) => void` · `onLoadMore?` · `hasMoreItems?: boolean` · `createMessage?: (value) => string` · `noOptionsMessage?` · `size?: 'S' | 'M'`
- **Usage**:
  ```tsx
  <Combobox value={v} onChange={set} creatable onCreateOption={create}>
    <ComboboxOption value="apple">Apple</ComboboxOption>
  </Combobox>
  ```
- **Gotchas**: virtualization is automatic. `creatable='visible'` always shows the create row; `creatable={true}` only when text typed. `onLoadMore` uses an IntersectionObserver on the last item.

### Checkbox
- **Import**: `import { Checkbox } from '@strapi/design-system'`
- **Props**: `checked?: boolean | 'indeterminate'` · `defaultChecked?` · `onCheckedChange?: (checked: boolean | 'indeterminate') => void` · `disabled?` · `name?/value?` · `children?` (auto-label)
- **Usage**: `<Checkbox checked={c} onCheckedChange={set}>Remember me</Checkbox>`
- **Gotchas**: tri-state — `'indeterminate'` renders a minus (great for "select all" headers). With `children`, auto-wraps a label.

### Radio
- **Import**: `import { Radio } from '@strapi/design-system'`
- **Compound**: `Radio.Group`, `Radio.Item`
- **Usage**:
  ```tsx
  <Radio.Group value={v} onValueChange={set}>
    <Radio.Item value="a">Option A</Radio.Item>
  </Radio.Group>
  ```
- **Gotchas**: `Item` auto-renders label from children. IDs auto-generated. Radix-based.

### Toggle vs Switch (don't confuse them)
- **Toggle** — `import { Toggle } from '@strapi/design-system'` — a **form field** showing two labeled buttons (off/on). Props: **`onLabel: string` + `offLabel: string` (required)** · `checked?: boolean | null` (default null) · `hasError?` · `id/name/required` (Field context). Use inside a Field for boolean entity attributes.
- **Switch** — `import { Switch } from '@strapi/design-system'` — a sliding on/off **control** for settings. Props: `checked?` · `onCheckedChange?: (checked: boolean) => void` · `onLabel?/offLabel?` · `visibleLabels?: boolean`. Radix-based.
- **Rule of thumb**: data attribute on a record → `Toggle`; live preference/setting → `Switch`.

### DatePicker / TimePicker / DateTimePicker
- **Import**: `import { DatePicker, TimePicker, DateTimePicker } from '@strapi/design-system'`
- **DatePicker props**: `value?: Date` · `onChange?: (date: Date | undefined) => void` · `onClear?` · `minDate?/maxDate?: Date` · `size?` · `locale?` · `required?`
- **TimePicker props**: `value?: string` (`HH:mm`) · `onChange?: (value: string | undefined) => void` · `step?: number` (default 15, minutes)
- **DateTimePicker props**: `value: Date | null | undefined` · `onChange: (date: Date | undefined) => void` · `dateLabel/timeLabel: string`
- **Gotchas**: DatePicker uses `@internationalized/date` internally but the public API is a JS `Date`. TimePicker separator is locale-aware. **Project rule (Tiween): display `DD/MM/YYYY` + Western numerals even in Arabic** — set `locale` accordingly.

### JSONInput
- **Import**: `import { JSONInput } from '@strapi/design-system'`
- **Props**: `value?: string` (default '') · `onChange?: (value: string) => void` · `hasError?: boolean` · `disabled?: boolean`
- **Gotchas**: CodeMirror-based with live JSON lint. Ref exposes `.focus()`/`.scrollIntoView()`. Value is a **string**, not a parsed object.

### CarouselInput
- **Import**: `import { CarouselInput } from '@strapi/design-system'`
- **Props**: `label?: string` · `selectedSlide?: number` · `onNext?/onPrevious?` · `nextLabel?/previousLabel?` · `actions?: ReactNode` · `hint?/error?/required?`
- **Gotchas**: wraps `Carousel` in a `Field.Root`. Used for media/image slot inputs.

---

## Buttons & Actions

### Button
- **Import**: `import { Button } from '@strapi/design-system'`
- **Props**: `variant: 'default' | 'secondary' | 'tertiary' | 'success' | 'success-light' | 'danger' | 'danger-light' | 'ghost'` (default 'default') · `size: 'XS' | 'S' | 'M' | 'L'` · `loading?: boolean` · `fullWidth?: boolean` · `startIcon?/endIcon?` · `type?: 'button' | 'submit' | 'reset'`
- **Usage**: `<Button variant="default" startIcon={<Plus />}>Ajouter</Button>`
- **Gotchas**: `loading` disables the button and swaps `startIcon` for a spinner. There are **8 variants** — `danger` for destructive, `tertiary`/`ghost` for low-emphasis.

### IconButton
- **Import**: `import { IconButton } from '@strapi/design-system'`
- **Props**: **`label: string` (required, a11y)** · `size?: 'XS' | 'S' | 'M' | 'L'` · `variant?: 'primary' | 'secondary' | 'tertiary'` · `withTooltip?: boolean` (default true) · `disabled?`
- **Usage**: `<IconButton label="Modifier" onClick={edit}><Pencil /></IconButton>`
- **Gotchas**: `label` is mandatory — it's the `aria-label` AND the tooltip. `withTooltip` defaults to **true**.

### LinkButton / TextButton
- **LinkButton**: button styling, renders as a link (`tag={BaseLink}`). Inherits all `Button` props + `href`.
- **TextButton**: inline text-style action. Props: `loading?` · `startIcon?/endIcon?` · `disabled?` · `type?`. Polymorphic.

---

## Overlays & Dialogs

### Modal (forms & content)
- **Import**: `import { Modal } from '@strapi/design-system'`
- **Compound**: `Modal.Root`, `Modal.Trigger`, `Modal.Content`, `Modal.Close`, `Modal.Header`, `Modal.Title`, `Modal.Body`, `Modal.Footer`
- **Props**: `Header` → `closeLabel?: string` · `Body` extends ScrollArea (auto-scroll) · Root extends Radix Dialog
- **Usage**:
  ```tsx
  <Modal.Root>
    <Modal.Trigger><Button>Ouvrir</Button></Modal.Trigger>
    <Modal.Content>
      <Modal.Header closeLabel="Fermer"><Modal.Title>Titre</Modal.Title></Modal.Header>
      <Modal.Body>{form}</Modal.Body>
      <Modal.Footer>{actions}</Modal.Footer>
    </Modal.Content>
  </Modal.Root>
  ```
- **Gotchas**: `Modal.Header` auto-includes a Close IconButton. `Modal.Body` is a ScrollArea (handles overflow). **`ModalLayout` does NOT exist in v2** — it was removed (not just deprecated). Always use `Modal.*`.

### Dialog (confirm / destructive)
- **Import**: `import { Dialog } from '@strapi/design-system'`
- **Compound**: `Dialog.Root`, `Dialog.Trigger`, `Dialog.Content`, `Dialog.Header`, `Dialog.Body`, `Dialog.Description`, `Dialog.Footer`, `Dialog.Cancel`, `Dialog.Action`
- **Usage**:
  ```tsx
  <Dialog.Root>
    <Dialog.Trigger asChild><Button variant="danger-light">Supprimer</Button></Dialog.Trigger>
    <Dialog.Content>
      <Dialog.Header>Confirmer</Dialog.Header>
      <Dialog.Body>Action irréversible.</Dialog.Body>
      <Dialog.Footer>
        <Dialog.Cancel asChild><Button variant="tertiary">Annuler</Button></Dialog.Cancel>
        <Dialog.Action asChild><Button variant="danger">Supprimer</Button></Dialog.Action>
      </Dialog.Footer>
    </Dialog.Content>
  </Dialog.Root>
  ```
- **Gotchas**: Radix **AlertDialog**-based. `Trigger`/`Cancel`/`Action` need **`asChild`** to wrap a Button. Use Dialog for confirms; Modal for content/forms. Never `window.confirm()`.

### Popover / Tooltip
- **Popover**: `Popover.Root/Trigger/Content/Anchor/Arrow/Anchor`. `Content` props: `side?: 'top' | 'bottom'` · `align?: 'start' | 'center' | 'end'` · `sideOffset?`. Has a `Popover.ScrollArea` with `onReachEnd` for lazy lists.
- **Tooltip**: `import { Tooltip }`. Props: **`label?: ReactNode`** · `delayDuration?` (default 500ms) · `open?/defaultOpen?`. **`description` is `@deprecated` → use `label`.** Returns children unwrapped if no `label`.

---

## Data Display

### Table
- **Import**: `import { Table, Thead, Tbody, Tr, Th, Td, TFooter } from '@strapi/design-system'`
- **Compound**: `Table` (root, `footer?` prop), `Thead`, `Tbody`, `Tr`, `Th`, `Td`, `TFooter`
- **Usage**:
  ```tsx
  <Table footer={<TFooter>50 lieux</TFooter>}>
    <Thead><Tr><Th>Nom</Th><Th>Statut</Th></Tr></Thead>
    <Tbody><Tr><Td>…</Td><Td><Status variant="success">Approuvé</Status></Td></Tr></Tbody>
  </Table>
  ```
- **Gotchas**: `Th` auto-colors `neutral600`, `Td` `neutral800`. Table auto-renders horizontal scroll shadows. **`Th`'s `action` prop is `@deprecated` — pass everything as children.** For keyboard-navigable raw grids use `RawTable`.

### Accordion
- **Import**: `import { Accordion } from '@strapi/design-system'`
- **Compound**: `Accordion.Root`, `Accordion.Item`, `Accordion.Header`, `Accordion.Trigger`, `Accordion.Content`, `Accordion.Actions`
- **Props**: `size?: 'S' | 'M'` (Root) · `Trigger` → `description?: string`, `icon?: ElementType`, `caretPosition?: 'left' | 'right'`
- **Usage**:
  ```tsx
  <Accordion.Root size="S">
    <Accordion.Item value="general">
      <Accordion.Header><Accordion.Trigger description="Infos de base">Général</Accordion.Trigger></Accordion.Header>
      <Accordion.Content>{fields}</Accordion.Content>
    </Accordion.Item>
  </Accordion.Root>
  ```
- **Gotchas**: Root forces `type="single"` + `collapsible`. Each `Item` needs a unique `value`.

### Status vs Badge vs Tag (pick the right one)
- **Status** — semantic state pill. `variant: 'alternative' | 'danger' | 'neutral' | 'primary' | 'secondary' | 'success' | 'warning'` · `size: 'XS' | 'S' | 'M'`. Auto-composes `{variant}100` bg / `{variant}200` border / `{variant}600` text. **Use for record status** (pending/approved/suspended).
- **Badge** — non-semantic label/count. `variant` + `size` + optional `backgroundColor`/`textColor` + `active`. Use for tags/counts, NOT status.
- **Tag** — removable chip. `icon: ReactNode` (required) + `label?` (a11y) + `onClick`. Use for filter chips / multi-select tokens.

### Others
- **Avatar**: `Avatar.Item` (`fallback` required, `src?`, `preview?`) + `Avatar.Group`. Fixed 32px.
- **Loader**: `small?: boolean` · children visually hidden + announced (`role="alert"`).
- **ProgressBar**: `value?: number` (0–100) · `size?: 'S' | 'M'`.
- **EmptyStateLayout**: **`content: string` (required)** · `icon?` · `action?` (typically a Button) · `hasRadius?` · `shadow?`.
- **Divider**: 1px separator, horizontal only, `role="separator"`.

---

## Navigation

- **Tabs**: `Tabs.Root` (`variant?: 'regular' | 'simple'`, `hasError?: string`) / `Tabs.List` / `Tabs.Trigger` (`value` required) / `Tabs.Content` (`value` required). Radix-based.
- **SubNav** (plugin sidebar): `SubNav`, `SubNavHeader` (`label`, `searchable?`, `value?`, `onChange?`), `SubNavSections`, `SubNavSection`, `SubNavLink` (`active?`, `icon?`), `SubNavLinkSection`.
- **Breadcrumbs**: `Breadcrumbs` (`label?`) + `Crumb` (`isCurrent?`) + `CrumbLink` (`href`) + `CrumbSimpleMenu`. Dividers auto-inserted.
- **Pagination**: `Pagination` (`activePage`, `pageCount`, `label?`) + `PreviousLink` / `NextLink` / `PageLink` (`number`) / `Dots`. `PageLink` auto-sets `aria-current`.
- **Searchbar**: `name` (required) · **`onClear` (required)** · `clearLabel?` · children = visually-hidden label. ESC clears.
- **SimpleMenu** + **MenuItem**: `SimpleMenu` (`label` required = button text) wraps a Radix menu; `MenuItem` are polymorphic links by default. `onReachEnd` for lazy menus.
- **Link / BaseLink**: `Link` (`href`, `isExternal?`, `startIcon?/endIcon?`) auto-adds an external icon when `isExternal`. `BaseLink` is the unstyled base.

---

## Page shell — from `@strapi/strapi/admin`, NOT the Design System

These are the most common false-import mistakes. They are **not** exported by
`@strapi/design-system`. A model trained on old examples will reach for a DS
`Layouts` import — that will not resolve.

```tsx
import { Page, Layouts, useRBAC, useFetchClient, useNotification } from '@strapi/strapi/admin';
```

- **`Page.Main`** — top-level page wrapper (loading/error boundary). · **`Page.Title`** — document title · **`Page.Error` / `Page.NoPermissions` / `Page.Loading`** — admin-standard states · **`Page.Protect`** — permission gate (pair with `useRBAC()`).
- **`Layouts.Root` / `Layouts.Header` / `Layouts.Content` / `Layouts.Action`** — the page chrome. Prefer these over hand-rolled `<Main>` + `<Box>`.
- **`Main`** (DS) is the low-level `<main>` landmark; `Page.Main` + `Layouts.*` is the higher-level, preferred shell.

Canonical page skeleton:
```tsx
<Page.Main>
  <Page.Title>Lieux</Page.Title>
  <Layouts.Header
    title="Lieux"
    primaryAction={<Button startIcon={<Plus />}>Ajouter un lieu</Button>}
  />
  <Layouts.Content>{/* Table, EmptyStateLayout, etc. */}</Layouts.Content>
</Page.Main>
```

---

## Symbols that do NOT exist in DS v2 (verified against v2.2.1 source)

Do not emit these — they are removed/renamed and will fail to import or are deprecated:

| Symbol | Reality in v2.2.1 | Use instead |
|--------|-------------------|-------------|
| `ModalLayout`, `ModalHeader`, `ModalBody`, `ModalFooter` | **Removed** from source | `Modal.Root/Content/Header/Title/Body/Footer` |
| `Tooltip` `description` prop | `@deprecated` | `label` |
| `Th` `action` prop | `@deprecated` | pass as children |
| `Layouts` / `Page` from `@strapi/design-system` | Not exported here | import from `@strapi/strapi/admin` |
| Native `<button>/<input>/<select>/<table>` in admin | n/a | the DS component above |

> Snapshot taken from `@strapi/design-system@2.2.1`. Re-run the extraction
> (clone the repo, parse `packages/design-system/src/components`) when bumping to
> a new major/minor to keep this catalog honest.
