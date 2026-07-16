const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const infographicsDir = path.resolve(__dirname, '.infographics');
const flyersDir = path.resolve(__dirname, '.flyers');

/* Web-style patterns to remove/replace:
   1. Badge pills with navy bg — make it a plain text label
   2. Card/box elements with rgba backgrounds + borders + border-radius — strip to plain blocks
   3. CTA boxes that look like buttons — replace with simple text + rule
*/

function transformBadge(html) {
  // Remove pill styling from badge
  let r = html;
  // Match <div class="badge">CodeMedic Consulting</div> text, keep it but make it a plain label
  r = r.replace(
    /\.badge \{[^}]*?background: #0a1e3d;[^}]*?color: #90caf9;[^}]*?padding: [^;]*?;[^}]*?border-radius: [^;]*?;[^}]*?border: [^;]*?;[^}]*?\}/g,
    `.badge {
      position: absolute;
      font-size: 11px;
      font-weight: 600;
      color: rgba(255,255,255,0.35);
      letter-spacing: 3px;
      text-transform: uppercase;
    }
    .badge::after {
      content: '';
      display: block;
      width: 20px;
      height: 1.5px;
      background: rgba(255,255,255,0.12);
      margin-top: 5px;
    }`
  );
  // Some have padding:6px variant or slightly different syntax — catch any remaining
  r = r.replace(
    /\.badge \{[^}]*?background: #0a1e3d;[^}]*?\}/g,
    ''
  );
  return r;
}

function removeCardStyling(html) {
  // Remove rgba backgrounds, borders, and border-radius from container elements
  // Targets: any element with `background: rgba(` followed by `border: 1px solid rgba(` and `border-radius:`
  // This catches cards, plans, points, reasons, features, stat boxes etc.
  let r = html;
  
  // Pattern 1: background: rgba(...); border: ... solid rgba(...); border-radius: ...px;
  // Replace with just the positioning/display/other properties
  const cardPattern = /background:\s*rgba\([^)]+\);\s*border:\s*1px\s+solid\s+rgba\([^)]+\);\s*border-radius:\s*\d+px;/g;
  r = r.replace(cardPattern, '');
  
  // Pattern 2: background: linear-gradient(rgba(...), rgba(...)); border: ... solid rgba(...); border-radius: ...px;
  const gradientCardPattern = /background:\s*linear-gradient\([^)]+\);\s*border:\s*1px\s+solid\s+rgba\([^)]+\);\s*border-radius:\s*\d+px;/g;
  r = r.replace(gradientCardPattern, '');
  
  // Pattern 3: border-radius on items that already had background removed but kept radius
  const standaloneRadius = /border-radius:\s*\d+px;[\s]*z-index:\s*3;/g;
  r = r.replace(standaloneRadius, 'z-index: 3;');
  
  // Pattern 4: Remove dashed borders from bundle/offer boxes (look like promo codes)
  r = r.replace(/border:\s*1px\s+dashed\s+rgba\([^)]+\);/g, '');
  
  return r;
}

function removeBoxBackgrounds(html) {
  // Remove background, border, border-radius from specific box classes that look like CTAs
  // solution-box, bundle-box, verdict, result-box, tech-strip, highlight-box etc.
  // These have background: rgba(...) or linear-gradient with rgba, + border + border-radius
  
  let r = html;
  
  // Match .something-box or .something-bundle with rgba background and border-radius
  // These are typically at the bottom of infographics looking like CTA buttons
  const boxPattern = /(\.\w+-(?:box|bundle|strip|verdict))\s*\{[^}]*?background:\s*(?:rgba\([^)]+\)|linear-gradient\([^)]+\));[^}]*?border[^}]*?border-radius:\s*\d+px;[^}]*?\}/g;
  r = r.replace(boxPattern, (match, className) => {
    // Remove background, border, border-radius but keep positioning
    const cleaned = match
      .replace(/background:\s*(?:rgba\([^)]+\)|linear-gradient\([^)]+\));/g, '')
      .replace(/border:\s*1px\s+(?:solid|dashed)\s+rgba\([^)]+\);/g, '')
      .replace(/border-radius:\s*\d+px;/g, '')
      .replace(/pointer-events:\s*none;/g, '');
    return cleaned;
  });
  
  return r;
}

function removeButtonChips(html) {
  // Remove pill-like tags/badges/plan badges inside content
  // .plan-badge, .reason-tag, .tech-tag, .tier-badge, .pt-badge etc.
  let r = html;
  
  const pillPattern = /(\.\w+-badge|\.\w+-tag)\s*\{[^}]*?background:\s*[^;]+;[^}]*?border-radius:\s*\d+px;[^}]*?color:\s*#[^;]+;[^}]*?\}/g;
  r = r.replace(pillPattern, (match) => {
    // Keep the content but just as simple text without pill styling
    return match
      .replace(/background:\s*[^;]+;/g, '')
      .replace(/border-radius:\s*\d+px;/g, '')
      .replace(/border:\s*1px\s+solid\s+rgba\([^)]+\);/g, '')
      .replace(/display:\s*inline-block;\s*/g, '')
      .replace(/padding:\s*\d+px\s+\d+px;/g, '');
  });
  
  return r;
}

function fixFeaturedPlans(html) {
  // Remove featured/green background from plan items
  let r = html;
  r = r.replace(/\.(plan|pt-col|tier)\.featured\s*\{[^}]*?background:[^}]*?\}/g, 
    (match) => match.replace(/background:\s*[^;]+;/g, ''));
  return r;
}

function processFile(filePath) {
  let html = fs.readFileSync(filePath, 'utf8');
  const original = html;
  
  html = transformBadge(html);
  html = removeCardStyling(html);
  html = removeBoxBackgrounds(html);
  html = removeButtonChips(html);
  html = fixFeaturedPlans(html);
  
  if (html !== original) {
    fs.writeFileSync(filePath, html, 'utf8');
    return true;
  }
  return false;
}

// Process all infographics
console.log('=== Infographics ===');
const infographics = fs.readdirSync(infographicsDir).filter(f => f.endsWith('.html'));
for (const f of infographics) {
  const changed = processFile(path.join(infographicsDir, f));
  console.log((changed ? 'MODIFIED' : 'SKIPPED') + ': ' + f);
}

// Process all flyers
console.log('\n=== Flyers ===');
const flyers = fs.readdirSync(flyersDir).filter(f => f.endsWith('.html'));
for (const f of flyers) {
  const changed = processFile(path.join(flyersDir, f));
  console.log((changed ? 'MODIFIED' : 'SKIPPED') + ': ' + f);
}

console.log('\nDone.');
