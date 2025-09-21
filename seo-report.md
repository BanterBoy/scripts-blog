# Technical SEO Improvements for scripts.lukeleigh.com

## Checklist Summary
| Item | Before | After | Notes |
| --- | --- | --- | --- |
| Robots.txt | Allowed all crawling without sitemap guarantee | Explicitly allows crawling, references sitemap | Updated `robots.txt` to match Google guidance. |
| Sitemap | Plugin enabled but unchecked | `jekyll-sitemap` confirmed and validated in CI | `seo-checks.rb` fails build if sitemap missing. |
| Titles & Descriptions | Several navigation pages used lowercase titles shared with H1 | Descriptive titles with separate navigation labels and headings | Added `nav_title`/`heading` to avoid nav regressions while improving SEO titles. |
| Canonical Tags | Managed by `jekyll-seo-tag` without verification | Local HTTP validation for every canonical URL | `build/seo-checks.rb` serves `_site` locally and checks for HTTP 200. |
| Status Codes | Manual spot checks only | Automated crawl of built site | CI runs Lychee plus canonical validation and records results in `seo-checks.json`. |
| Structured Data | WebSite markup emitted but missing organization context | WebSite + Organization + BlogPosting JSON-LD with accurate profile data | Added organization metadata and live search target URL. |
| Performance Hints | No resource preloads or asset sizing | Preload hero CSS/image, logo sized, lazy loading applied | Reduces layout shift and speeds first render. |

## Discovery & Crawlability
- `robots.txt` now follows Google’s recommended syntax and advertises `https://scripts.lukeleigh.com/sitemap.xml`.
- `jekyll-sitemap` remains enabled; CI verifies `_site/sitemap.xml` is generated and extracts 834 canonical URLs.
- Added a reusable `build/seo-checks.rb` script that spins up a local WEBrick server to confirm all canonical URLs resolve with HTTP 200 and that no meta refresh directives ship.

## Indexability & Rendering
- Navigation and landing pages received descriptive titles (`PowerShell Scripts | Maintenance Scripts`, etc.) plus dedicated `heading`/`nav_title` front matter so templates keep short labels.
- 404 page and private HTML embeds (`assets/*Home.html`) set `robots: noindex` to prevent soft-404s in search results.
- Template page `_pages/content/New-Topic.md` is unpublished and excluded from the sitemap.
- Updated `_includes/head.html` to preload the primary stylesheet and hero teasers when available.

## Structured Data Coverage
- `_includes/structured-data.html` now receives `organization` details from `_config.yml`, enabling both `WebSite` and `Organization` JSON-LD. Posts continue to emit `BlogPosting` entities.
- Configured `search_url` to point at a Google site search query so the `SearchAction` target is valid.

## Pages with Adjusted Indexing
| URL | Action | Reason |
| --- | --- | --- |
| `/404.html` | `noindex,follow` | Avoid indexing error page. |
| `/assets/KarenHome.html` | `noindex,nofollow` | Embedded Google Map not intended for search. |
| `/assets/LukeHome.html` | `noindex,nofollow` | Embedded Google Map not intended for search. |
| `/assets/MarkHome.html` | `noindex,nofollow` | Embedded Google Map not intended for search. |
| `_pages/content/New-Topic.md` | `published: false`, `noindex` | Editorial template only. |

The sitemap continues to list canonical, indexable URLs only (834 entries in the latest build).

## Internal Linking & URL Hygiene
- Sidebar navigation now prefers `nav_title` values so we can use richer document titles without bloating anchor text.
- All automatically generated links run through `relative_url` to avoid protocol or host mismatches.

## Automation & CI
- `.github/workflows/jekyll-build.yml` now instructs Lychee to output JSON, runs `bundle exec ruby build/seo-checks.rb`, and uploads both `lychee-report.json` and `seo-checks.json` artifacts for review.
- `build/seo-checks.rb` records sitemap presence, canonical status codes, meta robot rules, and any warnings in machine-readable form. Run locally with:
  ```bash
  bundle exec jekyll build --future
  bundle exec ruby build/seo-checks.rb
  cat seo-checks.json
  ```

## Remaining Follow-Ups
- Many legacy posts rely on automatically generated excerpts for descriptions. They render well, but adding hand-written summaries would further improve CTR.
- Large hero media (GIF/MP4) could be compressed in a future pass to shave additional kilobytes.

## Google Search Console Recommendations
1. Verify the property for `https://scripts.lukeleigh.com/` (Domain property if available).
2. Navigate to **Index → Sitemaps** and submit `https://scripts.lukeleigh.com/sitemap.xml`. Confirm Google reports the submission as “Success”.
3. Use **URL Inspection** on key templates:
   - `https://scripts.lukeleigh.com/`
   - `https://scripts.lukeleigh.com/menu/_pages/scripts.html`
   - `https://scripts.lukeleigh.com/scripts/active-directory-information/` (sample post)
4. For each, click **View Crawled Page** to confirm Google sees the canonical you expect and that structured data is detected.
5. Spot-check `https://scripts.lukeleigh.com/404.html` to ensure Search Console confirms the `noindex` directive.

## Validation Snapshot
- Latest local run: 834 URLs in sitemap, 832 HTML documents scanned, 0 canonical HTTP errors, and 0 unexpected `noindex` pages (see `seo-checks.json`).
- CI artifacts `seo-reports/seo-checks.json` and `seo-reports/lychee-report.json` retain machine-readable outputs for each build.
