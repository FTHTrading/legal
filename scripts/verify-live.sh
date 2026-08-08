#!/usr/bin/env bash
# ==========================================================================
# verify-live.sh  [base-url]
#
# The forcing function that closes the deploy-vs-visible gap.
#
# For every entry in scripts/live-assertions.json:
#   - fetches BASE + path (bare URL, no cache-buster query string)
#   - asserts every `present.token` appears in the body
#   - asserts every `absent.token`  does NOT appear
#
# Rule from 2026-08-07: verify against the served response, not the repo.
# Cache-buster URLs verify origin, not what a reader sees. This script hits
# the bare canonical URL — the same one a browser gets. If the bare URL
# still serves a pre-fix copy, the script fails, and the deploy is not
# considered "done".
#
# Exits non-zero on any failure. Suitable for CI post-deploy step or a
# manual gate before saying "shipped".
#
# Requires: bash, curl, node (for JSON parsing).
# ==========================================================================
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ASSERT="${HERE}/live-assertions.json"

BASE="${1:-}"
if [ -z "$BASE" ]; then
  BASE=$(node -e '
    const j = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
    process.stdout.write(j.base_default || "");
  ' "$ASSERT")
fi

if [ -z "$BASE" ]; then
  echo "usage: verify-live.sh <base-url>  (or set base_default in live-assertions.json)"
  exit 2
fi

green() { printf "\033[32m%s\033[0m\n" "$*"; }
red()   { printf "\033[31m%s\033[0m\n" "$*"; }
yellow(){ printf "\033[33m%s\033[0m\n" "$*"; }

green "Verifying against $BASE  ($(date -u '+%Y-%m-%d %H:%M:%SZ'))"
green "Assertion source: $ASSERT"
echo

FAIL_COUNT=0

# Iterate checks with node emitting a null-delimited stream of records so
# we don't have to shell-escape the tokens (many contain quotes, slashes,
# angle brackets, dashes).
node -e '
  const j = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
  for (const c of j.checks) {
    for (const p of (c.present || [])) process.stdout.write("P\0" + c.path + "\0" + p.token + "\0" + (p.why||"") + "\0");
    for (const a of (c.absent  || [])) process.stdout.write("A\0" + c.path + "\0" + a.token + "\0" + (a.why||"") + "\0");
  }
' "$ASSERT" | (
  # Simple state machine reading 4 null-terminated fields at a time.
  # We buffer a whole record then process.
  IFS= read -r -d '' KIND || exit 0
  while true; do
    IFS= read -r -d '' PATH_ || break
    IFS= read -r -d '' TOKEN || break
    IFS= read -r -d '' WHY   || break

    URL="${BASE}${PATH_}"
    BODY=$(curl -sSL --max-time 15 -H 'Cache-Control: no-cache' -H 'Pragma: no-cache' "$URL" 2>/dev/null || true)

    if [ -z "$BODY" ]; then
      red "  FAIL  $PATH_  (empty body — request failed)"
      FAIL_COUNT=$((FAIL_COUNT + 1))
      IFS= read -r -d '' KIND || exit 0
      continue
    fi

    case "$KIND" in
      P)
        if grep -qF -- "$TOKEN" <<<"$BODY"; then
          green "  OK    $PATH_  (present: ${TOKEN:0:60})"
        else
          red   "  FAIL  $PATH_  (missing: ${TOKEN:0:100})"
          yellow "        why: $WHY"
          FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
        ;;
      A)
        if grep -qF -- "$TOKEN" <<<"$BODY"; then
          red   "  FAIL  $PATH_  (forbidden PRESENT: ${TOKEN:0:100})"
          yellow "        why: $WHY"
          FAIL_COUNT=$((FAIL_COUNT + 1))
        else
          green "  OK    $PATH_  (absent: ${TOKEN:0:60})"
        fi
        ;;
    esac

    IFS= read -r -d '' KIND || break
  done

  echo
  if [ "$FAIL_COUNT" -eq 0 ]; then
    green "All assertions passed."
    exit 0
  else
    red "FAILED: $FAIL_COUNT assertion(s)."
    red "The bare URL is serving content that does not match the repo."
    red "  1. Confirm the fix is in HEAD:      git log --oneline -1 <path>"
    red "  2. If yes, this is a cache miss:    bash <path-to>/cf-purge.sh <zone>"
    red "  3. Re-run verify-live.sh"
    exit 1
  fi
)
