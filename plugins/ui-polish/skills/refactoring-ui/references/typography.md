# Designing Text

## Tailwind Type Scale

Use the built-in scale — don't invent sizes.

| Class | Size | Use for |
|-------|------|---------|
| `text-xs` | 12px | Badges, fine print (sparingly) |
| `text-sm` | 14px | Secondary text, labels, meta |
| `text-base` | 16px | Body text (default) |
| `text-lg` | 18px | Lead paragraphs, emphasis |
| `text-xl` | 20px | Card titles, section headers |
| `text-2xl` | 24px | Page section titles |
| `text-3xl` | 30px | Page titles |
| `text-4xl` | 36px | Hero headlines (mobile) |
| `text-5xl` | 48px | Hero headlines (desktop) |
| `text-6xl` | 60px | Large display text |

## Font Weights

```html
<span class="font-normal">Regular body text (400)</span>
<span class="font-medium">Slightly emphasized (500)</span>
<span class="font-semibold">Headlines, buttons (600)</span>
<span class="font-bold">Strong emphasis (700)</span>
```

**Avoid:** `font-thin`, `font-extralight`, `font-light` for UI text — too hard to read.

## Line Length

Optimal reading: 45-75 characters per line.

```html
<!-- Constrain prose width -->
<article class="max-w-prose">Long form content...</article>

<!-- Or use max-w-xl/2xl for similar effect -->
<div class="max-w-2xl">...</div>
```

**Mixed content:** Keep paragraphs constrained even in wider layouts.

```html
<div class="max-w-4xl">
  <img class="w-full" />
  <p class="max-w-prose">Paragraph stays readable width.</p>
</div>
```

## Line Height

Tailwind's defaults are good, but adjust based on context:

```html
<!-- Tight: headlines, large text -->
<h1 class="text-4xl leading-tight">Big Headline</h1>

<!-- Normal: body text (default) -->
<p class="leading-normal">Body paragraph...</p>

<!-- Relaxed: small text, wide columns -->
<p class="text-sm leading-relaxed">Small text needs more space.</p>
```

**Principle:** Line-height and font-size are inversely proportional.
- Large text → tighter leading (`leading-tight`, `leading-none`)
- Small text → looser leading (`leading-relaxed`)

## Alignment

```html
<!-- Default: left-align (best for reading) -->
<p class="text-left">Long paragraphs...</p>

<!-- Center: only for short, independent blocks -->
<div class="text-center">
  <h2>Short Headline</h2>
  <p class="max-w-md mx-auto">One or two lines max.</p>
</div>

<!-- Right-align numbers for comparison -->
<td class="text-right tabular-nums">1,234.56</td>
```

## Links in UI

Not every link needs `text-blue-600 underline`.

```html
<!-- In paragraphs: make links stand out -->
<p>Read our <a class="text-blue-600 hover:underline">documentation</a>.</p>

<!-- In navigation: subtle, discoverable -->
<nav class="flex gap-6">
  <a class="text-gray-600 hover:text-gray-900">Features</a>
  <a class="text-gray-600 hover:text-gray-900">Pricing</a>
</nav>

<!-- Ancillary links: underline on hover only -->
<a class="text-gray-500 hover:text-gray-700 hover:underline">Terms</a>
```

## Letter Spacing

```html
<!-- Tighten large headlines -->
<h1 class="text-5xl tracking-tight">Hero Headline</h1>

<!-- Widen all-caps text for legibility -->
<span class="uppercase tracking-wide text-xs font-semibold text-gray-500">
  Category
</span>
```

## Common Text Patterns

### Page Header
```tsx
// With shadcn Card
<div className="flex items-center justify-between mb-8">
  <div>
    <h1 className="text-2xl font-semibold tracking-tight">Dashboard</h1>
    <p className="text-muted-foreground">Overview of your account activity.</p>
  </div>
  <Button>
    <Plus className="mr-2 h-4 w-4" /> Add New
  </Button>
</div>
```

### Card Title + Description (shadcn)
```tsx
<CardHeader>
  <CardTitle>Team Settings</CardTitle>
  <CardDescription>Manage your team preferences.</CardDescription>
</CardHeader>
```

### Plain Tailwind Patterns
```html
<!-- Section Header -->
<h2 class="text-lg font-medium text-gray-900 mb-4">Recent Activity</h2>

<!-- Card Title + Description -->
<h3 class="font-semibold text-gray-900">Card Title</h3>
<p class="mt-1 text-sm text-gray-500">Supporting description text.</p>

<!-- Meta Information -->
<div class="flex items-center gap-2 text-sm text-gray-500">
  <span>John Doe</span>
  <span>·</span>
  <span>Mar 15, 2024</span>
</div>
```

### Badge/Label
```tsx
// shadcn Badge
import { Badge } from "@/components/ui/badge"

<Badge>Default</Badge>
<Badge variant="secondary">Draft</Badge>
<Badge variant="outline">Archived</Badge>
<Badge className="bg-green-100 text-green-800">Active</Badge>
```

```html
<!-- Plain Tailwind badge -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
  Active
</span>
```
