# SaaS & Admin UI Patterns

Different contexts require different design approaches. Marketing websites optimize for conversion; SaaS applications optimize for productivity and repeated use.

## Context Detection

Before designing, identify your context:

| Aspect | Marketing/Landing | SaaS/Admin Dashboard |
|--------|-------------------|---------------------|
| **Primary goal** | Convert visitors | Enable productivity |
| **User familiarity** | First-time visitors | Repeated daily use |
| **Form complexity** | Minimal fields | Complex multi-field |
| **Data density** | Low (persuasive) | High (informational) |
| **Error tolerance** | Low friction | Undo/recovery options |
| **Validation** | Immediate feedback | Batch + inline |
| **Layout** | Single-column | Multi-column acceptable |

## Modal vs Sheet vs Full Page

### Decision Framework

```
Is this action destructive or irreversible?
  └─ Yes → Modal (confirmation dialog)

Does user need to reference background content?
  └─ Yes → Sheet/Drawer (preserves context)

Is the form complex (>5 fields) or multi-step?
  └─ Yes → Full page or multi-step modal

Is this a quick edit (1-3 fields)?
  └─ Yes → Inline editing or small modal

Is this a settings/filter panel?
  └─ Yes → Drawer/Sheet (non-blocking if possible)
```

### When to Use Modals

**Best for:**
- Confirmation dialogs (delete, discard changes)
- Critical alerts requiring immediate attention
- Simple forms (login, quick create)
- Actions that need isolation from main workflow

```tsx
// shadcn Dialog - Confirmation
<Dialog>
  <DialogTrigger asChild>
    <Button variant="destructive" size="sm">Delete</Button>
  </DialogTrigger>
  <DialogContent className="sm:max-w-[425px]">
    <DialogHeader>
      <DialogTitle>Delete project</DialogTitle>
      <DialogDescription>
        This will permanently delete <strong>My Project</strong> and all associated data.
        This action cannot be undone.
      </DialogDescription>
    </DialogHeader>
    <DialogFooter className="gap-2 sm:gap-0">
      <Button variant="outline">Cancel</Button>
      <Button variant="destructive">Delete Project</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

**Modal sizing guidelines:**
- Small (max-w-sm): Confirmations, alerts
- Medium (max-w-md): Simple forms, 3-5 fields
- Large (max-w-lg): Complex forms, previews
- Never exceed 25% of screen for simple actions

**Anti-patterns:**
- ❌ Stacking more than 2 modals
- ❌ Long scrolling forms in modals
- ❌ Using modals for loading states
- ❌ Error messages in modal format

### When to Use Sheets/Drawers

**Best for:**
- Filters and sorting panels
- Settings that don't require full focus
- Detail views where context matters
- Chat/help panels
- Quick actions on selected items

```tsx
// shadcn Sheet - Filter Panel
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet"

<Sheet>
  <SheetTrigger asChild>
    <Button variant="outline" size="sm">
      <Filter className="mr-2 h-4 w-4" />
      Filters
    </Button>
  </SheetTrigger>
  <SheetContent>
    <SheetHeader>
      <SheetTitle>Filter Results</SheetTitle>
    </SheetHeader>
    <div className="space-y-6 py-4">
      <div className="space-y-2">
        <Label>Status</Label>
        <Select>
          <SelectTrigger>
            <SelectValue placeholder="All statuses" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="active">Active</SelectItem>
            <SelectItem value="pending">Pending</SelectItem>
            <SelectItem value="archived">Archived</SelectItem>
          </SelectContent>
        </Select>
      </div>
      {/* More filters */}
      <Button className="w-full">Apply Filters</Button>
    </div>
  </SheetContent>
</Sheet>
```

**Side sheets:** Use for desktop filters, settings panels, detail views
**Bottom sheets:** Use for mobile actions, limited options (iOS/Android pattern)

### When to Use Full Page

**Best for:**
- Complex multi-step wizards
- Forms with >7 fields
- Onboarding flows
- Settings pages with multiple sections
- Content creation (documents, posts)

```tsx
// Full page form with breadcrumb context
<div className="max-w-2xl mx-auto py-8">
  {/* Breadcrumb for context */}
  <nav className="flex items-center gap-2 text-sm text-muted-foreground mb-6">
    <a href="/projects" className="hover:text-foreground">Projects</a>
    <ChevronRight className="h-4 w-4" />
    <span className="text-foreground">Create New Project</span>
  </nav>

  <Card>
    <CardHeader>
      <CardTitle>Create New Project</CardTitle>
      <CardDescription>
        Fill in the details to set up your new project.
      </CardDescription>
    </CardHeader>
    <CardContent className="space-y-6">
      {/* Form sections */}
    </CardContent>
    <CardFooter className="flex justify-between border-t pt-6">
      <Button variant="outline" asChild>
        <a href="/projects">Cancel</a>
      </Button>
      <Button>Create Project</Button>
    </CardFooter>
  </Card>
</div>
```

## Confirmation Patterns

### Severity Levels

| Level | Pattern | Example |
|-------|---------|---------|
| **Low** | Toast with undo | Archive email, remove tag |
| **Medium** | Simple confirmation modal | Delete draft, leave page |
| **High** | Confirmation with details | Delete account, remove team member |
| **Critical** | Type-to-confirm | Delete repository, cancel subscription |

### Low Severity: Toast with Undo

For easily reversible actions, skip the confirmation and offer undo.

```tsx
// Toast with undo action
import { toast } from "sonner"

const handleArchive = async (item: Item) => {
  // Optimistically update UI
  archiveItem(item.id)

  toast("Item archived", {
    description: `"${item.name}" has been archived.`,
    action: {
      label: "Undo",
      onClick: () => restoreItem(item.id),
    },
  })
}
```

### Medium Severity: Simple Confirmation

```tsx
<AlertDialog>
  <AlertDialogTrigger asChild>
    <Button variant="outline">Discard Changes</Button>
  </AlertDialogTrigger>
  <AlertDialogContent>
    <AlertDialogHeader>
      <AlertDialogTitle>Discard unsaved changes?</AlertDialogTitle>
      <AlertDialogDescription>
        You have unsaved changes that will be lost. This cannot be undone.
      </AlertDialogDescription>
    </AlertDialogHeader>
    <AlertDialogFooter>
      <AlertDialogCancel>Keep Editing</AlertDialogCancel>
      <AlertDialogAction>Discard</AlertDialogAction>
    </AlertDialogFooter>
  </AlertDialogContent>
</AlertDialog>
```

### High Severity: Detailed Confirmation

Show exactly what will be affected.

```tsx
<Dialog>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Remove team member</DialogTitle>
      <DialogDescription>
        Remove <strong>john@example.com</strong> from the team?
      </DialogDescription>
    </DialogHeader>

    {/* Show consequences */}
    <div className="rounded-lg bg-muted p-4 text-sm space-y-2">
      <p className="font-medium">This will:</p>
      <ul className="list-disc pl-4 space-y-1 text-muted-foreground">
        <li>Revoke access to all team projects</li>
        <li>Unassign them from 3 active tasks</li>
        <li>Remove them from team chat channels</li>
      </ul>
    </div>

    <DialogFooter>
      <Button variant="outline">Cancel</Button>
      <Button variant="destructive">Remove Member</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

### Critical Severity: Type-to-Confirm

For irreversible, high-impact actions.

```tsx
const [confirmText, setConfirmText] = useState("")
const expectedText = "delete my account"

<Dialog>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Delete your account</DialogTitle>
      <DialogDescription>
        This action is permanent and cannot be undone. All your data, projects,
        and team associations will be permanently deleted.
      </DialogDescription>
    </DialogHeader>

    <div className="space-y-4">
      <Alert variant="destructive">
        <AlertTriangle className="h-4 w-4" />
        <AlertDescription>
          This will delete 12 projects and 847 files.
        </AlertDescription>
      </Alert>

      <div className="space-y-2">
        <Label>
          Type <span className="font-mono font-bold">{expectedText}</span> to confirm
        </Label>
        <Input
          value={confirmText}
          onChange={(e) => setConfirmText(e.target.value)}
          placeholder={expectedText}
        />
      </div>
    </div>

    <DialogFooter>
      <Button variant="outline">Cancel</Button>
      <Button
        variant="destructive"
        disabled={confirmText !== expectedText}
      >
        Permanently Delete Account
      </Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

### Confirmation Microcopy Rules

1. **Title:** Action verb + object ("Delete project", not "Are you sure?")
2. **Description:** Explain consequences in user terms
3. **Primary button:** Match the action verb ("Delete", not "Yes" or "OK")
4. **Cancel button:** "Cancel" or contextual ("Keep editing", "Go back")

## Data Tables & Lists

### CRUD Operation Patterns

#### Create Entry

**Options by complexity:**
1. **Inline add row** — Simple entities, few fields
2. **Modal form** — Moderate complexity (3-7 fields)
3. **Full page** — Complex entities, multiple sections
4. **Drawer** — When user needs table context

```tsx
// Inline add row pattern
<Table>
  <TableBody>
    {items.map(item => <TableRow key={item.id}>...</TableRow>)}

    {/* Inline create row */}
    {isAdding && (
      <TableRow className="bg-muted/50">
        <TableCell>
          <Input
            placeholder="Enter name..."
            autoFocus
            className="h-8"
          />
        </TableCell>
        <TableCell>
          <Select>
            <SelectTrigger className="h-8">
              <SelectValue placeholder="Select type" />
            </SelectTrigger>
            <SelectContent>...</SelectContent>
          </Select>
        </TableCell>
        <TableCell>
          <div className="flex gap-1">
            <Button size="sm" variant="ghost" onClick={() => setIsAdding(false)}>
              <X className="h-4 w-4" />
            </Button>
            <Button size="sm" onClick={handleCreate}>
              <Check className="h-4 w-4" />
            </Button>
          </div>
        </TableCell>
      </TableRow>
    )}
  </TableBody>
</Table>

{/* Add button */}
<Button variant="outline" onClick={() => setIsAdding(true)}>
  <Plus className="mr-2 h-4 w-4" /> Add Item
</Button>
```

#### Read/View

**Row click behavior options:**
1. **Expand inline** — Show details in expandable row
2. **Open drawer** — Side panel with full details
3. **Navigate** — Go to detail page
4. **Select** — For batch operations

```tsx
// Expandable row detail
<TableRow
  className="cursor-pointer hover:bg-muted/50"
  onClick={() => toggleExpand(item.id)}
>
  <TableCell>
    <ChevronRight
      className={cn(
        "h-4 w-4 transition-transform",
        expandedId === item.id && "rotate-90"
      )}
    />
  </TableCell>
  <TableCell>{item.name}</TableCell>
  <TableCell>{item.status}</TableCell>
</TableRow>

{expandedId === item.id && (
  <TableRow>
    <TableCell colSpan={3} className="bg-muted/30 p-4">
      {/* Expanded detail content */}
      <div className="grid grid-cols-2 gap-4 text-sm">
        <div>
          <span className="text-muted-foreground">Created:</span>
          <span className="ml-2">{item.createdAt}</span>
        </div>
        <div>
          <span className="text-muted-foreground">Modified:</span>
          <span className="ml-2">{item.modifiedAt}</span>
        </div>
      </div>
    </TableCell>
  </TableRow>
)}
```

#### Update/Edit

**Inline editing:** Best for simple, independent fields.

```tsx
// Inline editable cell
const [editing, setEditing] = useState<string | null>(null)
const [editValue, setEditValue] = useState("")

<TableCell
  className="cursor-pointer group"
  onClick={() => {
    setEditing(item.id)
    setEditValue(item.name)
  }}
>
  {editing === item.id ? (
    <div className="flex gap-1">
      <Input
        value={editValue}
        onChange={(e) => setEditValue(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === "Enter") saveEdit()
          if (e.key === "Escape") setEditing(null)
        }}
        onBlur={saveEdit}
        autoFocus
        className="h-7"
      />
    </div>
  ) : (
    <span className="group-hover:underline">{item.name}</span>
  )}
</TableCell>
```

**Visual cues for editable fields:**
- Pencil icon on hover
- Subtle border/background on hover
- Cursor change (text cursor)

#### Delete

**Single item:** Row action menu or button
**Bulk delete:** Batch action bar

```tsx
// Row actions dropdown
<DropdownMenu>
  <DropdownMenuTrigger asChild>
    <Button variant="ghost" size="icon" className="h-8 w-8">
      <MoreHorizontal className="h-4 w-4" />
    </Button>
  </DropdownMenuTrigger>
  <DropdownMenuContent align="end">
    <DropdownMenuItem>
      <Edit className="mr-2 h-4 w-4" />
      Edit
    </DropdownMenuItem>
    <DropdownMenuItem>
      <Copy className="mr-2 h-4 w-4" />
      Duplicate
    </DropdownMenuItem>
    <DropdownMenuSeparator />
    <DropdownMenuItem
      className="text-red-600 focus:text-red-600"
      onClick={() => setDeleteTarget(item)}
    >
      <Trash className="mr-2 h-4 w-4" />
      Delete
    </DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>
```

### Batch Actions

Show contextual action bar when items are selected.

```tsx
// Batch action bar (appears on selection)
{selectedIds.length > 0 && (
  <div className="flex items-center gap-4 p-3 bg-muted rounded-lg mb-4">
    <Checkbox
      checked={selectedIds.length === items.length}
      onCheckedChange={handleSelectAll}
    />
    <span className="text-sm font-medium">
      {selectedIds.length} selected
    </span>

    <div className="flex gap-2 ml-auto">
      <Button variant="outline" size="sm">
        <Archive className="mr-2 h-4 w-4" />
        Archive
      </Button>
      <Button variant="outline" size="sm">
        <Tag className="mr-2 h-4 w-4" />
        Add Tag
      </Button>
      <Button variant="destructive" size="sm">
        <Trash className="mr-2 h-4 w-4" />
        Delete
      </Button>
    </div>
  </div>
)}
```

### Empty States

Four types, each needs different treatment:

#### First-Use Empty State (Onboarding)

```tsx
<Card className="flex flex-col items-center justify-center p-12 text-center border-dashed">
  <div className="rounded-full bg-primary/10 p-4">
    <FolderPlus className="h-8 w-8 text-primary" />
  </div>
  <h3 className="mt-4 text-lg font-semibold">Create your first project</h3>
  <p className="mt-2 text-sm text-muted-foreground max-w-sm">
    Projects help you organize your work. Start by creating one to see how it works.
  </p>
  <Button className="mt-6">
    <Plus className="mr-2 h-4 w-4" />
    Create Project
  </Button>

  {/* Optional: Demo content or tutorial link */}
  <Button variant="link" className="mt-2">
    Or explore a demo project
  </Button>
</Card>
```

#### No Results Empty State (Search/Filter)

```tsx
<div className="flex flex-col items-center py-12 text-center">
  <Search className="h-10 w-10 text-muted-foreground/50" />
  <h3 className="mt-4 font-medium">No results found</h3>
  <p className="mt-1 text-sm text-muted-foreground">
    No items match "{searchQuery}"
  </p>
  <div className="mt-4 flex gap-2">
    <Button variant="outline" onClick={() => setSearchQuery("")}>
      Clear search
    </Button>
    <Button variant="outline" onClick={() => clearFilters()}>
      Reset filters
    </Button>
  </div>

  {/* Suggest alternatives */}
  {suggestions.length > 0 && (
    <div className="mt-6">
      <p className="text-sm text-muted-foreground">Did you mean:</p>
      <div className="flex gap-2 mt-2">
        {suggestions.map(s => (
          <Button
            key={s}
            variant="ghost"
            size="sm"
            onClick={() => setSearchQuery(s)}
          >
            {s}
          </Button>
        ))}
      </div>
    </div>
  )}
</div>
```

#### User-Cleared Empty State

```tsx
<div className="flex flex-col items-center py-12 text-center">
  <CheckCircle className="h-10 w-10 text-green-500" />
  <h3 className="mt-4 font-medium">All caught up!</h3>
  <p className="mt-1 text-sm text-muted-foreground">
    You've completed all your tasks.
  </p>
</div>
```

#### Error Empty State

```tsx
<div className="flex flex-col items-center py-12 text-center">
  <AlertCircle className="h-10 w-10 text-red-500" />
  <h3 className="mt-4 font-medium">Failed to load data</h3>
  <p className="mt-1 text-sm text-muted-foreground">
    Something went wrong while loading your projects.
  </p>
  <Button className="mt-4" onClick={retry}>
    <RefreshCw className="mr-2 h-4 w-4" />
    Try Again
  </Button>
</div>
```

### Loading States

#### Skeleton Loading (Preferred)

```tsx
// Table skeleton
<Table>
  <TableHeader>
    <TableRow>
      <TableHead><Skeleton className="h-4 w-24" /></TableHead>
      <TableHead><Skeleton className="h-4 w-20" /></TableHead>
      <TableHead><Skeleton className="h-4 w-16" /></TableHead>
    </TableRow>
  </TableHeader>
  <TableBody>
    {[...Array(5)].map((_, i) => (
      <TableRow key={i}>
        <TableCell><Skeleton className="h-4 w-32" /></TableCell>
        <TableCell><Skeleton className="h-4 w-24" /></TableCell>
        <TableCell><Skeleton className="h-4 w-20" /></TableCell>
      </TableRow>
    ))}
  </TableBody>
</Table>
```

#### Optimistic Updates

Update UI immediately, revert on error.

```tsx
const handleToggleStatus = async (id: string) => {
  // Optimistic update
  setItems(prev => prev.map(item =>
    item.id === id ? { ...item, active: !item.active } : item
  ))

  try {
    await api.toggleStatus(id)
  } catch {
    // Revert on error
    setItems(prev => prev.map(item =>
      item.id === id ? { ...item, active: !item.active } : item
    ))
    toast.error("Failed to update status")
  }
}
```

### Pagination Patterns

#### Standard Pagination

```tsx
<div className="flex items-center justify-between py-4">
  <p className="text-sm text-muted-foreground">
    Showing {start}-{end} of {total} results
  </p>

  <div className="flex items-center gap-2">
    <Button
      variant="outline"
      size="sm"
      disabled={page === 1}
      onClick={() => setPage(p => p - 1)}
    >
      <ChevronLeft className="h-4 w-4" />
      Previous
    </Button>

    {/* Page numbers */}
    <div className="flex gap-1">
      {pages.map(p => (
        <Button
          key={p}
          variant={p === page ? "default" : "ghost"}
          size="sm"
          className="w-8"
          onClick={() => setPage(p)}
        >
          {p}
        </Button>
      ))}
    </div>

    <Button
      variant="outline"
      size="sm"
      disabled={page === totalPages}
      onClick={() => setPage(p => p + 1)}
    >
      Next
      <ChevronRight className="h-4 w-4" />
    </Button>
  </div>
</div>
```

#### Load More Pattern

Better for feeds, activity logs.

```tsx
<div className="space-y-4">
  {items.map(item => <ItemCard key={item.id} item={item} />)}

  {hasMore && (
    <Button
      variant="outline"
      className="w-full"
      onClick={loadMore}
      disabled={loading}
    >
      {loading ? (
        <><Loader2 className="mr-2 h-4 w-4 animate-spin" /> Loading...</>
      ) : (
        <>Load More ({remaining} remaining)</>
      )}
    </Button>
  )}
</div>
```

## SaaS Forms vs Marketing Forms

### Marketing/Landing Page Forms

Optimize for conversion with minimal friction.

```tsx
// Lead capture - minimal fields
<Card className="max-w-sm">
  <CardHeader>
    <CardTitle>Get Early Access</CardTitle>
    <CardDescription>Join 10,000+ users on the waitlist.</CardDescription>
  </CardHeader>
  <CardContent>
    <form className="space-y-4">
      <Input placeholder="Enter your email" type="email" />
      <Button className="w-full">Join Waitlist</Button>
      <p className="text-xs text-center text-muted-foreground">
        No spam, ever. Unsubscribe anytime.
      </p>
    </form>
  </CardContent>
</Card>
```

**Rules:**
- Maximum 3-4 fields
- Single-column always
- High-contrast CTA
- Immediate value proposition
- Social proof nearby

### SaaS/Admin Forms

Optimize for accuracy and efficiency.

```tsx
// Complex entity creation - sectioned layout
<div className="max-w-3xl space-y-8">
  {/* Section: Basic Info */}
  <section className="space-y-4">
    <div>
      <h3 className="font-medium">Basic Information</h3>
      <p className="text-sm text-muted-foreground">
        Enter the core details for this resource.
      </p>
    </div>
    <div className="grid gap-4 sm:grid-cols-2">
      <div className="space-y-2">
        <Label htmlFor="name">Name</Label>
        <Input id="name" />
      </div>
      <div className="space-y-2">
        <Label htmlFor="type">Type</Label>
        <Select>...</Select>
      </div>
    </div>
    <div className="space-y-2">
      <Label htmlFor="description">Description</Label>
      <Textarea id="description" rows={3} />
    </div>
  </section>

  <Separator />

  {/* Section: Configuration */}
  <section className="space-y-4">
    <div>
      <h3 className="font-medium">Configuration</h3>
      <p className="text-sm text-muted-foreground">
        Set up how this resource behaves.
      </p>
    </div>
    {/* More fields */}
  </section>

  {/* Sticky footer on long forms */}
  <div className="sticky bottom-0 flex justify-end gap-3 py-4 bg-background border-t">
    <Button variant="outline">Cancel</Button>
    <Button>Create Resource</Button>
  </div>
</div>
```

**Rules:**
- Group related fields visually
- Multi-column OK for related pairs
- Progressive disclosure (advanced options collapsed)
- Autosave for long forms
- Inline validation
- Clear section headers
- Sticky action buttons on long forms

### Settings Pages

Use description-aside pattern.

```tsx
// Settings section pattern
<div className="space-y-10">
  {/* Each setting section */}
  <div className="grid gap-6 md:grid-cols-[250px_1fr]">
    <div>
      <h3 className="font-medium">Notifications</h3>
      <p className="text-sm text-muted-foreground">
        Configure how and when you receive notifications.
      </p>
    </div>
    <Card>
      <CardContent className="space-y-4 pt-6">
        <div className="flex items-center justify-between">
          <div className="space-y-0.5">
            <Label>Email notifications</Label>
            <p className="text-sm text-muted-foreground">
              Receive emails for important updates.
            </p>
          </div>
          <Switch />
        </div>
        <Separator />
        <div className="flex items-center justify-between">
          <div className="space-y-0.5">
            <Label>Push notifications</Label>
            <p className="text-sm text-muted-foreground">
              Get notified in your browser.
            </p>
          </div>
          <Switch />
        </div>
      </CardContent>
    </Card>
  </div>
</div>
```

## Quick Reference

### Context Checklist

Before designing, ask:

1. **Who uses this?** First-time visitor or power user?
2. **How often?** Once or daily?
3. **What's the cost of error?** Easily undone or permanent?
4. **How much data?** 2 fields or 20?
5. **Need context?** Reference other data while filling?

### Pattern Selection Matrix

| Scenario | Pattern |
|----------|---------|
| Quick create, few fields | Modal or inline |
| Complex create, many fields | Full page |
| Simple edit, 1-2 fields | Inline editing |
| Complex edit | Modal or drawer |
| Need to see list while editing | Drawer |
| Destructive action, reversible | Toast with undo |
| Destructive action, permanent | Confirmation modal |
| Destructive, high-impact | Type-to-confirm |
| Filters/settings | Drawer or sheet |
| First-time empty | Onboarding CTA + illustration |
| No results | Clear filters + suggestions |
