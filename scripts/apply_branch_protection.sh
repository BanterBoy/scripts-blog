#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-${1:-BanterBoy/scripts-blog}}"
BRANCH="${BRANCH:-prod}"

if [[ -z "$REPO" ]]; then
  echo "[ERROR] Repository name not set. Set REPO env var or pass as first argument (e.g. REPO=owner/repo ./scripts/apply_branch_protection.sh or ./scripts/apply_branch_protection.sh owner/repo)"
  exit 1
fi

REVIEW_COUNT="${REVIEW_COUNT:-0}"   # Set to 1 externally if you want to force a self-review PR workflow.
STATUS_CONTEXT="${STATUS_CONTEXT:-ci / ci}"

if ! [[ "$REVIEW_COUNT" =~ ^[0-9]+$ ]]; then
  echo "[ERROR] REVIEW_COUNT must be a non-negative integer (got '$REVIEW_COUNT')"
  exit 1
fi

PAYLOAD=$(cat <<EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["$STATUS_CONTEXT"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "required_approving_review_count": $REVIEW_COUNT
  },
  "restrictions": null,
  "required_conversation_resolution": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_linear_history": true
}
EOF
)

echo "[INFO] Applying branch protection to $REPO:$BRANCH"
GH_BIN="$(command -v gh 2>/dev/null || command -v gh.exe 2>/dev/null || true)"

if [[ -z "${GH_BIN}" ]]; then
  for candidate in "/mnt/c/Program Files/GitHub CLI/gh.exe" "/mnt/c/Program Files (x86)/GitHub CLI/gh.exe" "/c/Program Files/GitHub CLI/gh.exe" "/c/Program Files (x86)/GitHub CLI/gh.exe"; do
    if [[ -x "$candidate" ]]; then
      GH_BIN="$candidate"
      break
    fi
  done
fi

if [[ -z "${GH_BIN}" ]]; then
  echo "[ERROR] gh (GitHub CLI) not found in PATH"
  exit 1
fi

if ! "${GH_BIN}" auth status >/dev/null 2>&1; then
  echo "[ERROR] gh CLI not authenticated. Run: gh auth login"
  exit 1
fi

echo "[INFO] Using required_approving_review_count=$REVIEW_COUNT"
echo "[INFO] Requiring status check context: $STATUS_CONTEXT"

set -x
echo "$PAYLOAD" | "${GH_BIN}" api   -X PUT   -H "Accept: application/vnd.github+json"   "repos/$REPO/branches/$BRANCH/protection"   --input -
set +x

echo "[INFO] Fetching applied settings..."
API_OUTPUT="$("${GH_BIN}" api -H "Accept: application/vnd.github+json" "repos/$REPO/branches/$BRANCH/protection" 2>&1)"
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
