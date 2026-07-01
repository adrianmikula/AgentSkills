# Outreach Output Formats

This resource defines all supported output formats for the Business Outreach Generator. It is loaded by `Skill.md` when any outreach is generated. It contains format selection logic, tone rules, template routing, and presentation guidance.

When `Skill.md` needs format-specific details, it delegates to this file. Format-routing logic in `Skill.md` references section names from this document.

---

## Table of Contents

- [Format Routing](#format-routing)
- [Tone and Style Rules by Format](#tone-and-style-rules-by-format)
- [Template Sections](#template-sections)
- [Presentation by Format](#presentation-by-format)
- [Format-Specific Research Behaviour](#format-specific-research-behaviour)
- [Lead-Scanning Mode Routing](#lead-scanning-mode-routing)

---

## Format Routing

After the offering resource is loaded (or a generic template is generated from the idea file), select the format-specific template section using the table below.

| Output format | Template section name (in resource file or generic) |
|---------------|-----------------------------------------------------|
| `Email` | `## Email Template` |
| `LinkedIn` | `## LinkedIn Message Template` |
| `Phone` | `## Phone Call Template` |
| `Reddit` | `## Reddit Post Template` |
| `StackOverflow` | `## StackOverflow Post Template` |
| `Instagram` | `## Instagram Post Template` |
| `Airtasker` | `## Airtasker Task Response Template` |

If the loaded resource file does not contain the requested section, fall back to a **Generic Template** built from the idea's `## Context` and `## Key Facts`, formatted appropriately for the channel.

---

## Tone and Style Rules by Format

### Email
- **Length:** 200–350 words
- **Tone:** Friendly, direct, slightly urgent but never fear-mongering
- **Style:** Professional but personal. Use the contact's first name if known.
- **CTA:** One clear, low-friction action. No multiple links, no calendars, no "book a call" pressure.
- **Guarantee:** Explicitly mention any free audit is no-obligation and no follow-up spam.

### LinkedIn
- **Length:** 100–180 words (shorter, punchier)
- **Tone:** Conversational peer-to-peer, not a sales pitch
- **Style:** First-person, informal but credible. Avoid jargon. Reference shared context where possible.
- **CTA:** Soft ask — "Would you be open to a quick chat?" or "Happy to share more if useful."
- **Hook framing check:** Before writing the opener, assess whether the problem is already trending. Search social/forums for discussion volume on the topic. If the problem is well-known (multiple papers, active threads, high discussion volume): do NOT lead with "nobody talks about this" or "what nobody knows" framing. Instead, acknowledge the known problem and pivot to the gap in tooling, data, or approach. If the problem is genuinely under-discussed: lead with the discovery framing.

### Phone
- **Length:** Dot-point brief, 60–120 words of bullet points
- **Tone:** Pre-call research note, not a script
- **Style:** Concise, factual, leading questions only
- **Content:** Company overview, industry context, products/services, tech stack signals, suggested offering focus, 1–2 open questions to guide the conversation
- **Do NOT include:** Scripted conversation snippets or monologues

### Reddit
- **Length:** 150–400 words (title + body)
- **Tone:** Practitioner sharing findings, not an ad
- **Style:** Self-post (text post). Honest, story-driven. Mention the tool/idea as something you built while solving your own problem.
- **CTA:** Invite feedback, not sales. "Would love feedback on what rules/features to add." or "Happy to answer questions in comments."
- **Rules:** Follow subreddit rules — no direct linking in self-posts unless explicitly allowed. Mention the project tangentially or offer to share the link in comments. Respect strict-self-promo rules.
- **Hook framing check:** Before writing the opener, assess whether the problem is already widely discussed on Reddit and across the industry. Search recent posts, papers, and blogs for discussion volume. If the problem is well-known (multiple papers, active threads, high upvote counts): do NOT lead with "nobody talks about this" or "what nobody knows" framing. Instead, acknowledge the known problem and pivot to what's still missing — tooling, data, measurement, or a specific angle. If the problem is genuinely under-discussed: lead with the discovery framing.

#### Sales Pitch Avoidance (Reddit)

Reddit communities are aggressive toward self-promotion. Posts that read as ads get downvoted, reported to mods, and can get the account banned.

**Phrasing that triggers "this is a pitch" detection:**
- ❌ *"I've been experimenting with/building/working on a tool that..."* — Sounds like product development, not genuine experience sharing.
- ❌ *"Early results are promising"* — Classic SaaS teaser language.
- ❌ *"Curious if others have tried this"* — Reads as market validation fishing rather than genuine curiosity.
- ❌ *"I've been digging into this from a [service] angle"* — Suggests you're selling a service, not sharing findings.
- ❌ *"Happy to share more" / "feel free to DM me"* — Implies a funnel.
- ❌ *"The AI fights it at first, but once guardrails are in place"* — Product marketing voice.

**Safe alternatives:**
- ✅ Frame as personal experience: *"What I noticed on my team was..."*
- ✅ Cite independent research: *"The SlopCodeBench paper found that..."*
- ✅ Admit uncertainty: *"Not sure what the fix is — maybe we just accept the debt cost."*
- ✅ Be self-deprecating: *"Is my team unusually bad at this?"*
- ✅ Stay on-topic: Answer OP's question directly before introducing your angle.

**Moderation red flags (getting you banned):**
- Posting history of only self-promo across multiple subreddits
- Account younger than 6 months posting about their own project
- Asking for signups, leads, DMs, or "check out my profile"
- Reposting the same content to multiple subreddits
- Arguing with mods when a post is removed

**Subreddit-specific strategies:**
- **r/ExperiencedDevs, r/programming:** Must be data-backed or experience-grounded. Cite personal experiments or academic papers. Never lead with a solution. The community values critical thinking over enthusiasm.
- **r/vibecoding, r/reactjs:** More accepting of project mentions, but still no direct pitches. Frame as "I ran into this problem building my own thing" rather than "I built a tool that solves this."
- **r/WordPress:** Focus on specific technical advice. Plugin/theme mentions are expected, but don't pitch your own unless it directly solves the thread's exact problem.
- **r/SpringBoot:** Pure technical discussion. Don't mention your service unless someone explicitly asks "does anyone offer this as a service?"

**The one-post rule:** If you can't imagine reading the post and seeing a genuine contribution that happens to mention your area of work, it's a pitch. Rewrite until the product mention is optional.

### StackOverflow
- **Length:** 100–250 words (answer body only)
- **Tone:** Helpful community member, not a vendor
- **Style:** Answer the specific technical question first. Mention the tool/service only as a relevant additional resource, never the primary answer.
- **CTA:** Soft — "If you're dealing with this, I built X which handles Y." Do not link in the answer if it would be flagged as promotional; mention in profile or comments instead.
- **Rules:** Do not answer off-topic questions with promotional content. Only respond to questions directly related to the offering's domain.

### Airtasker
- **Length:** 100–200 words (task response body)
- **Tone:** Professional bidder, confident but grounded
- **Style:** Lead with deliverable and timeline. State qualifications succinctly. Include fixed price or price range.
- **CTA:** Clear next step — "Message me to discuss details" or "I can start within 48 hours."
- **Rules:** Differentiate on expertise, not just price. Airtasker users are comparing multiple bids.

### Instagram
- **Length:** Carousel: 5–10 slides, ~40–60 words per slide. Reel caption: 80–150 words.
- **Tone:** Authoritative but accessible. Educational, not salesy.
- **Style:** Visual-forward. Lead with a hook slide (question or bold statement), build the case across middle slides (data, screenshots, before/after), close with a soft CTA slide. Caption expands on the content with context and a discussion prompt.
- **CTA:** Soft — "Tag a teammate who needs to see this" or "Drop a comment if you've run into this." No direct sales links in captions. Link in bio or story sticker for deeper funnel.
- **Rules:** Follow Instagram's community guidelines — no misleading claims, no prohibited content (hacking tools, surveillance tech). Do not mention "audit", "scan", "vulnerability" in a way that implies unauthorized access. Frame as educational content, not a service advertisement. Use relevant hashtags (3–5 max) in the first comment, not the caption.

---

## Template Sections

When loading an offering resource file, extract the section matching the selected format. If the section is missing, generate a fallback.

### Fallback Template Rules

| Format | Fallback structure |
|--------|-------------------|
| Email | Subject line + greeting + 3-paragraph body (pain → proof → offer) + sign-off |
| LinkedIn | Greeting + 1–2 sentence hook + 2–3 sentence value prop + soft CTA |
| Phone | 4–6 dot points: company context, problem signal, suggested angle, 1–2 questions |
| Reddit | Title (question/statement format) + body paragraphs (story + details + feedback ask) |
| StackOverflow | Direct answer to question + 1–2 sentences contextualising + optional mention of related tooling |
| Instagram | Hook slide (question/stat) + 3–8 evidence slides (data, screenshots, comparisons) + CTA slide (discussion prompt) + caption expanding on the topic |
| Airtasker | Greeting + qualifications + deliverable summary + price + timeline + CTA |

When building a fallback, draw content from the idea file's `## Context` and `## Key Facts` sections.

---

## Presentation by Format

When presenting the final output to the human:

| Format | What to show |
|--------|-------------|
| **Email** | Full email with Subject line, body, and placeholder sign-off block. Note: "Replace [First Name] before sending." |
| **LinkedIn** | Single block of text optimised for character limits and conversational style. |
| **Phone** | Dot-point research brief: company overview, industry focus, products/services, tech stack, suggested offering focus, 1–2 leading questions. |
| **Reddit** | Title + body as a self-post. Note which subreddit it targets, character count, and whether direct links are allowed per that subreddit's rules. |
| **StackOverflow** | Question title + answer body. Note: "Verify the question is still open and on-topic before posting." |
| **Instagram** | Slide-by-slide carousel plan (slide 1 hook, slides 2–n evidence, final slide CTA) + caption text + suggested hashtags (3–5 in first comment). Recommend whether to post as a carousel, Reel, or single image based on content. Note: "Image assets will need to be created from the descriptions below." |
| **Airtasker** | Task response / bid proposal: short intro, why you're qualified, what you'll deliver, fixed price or price range, and a clear next step. Note: "Include your price and timeline in the response." |

---

## Format-Specific Research Behaviour

### Email, LinkedIn, Phone

These formats are **company-centric**. The skill:
1. Identifies a specific company or contact
2. Researches that company's website, tech stack, and relevant staff
3. Finds 2–3 local breach examples in the target country/city/industry
4. Populates the template with company-specific details

### Reddit, StackOverflow

These formats are **thread-centric**. The skill does **not** search for companies or developers to cold-pitch. Instead, it:

1. **Identifies a highly-relevant thread** (not a company) based on the selected offering's topic:
   - **Reddit:** Find existing posts in relevant subreddits where the offering's pain point is already being discussed
   - **StackOverflow:** Find an existing question where the offering's solution is directly relevant
2. **Evaluates thread relevance** using:
   - Direct match between thread topic and the idea's core value proposition
   - Thread activity level (recent, with ongoing discussion)
   - Whether the original poster is still actively seeking a solution
3. **Generates a response** that:
   - Adds genuine value to the thread
   - Mentions the offering/tool as a relevant resource, not a pitch
   - Follows platform self-promotion norms
4. **Does NOT:**
   - DM thread participants
   - Create new threads (unless the human explicitly requests it and the subreddit allows)
   - Target specific companies from thread discussions

### Instagram

This format is **audience-centric**. The skill creates educational or awareness-building content targeting a specific professional niche, not a specific company or thread:

1. **Identifies the target audience** from the selected offering's `## Keywords`, `## Context`, and `## Key Facts`
2. **Researches the audience's pain points** — what questions are developers/businesses asking on Reddit, Stack Overflow, and Twitter/X that the offering addresses
3. **Selects a content angle** from the offering's key facts that works visually:
   - Before/after comparison (e.g., "before DriftGuard vs after" codebase metrics)
   - Data-driven insight (e.g., "3 stats that show AI code degradation is real")
   - Educational how-to (e.g., "how to check if your WordPress plugins are vulnerable")
   - Myth-busting (e.g., "5 things people get wrong about Jakarta migration")
4. **Builds a carousel narrative** — hook → evidence (3–8 slides) → CTA
5. **Generates caption** that expands on the content and invites discussion
6. **Does NOT:**
   - Pitch services directly in the caption
   - Tag specific companies or individuals without their consent
   - Use sensitive security terminology in a way that could trigger content moderation

### Airtasker

This format is **job-centric**. The skill:

1. **Searches for open tasks/jobs** matching the selected offering's service category
2. **Filters for high-intent signals**:
   - Tasks with few offers (less competition)
   - Clear, specific requirements matching the offering
   - Budget in range of the offering's price point
   - Recently posted (within 48 hours)
3. **Evaluates task fit** using:
   - Skill overlap between task requirements and the idea's capabilities
   - Budget alignment
   - Client location (prefer same country/city when relevant)
4. **Generates a task response** that:
   - Addresses the specific task requirements
   - States qualifications and relevant experience
   - Provides a fixed price or price range
   - Includes a clear timeline
5. **Does NOT:**
   - Respond to tasks with 10+ existing offers (low win probability)
   - Undercut on price as primary differentiation

---

## Lead-Scanning Mode Routing

When no specific company or thread is provided, the mode triggered depends on the output format:

| Output format | Scanning mode | What it searches for |
|---------------|--------------|----------------------|
| `Email`, `LinkedIn`, `Phone` | Company / Developer Social Scanning | Companies and technical staff |
| `Reddit`, `StackOverflow` | Thread / Question Scanning | Relevant discussion threads and questions |
| `Instagram` | Audience / Trend Scanning | Professional pain points, trending discussions, and niche conversations on X/Twitter, Reddit, and LinkedIn that can be repurposed as visual educational content |
| `Airtasker` | Job / Task Scanning | Open tasks with few offers matching the offering |

### Audience / Trend Scanning (Instagram)

When `Output format` is `Instagram` and no specific audience has been provided:

1. **Research trending pain points** in the offering's domain using the idea's `## Keywords`:
   - Search X/Twitter, Reddit, and LinkedIn for questions, complaints, and discussion threads matching the idea's keywords
   - Identify 3–5 recurring themes or questions that visual content could address
2. **Select the strongest content angle** based on:
   - Frequency of the pain point (how many people are discussing it)
   - Visual potential (can this be shown with screenshots, diagrams, or before/after comparisons?)
   - Alignment with the offering's differentiation
3. **Build carousel content plan**:
   - Slide 1: Hook (bold statement or question)
   - Slides 2–7: Evidence (screenshots, data points, comparisons, code snippets)
   - Final slide: Soft CTA (discussion prompt, not a sales pitch)
4. **Draft caption** that expands on the visual content and includes:
   - Context and framing (1–2 sentences)
   - Key takeaway (1–2 sentences)
   - Discussion question (1 sentence)
   - Relevant hashtags (3–5, placed in first comment, not the caption)

### Thread / Question Scanning (Reddit + StackOverflow)

When `Output format` is `Reddit` or `StackOverflow` and no specific thread/question has been provided:

1. **Determine target platforms** based on the offering:
   - **Reddit:** Use the platform priority list from `resources/developer-social-scanning.md` (Priority 4 — Reddit), but replace the "find developers/companies" goal with "find relevant threads"
   - **StackOverflow:** Use Priority 1 from `resources/developer-social-scanning.md` (Stack Overflow), searching for questions matching the offering's problem domain
2. **Search query construction:**
   - Use the idea's `## Keywords` field as the primary query terms
   - Add problem-signal operators: `"how to"`, `"stuck on"`, `"doesn't work"`, `"looking for"`, `"recommendations"`
   - For Reddit: `site:reddit.com [keyword1] [keyword2] [current year]`
   - For StackOverflow: `site:stackoverflow.com [keyword1] [keyword2] [current year]`
3. **Thread/Question scoring:**
   - Tier 1 (+3): Direct match between thread topic and the idea's `## Keywords` / `## Context` + active engagement (comments within last 30 days) + unresolved/unaccepted
   - Tier 2 (+2): Partial keyword overlap + some engagement + no clear accepted answer
   - Tier 3 (+1): Tangential match to the idea's problem domain + older thread but still relevant
   - Disqualify: Already solved with accepted answer, or off-topic
4. **Present shortlist:** Same structure as Developer Social Scanning, but replace "Company/Contact" with "Thread/Question"
5. **Handoff:** When a thread is selected, return to the main flow with the thread context pre-populated, and generate a response-style output (not a company pitch)

### Job / Task Scanning (Airtasker)

When `Output format` is `Airtasker` and no specific task has been provided:

1. **Search strategy:**
   - Use the idea's `## Keywords` field to construct search queries for the offering category (e.g., keywords "web security, CI/CD pipeline, WordPress" → search "web security", "CI/CD", "WordPress")
   - Filter by: posted within last 7 days, fewer than 5 offers, budget in offering's price range
2. **Task scoring:**
   - Tier 1 (+3): Exact skill match + few offers (<3) + budget aligned + clear requirements
   - Tier 2 (+2): Strong skill overlap + few offers + budget slightly below range but negotiable
   - Tier 3 (+1): Partial match + few offers + budget not specified
   - Disqualify: 10+ offers, completely unrelated category, budget far below minimum
3. **Present shortlist:** Ranked list of open tasks with title, budget, offer count, requirements summary, and suggested response angle
4. **Handoff:** When a task is selected, return to the main flow with task details pre-populated, and generate an Airtasker task response
