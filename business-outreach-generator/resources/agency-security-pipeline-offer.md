# Agency Security Pipeline — Outreach Template

This resource contains the reusable outreach templates for the Agency Security Pipeline offering. It is loaded by `Skill.md` when the selected offering is "Agency Security Pipeline".

---

## Offering Overview

**What it is:** A managed, white-label CI/CD security pipeline delivered as a SaaS platform to web agencies. It continuously monitors all of an agency's client sites for security vulnerabilities, dependency staleness, and CMS/plugin CVEs — and applies updates through a sandboxed staging environment with automated smoke tests and instant production rollback.

**Target buyer:** Web agencies (5–50 staff) managing 10+ client sites on a shared CMS stack (WordPress, Winter CMS, October CMS, Craft CMS, etc.). Owner-operated or small-team agencies where developers are focused on building new client work, not maintaining existing sites.

**Commercial model:** Currently in beta development. Beta partners get the pipeline built and configured on their infrastructure at a heavily discounted rate in exchange for real-world feedback. Post-beta pricing: monthly SaaS licence per agency (not per site).

**Core value proposition:** Agencies stop updating client sites because they fear breaking production. This pipeline eliminates that fear — every update is validated in a sandbox clone with smoke tests and automated rollback before it touches production. The agency gets a white-label security score dashboard they can share with clients as a value-add.

**Beta framing:** Never present this as a finished product. Position it as: *"I'm building this and looking for a small number of agencies to build it with — you get it configured on your actual infrastructure at a discounted rate, and your feedback shapes the product."* This is more compelling than selling an unproven tool off the shelf, and it sets honest expectations.

---

## Research Instructions (Executed Before Template Population)

Before populating any template, perform the following steps **in order**. Steps 1–4 are mandatory. Step 5 is conditional.

---

### Step 1 — Identify the Agency Decision Maker

1. **Visit the agency's Team or About page** and identify:
   - The owner, managing director, or founder (primary target — they care about client retention and liability)
   - The lead/senior developer (secondary target — they feel the pain of manual updates and breakage risk)
   - Avoid targeting junior developers or project coordinators

2. **Capture:**
   - Owner/MD name and title
   - Lead developer name if visible
   - Staff count (visible on team page or LinkedIn)
   - Number of active client sites (estimate from portfolio page)

---

### Step 2 — Extract Client Site URLs from Portfolio Page

1. Fetch the agency's portfolio or "Our Work" page
2. Extract all external client site URLs listed — aim for 6–10 URLs
3. Exclude the agency's own domain, social media links, and non-website links
4. Prioritise URLs that look like small business client sites (hospitality, services, trades, retail)

---

### Step 3 — Run the Portfolio Scanner

Run the following Python script against the extracted client URLs **plus the agency's own homepage**. This is a single passive sweep — one HTTP request per site, 3-second pauses between requests.

```python
import subprocess, re, time, datetime

def scan(label, url):
    subprocess.run(
        ['curl','-s','--max-time','12',
         '-A','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36',
         '--compressed','-D','/tmp/h.txt','-o','/tmp/b.html', url],
        capture_output=True)
    try:
        hdrs = open('/tmp/h.txt').read()
        body = open('/tmp/b.html').read()
    except: return
    hdrs_l = hdrs.lower()

    # CMS detection
    cms = 'Unknown'
    gen = re.search(r'<meta[^>]*generator[^>]*content=["\'][^"\'>]{1,80}', body, re.I)
    gen_val = re.search(r'content=["\']([^"\']+)', gen.group() if gen else '').group(1) if gen else ''
    if re.search(r'wp-content|wp-includes', body):   cms = 'WordPress'
    if re.search(r'winter-cms|wintercms|/modules/system|combine/[a-f0-9]+-[0-9]+\.js', body, re.I): cms = 'Winter CMS'
    if re.search(r'october-cms|octobercms', body, re.I): cms = 'October CMS'
    if re.search(r'laravel|livewire', body, re.I):   cms = 'Laravel'
    if re.search(r'drupal', body, re.I) or 'x-drupal' in hdrs_l: cms = 'Drupal'
    if re.search(r'squarespace', body, re.I):        cms = 'Squarespace'
    if re.search(r'webflow', body, re.I):             cms = 'Webflow'
    if 'pepyaka' in hdrs_l:                           cms = 'Wix'
    # Proprietary CMS detection — highest priority, overrides above
    prop = re.search(r'([A-Za-z0-9 ]+CMS version [0-9]+\.[0-9.]+)', gen_val, re.I)
    if prop: cms = f'PROPRIETARY: {prop.group(1)}'

    # PHP version
    php = re.search(r'(?i)x-powered-by:\s*(php/[^\r\n]+)', hdrs)
    php_val = php.group(1).strip() if php else '-'

    # EOL PHP check (7.4 and below = EOL)
    php_eol = ''
    php_ver = re.search(r'PHP/(\d+)\.(\d+)', php_val, re.I)
    if php_ver:
        major, minor = int(php_ver.group(1)), int(php_ver.group(2))
        if major < 8 or (major == 8 and minor < 1):
            php_eol = ' ⚠️ EOL'

    # Security headers
    waf  = '✅' if any(x in hdrs_l for x in ['cloudflare','sucuri','wordfence']) else '❌'
    csp  = '✅' if 'content-security-policy:' in hdrs_l else '❌'
    hsts = '✅' if 'strict-transport-security:' in hdrs_l else '❌'

    # Asset timestamp staleness
    now = time.time()
    hits = re.findall(r'(?:src|href)=["\'][^"\']*?([1-9][0-9]{9})[^"\']*?["\']', body)
    valid = sorted([int(h) for h in hits if 1500000000 < int(h) < now])
    ts_info = 'no-ts'
    if valid:
        t = valid[0]; age = int((now - t) / 2629800)
        d = datetime.datetime.fromtimestamp(t, datetime.UTC).strftime('%b %Y')
        flag = '🔴 CRITICAL' if age >= 6 else ('🟠 HIGH' if age >= 1 else '✅ OK')
        ts_info = f'{flag} {d} ({age}mo)'

    print(f'  {label}')
    print(f'    CMS     : {cms}{(" ["+gen_val[:50]+"]") if gen_val and "PROPRIETARY" not in cms else ""}')
    print(f'    PHP     : {php_val}{php_eol}')
    print(f'    WAF/CSP/HSTS: {waf}/{csp}/{hsts}')
    print(f'    Assets  : {ts_info}')
    print()

sites = [
    ('AGENCY OWN SITE', 'https://AGENCY_URL'),
    # Add client URLs below:
    ('Client 1 name',   'https://client1.com.au'),
    ('Client 2 name',   'https://client2.com.au'),
    # ...
]

for label, url in sites:
    scan(label, url)
    time.sleep(3)
```

**What to record from the output:**
- All CMS platforms in use (WordPress, Winter CMS, proprietary, etc.) — note if multiple platforms are in use
- Any **PROPRIETARY CMS** detection — see Step 4
- Any **EOL PHP** versions — flag immediately, PHP 7.4 and below receive zero security patches
- Asset staleness — note the oldest and average ages across client sites
- WAF/CSP/HSTS gaps — count how many sites are missing each header

**Early-exit rule:** If the agency's own site returns `server: cloudflare` or similar WAF header, skip medium/high-risk follow-up probes. The passive sweep above is sufficient for the pitch.

---

### Step 4 — Proprietary CMS Detection (Critical Pitch Angle)

If the scanner output shows `PROPRIETARY:` for any client site, this is the **strongest possible pitch signal**. Record:

- The CMS name and version (e.g. `ABWeb CMS version 1.5.0`)
- Which client sites run it
- Whether the agency's own website links to the CMS (e.g. in the generator tag URL)

**Why this matters:** A proprietary in-house CMS has:
- **No public CVE feed** — standard security scanners are blind to it
- **No community patches** — if the agency doesn't patch it, nothing ever does
- **No third-party tooling** that monitors it

This means the pipeline you're offering is the **only solution that covers it** — you're not competing with Wordfence, WPScan, or any off-the-shelf tool. Adjust the pitch to lead with this angle when detected.

**Proprietary CMS pitch angle:**
> *"A number of your client sites run your own in-house CMS. There's no public CVE feed for a proprietary platform — standard security scanners are completely blind to it. I can build a pipeline that monitors it alongside your WordPress and Winter CMS sites from a single dashboard."*

---

### Step 5 — Hosting Infrastructure Signals

From the `server:` header values collected in Step 3, assess deployment complexity:

| Signal | Implication |
|--------|-------------|
| `LiteSpeed` or `Apache` (multiple sites) | Likely shared/cPanel hosting — CI/CD hooks may be limited; flag as discovery call question |
| `nginx` consistently | VPS likely — good CI/CD signal |
| Mix of different servers per client | Heterogeneous hosting — higher pipeline complexity; mention in scoping |
| `cloudflare` on agency site but not client sites | WAF inconsistently applied — pitch the dashboard as fixing this gap |
| `PHP/7.4` or lower | EOL runtime — frame as an urgent compliance/liability issue separate from CMS patching |

---

### Step 6 — Quantify and Summarise Findings

Before generating outreach, produce a one-paragraph internal summary:

```
Agency: [Name]
Decision maker: [Name, title, phone if available]
Staff count: [N]
Portfolio size: ~[N] client sites
CMS mix: [e.g. 60% proprietary ABWeb CMS, 30% WordPress, 10% Winter CMS]
Oldest asset timestamp: [Month Year] ([N] months)
Average asset age across scanned sites: [N] months
EOL PHP detected: [Yes/No — version, site(s)]
Sites missing CSP: [N/N scanned]
Sites missing HSTS: [N/N scanned]
Key pitch angle: [Proprietary CMS / Stale WordPress / EOL PHP / header gaps]
```

Use the numbers from this summary to populate the template placeholders. Concrete figures are far more persuasive than generic security claims.

---

### Step 7 — Localise Spelling and Phrasing

Match spelling to `{{COUNTRY}}`:
- Australia / UK: "localise", "organisation", "behaviour", "colour", "programme", "licence"
- United States: "localize", "organization", "behavior", "color", "program", "license"

---

## Email Template

**Subject line options (choose one based on scan findings):**
- `[Agency Name]'s client sites — security findings worth a look`
- `Found something on your client portfolio worth flagging`
- `[CMS] update risk across your client sites — quick question`

---

**Body:**

Hi {{OWNER_FIRST_NAME}},

I had a look at a few of the sites {{AGENCY_NAME}} has built — specifically {{CLIENT_SITE_1}} and {{CLIENT_SITE_2}}.

Both are running assets that were last deployed in {{ASSET_FREEZE_DATE}} — around {{STALENESS_MONTHS}} months ago. The jQuery version served has {{CVE_COUNT}} known CVEs at that version, and neither site has a Content Security Policy header, which means any XSS vulnerability in the page builder or a CDN script has no browser-side mitigation.

I'm not raising this to be critical — it's a systematic problem across most agency portfolios. The reason sites don't get updated isn't skill, it's risk: no-one wants to push a CMS update and watch a client's site go white-screen on a Tuesday afternoon.

I'm building a pipeline that takes that risk off the table. Every update — whether it's {{CMS_LIST}} — runs through a sandboxed clone of the production site first. Automated smoke tests validate the result, and if anything breaks, it never reaches production. If something slips through post-deploy, production rolls back in under 30 seconds.

I'm currently looking for a small number of beta partners to build this with. The arrangement is simple: you get the pipeline configured on your actual infrastructure at a heavily discounted rate, and your feedback shapes how it develops. You'd be building something around your specific stack rather than taking something generic off the shelf.

Happy to walk you through what I found on the scan if that's useful — worth a quick call this week?

**Note for {{CMS_LIST}} placeholder:** Populate with the CMS platforms confirmed in Research Step 3, not assumed. Examples:
- ABWeb CMS + Winter CMS only → "your own ABWeb CMS and Winter CMS"
- WordPress + Winter CMS → "WordPress and Winter CMS"
- ABWeb CMS + WordPress + Winter CMS → "your own ABWeb CMS, WordPress, and Winter CMS"
Do not include WordPress unless it was confirmed in the scan.

{{YOUR_NAME}}

---

## Phone Brief

**Call objective:** Get a 20-minute discovery call booked. Do not pitch the full product on a cold call — surface the problem, establish credibility with the scan findings, and ask for a meeting.

**Opening (15 seconds):**
> "Hi, is that {{OWNER_FIRST_NAME}}? My name's {{YOUR_NAME}} — I'm a developer based in {{YOUR_CITY}}. I had a look at a few of the sites {{AGENCY_NAME}} has built and I found something worth flagging — do you have two minutes?"

**If yes — the hook (30 seconds):**

*Use the variant that matches the primary finding from Research Step 3. Only reference CMS platforms that were actually confirmed in the scan — do not assume WordPress is in the mix if it wasn't found.*

**If proprietary CMS detected:**
> "I had a look at a few of your client sites — some of them are running your own in-house CMS. The issue is there's no public CVE feed for a proprietary platform, so standard security scanners are completely blind to it. On top of that, the asset pipelines on those sites haven't been updated in around {{STALENESS_MONTHS}} months. I'm not raising this to be critical — it's a systematic problem and there's a specific reason agencies don't update: the risk of breaking a client's site in production."

**If EOL PHP detected:**
> "I scanned {{CLIENT_SITE_1}} and it's running PHP {{PHP_VERSION}}, which stopped receiving security patches in {{PHP_EOL_DATE}}. Every PHP vulnerability discovered since then applies to that server with no fix available. Combined with assets that haven't been updated in {{STALENESS_MONTHS}} months, there's a meaningful window of exposure there."

**If Winter CMS / WordPress with stale assets (default — only if proprietary CMS not found):**
> "I scanned {{CLIENT_SITE_1}} and {{CLIENT_SITE_2}} — both are running assets last deployed around {{STALENESS_MONTHS}} months ago. The jQuery version served has known XSS vulnerabilities, and there's no Content Security Policy on either site. I'm not saying this to cause concern — it's the same picture across almost every agency portfolio I look at. The problem is that updating client sites is genuinely risky without the right tooling."

**The pivot (20 seconds):**
> "I'm building a pipeline that takes the risk out of it — sandboxed staging, automated smoke tests, instant rollback if anything breaks. I'm looking for a small number of agencies to build it with as beta partners — you'd get it set up on your infrastructure at a discounted rate, and your feedback shapes how it develops. I'd like to show you what I found on your portfolio specifically — would a 20-minute call this week work?"

**Common objections:**

| Objection | Response |
|-----------|----------|
| "Our developers can handle updates" | "Absolutely — and I'm sure they could build this too, but it'd pull them off billable work for months. As a beta partner you'd get it done at a fraction of that cost and keep your team on billable work." |
| "We don't have budget for this right now" | "The pilot is a fixed price, and it's designed to prove value before you commit to anything ongoing. What would make it worth 20 minutes to see the numbers?" |
| "We already do security checks" | "That's great — what does your current process look like for client site updates? I'm curious whether what I'm building would complement it or overlap." |
| "Send me an email" | "Happy to — who should I address it to, and is this the best email for you?" |

**Agency Scan Summary (have this ready):**
Prepare a 3-line summary from the Research Instructions Step 6 output. Use the most impactful findings in priority order:
1. **Proprietary CMS (if found):** "[N] of your client sites run your own in-house CMS — no public CVE feed exists for it, standard scanners are blind"
2. **EOL PHP (if found):** "{{CLIENT_SITE_1}} is running PHP {{PHP_VERSION}} — end-of-life since {{PHP_EOL_DATE}}, no security patches since then"
3. **Asset staleness:** "{{CLIENT_SITE_1}} assets last deployed {{STALENESS_MONTHS}} months ago"
4. **Header gap:** "No Content-Security-Policy on any scanned client site"

Use the top 2–3 that apply. If proprietary CMS is detected, always lead with that.

---

## Qualifying Signals (prioritise these leads)

- Agency manages 10+ active client sites on a shared CMS stack
- Portfolio page shows client sites — confirms they build and host, not just design
- Agency's own site shows stale assets or security header gaps (credibility angle)
- Owner/MD is named and reachable (small agency, direct decision maker)
- CMS is WordPress, Winter CMS, October CMS, Craft CMS, or similar plugin-based platform
- No mention of a dedicated DevOps or security engineer on the team page
- LinkedIn headcount 3–30 people

---

## Disqualifying Signals (skip or deprioritise)

- Agency explicitly markets security or DevSecOps as a core service — they already have this covered
- Agency is a large digital conglomerate (100+ staff, dedicated infrastructure team)
- Agency builds only on fully managed SaaS platforms (Squarespace, Webflow, Shopify) — no self-hosted CMS, no patching surface
- Agency has no portfolio page or client site evidence — can't validate the problem
- Business requires security clearance, a government security pass, or site induction/pass for contractors — see Universal Lead Disqualifiers in `Skill.md`
- Business is clearly based outside the target city/region `{{CITY}}` — see Universal Lead Disqualifiers in `Skill.md`

---

## Pilot Proposal Structure

When a discovery call is booked, structure the pilot proposal as follows:

**Pilot scope:** 3 client sites (agency selects them — ideally one simple, one medium, one complex)

**Pilot deliverables:**
1. Sandboxed staging clone of each site
2. Automated smoke test suite (homepage load, key page load, form render, checkout if applicable)
3. One full update cycle run through the pipeline (CMS core + plugins)
4. Rollback demonstration
5. White-label security dashboard showing all 3 sites

**Beta pilot pricing:** AUD $3,000–$5,000 fixed (adjust for market). Frame explicitly as beta pricing — *"this is what I charge to build and configure it on your infrastructure during the beta phase; once it's live and proven, ongoing pricing is based on portfolio size."* If it doesn't work on their infrastructure, they've paid for a clear answer, not an open-ended engagement.

**Rollout pricing (post-pilot):** Monthly SaaS licence based on site count:
- Up to 20 sites: AUD $600–$800/month
- 21–50 sites: AUD $1,000–$1,500/month
- 51+ sites: Custom pricing

**White-label client report add-on:** AUD $100–$200/month extra — branded PDF/email report the agency sends to clients monthly showing security score, last update, active CVEs.
