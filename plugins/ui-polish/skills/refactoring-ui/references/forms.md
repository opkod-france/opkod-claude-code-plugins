# Form Design Best Practices

Effective forms bridge the gap between users and conversions. 81% of users abandon forms after starting — design determines success.

## Form Structure

### Single-Column Layout (Always Prefer)

Research shows single-column forms outperform multi-column layouts with fewer errors and higher completion rates.

```tsx
// shadcn/ui - Single column form
<form className="space-y-6 max-w-md">
  <div className="space-y-2">
    <Label htmlFor="name">Full Name</Label>
    <Input id="name" placeholder="Jane Doe" />
  </div>
  <div className="space-y-2">
    <Label htmlFor="email">Email</Label>
    <Input id="email" type="email" placeholder="jane@example.com" />
  </div>
  <div className="space-y-2">
    <Label htmlFor="message">Message</Label>
    <Textarea id="message" placeholder="Your message..." />
  </div>
  <Button type="submit" className="w-full">Submit</Button>
</form>
```

```html
<!-- Plain Tailwind - Single column -->
<form class="space-y-6 max-w-md mx-auto">
  <div class="space-y-1.5">
    <label class="text-sm font-medium">Full Name</label>
    <input class="w-full px-3 py-2 border border-gray-300 rounded-lg
                  focus:outline-none focus:ring-2 focus:ring-blue-500" />
  </div>
  <!-- More fields... -->
</form>
```

**Exception:** Only use multi-column for tightly related pairs (City + State, First + Last name).

```tsx
// Acceptable: related field pairs
<div className="grid grid-cols-2 gap-4">
  <div className="space-y-2">
    <Label htmlFor="firstName">First Name</Label>
    <Input id="firstName" />
  </div>
  <div className="space-y-2">
    <Label htmlFor="lastName">Last Name</Label>
    <Input id="lastName" />
  </div>
</div>
```

### Keep Forms Concise

Only ask for essential information. Every additional field reduces completion rates.

```tsx
// Bad: Too many fields
<>
  <Input placeholder="First name" />
  <Input placeholder="Middle name" />
  <Input placeholder="Last name" />
  <Input placeholder="Nickname" />
  <Input placeholder="Title" />
</>

// Good: Essential only
<>
  <Input placeholder="Full name" />
  <Input placeholder="Email" />
</>
```

### Group Related Fields

Create visual groupings with spacing and optional section headers.

```tsx
// shadcn Card sections
<Card>
  <CardHeader>
    <CardTitle>Personal Information</CardTitle>
  </CardHeader>
  <CardContent className="space-y-4">
    <Input placeholder="Full name" />
    <Input placeholder="Email" />
  </CardContent>
</Card>

<Card className="mt-6">
  <CardHeader>
    <CardTitle>Shipping Address</CardTitle>
  </CardHeader>
  <CardContent className="space-y-4">
    <Input placeholder="Street address" />
    <Input placeholder="City" />
  </CardContent>
</Card>
```

```html
<!-- Plain Tailwind grouping -->
<fieldset class="space-y-4">
  <legend class="text-lg font-medium text-gray-900 mb-4">Personal Information</legend>
  <!-- fields -->
</fieldset>

<fieldset class="space-y-4 mt-8">
  <legend class="text-lg font-medium text-gray-900 mb-4">Payment Details</legend>
  <!-- fields -->
</fieldset>
```

### Question Order Strategy

1. **Start simple** — Name, email (low cognitive load)
2. **Build momentum** — Users commit effort
3. **Sensitive questions last** — After investment in form

## Multi-Step Forms

Break long forms into digestible steps. Multi-step forms can achieve 50%+ conversion rates.

```tsx
// shadcn multi-step with progress
import { Progress } from "@/components/ui/progress"

const steps = ["Account", "Profile", "Preferences"]
const [currentStep, setCurrentStep] = useState(0)

<div className="max-w-lg mx-auto">
  {/* Progress indicator */}
  <div className="mb-8">
    <div className="flex justify-between mb-2">
      {steps.map((step, i) => (
        <span
          key={step}
          className={cn(
            "text-sm font-medium",
            i <= currentStep ? "text-primary" : "text-muted-foreground"
          )}
        >
          {step}
        </span>
      ))}
    </div>
    <Progress value={(currentStep + 1) / steps.length * 100} />
  </div>

  {/* Step content */}
  <Card>
    <CardContent className="pt-6">
      {currentStep === 0 && <AccountFields />}
      {currentStep === 1 && <ProfileFields />}
      {currentStep === 2 && <PreferenceFields />}
    </CardContent>
    <CardFooter className="flex justify-between">
      <Button
        variant="outline"
        onClick={() => setCurrentStep(s => s - 1)}
        disabled={currentStep === 0}
      >
        Back
      </Button>
      <Button onClick={() => setCurrentStep(s => s + 1)}>
        {currentStep === steps.length - 1 ? "Submit" : "Continue"}
      </Button>
    </CardFooter>
  </Card>
</div>
```

```html
<!-- Plain Tailwind progress steps -->
<div class="flex items-center mb-8">
  <div class="flex items-center">
    <span class="w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center text-sm font-medium">1</span>
    <span class="ml-2 text-sm font-medium text-gray-900">Account</span>
  </div>
  <div class="flex-1 h-0.5 mx-4 bg-blue-600"></div>
  <div class="flex items-center">
    <span class="w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center text-sm font-medium">2</span>
    <span class="ml-2 text-sm font-medium text-gray-900">Profile</span>
  </div>
  <div class="flex-1 h-0.5 mx-4 bg-gray-200"></div>
  <div class="flex items-center">
    <span class="w-8 h-8 rounded-full bg-gray-200 text-gray-500 flex items-center justify-center text-sm font-medium">3</span>
    <span class="ml-2 text-sm font-medium text-gray-500">Review</span>
  </div>
</div>
```

**Rule:** Don't split related fields across steps.

## Labels and Instructions

### Always Use Visible Labels

Placeholders disappear when typing — always use persistent labels.

```tsx
// Good: Label + placeholder hint
<div className="space-y-2">
  <Label htmlFor="phone">Phone Number</Label>
  <Input id="phone" placeholder="(555) 123-4567" />
</div>

// Bad: Placeholder only
<Input placeholder="Phone number" />
```

### Format Hints

Show expected formats directly in the UI.

```tsx
<div className="space-y-2">
  <Label htmlFor="dob">Date of Birth</Label>
  <Input id="dob" placeholder="MM/DD/YYYY" />
  <p className="text-sm text-muted-foreground">Format: MM/DD/YYYY</p>
</div>

<div className="space-y-2">
  <Label htmlFor="card">Card Number</Label>
  <Input id="card" placeholder="1234 5678 9012 3456" />
</div>
```

### Helper Text Patterns

```tsx
// Description below label
<div className="space-y-2">
  <Label htmlFor="username">Username</Label>
  <Input id="username" />
  <p className="text-sm text-muted-foreground">
    This will be your public display name.
  </p>
</div>

// Character count
<div className="space-y-2">
  <div className="flex justify-between">
    <Label htmlFor="bio">Bio</Label>
    <span className="text-sm text-muted-foreground">{bio.length}/160</span>
  </div>
  <Textarea id="bio" value={bio} onChange={(e) => setBio(e.target.value)} />
</div>
```

## Inline Validation

Validate as users complete fields — don't wait for submission.

```tsx
// Real-time validation pattern
const [email, setEmail] = useState("")
const [emailError, setEmailError] = useState("")

const validateEmail = (value: string) => {
  if (!value) return "Email is required"
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) return "Please enter a valid email"
  return ""
}

<div className="space-y-2">
  <Label htmlFor="email">Email</Label>
  <Input
    id="email"
    type="email"
    value={email}
    onChange={(e) => setEmail(e.target.value)}
    onBlur={() => setEmailError(validateEmail(email))}
    className={cn(emailError && "border-red-500 focus:ring-red-500")}
  />
  {emailError && (
    <p className="text-sm text-red-500 flex items-center gap-1">
      <AlertCircle className="h-4 w-4" />
      {emailError}
    </p>
  )}
</div>
```

```html
<!-- Plain Tailwind validation states -->
<!-- Default -->
<input class="border border-gray-300 focus:ring-blue-500 focus:border-blue-500 rounded-lg px-3 py-2" />

<!-- Error -->
<input class="border border-red-500 focus:ring-red-500 focus:border-red-500 rounded-lg px-3 py-2" />
<p class="mt-1 text-sm text-red-500">Please enter a valid email address</p>

<!-- Success -->
<input class="border border-green-500 focus:ring-green-500 rounded-lg px-3 py-2" />
<p class="mt-1 text-sm text-green-600 flex items-center gap-1">
  <svg class="w-4 h-4"><!-- check icon --></svg>
  Looks good!
</p>
```

### Validation Timing

- **On blur:** Validate when user leaves field
- **On change (after error):** Clear error immediately when fixed
- **On submit:** Final validation before sending

## Visual Feedback

### Active Field Indication

```css
/* Focus ring - highly visible */
input:focus {
  @apply outline-none ring-2 ring-blue-500 border-blue-500;
}

/* Subtle background change */
input:focus {
  @apply bg-blue-50/50;
}
```

### Button States

```tsx
// Loading state
<Button disabled>
  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
  Submitting...
</Button>

// Success state
<Button className="bg-green-600 hover:bg-green-700">
  <Check className="mr-2 h-4 w-4" />
  Submitted!
</Button>
```

### Interactive Icons

Use icons to clarify field purpose.

```tsx
<div className="relative">
  <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
  <Input className="pl-10" placeholder="Email address" />
</div>

<div className="relative">
  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
  <Input className="pl-10" type="password" placeholder="Password" />
</div>

<div className="relative">
  <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
  <Input className="pl-10" placeholder="Search..." />
</div>
```

## Mobile Optimization

### Touch-Friendly Targets

Minimum 44x44px touch targets (Apple HIG).

```html
<!-- Good: Large touch target -->
<input class="w-full h-12 px-4 text-base" />
<button class="h-12 px-6 text-base">Submit</button>

<!-- Good: Checkbox with large tap area -->
<label class="flex items-center gap-3 p-3 -m-3 cursor-pointer">
  <input type="checkbox" class="w-5 h-5" />
  <span>Remember me</span>
</label>
```

### Input Types for Mobile Keyboards

```tsx
// Triggers numeric keypad
<Input type="tel" inputMode="tel" />

// Triggers email keyboard with @ visible
<Input type="email" inputMode="email" />

// Numeric input
<Input type="text" inputMode="numeric" pattern="[0-9]*" />

// URL keyboard
<Input type="url" inputMode="url" />
```

### Mobile-Friendly Selects

```tsx
// Native select works better on mobile
<select className="w-full h-12 px-3 border border-gray-300 rounded-lg bg-white">
  <option>Select country</option>
  <option>United States</option>
  <option>Canada</option>
</select>

// Or shadcn Select (styled, accessible)
<Select>
  <SelectTrigger className="h-12">
    <SelectValue placeholder="Select country" />
  </SelectTrigger>
  <SelectContent>
    <SelectItem value="us">United States</SelectItem>
    <SelectItem value="ca">Canada</SelectItem>
  </SelectContent>
</Select>
```

### Responsive Form Layout

```tsx
<form className="space-y-4 px-4 sm:px-0 max-w-lg mx-auto">
  {/* Full width on mobile, constrained on desktop */}
  <div className="space-y-2">
    <Label>Email</Label>
    <Input className="h-12 sm:h-10" />
  </div>

  {/* Stack buttons on mobile, inline on desktop */}
  <div className="flex flex-col sm:flex-row gap-3 pt-4">
    <Button variant="outline" className="sm:flex-1 h-12 sm:h-10">Cancel</Button>
    <Button className="sm:flex-1 h-12 sm:h-10">Submit</Button>
  </div>
</form>
```

## Trust and Security

### Privacy Communication

```tsx
<form className="space-y-4">
  {/* Fields */}

  <div className="flex items-start gap-2">
    <Checkbox id="marketing" />
    <Label htmlFor="marketing" className="text-sm font-normal leading-relaxed">
      I'd like to receive updates about products and promotions
    </Label>
  </div>

  <p className="text-xs text-muted-foreground">
    By submitting, you agree to our{" "}
    <a href="/privacy" className="underline hover:text-foreground">Privacy Policy</a>.
    We'll never share your information.
  </p>

  <Button type="submit">Create Account</Button>
</form>
```

### Security Indicators

```tsx
// Secure form indicator
<div className="flex items-center gap-2 text-sm text-muted-foreground mb-4">
  <Lock className="h-4 w-4" />
  <span>256-bit SSL encrypted</span>
</div>

// Payment security badges
<div className="flex items-center gap-4 mt-6 pt-4 border-t">
  <img src="/visa.svg" alt="Visa" className="h-6" />
  <img src="/mastercard.svg" alt="Mastercard" className="h-6" />
  <div className="flex items-center gap-1 text-sm text-muted-foreground">
    <Shield className="h-4 w-4" />
    <span>Secure checkout</span>
  </div>
</div>
```

### User-Friendly CAPTCHA

Place CAPTCHA after user investment, use lightweight options.

```tsx
// reCAPTCHA v3 (invisible) - preferred
// Or checkbox CAPTCHA at end of form
<div className="space-y-4">
  {/* All form fields first */}

  <div className="g-recaptcha" data-sitekey="..." />

  <Button type="submit">Submit</Button>
</div>
```

## Submission and Feedback

### Clear Call-to-Action

```tsx
// Specific action verbs
<Button>Create Account</Button>
<Button>Submit Application</Button>
<Button>Send Message</Button>
<Button>Complete Purchase</Button>

// Avoid generic
<Button>Submit</Button>  // Less clear
<Button>Send</Button>    // What are we sending?
```

### Success Feedback

```tsx
// Inline success message
const [submitted, setSubmitted] = useState(false)

{submitted ? (
  <Card className="text-center py-8">
    <CheckCircle className="mx-auto h-12 w-12 text-green-500" />
    <h3 className="mt-4 text-lg font-semibold">Message Sent!</h3>
    <p className="mt-2 text-muted-foreground">
      We'll get back to you within 24 hours.
    </p>
    <Button variant="outline" className="mt-6" onClick={() => setSubmitted(false)}>
      Send Another
    </Button>
  </Card>
) : (
  <form>{/* form fields */}</form>
)}
```

### Error Summary

For complex forms, show error summary at top.

```tsx
{errors.length > 0 && (
  <Alert variant="destructive" className="mb-6">
    <AlertCircle className="h-4 w-4" />
    <AlertTitle>Please fix the following errors:</AlertTitle>
    <AlertDescription>
      <ul className="list-disc pl-4 mt-2 space-y-1">
        {errors.map((error, i) => (
          <li key={i}>{error}</li>
        ))}
      </ul>
    </AlertDescription>
  </Alert>
)}
```

## Accessibility Requirements

### Color Contrast

- Normal text: minimum 4.5:1 ratio
- Large text (18px+): minimum 3:1 ratio
- Use WebAIM Contrast Checker

### Don't Rely on Color Alone

```tsx
// Bad: Color only
<Input className={error ? "border-red-500" : ""} />

// Good: Color + icon + text
<div className="space-y-2">
  <Input className={cn(error && "border-red-500")} aria-invalid={!!error} />
  {error && (
    <p className="text-sm text-red-500 flex items-center gap-1" role="alert">
      <AlertCircle className="h-4 w-4" />
      {error}
    </p>
  )}
</div>
```

### Required Field Indicators

```tsx
// Visible indicator + aria
<Label htmlFor="email">
  Email <span className="text-red-500" aria-hidden="true">*</span>
  <span className="sr-only">(required)</span>
</Label>
<Input id="email" required aria-required="true" />

// Or list required fields
<p className="text-sm text-muted-foreground mb-4">
  Fields marked with <span className="text-red-500">*</span> are required
</p>
```

### Keyboard Navigation

- All fields focusable via Tab
- Logical tab order (visual order = DOM order)
- Visible focus indicators
- Enter submits form

## Form Types Reference

### Registration Form
```tsx
<Card className="max-w-md mx-auto">
  <CardHeader>
    <CardTitle>Create Account</CardTitle>
    <CardDescription>Enter your details to get started.</CardDescription>
  </CardHeader>
  <CardContent className="space-y-4">
    <div className="space-y-2">
      <Label htmlFor="name">Full Name</Label>
      <Input id="name" />
    </div>
    <div className="space-y-2">
      <Label htmlFor="email">Email</Label>
      <Input id="email" type="email" />
    </div>
    <div className="space-y-2">
      <Label htmlFor="password">Password</Label>
      <Input id="password" type="password" />
      <p className="text-xs text-muted-foreground">
        At least 8 characters with a number
      </p>
    </div>
  </CardContent>
  <CardFooter className="flex flex-col gap-4">
    <Button className="w-full">Create Account</Button>
    <p className="text-sm text-center text-muted-foreground">
      Already have an account? <a href="/login" className="underline">Sign in</a>
    </p>
  </CardFooter>
</Card>
```

### Contact Form
```tsx
<form className="space-y-4 max-w-lg">
  <div className="grid sm:grid-cols-2 gap-4">
    <div className="space-y-2">
      <Label htmlFor="firstName">First Name</Label>
      <Input id="firstName" />
    </div>
    <div className="space-y-2">
      <Label htmlFor="lastName">Last Name</Label>
      <Input id="lastName" />
    </div>
  </div>
  <div className="space-y-2">
    <Label htmlFor="email">Email</Label>
    <Input id="email" type="email" />
  </div>
  <div className="space-y-2">
    <Label htmlFor="subject">Subject</Label>
    <Select>
      <SelectTrigger>
        <SelectValue placeholder="Select a topic" />
      </SelectTrigger>
      <SelectContent>
        <SelectItem value="support">Support</SelectItem>
        <SelectItem value="sales">Sales</SelectItem>
        <SelectItem value="other">Other</SelectItem>
      </SelectContent>
    </Select>
  </div>
  <div className="space-y-2">
    <Label htmlFor="message">Message</Label>
    <Textarea id="message" rows={5} />
  </div>
  <Button type="submit">Send Message</Button>
</form>
```

### Checkout Form
```tsx
<div className="grid lg:grid-cols-2 gap-8">
  <div className="space-y-6">
    {/* Shipping */}
    <Card>
      <CardHeader>
        <CardTitle className="text-lg">Shipping Address</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <Input placeholder="Full name" />
        <Input placeholder="Address line 1" />
        <Input placeholder="Address line 2 (optional)" />
        <div className="grid grid-cols-2 gap-4">
          <Input placeholder="City" />
          <Input placeholder="ZIP code" />
        </div>
      </CardContent>
    </Card>

    {/* Payment */}
    <Card>
      <CardHeader>
        <CardTitle className="text-lg">Payment</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <Input placeholder="Card number" />
        <div className="grid grid-cols-2 gap-4">
          <Input placeholder="MM/YY" />
          <Input placeholder="CVC" />
        </div>
      </CardContent>
    </Card>
  </div>

  {/* Order summary sidebar */}
  <Card className="h-fit">
    <CardHeader>
      <CardTitle className="text-lg">Order Summary</CardTitle>
    </CardHeader>
    <CardContent>{/* items */}</CardContent>
    <CardFooter>
      <Button className="w-full">Complete Purchase</Button>
    </CardFooter>
  </Card>
</div>
```

## Anti-Patterns

- **Placeholder-only labels** — Disappear on input, fail accessibility
- **Multi-column layouts** — Confuse users, increase errors
- **Generic submit buttons** — "Submit" vs "Create Account"
- **Delayed validation** — Wait for blur, not keystroke
- **Pre-checked opt-ins** — Often illegal, always annoying
- **Asking unnecessary info** — Each field reduces completion
- **Tiny touch targets** — Under 44px frustrates mobile users
- **Color-only errors** — Fails accessibility, use icons + text
- **Hidden required indicators** — Users shouldn't guess
- **No progress on long forms** — Users abandon without visibility
