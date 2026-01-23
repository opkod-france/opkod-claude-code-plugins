# OPKOD Claude Plugins Marketplace

A self-hosted marketplace for Claude Code plugins by OPKOD France.

## Installation

Install plugins from this marketplace using the Claude Code CLI:

```bash
claude plugins add https://opkod-france.github.io/claude-plugins-marketplace/plugins/<plugin-name>
```

### Managing Plugins

```bash
# List installed plugins
claude plugins list

# Remove a plugin
claude plugins remove <plugin-name>

# Update a plugin (remove and re-add)
claude plugins remove <plugin-name>
claude plugins add https://opkod-france.github.io/claude-plugins-marketplace/plugins/<plugin-name>
```

## Available Plugins

### ui-polish

Professional UI design principles using Tailwind CSS and shadcn/ui. Applies Refactoring UI methodology to create polished, professional interfaces.

**Features:**
- `/refactor [file]` - Refactor a UI component applying design principles
- `/review [file]` - Analyze a component for design improvements
- Automatic skill activation when building UI components

```bash
claude plugins add https://opkod-france.github.io/claude-plugins-marketplace/plugins/ui-polish
```

## License

MIT
