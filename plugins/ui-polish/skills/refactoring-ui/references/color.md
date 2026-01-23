# Working with Color

## Tailwind's Color System

Tailwind provides 8-10 shades per color (50-950). Use the full range.

### Shade Guide

| Shade | Use for |
|-------|---------|
| `50` | Subtle backgrounds, tinted areas |
| `100` | Hover states on light bg, borders |
| `200` | Soft borders, disabled states |
| `300` | Placeholder text on white |
| `400` | Secondary text on dark bg |
| `500` | Icons, secondary buttons |
| `600` | Primary buttons, links |
| `700` | Button hover states, emphasis |
| `800` | Dark backgrounds |
| `900` | Primary text, headings |
| `950` | Near-black, highest contrast |

## Greys

```html
<!-- Text hierarchy -->
<h1 class="text-gray-900">Primary text</h1>
<p class="text-gray-600">Secondary text</p>
<span class="text-gray-400">Tertiary text</span>

<!-- Backgrounds -->
<div class="bg-white">Primary surface</div>
<div class="bg-gray-50">Subtle distinction</div>
<div class="bg-gray-100">Inset areas, wells</div>
<div class="bg-gray-800">Dark mode surface</div>
<div class="bg-gray-900">Near-black</div>

<!-- Borders -->
<div class="border border-gray-200">Subtle border</div>
<div class="border border-gray-300">Standard border</div>
```

## Primary Colors

Use full shade range for versatility:

```html
<!-- Blue example -->
<div class="bg-blue-50 text-blue-700">Light tinted alert</div>
<button class="bg-blue-600 text-white hover:bg-blue-700">Button</button>
<a class="text-blue-600 hover:text-blue-700">Link</a>
<div class="border-l-4 border-blue-500">Accent border</div>
```

## Semantic Colors

```html
<!-- Success -->
<span class="text-green-600">Payment complete</span>
<div class="bg-green-50 text-green-800 p-4">Success message</div>

<!-- Warning -->
<span class="text-yellow-600">Review required</span>
<div class="bg-yellow-50 text-yellow-800 p-4">Warning message</div>

<!-- Error -->
<span class="text-red-600">Failed to save</span>
<div class="bg-red-50 text-red-800 p-4">Error message</div>

<!-- Info -->
<div class="bg-blue-50 text-blue-800 p-4">Info message</div>
```

## Text on Colored Backgrounds

**Never use grey text on colored backgrounds.** Use same-hue shades.

```html
<!-- Bad: grey on colored bg -->
<div class="bg-blue-600 p-4">
  <p class="text-white">Primary</p>
  <p class="text-gray-300">Secondary ❌</p>
</div>

<!-- Good: same-hue shades -->
<div class="bg-blue-600 p-4">
  <p class="text-white">Primary</p>
  <p class="text-blue-200">Secondary ✓</p>
</div>

<!-- Light backgrounds -->
<div class="bg-blue-50 p-4">
  <p class="text-blue-900">Primary</p>
  <p class="text-blue-700">Secondary</p>
</div>
```

## Accessibility

WCAG contrast minimums:
- Normal text: 4.5:1
- Large text (18px+): 3:1

### Flip the Contrast

White text on color requires very dark backgrounds (accessibility + hierarchy issues).

```html
<!-- Often problematic: light on dark -->
<div class="bg-blue-600 text-white p-4">
  Hard to meet contrast without very dark blue
</div>

<!-- Better: dark on light -->
<div class="bg-blue-50 text-blue-700 p-4">
  Color supports text without dominating
</div>
```

### Common Accessible Pairings

```html
<!-- Safe text/bg combinations -->
<div class="bg-white text-gray-900">...</div>
<div class="bg-gray-50 text-gray-900">...</div>
<div class="bg-gray-900 text-white">...</div>
<div class="bg-blue-50 text-blue-800">...</div>
<div class="bg-green-50 text-green-800">...</div>
<div class="bg-red-50 text-red-800">...</div>
<div class="bg-blue-600 text-white">...</div>
<div class="bg-gray-800 text-gray-100">...</div>
```

## Don't Rely on Color Alone

Add secondary indicators for color-blind users.

```html
<!-- Bad: color only -->
<span class="text-green-600">+12%</span>
<span class="text-red-600">-8%</span>

<!-- Good: color + icon -->
<span class="text-green-600">↑ +12%</span>
<span class="text-red-600">↓ -8%</span>

<!-- Or color + text label -->
<span class="text-green-600">+12% (increase)</span>
```

## Temperature with Tailwind

Tailwind's `gray` is neutral. For warmer/cooler tones:

```html
<!-- Cool greys (blue undertone) -->
<div class="bg-slate-50 text-slate-900">Cool UI</div>

<!-- Warm greys (brown undertone) -->
<div class="bg-stone-50 text-stone-900">Warm UI</div>

<!-- Neutral -->
<div class="bg-gray-50 text-gray-900">Neutral UI</div>

<!-- Zinc (slight cool) -->
<div class="bg-zinc-50 text-zinc-900">Modern UI</div>
```
