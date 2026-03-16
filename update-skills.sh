#!/bin/bash
# Update all skill submodules to their latest upstream versions
set -e

cd "$(dirname "$0")"

echo "Updating all skill submodules..."
git submodule update --remote --merge

echo ""
echo "Current submodule status:"
git submodule status

# Check if anything changed
if git diff --quiet && git diff --cached --quiet; then
  echo ""
  echo "All skills already up to date."
else
  echo ""
  echo "Skills updated. Review changes with: git diff"
  echo "Commit with: git add -A && git commit -m 'Update skill submodules'"
fi
