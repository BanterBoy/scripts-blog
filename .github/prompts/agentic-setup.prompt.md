---
agent: agent
description: "Bootstrap a complete agentic setup in any repository. Creates copilot-instructions.md, ORCHESTRATOR.md, an agent mode, instructions files, a context file, skills stubs, and prompt templates. Run once in a fresh repo."
---

# Agentic Repository Setup — Guided Bootstrap

You are setting up a complete GitHub Copilot agentic configuration for a repository.
By the end of this workflow, the repo will have:

- `ORCHESTRATOR.md` — living context and decision log
- `.github/copilot-instructions.md` — always-on repo instructions
- `.github/agents/<name>.agent.md` — custom agent mode
- `.github/instructions/<type>.instructions.md` — auto-injected file-type rules
- `.github/[project]-context.md` — persistent project/personal context
- `.github/skills/<name>/SKILL.md` — at least one domain skill stub
- `.github/prompts/*.prompt.md` — starter reusable workflows

Read `AGENTIC-SETUP.md` at the repo root (if present) for full background on the mental
model, file types, and conventions. If `AGENTIC-SETUP.md` is not found, continue using
only the information gathered in Step 1 — no steps need to be skipped and no functionality
is reduced; the file is supplementary reference only.

---

## Step 1 — Gather Project Information

Ask the user the following questions. Wait for all answers before creating any files.
Present them as a numbered list — do not ask one at a time.

> **Incomplete or unclear answers:** If any answer is vague or missing, ask a single
> targeted follow-up for that item before moving on. Do not proceed to Step 2 until
> all nine questions have a clear, actionable answer.
>
> **Checkpoint:** Before creating any file, confirm in Step 2 that the plan accurately
> reflects every answer. This is the only gate between gathering and execution.

```
I'll create a complete agentic setup for this repository. Before I start, I need some
information to make the configuration specific to you rather than generic.

1. **Repository purpose** — What is this repo for? (e.g., "a Jekyll blog about PowerShell",
   "a TypeScript API for managing customer orders", "a Python data pipeline")

2. **Agent name and role** — What should the AI agent be called, and what is its primary
   role? (e.g., "A.I. Blogger — writes and reviews blog posts", "Code Reviewer — reviews
   PRs against our conventions", "Dev Assistant — helps with the full dev workflow")

3. **Tech stack** — What are the main technologies? (languages, frameworks, hosting,
   CI/CD, key dependencies)

4. **Non-negotiable rules** — What must the AI never do without explicit permission?
   (e.g., "never change the remote_theme pin", "never modify production config files",
   "never push directly to main")

> **Constraints summary (fill as answers arrive):**
>
> | # | Constraint | Source file where it will appear |
> |---|-----------|----------------------------------|
> | 1 | [from answer 4] | copilot-instructions.md, agent.md |
> | … | … | … |
>
> Keep this table updated through Step 2. It is the single reference for all hard rules
> so they are applied consistently across every file created.

5. **File types and their rules** — Which file types or directories have specific
   conventions the AI should always follow when editing them?
   (e.g., "_posts/ — must follow specific anatomy", "src/api/ — must use auth middleware",
   "tests/ — must mock external calls")

6. **Repeating workflows** — What tasks do you do repeatedly that you'd want as a
   one-command prompt? (e.g., "write a new post", "review a PR", "cut a release",
   "generate a changelog")

7. **Domain skills needed** — What specialist knowledge should the AI carry?
   (e.g., "brand voice and tone", "security review checklist", "API design conventions",
   "database migration patterns")

8. **Personal or project context** — Is there personal or project-specific context the AI
   should know to write authentically? (e.g., "this is a personal blog — my background is
   X", "this is a product for Y audience", "the company is called Z")

9. **Subagent pattern?** — Do you want the agent to orchestrate subagents for complex tasks,
   or handle everything directly? (Subagent pattern works well for content-heavy or
   multi-step workflows; direct is simpler for code-focused repos.)
```

---

## Step 2 — Confirm the Plan

Before creating any files, present a brief plan:

```
Based on your answers, I'll create:

**Files to create:**
- ORCHESTRATOR.md (repo root)
- .github/copilot-instructions.md
- .github/agents/[name].agent.md
- .github/instructions/[type].instructions.md (one per file type mentioned)
- .github/[name]-context.md (project/personal context)
- .github/skills/[skill]/SKILL.md (one per domain skill)
- .github/prompts/[workflow].prompt.md (one per repeating workflow)

**Key decisions:**
- Agent name: [name from answer 2]
- Non-negotiable constraints: [summary from answer 4]
- applyTo patterns: [list from answer 5]

Shall I proceed?
```

Wait for confirmation before creating any files.

---

## Step 3 — Create ORCHESTRATOR.md

Create at the **repo root** as `ORCHESTRATOR.md`.

```markdown
# ORCHESTRATOR.md — [Agent Name] Living Context

> This file is maintained by the [Agent Name] agent.
> It is the source of truth for architecture, conventions, and decisions.
> Updated whenever meaningful changes are made.

---

## Identity

**Role**: [Agent name and purpose]
**Agent identity established**: [today's date YYYY-MM-DD]
**Primary interface**: GitHub Copilot (VS Code), [branch] branch

---

## Project Overview

| Property   | Value          |
| ---------- | -------------- |
| Repository | [owner/repo]   |
| Purpose    | [one sentence] |
| Owner      | [name/company] |

## Tech Stack

| Layer | Technology |
| ----- | ---------- |

[fill from answers]

---

## Directory Map

\`\`\`
/
[fill from project structure]
├── .github/
│ ├── copilot-instructions.md
│ ├── agents/[name].agent.md
│ ├── instructions/[files]
│ ├── prompts/[files]
│ └── skills/[skills]
\`\`\`

---

## Skills Reference

| Skill | Location | Invoke When |
| ----- | -------- | ----------- |

[fill from answer 7]

---

## Known Fragile / Non-Obvious Areas

| Area | Risk | Notes |
| ---- | ---- | ----- |

[fill from answer 4 — non-negotiable rules become fragile areas]

---

## Decision Log

| Date    | Decision              | Rationale             |
| ------- | --------------------- | --------------------- |
| [today] | Created agentic setup | Initial configuration |

---

## [Content/Feature] Inventory

[Optional: table of posts, features, modules — whatever makes sense for this repo]
```

---

## Step 4 — Create `.github/copilot-instructions.md`

```markdown
# [Agent Name] — Repo Instructions

You are the **[Agent Name]** for `[owner/repo]`.

## First Action — Always

Read `ORCHESTRATOR.md` at the repo root before doing anything else.

## Your Role

[Describe what the agent does and what it delegates. One short paragraph.]

## Skills Reference

| Skill | Location | Invoke When |
| ----- | -------- | ----------- |

[fill from answer 7]

## Non-Negotiable Rules

[List from answer 4 — these must appear here so they're always loaded]

## Subagent Briefing Template

[Include only if answer 9 was "subagent pattern"]
\`\`\`
GOAL: [exact deliverable]
FILES TO CREATE/EDIT: [exact paths]
FILES NOT TO TOUCH: [list from non-negotiable rules]
CONVENTIONS:

- Read ORCHESTRATOR.md first
- [Key conventions from answer 5]
  VERIFICATION: [what correct output looks like]
  \`\`\`
```

---

## Step 5 — Create `.github/agents/[name].agent.md`

Use the agent name from answer 2, kebab-cased for the filename.

```markdown
---
name: [kebab-case-name]
description: "[One sentence — what the agent does. Include: Use when: [...]. Do NOT use for: [...].]"
tools:
  [
    vscode/askQuestions,
    read/readFile,
    edit/editFiles,
    search/codebase,
    search/fileSearch,
    search/textSearch,
    agent/runSubagent,
    web/fetch,
  ]
---

# [Agent Name]

## First Action — Always

Read `ORCHESTRATOR.md` before doing anything else.

## What You Do

[Responsibilities. What you handle directly vs. what you delegate.]

**Handle directly (trivial):** [list]
**Delegate to subagent (substantial):** [list]

## Skills Reference

[Same table as copilot-instructions.md]

## Files Never to Touch Without Explicit Instruction

[List from non-negotiable rules]

## Subagent Briefing Template

[Same template as copilot-instructions.md, if using subagents]

## After Every Task

Update `ORCHESTRATOR.md` decision log with what changed.
```

**Tool list guidance:** Include only what the agent needs:

- Always: `vscode/askQuestions`, `read/readFile`, `search/codebase`
- If making edits: `edit/editFiles`, `edit/createFile`
- If orchestrating: `agent/runSubagent`
- If fetching docs: `web/fetch`
- Omit: browser tools unless the agent genuinely needs them

---

## Step 6 — Create `.github/instructions/*.instructions.md`

Create one file per distinct file type or directory from answer 5.

```markdown
---
applyTo: "[glob pattern from answer 5]"
---

# [File Type] Rules — Auto-Injected Context

You are editing [description of what this file type is].
These rules apply whenever a matching file is open.
For deeper reference, read `.github/skills/[skill]/SKILL.md`.

---

## [Primary Convention Name]

[The most important rules for this file type]

---

## Format / Structure Requirements

[Templates, anatomy, required elements in required order]

---

## Anti-Patterns

[What to never do in this file type, and why]

---

## Files Never to Modify Without Explicit Instruction

[Specific constraints]
```

**Tip:** Keep instructions files focused. If a rule applies to all files, it goes in
`copilot-instructions.md`. If it only applies to a specific path, it goes here.

---

## Step 7 — Create the Context File

Create `.github/[project-or-person]-context.md`.

```markdown
# [Project/Person] Context

> Maintained manually. Keep it honest and specific — generic context is useless.
> The AI uses this to write authentically rather than making things up.

---

## [Who / What This Is]

[Name, location, role, company]
[Background — how they got here]
[Current situation]

---

## Technical Background

[Stack, tools, environment, things done daily]

---

## Recurring Situations — for Anecdotes and Scene-Setting

[The patterns that come up regularly]
[What prompts action on this project]

---

## [Personal Life / Product Context / Business Context]

[Whatever is relevant to authentic output]

---

## Things the AI Should NOT Invent

Do not fabricate:

- [List specific constraints based on what's blank above]
```

---

## Step 8 — Create Skill Stubs

For each skill from answer 7, create `.github/skills/[skill-name]/SKILL.md`.

```markdown
---
name: [skill-name]
description: >
  [One paragraph describing what this skill covers and when to invoke it.
  Be specific — this text is used by the AI to decide whether to load the skill.]
---

# [Skill Title]

## Summary

[2–3 sentences: what this skill is about, who it's for, what output it produces]

---

## [Core Section 1 — e.g., Voice Constants / Coding Standards / Security Rules]

[The most important rules. Use bullet points for scanning.]

---

## [Core Section 2 — e.g., Templates / Patterns / Examples]

[Worked examples or templates the AI should follow]

---

## Anti-Patterns

[What to avoid and why]

---

## References

[Links or pointers to deeper docs if relevant]
```

---

## Step 9 — Create Prompt Files

For each repeating workflow from answer 6, create `.github/prompts/[workflow].prompt.md`.

```markdown
---
mode: agent
description: "[What this prompt does — shown when browsing prompts]"
---

# [Workflow Name] — Guided Workflow

## Before Anything Else

Read:

1. `ORCHESTRATOR.md`
2. `.github/skills/[relevant-skill]/SKILL.md`
3. `.github/[context-file].md`

---

## Step 1 — Gather Information

Ask the user:

1. [Question 1]
2. [Question 2]
3. [Question 3]

---

## Step 2 — Execute

[What to do with the answers. Be specific about file paths, formats, and order.]

---

## Step 3 — Verify

[What correct output looks like. What to check before declaring done.]

---

## After Completing

Update `ORCHESTRATOR.md` decision log.
```

---

## Step 10 — Final Verification

After creating all files, run through this checklist:

```
□ ORCHESTRATOR.md exists at repo root
□ .github/copilot-instructions.md — references ORCHESTRATOR.md, lists skills, states constraints
□ .github/agents/[name].agent.md — valid frontmatter with name, description, tools list
□ .github/instructions/*.instructions.md — each has valid applyTo in frontmatter
□ .github/[name]-context.md — no blank sections (fill in or mark "to be completed")
□ .github/skills/*/SKILL.md — each has name and description frontmatter only (no extra YAML)
□ .github/prompts/*.prompt.md — each has mode and description frontmatter

Quick functional tests:
1. Open a file matching an applyTo pattern → confirm instructions file loads in Copilot context
2. Start a chat without switching agents → confirm copilot-instructions.md applies
3. Switch to the custom agent → confirm it reads ORCHESTRATOR.md first
4. Reference a prompt → confirm it asks questions before executing
```

---

## After Setup — Maintenance Notes

Tell the user:

```
Your agentic setup is complete. A few things to keep in mind going forward:

1. **Update ORCHESTRATOR.md** after every meaningful change — use the decision log.
   Future sessions (and future you) need this context.

2. **Fill in blank sections** in the context file. The more specific, the more authentic
   the AI's output.

3. **Add to skills** as you develop conventions. A SKILL.md that starts sparse becomes
   more useful as you add examples and anti-patterns over time.

4. **Create new prompts** for every repeating workflow you discover. If you find yourself
   explaining the same task from scratch more than twice, it should be a prompt.

5. **Don't maintain duplicates.** If you're using only VS Code Copilot, don't also
   maintain a .claude/ directory. Pick one and keep only that.

6. See AGENTIC-SETUP.md at the repo root for full documentation on this setup.
```
