# Finishing Touches

## Supercharge the Defaults

### Custom Bullets with Icons
```html
<ul class="space-y-3">
  <li class="flex gap-3">
    <CheckIcon class="w-5 h-5 text-green-500 shrink-0" />
    <span>Feature included</span>
  </li>
  <li class="flex gap-3">
    <CheckIcon class="w-5 h-5 text-green-500 shrink-0" />
    <span>Another benefit</span>
  </li>
</ul>
```

### Enhanced Blockquotes
```html
<blockquote class="relative pl-6 border-l-4 border-blue-500">
  <span class="absolute -left-3 -top-2 text-6xl text-blue-200">"</span>
  <p class="text-gray-700 italic">Quote text here...</p>
  <cite class="block mt-2 text-sm text-gray-500 not-italic">— Author Name</cite>
</blockquote>
```

### Form Elements with shadcn/ui
```tsx
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Checkbox } from "@/components/ui/checkbox"

// Input with label
<div className="space-y-2">
  <Label htmlFor="email">Email</Label>
  <Input id="email" type="email" placeholder="you@example.com" />
</div>

// Checkbox
<div className="flex items-center space-x-2">
  <Checkbox id="terms" />
  <Label htmlFor="terms">Accept terms and conditions</Label>
</div>
```

### Custom Form Elements (plain Tailwind)
```html
<!-- Custom checkbox -->
<label class="flex items-center gap-2 cursor-pointer">
  <input type="checkbox" class="w-4 h-4 text-blue-600 rounded border-gray-300 
                                 focus:ring-blue-500" />
  <span>Remember me</span>
</label>

<!-- Custom radio -->
<label class="flex items-center gap-2 cursor-pointer">
  <input type="radio" class="w-4 h-4 text-blue-600 border-gray-300 
                              focus:ring-blue-500" />
  <span>Option one</span>
</label>
```

### Enhanced Links
```html
<!-- Underline effect -->
<a class="relative text-blue-600 after:absolute after:bottom-0 after:left-0 
          after:h-0.5 after:w-full after:bg-blue-600/30 hover:after:bg-blue-600">
  Learn more
</a>
```

## Accent Borders

Add color without graphic design.

### shadcn Alert Components
```tsx
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"

// Info
<Alert>
  <Info className="h-4 w-4" />
  <AlertTitle>Note</AlertTitle>
  <AlertDescription>Your changes have been saved.</AlertDescription>
</Alert>

// Error
<Alert variant="destructive">
  <AlertCircle className="h-4 w-4" />
  <AlertTitle>Error</AlertTitle>
  <AlertDescription>Failed to save changes.</AlertDescription>
</Alert>

// Custom accent colors
<Alert className="border-l-4 border-l-green-500 border-t-0 border-r-0 border-b-0">
  <CheckCircle className="h-4 w-4 text-green-600" />
  <AlertTitle>Success</AlertTitle>
  <AlertDescription>Your payment was processed.</AlertDescription>
</Alert>
```

### Plain Tailwind Accent Borders
```html
<!-- Top accent on card -->
<div class="bg-white rounded-lg shadow overflow-hidden">
  <div class="h-1 bg-gradient-to-r from-blue-500 to-purple-500"></div>
  <div class="p-6">Card content</div>
</div>

<!-- Left accent (alerts) -->
<div class="border-l-4 border-blue-500 bg-blue-50 p-4">
  <p class="text-blue-700">Info message</p>
</div>

<div class="border-l-4 border-green-500 bg-green-50 p-4">
  <p class="text-green-700">Success message</p>
</div>

<div class="border-l-4 border-red-500 bg-red-50 p-4">
  <p class="text-red-700">Error message</p>
</div>

<!-- Active nav indicator -->
<nav class="flex gap-4 border-b">
  <a class="pb-2 border-b-2 border-blue-500 text-blue-600 font-medium">Active</a>
  <a class="pb-2 border-b-2 border-transparent text-gray-500 hover:text-gray-700">Tab</a>
</nav>

<!-- Headline underline accent -->
<h2 class="text-2xl font-bold">
  Section Title
  <span class="block mt-2 w-12 h-1 bg-blue-500 rounded"></span>
</h2>
```

## Decorated Backgrounds

### Gradient Backgrounds
```html
<!-- Subtle gradient (two close hues) -->
<div class="bg-gradient-to-br from-blue-50 to-indigo-50">...</div>

<!-- Hero gradient -->
<div class="bg-gradient-to-r from-blue-600 to-purple-600 text-white">...</div>
```

### Pattern Overlays
```html
<!-- Dot pattern -->
<div class="relative bg-gray-50">
  <div class="absolute inset-0 bg-[radial-gradient(#e5e7eb_1px,transparent_1px)] 
              [background-size:16px_16px] opacity-50"></div>
  <div class="relative">Content</div>
</div>
```

### Decorative Shapes
```html
<!-- Corner accent -->
<div class="relative overflow-hidden">
  <div class="absolute -top-10 -right-10 w-40 h-40 bg-blue-500/10 rounded-full"></div>
  <div class="relative p-6">Content</div>
</div>
```

## Empty States

Don't leave blank — make them engaging.

### With shadcn/ui
```tsx
import { Card } from "@/components/ui/card"
import { Button } from "@/components/ui/button"

<Card className="flex flex-col items-center justify-center p-12 text-center">
  <div className="rounded-full bg-muted p-4">
    <Inbox className="h-8 w-8 text-muted-foreground" />
  </div>
  <h3 className="mt-4 text-lg font-semibold">No projects yet</h3>
  <p className="mt-1 text-sm text-muted-foreground">
    Get started by creating your first project.
  </p>
  <Button className="mt-6">
    <Plus className="mr-2 h-4 w-4" /> Create Project
  </Button>
</Card>
```

### With plain Tailwind
```html
<div class="text-center py-12">
  <!-- Illustration or icon -->
  <div class="mx-auto w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center">
    <InboxIcon class="w-12 h-12 text-gray-400" />
  </div>
  
  <!-- Message -->
  <h3 class="mt-4 text-lg font-medium text-gray-900">No projects yet</h3>
  <p class="mt-1 text-gray-500">Get started by creating your first project.</p>
  
  <!-- CTA -->
  <button class="mt-6 bg-blue-600 text-white px-4 py-2 rounded-lg font-medium">
    Create Project
  </button>
</div>
```

**Tip:** Hide filters/tabs that don't work without content.

## Use Fewer Borders

### Replace with Shadows
```html
<!-- Instead of border -->
<div class="border border-gray-200 rounded-lg p-4">...</div>

<!-- Use shadow -->
<div class="shadow-sm rounded-lg p-4">...</div>
```

### Replace with Background Colors
```html
<!-- Instead of border between sections -->
<div class="border-b border-gray-200 p-4">Section 1</div>
<div class="p-4">Section 2</div>

<!-- Use background difference -->
<div class="bg-gray-50 p-4">Section 1</div>
<div class="bg-white p-4">Section 2</div>
```

### Replace with Spacing
```html
<!-- Instead of dividers -->
<div class="divide-y">
  <div class="py-4">Item</div>
  <div class="py-4">Item</div>
</div>

<!-- Use generous spacing -->
<div class="space-y-6">
  <div>Item</div>
  <div>Item</div>
</div>
```

## Think Outside the Box

### Rich Dropdowns
```html
<div class="absolute bg-white rounded-lg shadow-lg p-4 w-80">
  <div class="grid grid-cols-2 gap-4">
    <a class="flex items-center gap-3 p-2 rounded hover:bg-gray-50">
      <div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
        <Icon class="w-5 h-5 text-blue-600" />
      </div>
      <div>
        <div class="font-medium">Feature</div>
        <div class="text-sm text-gray-500">Description</div>
      </div>
    </a>
    <!-- more items -->
  </div>
</div>
```

### Selectable Cards (instead of radio buttons)

#### With shadcn RadioGroup
```tsx
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Label } from "@/components/ui/label"

<RadioGroup defaultValue="basic" className="grid grid-cols-3 gap-4">
  {["basic", "pro", "enterprise"].map((plan) => (
    <div key={plan}>
      <RadioGroupItem value={plan} id={plan} className="peer sr-only" />
      <Label
        htmlFor={plan}
        className="flex flex-col items-center justify-between rounded-md border-2 
                   border-muted bg-popover p-4 hover:bg-accent hover:text-accent-foreground 
                   peer-data-[state=checked]:border-primary [&:has([data-state=checked])]:border-primary"
      >
        <span className="font-medium capitalize">{plan}</span>
        <span className="text-2xl font-bold">$9/mo</span>
      </Label>
    </div>
  ))}
</RadioGroup>
```

#### With plain Tailwind
```html
<div class="grid grid-cols-3 gap-4">
  <label class="relative cursor-pointer">
    <input type="radio" name="plan" class="peer sr-only" />
    <div class="p-4 border-2 rounded-lg peer-checked:border-blue-500 
                peer-checked:bg-blue-50 hover:bg-gray-50">
      <div class="font-medium">Basic</div>
      <div class="text-2xl font-bold">$9/mo</div>
    </div>
  </label>
  <!-- more options -->
</div>
```

### Enhanced Tables
```html
<table class="w-full">
  <tr class="border-b">
    <td class="py-4">
      <div class="flex items-center gap-4">
        <img class="w-10 h-10 rounded-full" />
        <div>
          <div class="font-medium text-gray-900">John Doe</div>
          <div class="text-sm text-gray-500">john@example.com</div>
        </div>
      </div>
    </td>
    <td class="text-right">
      <span class="inline-flex items-center px-2 py-1 rounded-full text-xs 
                   font-medium bg-green-100 text-green-700">
        Active
      </span>
    </td>
  </tr>
</table>
```
