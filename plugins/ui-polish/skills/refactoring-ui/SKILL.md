---
name: refactoring-ui
description: Professional UI design principles using Tailwind CSS and shadcn/ui. Use this skill when creating web interfaces, React components, HTML layouts, landing pages, dashboards, or any visual UI work. Applies Refactoring UI principles via Tailwind utilities and shadcn components for polished, professional designs. Triggers when building UI components, styling interfaces, creating layouts, designing forms, or when user wants something to look better or more professional.
---

# Refactoring UI with Tailwind + shadcn/ui

Apply professional design principles using Tailwind's design system and shadcn/ui components.

## Context Matters: Identify Your Project Type

Different contexts require different design approaches. Before applying patterns, identify your context:

| Aspect | Marketing/Landing | SaaS/Admin Dashboard |
|--------|-------------------|---------------------|
| **Goal** | Convert visitors | Enable productivity |
| **Users** | First-time visitors | Repeated daily use |
| **Forms** | Minimal (2-4 fields) | Complex multi-field |
| **Layout** | Single-column only | Multi-column OK |
| **Errors** | Prevent abandonment | Offer undo/recovery |

**Quick decision:** Is the user here once or daily? Once → optimize for conversion. Daily → optimize for efficiency.

See **[saas-patterns.md](references/saas-patterns.md)** for SaaS-specific patterns: modals vs sheets vs pages, confirmation dialogs, CRUD tables, empty states, and loading patterns.

## Core Principles

1. **Start with functionality, not chrome** - Design the feature first, not the shell
2. **Work in grayscale first** - Add color only after hierarchy is established
3. **Use existing systems** - Tailwind scale + shadcn components, don't reinvent
4. **Hierarchy is everything** - Not all elements deserve equal emphasis

## Topic References

### Foundation
- **[shadcn.md](references/shadcn.md)** - Component patterns, composition, customization
- **[hierarchy.md](references/hierarchy.md)** - Visual hierarchy, emphasis, contrast
- **[spacing.md](references/spacing.md)** - Layout, whitespace, sizing
- **[typography.md](references/typography.md)** - Type scales, fonts, line-height
- **[color.md](references/color.md)** - Palettes, shades, accessibility
- **[depth.md](references/depth.md)** - Shadows, elevation, layering
- **[polish.md](references/polish.md)** - Finishing touches, borders, backgrounds

### Specialized
- **[forms.md](references/forms.md)** - Form design, validation, multi-step, mobile optimization
- **[saas-patterns.md](references/saas-patterns.md)** - Modal/sheet/page decisions, confirmations, CRUD tables, lists, empty states

## Quick Start with shadcn/ui

### Installation (Next.js)
```bash
npx shadcn@latest init
npx shadcn@latest add button card input label
```

### Core Components to Know

| Component | Use for |
|-----------|---------|
| `Button` | Actions with built-in variants (default, secondary, outline, ghost, destructive) |
| `Card` | Content containers with header, content, footer |
| `Input` + `Label` | Form fields with consistent styling |
| `Dialog` | Modals with accessible focus management |
| `DropdownMenu` | Actions menus with keyboard navigation |
| `Select` | Styled native-like selects |
| `Tabs` | Content organization |
| `Badge` | Status indicators, counts |
| `Alert` | Feedback messages |
| `Skeleton` | Loading states |

## Button Hierarchy (shadcn)

```tsx
// Primary: one per section max
<Button>Save Changes</Button>

// Secondary: clear but not dominant
<Button variant="secondary">Cancel</Button>

// Outline: lighter touch
<Button variant="outline">Edit</Button>

// Ghost: minimal, for toolbars/nav
<Button variant="ghost">Settings</Button>

// Destructive: dangerous actions (use sparingly)
<Button variant="destructive">Delete</Button>

// Link: text-only navigation
<Button variant="link">Learn more</Button>
```

## Common Patterns

### Card with Hierarchy
```tsx
<Card>
  <CardHeader>
    <CardTitle>Account Settings</CardTitle>
    <CardDescription>Manage your account preferences.</CardDescription>
  </CardHeader>
  <CardContent className="space-y-4">
    {/* Form fields */}
  </CardContent>
  <CardFooter className="flex justify-end gap-2">
    <Button variant="outline">Cancel</Button>
    <Button>Save</Button>
  </CardFooter>
</Card>
```

### Form with Labels
```tsx
// Single-column layout (always preferred)
<form className="space-y-6 max-w-md">
  <div className="space-y-2">
    <Label htmlFor="email">Email</Label>
    <Input id="email" type="email" placeholder="you@example.com" />
  </div>
  <div className="space-y-2">
    <Label htmlFor="password">Password</Label>
    <Input id="password" type="password" />
    <p className="text-sm text-muted-foreground">At least 8 characters</p>
  </div>
  <Button type="submit" className="w-full">Sign In</Button>
</form>
```

See **[forms.md](references/forms.md)** for multi-step forms, validation, and mobile optimization.

### Alert Messages
```tsx
<Alert>
  <InfoIcon className="h-4 w-4" />
  <AlertTitle>Note</AlertTitle>
  <AlertDescription>Your session will expire in 5 minutes.</AlertDescription>
</Alert>

<Alert variant="destructive">
  <AlertCircle className="h-4 w-4" />
  <AlertTitle>Error</AlertTitle>
  <AlertDescription>Failed to save changes.</AlertDescription>
</Alert>
```

## Anti-Patterns

- ❌ Multiple primary buttons in one view
- ❌ `variant="destructive"` for non-destructive actions
- ❌ Skipping `Label` components (accessibility)
- ❌ Overriding shadcn styles instead of using variants
- ❌ Not using `space-y-*` or `gap-*` for consistent spacing
- ❌ Arbitrary Tailwind values like `w-[423px]` (use scale)
- ❌ Grey text on colored backgrounds (use same-hue shades)

## Quick Decision: Modal vs Sheet vs Page

```
Is this a confirmation/alert? → Modal
Need to reference background content? → Sheet/Drawer
Complex form (>5 fields)? → Full Page or Drawer
Quick edit (1-3 fields)? → Inline or small Modal
Settings/filters panel? → Drawer
```

## Quick Decision: Confirmation Pattern

```
Easily undone (archive, tag)? → Toast with undo
Moderate impact (delete draft)? → Simple modal
High impact (remove user)? → Modal with consequences
Irreversible (delete account)? → Type-to-confirm
```

See **[saas-patterns.md](references/saas-patterns.md)** for full decision frameworks and code examples.
