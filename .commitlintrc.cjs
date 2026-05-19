// commitlint config — mirrors the local .githooks/commit-msg rules.
// Run locally:  npx commitlint --from=HEAD~10
// Runs in CI:   .github/workflows/commitlint.yml

const fs = require('node:fs');
const path = require('node:path');

// Discover plugin names from the plugins/ directory.
const pluginsDir = path.join(__dirname, 'plugins');
const pluginScopes = fs.existsSync(pluginsDir)
  ? fs
      .readdirSync(pluginsDir, { withFileTypes: true })
      .filter((d) => d.isDirectory())
      .filter((d) => fs.existsSync(path.join(pluginsDir, d.name, 'plugin.json')))
      .map((d) => d.name)
  : [];

// Non-plugin scopes that are also allowed (extend as the repo grows).
const otherScopes = ['deps', 'release', 'marketplace', 'hooks', 'workflows', 'readme'];

const allowedScopes = [...pluginScopes, ...otherScopes];

module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Header
    'header-max-length': [2, 'always', 100],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'subject-case': [
      2,
      'never',
      ['sentence-case', 'start-case', 'pascal-case', 'upper-case'],
    ],

    // Type
    'type-empty': [2, 'never'],
    'type-case': [2, 'always', 'lower-case'],
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'perf', 'refactor', 'docs', 'chore', 'test', 'ci', 'build', 'style', 'revert'],
    ],

    // Scope: must be from the allowlist (or absent for non-release types).
    'scope-case': [2, 'always', 'kebab-case'],
    'scope-enum': [2, 'always', allowedScopes],

    // Body / footer
    'body-leading-blank': [1, 'always'],
    'footer-leading-blank': [1, 'always'],
  },
  // Skip merge/revert/release commits.
  ignores: [
    (commit) => /^(Merge|Revert|Reapply) /.test(commit),
    (commit) => commit.includes('[skip ci]'),
    (commit) => /^(fixup|squash|amend)! /.test(commit),
  ],
};
