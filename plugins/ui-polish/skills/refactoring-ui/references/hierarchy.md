# Visual Hierarchy

Visual hierarchy is the most effective tool for making something feel "designed."

## Core Concept

When everything competes for attention, interfaces feel noisy and chaotic. Deliberately de-emphasize secondary content to make important elements stand out.

## Hierarchy with Tailwind

### Text Colors (3 levels)

```html
<!-- Primary: headlines, key info -->
<h1 class="text-gray-900 font-semibold">Important headline</h1>

<!-- Secondary: body text, descriptions -->
<p class="text-gray-600">Supporting description text</p>

<!-- Tertiary: meta, timestamps, footnotes -->
<span class="text-gray-400 text-sm">Posted 3 days ago</span>
```

### Font Weights

```html
<span class="font-normal">Regular text (400)</span>
<span class="font-medium">Medium emphasis (500)</span>
<span class="font-semibold">Strong emphasis (600)</span>
<span class="font-bold">Maximum emphasis (700)</span>

<!-- Never use for UI text: -->
<span class="font-light">Too hard to read (300) ❌</span>
```

## De-emphasize to Emphasize

When the main element doesn't stand out, don't add more emphasis — de-emphasize competing elements.

```html
<!-- Nav: de-emphasize inactive items instead of over-styling active -->
<nav class="flex gap-4">
  <a class="text-gray-900 font-medium">Active</a>
  <a class="text-gray-400 hover:text-gray-600">Inactive</a>
  <a class="text-gray-400 hover:text-gray-600">Inactive</a>
</nav>

<!-- Sidebar: no background, let content breathe -->
<aside class="pr-8"><!-- no bg-gray-100 --></aside>
<main class="flex-1">Main content area</main>
```

## Labels Are a Last Resort

### Skip labels when format/context is clear
```html
<!-- Bad: redundant label -->
<span class="text-gray-500">Email:</span> jane@example.com

<!-- Good: format is self-evident -->
<span>jane@example.com</span>

<!-- Good: combine label and value -->
<span>12 left in stock</span>  <!-- not "In stock: 12" -->
```

### When labels are needed, de-emphasize them
```html
<div>
  <span class="text-xs text-gray-500 uppercase tracking-wide">Status</span>
  <span class="text-gray-900 font-medium">Active</span>
</div>
```

## Balance Weight and Contrast

Heavy elements (icons) need lower contrast to not overpower text.

```html
<!-- Icon too prominent -->
<div class="flex items-center gap-2">
  <CheckIcon class="w-5 h-5 text-gray-900" /> <!-- too heavy -->
  <span>Feature included</span>
</div>

<!-- Balanced: softer icon color -->
<div class="flex items-center gap-2">
  <CheckIcon class="w-5 h-5 text-gray-400" />
  <span>Feature included</span>
</div>
```

## Button Hierarchy

### With shadcn/ui
```tsx
import { Button } from "@/components/ui/button"

// Primary: solid, high contrast — one per section
<Button>Save Changes</Button>

// Secondary: muted background
<Button variant="secondary">Export</Button>

// Outline: border only
<Button variant="outline">Cancel</Button>

// Ghost: minimal, for toolbars
<Button variant="ghost">Settings</Button>

// Destructive: secondary style by default, not primary red
<Button variant="outline" className="text-red-600 hover:text-red-700">
  Delete
</Button>

// Destructive as primary (only in confirmation dialogs)
<Button variant="destructive">Delete Account</Button>
```

### With plain Tailwind
```html
<!-- Primary: solid, high contrast — one per section -->
<button class="bg-blue-600 text-white px-4 py-2 rounded-lg font-medium">
  Save Changes
</button>

<!-- Secondary: outline or muted -->
<button class="border border-gray-300 text-gray-700 px-4 py-2 rounded-lg">
  Cancel
</button>

<!-- Tertiary: text only -->
<button class="text-gray-500 hover:text-gray-700">
  Reset
</button>

<!-- Destructive: secondary style, not primary red -->
<button class="text-red-600 hover:text-red-700">
  Delete
</button>
```

## Grey Text on Colored Backgrounds

Don't use `text-gray-*` on colored backgrounds — use same-hue shades.

```html
<!-- Bad: grey on blue looks washed out -->
<div class="bg-blue-600 p-4">
  <p class="text-white">Primary text</p>
  <p class="text-gray-300">Secondary text ❌</p>
</div>

<!-- Good: blue shades maintain vibrancy -->
<div class="bg-blue-600 p-4">
  <p class="text-white">Primary text</p>
  <p class="text-blue-200">Secondary text ✓</p>
</div>
```
