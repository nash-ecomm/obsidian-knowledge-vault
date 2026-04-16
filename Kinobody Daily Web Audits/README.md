# Kinobody Daily Web Audits

Daily DTC e-commerce audit of [kinobody.com](https://kinobody.com) — run by a scheduled remote Claude agent. Output flows into the Obsidian vault at `Obsidian Knowledge Vault/Kinobody Daily Web Audits/`.

## What the agent audits (daily, full-site)

1. **Crawl** — fetch every URL in `crawl-targets.md`, record status codes, redirects, titles, meta descriptions.
2. **Performance** — pull Core Web Vitals (LCP, CLS, INP, TBT), page weight, and render-blocking resources via PageSpeed Insights API for priority pages.
3. **SEO & structured data** — validate JSON-LD (Product, Offer, Organization, Review, FAQ), check canonicals, H1 count, meta length, OG/Twitter tags, hreflang.
4. **Accessibility** — axe-style heuristics: alt text coverage, heading order, color contrast risks, form label coverage, tap target size.
5. **Merchandising & conversion** — price visibility, stock status, add-to-cart presence, review widget presence, cross-sell / upsell blocks, social proof freshness.
6. **Checkout funnel** — cart page, cart drawer, checkout surface (public-facing elements only), friction indicators.
7. **Mobile** — responsive layout issues, viewport meta, touch target coverage.
8. **Regressions** — diff against prior day: new 404s, title/meta drift, removed products, price changes, broken images.

## Output

- `YYYY-MM-DD.md` — daily audit with **P0 (ship-blocker)**, **P1 (high impact)**, **P2 (opportunity)**, **P3 (nit)** findings, plus metrics snapshot and quick-win list.
- `.source-log.md` — dedup log; findings already reported are not re-reported unless severity escalates or status changes.
- `crawl-targets.md` — source of truth for URLs to crawl (edit here to add/remove).
- `_templates/audit.md` — report template the agent fills in.
- `AGENT-INSTRUCTIONS.md` — the agent's brief.

## Schedule

Daily at 8:00 AM EST via a Claude Code remote trigger (see `AGENT-INSTRUCTIONS.md`).

## Workflow

1. Agent runs → writes `YYYY-MM-DD.md` + updates `.source-log.md` → commits + pushes to this repo.
2. You pull the repo locally (already cloned into the Obsidian vault) — Obsidian picks up the new file automatically.
3. Triage findings; anything that becomes dev work flows into the Kinobody Lander Pipeline or a standalone task.
