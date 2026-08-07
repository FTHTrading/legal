# FTHTrading / legal

**Open-source legal operations stack for private-capital operators.**
Document assembly, corpus retrieval, and diligence — with attorney sign-off built in.

## What this is

A production-grade in-house legal-ops engine that:

- **Assembles documents** from pre-audited templates by substituting facts
  (WY LLC formation, Reg D 506(c) subscription, 12-section PPM)
- **Retrieves regulatory text** on demand via free federal APIs (eCFR, SEC EDGAR)
- **Runs parallel diligence** against 7 public providers (OFAC, GLEIF, SAM, CourtListener, FINRA, IAPD, EDGAR)
- **Generates Blue Sky notice-filing plans** for 9 states
- **Tracks ongoing compliance** — Form D amendments, franchise tax, BOI, K-1, FBAR, OFAC re-screens
- **Ships every artifact with a Review Manifest** for attorney sign-off

Estimated attorney bill reduction per SPV formation + Reg D 506(c) raise: **$13K–$26K** at $650/hour.

## Live site

**https://fthtrading.github.io/legal/** — full documentation with table of contents.

## What this is NOT

A lawyer replacement. Every artifact ships with a required attorney-review manifest.
The attorney signing the manifest is the person of record for the legal opinion — not the system.

## Repo contents

| Path | Purpose |
|------|---------|
| `index.html` | Full public documentation — one-page site with sidebar TOC |
| `_ds/` | Design system CSS: tokens, layout, components, print |
| `_assets/` | Images and icons |
| `.nojekyll` | Serves `_ds/` correctly through GitHub Pages |

## Source code

The engine itself lives in the `fth-mcp-hub` repository under
`src/servers/legal-ops/` and `templates/legal/`. This repo publishes the
operator-facing documentation only.

## Tool inventory

**25 MCP tools** across 5 categories:

- **Corpus retrieval (6):** `legal_edgar_*`, `legal_cfr_*`
- **Diligence (4):** `legal_dd_*`
- **Templates & assembly (6):** `legal_template_*`, `legal_document_*`
- **Filings & compliance (6):** `legal_blue_sky_*`, `legal_entity_*`, `legal_compliance_calendar`
- **Review & workflow (3):** `legal_manifest_*`, `legal_spv_in_a_box`

## Template inventory

**17 templates** with open-license provenance:

- **WY LLC packet (3):** Articles of Organization, Manager-Managed Operating Agreement, Initial Written Consent
- **Reg D 506(c) (2):** Subscription Agreement, Accredited Investor Questionnaire (all Rule 501(a) categories)
- **PPM (12):** Cover, Summary, Risk Factors, Use of Proceeds, Business, Management, Conflicts, Securities & Plan, Bad Actor, Tax, ERISA, Additional Info

## Data sources

Every regulatory and diligence data source is a public federal API:

| API | Auth | Free |
|-----|------|------|
| SEC EDGAR | User-Agent | Yes |
| Cornell LII (eCFR) | None | Yes |
| Consolidated Screening List | None | Yes |
| GLEIF | None | Yes |
| CourtListener | Optional token | Yes |
| SAM.gov | Free API key | Yes |
| FINRA BrokerCheck | None | Yes |
| SEC IAPD | None | Yes |

No vendor lock-in. No black-box aggregators. No scrapers.

## Quick start

```bash
# 1. Get the source (separate repo)
git clone https://github.com/FTHTrading/fth-mcp-hub

# 2. Install
cd fth-mcp-hub && pnpm install

# 3. Start the hub
pnpm dev
# Hub listens on http://localhost:9077

# 4. Try a tool
curl -X POST http://localhost:9077/mcp/invoke \
  -H 'Content-Type: application/json' \
  -d '{"tool":"legal_cfr_pinpoint","arguments":{"citation":"17 CFR § 230.506(c)"}}'
```

## License

Documentation in this repo: MIT.
See individual template front matter for template-specific license provenance:
`public-domain`, `sec-filing-public`, `free-industry-standard`, `internal`.

## Not legal advice

Nothing in this repository constitutes legal advice, tax advice, ERISA advice,
or investment advice. This is a document-assembly and diligence system. Every
artifact requires review and sign-off by a licensed attorney qualified in the
relevant jurisdiction. The attorney signing the Review Manifest is the person
rendering the legal opinion.
