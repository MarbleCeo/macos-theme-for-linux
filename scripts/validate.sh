#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Simple local validation script

echo "🔎 Running local validations..."

# Shellcheck
if command -v shellcheck &> /dev/null; then
  echo "🛠️ Running shellcheck on scripts..."
  shellcheck -x install.sh scripts/*.sh || true
else
  echo "⚠️ shellcheck not found; skipping shellcheck. Install with: sudo apt install -y shellcheck"
fi

# Bash syntax check
echo "🧪 Checking bash syntax..."
bash -n install.sh || true
for f in scripts/*.sh; do
  bash -n "$f" || true
done

# Markdown link check
if command -v markdown-link-check &> /dev/null; then
  echo "🔗 Running markdown-link-check on README.md"
  markdown-link-check README.md --config .markdown-link-check.json || true
else
  echo "⚠️ markdown-link-check not installed; you can run: npm install -g markdown-link-check"
fi

echo "✅ Local validations completed (some checks may be skipped if tools are missing)."