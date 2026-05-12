---
name: github-actions-docs
description: Use when users ask how to write, explain, customize, migrate, secure, or troubleshoot GitHub Actions workflows, workflow syntax, triggers, matrices, runners, reusable workflows, artifacts, caching, secrets, OIDC, deployments, custom actions, or Actions Runner Controller, especially when they need official GitHub documentation, exact links, or docs-grounded YAML guidance.
---

GitHub Actions questions are easy to answer from stale memory. Use this skill to ground answers in official GitHub documentation and return the closest authoritative page instead of generic CI/CD advice.

## When to Use

Use this skill when the request is about GitHub Actions specifically — not general GitHub repository operations, CodeQL, or Dependabot (see exclusions below):

- GitHub Actions concepts, terminology, or product boundaries
- Workflow YAML, triggers, jobs, matrices, concurrency, variables, contexts, or expressions
- GitHub-hosted runners, larger runners, self-hosted runners, or Actions Runner Controller
- Artifacts, caches, reusable workflows, workflow templates, or custom actions
- Secrets, `GITHUB_TOKEN`, OpenID Connect, artifact attestations, or secure workflow patterns
- Environments, deployment protection rules, deployment history, or deployment examples
- Migrating from Jenkins, CircleCI, GitLab CI/CD, Travis CI, Azure Pipelines, or other CI systems
- Troubleshooting workflow behavior when the user needs documentation, syntax guidance, or official references

Do not use this skill for:

- A specific failing PR check, missing workflow log, or CI failure triage. Use `gh-fix-ci`.
- General GitHub pull request, branch, or repository operations. Use `github`.
- CodeQL-specific configuration or code scanning guidance. Use `codeql`.
- Dependabot configuration, grouping, or dependency update strategy. Use `dependabot`.

## Workflow

### 1. Classify the request

Group the question into one of four areas before searching:

| Area                    | Covers                                                                                                       |
| ----------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Authoring**           | Workflow YAML, syntax, triggers, jobs, matrices, expressions, variables, contexts                            |
| **Infrastructure**      | GitHub-hosted runners, larger runners, self-hosted runners, Actions Runner Controller                        |
| **Security & Delivery** | Secrets, OIDC, `GITHUB_TOKEN`, attestations, environments, deployment protection, custom actions, publishing |
| **Operations**          | Artifacts, caches, reusable workflows, monitoring, logs, troubleshooting, migration from other CI systems    |

If the request spans multiple areas, classify it by its primary question. If genuinely ambiguous, default to **Authoring** and broaden the search in step 2.

### 2. Search official GitHub docs first

- Treat `docs.github.com` as the source of truth.
- Prefer pages under <https://docs.github.com/en/actions>.
- Search with the user's exact terms plus a focused Actions phrase such as `workflow syntax`, `OIDC`, `reusable workflows`, or `self-hosted runners`.
- When multiple pages are plausible, compare 2-3 candidate pages and pick the one that most directly answers the user's question.

### 3. Open the best page before answering

- Read the most relevant page, and the exact section when practical.
- Use the topic map only to narrow the search space or surface likely starting pages.
- If a page appears renamed, moved, or incomplete, say that explicitly and return the nearest authoritative pages instead of guessing.

### 4. Answer with docs-grounded guidance

- Start with a direct answer in plain language.
- Include exact GitHub docs links, not just the docs homepage.
- Only provide YAML or step-by-step examples when the user asks for them or when the docs page makes an example necessary.
- Make any inference explicit. Good phrasing:
  - `According to GitHub docs, ...`
  - `Inference: this likely means ...`

## Answer Shape

Use a compact structure unless the user asks for depth:

1. Direct answer
2. Relevant docs
3. Example YAML or steps, only if needed
4. Explicit inference callout, only if you had to connect multiple docs pages

Keep citations close to the claim they support.

## Search and Routing Tips

- For concept questions, prefer overview or concept pages before deep reference pages.
- For syntax questions, prefer workflow syntax, events, contexts, variables, or expressions reference pages.
- For security questions, prefer `Secure use`, `Secrets`, `GITHUB_TOKEN`, `OpenID Connect`, and artifact attestation docs.
- For deployment questions, prefer environments and deployment protection docs before cloud-specific examples.
- For migration questions, prefer the migration hub page first, then a platform-specific migration guide.
- If the user asks for a beginner walkthrough, start with a tutorial or quickstart instead of a raw reference page.

## Common Mistakes

- Answering from memory without verifying the current docs
- Linking the GitHub Actions docs landing page when a narrower page exists
- Mixing up reusable workflows and composite actions
- Suggesting long-lived cloud credentials when OIDC is the better documented path
- Treating repo-specific CI debugging as a documentation question when it should be handed to `gh-fix-ci`
- Letting adjacent domains absorb the request when `codeql` or `dependabot` is the sharper fit

## Bundled Reference

Read `references/topic-map.md` only as a compact index of likely doc entry points. It is intentionally incomplete and should never replace the live GitHub docs as the final authority.
