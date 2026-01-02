#!/usr/bin/env bash
# Generic commit and push helper for GitHub Actions
# Expects these environment variables (workflow should set them):
# FILES - space-separated list of files to `git add`
# COMMIT_MSG_TEMPLATE - commit message, may contain {COUNT} placeholder
# COUNT_CMD - optional shell command to compute count (stdout used)
# BRANCH - optional; defaults to current branch derived from GITHUB_REF

set -euo pipefail

: "${FILES:?FILES must be set (space-separated)}"
COMMIT_MSG_TEMPLATE="${COMMIT_MSG_TEMPLATE:-chore: update files [skip ci]}"
COUNT_CMD="${COUNT_CMD:-}"
BRANCH="${BRANCH:-}"

# Configure git user for this commit
git config --local user.name "github-actions[bot]"
git config --local user.email "github-actions[bot]@users.noreply.github.com"

# Stage files
# shellcheck disable=SC2086
git add ${FILES}

# Only proceed if there are staged changes
if ! git diff --staged --quiet; then
  # Compute count if requested
  COUNT=""
  if [ -n "${COUNT_CMD}" ]; then
    # Use eval to support pipelines and quoting from YAML
    COUNT=$(eval "${COUNT_CMD}" 2>/dev/null || echo "0")
  fi

  # Replace placeholder
  COMMIT_MSG=${COMMIT_MSG_TEMPLATE//"{COUNT}"/$COUNT}
  COMMIT_MSG=${COMMIT_MSG//\{COUNT\}/$COUNT}

  # Commit
  git commit -m "$COMMIT_MSG"

  # Determine branch if not provided
  if [ -z "$BRANCH" ] && [ -n "${GITHUB_REF:-}" ]; then
    BRANCH=${GITHUB_REF#refs/heads/}
  fi
  BRANCH=${BRANCH:-master}

  # Pull with rebase to integrate remote changes then push
  if ! git pull --rebase origin "$BRANCH"; then
    echo "Remote changed, aborting push"
    git rebase --abort || true
    exit 0
  fi
  git push
  echo "✅ Changes committed and pushed"
else
  echo "ℹ️ No changes to commit"
fi

