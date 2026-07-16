const fs = require('fs');
const path = require('path');

const dirs = [
  path.resolve(__dirname, '.infographics'),
  path.resolve(__dirname, '.flyers')
];

function cleanFile(filePath) {
  let html = fs.readFileSync(filePath, 'utf8');
  const original = html;
  let changed = false;

  // 1. Remove remaining box backgrounds from veredict/solution/bundle/highlight/tech-strip
  // These might still have gradient backgrounds or plain rgba backgrounds after first pass
  html = html.replace(
    /\.(verdict|result-box|solution-box|bundle-box|highlight-box|tech-strip|promise-box|guarantee|stats-bar)\s*\{[^}]*?background:[^}]*?rgba[^}]*?\}/g,
    (match) => {
      changed = true;
      // Only remove background & border-radius, keep everything else
      return match
        .replace(/background:\s*[^;]+;/g, '')
        .replace(/border-radius:\s*\d+px;/g, '')
        .replace(/border:\s*1px\s+(solid|dashed)\s+rgba\([^)]+\);/g, '');
    }
  );

  // 2. Remove pill-like pricing badges (plan-badge, tier-badge, pt-badge, pbadge)
  html = html.replace(
    /\.\w+-badge\s*\{[^}]*?background:[^}]*?(?:#[0-9a-f]+|rgba)[^}]*?\}/g,
    (match) => {
      changed = true;
      return match
        .replace(/background:\s*[^;]+;/g, '')
        .replace(/border-radius:\s*\d+px;/g, '')
        .replace(/display:\s*inline-block;/g, '')
        .replace(/padding:\s*\d+px\s+\d+px;/g, '');
    }
  );

  // 3. Remove tag/chip styling (reason-tag, tech-tag)
  html = html.replace(
    /\.\w+-tag\s*\{[^}]*?background:[^}]*?rgba[^}]*?\}/g,
    (match) => {
      changed = true;
      return match
        .replace(/background:\s*[^;]+;/g, '')
        .replace(/border-radius:\s*\d+px;/g, '')
        .replace(/display:\s*inline-block;/g, '')
        .replace(/padding:\s*\d+px\s+\d+px;/g, '');
    }
  );

  // 4. Remove card/point/reason/feature row backgrounds (gradient or rgba)
  html = html.replace(
    /\.(card|point|reason|feature)\s*\{[^}]*?background:\s*(?:linear-gradient|rgba)[^}]*?\}/g,
    (match) => {
      changed = true;
      return match
        .replace(/background:\s*[^;]+;/g, '')
        .replace(/border-radius:\s*\d+px;/g, '')
        .replace(/border:\s*1px\s+(solid|dashed)\s+rgba\([^)]+\);/g, '');
    }
  );

  // 5. Remove .plan card backgrounds (already partially handled)
  html = html.replace(
    /\.plan\s*\{[^}]*?background:[^}]*?rgba[^}]*?\}/g,
    (match) => {
      changed = true;
      return match.replace(/background:\s*[^;]+;/g, '')
        .replace(/border-radius:\s*\d+px;/g, '');
    }
  );

  // 6. Remove background from .plan.featured if still present
  html = html.replace(
    /\.(plan|tier)\.featured\s*\{[^}]*?background:[^}]*?\}/g,
    (match) => {
      changed = true;
      return match.replace(/background:\s*[^;]+;/g, '');
    }
  );

  // 7. Remove col-problem / col-solution item backgrounds
  html = html.replace(
    /\.col-(?:problem|solution)\s*\.col-item\s*\{[^}]*?background:[^}]*?\}/g,
    (match) => {
      changed = true;
      return match.replace(/background:\s*[^;]+;/g, '');
    }
  );

  if (html !== original) {
    fs.writeFileSync(filePath, html, 'utf8');
    return true;
  }
  return false;
}

for (const dir of dirs) {
  const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));
  for (const f of files) {
    if (cleanFile(path.join(dir, f))) {
      console.log('  Fixed: ' + f);
    }
  }
}

console.log('Done.');
