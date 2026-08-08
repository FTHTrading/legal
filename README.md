# Unykorn Legal

**Global legal infrastructure for tokenized securities and real-world assets.**

Six connected sections: an education library, a working lexicon, a
jurisdictional regulatory map, an open smart-contract template registry,
a live registry of active RWA protocols and deals, and the open-source
Unykorn Legal Ops System that powers all of it.

## Live site

**https://legal.unykorn.ai** — full public reference.

## Sections

| Section | Path | What's inside |
|---------|------|--------------|
| **01 · Library** | [`/library/`](https://legal.unykorn.ai/library/) | RWA fundamentals, GENIUS Act, real-estate securities, contract law primer, every operating discipline |
| **02 · Lexicon** | [`/lexicon/`](https://legal.unykorn.ai/lexicon/) | Working dictionary of securities, tokenization, custody, structuring, and compliance terminology |
| **03 · Jurisdictions** | [`/jurisdictions/`](https://legal.unykorn.ai/jurisdictions/) | US federal + state layer plus UK FCA, EU MiCA, Singapore MAS, DIFC, ADGM, HK SFC, Swiss FINMA |
| **04 · Smart Contracts** | [`/smart-contracts/`](https://legal.unykorn.ai/smart-contracts/) | ERC-3643, ERC-1400, SAFTs, token warrants, vaults, escrow, waterfalls, staking |
| **05 · Active Deals** | [`/deals/`](https://legal.unykorn.ai/deals/) | Live RWA protocols: Ondo, Goldfinch, Centrifuge, Maple, Aave Horizon, Superstate, Franklin BENJI, more |
| **06 · System** | [`/system/`](https://legal.unykorn.ai/system/) | Unykorn Legal Ops MCP server: 25 tools, 17 templates, 9 DD providers, SPV-in-a-Box workflow |

## Repo contents

| Path | Purpose |
|------|---------|
| `index.html` | Home / hub |
| `system/` | Legal Ops MCP System reference (was original index) |
| `library/` `lexicon/` `jurisdictions/` `smart-contracts/` `deals/` | Content sections |
| `_ds/` | Design system CSS (tokens, layout, components, shell, print) |
| `_assets/` | Sample inputs, images, downloads |
| `CNAME` | `legal.unykorn.ai` (GitHub Pages custom domain) |
| `.nojekyll` | Serves `_ds/` correctly through GitHub Pages |

## About Unykorn LLC

**Unykorn LLC** &mdash; Wyoming LLC, EIN 42-3536633, D-U-N-S 145059107,
GLEIF LEI 2549008J7LUHSQ73SI26, ISO MIC UBEC, WY Filing ID 2026-002019968.

Sole active operating entity; historical UNYKORN 7777 INC. deprecated 2026-08-07.

## Source code

The engine that powers the System section lives in the `fth-mcp-hub` repository
under `src/servers/legal-ops/` and `templates/legal/`. This repo publishes the
operator-facing documentation only.

## License

Documentation in this repo: MIT (see `LICENSE`).
Individual smart-contract templates and legal doc templates carry per-file
license provenance: `public-domain`, `sec-filing-public`, `free-industry-standard`,
`apache-2.0`, `cc0`, `cc-by`, or `internal`.

## Not legal advice

Nothing in this repository constitutes legal advice, tax advice, ERISA advice,
or investment advice. Every generated artifact requires review and sign-off by
a licensed attorney qualified in the relevant jurisdiction. The attorney
signing the Review Manifest is the person rendering the legal opinion.

See [NOTICE-NOT-LEGAL-ADVICE.md](./NOTICE-NOT-LEGAL-ADVICE.md).
