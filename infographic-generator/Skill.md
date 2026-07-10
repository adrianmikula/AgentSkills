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

Example: `next-square-instagram-1-hook.html`

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
- Badge: `top: 36px; left: 48px`

## LinkedIn-Specific

**Always confirm with the human which variant they want.** If unsure, default to portrait (4:5).

### Variant A — Portrait (1080×1350, 4:5) [Default]

Content layout flows top-to-bottom:
```
Badge (top left)           ~50px
Headline                   ~120–200px
Subtitle / context         ~220–280px
Main content body          ~320–900px
CTA / key takeaway         ~920–1020px
Footer tagline             ~1060–1080px
                            total: 1350px
```

### Variant B — Square (1080×1080, 1:1)

Use for denser content or cross-posting to Instagram.

### Variant C — Landscape (1080×565, 1.91:1)

Use for data charts, before/after comparisons, timeline-style content.

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
- [ ] Include `.badge` with navy blue `#0a1e3d` — CodeMedic Consulting branding
- [ ] No export buttons, no print buttons, no extraneous UI
- [ ] All content inside `.canvas` / `.slide` — nothing outside
- [ ] All positioning via `position: absolute` at the outer level
- [ ] Set `overflow: hidden` on the container
- [ ] For social media: convert to PNG via `capture-website-cli`
- [ ] For PowerPoint: save as numbered HTML files + index deck
- [ ] Verify output with a browser preview
