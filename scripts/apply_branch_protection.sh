#!/usr/bin/env bash
set -euo pipefail

# Repository name can be set via environment variable REPO or as the first script argument.
REPO="${REPO:-${1:-}}"
BRANCH="prod"

if [[ -z "$REPO" ]]; then
  echo "[ERROR] Repository name not set. Set REPO env var or pass as first argument (e.g. REPO=owner/repo ./scripts/apply_branch_protection.sh or ./scripts/apply_branch_protection.sh owner/repo)"
  exit 1
fi
REVIEW_COUNT="${REVIEW_COUNT:-0}"   # Set to 1 externally if you want to force a self-review PR workflow.

echo "[INFO] Applying branch protection to $REPO:$BRANCH"
command -v gh >/dev/null 2>&1 || { echo "[ERROR] gh (GitHub CLI) not found in PATH"; exit 1; }

if ! gh auth status >/dev/null 2>&1; then
  echo "[ERROR] gh CLI not authenticated. Run: gh auth login"
  exit 1
fi

echo "[INFO] Using required_approving_review_count=$REVIEW_COUNT"
STATUS_CONTEXT="${STATUS_CONTEXT:-ci / ci}"
STATUS_CONTEXT="$STATUS_CONTEXT"
echo "[INFO] Requiring status check context: $STATUS_CONTEXT"

set -x
gh api \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  "repos/$REPO/branches/$BRANCH/protection" \
  -F required_status_checks.strict=true \
  -F required_status_checks.contexts[]="$STATUS_CONTEXT" \
  -F enforce_admins=true \
  -F required_pull_request_reviews.dismiss_stale_reviews=true \
  -F required_pull_request_reviews.required_approving_review_count="$REVIEW_COUNT" \
  -F required_conversation_resolution=true \
  -F allow_force_pushes=false \
  -F allow_deletions=false \
  -F required_linear_history=true
set +x

echo "[INFO] Fetching applied settings..."
API_OUTPUT="$(gh api -H "Accept: application/vnd.github+json" "repos/$REPO/branches/$BRANCH/protection" 2>&1)"
API_STATUS=$?
if [ $API_STATUS -ne 0 ]; then
  echo "[ERROR] Failed to fetch branch protection settings:"
  echo "$API_OUTPUT"
else
  if command -v jq >/dev/null 2>&1; then
    echo "$API_OUTPUT" | jq .
  else
    echo "[WARN] jq not installed; raw output below:"
    echo "$API_OUTPUT"
  fi
fi
echo "[SUCCESS] Branch protection applied."
echo "To require a self-review next time run: REVIEW_COUNT=1 ./scripts/apply_branch_protection.sh"
