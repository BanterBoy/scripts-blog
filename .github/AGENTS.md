# scripts-blog Agents Guidance

> **Read `ORCHESTRATOR.md` at the repo root before acting.** It is the canonical source of truth for all architecture decisions, post conventions, fragile areas, and the subagent briefing template. This file provides supplementary guidance for agents; ORCHESTRATOR.md wins in any conflict.

## Purpose of This Document

This document provides guidance for automation agents, AI assistants, and maintainers working on the scripts-blog repository. It
explains responsibilities, best practices, and workflows so that automated contributions stay consistent with the Jekyll site’s
structure and publishing standards. By following these instructions, agents can confidently add content, enhance the theme, and
maintain supporting automation without unexpected regressions.

## Repository Overview

**_Focus:_** scripts-blog powers a Jekyll site published at `https://scripts.lukeleigh.com`. Use the directories below to orient
new work and ensure updates land in the appropriate place:

- **\_posts/** – Script catalogue entries. Posts are **not** date-prefixed; filenames match the script name: `ScriptName.md`. Subdirectories by category: `scripts/`, `snippets/`, `UserAdminModule/`. Every post follows the fixed anatomy: front matter → description (Copilot dialogue) → script block → download → report issues. See ORCHESTRATOR.md for the full post anatomy and front matter requirements.
- **\_pages/** – Evergreen pages grouped by purpose. The `menu/` folder drives site navigation, while `content/` hosts longer
  reference material or landing pages. Keep permalinks aligned with existing conventions so links remain stable.
- **\_layouts/** – Page templates that set overall structure. Update these when introducing new page types or altering site-wide
  markup.
- **\_includes/** – Reusable Liquid components (headers, footers, callouts). Modify or add includes when you need to adjust shared
  fragments across multiple layouts.
- **\_sass/** – Modular Sass partials compiled into the site’s CSS. Maintain the existing naming conventions and import order when
  adjusting styling.
- **assets/** – Images, JavaScript, CSS, and other static files referenced by posts and layouts. Optimize media assets and store
  them in sensible subdirectories (e.g., `assets/img/`, `assets/js/`).
- **index.html, 404.html, robots.txt, feeds** – Root-level entry points and metadata that shape the public site experience.
  Update these thoughtfully when adjusting redirects, SEO metadata, or the home page layout.
- **\_config.yml** – Core configuration for the Jekyll build, theme, plugins, and Algolia search. Do not modify without explicit instruction. The Algolia search-only key is safe to remain in this file; the admin key must never appear in any repo file (CI env vars only). See ORCHESTRATOR.md for the full list of configuration constraints.
- **Gemfile, Gemfile.lock, docker-compose.yml, build/** – Tooling that supports local development, dependency management, and
  automation. Update these files when you change build requirements or add supporting scripts.

Historical automation resources live under **PowerShell/**. Treat them as supporting materials for the blog rather than the
primary deliverable, and update them only when they directly support published documentation.

## Roles for Agents

### Agents supporting this repository may be asked to:

- Draft or revise Markdown posts and pages, ensuring correct front matter and internal linking.
- Update layouts, includes, Sass partials, or assets to refine the site design or add new capabilities.
- Maintain configuration files, build scripts, and GitHub workflow definitions so continuous deployment remains reliable.
- Document workflows, contributor guidance, and cross-linking between the repository and the live site.
- Monitor automation (e.g., GitHub Actions, Azure Pipelines) and adjust them when new dependencies or checks are introduced.

## Guiding Principles

### Content Authoring Best Practices

- **_Front matter essentials:_** Every Jekyll-processed file must include YAML front matter specifying `layout`, `title`, and an
  appropriate `permalink`. Add `description`, `tags`, `categories`, and other metadata to support SEO and site organisation.
- **_Consistent naming:_** Post filenames are **not** date-prefixed — they match the script name: `ScriptName.md`. This is intentional; the site is a catalogue, not a chronological blog. Page filenames should mirror their permalink for clarity.
- **_Heading hierarchy:_** Begin each Markdown file with a single H1 (`# Title`). Structure subsequent content with H2/H3 levels
  and avoid skipping heading levels so generated tables of contents stay accurate.
- **_Link management:_** Use Liquid filters such as `{{ '/menu/_pages/about/' | relative_url }}` for internal links and `{{ site.url }}` for absolute references when necessary. Verify that external links include `https://` and that internal anchors resolve.
- **_Media usage:_** Optimise images before committing them, store them under `assets/`, and provide descriptive `alt` text. Use
  Markdown figure syntax or includes for galleries to keep layout consistent.
- **_Excerpts and summaries:_** Include a concise summary paragraph near the top of each post, and insert `<!--more-->` when you
  need to control home page teasers.

### Layout, Includes, and Styling

- **_Shared components first:_** When introducing new UI elements, prefer creating or updating `_includes/` files so multiple
  layouts can reuse them. Keep Liquid logic readable and comment complex conditions.
- **_Sass organisation:_** Extend existing partials in `_sass/` rather than adding large blocks of inline CSS. Follow the
  established import order in `main.scss` (or equivalent) to avoid specificity issues.
- **_Accessibility:_** Ensure semantic HTML, sufficient colour contrast, and keyboard-accessible navigation. Test changes with
  screen-reader friendly markup when possible.

### Configuration and Automation

- **_Configuration parity:_** When modifying `_config.yml` or related files, document the intent in commit messages and relevant
  READMEs. Mirror critical settings across local, staging, and production builds.
- **_Dependency management:_** Update the `Gemfile` and `Gemfile.lock` together. Note Ruby version requirements and any new gems
  in the README or site documentation.
- **_Build tooling:_** Keep supporting scripts in `build/` or the repository root idempotent and well-commented. If you add a new
  script for common tasks (e.g., link checking), ensure it runs on macOS, Linux, and GitHub-hosted runners.

### Testing and Quality Assurance

- **_Jekyll builds:_** Run `bundle exec jekyll build` before committing to verify the site compiles cleanly. For interactive
  testing, `bundle exec jekyll serve --livereload` helps spot rendering issues.
- **_Link and HTML validation:_** Where possible, run `bundle exec htmlproofer ./_site` or an equivalent checker to catch broken
  links, missing alt text, and HTML errors. Resolve issues before opening a pull request.
- **_Search and feed checks:_** Confirm that Algolia configurations, RSS/Atom feeds, and sitemap entries still render correctly
  after structural changes.
- **_Asset verification:_** Ensure referenced images, downloads, and other static files exist and load in local previews.

### Documentation Standards

- Keep the top-level `README.md` focused on the site’s purpose, development setup, and deployment workflow. Add or update
  directory-specific README files when introducing new conventions or tooling.
- Reference `.github/AGENTS.md` from contributor documentation so humans and agents alike can locate the latest automation
  guidance.
- Document significant layout changes, new includes, or build requirements within the repository to help future contributors
  understand the rationale.

## GitHub Pages and Jekyll Site Integration

The scripts-blog repository backs the live Jekyll site hosted on GitHub Pages. Treat code, content, and automation as a single
product: visitors should receive consistent information whether they read the published site or browse the repository.

### How the Jekyll Site Is Organised

- `_pages/` houses evergreen content surfaced through navigation menus and landing pages. Keep `menu/` entries synchronised with
  the live navigation structure.
- `_posts/` powers news, release notes, and change logs. Posts automatically populate archive pages, feeds, and the home page.
- `_layouts/`, `_includes/`, `_sass/`, and `assets/` define the presentation layer. Apply structural changes here so every page
  inherits the update.
- Root-level files such as `index.html`, `404.html`, `robots.txt`, `CNAME`, and `keybase.txt` control site-wide routing, search
  visibility, and domain configuration. Review them whenever you modify navigation or metadata.

### Position of This Guidance Within the Site

- `.github/AGENTS.md` is intentionally excluded from the build but remains the canonical reference for automation and authoring
  practices. When documenting contribution processes, link to this file using a stable GitHub URL like `{{ site.github.repository_url }}/blob/main/.github/AGENTS.md`.
- Summaries of these guidelines should stay in sync across README files, issue templates, and any “Contributing” pages. Update
  those summaries when this document changes.

### Formatting Expectations for Jekyll Content

- Include front matter on all Markdown or HTML files processed by Jekyll, specifying layout and metadata.
- Use Liquid helpers for internal links and asset references (`{{ '/assets/img/example.png' | relative_url }}`) so URLs work both
  locally and on GitHub Pages.
- Prefer Markdown tables only for short phrases or data points; use lists or paragraphs for narrative content.
- Keep code snippets fenced and specify the language for syntax highlighting (e.g., <code>`powershell</code> or
<code>`yaml</code>) when relevant to the article.
- Validate cross-links by building the site locally before submitting changes.

### Deployment and Automation Considerations

- Review GitHub Actions workflows (and Azure Pipelines where applicable) when altering dependencies, build commands, or
  deployment triggers. Update secrets or environment variables through the repository settings rather than hard-coding values.
- When adding new pages, posts, or includes, ensure `_config.yml` allows Jekyll to process them and that any necessary plugins are
  declared in the `Gemfile`.
- Document additional prerequisites—such as new Ruby gems, npm packages, or external services—in both workflow configuration and
  contributor-facing docs so local previews match the hosted site.

### Automation and Continuous Integration

- **_Automated checks first:_** Prioritise CI workflows that install dependencies, run `bundle exec jekyll build`, and perform
  linting or link checking before deployment steps.
- **_Reusable scripts:_** Provide helper scripts (Ruby, Bash, or PowerShell) that mirror CI steps for local use. Keep them
  idempotent and cross-platform when feasible.
- **_Content governance:_** Add safeguards against publishing drafts inadvertently (e.g., ensuring future-dated posts are
  intentional and front matter flags like `published: false` remain honoured).
- **_Data privacy:_** Confirm that any new automation handling analytics or API keys respects privacy policies and stores secrets
  securely.

## Agent Workflow

When tasked with updates, agents should follow this workflow:

1. **_Understand the request:_** Clarify whether the work involves content creation, visual design, automation, or configuration
   changes.
2. **_Locate relevant files:_** Use the repository structure to find existing posts, pages, includes, or assets to extend. Reuse
   components instead of duplicating markup.
3. **_Plan the change:_** Outline front matter, layout adjustments, and asset needs before editing. Coordinate navigation updates
   with `_config.yml` or menu includes.
4. **_Preview locally:_** Run `bundle exec jekyll serve` (or `docker-compose up` if preferred) to confirm the site renders as
   expected. Address build warnings early.
5. **_Validate automation:_** Update or create CI workflows, link checkers, or build scripts if your changes introduce new
   dependencies or processes.
6. **_Document decisions:_** Update README files, inline comments, or documentation pages to explain new structures or tooling.
7. **_Commit and review:_** Use clear commit messages, open a pull request summarising the change, and note any manual steps
   reviewers must follow.

## Future Directions

- **_Enhanced testing:_** Introduce automated HTML/link validation and visual regression testing to catch issues before they
  reach production.
- **_Component library:_** Gradually standardise UI components using `_includes/` and Sass utilities to simplify future design
  updates.
- **_Content governance:_** Develop editorial checklists or issue templates to track upcoming posts, review cycles, and approvals.
- **_Performance optimisation:_** Monitor site build times, asset sizes, and Lighthouse scores, and plan iterative improvements.
- **_Documentation depth:_** Expand contributor guides covering local development, deployment pipelines, and accessibility
  expectations.

## Final Thoughts

scripts-blog is the public face of the project’s documentation and storytelling. Treat every contribution—whether a new post, a
layout tweak, or an automation update—as part of that narrative. Aim for clarity, consistency, and a touch of personality while
upholding professional standards. By following these practices, agents will help ensure scripts-blog remains a reliable, inviting
resource for readers and maintainers alike.
