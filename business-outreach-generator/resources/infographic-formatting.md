# Infographic Formatting — DEPRECATED

**This resource is deprecated.** The infographic generation capability has been extracted into its own top-level skill at `../../infographic-generator/SKILL.md`. Use that skill instead of this resource.

This file is retained for reference only.

---

## When to Use

| Output format | Generate infographic? | Canvas dimensions | Aspect | Notes |
|---------------|----------------------|-------------------|--------|-------|
| `Instagram` | **Yes** | 1080 × 1080 | 1:1 | Standard Instagram feed post |
| `LinkedIn` (portrait) | **Yes** | 1080 × 1350 | 4:5 | Preferred — more feed real estate |
| `LinkedIn` (square) | **Yes** | 1080 × 1080 | 1:1 | Alternative — works for denser content |
| `LinkedIn` (landscape) | **Yes** | 1080 × 565 | 1.91:1 | Official LinkedIn single-image ad ratio; use for link-preview-style graphics |
| All others | No | — | — | Standard text-only outreach |

---

## Approach Overview

1. Write a standalone HTML file with a `.canvas` div sized to the target dimensions
2. Style everything with pure CSS — no JavaScript libraries, no AntV dependency
3. Convert to PNG using `capture-website-cli` targeting the `.canvas` element

---

## HTML Structure (Required)

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
    /* All content positioned absolutely inside .canvas */
    .badge {
      position: absolute;
      top: 36px; left: 48px;
      background: #0a1e3d;  /* Navy blue — CodeMedic Consulting brand */
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
    /* ... additional styles for specific content ... */
  </style>
</head>
<body>
  <div class="canvas">
    <div class="badge">CodeMedic Consulting</div>
    <!-- Content elements positioned absolutely -->
    <h1>{HEADLINE}</h1>
    ...
  </div>
</body>
</html>
```

### Key Rules

- **ALL content must be inside `.canvas`** — nothing outside it (no header, no nav, no export buttons)
- **No export buttons, no print buttons** — these will appear in the captured PNG if included
- The `.badge` element **must** use `background: #0a1e3d` (navy blue) with `color: #90caf9`
- Use **`position: absolute`** for all content within `.canvas` — precise top/left/right/bottom positioning ensures exact layout control
- The canvas has `overflow: hidden` — anything outside the canvas bounds is clipped

---

## Canvas Dimensions

| Platform | Width | Height | Aspect | When to use |
|----------|-------|--------|--------|-------------|
| Instagram | `1080` | `1080` | 1:1 | Always — Instagram is strictly square |
| LinkedIn (portrait) | `1080` | `1350` | 4:5 | **Default for LinkedIn.** Gets most vertical feed real estate. Best for list-style, comparison, or stat-heavy content. |
| LinkedIn (square) | `1080` | `1080` | 1:1 | Denser content (grids, feature tables) or when cross-posting from Instagram. |
| LinkedIn (landscape) | `1080` | `565` | 1.91:1 | Link-preview-style graphics, before/after comparisons, or wide-format data charts. Matches LinkedIn's single-image ad specification. |

---

## Styling Approach

### Layout strategy

Use `position: absolute` with explicit coordinates for every element. Never use `margin`, `padding` on the canvas itself, or `flex`/`grid` on the canvas (it causes alignment issues at different viewport sizes).

Good:
```css
h1 { position: absolute; top: 100px; left: 60px; right: 60px; font-size: 40px; color: #fff; }
.cards { position: absolute; top: 250px; left: 60px; right: 60px; }
```

### Inside containers (cards, grids, rows)

You CAN use flexbox or grid INSIDE absolutely-positioned container divs. The outer positioning is absolute; inner layout can be any technique.

### Brand colors

| Element | Color |
|---------|-------|
| Badge background | `#0a1e3d` (navy blue) |
| Badge text | `#90caf9` |
| Primary accent (dark themes) | `#3b82f6` |
| Dark backgrounds | `#0f172a`, `#1e293b` |
| Warm/rustic backgrounds (cafe) | `#2c1810`, `#3e2723`, `#4e342e` |
| Warm accent | `#ffcc80`, `#ffa726`, `#ff8f00` |
| Warm text | `#fff8e1`, `#bcaaa4`, `#a1887f` |
| Danger/urgency | `#ef5350`, `#ef9a9a` |

### Typography

- Dark minimal style: `system-ui, -apple-system, sans-serif`
- Warm/rustic coffee style: `'Georgia', 'Times New Roman', serif` for headings, `system-ui` for body

---

## PNG Generation

After writing the HTML file, convert to PNG using:

```bash
npx capture-website-cli {input.html} --output {output.png} --element .canvas --scale-factor 1
```

### Why these flags?

| Flag | Purpose |
|------|---------|
| `--element .canvas` | Captures ONLY the `.canvas` div at its natural size, excluding the body background |
| `--scale-factor 1` | Ensures 1:1 pixel mapping (default is 2, which doubles dimensions) |

### Critical: No `--full-page` flag

Do NOT use `--full-page`. It captures the full scrollable page including body background, producing wrong dimensions.

Do NOT use `--width`/`--height`. These set the viewport size, which doesn't matter because `--element` captures the element at its CSS size.

### Output path

Save PNGs alongside the HTML source:

```
../.drafts/infographics/{filename}.png
```

---

## Design Rules

### Instagram-specific (1080×1080)

- **Square only.** Never generate rectangular Instagram images.
- Content must fit within 1080×1080. If the design is too tall, compact it:
  - Reduce font sizes
  - Reduce padding/margins
  - Reduce gap sizes in flex/grid layouts
  - Move `bottom:` positioned elements closer to the bottom
  - Reduce number of items (e.g., 4 features → 3)
- Leave ~24–48px padding from canvas edges for breathing room
- Badge goes in top-left corner at `top: 36px; left: 48px` (or `top: 50px; left: 60px` for warm themes with border ornament)

### LinkedIn-specific

**Always confirm with the human which variant they want.** If unsure, default to portrait (4:5), explaining: *"Portrait gets the most feed real estate. Square works for cross-posting to Instagram. Landscape works if you're sharing a link-preview-style graphic or chart."*

#### Variant A — Portrait (1080×1350, 4:5) [Default]

Preferred for most content. The extra 270px of height keeps viewers scrolling longer and allows richer layouts.

Content layout flows top-to-bottom naturally:

```
┌──────────────────────┐
│  Badge (top left)     │  ~50px
│                       │
│  Headline             │  ~120–200px
│  (bold stat or hook)  │
│                       │
│  Subtitle / context   │  ~220–280px
│                       │
│  Main content body    │  ~320–900px
│  - Data points        │
│  - Feature grid       │
│  - Comparison cards   │
│                       │
│  CTA / key takeaway   │  ~920–1020px
│                       │
│  Footer tagline       │  ~1060–1080px
└──────────────────────┘
                        total: 1350px
```

- **Headline:** Bold number, question, or contrast (e.g., "60% of agencies miss this" or "Premium sites, half price — $500")
- **Body:** 4–6 feature cards, 2–3 step process, or comparison with supporting detail
- **CTA:** Soft lead-gen — "DM me for a free audit" / "Link in comments" / "Tag a colleague"
- **Spacing:** Sections spread evenly; 24–36px gaps between blocks; bottom-positioned elements use larger values (e.g., footer at `bottom: 60px`)

#### Variant B — Square (1080×1080, 1:1)

Use when:
- Content is naturally denser (e.g., a 3×3 grid of features, or a large comparison table)
- The design works better as a compact block
- The infographic will be cross-posted to Instagram (same file, no resize needed)

Layout follows the Instagram pattern but with LinkedIn-appropriate tone (professional, less flashy):

```
┌──────────────────────┐
│  Badge (top left)     │  ~50px
│                       │
│  Headline             │  ~100–180px
│                       │
│  Subtitle             │  ~200–260px
│                       │
│  Main content         │  ~280–800px
│  (grid / cards /      │
│   comparison)         │
│                       │
│  CTA / footer         │  ~840–1080px
└──────────────────────┘
                        total: 1080px
```

- Same headline/CTA rules as portrait
- Fewer body items (3–5 vs 5–7) to avoid cramming
- Font sizes can be slightly larger since the canvas is less tall
- Bottom-elements use Instagram-style values (footer at `bottom: 36–52px`)

**Square to portrait conversion:** If you already have a square design and need a portrait variant, add one more content row in the middle section and adjust `top:` / `bottom:` values proportionally. Do not stretch the square — re-lay out the content for the taller canvas.

#### Variant C — Landscape (1080×565, 1.91:1)

Use when:
- Sharing a data chart, graph, or before/after screenshot as the primary visual
- The infographic mirrors a link-preview card (e.g., "New blog post: ...")
- Content is naturally wide (comparison bars, timelines, maps)
- You want something visually distinct from the typical portrait/square feed

Layout is naturally more compact:

```
┌────────────────────────────────────────────────┐
│  Badge (top left)                               │  ~40px
│                                                 │
│  Headline (one line, punchy)                    │  ~80–130px
│                                                 │
│  Main visual / chart / comparison               │  ~160–440px
│  (best: horizontal bar, side-by-side, timeline) │
│                                                 │
│  CTA / tagline (bottom)                         │  ~460–520px
└────────────────────────────────────────────────┘
                                                  total: 565px
```

- **Headline:** Keep to a single line (30–40px font). No room for multi-line hooks.
- **Body:** Optimise for horizontal space — use `display: flex` with `gap` for side-by-side cards, horizontal bars, or a single row of stats. Avoid tall vertical lists.
- **CTA:** Bottom strip with a link handle, price, or one-liner.
- **Limitations:** Very little vertical room. Max 2–3 items side by side. No long text paragraphs.
- **Conversion advice:** Do not vertically stretch a square or portrait design — rebuild the layout for wide format.

### Generic design principles

- **Dark backgrounds** with light text work best for engagement
- One clear focal point (headline, stat, or visual hierarchy)
- No more than 4–5 distinct content blocks per canvas
- CTA at the bottom (price, website, contact, or value proposition)
- Footer line with "Branded online ordering for Australian cafes" style tagline

---

## Content Extraction (Before Designing)

Before writing the HTML, extract visual-worthy content from the idea file:

1. **Headline** — Hook or value proposition (keep to 5–10 words)
2. **Subtitle** — Supporting context (one line)
3. **Data points** — 3–5 facts, stats, or features from `## Key Facts` or `## Context`
4. **CTA** — Price, call-to-action, or next step
5. **Footer tagline** — Idea name + brief descriptor

All claims must be grounded in the idea file. See Grounding Requirement in `SKILL.md`.

---

## File Naming

```
{directory}/
  {idea-slug}-{platform}-{n}-{topic}.html
  {idea-slug}-{platform}-{n}-{topic}.png
```

Where `{platform}` is `instagram` or `linkedin`, `{n}` is a sequence number (1, 2, 3...) and `{topic}` describes the slide content.

Examples:
- `branded-site-instagram-1-hook.html` / `branded-site-instagram-1-hook.png`
- `branded-site-linkedin-1-comparison.html` / `branded-site-linkedin-1-comparison.png`

---

## Generation Checklist

- [ ] Ground all claims in the idea file
- [ ] Write HTML with `.canvas` at correct dimensions: 1080×1080 for Instagram, 1080×1350 for LinkedIn
- [ ] Include `.badge` with navy blue `#0a1e3d` — CodeMedic Consulting branding
- [ ] No export buttons, no print buttons, no extraneous UI
- [ ] All content inside `.canvas` — nothing outside
- [ ] All positioning via `position: absolute` at the outer level
- [ ] Set `overflow: hidden` on `.canvas`
- [ ] Convert to PNG: `--element .canvas --scale-factor 1`
- [ ] Verify output dimensions with `file {output}.png`
- [ ] Save HTML + PNG side by side in `../.drafts/infographics/`

---

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| PNG is 1080×1350 instead of 1080×1080 | `.canvas` CSS height is wrong, or `--full-page` flag used, or `--scale-factor` missing | Check CSS height is 1080px; remove `--full-page`; add `--scale-factor 1` |
| Body background appears in PNG | `--element .canvas` not used | Add `--element .canvas` flag |
| Export button visible in PNG | Button element present in HTML | Remove export/print button elements |
| Content clipped/overflowing | `overflow: hidden` clips content outside canvas | Compact the design (reduce fonts, padding, gaps) |
| AntV library text clipping | AntV bug with certain text lengths | Don't use AntV. Use pure HTML/CSS instead. |
