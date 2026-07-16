---
name: infographic-generator
description: Generate infographics and presentation slides as standalone HTML files. Supports social media infographics (Instagram, LinkedIn) and PowerPoint-ready slide decks (1920×1080 16:9). Output is pure HTML/CSS — no build tools, no libraries. Can be referenced by other skills (e.g., Business Outreach Generator) for visual asset co-generation.
---

## Overview

This Skill generates branded infographics and presentation slides as standalone HTML files using pure HTML/CSS. Two approaches are available:

1. **Pure HTML/CSS (canonical)** — No dependencies. Write a `.canvas` div at target dimensions, style with CSS, convert to PNG via `capture-website-cli`. Used for Instagram and LinkedIn.
2. **AntV Infographic (legacy)** — Uses the AntV Infographic library via CDN. Available for complex chart-based visuals. See `## AntV Infographic (Legacy)` below.

For PowerPoint slides, use the pure HTML/CSS approach at 1920×1080 (16:9 widescreen) — each slide is a separate HTML file.

---

## Output Formats

| Format | Canvas Dimensions | Aspect | Approach |
|--------|-----------------|--------|----------|
| `Instagram` | 1080 × 1080 | 1:1 square | Pure HTML/CSS → PNG |
| `LinkedIn` (portrait) | 1080 × 1350 | 4:5 | Pure HTML/CSS → PNG |
| `LinkedIn` (square) | 1080 × 1080 | 1:1 | Pure HTML/CSS → PNG |
| `LinkedIn` (landscape) | 1080 × 565 | 1.91:1 | Pure HTML/CSS → PNG |
| `PowerPoint Slide` | 1920 × 1080 | 16:9 widescreen | Pure HTML/CSS (no PNG conversion) |
| `Flyer (A5)` | 1748 × 2480 | A5 portrait (≈ 1:1.42) | Pure HTML/CSS → PNG. Light background, dark text. See **Flyer-Specific (A5)** below. |

---

## Pure HTML/CSS Infographic Generation (Canonical)

### HTML Structure

Every infographic HTML file must follow this structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{Title}</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      background: {BACKGROUND_COLOR};
      font-family: {FONT_FAMILY};
    }
    .canvas {
      width: {WIDTH}px;
      height: {HEIGHT}px;
      background: {CANVAS_BG};
      position: relative;
      overflow: hidden;
    }
    .badge {
      position: absolute;
      top: 36px; left: 48px;
      background: #0a1e3d;
      color: #90caf9;
      font-size: 12px;
      font-weight: 700;
      padding: 5px 16px;
      border-radius: 20px;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      font-family: system-ui;
      border: 1px solid rgba(144,202,249,0.15);
    }
  </style>
</head>
<body>
  <div class="canvas">
    <div class="badge">CodeMedic Consulting</div>
    <!-- Content elements positioned absolutely -->
  </div>
</body>
</html>
```

### Key Rules

- **ALL content must be inside `.canvas`** — nothing outside it
- **No export buttons, no print buttons** — these will appear in captured PNGs
- The `.badge` element **must** use `background: #0a1e3d` (navy blue) with `color: #90caf9`
- Use **`position: absolute`** for all content within `.canvas` — precise top/left/right/bottom positioning
- The canvas has `overflow: hidden` — anything outside is clipped

### Layout Strategy

Use `position: absolute` with explicit coordinates for every element. Never use `margin`, `padding` on the canvas itself, or `flex`/`grid` on the canvas.

Good:
```css
h1 { position: absolute; top: 100px; left: 60px; right: 60px; font-size: 40px; color: #fff; }
.cards { position: absolute; top: 250px; left: 60px; right: 60px; }
```

You CAN use flexbox or grid INSIDE absolutely-positioned container divs.

### Brand Colors

| Element | Color |
|---------|-------|
| Badge background | `#0a1e3d` (navy blue) |
| Badge text | `#90caf9` |
| Primary accent (dark themes) | `#3b82f6` |
| Dark backgrounds | `#0f172a`, `#1e293b` |
| Warm/rustic backgrounds | `#2c1810`, `#3e2723`, `#4e342e` |
| Warm accent | `#ffcc80`, `#ffa726`, `#ff8f00` |
| Warm text | `#fff8e1`, `#bcaaa4`, `#a1887f` |
| Danger/urgency | `#ef5350`, `#ef9a9a` |

### Typography

- Dark minimal style: `system-ui, -apple-system, sans-serif`
- Warm/rustic style: `'Georgia', 'Times New Roman', serif` for headings, `system-ui` for body

### PNG Generation (Instagram & LinkedIn)

After writing the HTML file, convert to PNG:

```bash
npx capture-website-cli {input.html} --output {output.png} --element .canvas --scale-factor 1 --launch-options '{"args":["--allow-file-access-from-files"]}'
```

**Important flags:**
| Flag | Purpose |
|------|---------|
| `--element .canvas` | Captures ONLY the `.canvas` div at its natural size |
| `--scale-factor 1` | Ensures 1:1 pixel mapping |
| `--launch-options` | Required when using branding images — allows `file://` protocol to load local resources |

Do NOT use `--full-page` (captures body background). Do NOT use `--width`/`--height` (viewport doesn't matter with `--element`).

### File Naming

```
{directory}/
  {idea-slug}-{platform}-{n}-{topic}.html
  {idea-slug}-{platform}-{n}-{topic}.png
```

Example: `branded-site-instagram-1-hook.html`

---

## PowerPoint Slide Generation

### Dimensions

| Property | Value |
|----------|-------|
| Width | 1920 px |
| Height | 1080 px |
| Aspect | 16:9 widescreen (standard PowerPoint) |
| Approach | Pure HTML/CSS only (AntV not suitable for slides) |

### Per-Slide HTML Structure

Each slide is a standalone HTML file at 1920×1080. Follow the same pure HTML/CSS structure as above, with these slide-specific adjustments:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Slide N — {Title}</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      background: #0f172a;
      font-family: system-ui, -apple-system, sans-serif;
    }
    .slide {
      width: 1920px;
      height: 1080px;
      background: #0f172a;
      position: relative;
      overflow: hidden;
    }
    .badge {
      position: absolute;
      top: 36px; left: 48px;
      background: #0a1e3d;
      color: #90caf9;
      font-size: 14px;
      font-weight: 700;
      padding: 6px 20px;
      border-radius: 20px;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      border: 1px solid rgba(144,202,249,0.15);
    }
    .slide-number {
      position: absolute;
      bottom: 36px; right: 48px;
      color: rgba(255,255,255,0.3);
      font-size: 14px;
      font-family: system-ui;
    }
  </style>
</head>
<body>
  <div class="slide">
    <div class="badge">CodeMedic Consulting</div>
    <!-- Content positioned absolutely -->
    <div class="slide-number">{N} / {TOTAL}</div>
  </div>
</body>
</html>
```

### Slide Content Principles

- **Headline:** Bold statement or question, 40–56px font, positioned at top (100–180px from top)
- **Body content:** Data cards, comparison tables, bullet points in the middle zone (250–850px from top)
- **Footer/source line:** Positioned near bottom (960–1000px from top)
- **Slide number:** Bottom-right corner, `bottom: 36px; right: 48px` in faded text
- **Generous padding:** 48–80px from edges to avoid clipping on projectors
- **One message per slide:** Don't cram multiple concepts into one slide

### Content Types per Slide

| Content Type | CSS Approach | Best For |
|-------------|-------------|----------|
| Big stat / number | Centered large font (100–140px) | Hook slides, impact statements |
| Bullet list | Absolutely-positioned list with spacing | Feature lists, strategies |
| Comparison cards | Side-by-side flex containers inside positioned div | Before/after, pricing |
| Data table | CSS grid inside positioned div | Metric comparisons |
| Quote / testimonial | Large italic text with attribution | Social proof |
| Diagram boxes | Absolutely-positioned boxes with arrows | Process flows, architecture |
| QR / link slide | Centered CTA with link text | Offer/CTA slides |

### Slide Deck Organization

Slides are saved as individual HTML files in a numbered sequence:

```
../.slides/{deck-name}/
   01-title.html
   02-problem.html
   03-three-levels.html
   ...
```

A separate index/deck file is also generated that embeds all slides in a vertical scroll:

```
../.slides/{deck-name}/index.html
```

This index file uses simple CSS to display all slides stacked vertically at 1920×1080 each, with a thin separator line between them — useful for reviewing the full deck.

### Index Deck HTML Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{Deck Title} — Full Deck</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { background: #111; }
    .slide-wrapper {
      width: 1920px;
      height: 1080px;
      margin: 0 auto;
      border-bottom: 1px solid #333;
      position: relative;
      overflow: hidden;
    }
    .slide-wrapper iframe {
      width: 1920px;
      height: 1080px;
      border: none;
      transform-origin: top left;
    }
    @media (max-width: 1920px) {
      .slide-wrapper {
        width: 100%;
        height: auto;
      }
      .slide-wrapper iframe {
        width: 100%;
        height: 56.25vw;
      }
    }
  </style>
</head>
<body>
  <div class="slide-wrapper"><iframe src="01-title.html" title="Slide 1"></iframe></div>
  <div class="slide-wrapper"><iframe src="02-problem.html" title="Slide 2"></iframe></div>
  ...
</body>
</html>
```

---

## Instagram-Specific (1080×1080)

- **Square only.** Never generate rectangular Instagram images.
- Content must fit within 1080×1080. If design is too tall: reduce font sizes, reduce padding, reduce gap sizes, reduce number of items.
- Leave ~24–48px padding from canvas edges.
- The `.badge` element is required (branding). Position at `top: 36px; left: 48px`.
- **Vary layouts across a batch** — Alternate between: centered headline + bullet points, top-heavy stat + supporting text, comparison split (left/right), stacked card layout, or single bold message with whitespace. Use the Layout Variation Rule and Design System concepts (adapted for 1080×1080) to ensure variety even within a single format.

## LinkedIn-Specific

**Always confirm with the human which variant they want.** If unsure, default to portrait (4:5).

### Variant A — Portrait (1080×1350, 4:5) [Default]

Content layout flows top-to-bottom. **Vary your approach across a batch** — do not repeat the same zone structure. Below is ONE possible layout; invent others using the Layout Variation Rule and Design System tables.

Example layout (one of many):
```
Badge (top left)           ~50px
Headline                   ~120–200px
Subtitle / context         ~220–280px
Main content body          ~320–900px
CTA / key takeaway         ~920–1020px
Footer tagline             ~1060–1080px
                            total: 1350px
```

Alternatives: two-column split at ~500px, headline at bottom with data above, single centered stat with context, stacked card layout, headline + full-width image/gradient + overlay text.

### Variant B — Square (1080×1080, 1:1)

Use for denser content or cross-posting to Instagram.

### Variant C — Landscape (1080×565, 1.91:1)

Use for data charts, before/after comparisons, timeline-style content.

---

## Target Audience Parameter

The infographic generator accepts a `target_audience` input that governs the wording and framing of all text content on the canvas. This is passed by the calling skill (e.g., Business Outreach Generator), which derives it from available onboarding parameters.

### Audience Types

| Value | When to use | Wording rules |
|-------|-------------|---------------|
| `non-technical` | Business owners, hospitality staff, retail operators, service providers — no technical background | Plain language, short words, benefit-focused. Avoid jargon ("database", "CDN", "static site", "CVE", "plugin", "Next.js"). Frame everything as outcomes: "stays working" not "zero-database architecture"; "loads fast on phones" not "static CDN delivery" |
| `technical` | Developers, IT managers, engineers, technical founders | Can use industry terms and feature-level descriptions. "Plugin dependency chain", "20+ CVEs per month", "5–15 database queries per page" |
| `mixed` | Agencies, consultants, business decision-makers with some tech awareness | Balance — explain technical terms briefly in context, focus on business impact |

### Wording Guidance

**Non-technical audience:**
- Prefer short words and plain language over jargon
- Frame everything as outcomes and benefits, not features or architecture
- Replace technical nouns ("database", "CDN", "plugin", "server", "Next.js") with plain descriptions of what the result means for the business
- Use concrete, relatable scenarios ("loads fast on slow cafe WiFi" not "edge-optimised delivery")

**Technical audience:**
- Use precise terminology — the audience knows what "database queries", "CDN", "plugin architecture" mean
- Lead with capabilities and features, not just benefits
- Reference technologies by name

**Mixed audience:**
- Use the technical term once, immediately followed by a plain explanation
- Frame everything in business outcomes first, then optionally add the technical detail

### When Not Specified

If `target_audience` is not provided by the calling skill, ask the user: *"Who is the target audience for this infographic? Non-technical (plain language, no jargon), technical (industry terms OK), or mixed?"* Do not assume a default.

## Flyer-Specific (A5)

### Dimensions

| Property | Value |
|----------|-------|
| Standard | A5 (148 mm × 210 mm) |
| Width | 1748 px |
| Height | 2480 px |
| DPI | 300 (print-ready) |
| Aspect | Portrait only (≈ 1:1.42) |
| Approach | Pure HTML/CSS → PNG via `capture-website-cli` |

### Design Rules — Ink-Saving Light Theme

Flyers are designed for **physical printing**. All design decisions prioritise ink savings and readability:

| Rule | Specification | Rationale |
|------|---------------|-----------|
| Background | `#ffffff` (white) or `#fafafa` (near-white). Never use dark or full-colour backgrounds. | Saves printer ink/toner |
| Body text | `#1a1a1a` or `#222222` (near-black). Minimum 14px font for body, 11px for fine print. | Maximum readability on paper |
| Colour usage | Accent colours reserved for: headlines, sub-headers, border-left decorations, icon fills, small highlight boxes (max 2 per flyer), and dividers/rules. Do NOT use colour for full-width backgrounds, large coloured blocks, or text paragraphs. | Colour adds cost to print; use sparingly for emphasis only |
| Font | `system-ui, -apple-system, sans-serif` for body. One decorative/display font max for headlines (loaded via Google Fonts CDN if desired). | Sans-serif is most readable at small print sizes |
| Logo | Required. Place at top-left or top-center. Source from `.branding/logos/` or embed as `<img>` with fixed pixel dimensions (max 200px wide or tall). | Brand recognition |
| QR code | Required. Generate using `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data={URL_ENCODED_TARGET}` as `<img>` tag. Minimum 236 × 236 px. Place at bottom-right or bottom-center with "Scan for more info" label. The `data` parameter must be a URL-encoded link to a working, relevant page (website, booking page, contact form). | Print-accessible quick-access contact |
| Phone number | Required. Printed in clear text, minimum 16px font, e.g. "Call us: 0400 000 000". Place in the contact section. | Immediate-action contact for print |
| Website/email | Required. Printed in full as text (not hyperlinked), e.g. "Visit example.com" or "Email hello@example.com". Minimum 14px font. Place in the contact section. | Accessible for non-technical users who don't use QR codes |
| Hyperlinks | Do NOT use clickable HTML links as the sole contact method. Paper cannot be clicked. QR codes, phone numbers, and full-text URLs/emails are the expected contact methods. | Print media constraint |

### Design System — Interchangeable Components

Flyers are built by mixing and matching these components. Each component is a CSS-positioned block within the `.canvas`. **Do not use all components in one flyer.** Select 3–5 components that best serve the content angle.

| Component | Purpose | Typical position zone |
|-----------|---------|-----------------------|
| `logo-block` | Brand mark, top-left or top-center | Top 3–8% |
| `hero-stripe` | Thin colored bar at top/bottom as framing device | Top 0–0.5% or Bottom 99.5–100% |
| `corner-accent` | L-shaped corner bracket (decorative) | Any corner |
| `ornament-divider` | Dot + lines or similar decorative separator | Between sections |
| `headline-block` | Hook or value proposition (bold, 1–3 lines) | Top 8–18% |
| `story-block` | Narrative paragraph(s) explaining problem/context | Top 18–28% |
| `promise-box` | Rounded callout with soft background, centered | Mid 25–40% |
| `comparison-columns` | Side-by-side problem vs solution columns | Mid 20–50% |
| `pricing-row` | 3-tier horizontal pricing (cards, table, or inline) | Mid 35–55% |
| `feature-grid` | Icon + label grid (2×2 or 4×1) | Mid 40–60% |
| `process-steps` | Numbered step sequence with arrows | Mid 45–60% |
| `checklist` | Bullet list with checkmark icons | Mid 40–55% |
| `stats-bar` | Horizontal bar of data points/callouts | Mid 30–50% |
| `cta-block` | Large phone number or email as primary call-to-action | Bottom 10–20% |
| `contact-bar` | Phone + email + web in compact row | Bottom 8–15% |
| `qr-block` | QR code with scan label | Bottom 8–15% |
| `footer-tagline` | Brand name + descriptor line | Bottom 2–5% |

### Layout Variation Rule

**Every flyer in a batch must use a different combination of components and different visual arrangement.** Before generating, check which layouts you have already used for this idea and select a distinct approach. Recommended variation strategies:

| Variation axis | How to vary |
|----------------|-------------|
| **Component set** | Use different components. If Flyer A used `headline-block` + `story-block` + `pricing-row` + `checklist` + `contact-bar` + `qr-block`, Flyer B should use `hero-stripe` + `corner-accent` + `headline-block` + `promise-box` + `comparison-columns` + `feature-grid` + `cta-block` + `qr-block` |
| **Logo position** | Alternate: top-left, top-center, top-right, or integrated into headline |
| **Contact layout** | Alternate: phone+email-left + QR-right, phone-prominent-center + QR-right, QR-left + contact-details-right, all-contact at bottom-center in compact row |
| **Accent colour** | If the idea supports multiple themes, use different accent colours across flyers |
| **Visual weight** | Alternate: text-heavy/informative vs. icon-driven/visual vs. whitespace-heavy/minimalist |
| **Information density** | Alternate: dense with details vs. sparse with single bold message |
| **Structural layout** | Alternate: single-column vertical flow vs. multi-column grid vs. layered/overlapping elements |
| **Decorative framing** | Alternate: plain/no decoration vs. corner accents vs. top/bottom stripes vs. bordered frame vs. background watermark |
| **Pricing presentation** | Alternate: horizontal cards vs. compact inline row vs. simple table vs. single "starting from" price callout |
| **Headline treatment** | Alternate: left-aligned vs. centered vs. split with accent bar vs. question format vs. bold statement |

### Layout Examples (Not Templates — For Inspiration Only)

The following are examples of how components can combine into a cohesive layout. These are NOT prescriptive templates. Invent your own combinations.

**Layout A — Story/Postcard** (warm, emotional, minimalist):
```
Top 0–1%: hero-stripe
Top 3–8%: logo (centered)
Top 9–11%: ornament-divider
Top 12–20%: headline-block (centered, 1–3 lines)
Top 22–30%: story-block (centered narrative)
Mid 30–45%: promise-box (rounded, soft background)
Mid 45–55%: pricing-row (inline, minimal)
Mid 55–65%: feature-grid (4 icons horizontal)
Bottom 10–18%: contact-bar + qr-block (side by side)
Bottom 2–5%: footer-tagline
```

**Layout B — Comparison/Brochure** (structured, professional, column-driven):
```
Top 0–1%: hero-stripe (optional)
Top 3–8%: logo (top-left) + badge (optional)
Top 8–18%: headline-block (accent bar + headline + sub)
Mid 18–45%: comparison-columns (problem | solution)
Mid 45–55%: pricing-row (table or card style)
Mid 55–65%: process-steps (numbered, 3 steps)
Bottom 8–18%: cta-block (large phone) + email/web text + qr-block
Bottom 2–5%: footer-tagline (split layout)
```

**Layout C — Feature Showcase** (visual, icon-driven):
```
Top 3–8%: logo (top-left)
Top 8–16%: headline-block (bold statement, left-aligned)
Top 18–25%: story-block (short context paragraph)
Mid 25–50%: feature-grid (2×2 grid with icons)
Mid 50–60%: pricing-row (compact)
Mid 60–72%: checklist (bullets with checkmarks)
Bottom 10–18%: contact details + qr-block
Bottom 2–5%: footer-tagline
```

**Layout D — Minimalist/Whitespace** (bold single message):
```
Top 3–8%: logo (top-left or top-center)
Top 12–25%: headline-block (very large, 1 line, centered)
Top 28–35%: story-block (1 short paragraph)
Mid 38–50%: promise-box or single strong stat
Mid 52–58%: pricing-row (inline, no cards, very minimal)
Bottom 12–20%: cta-block (phone large) + qr-block
Bottom 2–5%: footer-tagline
```

**Layout E — Process/How-It-Works** (step-driven):
```
Top 0–1%: hero-stripe
Top 3–8%: logo (top-left)
Top 8–16%: headline-block (question format)
Top 18–25%: story-block
Mid 25–50%: process-steps (3–4 steps with or without arrows)
Mid 50–60%: pricing-row (table style)
Mid 60–72%: feature-grid or checklist
Bottom 8–18%: cta-block + qr-block
Bottom 2–5%: footer-tagline
```

### Key HTML Generation Rules for Flyers

- Set `.canvas` to `width: 1748px; height: 2480px; background: #ffffff;`
- Use `padding` on `.canvas` for print bleed margins (`100px 120px`) rather than absolute-positioning all content to edges. Content inside can use absolute positioning as needed.
- Logo: `<img>` tag with fixed max dimensions. Must reference an actual file from `.branding/logos/`.
- QR code: `<img>` tag pointing to `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data={URL_ENCODED_TARGET}`. The `data` must be URL-encoded.
- Contact details: always include phone (text), email or URL (text), AND QR code. All three are required.
- **No dark backgrounds** — body background must be `#ffffff` or `#fafafa`.
- **No full-canvas colour blocks** — colour only in small elements (highlight boxes, borders, icons).
- No export buttons, no print buttons, no JavaScript.
- Save flyer HTML to `../.flyers/{idea-slug}-flyer-{n}-{topic}.html`.
- Convert to PNG using the same `capture-website-cli` command as infographics (see "PNG Generation" above).

### Content Extraction for Flyers (Before Designing)

1. **Logo** — Business logo from `.branding/logos/`. If not available, use the business name in a styled text block as a fallback.
2. **Headline** — Bold hook or value proposition (1–2 lines, 8–16 words)
3. **Subhead** — Supporting context or framing (1 line, 5–10 words)
4. **Body content** — 2–5 paragraphs or bullet lists (150–400 words total). Longer than Instagram; can include detailed explanations.
5. **Key highlights** — 1–3 standout stats, features, or offers (for highlight boxes with accent colour)
6. **Contact info** — Phone number, email, website URL (all in text), plus QR code target URL
7. **Footer tagline** — Business name + brief descriptor
8. **Layout selection** — Review the Layout Variation Rule and Design System tables above. Choose a component combination and arrangement that is distinct from any flyers already generated for this idea. If generating multiple flyers in one batch, each must use a different layout approach.

### PNG Generation for Flyers

Use the same `capture-website-cli` command as Instagram/LinkedIn:

```bash
npx capture-website-cli {input.html} --output {output.png} --element .canvas --scale-factor 1 --launch-options '{"args":["--allow-file-access-from-files"]}'
```

The output PNG will be 1748 × 2480 px at 1:1 scale — ready for printing at 300 DPI.

---

## Content Extraction (Before Designing)

Before writing the HTML, extract visual-worthy content from the source idea file or script:

1. **Headline** — Hook or value proposition (5–10 words)
2. **Subtitle** — Supporting context (one line)
3. **Data points** — 3–5 facts, stats, or features
4. **CTA** — Call-to-action or next step
5. **Footer tagline** — Brand name + brief descriptor

## Grounding Rules — No Hallucinated Content

Every fact, quote, statistic, and persona in the infographic must be grounded in the source idea file.

### Prohibited Content Types

| Content type | Status | Example of violation | Why |
|-------------|--------|---------------------|-----|
| Testimonials from named individuals | **Prohibited unless explicitly in idea file** | "— Sarah, Owner, Local Australian Cafe" | Inventing a persona and quote with no source grounding |
| Specific metrics without source | **Prohibited** | "Orders went up 40%" | Only cite metrics listed in the idea file's `## Key Facts` or `## Context` |
| Competitor claims without source | **Prohibited** | "Better than Wix at half the price" | Unsubstantiated comparison |
| Statistics with specific numbers | **Prohibited unless sourced** | "80% of cafes struggle with X" | Must be from the idea file's cited research |

### Allowed Alternatives

If the idea file doesn't contain a testimonial or specific metric:

| Instead of | Use |
|-----------|-----|
| "— Sarah, Owner, Local Australian Cafe" | Generic framing: no quotes, just benefits. "Your cafe gets a branded site that customers remember." |
| "Orders went up 40%" | Vague up: "A branded site helps customers find and remember you." |
| "80% of cafes..." | Remove the number: "Most cafes struggle with..." |

### Post-Generation Verification Step

After generating the infographic HTML and before PNG conversion, verify every claim:

1. **Read through the HTML content** — identify every fact, number, quote, and named reference.
2. **Cross-check each against the source idea file** — does the idea file contain this exact claim?
3. **If any claim is ungrounded** — rewrite it to match the idea file exactly, or vague up to remove the fabricated detail.

Only proceed to PNG conversion after all claims pass verification.

---

## AntV Infographic (Legacy)

The AntV Infographic library (@antv/infographic via CDN) is available as an alternative for complex chart-based visuals. It supports templates like `list-row-icon-box`, `compare-horizontal-bar`, `sequence-steps`, `chart-column-simple`, `chart-donut-simple`, and `hierarchy-structure`.

**Known limitations:** Text clipping/overflow bugs with certain text lengths. Prefer the pure HTML/CSS approach above unless you specifically need chart types (donut, bar, column) that are tedious to build with CSS.

For AntV syntax construction and HTML template, see the legacy documentation in `resources/antv-legacy.md` if present, or reference the AntV Infographic GitHub repository.

---

## Branding Assets

A `.branding/` folder at the project root stores stock images and artwork for use in infographics and slides. The folder is gitignored.

### Directory Structure

```
.branding/
├── backgrounds/           # Full-canvas backdrop images
│   ├── cafe/              # Coffee shop interiors, counter scenes, barista shots
│   ├── tech/              # Server racks, workstations, terminal screens
│   ├── ai/                # Neural network viz, abstract data flows, robot/cyborg
│   └── code/              # Editor screenshots, code snippets on dark backgrounds
├── logos/                 # Brand marks, icons, logos
│   ├── cafe/              # Coffee cup icons, cafe brand marks, fork/knife symbols
│   ├── tech/              # Tech brand logos, gear/server icons, circuit patterns
│   ├── ai/                # AI/ML icons, robot silhouettes, brain/neural symbols
│   └── code/              # IDE logos, language icons (JS, Python, Java), git marks
└── heros/                 # Hero/focal images — people, scenes, product shots
    ├── cafe/              # Baristas at work, customers smiling, latte art
    ├── tech/              # Developers coding, team meetings, server rooms
    ├── ai/                # Futuristic AI concept art, robot hands, data centres
    └── code/              # Screen close-ups, code review pairs, terminal glow shots
```

### Asset Discovery

Before generating an infographic or slide, check which assets are available:

1. Check if `.branding/` exists at the project root.
2. If it exists, list the subdirectories under the required category (`backgrounds/`, `logos/`, `heros/`) to discover available themes.
3. Select the most relevant theme for the content being created:
   - **Cafe/hospitality content** → `cafe/` theme
   - **Developer tooling / IDE plugins** → `code/` or `tech/` theme
   - **AI/security/content** → `ai/` or `tech/` theme
4. If multiple images exist in a theme folder, pick the one that best matches the infographic's tone (e.g., warm/rustic for cafe, dark/minimal for tech).

### Embedding Assets in HTML

Use CSS `background-image` for full-canvas backgrounds and `<img>` tags for decorative/logos inside the `.canvas` or `.slide` container. Paths are relative to the infographic HTML file's location (`.infographics/`):

```html
<!-- Full-canvas background — CSS background-image with cover (most reliable) -->
<div class="canvas" style="background: url('../.branding/backgrounds/cafe/coffee-counter.jpg') center center / cover no-repeat;">
  <!-- Gradient overlay via ::after pseudo-element -->
  <style>.canvas::after { content: ''; position: absolute; inset: 0; background: linear-gradient(...); z-index: 1; }</style>

  <!-- Logo overlay with <img> tag -->
  <img src="../.branding/logos/cafe/coffee-cup-icon.svg"
       style="position: absolute; top: 60px; right: 60px; width: 80px; height: 80px; z-index: 3;">
</div>
```

**Critical sizing rule:** Full-canvas backgrounds must use CSS `background: url(...) center center / cover no-repeat;` on the `.canvas` or `.slide` element itself. Do NOT use `<img>` tags for full-canvas backgrounds — headless browser rendering (`capture-website-cli`) can fail to stretch `<img>` tags to fill their parent, resulting in the image occupying only a small portion of the canvas. CSS `background-image` with `background-size: cover` reliably fills the entire container regardless of source resolution.

For decorative elements (corner flourishes, floating accents, logos), use `<img>` tags with fixed pixel dimensions — these don't need to fill the full canvas.

### Usage Principles

| Asset Type | Placement | Best Use Case |
|------------|-----------|---------------|
| `backgrounds/` | CSS `background-image` with `background-size: cover` on `.canvas` or `.slide` | Full-canvas backdrop for infographics or slides |
| `logos/` | `<img>` tag, corner position (top-right or bottom-left), 60–120px | Brand marks, section icons, bullet replacements |
| `heros/` | `<img>` tag or CSS background with gradient overlay | Focal images for hook/opening slides, Instagram posts |

### Fallback

If `.branding/` does not exist, or no matching theme subfolder is found, generate the infographic entirely with CSS styling (gradients, solid colours, icon fonts, CSS shapes) — no external images. This is the standard fallback and should produce a complete, professional result without any image dependencies.

---

## Generation Checklist

- [ ] Ground all claims in the source material (idea file, script, or research)
- [ ] Write HTML with `.canvas` or `.slide` at correct dimensions
- [ ] **If Instagram/LinkedIn:** Include `.badge` with navy blue `#0a1e3d` — CodeMedic Consulting branding
- [ ] **If Flyer:** Include logo instead of badge (badge is optional)
- [ ] No export buttons, no print buttons, no extraneous UI
- [ ] All content inside `.canvas` / `.slide` — nothing outside
- [ ] All positioning via `position: absolute` at the outer level (or padding for flyers)
- [ ] Set `overflow: hidden` on the container
- [ ] **Layout Variation:** If generating multiple outputs, verify this layout uses different components and arrangement from previous ones
- [ ] For social media: convert to PNG via `capture-website-cli`
- [ ] For Flyer: convert to PNG via `capture-website-cli` at 1748×2480 px
- [ ] For Flyer: verify light background (`#ffffff` / `#fafafa`), dark text, colour used sparingly
- [ ] For Flyer: verify logo, QR code, phone number, and text URL/email are all present
- [ ] For PowerPoint: save as numbered HTML files + index deck
- [ ] Verify output with a browser preview
