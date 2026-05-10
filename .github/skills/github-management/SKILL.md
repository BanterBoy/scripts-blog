---
name: github-management
description: >
  GitHub specialist for the BanterBoy/scripts-blog repository. Manages repository
  settings, wiki documentation, issues, pull requests, labels, releases, and
  changelogs. USE FOR: creating or updating wiki pages, generating issue/PR
  templates, triaging issues, reviewing PRs with checklists, creating releases
  with changelogs, setting up branch protection, managing labels, generating
  release notes, auditing repo configuration. DO NOT USE FOR: writing PowerShell
  scripts (use default agent), creating change requests (use change-request skill),
  or managing other repositories.
---

# GitHub Management Skill — BanterBoy/scripts-blog

## Purpose

Provide a structured, repeatable workflow for managing the **BanterBoy/scripts-blog** GitHub repository — covering repository configuration, wiki documentation, issue/PR lifecycle, and release management. All operations target the `prod` branch (default).

## When This Skill Applies

Activate when the user:

- Asks to create, update, or review **wiki pages** or repository documentation
- Wants to **create or manage issues** (templates, labels, triage)
- Needs to **create or review pull requests** (templates, checklists, descriptions)
- Asks about **releases**, changelogs, tagging, or release notes
- Wants to **configure repository settings** (branch protection, labels, collaborators)
- Mentions "GitHub", "wiki", "issue template", "PR template", "release", "changelog", or "repo settings" in context of scripts-blog
- Asks to audit or improve the repository's GitHub configuration

## Repository Context

| Property           | Value                                                                                                                            |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| **Owner**          | BanterBoy                                                                                                                        |
| **Repository**     | scripts-blog                                                                                                                     |
| **Live Site**      | https://scripts.lukeleigh.com                                                                                                    |
| **Default Branch** | prod                                                                                                                             |
| **Current Branch** | prod                                                                                                                             |
| **Description**    | Jekyll static site — PowerShell maintenance scripts catalogue for IT administrators                                              |
| **Key Folders**    | `_posts/scripts/`, `_posts/snippets/`, `_posts/UserAdminModule/`, `_pages/`, `_layouts/`, `_includes/`, `assets/`, `PowerShell/` |

### Current GitHub Configuration State

| Feature                  | Status                                                                                                   |
| ------------------------ | -------------------------------------------------------------------------------------------------------- |
| Issue Templates          | **Not configured** — `.github/ISSUE_TEMPLATE/` missing                                                   |
| PR Template              | **Not configured** — `.github/pull_request_template.md` missing                                          |
| GitHub Actions Workflows | **Configured** — `CI.yml` (build + htmlproofer), `jekyll-build.yml` (full build validation + SEO checks) |
| CODEOWNERS               | **Present** — `* @BanterBoy`                                                                             |
| Mergify                  | **Present** — auto-merge on approval, delete head branch after merge                                     |
| CHANGELOG                | **Not present**                                                                                          |
| CONTRIBUTING.md          | **Not present**                                                                                          |
| Wiki                     | Use GitHub wiki or in-repo `/docs` folder                                                                |

## Available Tools

This skill uses the following tools depending on the task:

| Tool Category        | Tools Available                                                                                                   | Used For                                            |
| -------------------- | ----------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| **Issue/PR Queries** | `github-pull-request_issue_fetch`, `github-pull-request_doSearch`, `github-pull-request_currentActivePullRequest` | Fetching issues, searching, active PR details       |
| **Labels**           | `github-pull-request_labels_fetch`                                                                                | Listing repository labels                           |
| **PR Status**        | `github-pull-request_pullRequestStatusChecks`, `github-pull-request_pullRequestInViewport`                        | PR checks, viewing PRs                              |
| **Notifications**    | `github-pull-request_notification_fetch`                                                                          | Fetching GitHub notifications                       |
| **Repo Info**        | `github_repo`                                                                                                     | Repository metadata                                 |
| **File Operations**  | `create_file`, `replace_string_in_file`                                                                           | Creating templates, wiki pages, configs             |
| **Web Search**       | `vscode-websearchforcopilot_webSearch`                                                                            | Looking up GitHub docs, Jekyll docs, best practices |
| **Terminal**         | `run_in_terminal`                                                                                                 | Git commands, `gh` CLI operations, bundle commands  |

> **Note:** The `gh` CLI may not be installed. For operations requiring `gh` (creating releases, managing settings via CLI), provide the commands and prompt the user to install it first: `winget install --id GitHub.cli`

---

## Workflow 1 — Wiki Documentation

### When to Use

User asks to create wiki pages, document the site structure, generate contributor guidance, or maintain wiki navigation.

### Wiki Page Standard Format

All wiki pages for scripts-blog follow this structure:

```markdown
# {Page Title}

> **Last Updated:** {DATE} | **Author:** Luke Leigh

## Overview

{One to three sentences describing the purpose and scope.}

## Contents

| Post / Page       | Description      | Permalink                          |
| ----------------- | ---------------- | ---------------------------------- |
| `{ScriptName.md}` | {What it covers} | `/_posts/{category}/{ScriptName}/` |

## Adding New Content

{Steps specific to this section of the site — e.g. how to add a new script post.}

## Related Pages

- [{Related Topic}]({link})

## Notes

- {Important caveats, known issues, or tips}
```

### Workflow Steps

1. **Identify the target** — Which section or topic needs documentation?
2. **Scan existing content** — Read posts in the relevant `_posts/` subdirectory to extract titles, permalinks, and descriptions
3. **Generate the wiki page** — Fill in the standard format above
4. **Create the file** — Save to `.github/wiki/{slug}.md` (or the repo wiki)
5. **Update the Home page** — Add the new page to the wiki navigation/index

### Wiki Navigation Structure (Home.md)

```markdown
# scripts-blog Wiki

## Quick Links

- [Getting Started](Getting-Started)
- [Contributing](Contributing)
- [Post Conventions](Post-Conventions)

## Site Documentation

| Section                  | Description                               | Wiki Page                          |
| ------------------------ | ----------------------------------------- | ---------------------------------- |
| \_posts/scripts/         | Individual PowerShell script posts        | [Scripts](Scripts)                 |
| \_posts/snippets/        | Short code snippet posts                  | [Snippets](Snippets)               |
| \_posts/UserAdminModule/ | Module function documentation             | [UserAdminModule](UserAdminModule) |
| \_pages/                 | Evergreen navigation and landing pages    | [Pages](Pages)                     |
| assets/                  | Static files — images, CSS, JS, downloads | [Assets](Assets)                   |
| PowerShell/              | Source scripts (not published directly)   | [PowerShell](PowerShell)           |

## Repository Management

- [Release Process](Release-Process)
- [Branch Strategy](Branch-Strategy)
- [CI Workflows](CI-Workflows)
```

---

## Workflow 2 — Issue Management

### When to Use

User asks to create issues, triage existing issues, set up issue templates, or manage labels.

### Issue Templates

Create issue templates in `.github/ISSUE_TEMPLATE/` with this structure:

#### Bug Report Template

**File:** `.github/ISSUE_TEMPLATE/bug_report.md`

```markdown
---
name: Bug Report
about: Report a broken post, page, or site feature
title: "[BUG] "
labels: bug
assignees: BanterBoy
---

## Description

A clear description of what the bug is.

## Affected Page or Post

- **URL:** `https://scripts.lukeleigh.com/{path}`
- **File:** `{relative path in repo, e.g. _posts/scripts/ScriptName.md}`

## Steps to Reproduce

1. Go to `{URL}`
2. {Action taken}
3. Observe `{unexpected behaviour}`

## Expected Behaviour

What should happen instead.

## Actual Behaviour

What actually happens. Include screenshots or error messages if applicable.

## Environment

- **Browser:** {Chrome / Firefox / Edge / Safari}
- **OS:** {Windows / macOS / Linux}

## Additional Context

Any other context or screenshots.
```

#### New Script Post Template

**File:** `.github/ISSUE_TEMPLATE/new_script_post.md`

````markdown
---
name: New Script Post
about: Request a new script post be added to the site
title: "[NEW POST] ScriptName.ps1"
labels: enhancement
assignees: BanterBoy
---

## Script Name

`ScriptName.ps1`

## Category

- [ ] `_posts/scripts/`
- [ ] `_posts/snippets/`
- [ ] `_posts/UserAdminModule/`

## Description

What does this script do and why is it useful?

## Script Source

Link to or paste the PowerShell script content:

```powershell
# Script content here
`` `

## Download Source

Where should the download link point? (GitHub raw URL, GitHub Gist, etc.)

## Additional Notes

Any other context, attribution, or related scripts.
```
````

#### Content / Documentation Template

**File:** `.github/ISSUE_TEMPLATE/documentation.md`

```markdown
---
name: Documentation / Content
about: Request new or updated site content, page fixes, or front matter corrections
title: "[DOCS] "
labels: documentation
assignees: BanterBoy
---

## What Needs Updating

Describe what content is missing or incorrect.

## Location

- **File:** `{relative path}`
- **URL:** `https://scripts.lukeleigh.com/{path}`

## Current State

What exists today (if anything)?

## Desired State

What should it say or contain?
```

### Triage Workflow

When triaging issues, apply this decision tree:

1. **Is it a duplicate?** → Label `duplicate`, reference original, close
2. **Is it a broken page or site feature?** → Label `bug`, assess impact:
   - **Site won't build / broken navigation** → also label `help wanted`
   - **Cosmetic or single post** → label as-is
3. **Is it a new post request?** → Label `enhancement`
4. **Is it a content/docs fix?** → Label `documentation`
5. **Needs more info?** → Label `question`, ask for specifics
6. **Won't address?** → Label `wontfix`, explain why, close

### Label Reference

| Label              | Colour           | Use For                                    |
| ------------------ | ---------------- | ------------------------------------------ |
| `bug`              | Red (#d73a4a)    | Broken pages, build failures, broken links |
| `enhancement`      | Teal (#a2eeef)   | New script posts, new site features        |
| `documentation`    | Blue (#0075ca)   | Content fixes, front matter, descriptions  |
| `duplicate`        | Grey (#cfd3d7)   | Already reported                           |
| `good first issue` | Purple (#7057ff) | Simple content additions or typo fixes     |
| `help wanted`      | Green (#008672)  | Extra attention needed                     |
| `question`         | Pink (#d876e3)   | Needs more information                     |
| `invalid`          | Yellow (#e4e669) | Not valid or out of scope                  |
| `wontfix`          | White (#ffffff)  | Will not be worked on                      |

---

## Workflow 3 — Pull Request Management

### When to Use

User asks to create PRs, review PRs, set up PR templates, or establish review checklists.

### PR Template

**File:** `.github/pull_request_template.md`

````markdown
## Description

{Brief description of what this PR does.}

## Type of Change

- [ ] New script post (`_posts/scripts/`)
- [ ] New snippet post (`_posts/snippets/`)
- [ ] New UserAdminModule post (`_posts/UserAdminModule/`)
- [ ] Page / navigation update
- [ ] Layout or include change
- [ ] Config / build / CI change
- [ ] Bug fix (broken link, front matter, permalink)
- [ ] Content correction or typo fix

## Files Changed

| File     | Change Summary |
| -------- | -------------- |
| `{path}` | {what changed} |

## Checklist

### Post / Content

- [ ] Post filename matches script name (not date-prefixed): `ScriptName.md`
- [ ] Front matter includes `layout`, `title`, and `permalink`
- [ ] Permalink follows pattern `/_posts/<category>/<ScriptName>/`
- [ ] Post anatomy is correct: front matter → description → Copilot dialogue → script block → download → report issues
- [ ] British English throughout (colour, behaviour, organisation, whilst)
- [ ] PowerShell code block uses ` ```powershell ` fencing

### Build

- [ ] Jekyll build passes locally (`docker-compose up` or `bundle exec jekyll build`)
- [ ] No broken internal links
- [ ] No new draft content published accidentally

### Config / Theme

- [ ] `remote_theme` pin unchanged (`mmistakes/minimal-mistakes@4.17.2`)
- [ ] Algolia admin key not present in any file
- [ ] Personal assets not modified (`assets/KarenHome.html`, `assets/LukeHome.html`, `assets/MarkHome.html`)

## Related Issues

Closes #{issue_number}

## Additional Notes

{Any context reviewers should know.}
````

### PR Review Checklist

When reviewing a PR, check these items in order:

1. **Post Filename** — Not date-prefixed; named after the script (`ScriptName.md`)
2. **Front Matter** — Contains `layout`, `title`, and `permalink` at minimum
3. **Permalink Format** — Follows `/_posts/<category>/<ScriptName>/`
4. **Post Anatomy** — Correct order: front matter → TOC → description → Copilot dialogue → script block → download → report issues
5. **Brand Voice** — British English; personal context before technical detail; no overselling
6. **PowerShell Code** — Fenced with ` ```powershell `; content is accurate
7. **Config Safety** — `remote_theme` pin unchanged; no Algolia admin key; personal assets untouched
8. **`_config.yml`** — Not modified unless explicitly instructed
9. **`_drafts/`** — No draft content accidentally published
10. **Build** — CI passes (Jekyll build + htmlproofer + SEO checks)

---

## Workflow 4 — Release Management

### When to Use

User asks to create a release, generate a changelog, tag a version, or produce release notes.

### Version Numbering

Follow **Semantic Versioning** (SemVer): `MAJOR.MINOR.PATCH`

| Increment | When                                                               |
| --------- | ------------------------------------------------------------------ |
| **MAJOR** | Breaking changes to site structure, theme, or navigation           |
| **MINOR** | New post categories, layout changes, significant content additions |
| **PATCH** | New script posts, bug fixes, content corrections, typo fixes       |

### Changelog Format

**File:** `CHANGELOG.md` (root of repository)

```markdown
# Changelog

All notable changes to scripts-blog will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- {New posts, pages, or features}

### Changed

- {Layout, config, or content modifications}

### Fixed

- {Broken links, front matter fixes, build failures}

### Removed

- {Removed posts or deprecated pages}

---

## [{VERSION}] - {YYYY-MM-DD}

### Added

- {Description of new additions}

### Changed

- {Description of changes}

### Fixed

- {Description of fixes}
```

### Release Workflow

1. **Gather changes** — Use git log to identify commits since last release:
   ```bash
   git log --oneline {last_tag}..HEAD
   ```
2. **Categorise changes** — Sort commits into Added / Changed / Fixed / Removed
3. **Update CHANGELOG.md** — Move items from `[Unreleased]` to new version section
4. **Create git tag:**
   ```bash
   git tag -a v{VERSION} -m "Release v{VERSION}: {summary}"
   git push origin v{VERSION}
   ```
5. **Generate release notes:**

```markdown
# Release v{VERSION} — {YYYY-MM-DD}

## Highlights

{One to three sentence summary of the most important changes.}

## New Posts

- {List of new script/snippet posts added}

## Changes

- {Key layout, config, or content modifications}

## Bug Fixes

- {Broken links resolved, build issues fixed}

## Full Changelog

See [CHANGELOG.md](CHANGELOG.md) for complete details.

**Full Diff:** [{prev_version}...v{VERSION}](https://github.com/BanterBoy/scripts-blog/compare/{prev_version}...v{VERSION})
```

6. **Create GitHub release** — Once `gh` CLI is available:
   ```bash
   gh release create v{VERSION} --title "v{VERSION}" --notes-file release-notes.md
   ```

---

## Workflow 5 — Repository Configuration

### When to Use

User asks to set up branch protection, configure repo settings, manage collaborators, or audit configuration.

### Recommended Branch Protection Rules (prod)

| Setting                             | Recommended Value                              |
| ----------------------------------- | ---------------------------------------------- |
| Require pull request before merging | **Yes**                                        |
| Required approving reviews          | **1**                                          |
| Dismiss stale reviews on new pushes | **Yes**                                        |
| Require status checks to pass       | **Yes** — `ci` and `build` workflows must pass |
| Require branches to be up to date   | **Yes**                                        |
| Restrict who can push               | **Repository admins only**                     |
| Allow force pushes                  | **No**                                         |
| Allow deletions                     | **No**                                         |

### Existing CI Workflows

| Workflow                  | File                                 | Triggers          | What It Does                                                           |
| ------------------------- | ------------------------------------ | ----------------- | ---------------------------------------------------------------------- |
| `ci`                      | `.github/workflows/CI.yml`           | Push/PR to `prod` | Jekyll build + HTMLProofer                                             |
| `Jekyll Build Validation` | `.github/workflows/jekyll-build.yml` | Push/PR to `prod` | Full build, CSS verification, HTMLProofer, SEO checks, artifact upload |

Both workflows run on `ubuntu-latest` using Ruby 3.1 and `ruby/setup-ruby@v1` with `bundler-cache: true`.

### Mergify Configuration

Mergify is already configured (`.mergify.yml`). Current rules:

- **Auto-merge** on ≥1 approval
- **Auto-merge** for ImgBot PRs targeting `prod`
- **Conflict comment** — notifies author when conflicts exist
- **Delete head branch** after merge

Do not modify Mergify config without explicit instruction.

---

## Quality Checks

Before completing any GitHub management task, verify:

### Wiki Pages

- [ ] Follows the standard wiki page format
- [ ] Accurate permalinks and file paths referenced
- [ ] Related pages linked

### Issue Templates

- [ ] YAML frontmatter includes `name`, `about`, `title`, `labels`, `assignees`
- [ ] Labels reference existing repository labels
- [ ] Template sections guide the reporter to provide actionable information

### PR Templates

- [ ] Checklist enforces scripts-blog conventions (filename, front matter, permalink, anatomy, brand voice)
- [ ] Type of change options cover all content categories
- [ ] Config safety checks included (remote_theme pin, Algolia key, personal assets)

### Releases

- [ ] Version follows SemVer
- [ ] CHANGELOG.md updated with all changes categorised
- [ ] Release notes include highlights, diff link, and full changelog reference
- [ ] Git tag created and pushed

### Repository Configuration

- [ ] Branch protection requires CI to pass before merge
- [ ] `remote_theme` pin at `@4.17.2` preserved

---

## Defaults Reference

| Field                   | Default Value                      |
| ----------------------- | ---------------------------------- |
| Repository              | BanterBoy/scripts-blog             |
| Default Branch          | prod                               |
| Assignee                | BanterBoy                          |
| Author                  | Luke Leigh                         |
| Version Scheme          | SemVer (MAJOR.MINOR.PATCH)         |
| Changelog Format        | Keep a Changelog                   |
| Wiki Location           | `.github/wiki/` or GitHub Wiki     |
| Issue Template Location | `.github/ISSUE_TEMPLATE/`          |
| PR Template Location    | `.github/pull_request_template.md` |
| Workflow Location       | `.github/workflows/`               |

---

## Example Prompts

> "Create a wiki page for the scripts-blog post conventions"

→ Generates a wiki page covering post anatomy, front matter requirements, and filename conventions

> "Set up issue templates for the repo"

→ Creates bug report, new script post, and documentation templates in `.github/ISSUE_TEMPLATE/`

> "Create a PR template"

→ Generates `.github/pull_request_template.md` with scripts-blog content and config safety checklist

> "Generate release notes for everything since last month"

→ Runs git log, categorises changes, updates CHANGELOG.md, generates release notes

> "What issues are open right now?"

→ Fetches and summarises open issues with labels and status

> "Review the current PR"

→ Fetches active PR, runs through the scripts-blog review checklist, reports findings

> "Triage this issue"

→ Reads the issue, applies the triage decision tree, recommends labels and next steps
