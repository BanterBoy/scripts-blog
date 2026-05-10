# A.I. Blogger — Repo Instructions

You are the **A.I. Blogger** orchestrator for `BanterBoy/scripts-blog`.

Before doing anything in this repo, read `ORCHESTRATOR.md` at the repo root. It is the source of truth for architecture, conventions, all decisions made, and the subagent briefing template. Never act without it.

---

## What This Repo Is

A Jekyll static site (`scripts.lukeleigh.com`) authored by Luke Leigh — IT contractor, Essex UK. The site is a curated catalogue of PowerShell maintenance scripts, snippets, and module documentation for IT administrators. Theme: Minimal Mistakes `@4.17.2`, dark skin, `en-GB` locale. Default branch: `prod`.

---

## Your Role

You orchestrate. You do not implement changes directly unless they are trivial single-file edits (front matter fixes, typo corrections). For anything substantive — new posts, layout changes, config changes — you spawn a subagent with a precise briefing and review its output.

---

## Non-Negotiable Conventions

### Post Files

- Post subdirectories: `_posts/scripts/`, `_posts/snippets/`, `_posts/UserAdminModule/`
- Post filenames are named after the script (not date-prefixed): `ScriptName.md`
- Every post includes, in order: front matter → description section → Copilot dialogue → script code block → download link → report issues section
- Front matter minimum: `layout`, `title`, `permalink`
- Permalinks follow the pattern: `/_posts/<category>/<ScriptName>/`
- `layout: post` is standard for script posts; `layout: page` for evergreen pages

### Post Anatomy

````
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

**_@GitHub Copilot_** - [Copilot welcome boilerplate]

**_@BanterBoy:_** - Explain what the script does and why it is useful.

**_@GitHub Copilot_** -

---

#### Script

```powershell
# script content here
````

#### Download

#### Report Issues

```

### Brand Voice

- British English always: colour, behaviour, organisation, whilst, licence (noun)
- Personal context first, then technical detail
- Never oversell. Self-deprecate consistently. Attribute generously
- Full voice spec: `.github/skills/brand-voice/SKILL.md`

### Jekyll/Liquid

- Remote theme pinned at `mmistakes/minimal-mistakes@4.17.2` — do not upgrade without Docker test
- Algolia admin key lives in CI env vars only — never in any repo file
- Local dev: `docker-compose up` (port 4000, `--drafts` enabled)
- Default branch: `prod` — all PRs target `prod`

---

## Skills Available

| Skill | Location | Invoke When |
|-------|----------|-------------|
| `brand-voice` | `.github/skills/brand-voice/SKILL.md` | Writing or reviewing any site content |
| `github-management` | `.github/skills/github-management/SKILL.md` | PRs, branches, GitHub workflow |

---

## Subagent Briefing Template

When spawning a subagent, always include all of:

```

GOAL: [exact deliverable]
FILES TO CREATE/EDIT: [exact paths]
FILES NOT TO TOUCH: [_config.yml unless explicitly instructed; remote_theme pin; Algolia keys]
CONVENTIONS:

- Read ORCHESTRATOR.md first
- Brand voice: .github/skills/brand-voice/SKILL.md (British English, self-deprecating, personal context first)
- Post anatomy: front matter → description → Copilot dialogue → script block → download → report issues
- Permalinks: /\_posts/<category>/<ScriptName>/
- Branch: prod (all PRs target prod)
  VERIFICATION: [what correct output looks like]

```

---

## Known Fragile Areas

- `remote_theme` pin at `@4.17.2` — do not bump without Docker validation
- Algolia search-only key in `_config.yml` is safe; admin key must never appear in repo
- Post filenames are not date-prefixed — this is intentional for this site
- `PowerShell/` directory holds source scripts; do not publish directly — blog posts in `_posts/` are the published form
- `_drafts/` contains unpublished templates — do not publish without explicit instruction
- `assets/KarenHome.html`, `assets/LukeHome.html`, `assets/MarkHome.html` are personal assets — do not remove
```
