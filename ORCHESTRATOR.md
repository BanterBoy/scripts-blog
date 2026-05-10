# ORCHESTRATOR.md — scripts-blog Source of Truth

> This document is the canonical reference for any agent or contributor working in `BanterBoy/scripts-blog`. Read it in full before making any changes to the repository.

---

## Repository Identity

| Property       | Value                                                              |
| -------------- | ------------------------------------------------------------------ |
| Repository     | `BanterBoy/scripts-blog`                                           |
| Live site      | `https://scripts.lukeleigh.com`                                    |
| Title          | Maintenance Scripts                                                |
| Tagline        | ITAdmin PowerShell Maintenance Scripts                             |
| Description    | A catalogue of PowerShell scripts to automate IT maintenance tasks |
| Author         | Luke Leigh — IT contractor, Essex UK                               |
| Language       | `en-GB`                                                            |
| Default branch | `prod`                                                             |
| Theme          | Minimal Mistakes `mmistakes/minimal-mistakes@4.17.2`               |
| Skin           | Dark                                                               |

---

## Architecture

### Directory Map

| Directory                 | Purpose                                                                    |
| ------------------------- | -------------------------------------------------------------------------- |
| `_posts/scripts/`         | Individual script posts — one file per PowerShell script                   |
| `_posts/snippets/`        | Shorter code snippet posts                                                 |
| `_posts/UserAdminModule/` | Module function documentation posts                                        |
| `_pages/menu/`            | Site navigation pages (`about`, `scripts`, `snippets`, `modules`, `gists`) |
| `_pages/content/`         | Evergreen reference content and landing pages                              |
| `_layouts/`               | Jekyll layout templates (`post`, `page`, `default`, `single`)              |
| `_includes/`              | Reusable Liquid components                                                 |
| `_sass/`                  | Sass partials — do not alter import order                                  |
| `assets/`                 | Static files: images, CSS, JS, downloadable scripts                        |
| `PowerShell/`             | Source PowerShell scripts — reference material, not published directly     |
| `_drafts/`                | Unpublished templates and works in progress                                |
| `build/`                  | CI/local tooling scripts (Ruby, PowerShell)                                |
| `scripts/`                | Repository automation scripts                                              |
| `.github/workflows/`      | GitHub Actions CI/CD pipelines                                             |

### Build & Local Dev

```bash
# Local development
docker-compose up
# Site served at http://localhost:4000 with --drafts enabled

# Manual Jekyll build
bundle exec jekyll build

# HTML validation
bundle exec htmlproofer ./_site
```

---

## Post Conventions

### Filenames

Posts are named after the script — **not** date-prefixed:

```
_posts/scripts/ScriptName.md
_posts/snippets/SnippetName.md
_posts/UserAdminModule/FunctionName.md
```

### Front Matter

Every post must include at minimum:

```yaml
---
layout: post
title: ScriptName.ps1
permalink: /_posts/scripts/ScriptName/
---
```

Optional but encouraged: `description`, `tags`, `categories`, `excerpt`.

Permalink pattern: `/_posts/<category>/<ScriptName>/`

### Post Anatomy

Every script post follows this exact structure — do not deviate:

````markdown
---
layout: post
title: ScriptName.ps1
permalink: /_posts/scripts/ScriptName/
---

- [Description](#description)
  - [Script](#script)
  - [Download](#download)
  - [Report Issues](#report-issues)

---

### Description

**_@GitHub Copilot_** - Welcome @BanterBoy, I'm your Copilot and I'm here to help you get
things done faster. I can identify issues, explain and even improve code.

You can ask generic questions, but what I'm really good at is helping you with your code.
For example:

Generate unit tests for my code
Explain the selected code
Propose a fix for the bugs in my code
If you want to learn more about my capabilities and limitations, check out the Copilot
documentation.

I'm powered by AI, so surprises and mistakes are possible. Make sure to verify any generated
code or suggestions, and share feedback so that we can learn and improve.

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
# script content here
```
````

#### Download

<a href="/_posts/scripts/ScriptName/" target="_blank">ScriptName.ps1</a>

#### Report Issues

Please report any issues with this script at the [GitHub repository](https://github.com/BanterBoy/scripts-blog/issues).

```

---

## Brand Voice

Full specification: `.github/skills/brand-voice/SKILL.md`

### Non-Negotiables

- **British English throughout**: colour, behaviour, organisation, whilst, licence (noun), recognise, etc.
- **Personal context first**: open with what prompted the need before the technical explanation
- **Self-deprecating and honest**: never oversell, never use superlatives about own work
- **Conversational**: contractions everywhere — it's, I'm, didn't, wasn't
- **Attribute generously**: credit sources, link to further reading, quote contributors

---

## Skills

| Skill | Path | Invoke When |
|-------|------|-------------|
| `brand-voice` | `.github/skills/brand-voice/SKILL.md` | Writing or reviewing any site content |
| `github-management` | `.github/skills/github-management/SKILL.md` | PRs, releases, branch management, issue triage |

---

## Configuration Constraints

| Setting | Value | Rule |
|---------|-------|------|
| `remote_theme` | `mmistakes/minimal-mistakes@4.17.2` | Do not bump without Docker validation |
| Algolia search-only key | Present in `_config.yml` | Safe to remain; never add admin key |
| Algolia admin key | CI environment variable only | Must never appear in any repo file |
| `baseurl` | `/` | Do not change |
| `url` | `https://scripts.lukeleigh.com` | Do not change |
| Default branch | `prod` | All PRs target `prod` |

---

## Known Fragile Areas

- **`remote_theme` pin** — `@4.17.2` is pinned for stability. Do not bump without a full Docker build test.
- **Post filenames are not date-prefixed** — intentional. This site is a script catalogue, not a chronological blog.
- **`PowerShell/` directory** — source scripts only. Do not publish files directly from here; posts in `_posts/` are the published form.
- **`_drafts/`** — contains unpublished templates and works in progress. Do not publish without explicit instruction.
- **Personal assets** — `assets/KarenHome.html`, `assets/LukeHome.html`, `assets/MarkHome.html` are personal assets. Do not remove or modify.
- **Algolia admin key** — must never appear in any repo file. Search-only key in `_config.yml` is safe.
- **`_config.yml`** — do not modify without explicit instruction.

---

## Subagent Briefing Template

When spawning a subagent for any substantive task, use this template:

```

GOAL: [exact deliverable — one sentence]

FILES TO CREATE/EDIT: [exact relative paths]

FILES NOT TO TOUCH:

- \_config.yml (unless explicitly instructed)
- remote_theme pin in \_config.yml
- Algolia keys
- assets/KarenHome.html, assets/LukeHome.html, assets/MarkHome.html

CONVENTIONS:

- Read ORCHESTRATOR.md first
- Brand voice: .github/skills/brand-voice/SKILL.md
  (British English, self-deprecating, personal context first)
- Post anatomy: front matter → description → Copilot dialogue → script block → download → report issues
- Post filenames: ScriptName.md (not date-prefixed)
- Permalinks: /\_posts/<category>/<ScriptName>/
- Branch: prod (all PRs target prod)

VERIFICATION: [what correct output looks like — be specific]

```

---

## Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-05-10 | Created `ORCHESTRATOR.md` | Establishes single source of truth for agent orchestration |
| 2026-05-10 | Created `.github/copilot-instructions.md` | Registers orchestrator role and conventions with GitHub Copilot |
| — | Post filenames not date-prefixed | Site is a script catalogue; permalinks are by script name, not date |
| — | Remote theme pinned at `@4.17.2` | Stability over recency; untested upgrades risk layout breakage |
| — | Algolia admin key in CI only | Security requirement; search-only key is safe in config |

---

## Conversation Memory

Use this section to record significant decisions, discoveries, or context that should persist across agent sessions.

### Architecture Discoveries

- Jekyll plugins in use: `jekyll-feed`, `jekyll-gist`, `jekyll-include-cache`, `jekyll-json-feed`, `jekyll-paginate`, `jekyll-seo-tag`, `jekyll-sitemap`
- `_config.yml` sets `permalink: /:categories/:title/` globally; individual post front matter permalinks override this
- `_pages/menu/` drives site navigation; links are managed in `_config.yml` navigation settings and page front matter
- `PowerShell/` subdirectories: `inProgress/`, `NewFunctions/`, `NewtonsoftJson/`, `queries/`, `scriptAssets/`, `scriptNotes/`, `scripts/`, `snippets/`, `tools/`, `UserAdminModule/`

### Content Conventions Observed

- All script posts use the `@GitHub Copilot` / `@BanterBoy:` dialogue format in the Description section
- Download section links to the raw script file; Report Issues section links to the GitHub issues page
- No Formspree or comment forms on this site (scripts catalogue, not a personal blog)
- `_drafts/` contains: `bits.md`, `IS-BLANK-tools.md`, `templatePage.md`, `templatePost.md`

### Workflow Notes

- Local dev: `docker-compose up` (port 4000)
- CI: GitHub Actions workflows in `.github/workflows/`
- Branch protection config: `docs/branch-protection.disabled` (currently disabled)
- Mergify config present at `.mergify.yml`
```
