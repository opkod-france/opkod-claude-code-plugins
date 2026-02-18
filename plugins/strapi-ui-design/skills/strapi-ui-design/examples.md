# Strapi UI Design Examples

Complete, production-ready interface examples for Strapi v5 plugins.

## Table of Contents

- [Complete Plugin Admin Interface](#complete-plugin-admin-interface)
- [Settings Page with Tabs](#settings-page-with-tabs)
- [Data Management Page](#data-management-page)
- [Import/Export Interface](#importexport-interface)
- [Dashboard with Charts](#dashboard-with-charts)

---

## Complete Plugin Admin Interface

A full-featured plugin with navigation, CRUD operations, and proper routing.

### Plugin Registration

```tsx
// admin/src/index.tsx
import { getTranslation } from './utils/getTranslation';
import { PLUGIN_ID } from './pluginId';
import { Puzzle } from '@strapi/icons';

export default {
  register(app: any) {
    app.addMenuLink({
      to: `plugins/${PLUGIN_ID}`,
      icon: Puzzle,
      intlLabel: {
        id: `${PLUGIN_ID}.plugin.name`,
        defaultMessage: 'Task Manager',
      },
      permissions: [],
    });

    app.registerPlugin({
      id: PLUGIN_ID,
      name: PLUGIN_ID,
    });
  },

  bootstrap(app: any) {
    // Inject into Content Manager
    app.injectComponent('editView', 'right-links', {
      name: `${PLUGIN_ID}-panel`,
      Component: async () => {
        const component = await import('./components/ContentManagerPanel');
        return component.default;
      },
    });
  },

  async registerTrads({ locales }: { locales: string[] }) {
    return Promise.all(
      locales.map(async (locale) => {
        try {
          const { default: data } = await import(`./translations/${locale}.json`);
          return { data, locale };
        } catch {
          return { data: {}, locale };
        }
      })
    );
  },
};
```

### Plugin Router

```tsx
// admin/src/pages/App.tsx
import { Routes, Route } from 'react-router-dom';
import { Page } from '@strapi/strapi/admin';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

import HomePage from './HomePage';
import TaskListPage from './TaskListPage';
import TaskDetailPage from './TaskDetailPage';
import SettingsPage from './SettingsPage';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});

const App = () => {
  return (
    <QueryClientProvider client={queryClient}>
      <Routes>
        <Route index element={<HomePage />} />
        <Route path="tasks" element={<TaskListPage />} />
        <Route path="tasks/:documentId" element={<TaskDetailPage />} />
        <Route path="settings" element={<SettingsPage />} />
        <Route path="*" element={<Page.Error />} />
      </Routes>
    </QueryClientProvider>
  );
};

export default App;
```

### Home Page with Navigation

```tsx
// admin/src/pages/HomePage.tsx
import {
  Main,
  Box,
  Flex,
  Typography,
  Grid,
  Card,
  Button,
  Badge,
} from '@strapi/design-system';
import { Link } from 'react-router-dom';
import { Plus, Cog, File, ChartPie } from '@strapi/icons';
import { useQuery } from '@tanstack/react-query';
import { useFetchClient } from '@strapi/strapi/admin';
import { PLUGIN_ID } from '../pluginId';

interface Stats {
  totalTasks: number;
  completedTasks: number;
  pendingTasks: number;
}

const HomePage = () => {
  const { get } = useFetchClient();

  const { data: stats } = useQuery({
    queryKey: [PLUGIN_ID, 'stats'],
    queryFn: async () => {
      const { data } = await get(`/${PLUGIN_ID}/stats`);
      return data as Stats;
    },
  });

  return (
    <Main>
      {/* Header */}
      <Box paddingLeft={10} paddingRight={10} paddingTop={8} paddingBottom={6}>
        <Flex justifyContent="space-between" alignItems="center">
          <Box>
            <Typography variant="alpha">Task Manager</Typography>
            <Typography variant="epsilon" textColor="neutral600">
              Manage tasks across your content
            </Typography>
          </Box>
          <Flex gap={2}>
            <Button
              variant="secondary"
              startIcon={<Cog />}
              tag={Link}
              to="settings"
            >
              Settings
            </Button>
            <Button startIcon={<Plus />} tag={Link} to="tasks">
              View Tasks
            </Button>
          </Flex>
        </Flex>
      </Box>

      {/* Quick Stats */}
      <Box paddingLeft={10} paddingRight={10} paddingBottom={6}>
        <Grid.Root gap={6}>
          <Grid.Item col={4}>
            <Card padding={6}>
              <Flex direction="column" alignItems="center" gap={2}>
                <Typography variant="alpha" textColor="primary600">
                  {stats?.totalTasks || 0}
                </Typography>
                <Typography variant="pi" textColor="neutral600">
                  Total Tasks
                </Typography>
              </Flex>
            </Card>
          </Grid.Item>
          <Grid.Item col={4}>
            <Card padding={6}>
              <Flex direction="column" alignItems="center" gap={2}>
                <Typography variant="alpha" textColor="success600">
                  {stats?.completedTasks || 0}
                </Typography>
                <Typography variant="pi" textColor="neutral600">
                  Completed
                </Typography>
              </Flex>
            </Card>
          </Grid.Item>
          <Grid.Item col={4}>
            <Card padding={6}>
              <Flex direction="column" alignItems="center" gap={2}>
                <Typography variant="alpha" textColor="warning600">
                  {stats?.pendingTasks || 0}
                </Typography>
                <Typography variant="pi" textColor="neutral600">
                  Pending
                </Typography>
              </Flex>
            </Card>
          </Grid.Item>
        </Grid.Root>
      </Box>

      {/* Quick Actions */}
      <Box paddingLeft={10} paddingRight={10}>
        <Typography variant="beta" paddingBottom={4}>
          Quick Actions
        </Typography>
        <Grid.Root gap={4}>
          <Grid.Item col={6}>
            <Card padding={6} tag={Link} to="tasks" style={{ textDecoration: 'none' }}>
              <Flex gap={4} alignItems="center">
                <Box
                  background="primary100"
                  padding={3}
                  borderRadius="50%"
                >
                  <File fill="primary600" />
                </Box>
                <Box>
                  <Typography variant="delta">Manage Tasks</Typography>
                  <Typography textColor="neutral600">
                    View, create, and organize tasks
                  </Typography>
                </Box>
              </Flex>
            </Card>
          </Grid.Item>
          <Grid.Item col={6}>
            <Card padding={6} tag={Link} to="settings" style={{ textDecoration: 'none' }}>
              <Flex gap={4} alignItems="center">
                <Box
                  background="secondary100"
                  padding={3}
                  borderRadius="50%"
                >
                  <Cog fill="secondary600" />
                </Box>
                <Box>
                  <Typography variant="delta">Settings</Typography>
                  <Typography textColor="neutral600">
                    Configure plugin options
                  </Typography>
                </Box>
              </Flex>
            </Card>
          </Grid.Item>
        </Grid.Root>
      </Box>
    </Main>
  );
};

export default HomePage;
```

### Task List Page

```tsx
// admin/src/pages/TaskListPage.tsx
import {
  Main,
  Box,
  Flex,
  Typography,
  Button,
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  IconButton,
  Tooltip,
  Badge,
  Searchbar,
  Pagination,
  Loader,
  EmptyStateLayout,
} from '@strapi/design-system';
import { Plus, Pencil, Trash, Eye, ArrowLeft, EmptyDocuments } from '@strapi/icons';
import { Link, useNavigate } from 'react-router-dom';
import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, useNotification } from '@strapi/strapi/admin';
import { PLUGIN_ID } from '../pluginId';
import ConfirmDeleteDialog from '../components/ConfirmDeleteDialog';
import CreateTaskModal from '../components/CreateTaskModal';

interface Task {
  id: number;
  documentId: string;
  name: string;
  status: 'todo' | 'in_progress' | 'done';
  priority: 'low' | 'medium' | 'high';
  createdAt: string;
}

const TaskListPage = () => {
  const navigate = useNavigate();
  const { get, del } = useFetchClient();
  const { toggleNotification } = useNotification();
  const queryClient = useQueryClient();

  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [deleteTask, setDeleteTask] = useState<Task | null>(null);

  const pageSize = 10;

  // Fetch tasks
  const { data, isLoading } = useQuery({
    queryKey: [PLUGIN_ID, 'tasks', { search, page: currentPage }],
    queryFn: async () => {
      const params = new URLSearchParams({
        _start: String((currentPage - 1) * pageSize),
        _limit: String(pageSize),
        ...(search && { _q: search }),
      });
      const { data } = await get(`/${PLUGIN_ID}/tasks?${params}`);
      return data as { tasks: Task[]; total: number };
    },
  });

  // Delete mutation
  const deleteMutation = useMutation({
    mutationFn: async (documentId: string) => {
      await del(`/${PLUGIN_ID}/tasks/${documentId}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [PLUGIN_ID, 'tasks'] });
      queryClient.invalidateQueries({ queryKey: [PLUGIN_ID, 'stats'] });
      toggleNotification({
        type: 'success',
        message: 'Task deleted successfully',
      });
      setDeleteTask(null);
    },
    onError: () => {
      toggleNotification({
        type: 'danger',
        message: 'Failed to delete task',
      });
    },
  });

  const getStatusBadge = (status: Task['status']) => {
    const config = {
      todo: { bg: 'neutral150', text: 'neutral600', label: 'To Do' },
      in_progress: { bg: 'warning100', text: 'warning700', label: 'In Progress' },
      done: { bg: 'success100', text: 'success700', label: 'Done' },
    };
    const { bg, text, label } = config[status];
    return (
      <Badge backgroundColor={bg} textColor={text}>
        {label}
      </Badge>
    );
  };

  const getPriorityBadge = (priority: Task['priority']) => {
    const config = {
      low: { bg: 'neutral150', text: 'neutral600' },
      medium: { bg: 'warning100', text: 'warning700' },
      high: { bg: 'danger100', text: 'danger700' },
    };
    const { bg, text } = config[priority];
    return (
      <Badge backgroundColor={bg} textColor={text}>
        {priority}
      </Badge>
    );
  };

  const tasks = data?.tasks || [];
  const totalCount = data?.total || 0;
  const pageCount = Math.ceil(totalCount / pageSize);

  return (
    <Main>
      {/* Header */}
      <Box paddingLeft={10} paddingRight={10} paddingTop={8} paddingBottom={6}>
        <Flex justifyContent="space-between" alignItems="center">
          <Flex gap={4} alignItems="center">
            <IconButton
              label="Go back"
              tag={Link}
              to=".."
            >
              <ArrowLeft />
            </IconButton>
            <Box>
              <Typography variant="alpha">Tasks</Typography>
              <Typography variant="epsilon" textColor="neutral600">
                {totalCount} task(s) found
              </Typography>
            </Box>
          </Flex>
          <Button
            startIcon={<Plus />}
            onClick={() => setIsCreateModalOpen(true)}
          >
            Add Task
          </Button>
        </Flex>
      </Box>

      {/* Search */}
      <Box paddingLeft={10} paddingRight={10} paddingBottom={4}>
        <Searchbar
          name="search"
          value={search}
          onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
            setSearch(e.target.value);
            setCurrentPage(1);
          }}
          onClear={() => {
            setSearch('');
            setCurrentPage(1);
          }}
          placeholder="Search tasks..."
        >
          Search
        </Searchbar>
      </Box>

      {/* Content */}
      <Box paddingLeft={10} paddingRight={10}>
        {isLoading ? (
          <Flex justifyContent="center" padding={8}>
            <Loader>Loading tasks...</Loader>
          </Flex>
        ) : tasks.length === 0 ? (
          <EmptyStateLayout
            icon={<EmptyDocuments />}
            content={search ? `No tasks match "${search}"` : 'No tasks yet'}
            action={
              !search && (
                <Button
                  startIcon={<Plus />}
                  onClick={() => setIsCreateModalOpen(true)}
                >
                  Add your first task
                </Button>
              )
            }
          />
        ) : (
          <>
            <Table colCount={5} rowCount={tasks.length + 1}>
              <Thead>
                <Tr>
                  <Th>
                    <Typography variant="sigma">Name</Typography>
                  </Th>
                  <Th>
                    <Typography variant="sigma">Status</Typography>
                  </Th>
                  <Th>
                    <Typography variant="sigma">Priority</Typography>
                  </Th>
                  <Th>
                    <Typography variant="sigma">Created</Typography>
                  </Th>
                  <Th>
                    <Typography variant="sigma">Actions</Typography>
                  </Th>
                </Tr>
              </Thead>
              <Tbody>
                {tasks.map((task) => (
                  <Tr key={task.id}>
                    <Td>
                      <Typography textColor="neutral800" fontWeight="semiBold">
                        {task.name}
                      </Typography>
                    </Td>
                    <Td>{getStatusBadge(task.status)}</Td>
                    <Td>{getPriorityBadge(task.priority)}</Td>
                    <Td>
                      <Typography textColor="neutral600">
                        {new Date(task.createdAt).toLocaleDateString()}
                      </Typography>
                    </Td>
                    <Td>
                      <Flex gap={1}>
                        <Tooltip description="View">
                          <IconButton
                            label="View"
                            onClick={() => navigate(task.documentId)}
                          >
                            <Eye />
                          </IconButton>
                        </Tooltip>
                        <Tooltip description="Edit">
                          <IconButton
                            label="Edit"
                            onClick={() => navigate(`${task.documentId}?edit=true`)}
                          >
                            <Pencil />
                          </IconButton>
                        </Tooltip>
                        <Tooltip description="Delete">
                          <IconButton
                            label="Delete"
                            onClick={() => setDeleteTask(task)}
                          >
                            <Trash />
                          </IconButton>
                        </Tooltip>
                      </Flex>
                    </Td>
                  </Tr>
                ))}
              </Tbody>
            </Table>

            {/* Pagination */}
            {pageCount > 1 && (
              <Box paddingTop={4}>
                <Flex justifyContent="flex-end">
                  <Pagination activePage={currentPage} pageCount={pageCount}>
                    <Pagination.PageLink
                      number={1}
                      onClick={() => setCurrentPage(1)}
                    >
                      First
                    </Pagination.PageLink>
                    <Pagination.PreviousLink
                      onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                    >
                      Previous
                    </Pagination.PreviousLink>
                    <Pagination.NextLink
                      onClick={() => setCurrentPage((p) => Math.min(pageCount, p + 1))}
                    >
                      Next
                    </Pagination.NextLink>
                    <Pagination.PageLink
                      number={pageCount}
                      onClick={() => setCurrentPage(pageCount)}
                    >
                      Last
                    </Pagination.PageLink>
                  </Pagination>
                </Flex>
              </Box>
            )}
          </>
        )}
      </Box>

      {/* Create Modal */}
      <CreateTaskModal
        isOpen={isCreateModalOpen}
        onClose={() => setIsCreateModalOpen(false)}
      />

      {/* Delete Dialog */}
      <ConfirmDeleteDialog
        isOpen={!!deleteTask}
        onClose={() => setDeleteTask(null)}
        onConfirm={() => deleteTask && deleteMutation.mutate(deleteTask.documentId)}
        itemName={deleteTask?.name || ''}
        isLoading={deleteMutation.isPending}
      />
    </Main>
  );
};

export default TaskListPage;
```

---

## Settings Page with Tabs

```tsx
// admin/src/pages/SettingsPage.tsx
import {
  Main,
  Box,
  Flex,
  Typography,
  Button,
  Tabs,
  Card,
  Field,
  TextInput,
  Textarea,
  Toggle,
  Select,
  Option,
  Alert,
  Loader,
} from '@strapi/design-system';
import { Check, ArrowLeft } from '@strapi/icons';
import { Link } from 'react-router-dom';
import { useState, useEffect } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, useNotification } from '@strapi/strapi/admin';
import { PLUGIN_ID } from '../pluginId';

interface GeneralSettings {
  defaultPriority: 'low' | 'medium' | 'high';
  enableNotifications: boolean;
  taskPrefix: string;
}

interface IntegrationSettings {
  webhookUrl: string;
  apiKey: string;
  syncEnabled: boolean;
}

interface NotificationSettings {
  emailEnabled: boolean;
  emailRecipients: string;
  slackWebhook: string;
}

const SettingsPage = () => {
  const { get, put } = useFetchClient();
  const { toggleNotification } = useNotification();
  const queryClient = useQueryClient();

  const [activeTab, setActiveTab] = useState('general');
  const [general, setGeneral] = useState<GeneralSettings>({
    defaultPriority: 'medium',
    enableNotifications: true,
    taskPrefix: 'TASK-',
  });
  const [integration, setIntegration] = useState<IntegrationSettings>({
    webhookUrl: '',
    apiKey: '',
    syncEnabled: false,
  });
  const [notifications, setNotifications] = useState<NotificationSettings>({
    emailEnabled: false,
    emailRecipients: '',
    slackWebhook: '',
  });

  // Fetch all settings
  const { data, isLoading, error } = useQuery({
    queryKey: [PLUGIN_ID, 'settings'],
    queryFn: async () => {
      const { data } = await get(`/${PLUGIN_ID}/settings`);
      return data;
    },
  });

  useEffect(() => {
    if (data) {
      setGeneral(data.general || general);
      setIntegration(data.integration || integration);
      setNotifications(data.notifications || notifications);
    }
  }, [data]);

  // Save mutation
  const saveMutation = useMutation({
    mutationFn: async () => {
      const { data } = await put(`/${PLUGIN_ID}/settings`, {
        general,
        integration,
        notifications,
      });
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [PLUGIN_ID, 'settings'] });
      toggleNotification({
        type: 'success',
        message: 'Settings saved successfully',
      });
    },
    onError: () => {
      toggleNotification({
        type: 'danger',
        message: 'Failed to save settings',
      });
    },
  });

  if (error) {
    return (
      <Main>
        <Box padding={8}>
          <Alert variant="danger">Failed to load settings</Alert>
        </Box>
      </Main>
    );
  }

  return (
    <Main>
      {/* Header */}
      <Box paddingLeft={10} paddingRight={10} paddingTop={8} paddingBottom={6}>
        <Flex justifyContent="space-between" alignItems="center">
          <Flex gap={4} alignItems="center">
            <Button
              variant="tertiary"
              startIcon={<ArrowLeft />}
              tag={Link}
              to=".."
            >
              Back
            </Button>
            <Typography variant="alpha">Settings</Typography>
          </Flex>
          <Button
            startIcon={<Check />}
            onClick={() => saveMutation.mutate()}
            loading={saveMutation.isPending}
          >
            Save
          </Button>
        </Flex>
      </Box>

      {/* Content */}
      <Box paddingLeft={10} paddingRight={10}>
        {isLoading ? (
          <Flex justifyContent="center" padding={8}>
            <Loader>Loading settings...</Loader>
          </Flex>
        ) : (
          <Tabs.Root value={activeTab} onValueChange={setActiveTab}>
            <Tabs.List>
              <Tabs.Trigger value="general">General</Tabs.Trigger>
              <Tabs.Trigger value="integration">Integration</Tabs.Trigger>
              <Tabs.Trigger value="notifications">Notifications</Tabs.Trigger>
            </Tabs.List>

            <Box paddingTop={6}>
              {/* General Tab */}
              <Tabs.Content value="general">
                <Card padding={6}>
                  <Typography variant="delta" paddingBottom={4}>
                    General Settings
                  </Typography>
                  <Flex direction="column" gap={4}>
                    <Field.Root name="taskPrefix">
                      <Field.Label>Task Prefix</Field.Label>
                      <TextInput
                        value={general.taskPrefix}
                        onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
                          setGeneral((prev) => ({
                            ...prev,
                            taskPrefix: e.target.value,
                          }))
                        }
                        placeholder="TASK-"
                      />
                      <Field.Hint>
                        Prefix added to task identifiers
                      </Field.Hint>
                    </Field.Root>

                    <Field.Root name="defaultPriority">
                      <Field.Label>Default Priority</Field.Label>
                      <Select
                        value={general.defaultPriority}
                        onChange={(value: string) =>
                          setGeneral((prev) => ({
                            ...prev,
                            defaultPriority: value as GeneralSettings['defaultPriority'],
                          }))
                        }
                      >
                        <Option value="low">Low</Option>
                        <Option value="medium">Medium</Option>
                        <Option value="high">High</Option>
                      </Select>
                      <Field.Hint>
                        Default priority for new tasks
                      </Field.Hint>
                    </Field.Root>

                    <Field.Root name="enableNotifications">
                      <Flex gap={2} alignItems="center">
                        <Toggle
                          checked={general.enableNotifications}
                          onCheckedChange={(checked: boolean) =>
                            setGeneral((prev) => ({
                              ...prev,
                              enableNotifications: checked,
                            }))
                          }
                        />
                        <Field.Label>Enable Notifications</Field.Label>
                      </Flex>
                      <Field.Hint>
                        Show in-app notifications for task updates
                      </Field.Hint>
                    </Field.Root>
                  </Flex>
                </Card>
              </Tabs.Content>

              {/* Integration Tab */}
              <Tabs.Content value="integration">
                <Card padding={6}>
                  <Typography variant="delta" paddingBottom={4}>
                    Integration Settings
                  </Typography>
                  <Flex direction="column" gap={4}>
                    <Field.Root name="webhookUrl">
                      <Field.Label>Webhook URL</Field.Label>
                      <TextInput
                        value={integration.webhookUrl}
                        onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
                          setIntegration((prev) => ({
                            ...prev,
                            webhookUrl: e.target.value,
                          }))
                        }
                        placeholder="https://example.com/webhook"
                      />
                      <Field.Hint>
                        URL to receive task event webhooks
                      </Field.Hint>
                    </Field.Root>

                    <Field.Root name="apiKey">
                      <Field.Label>API Key</Field.Label>
                      <TextInput
                        type="password"
                        value={integration.apiKey}
                        onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
                          setIntegration((prev) => ({
                            ...prev,
                            apiKey: e.target.value,
                          }))
                        }
                        placeholder="Enter API key"
                      />
                      <Field.Hint>
                        API key for external service authentication
                      </Field.Hint>
                    </Field.Root>

                    <Field.Root name="syncEnabled">
                      <Flex gap={2} alignItems="center">
                        <Toggle
                          checked={integration.syncEnabled}
                          onCheckedChange={(checked: boolean) =>
                            setIntegration((prev) => ({
                              ...prev,
                              syncEnabled: checked,
                            }))
                          }
                        />
                        <Field.Label>Enable Sync</Field.Label>
                      </Flex>
                      <Field.Hint>
                        Automatically sync tasks with external service
                      </Field.Hint>
                    </Field.Root>
                  </Flex>
                </Card>
              </Tabs.Content>

              {/* Notifications Tab */}
              <Tabs.Content value="notifications">
                <Card padding={6}>
                  <Typography variant="delta" paddingBottom={4}>
                    Notification Settings
                  </Typography>
                  <Flex direction="column" gap={4}>
                    <Field.Root name="emailEnabled">
                      <Flex gap={2} alignItems="center">
                        <Toggle
                          checked={notifications.emailEnabled}
                          onCheckedChange={(checked: boolean) =>
                            setNotifications((prev) => ({
                              ...prev,
                              emailEnabled: checked,
                            }))
                          }
                        />
                        <Field.Label>Email Notifications</Field.Label>
                      </Flex>
                    </Field.Root>

                    {notifications.emailEnabled && (
                      <Field.Root name="emailRecipients">
                        <Field.Label>Email Recipients</Field.Label>
                        <Textarea
                          value={notifications.emailRecipients}
                          onChange={(e: React.ChangeEvent<HTMLTextAreaElement>) =>
                            setNotifications((prev) => ({
                              ...prev,
                              emailRecipients: e.target.value,
                            }))
                          }
                          placeholder="email1@example.com, email2@example.com"
                        />
                        <Field.Hint>
                          Comma-separated list of email addresses
                        </Field.Hint>
                      </Field.Root>
                    )}

                    <Field.Root name="slackWebhook">
                      <Field.Label>Slack Webhook</Field.Label>
                      <TextInput
                        value={notifications.slackWebhook}
                        onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
                          setNotifications((prev) => ({
                            ...prev,
                            slackWebhook: e.target.value,
                          }))
                        }
                        placeholder="https://hooks.slack.com/..."
                      />
                      <Field.Hint>
                        Slack webhook URL for notifications
                      </Field.Hint>
                    </Field.Root>
                  </Flex>
                </Card>
              </Tabs.Content>
            </Box>
          </Tabs.Root>
        )}
      </Box>
    </Main>
  );
};

export default SettingsPage;
```

---

## Data Management Page

A page for managing data with filtering, bulk actions, and export.

```tsx
// admin/src/pages/DataManagementPage.tsx
import {
  Main,
  Box,
  Flex,
  Typography,
  Button,
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Checkbox,
  IconButton,
  Tooltip,
  Badge,
  Searchbar,
  Select,
  Option,
  Field,
  Popover,
  Loader,
  EmptyStateLayout,
} from '@strapi/design-system';
import {
  Plus,
  Trash,
  Download,
  Filter,
  EmptyDocuments,
} from '@strapi/icons';
import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, useNotification } from '@strapi/strapi/admin';

interface DataItem {
  id: number;
  documentId: string;
  name: string;
  type: string;
  status: 'active' | 'inactive' | 'archived';
  createdAt: string;
}

interface Filters {
  status: string;
  type: string;
}

const PLUGIN_ID = 'data-manager';

const DataManagementPage = () => {
  const { get, del, post } = useFetchClient();
  const { toggleNotification } = useNotification();
  const queryClient = useQueryClient();

  const [search, setSearch] = useState('');
  const [selectedIds, setSelectedIds] = useState<string[]>([]);
  const [filters, setFilters] = useState<Filters>({ status: '', type: '' });
  const [showFilters, setShowFilters] = useState(false);

  // Fetch data
  const { data, isLoading } = useQuery({
    queryKey: [PLUGIN_ID, 'items', { search, filters }],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (search) params.set('_q', search);
      if (filters.status) params.set('status', filters.status);
      if (filters.type) params.set('type', filters.type);
      const { data } = await get(`/${PLUGIN_ID}/items?${params}`);
      return data as DataItem[];
    },
  });

  // Bulk delete mutation
  const bulkDeleteMutation = useMutation({
    mutationFn: async (ids: string[]) => {
      await Promise.all(ids.map((id) => del(`/${PLUGIN_ID}/items/${id}`)));
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [PLUGIN_ID, 'items'] });
      toggleNotification({
        type: 'success',
        message: `${selectedIds.length} item(s) deleted`,
      });
      setSelectedIds([]);
    },
    onError: () => {
      toggleNotification({
        type: 'danger',
        message: 'Failed to delete items',
      });
    },
  });

  // Export mutation
  const exportMutation = useMutation({
    mutationFn: async () => {
      const { data } = await post(`/${PLUGIN_ID}/export`, { ids: selectedIds });
      return data;
    },
    onSuccess: (data: { url: string }) => {
      window.open(data.url, '_blank');
      toggleNotification({
        type: 'success',
        message: 'Export ready for download',
      });
    },
  });

  const items = data || [];
  const allSelected = selectedIds.length === items.length && items.length > 0;
  const someSelected = selectedIds.length > 0 && !allSelected;

  const toggleAll = () => {
    if (allSelected) {
      setSelectedIds([]);
    } else {
      setSelectedIds(items.map((item) => item.documentId));
    }
  };

  const toggleOne = (documentId: string) => {
    if (selectedIds.includes(documentId)) {
      setSelectedIds(selectedIds.filter((id) => id !== documentId));
    } else {
      setSelectedIds([...selectedIds, documentId]);
    }
  };

  const getStatusBadge = (status: DataItem['status']) => {
    const config = {
      active: { bg: 'success100', text: 'success700' },
      inactive: { bg: 'neutral150', text: 'neutral600' },
      archived: { bg: 'warning100', text: 'warning700' },
    };
    const { bg, text } = config[status];
    return (
      <Badge backgroundColor={bg} textColor={text}>
        {status}
      </Badge>
    );
  };

  const hasActiveFilters = filters.status || filters.type;

  return (
    <Main>
      {/* Header */}
      <Box paddingLeft={10} paddingRight={10} paddingTop={8} paddingBottom={6}>
        <Flex justifyContent="space-between" alignItems="center">
          <Typography variant="alpha">Data Management</Typography>
          <Button startIcon={<Plus />}>Add Item</Button>
        </Flex>
      </Box>

      {/* Toolbar */}
      <Box paddingLeft={10} paddingRight={10} paddingBottom={4}>
        <Flex gap={4} justifyContent="space-between">
          <Flex gap={2} flex={1}>
            <Box flex={1} maxWidth="400px">
              <Searchbar
                name="search"
                value={search}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
                  setSearch(e.target.value)
                }
                onClear={() => setSearch('')}
                placeholder="Search items..."
              >
                Search
              </Searchbar>
            </Box>

            <Popover.Root open={showFilters} onOpenChange={setShowFilters}>
              <Popover.Trigger>
                <Button
                  variant={hasActiveFilters ? 'default' : 'tertiary'}
                  startIcon={<Filter />}
                >
                  Filters
                  {hasActiveFilters && (
                    <Badge marginLeft={2}>
                      {[filters.status, filters.type].filter(Boolean).length}
                    </Badge>
                  )}
                </Button>
              </Popover.Trigger>
              <Popover.Content>
                <Box padding={4} width="280px">
                  <Flex direction="column" gap={4}>
                    <Field.Root name="statusFilter">
                      <Field.Label>Status</Field.Label>
                      <Select
                        value={filters.status}
                        onChange={(value: string) =>
                          setFilters((prev) => ({ ...prev, status: value }))
                        }
                        placeholder="All statuses"
                      >
                        <Option value="">All</Option>
                        <Option value="active">Active</Option>
                        <Option value="inactive">Inactive</Option>
                        <Option value="archived">Archived</Option>
                      </Select>
                    </Field.Root>

                    <Field.Root name="typeFilter">
                      <Field.Label>Type</Field.Label>
                      <Select
                        value={filters.type}
                        onChange={(value: string) =>
                          setFilters((prev) => ({ ...prev, type: value }))
                        }
                        placeholder="All types"
                      >
                        <Option value="">All</Option>
                        <Option value="document">Document</Option>
                        <Option value="image">Image</Option>
                        <Option value="video">Video</Option>
                      </Select>
                    </Field.Root>

                    <Flex justifyContent="flex-end" gap={2}>
                      <Button
                        variant="tertiary"
                        onClick={() => setFilters({ status: '', type: '' })}
                      >
                        Clear
                      </Button>
                      <Button onClick={() => setShowFilters(false)}>
                        Apply
                      </Button>
                    </Flex>
                  </Flex>
                </Box>
              </Popover.Content>
            </Popover.Root>
          </Flex>

          {selectedIds.length > 0 && (
            <Flex gap={2}>
              <Typography textColor="neutral600">
                {selectedIds.length} selected
              </Typography>
              <Button
                variant="secondary"
                startIcon={<Download />}
                onClick={() => exportMutation.mutate()}
                loading={exportMutation.isPending}
              >
                Export
              </Button>
              <Button
                variant="danger"
                startIcon={<Trash />}
                onClick={() => bulkDeleteMutation.mutate(selectedIds)}
                loading={bulkDeleteMutation.isPending}
              >
                Delete
              </Button>
            </Flex>
          )}
        </Flex>
      </Box>

      {/* Table */}
      <Box paddingLeft={10} paddingRight={10}>
        {isLoading ? (
          <Flex justifyContent="center" padding={8}>
            <Loader>Loading data...</Loader>
          </Flex>
        ) : items.length === 0 ? (
          <EmptyStateLayout
            icon={<EmptyDocuments />}
            content="No items found"
            action={
              <Button startIcon={<Plus />}>Add your first item</Button>
            }
          />
        ) : (
          <Table colCount={5} rowCount={items.length + 1}>
            <Thead>
              <Tr>
                <Th>
                  <Checkbox
                    checked={allSelected}
                    indeterminate={someSelected}
                    onCheckedChange={toggleAll}
                    aria-label="Select all"
                  />
                </Th>
                <Th>
                  <Typography variant="sigma">Name</Typography>
                </Th>
                <Th>
                  <Typography variant="sigma">Type</Typography>
                </Th>
                <Th>
                  <Typography variant="sigma">Status</Typography>
                </Th>
                <Th>
                  <Typography variant="sigma">Created</Typography>
                </Th>
              </Tr>
            </Thead>
            <Tbody>
              {items.map((item) => (
                <Tr key={item.id}>
                  <Td>
                    <Checkbox
                      checked={selectedIds.includes(item.documentId)}
                      onCheckedChange={() => toggleOne(item.documentId)}
                      aria-label={`Select ${item.name}`}
                    />
                  </Td>
                  <Td>
                    <Typography fontWeight="semiBold">{item.name}</Typography>
                  </Td>
                  <Td>
                    <Typography textColor="neutral600">{item.type}</Typography>
                  </Td>
                  <Td>{getStatusBadge(item.status)}</Td>
                  <Td>
                    <Typography textColor="neutral600">
                      {new Date(item.createdAt).toLocaleDateString()}
                    </Typography>
                  </Td>
                </Tr>
              ))}
            </Tbody>
          </Table>
        )}
      </Box>
    </Main>
  );
};

export default DataManagementPage;
```

---

## Import/Export Interface

```tsx
// admin/src/pages/ImportExportPage.tsx
import {
  Main,
  Box,
  Flex,
  Typography,
  Button,
  Card,
  Grid,
  Field,
  Select,
  Option,
  Toggle,
  ProgressBar,
  Alert,
  Divider,
} from '@strapi/design-system';
import { Upload, Download, File } from '@strapi/icons';
import { useState, useRef } from 'react';
import { useMutation } from '@tanstack/react-query';
import { useFetchClient, useNotification } from '@strapi/strapi/admin';

const PLUGIN_ID = 'data-manager';

interface ImportResult {
  success: number;
  failed: number;
  errors: string[];
}

const ImportExportPage = () => {
  const { post, get } = useFetchClient();
  const { toggleNotification } = useNotification();
  const fileInputRef = useRef<HTMLInputElement>(null);

  // Import state
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [importOptions, setImportOptions] = useState({
    overwrite: false,
    skipErrors: true,
  });
  const [importProgress, setImportProgress] = useState(0);
  const [importResult, setImportResult] = useState<ImportResult | null>(null);

  // Export state
  const [exportFormat, setExportFormat] = useState('json');
  const [exportOptions, setExportOptions] = useState({
    includeRelations: true,
    includeDrafts: false,
  });

  // Import mutation
  const importMutation = useMutation({
    mutationFn: async () => {
      if (!selectedFile) throw new Error('No file selected');

      const formData = new FormData();
      formData.append('file', selectedFile);
      formData.append('options', JSON.stringify(importOptions));

      // Simulate progress
      const progressInterval = setInterval(() => {
        setImportProgress((prev) => Math.min(prev + 10, 90));
      }, 200);

      try {
        const { data } = await post(`/${PLUGIN_ID}/import`, formData);
        clearInterval(progressInterval);
        setImportProgress(100);
        return data as ImportResult;
      } catch (error) {
        clearInterval(progressInterval);
        throw error;
      }
    },
    onSuccess: (result) => {
      setImportResult(result);
      toggleNotification({
        type: 'success',
        message: `Import completed: ${result.success} items imported`,
      });
    },
    onError: (error: Error) => {
      setImportProgress(0);
      toggleNotification({
        type: 'danger',
        message: error.message || 'Import failed',
      });
    },
  });

  // Export mutation
  const exportMutation = useMutation({
    mutationFn: async () => {
      const { data } = await post(`/${PLUGIN_ID}/export`, {
        format: exportFormat,
        options: exportOptions,
      });
      return data as { url: string; filename: string };
    },
    onSuccess: (data) => {
      // Trigger download
      const link = document.createElement('a');
      link.href = data.url;
      link.download = data.filename;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);

      toggleNotification({
        type: 'success',
        message: 'Export completed',
      });
    },
    onError: () => {
      toggleNotification({
        type: 'danger',
        message: 'Export failed',
      });
    },
  });

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setSelectedFile(file);
      setImportProgress(0);
      setImportResult(null);
    }
  };

  const handleImport = () => {
    setImportProgress(0);
    setImportResult(null);
    importMutation.mutate();
  };

  const resetImport = () => {
    setSelectedFile(null);
    setImportProgress(0);
    setImportResult(null);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  return (
    <Main>
      {/* Header */}
      <Box paddingLeft={10} paddingRight={10} paddingTop={8} paddingBottom={6}>
        <Typography variant="alpha">Import / Export</Typography>
        <Typography variant="epsilon" textColor="neutral600">
          Import data from files or export your data
        </Typography>
      </Box>

      {/* Content */}
      <Box paddingLeft={10} paddingRight={10}>
        <Grid.Root gap={6}>
          {/* Import Section */}
          <Grid.Item col={6}>
            <Card padding={6} height="100%">
              <Flex direction="column" gap={4}>
                <Flex gap={2} alignItems="center">
                  <Upload />
                  <Typography variant="delta">Import Data</Typography>
                </Flex>

                <Divider />

                {/* File Upload */}
                <Box>
                  <input
                    ref={fileInputRef}
                    type="file"
                    accept=".json,.csv,.xlsx"
                    onChange={handleFileSelect}
                    style={{ display: 'none' }}
                    id="import-file"
                  />
                  <label htmlFor="import-file">
                    <Box
                      padding={6}
                      background="neutral100"
                      borderColor="neutral200"
                      borderStyle="dashed"
                      borderWidth="1px"
                      borderRadius="4px"
                      style={{ cursor: 'pointer' }}
                    >
                      <Flex
                        direction="column"
                        alignItems="center"
                        gap={2}
                      >
                        <File width="32px" height="32px" />
                        {selectedFile ? (
                          <Typography fontWeight="semiBold">
                            {selectedFile.name}
                          </Typography>
                        ) : (
                          <>
                            <Typography fontWeight="semiBold">
                              Click to upload
                            </Typography>
                            <Typography textColor="neutral600" variant="pi">
                              JSON, CSV, or Excel files
                            </Typography>
                          </>
                        )}
                      </Flex>
                    </Box>
                  </label>
                </Box>

                {/* Import Options */}
                {selectedFile && (
                  <>
                    <Field.Root name="overwrite">
                      <Flex gap={2} alignItems="center">
                        <Toggle
                          checked={importOptions.overwrite}
                          onCheckedChange={(checked: boolean) =>
                            setImportOptions((prev) => ({
                              ...prev,
                              overwrite: checked,
                            }))
                          }
                        />
                        <Field.Label>Overwrite existing items</Field.Label>
                      </Flex>
                    </Field.Root>

                    <Field.Root name="skipErrors">
                      <Flex gap={2} alignItems="center">
                        <Toggle
                          checked={importOptions.skipErrors}
                          onCheckedChange={(checked: boolean) =>
                            setImportOptions((prev) => ({
                              ...prev,
                              skipErrors: checked,
                            }))
                          }
                        />
                        <Field.Label>Skip items with errors</Field.Label>
                      </Flex>
                    </Field.Root>

                    {/* Progress */}
                    {importMutation.isPending && (
                      <Box>
                        <Typography variant="pi" paddingBottom={2}>
                          Importing... {importProgress}%
                        </Typography>
                        <ProgressBar value={importProgress} />
                      </Box>
                    )}

                    {/* Result */}
                    {importResult && (
                      <Alert
                        variant={importResult.failed > 0 ? 'warning' : 'success'}
                        title="Import Complete"
                      >
                        <Typography>
                          {importResult.success} items imported successfully
                          {importResult.failed > 0 &&
                            `, ${importResult.failed} failed`}
                        </Typography>
                      </Alert>
                    )}

                    <Flex gap={2}>
                      <Button
                        onClick={handleImport}
                        loading={importMutation.isPending}
                        disabled={!!importResult}
                        startIcon={<Upload />}
                      >
                        Import
                      </Button>
                      {importResult && (
                        <Button variant="tertiary" onClick={resetImport}>
                          Import Another
                        </Button>
                      )}
                    </Flex>
                  </>
                )}
              </Flex>
            </Card>
          </Grid.Item>

          {/* Export Section */}
          <Grid.Item col={6}>
            <Card padding={6} height="100%">
              <Flex direction="column" gap={4}>
                <Flex gap={2} alignItems="center">
                  <Download />
                  <Typography variant="delta">Export Data</Typography>
                </Flex>

                <Divider />

                <Field.Root name="exportFormat">
                  <Field.Label>Export Format</Field.Label>
                  <Select
                    value={exportFormat}
                    onChange={(value: string) => setExportFormat(value)}
                  >
                    <Option value="json">JSON</Option>
                    <Option value="csv">CSV</Option>
                    <Option value="xlsx">Excel (XLSX)</Option>
                  </Select>
                </Field.Root>

                <Field.Root name="includeRelations">
                  <Flex gap={2} alignItems="center">
                    <Toggle
                      checked={exportOptions.includeRelations}
                      onCheckedChange={(checked: boolean) =>
                        setExportOptions((prev) => ({
                          ...prev,
                          includeRelations: checked,
                        }))
                      }
                    />
                    <Field.Label>Include relations</Field.Label>
                  </Flex>
                  <Field.Hint>
                    Export related content with each item
                  </Field.Hint>
                </Field.Root>

                <Field.Root name="includeDrafts">
                  <Flex gap={2} alignItems="center">
                    <Toggle
                      checked={exportOptions.includeDrafts}
                      onCheckedChange={(checked: boolean) =>
                        setExportOptions((prev) => ({
                          ...prev,
                          includeDrafts: checked,
                        }))
                      }
                    />
                    <Field.Label>Include drafts</Field.Label>
                  </Flex>
                  <Field.Hint>
                    Export unpublished draft content
                  </Field.Hint>
                </Field.Root>

                <Button
                  onClick={() => exportMutation.mutate()}
                  loading={exportMutation.isPending}
                  startIcon={<Download />}
                >
                  Export All Data
                </Button>
              </Flex>
            </Card>
          </Grid.Item>
        </Grid.Root>
      </Box>
    </Main>
  );
};

export default ImportExportPage;
```

---

## Dashboard with Charts

A dashboard using Strapi Design System with custom chart visualization.

```tsx
// admin/src/pages/AnalyticsDashboard.tsx
import {
  Main,
  Box,
  Flex,
  Typography,
  Card,
  Grid,
  Select,
  Option,
  Field,
  Badge,
  Loader,
} from '@strapi/design-system';
import { useQuery } from '@tanstack/react-query';
import { useFetchClient } from '@strapi/strapi/admin';
import { useState } from 'react';

const PLUGIN_ID = 'analytics';

interface AnalyticsData {
  overview: {
    totalViews: number;
    totalUsers: number;
    totalContent: number;
    engagement: number;
  };
  trends: {
    date: string;
    views: number;
    users: number;
  }[];
  topContent: {
    id: number;
    title: string;
    views: number;
    growth: number;
  }[];
}

// Simple bar chart component using design system primitives
interface BarChartProps {
  data: { label: string; value: number }[];
  maxValue: number;
}

const BarChart = ({ data, maxValue }: BarChartProps) => (
  <Flex direction="column" gap={3}>
    {data.map((item, index) => (
      <Flex key={index} gap={3} alignItems="center">
        <Box width="80px">
          <Typography variant="pi" textColor="neutral600" ellipsis>
            {item.label}
          </Typography>
        </Box>
        <Box flex={1}>
          <Box
            background="primary200"
            height="24px"
            borderRadius="4px"
            style={{
              width: `${(item.value / maxValue) * 100}%`,
              minWidth: '20px',
            }}
          >
            <Flex
              height="100%"
              alignItems="center"
              paddingLeft={2}
            >
              <Typography variant="pi" textColor="primary700" fontWeight="semiBold">
                {item.value.toLocaleString()}
              </Typography>
            </Flex>
          </Box>
        </Box>
      </Flex>
    ))}
  </Flex>
);

// Stat card component
interface StatCardProps {
  label: string;
  value: number | string;
  trend?: number;
  color?: string;
}

const StatCard = ({ label, value, trend, color = 'primary600' }: StatCardProps) => (
  <Card padding={6}>
    <Flex direction="column" gap={2}>
      <Typography variant="pi" textColor="neutral600">
        {label}
      </Typography>
      <Flex alignItems="baseline" gap={2}>
        <Typography variant="alpha" textColor={color}>
          {typeof value === 'number' ? value.toLocaleString() : value}
        </Typography>
        {trend !== undefined && (
          <Badge
            backgroundColor={trend >= 0 ? 'success100' : 'danger100'}
            textColor={trend >= 0 ? 'success700' : 'danger700'}
          >
            {trend >= 0 ? '+' : ''}{trend}%
          </Badge>
        )}
      </Flex>
    </Flex>
  </Card>
);

const AnalyticsDashboard = () => {
  const { get } = useFetchClient();
  const [timeRange, setTimeRange] = useState('7d');

  const { data, isLoading } = useQuery({
    queryKey: [PLUGIN_ID, 'analytics', timeRange],
    queryFn: async () => {
      const { data } = await get(`/${PLUGIN_ID}/analytics?range=${timeRange}`);
      return data as AnalyticsData;
    },
  });

  if (isLoading) {
    return (
      <Main>
        <Flex justifyContent="center" padding={8}>
          <Loader>Loading analytics...</Loader>
        </Flex>
      </Main>
    );
  }

  const overview = data?.overview;
  const trends = data?.trends || [];
  const topContent = data?.topContent || [];

  // Prepare chart data
  const trendChartData = trends.slice(-7).map((t) => ({
    label: new Date(t.date).toLocaleDateString('en', { weekday: 'short' }),
    value: t.views,
  }));
  const maxTrendValue = Math.max(...trendChartData.map((d) => d.value), 1);

  const contentChartData = topContent.slice(0, 5).map((c) => ({
    label: c.title,
    value: c.views,
  }));
  const maxContentValue = Math.max(...contentChartData.map((d) => d.value), 1);

  return (
    <Main>
      {/* Header */}
      <Box paddingLeft={10} paddingRight={10} paddingTop={8} paddingBottom={6}>
        <Flex justifyContent="space-between" alignItems="center">
          <Box>
            <Typography variant="alpha">Analytics Dashboard</Typography>
            <Typography variant="epsilon" textColor="neutral600">
              Overview of your content performance
            </Typography>
          </Box>
          <Box width="200px">
            <Field.Root name="timeRange">
              <Select
                value={timeRange}
                onChange={(value: string) => setTimeRange(value)}
              >
                <Option value="7d">Last 7 days</Option>
                <Option value="30d">Last 30 days</Option>
                <Option value="90d">Last 90 days</Option>
                <Option value="1y">Last year</Option>
              </Select>
            </Field.Root>
          </Box>
        </Flex>
      </Box>

      {/* Stats Grid */}
      <Box paddingLeft={10} paddingRight={10} paddingBottom={6}>
        <Grid.Root gap={6}>
          <Grid.Item col={3}>
            <StatCard
              label="Total Views"
              value={overview?.totalViews || 0}
              trend={12}
            />
          </Grid.Item>
          <Grid.Item col={3}>
            <StatCard
              label="Active Users"
              value={overview?.totalUsers || 0}
              trend={8}
              color="success600"
            />
          </Grid.Item>
          <Grid.Item col={3}>
            <StatCard
              label="Total Content"
              value={overview?.totalContent || 0}
              trend={3}
              color="secondary600"
            />
          </Grid.Item>
          <Grid.Item col={3}>
            <StatCard
              label="Engagement Rate"
              value={`${overview?.engagement || 0}%`}
              trend={-2}
              color="warning600"
            />
          </Grid.Item>
        </Grid.Root>
      </Box>

      {/* Charts */}
      <Box paddingLeft={10} paddingRight={10}>
        <Grid.Root gap={6}>
          {/* Trends Chart */}
          <Grid.Item col={6}>
            <Card padding={6}>
              <Typography variant="delta" paddingBottom={4}>
                Views Trend
              </Typography>
              <BarChart data={trendChartData} maxValue={maxTrendValue} />
            </Card>
          </Grid.Item>

          {/* Top Content */}
          <Grid.Item col={6}>
            <Card padding={6}>
              <Typography variant="delta" paddingBottom={4}>
                Top Content
              </Typography>
              <BarChart data={contentChartData} maxValue={maxContentValue} />
            </Card>
          </Grid.Item>

          {/* Content Table */}
          <Grid.Item col={12}>
            <Card padding={6}>
              <Typography variant="delta" paddingBottom={4}>
                Content Performance
              </Typography>
              <Flex direction="column" gap={3}>
                {topContent.map((content) => (
                  <Flex
                    key={content.id}
                    justifyContent="space-between"
                    alignItems="center"
                    padding={3}
                    background="neutral100"
                    borderRadius="4px"
                  >
                    <Typography fontWeight="semiBold">
                      {content.title}
                    </Typography>
                    <Flex gap={4} alignItems="center">
                      <Typography textColor="neutral600">
                        {content.views.toLocaleString()} views
                      </Typography>
                      <Badge
                        backgroundColor={
                          content.growth >= 0 ? 'success100' : 'danger100'
                        }
                        textColor={
                          content.growth >= 0 ? 'success700' : 'danger700'
                        }
                      >
                        {content.growth >= 0 ? '+' : ''}
                        {content.growth}%
                      </Badge>
                    </Flex>
                  </Flex>
                ))}
              </Flex>
            </Card>
          </Grid.Item>
        </Grid.Root>
      </Box>
    </Main>
  );
};

export default AnalyticsDashboard;
```

---

## Component Summary

| Component | File | Purpose |
|-----------|------|---------|
| Plugin Registration | `admin/src/index.tsx` | Menu links, injection zones, translations |
| App Router | `admin/src/pages/App.tsx` | Route configuration with React Router |
| Home Page | `admin/src/pages/HomePage.tsx` | Dashboard with stats and quick actions |
| Task List | `admin/src/pages/TaskListPage.tsx` | CRUD table with search and pagination |
| Settings | `admin/src/pages/SettingsPage.tsx` | Tabbed settings with form validation |
| Data Management | `admin/src/pages/DataManagementPage.tsx` | Bulk actions, filtering, export |
| Import/Export | `admin/src/pages/ImportExportPage.tsx` | File upload and download |
| Analytics | `admin/src/pages/AnalyticsDashboard.tsx` | Charts and statistics |

## Key Patterns Used

| Pattern | Components | Purpose |
|---------|------------|---------|
| Page Structure | Main, Box, Flex, Typography | Consistent layout |
| Data Tables | Table, Thead, Tbody, Tr, Td, Th | List display |
| Forms | Field, TextInput, Select, Toggle | User input |
| Navigation | Link, Button with tag prop | Routing |
| State | React Query, useState | Data management |
| Feedback | Badge, Alert, Loader | Status indication |
| Dialogs | Modal, Dialog | Overlays |
