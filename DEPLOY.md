# Deploy discipline for legal.unykorn.ai

This site is served from `main` via GitHub Pages, fronted by Cloudflare
(grey-cloud CNAME to `fthtrading.github.io`). Two forcing functions are in
place; a third is manual pending a Cloudflare token.

## The three gates

### 1. Pre-merge: internal-marker check (automatic, blocking)

`.github/workflows/internal-marker-check.yml` scans every file in the Pages
publish root for a specific classification marker (see that workflow file
for the exact byte sequence). Any hit fails the build.

**Background:** on 2026-08-07 two documents carrying this marker were
published to the site, exposing pricing negotiation reasoning and named
counterparty status. The marker is a hard-coded discipline; do not weaken.

### 2. Post-deploy: verify-live (automatic, blocking)

`.github/workflows/verify-live.yml` runs `scripts/verify-live.sh` against
the live domain 60 seconds after every `pages-build-deployment` completes.
The script asserts every entry in `scripts/live-assertions.json` matches
the response from the **bare canonical URL** — no cache-buster query
strings.

**Background:** on 2026-08-08 the `/smart-contracts/` page was reported
serving pre-fix content at the canonical URL. Distinguishing test (bare vs
`?v=99`) showed no cache-key stratification, so cache-buster verification
would have "passed" while the reader saw stale content. This script hits
what the reader actually gets.

**Adding an assertion:** open `scripts/live-assertions.json`, add an entry
under `checks` with the URL path and one or more `present` tokens (with a
`why` explaining what the assertion protects). For forbidden strings (e.g.
a deprecated entity name), add to `absent` on the same URL entry.

Run locally before pushing:

```bash
bash scripts/verify-live.sh                    # uses base_default
bash scripts/verify-live.sh https://staging.example.com   # override base
```

### 3. Cache purge (manual until CF token minted)

**Missing forcing function.** The CF cache-purge step is not yet wired
because it requires a Cloudflare API token minted with `Zone > Cache Purge
> unykorn.ai` scope. Kevan-only step:

1. Cloudflare Dashboard → My Profile → API Tokens → Create Token
2. Template: **Zone** → **Cache Purge** → Zone: **unykorn.ai**
3. Save token, export as `CLOUDFLARE_API_TOKEN` in shell env
4. `bash ~/dev/platforms/uny-corpus/scripts/cf-purge.sh unykorn.ai`
   (script lives in the corpus repo but works on any unykorn.ai zone)

Once the token exists as a **repository secret** in this repo, revise
`.github/workflows/verify-live.yml` to purge before verify runs, so a
post-deploy `verify-live` failure automatically retries after a purge.

## Deploy sequence

```
push to main
  |
  v
GitHub Pages build + deploy
  |
  v
verify-live workflow waits 60s, then hits bare canonical URLs
  |
  +-- pass -> stamp "shipped" in commit status
  |
  +-- fail -> job red, log includes the diff and the purge command
```

## Recovering from a failed verify-live

1. **Confirm the fix is in HEAD** for the path that failed:
   ```
   git log --oneline -1 <path/to/file>
   ```
2. If yes → the origin is fresh, the edge is stale → **manual cache purge**
   (step 3 above), then re-run the workflow.
3. If no → the fix wasn't actually committed → land it, push, verify-live
   re-runs on the next Pages deploy.

## What NOT to do

- **Never** verify with a cache-buster query string (`?v=99`). It verifies
  the origin, not what the reader gets.
- **Never** commit a document carrying the internal-classification marker
  (see `internal-marker-check.yml` for the exact byte sequence) to any branch
  that ships. The marker-check will block; if it somehow doesn't (path in
  ignore-regex), assume the check is silently broken and file an issue.
- **Never** delete an assertion from `live-assertions.json` because it's
  failing. The assertion protects a fact the site is claiming; if the
  fact changes, update the assertion with the new expected value AND the
  reason (`why` field).
