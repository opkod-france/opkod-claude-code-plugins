# Layout and Spacing

## Start with Too Much White Space

Most designs add whitespace reactively. Start generous, then reduce.

```html
<!-- Start with more padding than you think -->
<div class="p-8"><!-- then try p-6, p-4 until right --></div>
```

## Tailwind Spacing Scale

Tailwind's spacing scale is already well-designed — use it, don't fight it.

| Class | Size | Common Use |
|-------|------|------------|
| `1` | 4px | Tight gaps, icon padding |
| `2` | 8px | Button padding, small gaps |
| `3` | 12px | Input padding |
| `4` | 16px | Card padding, standard gaps |
| `5` | 20px | Medium spacing |
| `6` | 24px | Section padding |
| `8` | 32px | Large gaps |
| `10` | 40px | Section margins |
| `12` | 48px | Hero spacing |
| `16` | 64px | Major sections |
| `20` | 80px | Page sections |
| `24` | 96px | Hero sections |

**Principle:** Adjacent scale values differ by ~25%+, making choices obvious.

## Don't Fill the Screen

```html
<!-- Bad: stretches unnecessarily -->
<form class="w-full">...</form>

<!-- Good: constrain to what's needed -->
<form class="max-w-md mx-auto">...</form>
```

### Max-Width Reference

```html
<div class="max-w-xs">320px - narrow cards, small modals</div>
<div class="max-w-sm">384px - sidebar content</div>
<div class="max-w-md">448px - forms, dialogs</div>
<div class="max-w-lg">512px - medium content areas</div>
<div class="max-w-xl">576px - wide forms</div>
<div class="max-w-2xl">672px - article content</div>
<div class="max-w-3xl">768px - wide articles</div>
<div class="max-w-4xl">896px - dashboards</div>
<div class="max-w-prose">65ch - optimal reading width</div>
```

## Grids: Fixed + Fluid

Don't make everything percentage-based. Sidebars should be fixed width.

```html
<!-- Good: fixed sidebar, fluid main -->
<div class="flex">
  <aside class="w-64 shrink-0">Fixed 256px sidebar</aside>
  <main class="flex-1 min-w-0">Fluid main content</main>
</div>

<!-- Bad: percentage sidebar shrinks/grows awkwardly -->
<div class="flex">
  <aside class="w-1/4">Percentage sidebar ❌</aside>
  <main class="w-3/4">...</main>
</div>
```

## Responsive: Don't Scale Proportionally

Large elements shrink faster than small elements.

```html
<!-- Heading: much smaller on mobile -->
<h1 class="text-3xl md:text-4xl lg:text-5xl">...</h1>

<!-- Body: barely changes -->
<p class="text-sm md:text-base">...</p>

<!-- Spacing: tighter on mobile -->
<section class="py-12 md:py-16 lg:py-24">...</section>
```

## Avoid Ambiguous Spacing

Group related elements with tighter spacing.

```html
<!-- Bad: equal spacing creates ambiguity -->
<div class="space-y-4">
  <label>Email</label>
  <input />
  <label>Password</label>  <!-- Which input does this belong to? -->
  <input />
</div>

<!-- Good: tight within groups, loose between -->
<div class="space-y-6">
  <div>
    <label class="block mb-1">Email</label>
    <input />
  </div>
  <div>
    <label class="block mb-1">Password</label>
    <input />
  </div>
</div>
```

## Thinking in Columns

Narrow content feeling unbalanced? Split into columns.

```html
<!-- Form with side description -->
<div class="grid md:grid-cols-3 gap-8">
  <div class="md:col-span-1">
    <h3 class="font-medium">Account Settings</h3>
    <p class="text-gray-500 text-sm mt-1">Update your account information.</p>
  </div>
  <div class="md:col-span-2">
    <form class="space-y-4">...</form>
  </div>
</div>
```

## Common Layout Patterns

### Centered Content
```html
<div class="max-w-2xl mx-auto px-4">...</div>
```

### Sidebar Layout
```html
<div class="flex min-h-screen">
  <aside class="w-64 border-r bg-gray-50">...</aside>
  <main class="flex-1 p-8">...</main>
</div>
```

### Card Grid
```html
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  <div class="bg-white rounded-lg shadow p-6">...</div>
  <!-- more cards -->
</div>
```
