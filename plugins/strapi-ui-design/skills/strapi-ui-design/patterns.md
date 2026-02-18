# Strapi UI Design Patterns

Advanced component patterns and techniques for building Strapi v5 plugin interfaces.

## Table of Contents

- [Data Table Patterns](#data-table-patterns)
- [Form Patterns](#form-patterns)
- [Modal Patterns](#modal-patterns)
- [Settings Page Patterns](#settings-page-patterns)
- [Dashboard Patterns](#dashboard-patterns)
- [Content Manager Integration](#content-manager-integration)
- [State Management Patterns](#state-management-patterns)
- [Error Handling Patterns](#error-handling-patterns)
- [Loading States](#loading-states)
- [Empty States](#empty-states)

---

## Data Table Patterns

### Basic Data Table with Actions

```tsx
import {
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Typography,
  IconButton,
  Flex,
  Box,
  Tooltip,
  Badge,
} from '@strapi/design-system';
import { Pencil, Trash, Eye } from '@strapi/icons';

interface Item {
  id: number;
  name: string;
  status: 'draft' | 'published';
  createdAt: string;
}

interface DataTableProps {
  items: Item[];
  onEdit: (id: number) => void;
  onDelete: (id: number) => void;
  onView: (id: number) => void;
}

const DataTable = ({ items, onEdit, onDelete, onView }: DataTableProps) => {
  return (
    <Table colCount={4} rowCount={items.length + 1}>
      <Thead>
        <Tr>
          <Th>
            <Typography variant="sigma">Name</Typography>
          </Th>
          <Th>
            <Typography variant="sigma">Status</Typography>
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
        {items.map((item) => (
          <Tr key={item.id}>
            <Td>
              <Typography textColor="neutral800">{item.name}</Typography>
            </Td>
            <Td>
              <Badge
                backgroundColor={item.status === 'published' ? 'success100' : 'neutral150'}
                textColor={item.status === 'published' ? 'success700' : 'neutral600'}
              >
                {item.status}
              </Badge>
            </Td>
            <Td>
              <Typography textColor="neutral600">
                {new Date(item.createdAt).toLocaleDateString()}
              </Typography>
            </Td>
            <Td>
              <Flex gap={1}>
                <Tooltip description="View">
                  <IconButton
                    label="View"
                    onClick={() => onView(item.id)}
                  >
                    <Eye />
                  </IconButton>
                </Tooltip>
                <Tooltip description="Edit">
                  <IconButton
                    label="Edit"
                    onClick={() => onEdit(item.id)}
                  >
                    <Pencil />
                  </IconButton>
                </Tooltip>
                <Tooltip description="Delete">
                  <IconButton
                    label="Delete"
                    onClick={() => onDelete(item.id)}
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
  );
};
```

### Table with Selection

```tsx
import {
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Checkbox,
  Typography,
  Flex,
  Button,
  Box,
} from '@strapi/design-system';
import { Trash } from '@strapi/icons';
import { useState } from 'react';

interface SelectableTableProps {
  items: Array<{ id: number; name: string }>;
  onBulkDelete: (ids: number[]) => void;
}

const SelectableTable = ({ items, onBulkDelete }: SelectableTableProps) => {
  const [selectedIds, setSelectedIds] = useState<number[]>([]);

  const allSelected = selectedIds.length === items.length && items.length > 0;
  const someSelected = selectedIds.length > 0 && !allSelected;

  const toggleAll = () => {
    if (allSelected) {
      setSelectedIds([]);
    } else {
      setSelectedIds(items.map((item) => item.id));
    }
  };

  const toggleOne = (id: number) => {
    if (selectedIds.includes(id)) {
      setSelectedIds(selectedIds.filter((selectedId) => selectedId !== id));
    } else {
      setSelectedIds([...selectedIds, id]);
    }
  };

  return (
    <Box>
      {selectedIds.length > 0 && (
        <Box paddingBottom={4}>
          <Flex justifyContent="space-between" alignItems="center">
            <Typography>
              {selectedIds.length} item(s) selected
            </Typography>
            <Button
              variant="danger"
              startIcon={<Trash />}
              onClick={() => onBulkDelete(selectedIds)}
            >
              Delete Selected
            </Button>
          </Flex>
        </Box>
      )}
      <Table colCount={2} rowCount={items.length + 1}>
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
          </Tr>
        </Thead>
        <Tbody>
          {items.map((item) => (
            <Tr key={item.id}>
              <Td>
                <Checkbox
                  checked={selectedIds.includes(item.id)}
                  onCheckedChange={() => toggleOne(item.id)}
                  aria-label={`Select ${item.name}`}
                />
              </Td>
              <Td>
                <Typography>{item.name}</Typography>
              </Td>
            </Tr>
          ))}
        </Tbody>
      </Table>
    </Box>
  );
};
```

### Table with Sorting and Pagination

```tsx
import {
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Typography,
  Flex,
  Pagination,
  Box,
} from '@strapi/design-system';
import { CaretUp, CaretDown } from '@strapi/icons';
import { useState } from 'react';

type SortOrder = 'asc' | 'desc';

interface SortableTableProps {
  items: Array<{ id: number; name: string; createdAt: string }>;
  totalCount: number;
  pageSize: number;
  currentPage: number;
  onPageChange: (page: number) => void;
  onSort: (field: string, order: SortOrder) => void;
}

const SortableTable = ({
  items,
  totalCount,
  pageSize,
  currentPage,
  onPageChange,
  onSort,
}: SortableTableProps) => {
  const [sortField, setSortField] = useState<string>('name');
  const [sortOrder, setSortOrder] = useState<SortOrder>('asc');

  const handleSort = (field: string) => {
    const newOrder = sortField === field && sortOrder === 'asc' ? 'desc' : 'asc';
    setSortField(field);
    setSortOrder(newOrder);
    onSort(field, newOrder);
  };

  const SortIcon = ({ field }: { field: string }) => {
    if (sortField !== field) return null;
    return sortOrder === 'asc' ? <CaretUp /> : <CaretDown />;
  };

  const pageCount = Math.ceil(totalCount / pageSize);

  return (
    <Box>
      <Table colCount={2} rowCount={items.length + 1}>
        <Thead>
          <Tr>
            <Th
              action={<SortIcon field="name" />}
              onClick={() => handleSort('name')}
              style={{ cursor: 'pointer' }}
            >
              <Typography variant="sigma">Name</Typography>
            </Th>
            <Th
              action={<SortIcon field="createdAt" />}
              onClick={() => handleSort('createdAt')}
              style={{ cursor: 'pointer' }}
            >
              <Typography variant="sigma">Created</Typography>
            </Th>
          </Tr>
        </Thead>
        <Tbody>
          {items.map((item) => (
            <Tr key={item.id}>
              <Td>
                <Typography>{item.name}</Typography>
              </Td>
              <Td>
                <Typography textColor="neutral600">
                  {new Date(item.createdAt).toLocaleDateString()}
                </Typography>
              </Td>
            </Tr>
          ))}
        </Tbody>
      </Table>
      <Box paddingTop={4}>
        <Flex justifyContent="flex-end">
          <Pagination activePage={currentPage} pageCount={pageCount}>
            <Pagination.PageLink number={1}>First</Pagination.PageLink>
            <Pagination.PreviousLink onClick={() => onPageChange(currentPage - 1)}>
              Previous
            </Pagination.PreviousLink>
            <Pagination.NextLink onClick={() => onPageChange(currentPage + 1)}>
              Next
            </Pagination.NextLink>
            <Pagination.PageLink number={pageCount}>Last</Pagination.PageLink>
          </Pagination>
        </Flex>
      </Box>
    </Box>
  );
};
```

---

## Form Patterns

### Complete Form with Validation

```tsx
import {
  Box,
  Flex,
  Button,
  Typography,
  Field,
  TextInput,
  Textarea,
  Select,
  Option,
  Toggle,
  Grid,
} from '@strapi/design-system';
import { Check, Cross } from '@strapi/icons';
import { useState } from 'react';

interface FormData {
  title: string;
  description: string;
  category: string;
  isPublished: boolean;
}

interface FormErrors {
  title?: string;
  description?: string;
  category?: string;
}

interface EntityFormProps {
  initialData?: FormData;
  onSubmit: (data: FormData) => void;
  onCancel: () => void;
  isLoading?: boolean;
}

const EntityForm = ({
  initialData,
  onSubmit,
  onCancel,
  isLoading = false,
}: EntityFormProps) => {
  const [formData, setFormData] = useState<FormData>(
    initialData || {
      title: '',
      description: '',
      category: '',
      isPublished: false,
    }
  );
  const [errors, setErrors] = useState<FormErrors>({});

  const validate = (): boolean => {
    const newErrors: FormErrors = {};

    if (!formData.title.trim()) {
      newErrors.title = 'Title is required';
    } else if (formData.title.length < 3) {
      newErrors.title = 'Title must be at least 3 characters';
    }

    if (!formData.category) {
      newErrors.category = 'Please select a category';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (validate()) {
      onSubmit(formData);
    }
  };

  const handleChange = (field: keyof FormData, value: string | boolean) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
    // Clear error when field is modified
    if (errors[field as keyof FormErrors]) {
      setErrors((prev) => ({ ...prev, [field]: undefined }));
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <Flex direction="column" gap={6}>
        {/* Title Field */}
        <Field.Root name="title" error={errors.title} required>
          <Field.Label>Title</Field.Label>
          <TextInput
            value={formData.title}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
              handleChange('title', e.target.value)
            }
            placeholder="Enter a title"
            disabled={isLoading}
          />
          <Field.Hint>A descriptive title for your item</Field.Hint>
          <Field.Error />
        </Field.Root>

        {/* Description Field */}
        <Field.Root name="description">
          <Field.Label>Description</Field.Label>
          <Textarea
            value={formData.description}
            onChange={(e: React.ChangeEvent<HTMLTextAreaElement>) =>
              handleChange('description', e.target.value)
            }
            placeholder="Enter a description (optional)"
            disabled={isLoading}
          />
          <Field.Hint>Provide additional details</Field.Hint>
        </Field.Root>

        {/* Category Field */}
        <Field.Root name="category" error={errors.category} required>
          <Field.Label>Category</Field.Label>
          <Select
            value={formData.category}
            onChange={(value: string) => handleChange('category', value)}
            placeholder="Select a category"
            disabled={isLoading}
          >
            <Option value="general">General</Option>
            <Option value="technical">Technical</Option>
            <Option value="marketing">Marketing</Option>
          </Select>
          <Field.Error />
        </Field.Root>

        {/* Published Toggle */}
        <Field.Root name="isPublished">
          <Flex gap={2} alignItems="center">
            <Toggle
              checked={formData.isPublished}
              onCheckedChange={(checked: boolean) =>
                handleChange('isPublished', checked)
              }
              disabled={isLoading}
            />
            <Field.Label>Published</Field.Label>
          </Flex>
          <Field.Hint>Make this item visible to the public</Field.Hint>
        </Field.Root>

        {/* Form Actions */}
        <Flex justifyContent="flex-end" gap={2}>
          <Button
            variant="tertiary"
            onClick={onCancel}
            disabled={isLoading}
          >
            Cancel
          </Button>
          <Button
            type="submit"
            loading={isLoading}
            startIcon={<Check />}
          >
            {initialData ? 'Save Changes' : 'Create'}
          </Button>
        </Flex>
      </Flex>
    </form>
  );
};
```

### Multi-Step Form

```tsx
import {
  Box,
  Flex,
  Button,
  Typography,
  Field,
  TextInput,
  ProgressBar,
} from '@strapi/design-system';
import { ArrowLeft, ArrowRight, Check } from '@strapi/icons';
import { useState } from 'react';

interface Step {
  title: string;
  component: React.ReactNode;
}

interface MultiStepFormProps {
  steps: Step[];
  onComplete: (data: Record<string, unknown>) => void;
}

const MultiStepForm = ({ steps, onComplete }: MultiStepFormProps) => {
  const [currentStep, setCurrentStep] = useState(0);
  const [formData, setFormData] = useState<Record<string, unknown>>({});

  const progress = ((currentStep + 1) / steps.length) * 100;

  const goNext = () => {
    if (currentStep < steps.length - 1) {
      setCurrentStep(currentStep + 1);
    }
  };

  const goBack = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  const handleComplete = () => {
    onComplete(formData);
  };

  return (
    <Box>
      {/* Progress Header */}
      <Box paddingBottom={6}>
        <Flex justifyContent="space-between" alignItems="center" paddingBottom={2}>
          <Typography variant="beta">{steps[currentStep].title}</Typography>
          <Typography textColor="neutral600">
            Step {currentStep + 1} of {steps.length}
          </Typography>
        </Flex>
        <ProgressBar value={progress} />
      </Box>

      {/* Step Content */}
      <Box paddingBottom={6}>{steps[currentStep].component}</Box>

      {/* Navigation */}
      <Flex justifyContent="space-between">
        <Button
          variant="tertiary"
          startIcon={<ArrowLeft />}
          onClick={goBack}
          disabled={currentStep === 0}
        >
          Back
        </Button>
        {currentStep === steps.length - 1 ? (
          <Button startIcon={<Check />} onClick={handleComplete}>
            Complete
          </Button>
        ) : (
          <Button endIcon={<ArrowRight />} onClick={goNext}>
            Next
          </Button>
        )}
      </Flex>
    </Box>
  );
};
```

### Inline Editable Field

```tsx
import {
  Box,
  Flex,
  Typography,
  TextInput,
  IconButton,
} from '@strapi/design-system';
import { Pencil, Check, Cross } from '@strapi/icons';
import { useState } from 'react';

interface InlineEditProps {
  value: string;
  onSave: (value: string) => void;
  label: string;
}

const InlineEdit = ({ value, onSave, label }: InlineEditProps) => {
  const [isEditing, setIsEditing] = useState(false);
  const [editValue, setEditValue] = useState(value);

  const handleSave = () => {
    onSave(editValue);
    setIsEditing(false);
  };

  const handleCancel = () => {
    setEditValue(value);
    setIsEditing(false);
  };

  if (isEditing) {
    return (
      <Flex gap={2} alignItems="center">
        <TextInput
          value={editValue}
          onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
            setEditValue(e.target.value)
          }
          aria-label={label}
          autoFocus
        />
        <IconButton label="Save" onClick={handleSave}>
          <Check />
        </IconButton>
        <IconButton label="Cancel" onClick={handleCancel}>
          <Cross />
        </IconButton>
      </Flex>
    );
  }

  return (
    <Flex gap={2} alignItems="center">
      <Typography>{value}</Typography>
      <IconButton label={`Edit ${label}`} onClick={() => setIsEditing(true)}>
        <Pencil />
      </IconButton>
    </Flex>
  );
};
```

---

## Modal Patterns

### Confirmation Dialog

```tsx
import {
  Dialog,
  Button,
  Flex,
  Typography,
} from '@strapi/design-system';
import { Trash, ExclamationMarkCircle } from '@strapi/icons';

interface ConfirmDeleteDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  itemName: string;
  isLoading?: boolean;
}

const ConfirmDeleteDialog = ({
  isOpen,
  onClose,
  onConfirm,
  itemName,
  isLoading = false,
}: ConfirmDeleteDialogProps) => {
  return (
    <Dialog.Root open={isOpen} onOpenChange={onClose}>
      <Dialog.Content>
        <Dialog.Header>Delete {itemName}</Dialog.Header>
        <Dialog.Body icon={<ExclamationMarkCircle />}>
          <Flex direction="column" gap={2}>
            <Typography>
              Are you sure you want to delete <strong>{itemName}</strong>?
            </Typography>
            <Typography textColor="neutral600">
              This action cannot be undone.
            </Typography>
          </Flex>
        </Dialog.Body>
        <Dialog.Footer>
          <Dialog.Cancel>
            <Button variant="tertiary" disabled={isLoading}>
              Cancel
            </Button>
          </Dialog.Cancel>
          <Dialog.Action>
            <Button
              variant="danger"
              startIcon={<Trash />}
              onClick={onConfirm}
              loading={isLoading}
            >
              Delete
            </Button>
          </Dialog.Action>
        </Dialog.Footer>
      </Dialog.Content>
    </Dialog.Root>
  );
};
```

### Form Modal

```tsx
import {
  Modal,
  Button,
  Field,
  TextInput,
  Flex,
} from '@strapi/design-system';
import { Plus, Check } from '@strapi/icons';
import { useState } from 'react';

interface CreateItemModalProps {
  isOpen: boolean;
  onClose: () => void;
  onCreate: (name: string) => void;
  isLoading?: boolean;
}

const CreateItemModal = ({
  isOpen,
  onClose,
  onCreate,
  isLoading = false,
}: CreateItemModalProps) => {
  const [name, setName] = useState('');
  const [error, setError] = useState<string | undefined>();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) {
      setError('Name is required');
      return;
    }
    onCreate(name);
  };

  const handleClose = () => {
    setName('');
    setError(undefined);
    onClose();
  };

  return (
    <Modal.Root open={isOpen} onOpenChange={handleClose}>
      <Modal.Content>
        <Modal.Header>
          <Modal.Title>Create New Item</Modal.Title>
        </Modal.Header>
        <form onSubmit={handleSubmit}>
          <Modal.Body>
            <Field.Root name="name" error={error} required>
              <Field.Label>Name</Field.Label>
              <TextInput
                value={name}
                onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
                  setName(e.target.value);
                  setError(undefined);
                }}
                placeholder="Enter item name"
                disabled={isLoading}
              />
              <Field.Error />
            </Field.Root>
          </Modal.Body>
          <Modal.Footer>
            <Modal.Close>
              <Button variant="tertiary" disabled={isLoading}>
                Cancel
              </Button>
            </Modal.Close>
            <Button
              type="submit"
              loading={isLoading}
              startIcon={<Check />}
            >
              Create
            </Button>
          </Modal.Footer>
        </form>
      </Modal.Content>
    </Modal.Root>
  );
};
```

### Detail View Modal

```tsx
import {
  Modal,
  Button,
  Typography,
  Box,
  Flex,
  Badge,
  Divider,
} from '@strapi/design-system';
import { Pencil, Trash } from '@strapi/icons';

interface Item {
  id: number;
  name: string;
  description: string;
  status: 'draft' | 'published';
  createdAt: string;
  updatedAt: string;
}

interface DetailModalProps {
  item: Item | null;
  isOpen: boolean;
  onClose: () => void;
  onEdit: (item: Item) => void;
  onDelete: (item: Item) => void;
}

const DetailModal = ({
  item,
  isOpen,
  onClose,
  onEdit,
  onDelete,
}: DetailModalProps) => {
  if (!item) return null;

  return (
    <Modal.Root open={isOpen} onOpenChange={onClose}>
      <Modal.Content>
        <Modal.Header>
          <Modal.Title>{item.name}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Flex direction="column" gap={4}>
            <Box>
              <Typography variant="sigma" textColor="neutral600">
                Status
              </Typography>
              <Box paddingTop={1}>
                <Badge
                  backgroundColor={
                    item.status === 'published' ? 'success100' : 'neutral150'
                  }
                  textColor={
                    item.status === 'published' ? 'success700' : 'neutral600'
                  }
                >
                  {item.status}
                </Badge>
              </Box>
            </Box>
            <Divider />
            <Box>
              <Typography variant="sigma" textColor="neutral600">
                Description
              </Typography>
              <Box paddingTop={1}>
                <Typography>
                  {item.description || 'No description provided'}
                </Typography>
              </Box>
            </Box>
            <Divider />
            <Flex gap={6}>
              <Box>
                <Typography variant="sigma" textColor="neutral600">
                  Created
                </Typography>
                <Typography>
                  {new Date(item.createdAt).toLocaleString()}
                </Typography>
              </Box>
              <Box>
                <Typography variant="sigma" textColor="neutral600">
                  Updated
                </Typography>
                <Typography>
                  {new Date(item.updatedAt).toLocaleString()}
                </Typography>
              </Box>
            </Flex>
          </Flex>
        </Modal.Body>
        <Modal.Footer>
          <Flex gap={2}>
            <Button
              variant="danger-light"
              startIcon={<Trash />}
              onClick={() => onDelete(item)}
            >
              Delete
            </Button>
            <Button
              startIcon={<Pencil />}
              onClick={() => onEdit(item)}
            >
              Edit
            </Button>
          </Flex>
        </Modal.Footer>
      </Modal.Content>
    </Modal.Root>
  );
};
```

---

## Settings Page Patterns

### Plugin Settings Page

```tsx
import {
  Main,
  Box,
  Flex,
  Typography,
  Button,
  Field,
  TextInput,
  Toggle,
  Card,
  Grid,
  Alert,
} from '@strapi/design-system';
import { Check } from '@strapi/icons';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, useNotification } from '@strapi/strapi/admin';
import { useState, useEffect } from 'react';

interface PluginSettings {
  apiKey: string;
  isEnabled: boolean;
  webhookUrl: string;
}

const PLUGIN_ID = 'my-plugin';

const SettingsPage = () => {
  const { get, put } = useFetchClient();
  const { toggleNotification } = useNotification();
  const queryClient = useQueryClient();

  const [settings, setSettings] = useState<PluginSettings>({
    apiKey: '',
    isEnabled: false,
    webhookUrl: '',
  });

  // Fetch settings
  const { data, isLoading, error } = useQuery({
    queryKey: [PLUGIN_ID, 'settings'],
    queryFn: async () => {
      const { data } = await get(`/${PLUGIN_ID}/settings`);
      return data as PluginSettings;
    },
  });

  // Update local state when data loads
  useEffect(() => {
    if (data) {
      setSettings(data);
    }
  }, [data]);

  // Save mutation
  const saveMutation = useMutation({
    mutationFn: async (newSettings: PluginSettings) => {
      const { data } = await put(`/${PLUGIN_ID}/settings`, newSettings);
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

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    saveMutation.mutate(settings);
  };

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
          <Box>
            <Typography variant="alpha">Settings</Typography>
            <Typography variant="epsilon" textColor="neutral600">
              Configure your plugin settings
            </Typography>
          </Box>
          <Button
            type="submit"
            form="settings-form"
            loading={saveMutation.isPending}
            startIcon={<Check />}
          >
            Save
          </Button>
        </Flex>
      </Box>

      {/* Content */}
      <Box paddingLeft={10} paddingRight={10}>
        <form id="settings-form" onSubmit={handleSubmit}>
          <Grid.Root gap={6}>
            {/* API Configuration */}
            <Grid.Item col={12}>
              <Card padding={6}>
                <Typography variant="delta" paddingBottom={4}>
                  API Configuration
                </Typography>
                <Flex direction="column" gap={4}>
                  <Field.Root name="apiKey">
                    <Field.Label>API Key</Field.Label>
                    <TextInput
                      type="password"
                      value={settings.apiKey}
                      onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
                        setSettings((prev) => ({
                          ...prev,
                          apiKey: e.target.value,
                        }))
                      }
                      placeholder="Enter your API key"
                      disabled={isLoading}
                    />
                    <Field.Hint>
                      Your API key for authentication
                    </Field.Hint>
                  </Field.Root>

                  <Field.Root name="webhookUrl">
                    <Field.Label>Webhook URL</Field.Label>
                    <TextInput
                      value={settings.webhookUrl}
                      onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
                        setSettings((prev) => ({
                          ...prev,
                          webhookUrl: e.target.value,
                        }))
                      }
                      placeholder="https://example.com/webhook"
                      disabled={isLoading}
                    />
                    <Field.Hint>
                      URL to receive webhook notifications
                    </Field.Hint>
                  </Field.Root>
                </Flex>
              </Card>
            </Grid.Item>

            {/* Feature Toggles */}
            <Grid.Item col={12}>
              <Card padding={6}>
                <Typography variant="delta" paddingBottom={4}>
                  Feature Toggles
                </Typography>
                <Field.Root name="isEnabled">
                  <Flex gap={2} alignItems="center">
                    <Toggle
                      checked={settings.isEnabled}
                      onCheckedChange={(checked: boolean) =>
                        setSettings((prev) => ({
                          ...prev,
                          isEnabled: checked,
                        }))
                      }
                      disabled={isLoading}
                    />
                    <Field.Label>Enable Plugin</Field.Label>
                  </Flex>
                  <Field.Hint>
                    Enable or disable the plugin functionality
                  </Field.Hint>
                </Field.Root>
              </Card>
            </Grid.Item>
          </Grid.Root>
        </form>
      </Box>
    </Main>
  );
};

export default SettingsPage;
```

---

## Dashboard Patterns

### Statistics Dashboard

```tsx
import {
  Main,
  Box,
  Flex,
  Typography,
  Card,
  Grid,
  Loader,
} from '@strapi/design-system';
import { useQuery } from '@tanstack/react-query';
import { useFetchClient } from '@strapi/strapi/admin';

interface Stats {
  totalItems: number;
  publishedItems: number;
  draftItems: number;
  recentActivity: number;
}

interface StatCardProps {
  label: string;
  value: number;
  color?: string;
}

const StatCard = ({ label, value, color = 'primary600' }: StatCardProps) => (
  <Card padding={6}>
    <Flex direction="column" alignItems="center" gap={2}>
      <Typography variant="alpha" textColor={color}>
        {value.toLocaleString()}
      </Typography>
      <Typography variant="pi" textColor="neutral600">
        {label}
      </Typography>
    </Flex>
  </Card>
);

const Dashboard = () => {
  const { get } = useFetchClient();

  const { data: stats, isLoading } = useQuery({
    queryKey: ['my-plugin', 'stats'],
    queryFn: async () => {
      const { data } = await get('/my-plugin/stats');
      return data as Stats;
    },
  });

  if (isLoading) {
    return (
      <Main>
        <Flex justifyContent="center" padding={8}>
          <Loader>Loading statistics...</Loader>
        </Flex>
      </Main>
    );
  }

  return (
    <Main>
      {/* Header */}
      <Box paddingLeft={10} paddingRight={10} paddingTop={8} paddingBottom={6}>
        <Typography variant="alpha">Dashboard</Typography>
        <Typography variant="epsilon" textColor="neutral600">
          Overview of your plugin activity
        </Typography>
      </Box>

      {/* Stats Grid */}
      <Box paddingLeft={10} paddingRight={10}>
        <Grid.Root gap={6}>
          <Grid.Item col={3}>
            <StatCard label="Total Items" value={stats?.totalItems || 0} />
          </Grid.Item>
          <Grid.Item col={3}>
            <StatCard
              label="Published"
              value={stats?.publishedItems || 0}
              color="success600"
            />
          </Grid.Item>
          <Grid.Item col={3}>
            <StatCard
              label="Drafts"
              value={stats?.draftItems || 0}
              color="warning600"
            />
          </Grid.Item>
          <Grid.Item col={3}>
            <StatCard
              label="Recent Activity"
              value={stats?.recentActivity || 0}
              color="secondary600"
            />
          </Grid.Item>
        </Grid.Root>
      </Box>
    </Main>
  );
};

export default Dashboard;
```

---

## Content Manager Integration

### Injection Zone Panel

```tsx
// admin/src/components/ContentManagerPanel.tsx
import {
  Box,
  Flex,
  Typography,
  Button,
  Field,
  TextInput,
  Card,
  Loader,
} from '@strapi/design-system';
import { Plus, Refresh } from '@strapi/icons';
import { unstable_useContentManagerContext as useContentManagerContext } from '@strapi/strapi/admin';
import { useQuery } from '@tanstack/react-query';
import { useFetchClient } from '@strapi/strapi/admin';

const ContentManagerPanel = () => {
  const context = useContentManagerContext();
  const { get } = useFetchClient();

  // Get current document info
  const { model, id, document } = context;

  // Fetch related data
  const { data, isLoading } = useQuery({
    queryKey: ['my-plugin', 'related', model, id],
    queryFn: async () => {
      const { data } = await get(`/my-plugin/related/${model}/${id}`);
      return data;
    },
    enabled: !!id, // Only fetch if we have an ID (not a new document)
  });

  if (!id) {
    return (
      <Box padding={4}>
        <Typography textColor="neutral600">
          Save the document to see related data.
        </Typography>
      </Box>
    );
  }

  if (isLoading) {
    return (
      <Box padding={4}>
        <Loader small>Loading...</Loader>
      </Box>
    );
  }

  return (
    <Box padding={4}>
      <Typography variant="sigma" textColor="neutral600" paddingBottom={2}>
        Plugin Panel
      </Typography>
      <Card padding={4}>
        <Flex direction="column" gap={3}>
          <Typography variant="omega">
            Related items: {data?.count || 0}
          </Typography>
          <Button variant="secondary" startIcon={<Plus />} fullWidth>
            Add Related Item
          </Button>
        </Flex>
      </Card>
    </Box>
  );
};

export default ContentManagerPanel;
```

### Registering Injection Zone

```tsx
// admin/src/index.tsx
import { getTranslation } from './utils/getTranslation';
import { PLUGIN_ID } from './pluginId';

export default {
  register(app: any) {
    app.registerPlugin({
      id: PLUGIN_ID,
      name: PLUGIN_ID,
    });
  },

  bootstrap(app: any) {
    // Inject into Content Manager edit view
    app.injectComponent('editView', 'right-links', {
      name: 'my-plugin-panel',
      Component: async () => {
        const component = await import('./components/ContentManagerPanel');
        return component.default;
      },
    });
  },
};
```

---

## State Management Patterns

### Custom Hook for CRUD Operations

```tsx
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useFetchClient, useNotification } from '@strapi/strapi/admin';

interface Item {
  id: number;
  documentId: string;
  name: string;
}

const PLUGIN_ID = 'my-plugin';

export const useItems = () => {
  const { get, post, put, del } = useFetchClient();
  const { toggleNotification } = useNotification();
  const queryClient = useQueryClient();

  // Fetch all items
  const query = useQuery({
    queryKey: [PLUGIN_ID, 'items'],
    queryFn: async () => {
      const { data } = await get(`/${PLUGIN_ID}/items`);
      return data as Item[];
    },
  });

  // Create item
  const createMutation = useMutation({
    mutationFn: async (newItem: Omit<Item, 'id' | 'documentId'>) => {
      const { data } = await post(`/${PLUGIN_ID}/items`, newItem);
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [PLUGIN_ID, 'items'] });
      toggleNotification({
        type: 'success',
        message: 'Item created successfully',
      });
    },
    onError: (error: Error) => {
      toggleNotification({
        type: 'danger',
        message: error.message || 'Failed to create item',
      });
    },
  });

  // Update item
  const updateMutation = useMutation({
    mutationFn: async ({
      documentId,
      data: updateData,
    }: {
      documentId: string;
      data: Partial<Item>;
    }) => {
      const { data } = await put(`/${PLUGIN_ID}/items/${documentId}`, updateData);
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [PLUGIN_ID, 'items'] });
      toggleNotification({
        type: 'success',
        message: 'Item updated successfully',
      });
    },
    onError: (error: Error) => {
      toggleNotification({
        type: 'danger',
        message: error.message || 'Failed to update item',
      });
    },
  });

  // Delete item
  const deleteMutation = useMutation({
    mutationFn: async (documentId: string) => {
      await del(`/${PLUGIN_ID}/items/${documentId}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [PLUGIN_ID, 'items'] });
      toggleNotification({
        type: 'success',
        message: 'Item deleted successfully',
      });
    },
    onError: (error: Error) => {
      toggleNotification({
        type: 'danger',
        message: error.message || 'Failed to delete item',
      });
    },
  });

  return {
    items: query.data || [],
    isLoading: query.isLoading,
    error: query.error,
    createItem: createMutation.mutate,
    updateItem: updateMutation.mutate,
    deleteItem: deleteMutation.mutate,
    isCreating: createMutation.isPending,
    isUpdating: updateMutation.isPending,
    isDeleting: deleteMutation.isPending,
  };
};
```

---

## Error Handling Patterns

### Error Boundary with Fallback

```tsx
import { Box, Typography, Button, Alert, Flex } from '@strapi/design-system';
import { ArrowClockwise } from '@strapi/icons';
import { Component, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  handleRetry = () => {
    this.setState({ hasError: false, error: null });
  };

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }

      return (
        <Box padding={8}>
          <Alert
            variant="danger"
            title="Something went wrong"
            action={
              <Button
                variant="secondary"
                startIcon={<ArrowClockwise />}
                onClick={this.handleRetry}
              >
                Retry
              </Button>
            }
          >
            <Typography>
              {this.state.error?.message || 'An unexpected error occurred'}
            </Typography>
          </Alert>
        </Box>
      );
    }

    return this.props.children;
  }
}

export default ErrorBoundary;
```

### API Error Display

```tsx
import { Alert, Box, Typography, Button } from '@strapi/design-system';
import { ArrowClockwise } from '@strapi/icons';

interface ApiErrorProps {
  error: Error | null;
  onRetry?: () => void;
}

const ApiError = ({ error, onRetry }: ApiErrorProps) => {
  if (!error) return null;

  return (
    <Box padding={4}>
      <Alert
        variant="danger"
        title="Error loading data"
        action={
          onRetry && (
            <Button
              variant="secondary"
              startIcon={<ArrowClockwise />}
              onClick={onRetry}
            >
              Retry
            </Button>
          )
        }
      >
        <Typography>{error.message || 'Failed to load data'}</Typography>
      </Alert>
    </Box>
  );
};

export default ApiError;
```

---

## Loading States

### Full Page Loading

```tsx
import { Main, Flex, Loader } from '@strapi/design-system';

interface PageLoaderProps {
  message?: string;
}

const PageLoader = ({ message = 'Loading...' }: PageLoaderProps) => (
  <Main>
    <Flex
      justifyContent="center"
      alignItems="center"
      height="100%"
      minHeight="400px"
    >
      <Loader>{message}</Loader>
    </Flex>
  </Main>
);

export default PageLoader;
```

### Skeleton Loading

```tsx
import { Box, Flex, Card } from '@strapi/design-system';

const SkeletonLine = ({ width = '100%' }: { width?: string }) => (
  <Box
    background="neutral200"
    height="16px"
    width={width}
    borderRadius="4px"
  />
);

const TableRowSkeleton = () => (
  <Flex gap={4} padding={4}>
    <SkeletonLine width="30%" />
    <SkeletonLine width="20%" />
    <SkeletonLine width="15%" />
    <SkeletonLine width="10%" />
  </Flex>
);

const CardSkeleton = () => (
  <Card padding={6}>
    <Flex direction="column" gap={3}>
      <SkeletonLine width="60%" />
      <SkeletonLine width="100%" />
      <SkeletonLine width="40%" />
    </Flex>
  </Card>
);

export { SkeletonLine, TableRowSkeleton, CardSkeleton };
```

---

## Empty States

### No Data Empty State

```tsx
import { EmptyStateLayout, Button, Box } from '@strapi/design-system';
import { Plus, EmptyDocuments } from '@strapi/icons';

interface EmptyStateProps {
  title: string;
  description: string;
  action?: {
    label: string;
    onClick: () => void;
  };
}

const EmptyState = ({ title, description, action }: EmptyStateProps) => (
  <Box padding={8}>
    <EmptyStateLayout
      icon={<EmptyDocuments />}
      content={title}
      action={
        action && (
          <Button startIcon={<Plus />} onClick={action.onClick}>
            {action.label}
          </Button>
        )
      }
    />
  </Box>
);

export default EmptyState;
```

### Search No Results

```tsx
import { Box, Flex, Typography } from '@strapi/design-system';
import { Search } from '@strapi/icons';

interface NoSearchResultsProps {
  query: string;
}

const NoSearchResults = ({ query }: NoSearchResultsProps) => (
  <Box padding={8}>
    <Flex
      direction="column"
      alignItems="center"
      gap={4}
    >
      <Box
        background="neutral100"
        padding={4}
        borderRadius="50%"
      >
        <Search width="32px" height="32px" />
      </Box>
      <Typography variant="delta" textAlign="center">
        No results found
      </Typography>
      <Typography textColor="neutral600" textAlign="center">
        No items match "{query}". Try adjusting your search.
      </Typography>
    </Flex>
  </Box>
);

export default NoSearchResults;
```

---

## Key Patterns Summary

| Pattern | Use Case | Key Components |
|---------|----------|----------------|
| Data Table | Displaying lists of items | Table, Thead, Tbody, Tr, Td, Th |
| Form with Validation | User input with errors | Field, TextInput, Select, Toggle |
| Confirmation Dialog | Destructive actions | Dialog, Button (variant="danger") |
| Form Modal | Create/Edit in overlay | Modal, Field, TextInput |
| Settings Page | Plugin configuration | Main, Card, Grid, Toggle |
| Dashboard | Statistics overview | Card, Grid, Typography |
| Content Manager Panel | Edit view integration | Box, Card, unstable_useContentManagerContext |
| CRUD Hook | Data operations | useQuery, useMutation, useFetchClient |
| Error Handling | API failures | Alert, ErrorBoundary |
| Loading States | Async operations | Loader, Skeleton |
| Empty States | No data scenarios | EmptyStateLayout |
