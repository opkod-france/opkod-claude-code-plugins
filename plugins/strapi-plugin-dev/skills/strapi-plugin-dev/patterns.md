# Strapi v5 Advanced Patterns

## Lifecycle Hooks

### Plugin Lifecycle

```typescript
// server/src/register.ts - Runs before bootstrap
export default ({ strapi }: { strapi: Core.Strapi }) => {
  // Extend core services
  strapi.service('api::article.article').customMethod = async () => {
    // Custom logic
  };
};

// server/src/bootstrap.ts - Runs after all plugins registered
export default async ({ strapi }: { strapi: Core.Strapi }) => {
  // Seed data, set up listeners, etc.
  const existingSettings = await strapi
    .documents('plugin::my-plugin.settings')
    .findFirst();

  if (!existingSettings) {
    await strapi.documents('plugin::my-plugin.settings').create({
      data: { enabled: true },
    });
  }
};

// server/src/destroy.ts - Cleanup on shutdown
export default async ({ strapi }: { strapi: Core.Strapi }) => {
  // Close connections, cleanup resources
};
```

### Content-Type Lifecycle Hooks

```typescript
// server/src/content-types/article/lifecycles.ts
export default {
  async beforeCreate(event) {
    const { data } = event.params;
    // Modify data before creation
    if (!data.slug && data.title) {
      data.slug = slugify(data.title);
    }
  },

  async afterCreate(event) {
    const { result } = event;
    // Trigger side effects
    await strapi.service('plugin::my-plugin.notifications').send({
      type: 'new-article',
      articleId: result.documentId,
    });
  },

  async beforeUpdate(event) {
    const { data, where } = event.params;
    // Validation or transformation
  },

  async afterUpdate(event) {
    const { result } = event;
    // Cache invalidation, webhooks, etc.
  },

  async beforeDelete(event) {
    const { where } = event.params;
    // Cleanup related data
  },

  async afterDelete(event) {
    // Post-deletion cleanup
  },
};
```

## Query Patterns

### Filtering

```typescript
// Complex filters
const articles = await strapi.documents('api::article.article').findMany({
  filters: {
    $and: [
      { publishedAt: { $notNull: true } },
      { title: { $containsi: 'strapi' } },
      {
        $or: [
          { category: { name: { $eq: 'Tech' } } },
          { featured: { $eq: true } },
        ],
      },
    ],
  },
});

// Filter operators
// $eq, $ne, $in, $notIn, $lt, $lte, $gt, $gte
// $contains, $containsi, $notContains, $notContainsi
// $startsWith, $endsWith, $null, $notNull
// $between, $and, $or, $not
```

### Population Strategies

```typescript
// Selective population
const article = await strapi.documents('api::article.article').findOne({
  documentId: 'abc123',
  populate: {
    author: {
      fields: ['username', 'email'],
    },
    categories: {
      fields: ['name', 'slug'],
      filters: { active: true },
    },
    cover: true, // Simple populate
  },
});

// Deep population
const article = await strapi.documents('api::article.article').findOne({
  documentId: 'abc123',
  populate: {
    author: {
      populate: {
        avatar: true,
        role: {
          fields: ['name'],
        },
      },
    },
  },
});

// Dynamic zone population
const page = await strapi.documents('api::page.page').findOne({
  documentId: 'xyz789',
  populate: {
    blocks: {
      on: {
        'blocks.hero': { populate: ['image'] },
        'blocks.rich-text': true,
        'blocks.cta': { populate: ['link'] },
      },
    },
  },
});
```

### Pagination

```typescript
// Offset pagination
const { results, pagination } = await strapi
  .documents('api::article.article')
  .findMany({
    status: 'published',
    limit: 10,
    start: 20,
  });

// In controllers, use pagination helper
async findMany(ctx) {
  const { page = 1, pageSize = 25 } = ctx.query;

  const start = (page - 1) * pageSize;
  const limit = Math.min(pageSize, 100); // Cap at 100

  const [results, total] = await Promise.all([
    strapi.documents('api::article.article').findMany({
      start,
      limit,
      status: 'published',
    }),
    strapi.documents('api::article.article').count({
      status: 'published',
    }),
  ]);

  return {
    data: results,
    meta: {
      pagination: {
        page,
        pageSize: limit,
        pageCount: Math.ceil(total / limit),
        total,
      },
    },
  };
}
```

## Middleware Patterns

### Global Middleware

```typescript
// server/src/middlewares/request-logger.ts
export default (config, { strapi }) => {
  return async (ctx, next) => {
    const start = Date.now();

    await next();

    const duration = Date.now() - start;
    strapi.log.info(`${ctx.method} ${ctx.url} - ${duration}ms`);
  };
};
```

### Route-Specific Middleware

```typescript
// In routes definition
{
  method: 'GET',
  path: '/items',
  handler: 'item.findMany',
  config: {
    middlewares: ['plugin::my-plugin.rate-limit'],
  },
}

// server/src/middlewares/rate-limit.ts
export default (config, { strapi }) => {
  const requests = new Map();

  return async (ctx, next) => {
    const ip = ctx.ip;
    const now = Date.now();
    const windowMs = config.windowMs || 60000;
    const max = config.max || 100;

    // Simple rate limiting logic
    const userRequests = requests.get(ip) || [];
    const recentRequests = userRequests.filter(t => now - t < windowMs);

    if (recentRequests.length >= max) {
      return ctx.throw(429, 'Too many requests');
    }

    recentRequests.push(now);
    requests.set(ip, recentRequests);

    await next();
  };
};
```

## Custom Field Pattern

```typescript
// server/src/register.ts
export default ({ strapi }: { strapi: Core.Strapi }) => {
  strapi.customFields.register({
    name: 'color-picker',
    plugin: 'my-plugin',
    type: 'string',
    inputSize: {
      default: 4,
      isResizable: true,
    },
  });
};

// admin/src/index.tsx
app.customFields.register({
  name: 'color-picker',
  pluginId: 'my-plugin',
  type: 'string',
  intlLabel: {
    id: 'my-plugin.color-picker.label',
    defaultMessage: 'Color Picker',
  },
  intlDescription: {
    id: 'my-plugin.color-picker.description',
    defaultMessage: 'Select a color',
  },
  components: {
    Input: async () => import('./components/ColorPickerInput'),
  },
  options: {
    base: [
      {
        name: 'options.format',
        type: 'select',
        intlLabel: { id: 'color-picker.format', defaultMessage: 'Format' },
        options: [
          { value: 'hex', label: 'HEX' },
          { value: 'rgb', label: 'RGB' },
        ],
      },
    ],
  },
});
```

## Injection Zones

```typescript
// admin/src/index.tsx
export default {
  bootstrap(app) {
    // Inject into Content Manager edit view
    app.getPlugin('content-manager').injectComponent('editView', 'right-links', {
      name: 'my-plugin-preview',
      Component: () => import('./components/PreviewButton'),
    });

    // Inject into Content Manager list view
    app.getPlugin('content-manager').injectComponent('listView', 'actions', {
      name: 'my-plugin-bulk-action',
      Component: () => import('./components/BulkAction'),
    });
  },
};
```

## Service Composition Pattern

```typescript
// server/src/services/article.ts
const articleService = ({ strapi }: { strapi: Core.Strapi }) => ({
  // Core CRUD wrapping Document Service
  async findPublished(options = {}) {
    return strapi.documents('api::article.article').findMany({
      ...options,
      status: 'published',
    });
  },

  // Business logic methods
  async publishWithNotification(documentId: string) {
    const article = await strapi.documents('api::article.article').publish({
      documentId,
    });

    // Compose with other services
    await strapi.service('plugin::my-plugin.notification').send({
      type: 'article-published',
      data: article,
    });

    await strapi.service('plugin::my-plugin.cache').invalidate(`article:${documentId}`);

    return article;
  },

  // Aggregation methods
  async getStats() {
    const [total, published, draft] = await Promise.all([
      strapi.documents('api::article.article').count({}),
      strapi.documents('api::article.article').count({ status: 'published' }),
      strapi.documents('api::article.article').count({ status: 'draft' }),
    ]);

    return { total, published, draft };
  },
});

export default articleService;
```

## Error Handling Pattern

```typescript
// server/src/utils/errors.ts
import { errors } from '@strapi/utils';

const { ApplicationError, NotFoundError, ForbiddenError } = errors;

export class PluginError extends ApplicationError {
  constructor(message: string, details?: object) {
    super(message, details);
    this.name = 'PluginError';
  }
}

// Usage in controllers
async findOne(ctx) {
  const { id } = ctx.params;

  const item = await strapi.documents('plugin::my-plugin.item').findOne({
    documentId: id,
  });

  if (!item) {
    throw new NotFoundError(`Item with id ${id} not found`);
  }

  if (item.private && ctx.state.user?.id !== item.owner?.id) {
    throw new ForbiddenError('You do not have access to this item');
  }

  return { data: item };
}
```

## TypeScript Patterns

### Typed Services

```typescript
// server/src/services/index.ts
import type { Core } from '@strapi/strapi';
import itemService from './item';

export default {
  item: itemService,
};

// Type augmentation for strapi.service()
declare module '@strapi/strapi' {
  interface Services {
    'plugin::my-plugin.item': ReturnType<typeof itemService>;
  }
}
```

### Typed Content-Types

```typescript
// After running: strapi ts:generate-types
import type { Struct, Schema } from '@strapi/strapi';

// Auto-generated types in types/generated/contentTypes.d.ts
export interface PluginMyPluginItem extends Struct.CollectionTypeSchema {
  collectionName: 'items';
  info: {
    singularName: 'item';
    pluralName: 'items';
    displayName: 'Item';
  };
  attributes: {
    title: Schema.Attribute.String & Schema.Attribute.Required;
    slug: Schema.Attribute.UID<'title'>;
    content: Schema.Attribute.RichText;
  };
}
```

## Cron Jobs

```typescript
// server/src/config/index.ts
export default {
  default: {},
  validator: () => {},
};

// config/cron-tasks.ts (in main Strapi app)
export default {
  '*/5 * * * *': async ({ strapi }) => {
    // Run every 5 minutes
    await strapi.service('plugin::my-plugin.sync').run();
  },

  '0 0 * * *': async ({ strapi }) => {
    // Run daily at midnight
    await strapi.service('plugin::my-plugin.cleanup').oldDrafts();
  },
};
```

## Webhook Pattern

```typescript
// server/src/services/webhook.ts
const webhookService = ({ strapi }: { strapi: Core.Strapi }) => ({
  async trigger(event: string, payload: object) {
    const settings = await strapi
      .documents('plugin::my-plugin.settings')
      .findFirst();

    if (!settings?.webhookUrl) {
      return;
    }

    try {
      await fetch(settings.webhookUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Webhook-Event': event,
        },
        body: JSON.stringify({
          event,
          timestamp: new Date().toISOString(),
          data: payload,
        }),
      });
    } catch (error) {
      strapi.log.error(`Webhook failed for event ${event}:`, error);
    }
  },
});

export default webhookService;
```

---

## React Query Pattern (plugin-todo)

The recommended approach for admin panel data fetching using `@tanstack/react-query`.

### Query Client Setup

```tsx
// admin/src/components/MyPanel.tsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

const queryClient = new QueryClient();

export const MyPanel = () => {
  return (
    <QueryClientProvider client={queryClient}>
      <MyContent />
    </QueryClientProvider>
  );
};
```

### Data Fetching with useQuery

```tsx
// admin/src/components/TaskList.tsx
import { useQuery } from '@tanstack/react-query';
import { useFetchClient, unstable_useContentManagerContext } from '@strapi/strapi/admin';

export const TaskList = () => {
  const { get } = useFetchClient();
  const { slug, id } = unstable_useContentManagerContext();

  const { data: tasks, isLoading, error } = useQuery({
    queryKey: ['tasks', slug, id],
    queryFn: () => get(`/todo/tasks/related/${slug}/${id}`).then((res) => res.data),
    enabled: !!id, // Only fetch when id exists
  });

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error loading tasks</div>;

  return (
    <ul>
      {tasks?.map((task: any) => (
        <li key={task.id}>{task.name}</li>
      ))}
    </ul>
  );
};
```

### Mutations with Cache Invalidation

```tsx
// admin/src/components/TaskList.tsx
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, unstable_useContentManagerContext } from '@strapi/strapi/admin';
import { Checkbox } from '@strapi/design-system';

export const TaskList = () => {
  const { get, put } = useFetchClient();
  const { slug, id } = unstable_useContentManagerContext();
  const queryClient = useQueryClient();

  const { data: tasks } = useQuery({
    queryKey: ['tasks', slug, id],
    queryFn: () => get(`/todo/tasks/related/${slug}/${id}`).then((res) => res.data),
  });

  const toggleMutation = useMutation({
    mutationFn: (task: any) =>
      put(`/todo/tasks/${task.documentId}`, { data: { done: !task.done } }),
    onSuccess: () => {
      // Invalidate and refetch
      queryClient.invalidateQueries({ queryKey: ['tasks', slug, id] });
    },
  });

  return (
    <ul>
      {tasks?.map((task: any) => (
        <li key={task.id}>
          <Checkbox
            checked={task.done}
            onCheckedChange={() => toggleMutation.mutate(task)}
          >
            {task.name}
          </Checkbox>
        </li>
      ))}
    </ul>
  );
};
```

### Create Mutation with Modal

```tsx
// admin/src/components/TodoModal.tsx
import { useState } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, unstable_useContentManagerContext } from '@strapi/strapi/admin';
import { Dialog, TextInput, Button } from '@strapi/design-system';

interface Props {
  open: boolean;
  setOpen: (open: boolean) => void;
}

export const TodoModal = ({ open, setOpen }: Props) => {
  const [taskName, setTaskName] = useState('');
  const { post } = useFetchClient();
  const { id, model } = unstable_useContentManagerContext();
  const queryClient = useQueryClient();

  const createMutation = useMutation({
    mutationFn: () =>
      post('/todo/tasks', {
        data: {
          name: taskName,
          related: [{ __type: model, id }],
        },
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['tasks'] });
      setTaskName('');
      setOpen(false);
    },
  });

  return (
    <Dialog.Root open={open} onOpenChange={setOpen}>
      <Dialog.Content>
        <Dialog.Header>Add Task</Dialog.Header>
        <Dialog.Body>
          <TextInput
            label="Task name"
            value={taskName}
            onChange={(e) => setTaskName(e.target.value)}
          />
        </Dialog.Body>
        <Dialog.Footer>
          <Dialog.Cancel>
            <Button variant="tertiary">Cancel</Button>
          </Dialog.Cancel>
          <Dialog.Action>
            <Button
              onClick={() => createMutation.mutate()}
              disabled={!taskName || createMutation.isPending}
            >
              Confirm
            </Button>
          </Dialog.Action>
        </Dialog.Footer>
      </Dialog.Content>
    </Dialog.Root>
  );
};
```

## Content Manager Integration Pattern

### Injecting Components into Edit View

```typescript
// admin/src/index.ts
export default {
  bootstrap(app: any) {
    // Add panel to right sidebar of edit view
    app.getPlugin('content-manager').injectComponent('editView', 'right-links', {
      name: 'my-plugin-panel',
      Component: MyPanel,
    });
  },
};
```

### Available Injection Zones

| Zone | Location |
|------|----------|
| `editView.right-links` | Right sidebar of content edit view |
| `editView.informations` | Information panel in edit view |
| `listView.actions` | Actions area in list view |
| `listView.deleteModalAdditionalInfos` | Additional info in delete modal |

### Using Content Manager Context

```tsx
import { unstable_useContentManagerContext } from '@strapi/strapi/admin';

const MyComponent = () => {
  const {
    id,           // Current document ID (null if creating new)
    slug,         // Content type slug (e.g., 'api::article.article')
    model,        // Content type model name
    isCreatingEntry,
    hasDraftAndPublish,
  } = unstable_useContentManagerContext();

  return (
    <div>
      {id ? `Editing: ${id}` : 'Creating new entry'}
    </div>
  );
};
```

## Polymorphic Relations Pattern

### Schema with morphToMany

```json
{
  "attributes": {
    "related": {
      "type": "relation",
      "relation": "morphToMany"
    }
  }
}
```

### Querying Polymorphic Relations

```typescript
// server/src/services/task.ts
import { factories } from '@strapi/strapi';

export default factories.createCoreService('plugin::todo.task', ({ strapi }) => ({
  async findRelatedTasks(relatedId: string, relatedType: string) {
    // Query the junction table directly
    const relatedTasks = await strapi.db
      .query('tasks_related_mph')
      .findMany({
        where: {
          related_id: relatedId,
          related_type: relatedType,
        },
      });

    const taskIds = relatedTasks.map((t) => t.task_id);

    // Fetch full task documents
    return strapi.documents('plugin::todo.task').findMany({
      filters: { id: { $in: taskIds } },
    });
  },
}));
```

### Creating with Polymorphic Relation

```typescript
// Creating a task related to an article
await strapi.documents('plugin::todo.task').create({
  data: {
    name: 'Review article',
    done: false,
    related: [
      {
        __type: 'api::article.article',
        id: articleId,
      },
    ],
  },
});
```

## Factory Pattern Deep Dive

### createCoreService

```typescript
import { factories } from '@strapi/strapi';

// Minimal - just use core CRUD
export default factories.createCoreService('plugin::my-plugin.item');

// Extended - add custom methods
export default factories.createCoreService('plugin::my-plugin.item', ({ strapi }) => ({
  // Custom method
  async findActive() {
    return strapi.documents('plugin::my-plugin.item').findMany({
      filters: { active: true },
    });
  },

  // Override core method
  async findOne(documentId: string) {
    const item = await super.findOne(documentId);
    // Add custom logic
    return { ...item, customField: 'value' };
  },
}));
```

### createCoreController

```typescript
import { factories } from '@strapi/strapi';

// Minimal - standard CRUD endpoints
export default factories.createCoreController('plugin::my-plugin.item');

// Extended - add custom endpoints
export default factories.createCoreController('plugin::my-plugin.item', ({ strapi }) => ({
  // Custom endpoint handler
  async findActive(ctx) {
    const items = await strapi
      .service('plugin::my-plugin.item')
      .findActive();

    ctx.body = { data: items };
  },

  // Override core endpoint
  async find(ctx) {
    // Add custom logic before
    const result = await super.find(ctx);
    // Add custom logic after
    return result;
  },
}));
```

### createCoreRouter

```typescript
import { factories } from '@strapi/strapi';

// Creates standard REST routes: GET, POST, GET/:id, PUT/:id, DELETE/:id
export default factories.createCoreRouter('plugin::my-plugin.item');

// The generated routes object has a .routes property that can be spread
// into custom route definitions
```

## Server Index Pattern (plugin-todo)

```typescript
// server/src/index.ts
import controllers from './controllers';
import routes from './routes';
import services from './services';
import contentTypes from './content-types';

export default {
  controllers,
  routes,
  services,
  contentTypes,
};
```

```typescript
// server/src/services/index.ts
import task from './task';

export default {
  task,
};
```

```typescript
// server/src/controllers/index.ts
import task from './task';

export default {
  task,
};
```

## Plugin Initializer Pattern

```tsx
// admin/src/components/Initializer.tsx
import { useEffect, useRef } from 'react';
import { PLUGIN_ID } from '../pluginId';

interface Props {
  setPlugin: (id: string) => void;
}

export const Initializer = ({ setPlugin }: Props) => {
  const ref = useRef(setPlugin);

  useEffect(() => {
    ref.current(PLUGIN_ID);
  }, []);

  return null;
};
```

---

## Strapi Design System v2 Patterns

The Strapi Design System v2 (`@strapi/design-system` ^2.0.0) uses compound component patterns extensively. These patterns are based on real usage in production plugins like [pluginpal/strapi-webtools](https://github.com/pluginpal/strapi-webtools).

### Page Layouts

```tsx
import { Layouts, Page } from '@strapi/strapi/admin';

// Full page with sidebar navigation
<Layouts.Root sideNav={<SubNav>...</SubNav>}>
  <Routes>...</Routes>
</Layouts.Root>

// Page header with actions and back button
<Layouts.Header
  title="URL patterns"
  subtitle="A list of all the known URL alias patterns."
  primaryAction={
    <Button onClick={handleCreate} startIcon={<Plus />}>
      Add new pattern
    </Button>
  }
  navigationAction={
    <DsLink startIcon={<ArrowLeft />} tag={Link} to="/plugins/my-plugin">
      Back
    </DsLink>
  }
/>

// Page content area
<Layouts.Content>
  {/* page body */}
</Layouts.Content>

// Page states
<Page.Loading />
<Page.Error />
<Page.Protect permissions={pluginPermissions['settings.patterns']}>
  {/* protected content */}
</Page.Protect>
```

### Sub-Navigation (Sidebar)

```tsx
import {
  SubNav, SubNavHeader, SubNavSections, SubNavSection, SubNavLink,
} from '@strapi/design-system';
import { Link } from 'react-router-dom';

<SubNav>
  <SubNavHeader value="" label="My Plugin" />
  <SubNavSections>
    <SubNavSection label="Settings">
      <SubNavLink tag={Link} to="/plugins/my-plugin">
        Overview
      </SubNavLink>
      <SubNavLink tag={Link} to="/plugins/my-plugin/patterns">
        Patterns
      </SubNavLink>
    </SubNavSection>
  </SubNavSections>
</SubNav>
```

### Tables

```tsx
import {
  Table, Tr, Thead, Th, Tbody, Td,
  Typography, VisuallyHidden, EmptyStateLayout,
  Flex, IconButton,
} from '@strapi/design-system';
import { Pencil, Trash } from '@strapi/icons';

<Table colCount={3} rowCount={items.length + 1}>
  <Thead>
    <Tr>
      <Th>
        <Typography variant="sigma" textColor="neutral600">Name</Typography>
      </Th>
      <Th>
        <VisuallyHidden>Actions</VisuallyHidden>
      </Th>
    </Tr>
  </Thead>
  <Tbody>
    {items.map((item) => (
      <Tr key={item.id}>
        <Td><Typography>{item.name}</Typography></Td>
        <Td>
          <Flex justifyContent="end" gap={2}>
            <IconButton onClick={() => handleEdit(item)} label="Edit">
              <Pencil />
            </IconButton>
            <IconButton onClick={() => handleDelete(item)} label="Delete">
              <Trash />
            </IconButton>
          </Flex>
        </Td>
      </Tr>
    ))}
  </Tbody>
</Table>

// Empty state
<EmptyStateLayout
  content="You don't have any items yet."
  shadow="tableShadow"
  hasRadius
  action={<Button variant="secondary" onClick={handleCreate}>Create first item</Button>}
/>
```

### Modal (Compound Component)

```tsx
import { Modal, Button, Typography } from '@strapi/design-system';

<Modal.Root open={open} onOpenChange={setOpen}>
  <Modal.Trigger>
    <Button>Edit</Button>
  </Modal.Trigger>
  <Modal.Content>
    <Modal.Header>
      <Typography textColor="neutral800" variant="omega" fontWeight="bold">
        Edit Item
      </Typography>
    </Modal.Header>
    <Modal.Body>
      {/* form content */}
    </Modal.Body>
    <Modal.Footer>
      <Modal.Close>
        <Button variant="tertiary">Cancel</Button>
      </Modal.Close>
      <Button loading={submitting} onClick={handleSubmit}>
        Save
      </Button>
    </Modal.Footer>
  </Modal.Content>
</Modal.Root>
```

### Dialog (Confirm Actions)

```tsx
import { Dialog, Button, Typography } from '@strapi/design-system';
import { WarningCircle } from '@strapi/icons';

<Dialog.Root>
  <Dialog.Trigger>{children}</Dialog.Trigger>
  <Dialog.Content>
    <Dialog.Header>Delete item</Dialog.Header>
    <Dialog.Body icon={<WarningCircle />}>
      <Typography>Are you sure you want to delete this item?</Typography>
    </Dialog.Body>
    <Dialog.Footer>
      <Dialog.Cancel>
        <Button variant="tertiary">Cancel</Button>
      </Dialog.Cancel>
      <Button variant="secondary" onClick={onDelete}>Delete</Button>
    </Dialog.Footer>
  </Dialog.Content>
</Dialog.Root>
```

### Form Fields (Field Compound Component)

```tsx
import {
  Field, TextInput, SingleSelect, SingleSelectOption, Checkbox,
} from '@strapi/design-system';

// Text field with error and hint
<Field.Root error={errors.name?.message} hint="A unique identifier">
  <Field.Label>Name</Field.Label>
  <TextInput
    name="name"
    value={values.name}
    onChange={(e) => setValue('name', e.target.value)}
  />
  <Field.Hint />
  <Field.Error />
</Field.Root>

// Select field
<Field.Root hint="Choose a content type" error={errors.contenttype?.message}>
  <Field.Label>Content Type</Field.Label>
  <SingleSelect
    name="contenttype"
    value={values.contenttype}
    onChange={(v) => setValue('contenttype', v)}
  >
    {contentTypes.map((ct) => (
      <SingleSelectOption key={ct.uid} value={ct.uid}>
        {ct.name}
      </SingleSelectOption>
    ))}
  </SingleSelect>
  <Field.Hint />
  <Field.Error />
</Field.Root>

// Checkbox with field hint
<Field.Root hint="Uncheck this to create a custom alias below.">
  <Checkbox
    onCheckedChange={(value) => setValue('generated', value)}
    checked={values.generated}
  >
    Generate automatic URL alias
  </Checkbox>
  <Field.Hint />
</Field.Root>
```

### Radio Groups

```tsx
import { Radio, Flex } from '@strapi/design-system';

<Radio.Group
  onValueChange={(value) => setSelectedType(value)}
  value={selectedType}
  name="generation-type"
>
  <Flex direction="column" alignItems="start" gap="2">
    <Radio.Item value="draft">Create as draft</Radio.Item>
    <Radio.Item value="published">Publish immediately</Radio.Item>
    <Radio.Item value="scheduled">Schedule for later</Radio.Item>
  </Flex>
</Radio.Group>
```

### Grid Layout

```tsx
import { Grid } from '@strapi/design-system';

<Grid.Root gap={4} marginTop={4}>
  <Grid.Item col={6} direction="column" alignItems="flex-start" gap="4">
    {/* 6-column item */}
  </Grid.Item>
  <Grid.Item col={6} s={12} direction="column" alignItems="flex-start">
    {/* responsive: 6 cols on desktop, 12 (full width) on small */}
  </Grid.Item>
</Grid.Root>
```

### Pagination

```tsx
import { Pagination } from '@strapi/strapi/admin';

<Pagination.Root {...pagination}>
  <Pagination.PageSize />
  <Pagination.Links />
</Pagination.Root>
```

### Filters and Search

```tsx
import { Filters as StrapiFilters, SearchInput } from '@strapi/strapi/admin';
import { Flex } from '@strapi/design-system';

const filters: StrapiFilters.Filter[] = [
  {
    input: FilterInput,
    label: 'Content-Type',
    name: 'contenttype',
    options: contentTypes.map((ct) => ({ label: ct.name, value: ct.uid })),
    type: 'string',
  },
];

<Flex gap="2" marginBottom="4">
  <SearchInput label="Search" placeholder="Search" />
  <StrapiFilters.Root options={filters}>
    <StrapiFilters.Trigger />
    <StrapiFilters.Popover />
    <StrapiFilters.List />
  </StrapiFilters.Root>
</Flex>
```

### Typography Variants

| Variant | Use Case |
|---------|----------|
| `alpha` | Page title (h1) |
| `beta` | Section heading (h2) |
| `delta` | Sub-section heading |
| `sigma` | Table headers, labels (`textColor="neutral600"`) |
| `omega` | Body text, modal titles |
| `pi` | Small descriptions (`textColor="neutral600"`) |

### Strapi Admin Hooks

```tsx
import {
  useFetchClient,           // { get, post, put, del } - API calls
  getFetchClient,            // Same as useFetchClient but not a hook
  useNotification,           // { toggleNotification } - toast notifications
  useRBAC,                   // Role-based access control
  unstable_useContentManagerContext, // Content Manager context
  Page,                      // Page.Loading, Page.Error, Page.Protect
  Layouts,                   // Layouts.Root, Layouts.Header, Layouts.Content
  Pagination,                // Pagination.Root, Pagination.PageSize, Pagination.Links
} from '@strapi/strapi/admin';
```

### RBAC Permissions

```tsx
import { useRBAC } from '@strapi/strapi/admin';

// Define permissions
const pluginPermissions = {
  'settings.list': [{ action: 'plugin::my-plugin.settings.list', subject: null }],
  'settings.patterns': [{ action: 'plugin::my-plugin.settings.patterns', subject: null }],
  'edit-view.sidebar': [{ action: 'plugin::my-plugin.edit-view.sidebar', subject: null }],
};

// Use in components
const {
  allowedActions: { canList, canPatterns },
} = useRBAC(pluginPermissions);

if (!canList) return null;

// Or protect entire pages
<Page.Protect permissions={pluginPermissions['settings.patterns']}>
  {/* protected content */}
</Page.Protect>
```

### Notifications

```tsx
import { useNotification } from '@strapi/strapi/admin';
import { useIntl } from 'react-intl';

const { toggleNotification } = useNotification();
const { formatMessage } = useIntl();

// Success
toggleNotification({
  type: 'success',
  message: formatMessage({ id: 'my-plugin.success.saved', defaultMessage: 'Saved successfully' }),
});

// Error
toggleNotification({
  type: 'danger',
  message: formatMessage({ id: 'notification.error', defaultMessage: 'An error occurred' }),
});
```

---

## React Hook Form + Zod Patterns

For modern Strapi v5 plugins, use React Hook Form with Zod for type-safe form validation. This replaces legacy patterns using Formik + Yup.

### Dependencies

```json
{
  "dependencies": {
    "@hookform/resolvers": "^3.9.0",
    "react-hook-form": "^7.54.0",
    "zod": "^3.24.0"
  }
}
```

### Basic Settings Form

```tsx
// admin/src/pages/SettingsPage.tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, useNotification, Layouts, Page } from '@strapi/strapi/admin';
import {
  Main, Box, Button, Flex, Field, TextInput, Checkbox,
  Typography,
} from '@strapi/design-system';
import { Check } from '@strapi/icons';
import { useIntl } from 'react-intl';

const settingsSchema = z.object({
  apiUrl: z.string().url('Must be a valid URL').min(1, 'Required'),
  apiKey: z.string().min(1, 'API key is required'),
  enabled: z.boolean(),
  syncInterval: z.coerce.number().min(1).max(1440),
});

type SettingsFormValues = z.infer<typeof settingsSchema>;

const SettingsPage = () => {
  const { get, put } = useFetchClient();
  const { toggleNotification } = useNotification();
  const { formatMessage } = useIntl();
  const queryClient = useQueryClient();

  const { data: settings, isLoading } = useQuery({
    queryKey: ['my-plugin', 'settings'],
    queryFn: () => get('/my-plugin/settings').then((res) => res.data),
  });

  const {
    register,
    handleSubmit,
    formState: { errors, isDirty, isSubmitting },
    reset,
    watch,
    setValue,
  } = useForm<SettingsFormValues>({
    resolver: zodResolver(settingsSchema),
    values: settings, // Syncs form with fetched data
  });

  const mutation = useMutation({
    mutationFn: (data: SettingsFormValues) =>
      put('/my-plugin/settings', { data }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['my-plugin', 'settings'] });
      toggleNotification({
        type: 'success',
        message: formatMessage({ id: 'my-plugin.settings.saved' }),
      });
    },
    onError: () => {
      toggleNotification({
        type: 'danger',
        message: formatMessage({ id: 'notification.error' }),
      });
    },
  });

  if (isLoading) return <Page.Loading />;

  return (
    <Main>
      <form onSubmit={handleSubmit((data) => mutation.mutate(data))}>
        <Layouts.Header
          title="Settings"
          primaryAction={
            <Button
              type="submit"
              startIcon={<Check />}
              loading={isSubmitting}
              disabled={!isDirty}
            >
              Save
            </Button>
          }
        />
        <Layouts.Content>
          <Box background="neutral0" padding={6} shadow="filterShadow" hasRadius>
            <Flex direction="column" gap={4}>
              <Field.Root error={errors.apiUrl?.message}>
                <Field.Label>API URL</Field.Label>
                <TextInput {...register('apiUrl')} placeholder="https://api.example.com" />
                <Field.Error />
              </Field.Root>

              <Field.Root error={errors.apiKey?.message}>
                <Field.Label>API Key</Field.Label>
                <TextInput {...register('apiKey')} type="password" />
                <Field.Error />
              </Field.Root>

              <Field.Root error={errors.syncInterval?.message} hint="In minutes (1-1440)">
                <Field.Label>Sync Interval</Field.Label>
                <TextInput {...register('syncInterval')} type="number" />
                <Field.Hint />
                <Field.Error />
              </Field.Root>

              <Field.Root>
                <Checkbox
                  checked={watch('enabled')}
                  onCheckedChange={(value) => setValue('enabled', !!value, { shouldDirty: true })}
                >
                  Enable sync
                </Checkbox>
              </Field.Root>
            </Flex>
          </Box>
        </Layouts.Content>
      </form>
    </Main>
  );
};
```

### Create/Edit Form with Modal

```tsx
// admin/src/components/CreateItemModal.tsx
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, useNotification } from '@strapi/strapi/admin';
import {
  Modal, Button, Field, TextInput, SingleSelect, SingleSelectOption,
} from '@strapi/design-system';

const createItemSchema = z.object({
  name: z.string().min(1, 'Name is required').max(255),
  slug: z.string()
    .min(1, 'Slug is required')
    .regex(/^[a-z0-9-]+$/, 'Only lowercase letters, numbers, and hyphens'),
  contentType: z.string().min(1, 'Content type is required'),
});

type CreateItemValues = z.infer<typeof createItemSchema>;

interface Props {
  open: boolean;
  onClose: () => void;
  contentTypes: Array<{ uid: string; name: string }>;
}

export const CreateItemModal = ({ open, onClose, contentTypes }: Props) => {
  const { post } = useFetchClient();
  const { toggleNotification } = useNotification();
  const queryClient = useQueryClient();

  const {
    register,
    handleSubmit,
    control,
    formState: { errors, isSubmitting },
    reset,
  } = useForm<CreateItemValues>({
    resolver: zodResolver(createItemSchema),
    defaultValues: { name: '', slug: '', contentType: '' },
  });

  const mutation = useMutation({
    mutationFn: (data: CreateItemValues) =>
      post('/my-plugin/items', { data }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['my-plugin', 'items'] });
      toggleNotification({ type: 'success', message: 'Item created' });
      reset();
      onClose();
    },
  });

  return (
    <Modal.Root open={open} onOpenChange={(isOpen) => !isOpen && onClose()}>
      <Modal.Content>
        <Modal.Header>Create Item</Modal.Header>
        <Modal.Body>
          <form id="create-item-form" onSubmit={handleSubmit((data) => mutation.mutate(data))}>
            <Field.Root error={errors.name?.message}>
              <Field.Label>Name</Field.Label>
              <TextInput {...register('name')} />
              <Field.Error />
            </Field.Root>

            <Field.Root error={errors.slug?.message}>
              <Field.Label>Slug</Field.Label>
              <TextInput {...register('slug')} />
              <Field.Error />
            </Field.Root>

            {/* Use Controller for non-native inputs like SingleSelect */}
            <Controller
              name="contentType"
              control={control}
              render={({ field: { onChange, value } }) => (
                <Field.Root error={errors.contentType?.message}>
                  <Field.Label>Content Type</Field.Label>
                  <SingleSelect value={value} onChange={onChange}>
                    {contentTypes.map((ct) => (
                      <SingleSelectOption key={ct.uid} value={ct.uid}>
                        {ct.name}
                      </SingleSelectOption>
                    ))}
                  </SingleSelect>
                  <Field.Error />
                </Field.Root>
              )}
            />
          </form>
        </Modal.Body>
        <Modal.Footer>
          <Modal.Close>
            <Button variant="tertiary">Cancel</Button>
          </Modal.Close>
          <Button
            type="submit"
            form="create-item-form"
            loading={isSubmitting}
          >
            Create
          </Button>
        </Modal.Footer>
      </Modal.Content>
    </Modal.Root>
  );
};
```

### Reusable Zod Schemas

```typescript
// admin/src/utils/schemas.ts
import { z } from 'zod';

// Common field schemas
export const slugSchema = z.string()
  .min(1, 'Slug is required')
  .regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/, 'Must be a valid slug (lowercase, hyphens only)');

export const uidSchema = z.string()
  .regex(/^(api|plugin)::\w[\w-]*\.\w[\w-]*$/, 'Must be a valid Strapi UID');

// Pattern schema with async server-side validation
export const patternSchema = z.object({
  pattern: z.string().min(1, 'Pattern is required'),
  contenttype: uidSchema,
  languages: z.array(z.string()).optional(),
});

// Settings schema
export const settingsSchema = z.object({
  enabled: z.boolean().default(true),
  webhookUrl: z.string().url().optional().or(z.literal('')),
  maxRetries: z.coerce.number().int().min(0).max(10).default(3),
});
```

### Custom Hook: usePluginForm

```tsx
// admin/src/hooks/usePluginForm.ts
import { useForm, UseFormProps } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, useNotification } from '@strapi/strapi/admin';
import { useIntl } from 'react-intl';
import { z } from 'zod';

interface UsePluginFormOptions<T extends z.ZodType> {
  schema: T;
  endpoint: string;
  method?: 'post' | 'put';
  queryKeyToInvalidate: string[];
  successMessageId?: string;
  formOptions?: Omit<UseFormProps<z.infer<T>>, 'resolver'>;
}

export function usePluginForm<T extends z.ZodType>({
  schema,
  endpoint,
  method = 'post',
  queryKeyToInvalidate,
  successMessageId = 'notification.success',
  formOptions,
}: UsePluginFormOptions<T>) {
  const { post, put } = useFetchClient();
  const { toggleNotification } = useNotification();
  const { formatMessage } = useIntl();
  const queryClient = useQueryClient();

  const form = useForm<z.infer<T>>({
    resolver: zodResolver(schema),
    ...formOptions,
  });

  const mutation = useMutation({
    mutationFn: (data: z.infer<T>) =>
      method === 'post'
        ? post(endpoint, { data })
        : put(endpoint, { data }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeyToInvalidate });
      toggleNotification({
        type: 'success',
        message: formatMessage({ id: successMessageId }),
      });
    },
    onError: () => {
      toggleNotification({
        type: 'danger',
        message: formatMessage({ id: 'notification.error' }),
      });
    },
  });

  return {
    ...form,
    mutation,
    onSubmit: form.handleSubmit((data) => mutation.mutate(data)),
  };
}
```

---

## TanStack Query v5 Patterns (Advanced)

### Custom Query Hooks

```tsx
// admin/src/hooks/usePluginData.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient } from '@strapi/strapi/admin';

const PLUGIN_PREFIX = '/my-plugin';

export function useItems(params?: string) {
  const { get } = useFetchClient();

  return useQuery({
    queryKey: ['my-plugin', 'items', params],
    queryFn: () =>
      get<{ data: Item[]; meta: PaginationMeta }>(
        `${PLUGIN_PREFIX}/items${params ? `?${params}` : ''}`
      ).then((res) => res.data),
  });
}

export function useItem(documentId: string) {
  const { get } = useFetchClient();

  return useQuery({
    queryKey: ['my-plugin', 'items', documentId],
    queryFn: () =>
      get<{ data: Item }>(`${PLUGIN_PREFIX}/items/${documentId}`)
        .then((res) => res.data.data),
    enabled: !!documentId,
  });
}

export function useCreateItem() {
  const { post } = useFetchClient();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreateItemPayload) =>
      post(`${PLUGIN_PREFIX}/items`, { data }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['my-plugin', 'items'] });
    },
  });
}

export function useUpdateItem() {
  const { put } = useFetchClient();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ documentId, data }: { documentId: string; data: Partial<Item> }) =>
      put(`${PLUGIN_PREFIX}/items/${documentId}`, { data }),
    onSuccess: (_, { documentId }) => {
      queryClient.invalidateQueries({ queryKey: ['my-plugin', 'items'] });
      queryClient.invalidateQueries({ queryKey: ['my-plugin', 'items', documentId] });
    },
  });
}

export function useDeleteItem() {
  const { del } = useFetchClient();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (documentId: string) =>
      del(`${PLUGIN_PREFIX}/items/${documentId}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['my-plugin', 'items'] });
    },
  });
}
```

### Query Key Conventions

| Key Pattern | Use Case |
|-------------|----------|
| `['my-plugin', 'items']` | List of items |
| `['my-plugin', 'items', params]` | List with query params (pagination, filters) |
| `['my-plugin', 'items', documentId]` | Single item by ID |
| `['my-plugin', 'settings']` | Plugin settings |
| `['my-plugin', 'content-types']` | Available content types |

### Loading/Error State Pattern

```tsx
import { Page } from '@strapi/strapi/admin';

const ItemsPage = () => {
  const items = useItems();
  const contentTypes = useContentTypes();

  if (items.isLoading || contentTypes.isLoading) {
    return <Page.Loading />;
  }

  if (items.isError || contentTypes.isError) {
    return <Page.Error />;
  }

  return (
    <Main>
      {/* render content */}
    </Main>
  );
};
```

### useFetchClient vs getFetchClient

Strapi provides two ways to make authenticated API calls:

```tsx
// Hook version - use in React components
import { useFetchClient } from '@strapi/strapi/admin';

const MyComponent = () => {
  const { get, post, put, del } = useFetchClient();
  // Use in useQuery, useMutation, event handlers
};

// Utility function - use outside React (or in callbacks that don't need reactivity)
import { getFetchClient } from '@strapi/strapi/admin';

const { get, post, put, del } = getFetchClient();

// Both return { data } where:
// - Outer .data = axios response wrapper
// - Inner .data = your API payload
// Access pattern: response.data.data for the actual data
```

---

## Content Type Builder Integration

Extend the Content Type Builder to add plugin-specific options to content types.

```tsx
// admin/src/index.ts
import * as yup from 'yup'; // CTB still requires yup for validators

export default {
  bootstrap(app: any) {
    const ctbPlugin = app.getPlugin('content-type-builder');
    if (ctbPlugin) {
      const ctbFormsAPI = ctbPlugin.apis.forms;

      // Register custom form component
      ctbFormsAPI.components.add({
        id: 'my-plugin.checkboxConfirmation',
        component: CheckboxConfirmation,
      });

      // Extend content type form
      ctbFormsAPI.extendContentType({
        validator: () => ({
          'my-plugin': yup.object().shape({
            enabled: yup.bool().default(true),
          }),
        }),
        form: {
          advanced() {
            return [{
              name: 'pluginOptions.my-plugin.enabled',
              description: {
                id: 'my-plugin.ctb.enabled.description',
                defaultMessage: 'Enable My Plugin for this content type',
              },
              type: 'my-plugin.checkboxConfirmation',
              intlLabel: {
                id: 'my-plugin.ctb.enabled.label',
                defaultMessage: 'My Plugin',
              },
            }];
          },
        },
      });
    }
  },
};
```

---

## Edit View Side Panel (addEditViewSidePanel)

Register a custom panel in the Content Manager's edit view sidebar.

```tsx
// admin/src/index.ts
import type { StrapiApp } from '@strapi/strapi/admin';
import type { PanelComponent } from '@strapi/content-manager/strapi-admin';
import { MyPanel } from './components/MyPanel';

export default {
  bootstrap(app: StrapiApp) {
    // @ts-expect-error - API exists but types may lag
    app.getPlugin('content-manager').apis.addEditViewSidePanel([MyPanel]);
  },
};

// admin/src/components/MyPanel.tsx
import { unstable_useContentManagerContext } from '@strapi/strapi/admin';
import type { PanelComponent } from '@strapi/content-manager/strapi-admin';

const MyPanel: PanelComponent = () => {
  const { contentType, model, id } = unstable_useContentManagerContext();

  // Check if the plugin is enabled for this content type
  if (!contentType?.pluginOptions?.['my-plugin']?.enabled) return null;

  // Panel must return { title, content } or null
  return {
    title: 'My Plugin',
    content: (
      <Box padding={4}>
        <Typography>Panel content for {model}</Typography>
      </Box>
    ),
  };
};
```

---

## Custom Injection Zones

Create your own injection zones so other plugins or addons can extend your plugin's UI.

```tsx
// admin/src/index.ts
export default {
  register(app: any) {
    app.registerPlugin({
      id: PLUGIN_ID,
      initializer: Initializer,
      isReady: false,
      name: PLUGIN_ID,
      injectionZones: {
        myPluginRouter: { route: [] },
        myPluginSidePanel: { link: [] },
      },
    });
  },
};

// admin/src/pages/App.tsx - Render injected routes
import { useStrapiApp } from '@strapi/strapi/admin';
import { PLUGIN_ID } from '../pluginId';

const App = () => {
  const getPlugin = useStrapiApp('App', (state) => state.getPlugin);
  const plugin = getPlugin(PLUGIN_ID);
  const injectedRoutes = plugin?.getInjectedComponents('myPluginRouter', 'route') || [];

  return (
    <Routes>
      <Route index element={<HomePage />} />
      {injectedRoutes.map(({ path, Component }) => (
        <Route key={path} path={path} element={<Component />} />
      ))}
      <Route path="*" element={<Page.Error />} />
    </Routes>
  );
};
```

---

## Monorepo Plugin Development (PluginPal Boilerplate)

Based on [pluginpal/strapi-plugin-boilerplate](https://github.com/pluginpal/strapi-plugin-boilerplate) - a test-driven template for Strapi v5 plugins.

### Recommended Monorepo Structure

```
my-plugin/
├── package.json              # Root: pnpm workspace + Turborepo
├── pnpm-workspace.yaml
├── turbo.json
├── biome.json                # Linting (replaces ESLint + Prettier)
├── cypress.config.js         # E2E tests
├── packages/
│   └── my-plugin/
│       ├── package.json      # Plugin package with exports
│       ├── admin/src/        # Admin panel
│       └── server/src/       # Server-side
│           └── tests/        # Jest + Supertest integration tests
└── apps/
    └── playground/           # Isolated Strapi instance for dev
        ├── package.json      # Strapi 5.x + plugin workspace ref
        ├── config/
        └── tests/
            └── helpers.ts    # Strapi test bootstrap helpers
```

### Test Setup (Jest + Supertest)

```typescript
// apps/playground/tests/helpers.ts
const { createStrapi } = require('@strapi/strapi');

let instance;

async function setupStrapi() {
  if (!instance) {
    const app = await createStrapi({
      appDir: '../../apps/playground',
      distDir: '../../apps/playground/dist',
    }).load();

    instance = app;
    await instance.server.mount();
  }
  return instance;
}

async function stopStrapi() {
  if (instance) {
    await instance.server.httpServer.close();
    await instance.db.connection.destroy();
    instance.destroy();
  }
}

module.exports = { setupStrapi, stopStrapi };
```

```typescript
// packages/my-plugin/server/tests/example.test.ts
const request = require('supertest');
const { setupStrapi, stopStrapi } = require('../../../apps/playground/tests/helpers');

let strapi;

beforeAll(async () => {
  strapi = await setupStrapi();
});

afterAll(async () => {
  await stopStrapi();
});

it('should return items from the API', async () => {
  const response = await request(strapi.server.httpServer)
    .get('/api/my-plugin/items')
    .expect(200);

  expect(response.body.data).toBeDefined();
});

it('should call the service correctly', async () => {
  const result = strapi.service('plugin::my-plugin.item').findAll();
  expect(result).toBeDefined();
});
```

### Package.json with Modern Exports

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "strapi": {
    "kind": "plugin",
    "name": "my-plugin",
    "displayName": "My Plugin"
  },
  "exports": {
    "./strapi-admin": {
      "source": "./admin/src/index.ts",
      "import": "./dist/admin/index.mjs",
      "require": "./dist/admin/index.js"
    },
    "./strapi-server": {
      "source": "./server/src/index.ts",
      "import": "./dist/server/index.mjs",
      "require": "./dist/server/index.js"
    }
  },
  "dependencies": {
    "@hookform/resolvers": "^3.9.0",
    "@strapi/design-system": "^2.0.0-rc.14",
    "@strapi/icons": "^2.0.0-rc.14",
    "@tanstack/react-query": "^5.62.0",
    "react-hook-form": "^7.54.0",
    "react-intl": "^7.1.0",
    "zod": "^3.24.0"
  },
  "peerDependencies": {
    "@strapi/strapi": "^5.0.0",
    "react": "^17.0.0 || ^18.0.0",
    "react-dom": "^17.0.0 || ^18.0.0",
    "react-router-dom": "^6.0.0",
    "styled-components": "^6.0.0"
  }
}
```
