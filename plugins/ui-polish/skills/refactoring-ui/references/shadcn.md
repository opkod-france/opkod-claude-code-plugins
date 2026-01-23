# shadcn/ui Component Patterns

shadcn/ui provides accessible, customizable components built on Radix UI + Tailwind.

## Philosophy

- **Copy-paste, not npm install** — You own the code
- **Composable** — Build complex UIs from primitives
- **Accessible** — Radix handles keyboard nav, focus, ARIA
- **Customizable** — Modify source directly, use CSS variables

## Installation

```bash
# Initialize in project
npx shadcn@latest init

# Add components as needed
npx shadcn@latest add button card input dialog
```

## Button Variants

Use variants for hierarchy, not custom colors.

```tsx
import { Button } from "@/components/ui/button"

// Primary action — one per section
<Button>Save Changes</Button>

// Secondary — clear but not dominant
<Button variant="secondary">Export</Button>

// Outline — lighter touch
<Button variant="outline">Cancel</Button>

// Ghost — minimal, toolbars/nav
<Button variant="ghost" size="icon">
  <Settings className="h-4 w-4" />
</Button>

// Destructive — dangerous actions only
<Button variant="destructive">Delete Account</Button>

// Link — text navigation
<Button variant="link">View documentation</Button>
```

### Button Sizes

```tsx
<Button size="sm">Small</Button>
<Button size="default">Default</Button>
<Button size="lg">Large</Button>
<Button size="icon"><Plus className="h-4 w-4" /></Button>
```

### Button with Loading State

```tsx
<Button disabled>
  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
  Saving...
</Button>
```

## Cards

Use Card components for content containers.

```tsx
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"

<Card>
  <CardHeader>
    <CardTitle>Team Settings</CardTitle>
    <CardDescription>Manage your team preferences and members.</CardDescription>
  </CardHeader>
  <CardContent>
    {/* Main content */}
  </CardContent>
  <CardFooter className="flex justify-between">
    <Button variant="outline">Cancel</Button>
    <Button>Save</Button>
  </CardFooter>
</Card>
```

### Card Variants via className

```tsx
// Elevated card
<Card className="shadow-lg">

// Interactive card
<Card className="cursor-pointer hover:shadow-md transition-shadow">

// Bordered card (no shadow)
<Card className="shadow-none border">

// Colored accent
<Card className="border-l-4 border-l-blue-500">
```

## Forms

Always pair Input with Label for accessibility.

```tsx
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"

<div className="grid w-full max-w-sm gap-1.5">
  <Label htmlFor="email">Email</Label>
  <Input type="email" id="email" placeholder="you@example.com" />
</div>
```

### Form Layout Pattern

```tsx
<form className="space-y-6">
  {/* Group related fields */}
  <div className="space-y-4">
    <div className="space-y-2">
      <Label htmlFor="name">Name</Label>
      <Input id="name" />
    </div>
    <div className="space-y-2">
      <Label htmlFor="email">Email</Label>
      <Input id="email" type="email" />
    </div>
  </div>

  {/* Actions at bottom */}
  <div className="flex justify-end gap-2">
    <Button variant="outline">Cancel</Button>
    <Button type="submit">Submit</Button>
  </div>
</form>
```

### With Description and Error

```tsx
<div className="space-y-2">
  <Label htmlFor="username">Username</Label>
  <Input id="username" />
  <p className="text-sm text-muted-foreground">
    This will be your public display name.
  </p>
</div>

{/* Error state */}
<div className="space-y-2">
  <Label htmlFor="email">Email</Label>
  <Input id="email" className="border-red-500" />
  <p className="text-sm text-red-500">Please enter a valid email.</p>
</div>
```

## Select

```tsx
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"

<Select>
  <SelectTrigger className="w-[180px]">
    <SelectValue placeholder="Select role" />
  </SelectTrigger>
  <SelectContent>
    <SelectItem value="admin">Admin</SelectItem>
    <SelectItem value="editor">Editor</SelectItem>
    <SelectItem value="viewer">Viewer</SelectItem>
  </SelectContent>
</Select>
```

## Dialog (Modal)

```tsx
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"

<Dialog>
  <DialogTrigger asChild>
    <Button>Edit Profile</Button>
  </DialogTrigger>
  <DialogContent className="sm:max-w-[425px]">
    <DialogHeader>
      <DialogTitle>Edit Profile</DialogTitle>
      <DialogDescription>
        Make changes to your profile here.
      </DialogDescription>
    </DialogHeader>
    <div className="grid gap-4 py-4">
      {/* Form content */}
    </div>
    <DialogFooter>
      <Button type="submit">Save changes</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

### Destructive Confirmation Dialog

```tsx
<Dialog>
  <DialogTrigger asChild>
    <Button variant="destructive">Delete</Button>
  </DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Are you sure?</DialogTitle>
      <DialogDescription>
        This action cannot be undone. This will permanently delete your account.
      </DialogDescription>
    </DialogHeader>
    <DialogFooter>
      <Button variant="outline">Cancel</Button>
      <Button variant="destructive">Delete</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

## Dropdown Menu

```tsx
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"

<DropdownMenu>
  <DropdownMenuTrigger asChild>
    <Button variant="ghost" size="icon">
      <MoreHorizontal className="h-4 w-4" />
    </Button>
  </DropdownMenuTrigger>
  <DropdownMenuContent align="end">
    <DropdownMenuLabel>Actions</DropdownMenuLabel>
    <DropdownMenuSeparator />
    <DropdownMenuItem>Edit</DropdownMenuItem>
    <DropdownMenuItem>Duplicate</DropdownMenuItem>
    <DropdownMenuSeparator />
    <DropdownMenuItem className="text-red-600">Delete</DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>
```

## Tabs

```tsx
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

<Tabs defaultValue="account" className="w-[400px]">
  <TabsList>
    <TabsTrigger value="account">Account</TabsTrigger>
    <TabsTrigger value="password">Password</TabsTrigger>
  </TabsList>
  <TabsContent value="account">
    <Card>
      <CardHeader>
        <CardTitle>Account</CardTitle>
      </CardHeader>
      <CardContent>{/* Account settings */}</CardContent>
    </Card>
  </TabsContent>
  <TabsContent value="password">
    <Card>
      <CardHeader>
        <CardTitle>Password</CardTitle>
      </CardHeader>
      <CardContent>{/* Password settings */}</CardContent>
    </Card>
  </TabsContent>
</Tabs>
```

## Alert

```tsx
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"

// Default (info)
<Alert>
  <Info className="h-4 w-4" />
  <AlertTitle>Note</AlertTitle>
  <AlertDescription>This is an informational message.</AlertDescription>
</Alert>

// Destructive (error)
<Alert variant="destructive">
  <AlertCircle className="h-4 w-4" />
  <AlertTitle>Error</AlertTitle>
  <AlertDescription>Something went wrong.</AlertDescription>
</Alert>
```

## Badge

```tsx
import { Badge } from "@/components/ui/badge"

<Badge>Default</Badge>
<Badge variant="secondary">Secondary</Badge>
<Badge variant="outline">Outline</Badge>
<Badge variant="destructive">Destructive</Badge>

// Custom colors via className
<Badge className="bg-green-100 text-green-800 hover:bg-green-100">Active</Badge>
<Badge className="bg-yellow-100 text-yellow-800 hover:bg-yellow-100">Pending</Badge>
```

## Skeleton (Loading States)

```tsx
import { Skeleton } from "@/components/ui/skeleton"

// Card loading state
<Card>
  <CardHeader>
    <Skeleton className="h-6 w-[200px]" />
    <Skeleton className="h-4 w-[300px]" />
  </CardHeader>
  <CardContent className="space-y-2">
    <Skeleton className="h-4 w-full" />
    <Skeleton className="h-4 w-full" />
    <Skeleton className="h-4 w-2/3" />
  </CardContent>
</Card>

// Avatar + text
<div className="flex items-center gap-4">
  <Skeleton className="h-12 w-12 rounded-full" />
  <div className="space-y-2">
    <Skeleton className="h-4 w-[150px]" />
    <Skeleton className="h-4 w-[100px]" />
  </div>
</div>
```

## Table

```tsx
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

<Table>
  <TableHeader>
    <TableRow>
      <TableHead>Name</TableHead>
      <TableHead>Status</TableHead>
      <TableHead className="text-right">Amount</TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
    <TableRow>
      <TableCell className="font-medium">John Doe</TableCell>
      <TableCell><Badge>Active</Badge></TableCell>
      <TableCell className="text-right">$250.00</TableCell>
    </TableRow>
  </TableBody>
</Table>
```

## Composition Patterns

### Page Header
```tsx
<div className="flex items-center justify-between">
  <div>
    <h1 className="text-2xl font-semibold tracking-tight">Dashboard</h1>
    <p className="text-muted-foreground">Overview of your account.</p>
  </div>
  <Button>
    <Plus className="mr-2 h-4 w-4" /> Add New
  </Button>
</div>
```

### Empty State
```tsx
<Card className="flex flex-col items-center justify-center p-12 text-center">
  <div className="rounded-full bg-muted p-4">
    <Inbox className="h-8 w-8 text-muted-foreground" />
  </div>
  <h3 className="mt-4 text-lg font-semibold">No projects yet</h3>
  <p className="mt-1 text-sm text-muted-foreground">
    Get started by creating your first project.
  </p>
  <Button className="mt-4">
    <Plus className="mr-2 h-4 w-4" /> Create Project
  </Button>
</Card>
```

### Settings Section
```tsx
<div className="grid gap-6 md:grid-cols-[200px_1fr]">
  <div>
    <h3 className="font-medium">Notifications</h3>
    <p className="text-sm text-muted-foreground">
      Configure how you receive notifications.
    </p>
  </div>
  <Card>
    <CardContent className="pt-6">
      {/* Settings form */}
    </CardContent>
  </Card>
</div>
```

## Theming with CSS Variables

shadcn uses CSS variables for theming. Override in `globals.css`:

```css
@layer base {
  :root {
    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96%;
    --muted: 210 40% 96%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96%;
    --destructive: 0 84.2% 60.2%;
    --border: 214.3 31.8% 91.4%;
    --ring: 222.2 84% 4.9%;
  }
}
```

## Best Practices

1. **Use `asChild` for custom triggers** — Preserves your element while adding behavior
2. **Prefer variants over className overrides** — More maintainable
3. **Always include Labels** — Required for accessibility
4. **Use `text-muted-foreground`** — Consistent secondary text color
5. **Compose from primitives** — Build complex UIs from simple parts
6. **Keep dialogs focused** — One task per modal
7. **Show loading states** — Use Skeleton during data fetches
