#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-${1:-BanterBoy/scripts-blog}}"
BRANCH="${BRANCH:-prod}"

if [[ -z "$REPO" ]]; then
  echo "[ERROR] Repository name not set. Set REPO env var or pass as first argument (e.g. REPO=owner/repo ./scripts/apply_branch_protection.sh or ./scripts/apply_branch_protection.sh owner/repo)"
  exit 1
fi

REVIEW_COUNT="${REVIEW_COUNT:-0}"
STATUS_CONTEXT="${STATUS_CONTEXT:-}"
STRICT_STATUS="${STRICT_STATUS:-false}"
REQUIRE_CONVERSATION="${REQUIRE_CONVERSATION:-false}"
REQUIRE_LINEAR_HISTORY="${REQUIRE_LINEAR_HISTORY:-false}"
ALLOW_FORCE_PUSHES="${ALLOW_FORCE_PUSHES:-false}"
ALLOW_DELETIONS="${ALLOW_DELETIONS:-false}"

to_bool() {
  case "${1:-false}" in
    1|true|TRUE|yes|on) echo true ;;
    *) echo false ;;
  esac
}

if ! [[ "$REVIEW_COUNT" =~ ^[0-9]+$ ]]; then
  echo "[ERROR] REVIEW_COUNT must be a non-negative integer (got '$REVIEW_COUNT')"
  exit 1
fi

STRICT_BOOL=$(to_bool "$STRICT_STATUS")
CONVERSATION_BOOL=$(to_bool "$REQUIRE_CONVERSATION")
LINEAR_BOOL=$(to_bool "$REQUIRE_LINEAR_HISTORY")
FORCE_BOOL=$(to_bool "$ALLOW_FORCE_PUSHES")
DELETE_BOOL=$(to_bool "$ALLOW_DELETIONS")

if [[ -n "$STATUS_CONTEXT" ]]; then
  IFS=' ' read -r -a CONTEXT_LIST <<< "$STATUS_CONTEXT"
  if [[ ${#CONTEXT_LIST[@]} -gt 0 ]]; then
    CONTEXTS_JOINED=$(printf '"%s", ' "${CONTEXT_LIST[@]}")
    CONTEXTS_JOINED="[${CONTEXTS_JOINED%, }]"
    STATUS_JSON=$(cat <<EOF
  "required_status_checks": {
    "strict": ${STRICT_BOOL},
    "contexts": ${CONTEXTS_JOINED}
  },
EOF
)
  else
    STATUS_JSON='  "required_status_checks": null,'
  fi
else
  STATUS_JSON='  "required_status_checks": null,'
fi

PAYLOAD=$(cat <<EOF
{
${STATUS_JSON}
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": true,
    "required_approving_review_count": ${REVIEW_COUNT}
  },
  "restrictions": null,
  "required_conversation_resolution": ${CONVERSATION_BOOL},
  "allow_force_pushes": ${FORCE_BOOL},
  "allow_deletions": ${DELETE_BOOL},
  "required_linear_history": ${LINEAR_BOOL}
}
EOF
)

GH_BIN="$(command -v gh 2>/dev/null || command -v gh.exe 2>/dev/null || true)"
if [[ -z "${GH_BIN}" ]]; then
  for candidate in "/mnt/c/Program Files/GitHub CLI/gh.exe" "/mnt/c/Program Files (x86)/GitHub CLI/gh.exe"                    "/c/Program Files/GitHub CLI/gh.exe" "/c/Program Files (x86)/GitHub CLI/gh.exe"; do
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

echo "[INFO] Applying branch protection to $REPO:$BRANCH"
echo "[INFO] required_approving_review_count=$REVIEW_COUNT"
if [[ -n "$STATUS_CONTEXT" ]]; then
  echo "[INFO] Requiring status check context(s): $STATUS_CONTEXT"
else
  echo "[INFO] No required status checks configured"
fi

echo "[DEBUG] Request payload:" >&2
echo "$PAYLOAD" >&2

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
