---
name: brand-voice
description: >
  Enforces the voice, tone, and style of Luke Leigh's personal IT blog and Leigh Services brand.
  Use when writing or reviewing any site content, blog posts, LinkedIn copy, or documentation
  to ensure British English, self-deprecating conversational tone, and correct structural patterns.
# Brand Voice Plugin Settings
# Copy this file to .claude/brand-voice.local.md in your working folder.

company_name: "Leigh Services"
platforms:
  notion: false
  confluence: false
  google-drive: false
  box: false
  microsoft-365: true
  figma: false
  gong: false
  granola: false
  slack: false
discovery:
  search-depth: standard # standard: check the immediate post file and its front matter only | deep: also scan _posts/, _pages/, and _config.yml for supporting context
  max-sources: 15
enforcement:
  strictness: balanced # strict: enforce every rule with no exceptions | balanced: enforce critical rules (language, anatomy, self-deprecation) but allow minor phrasing deviations | flexible: flag only major violations
  always-explain: true
open-questions:
  share-with-team: false
---

# Brand Context

## Company Name

Leigh Services (Leigh IT Services Limited)

## Tagline / Descriptor

Infrastructure/Automation Engineer

## Blog URL (Primary Voice Reference)

https://blog.lukeleigh.com — "Yet another IT Admin Blog"
The subtitle is intentional. It signals self-awareness and active resistance to self-promotion.

## Industry & Positioning

IT contractor specialising in infrastructure engineering, PowerShell development, and
automation. Based in Essex, UK. Solo contractor — experienced, practical, deeply technical,
and completely unpretentious about it.

## Voice Summary

Luke writes like a senior engineer having a conversation, not like someone managing a brand.
Posts meander through personal context before arriving at the point. He's self-deprecating,
genuinely community-minded, and writes for other IT admins rather than to impress anyone.
The voice is warm, occasionally dry, and very British. It shifts register naturally — informal
and anecdote-heavy in intros, precise and structured in technical sections, then back to
conversational at the close.

## We Are / We Are Not

| We Are                                         | We Are Not                              |
| ---------------------------------------------- | --------------------------------------- |
| Conversational and genuinely human             | Corporate, brand-managed, or polished   |
| Self-deprecating and honest                    | Boastful or self-promotional            |
| Technically precise when it matters            | Jargon-stacking without substance       |
| Community-minded — sharing freely              | Gatekeeping or positioning as authority |
| Warm and personable                            | Cold, formal, or impersonal             |
| British — language and cultural references     | Mid-Atlantic or Americanised            |
| Comfortable with tangents and anecdotes        | Rigidly on-message                      |
| Willing to admit things went wrong             | Polished to the point of being fake     |
| Mildly irreverent when the moment calls for it | Sanitised or HR-approved in tone        |

## Voice Constants — Priority Order

Apply these in order. Rules listed first take precedence if they conflict with later ones.

**Critical (must not deviate)**

1. British English throughout: colour, behaviour, organisation, whilst, licence (noun) etc.
2. Personal context comes FIRST. Set the scene before making the point:
   - Technical post? Open with what prompted the need.
   - Security post? Open with the incident story.
   - Module post? Open with the personal discovery/backstory.
3. Never oversell, never use superlatives about own work.
4. Attribute and link generously — quote sources, credit others, link to further reading.

**Important (enforce unless there is a clear reason not to)** 5. Write like a person talking, not a brand communicating. 6. Contractions everywhere — it's, I'm, didn't, wasn't, shouldn't, he'd, you'll. 7. Self-deprecation is a consistent feature, not occasional: "yes I am that old",
"I can tell you are all on the edge of your seats", "there is still plenty more work
to do there!" 8. Ellipses (……) used mid-sentence for conversational pauses, not just at sentence ends.

**Permitted where it fits** 9. Mild language where appropriate ("massive kick up the ass"). 10. Emoji used very sparingly and only where it adds something: 👌 ¯\_(ツ)/¯ 1️⃣

## Anti-Patterns to Avoid

**Highest priority — always flag these**

- American spellings: "color", "behavior", "organize", "license" (as noun)
- Overselling: "best-in-class", "industry-leading", "game-changing", "unique value proposition"
- Fake enthusiasm: "excited to share", "thrilled to announce", "I'm passionate about"
- Avoiding self-deprecation to sound more authoritative — the humility IS the authority

**Also avoid**

- Corporate buzzwords: "synergistic", "leverage", "cutting-edge", "world-class", "holistic"
- Overly polished phrasing that sounds like a press release or marketing copy
- Opening a post/email with a compliment or pleasantry before getting to the point
- Bullet lists instead of prose when context is conversational or narrative

## Signature Stylistic Devices

### The Self-Questioning Format

Pre-empt objections in a mock Q&A with yourself:
"That's a bit strange. Is it? Yes, surely one blog would have been enough?
Well, yes but there were, 'reasons'……honest 👌"
Use this when introducing something that might seem unusual or needs justification.

### The Knowing Aside

Acknowledge the audience with a wink: "I can tell you are all on the edge of your seats",
"Anyone who knows me will find that statement very amusing"

### The Parenthetical Aside

Slip in self-aware commentary mid-sentence: "(yes I am that old)",
"(I think I laughed when he told me but I can't be sure)"

### The Wry Footnote

Use numbered footnotes for humorous or affectionate asides that don't fit in the main text —
e.g., attributing a purchase suggestion to a family member with a knowing comment.

### Scene-Setting Before Technical Content

Never jump straight into code or instructions. A short personal paragraph first:
where you were, what prompted the need, what you were doing. Even 2–3 sentences of context
before the first heading makes a big difference.

## Tone Flexes by Context

| Context                      | Formality  | Personality                       | Technical Depth |
| ---------------------------- | ---------- | --------------------------------- | --------------- |
| Blog post intro/outro        | Very low   | High — anecdotes, asides, humour  | Low             |
| Blog post technical sections | Medium     | Low — let the content lead        | High            |
| LinkedIn post                | Low-Medium | Moderate — human but not rambling | Low-Medium      |
| Client proposal/brief        | Medium     | Low — rein in the tangents        | High            |
| Technical documentation      | Medium     | Minimal                           | High            |
| Email to a client            | Medium     | Moderate — warm, direct, British  | Medium          |
| Social / informal            | Low        | High                              | Low             |

## Structural Patterns

- Long posts use clear headed sections — but the section intros are always conversational
- Code blocks are clean, accurate, and preceded by a brief plain-English sentence
- "Further reading" / resource sections are a consistent feature — share the good stuff
- Lists are used for genuinely list-like things (accounts to check, commands), not as a
  substitute for prose

## Colour Palette

| Role                | Hex     | RGB                | Pantone |
| ------------------- | ------- | ------------------ | ------- |
| Primary (Navy)      | #233565 | rgb(35, 53, 101)   | 19-3953 |
| Secondary (Navy)    | #233565 | rgb(35, 53, 101)   | 19-3953 |
| Accent (Mint Green) | #8BD8BC | rgb(139, 216, 188) | 13-5714 |
| Background (White)  | #FFFFFF | rgb(255, 255, 255) | 11-0601 |

## Typography

| Role               | Font              |
| ------------------ | ----------------- |
| Primary            | Exo Medium        |
| Display / Wordmark | Unica One Regular |

## Logo

- Primary: Enso (Zen brushstroke circle) in navy with icon cluster and wordmark
- Tagline under wordmark: "Infrastructure/Automation Engineer"
- Variants: Full primary, Wordmark only, Icon only
- On dark backgrounds: white version; on light: navy/standard

## Approved Terminology

- "Leigh Services" (short) or "Leigh IT Services Limited" (formal/legal)
- "PowerShell Developer / Infrastructure Engineer" — both roles, in that order
- "IT Admin", "sysadmin", "admin" — plain language, not "IT Professional" or "Engineer"
- British spelling and idiom throughout

## Known Brand Materials

- OneDrive: Images and style guides
- BrandBoard.pdf: Colour palette, typography, logo versions
- Blog: https://blog.lukeleigh.com (primary real-world voice reference — read before enforcing)
