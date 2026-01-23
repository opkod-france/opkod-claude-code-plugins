# OPKOD Claude Plugins Marketplace

A self-hosted marketplace for Claude Code plugins by OPKOD France.

## Installation

Install plugins directly from this marketplace using the Claude Code CLI:

```bash
# Install a specific plugin
claude plugins add https://opkod-france.github.io/claude-plugins-marketplace/plugins/ui-polish
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

## Contributing a Plugin

1. Fork this repository
2. Create a new folder under `plugins/your-plugin-name/`
3. Add your `plugin.json` manifest and plugin content (skills/, commands/, agents/, hooks/)
4. Add your plugin entry to `marketplace.json`
5. Update `index.html` with your plugin card
6. Submit a pull request

### Plugin Structure

```
plugins/your-plugin-name/
├── plugin.json          # Required: Plugin manifest
├── skills/              # Optional: Skill definitions
│   └── skill-name/
│       └── SKILL.md
├── commands/            # Optional: Slash commands
│   └── command.md
├── agents/              # Optional: Custom agents
│   └── agent.md
└── hooks/               # Optional: Event hooks
    └── hook.md
```

### plugin.json Example

```json
{
  "name": "your-plugin-name",
  "version": "1.0.0",
  "description": "What your plugin does",
  "author": {
    "name": "Your Name"
  },
  "repository": "https://github.com/you/your-repo",
  "license": "MIT",
  "skills": { "auto_discover": true },
  "commands": { "auto_discover": true }
}
```

## Hosting Your Own Marketplace

This repository demonstrates how to host a Claude Code plugin marketplace on GitHub Pages:

1. **Create a repository** with this structure
2. **Enable GitHub Pages** (Settings > Pages > Deploy from branch: `main`, folder: `/ (root)`)
3. **Add your plugins** to the `plugins/` directory
4. **Update `marketplace.json`** to list all available plugins

Users can then install plugins with:
```bash
claude plugins add https://your-username.github.io/your-marketplace/plugins/plugin-name
```

## License

MIT - See individual plugins for their respective licenses.
