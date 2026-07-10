# Infographic — Outreach Visual Asset Generation (DEPRECATED)

**This resource is deprecated.** The infographic generation capability has been extracted into its own top-level skill at `../../infographic-generator/SKILL.md`. The pure HTML/CSS approach in that skill supersedes the AntV library approach documented here.

This file is retained for reference only. Do not use for new generation tasks.

Infographics are generated as standalone HTML files using the [AntV Infographic](https://github.com/antvis/Infographic) library via CDN. No npm install or local build is required — the skill generates an `.html` file that the human can open in any browser to view, screenshot, or export as SVG.

---

## When to Generate Infographics

| Output format | Generate infographic? | Suggested structure |
|---------------|----------------------|---------------------|
| `Instagram` | **Yes** | Multi-slide carousel infographic (3–6 slides) or a single detailed infographic |
| `LinkedIn` | **Yes** | Single infographic for the post body (shared with text caption) |
| All others | No | Standard text-only outreach |

For Instagram, the infographic replaces or supplements the carousel slide plan. For LinkedIn, it serves as the visual anchor for the post.

---

## Prerequisite: Extract Visual-Worthy Data Points

Before generating an infographic, extract 3–5 concrete data points or structural facts from the research that can be visualised. Priority order:

1. **Comparative stat** — "Before/after", "X vs Y" (best for `compare-*` templates)
2. **Step sequence** — "How it works" (best for `sequence-*` templates)
3. **Hierarchy/list** — "5 things to know" (best for `hierarchy-*` or `list-*` templates)
4. **Causal relationship** — "X leads to Y" (best for `relation-*` templates)

All data must be grounded in the selected idea file's `## Key Facts`, `## Context`, or in research findings found during Step 4 of `Skill.md`. Do not invent statistics.

---

## Available Infographic Templates

The following templates from AntV Infographic are suited to outreach. Select one per infographic based on the data structure.

| Data shape | Template name | Best for |
|-----------|---------------|----------|
| List with description | `list-row-simple-horizontal-arrow` | Features, checklist, "5 reasons why" |
| List with icon | `list-row-icon-box` | Highlighted points with icons |
| Vertical list | `list-row-simple-vertical` | Numbered steps, tier list |
| Horizontal comparison | `compare-horizontal-bar` | Before/after, X vs Y |
| Vertical comparison | `compare-vertical-card` | Side-by-side comparison |
| Timeline | `sequence-timeline` | Chronology, phases |
| Process steps | `sequence-steps` | How-it-works, methodology |
| Statistics | `chart-column-simple` | Numeric data, rankings |
| Donut chart | `chart-donut-simple` | Proportions, percentages |
| Hierarchy | `hierarchy-structure` | Org chart, layered info |
| Mind map | `hierarchy-mindmap` | Branched concepts |

If unsure, default to `list-row-simple-horizontal-arrow` for lists or `compare-horizontal-bar` for comparisons.

---

## AntV Infographic Syntax Construction

Every infographic starts with the `infographic` keyword on line 1, followed by the template name, then indented data and optional theme blocks.

### Minimal syntax structure

```plain
infographic {template-name}
data
  {field}
    - {key} {value}
    - {key} {value}
```

### Common data fields by template family

| Template family | Primary data field | Secondary fields |
|-----------------|-------------------|------------------|
| `list-*` | `lists` | `title`, `desc` |
| `sequence-*` | `sequences` | `title`, `desc`, `order` |
| `compare-*` | `compares` | `title`, `desc`, `children` |
| `hierarchy-*` | `items` or `root` | `label`, `desc`, `children` |
| `relation-*` | `nodes`, `relations` | `label`, `desc` |
| `chart-*` | `values` | `category`, `value` |

### Theme customisation (optional)

```plain
theme
  scheme dark
  font family system-ui
```

### Example 1 — List of features

```plain
infographic list-row-icon-box
data
  title 3 things most cafes get wrong online
  desc A simple check for Perth hospitality owners
  lists
    - label No mobile menu
      desc 60% of Perth cafe sites fail mobile testing
    - label Slow load time
      desc Every 1s delay costs 7% of conversions
    - label Missing hours
      desc Google Maps data is often wrong without a site
```

### Example 2 — Before/after comparison

```plain
infographic compare-horizontal-bar
data
  title Square Online vs a branded site
  desc What owners actually notice
  compares
    - label Free Square page
      desc Generic, unbranded template. No SEO.
      value 3
    - label Branded site
      desc Your brand, your domain, full SEO control.
      value 9
```

### Example 3 — How it works (sequence)

```plain
infographic sequence-steps
data
  title How a Square-ordering site is built
  desc From signup to live in ~5 hours
  sequences
    - label Deploy template
      desc Netlify subdomain, logo, colours, custom domain
    - label Connect Square
      desc Sandbox connection, menu import
    - label Content pages
      desc About, contact, delivery info, hours
    - label QA & handover
      desc Mobile test, preview link, feedback loop
```

---

## HTML File Generation

After drafting the AntV Infographic syntax, create a complete standalone HTML file.

### File path

Save as `../.drafts/infographics/{idea-slug}-{format}-{date}-infographic.html`

Example: `../.drafts/infographics/next-square-instagram-2026-07-09-infographic.html`

Create the directory if it does not exist.

### HTML template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{title} - Infographic</title>
  <style>
    body { margin: 0; padding: 0; font-family: system-ui, -apple-system, sans-serif; background: #f5f5f5; }
    #container { width: 100vw; height: 100vh; }
    .export-btn { position: fixed; top: 12px; right: 12px; z-index: 1000; padding: 8px 14px; background: #222; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; }
    .export-btn:hover { background: #444; }
  </style>
</head>
<body>
  <button class="export-btn" onclick="exportSVG()">Download SVG</button>
  <div id="container"></div>
  <script src="https://unpkg.com/@antv/infographic@latest/dist/infographic.min.js"></script>
  <script>
    const infographic = new AntVInfographic.Infographic({
      container: '#container',
      width: '100%',
      height: '100%',
    });
    const syntax = `{ANTV_INFGRAPHIC_SYNTAX}`;
    document.fonts?.ready.then(() => {
      infographic.render(syntax);
    }).catch((error) => {
      console.error('Font load error, rendering anyway:', error);
      infographic.render(syntax);
    });
    async function exportSVG() {
      try {
        const svgDataUrl = await infographic.toDataURL({ type: 'svg' });
        const link = document.createElement('a');
        link.download = '{filename}.svg';
        link.href = svgDataUrl;
        link.click();
      } catch (e) {
        console.error('SVG export failed:', e);
        alert('SVG export failed. Try right-clicking the infographic and selecting "Save as SVG" or taking a screenshot.');
      }
    }
  </script>
</body>
</html>
```

Replace all placeholders before writing:
- `{title}` — Human-readable title for the infographic
- `{ANTV_INFGRAPHIC_SYNTAX}` — The complete AntV Infographic DSL block
- `{filename}` — Sanitised slug for the download filename

---

## Format-Specific Application

### Instagram

The infographic should cover the carousel's visual narrative. Because Instagram is mobile-first, design for a tall/vertical or square aspect ratio.

**Recommended templates for Instagram:**
- Carousel (3–6 slides): Generate ONE infographic per slide, or use `list-row-simple-horizontal-arrow` / `compare-horizontal-bar` to combine multiple data points in one image.
- Single image post: Use `list-row-icon-box` or `compare-horizontal-bar`.

**Content flow:**
1. Slide 1 (hook): Bold question or stat — use `list-row-icon-box` with a single item or `chart-column-simple` with one striking value
2. Slides 2–4 (evidence): Use `compare-horizontal-bar`, `sequence-steps`, or `chart-column-simple`
3. Final slide (CTA): Use `list-row-simple-vertical` with a single item — the discussion prompt

**Caption integration:** The caption should reference the infographic naturally. Example: *"3 things most Perth cafes get wrong online. Link in bio for the breakdown."*

**File naming:** `{idea-slug}-instagram-{date}-infographic.html`

### LinkedIn

The infographic accompanies a text caption. Design for a horizontal/landscape aspect ratio.

**Recommended templates for LinkedIn:**
- Single infographic: `compare-horizontal-bar` or `chart-column-simple`
- Process/methodology: `sequence-steps`
- Checklist: `list-row-icon-box`

**Content flow:**
1. Hook stat or bold statement
2. Supporting data (2–3 points)
3. Soft CTA or takeaway

**Caption integration:** The caption should set context and reference the visual. Example: *"I pulled together 3 stats on cafe websites in Perth that surprised me. Full breakdown in the infographic below."*

**File naming:** `{idea-slug}-linkedin-{date}-infographic.html`

---

## Research Behaviour for Infographic-Ready Content

When generating outreach for Instagram or LinkedIn, actively seek data points that can be visualised:

1. **Local market stats:** Search for statistics about website quality, mobile usage, or online ordering in the target city/country
2. **Industry benchmarks:** Find 1–2 credible stats relevant to the offering (e.g., "% of small businesses without a website", "average load time impact on conversions")
3. **Before/after signals:** If researching a specific company, note what their current site lacks vs what a proper site provides
4. **Trend data:** If a linked trend exists in `../.ideas/trends/index.md`, extract any numeric data points

Store extracted data points in the draft file alongside the text, in a `## Infographic Data` section:

```markdown
## Infographic Data

**Selected template:** compare-horizontal-bar
**Title:** Square Online vs a branded site
**Data source:** Key Facts (idea file)

- Free Square page: score 3/10
- Branded site: score 9/10
```

---

## Infographic Generation Checklist

When the output format is Instagram or LinkedIn, after generating the text outreach:

- [ ] Extract 3–5 visual-worthy data points from research
- [ ] Select an AntV Infographic template matching the data shape
- [ ] Construct valid AntV Infographic syntax
- [ ] Create the standalone HTML file using the template above
- [ ] Save to `../.drafts/infographics/{idea-slug}-{format}-{date}-infographic.html`
- [ ] Note the file path in the draft output under `**Infographic:**`
- [ ] Tell the human: "Open the HTML file in a browser to view and export as SVG. Screenshot or export for Instagram/LinkedIn upload."

---

## Example: Complete Instagram Infographic File

Generated HTML file `next-square-instagram-2026-07-09-infographic.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>3 Things Most Cafes Get Wrong Online - Infographic</title>
  <style>
    body { margin: 0; padding: 0; font-family: system-ui, -apple-system, sans-serif; background: #f5f5f5; }
    #container { width: 100vw; height: 100vh; }
    .export-btn { position: fixed; top: 12px; right: 12px; z-index: 1000; padding: 8px 14px; background: #222; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; }
    .export-btn:hover { background: #444; }
  </style>
</head>
<body>
  <button class="export-btn" onclick="exportSVG()">Download SVG</button>
  <div id="container"></div>
  <script src="https://unpkg.com/@antv/infographic@latest/dist/infographic.min.js"></script>
  <script>
    const infographic = new AntVInfographic.Infographic({
      container: '#container',
      width: '100%',
      height: '100%',
    });
    const syntax = `infographic list-row-icon-box
data
  title 3 things most cafes get wrong online
  desc A simple checklist for Perth hospitality owners
  lists
    - label No mobile menu
      desc 60% of Perth cafe sites fail mobile testing
    - label Slow load time
      desc Every 1s delay costs 7% of conversions
    - label Missing hours
      desc Google Maps data is often wrong without a site`;
    document.fonts?.ready.then(() => {
      infographic.render(syntax);
    }).catch((error) => {
      console.error('Font load error, rendering anyway:', error);
      infographic.render(syntax);
    });
    async function exportSVG() {
      try {
        const svgDataUrl = await infographic.toDataURL({ type: 'svg' });
        const link = document.createElement('a');
        link.download = 'next-square-instagram-2026-07-09-infographic.svg';
        link.href = svgDataUrl;
        link.click();
      } catch (e) {
        console.error('SVG export failed:', e);
        alert('SVG export failed. Try right-clicking the infographic and selecting "Save as SVG" or taking a screenshot.');
      }
    }
  </script>
</body>
</html>
```
