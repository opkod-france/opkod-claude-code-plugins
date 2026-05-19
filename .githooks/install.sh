#!/usr/bin/env bash
# Activate the repo-managed git hooks for this clone.
# Run once after cloning:  ./.githooks/install.sh
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

git config core.hooksPath .githooks
chmod +x .githooks/commit-msg .githooks/pre-commit

echo "✓ core.hooksPath set to .githooks"
echo "✓ commit-msg and pre-commit hooks are active"
echo
echo "Hooks installed:"
echo "  • commit-msg — enforces conventional commits with plugin scope"
echo "  • pre-commit — runs plugin lint scripts on staged files"
echo
echo "To bypass once (NOT recommended):  git commit --no-verify"
