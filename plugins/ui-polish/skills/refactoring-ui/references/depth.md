# Creating Depth

## Tailwind Shadow Scale

Shadows convey elevation — bigger shadow = closer to user = more attention.

| Class | Use for |
|-------|---------|
| `shadow-sm` | Subtle lift: buttons, inputs |
| `shadow` | Default cards, panels |
| `shadow-md` | Dropdowns, popovers |
| `shadow-lg` | Floating panels, elevated cards |
| `shadow-xl` | Modals, dialogs |
| `shadow-2xl` | Maximum elevation |

```html
<button class="shadow-sm hover:shadow">Subtle button</button>
<div class="shadow rounded-lg p-4">Standard card</div>
<div class="shadow-md">Dropdown menu</div>
<div class="shadow-xl">Modal dialog</div>
```

## Interactive Shadows

Use shadow changes for interaction feedback.

```html
<!-- Button: press effect -->
<button class="shadow hover:shadow-md active:shadow-sm transition-shadow">
  Click me
</button>

<!-- Card: lift on hover -->
<div class="shadow hover:shadow-lg transition-shadow cursor-pointer">
  Clickable card
</div>

<!-- Draggable: elevate on grab -->
<div class="shadow data-[dragging=true]:shadow-xl">
  Drag to reorder
</div>
```

## Flat Design Depth (No Shadows)

Create depth with color instead of shadows.

```html
<!-- Raised: lighter than background -->
<div class="bg-gray-50"> <!-- page background -->
  <div class="bg-white p-4">Raised panel</div>
</div>

<!-- Inset: darker than background -->
<div class="bg-white">
  <div class="bg-gray-100 p-4">Inset well</div>
</div>

<!-- Solid shadow (flat design aesthetic) -->
<button class="bg-blue-600 text-white shadow-[0_4px_0_theme(colors.blue.800)] 
               active:shadow-none active:translate-y-1">
  Flat button with depth
</button>
```

## Layering with Overlap

Create depth by overlapping elements.

```html
<!-- Card crossing background boundary -->
<div class="bg-blue-600 pb-16">
  <h2 class="text-white">Section header</h2>
</div>
<div class="-mt-12 mx-4">
  <div class="bg-white rounded-lg shadow-lg p-6">
    Card overlaps both backgrounds
  </div>
</div>

<!-- Image with overlap -->
<div class="relative">
  <div class="bg-gray-100 h-48"></div>
  <img class="absolute -bottom-8 left-8 w-32 h-32 rounded-lg shadow-lg" />
</div>
```

## Ring for Focus States

Use `ring` utilities for focus indication (better than border changes).

```html
<input class="border border-gray-300 rounded-md 
              focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />

<button class="bg-blue-600 text-white rounded-md 
               focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
  Button
</button>
```

## Emulating Light Source

Light comes from above — top edges lighter, bottom edges cast shadows.

```html
<!-- Raised button with light simulation -->
<button class="bg-gray-100 
               shadow-sm
               border-t border-white/50
               border-b border-gray-300">
  Raised
</button>

<!-- Inset input -->
<input class="bg-white
              shadow-inner
              border border-gray-300" />
```

## Common Depth Patterns

### Card
```html
<div class="bg-white rounded-lg shadow p-6">
  Card content
</div>
```

### Elevated Card (hover or important)
```html
<div class="bg-white rounded-lg shadow-lg p-6">
  Elevated card
</div>
```

### Modal / Dialog

#### With shadcn/ui
```tsx
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"

<Dialog>
  <DialogTrigger asChild>
    <Button>Open</Button>
  </DialogTrigger>
  <DialogContent className="sm:max-w-[425px]">
    <DialogHeader>
      <DialogTitle>Edit Profile</DialogTitle>
      <DialogDescription>Make changes to your profile here.</DialogDescription>
    </DialogHeader>
    {/* Content */}
  </DialogContent>
</Dialog>
```

#### Plain Tailwind
```html
<div class="fixed inset-0 bg-black/50">
  <div class="bg-white rounded-lg shadow-2xl max-w-md mx-auto mt-20 p-6">
    Modal content
  </div>
</div>
```

### Dropdown

#### With shadcn/ui
```tsx
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"

<DropdownMenu>
  <DropdownMenuTrigger asChild>
    <Button variant="outline">Options</Button>
  </DropdownMenuTrigger>
  <DropdownMenuContent>
    <DropdownMenuItem>Edit</DropdownMenuItem>
    <DropdownMenuItem>Duplicate</DropdownMenuItem>
    <DropdownMenuItem className="text-red-600">Delete</DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>
```

#### Plain Tailwind
```html
<div class="relative">
  <button>Trigger</button>
  <div class="absolute top-full mt-2 bg-white rounded-lg shadow-md border border-gray-100 p-2">
    Dropdown content
  </div>
</div>
```

### Inset Section
```html
<div class="bg-gray-100 rounded-lg p-4">
  Inset content area
</div>
```

### Image Overlap Prevention
```html
<!-- When images might blend with background -->
<img class="rounded-lg ring-1 ring-black/5" src="..." />
```
