# Local Business Lead Generation

For offerings targeting micro businesses (1–9 staff) or local businesses (cafes, restaurants, hairdressers, retail shops, bakeries, etc.) that may need website work. Use this playbook instead of developer/website scanning modes.

## Rationale

Micro businesses rarely post about website problems online. The highest-intent signals are:

1. **Recent ownership change** — new owners inherit someone else's tech and are far more likely to want updates, new sites, security audits, or plugin maintenance than established owners who've been "fine with what they have" for years.
2. **New business opening** — new venues often launch with a basic Facebook page or rushed WordPress site that needs upgrading once they find their feet. The first 3–6 months is the window.
3. **Rebrand / relocation** — businesses that have rebranded or moved locations almost always need website changes to match.

All three signals can be found through the same news sources — hospitality/retail press covers new openings, ownership changes, and relaunches equally.

## Lead Sources (ranked by quality)

| Source | Description | Quality |
|--------|-------------|---------|
| **Hospitality news sites** (perthisok.com, soperth.com.au, broadsheet.com.au) | Cover new openings, reopenings, ownership changes, rebrands | ★★★ Best — confirmed new owners with named contacts |
| **Business broker listings** (benchmarkbusiness.com.au, platinumbusiness.com.au) | "Under Offer", "Recently Sold", "New Management" filters | ★★☆ Good — may be pending sale, not yet closed |
| **Local news** (perthnow.com.au, community papers) | Retirement sales, closures, "under new management" announcements | ★★★ Best for local micro businesses |
| **Google Maps / Reviews** | Search "new owners" / "under new management" in recent reviews | ★★☆ Manual but catches small changes |
| **Social media** (Instagram/Facebook posts) | Posts announcing "we've taken over", "new chapter", "new management" | ★★☆ Requires manual scanning |

## Search Query Templates

For hospitality news sites (perthisok.com, soperth.com.au):
```
"new owner" "Perth" cafe 2026
"under new management" Perth restaurant 2026
"sold" "new owners" Perth cafe 2026
```
For new openings:
```
"opens" OR "opening" OR "just opened" Perth cafe restaurant bakery 2026
"grand opening" Perth cafe salon 2026
```
For rebrands / relocations:
```
"rebrand" OR "new location" OR "relaunch" Perth cafe salon restaurant 2026
```

For business broker sites:
```
site:benchmarkbusiness.com.au "under offer" cafe Perth 2026
site:platinumbusiness.com.au "under offer" Perth 2026
```

For Google review signals:
```
"new owners" "Perth" cafe site:google.com
```

## Lead Evaluation Criteria

Score each lead on:

1. **Ownership confirmed** (+5 for confirmed sale/article/new opening with named owners, +2 for "under offer"/broker listing/unconfirmed signals)
2. **Size** (+2 for micro 1–9, +1 for small 10–39, -3 for 40+)
3. **Current website quality** — Use the following tiered scoring:
   - **+5: No web presence at all** — none of the multi-source sweep checks returned anything usable. This is the strongest possible need signal.
   - **+5: Broken/404** — a URL exists but returns 404, 500, timeout, or blank page. The business has a site they can't use — strong need signal.
   - **0: Third-party platform only** — the only web presence is a platform-hosted page (TuckerFox, onlinedining, Uber Eats, Menulog, Mr Yum, etc.). Neutral — they may feel it's sufficient, but it's also an opportunity to upgrade them to something they control. Note the platform name in the lead.
   - **+1: Outdated standalone site** — has a custom domain and dedicated site, but it's clearly outdated (old copyright, broken features, non-responsive, stale content)
   - **-2: Modern or recently redesigned** — verified current, well-maintained site

4. **Industry fit** (matches the offering's target sector)
5. **Recency** (+2 if changed hands <3 months ago, +1 if <6 months)

### Lead Profile Format (Reporting)

When presenting leads, include a **Web Presence Type** field with one of these values:

| Label | Meaning |
|-------|---------|
| **None** | No web presence found across all 6 sweep sources |
| **Broken** | URL exists but doesn't load (404/500/timeout) |
| **Third-party only** | Only platform-hosted page (TuckerFox, onlinedining, Uber Eats, etc.) — no dedicated domain, no branding control, no SEO value. Flag with ⚠️ in reports. |
| **Outdated standalone** | Custom domain site that's stale/broken/old |
| **Modern** | Verified current, well-maintained site |

The Web Presence Type should appear in each lead's summary line, e.g.:

```
| 4 | Bayside Fish Shack | 10 | Ownership change, ⚠️ third-party only (TuckerFox), phone |
```

### Outreach Angle — Third-Party Platform Leads

When a lead's only web presence is a third-party platform page (TuckerFox, onlinedining, etc.), use this angle:

> "Right now your only online presence is a [platform name] listing — you can't control the brand, you're stuck with their template, and Google sends customers to your competitors because there's no dedicated site. I can fix that with a simple site you actually own — $500, live in 48 hours."

This is a stronger pitch than "you have no website" (which implies starting from zero) — instead frame it as: "you have a weak presence that you don't control, and you're losing customers because of it."

### Social Media Verification Step

MANDATORY for Instagram, Facebook, TikTok, or any social account. Before adding a social handle to a lead profile, you MUST verify it belongs to the actual business. Social platforms surface similarly-named accounts from other suburbs, brands, or unrelated entities.

Follow these steps in order:

1. **Confirm the handle matches the business**
   - Search the exact handle on the platform
   - Cross-check the profile name, bio, location, and recent posts
   - If the account is for a different business, suburb, or brand → reject

2. **Check follower count and activity**
   - Genuine business accounts typically have consistent posting history
   - Follower count should align with a local/micro business (not a major chain unless that's the target)
   - If the account is inactive or clearly abandoned → note but do not discard

3. **Check for duplicate/confusing accounts**
   - Search for handles with similar names (e.g. `@bertscoffeebar` vs `@bertscitybeach`)
   - Search for handles with the same name but different locations (e.g. `Kalahari` in Clarkson vs Willetton)
   - If multiple accounts exist, identify which one matches the target business and explicitly note the others in the lead profile as "NOT this venue"
   - Use the account with the highest follower count only if it matches the business location and name

4. **Check bio for location and contact info**
   - The bio should mention the suburb, address, or a phone number matching the business
   - If the bio is vague or points to a different location → reject

5. **Verify ownership if possible**
   - Look for "verified" badges, posts announcing ownership changes, or comments from named owners
   - If ownership cannot be confirmed → score accordingly but do not invent contacts

### Website Detection — Multi-Source Sweep (Before Verification)

IMPORTANT: Do not score a lead as "no website" until you have performed a multi-source sweep. Single-source misses are the #1 failure mode. A business may have an online presence that is NOT a standalone domain — ordering platform pages, directory listings, and subdomain-hosted sites are common for micro businesses.

Run ALL of the following checks. Only mark "no website" if every check returns nothing.

1. **Standalone domain search (3 query variants):**
   - `"[business name]" "[suburb]" WA`
   - `"[business name]" "[suburb]" site:com.au`
   - `"[business name]" website OR site OR "online ordering"`

2. **Ordering platform check (hospitality businesses only):**
   Search each of these platforms with the business name and suburb:
   - `site:tuckerfox.com.au "[business name]" "[suburb]"` — hosted ordering sites on subdomains
   - `site:onlinedining.com.au "[business name]" "[suburb]"` — directory pages with menus
   - `site:hungryfoody.com.au "[business name]"` — ordering/menu platform
   - `site:agfg.com.au "[business name]"` — restaurant directory
   - `site:menulog.com.au "[business name]" "[suburb]"` — delivery platform
   - `site:ubereats.com "[business name]" "[suburb]"` — delivery platform
   - `site:mryum.com "[business name]"` — QR ordering platform
   - `site:klikit.com.au "[business name]"` — ordering platform

   These platforms serve as de facto websites for many micro hospitality businesses. A business that has a TuckerFox or onlinedining.com.au page with menu, hours, and contact info DOES have a web presence — score as an inherited/third-party site, not "no site."

3. **ABN Lookup cross-reference:**
   - Search: `"[business name]" "[suburb]" site:abr.business.gov.au`
   - If an ABN is found, the registered business name and address may help disambiguate from similarly-named businesses in other suburbs.

4. **Google Maps entry check:**
   - Search: `"[business name]" "[suburb]" site:google.com/maps`
   - Google Maps entries often have a "Website" field — if a URL is listed, visit and verify
   - If NO URL is listed in Google Maps BUT steps 1–3 found a presence → note "Google Maps missing website link — opportunity" but do not score as "no site"

5. **Social media as sole presence:**
   - If the business ONLY has Instagram/Facebook and NONE of steps 1–4 returned anything → score +2 for "no website"
   - If ANY of steps 1–4 returned a usable page (menu, hours, contact, ordering) → score as inherited/neglected site (+1 for outdated/poor quality)

6. **Cross-reference all findings:**
   - Compare business name, address, phone across all sources
   - If multiple sources exist but the business name/owner differs → flag ownership change opportunity
   - If the only web presence is a third-party platform page (TuckerFox, onlinedining, etc.) with no ability to update branding or content → note as "locked-in third-party site — migration opportunity"

### Website Verification Step

MANDATORY. Before scoring website quality (+2/+1/-1/-2), you MUST verify any URL found through the multi-source sweep. Never score a site without loading it first.

Follow these steps in order:

1. **Confirm the URL belongs to the actual business**
   - `vans.com.au` is a fashion brand, not Vans Cafe Cottesloe → reject
   - `vanscafe.com.au` IS the correct cafe → proceed
   - Cross-check address, phone, or business name against site content

2. **Check if the site actually loads**
   - Use the available web fetch/visit tool
   - If it returns a 404, 500, timeout, or blank/error page → mark as **broken site**
   - If the site does not load at all → score +2 for "broken/no website"

3. **Check HTTPS/SSL**
   - If no HTTPS or certificate warning → mark as security issue

4. **Check mobile responsiveness**
   - Look for viewport meta tag, responsive CSS, or actual mobile layout issues
   - If mobile layout is broken, elements overflow, or ordering features are hidden/disabled → note explicitly

5. **Check for broken/disabled features**
   - Online ordering buttons that lead nowhere
   - Menu links that return 404
   - Contact forms with no action

6. **Check copyright year**
   - In footer: if it's 3+ years behind current year → +2 bonus
   - If it matches current year → skip (not enough info alone to apply -5 penalty unless there's a site redesign credit)

7. **Check WordPress version (if applicable)**
   - Look for `?ver=` in scripts, generator meta, or readme.html
   - Compare against actual latest version from wordpress.org
   - If behind by major version → +2
   - Only apply -5 for "latest WP version" if you have verified it's actually the latest release AND site is well-maintained

8. **Check redesign signals**
   - Footer credits: "Site by [agency]", "Designed by", "Built with"
   - Recent blog posts about relaunch
   - If redesign is confirmed → apply -3 to -5 penalty
   - **Do not apply -5 for copyright year alone** — that is not a redesign signal

9. **Check for large-operator indicators**
   - If the site mentions "part of the X Group" or shows >1 location with the same branding → apply -3 penalty for large operator

### Disqualification Rules

**Recent redesign/refresh** — If the website shows clear indicators of a very recent redesign, the lead should be deprioritised or excluded entirely:

| Indicator | Penalty |
|-----------|---------|
| Copyright year matches current year (e.g. "2026") AND there's a site redesign credit | -5 combined |
| Recent blog/news post about a site relaunch or redesign | -5 |
| "Site redesigned by [agency]" credits in footer | -3 |
| Modern, polished design verified via live check | -2 |
| Latest WordPress version + active theme updates verified | -5 |

**Negative score elimination:** Any lead with a final total score below 0 must be removed from the outreach list entirely. Do not include zero- or negative-score leads in the draft file.

### Priority Boost Rules

Certain indicators suggest the site is neglected or mismanaged — these increase the likelihood the owner needs help:

| Indicator | Bonus |
|-----------|-------|
| Broken site (does not load, 404, blank, error) | +3 |
| No HTTPS or certificate warning | +3 |
| Very old WordPress version (major version behind current, verified) | +2 |
| Mobile broken / responsive issues | +2 |
| Copyright year is 3+ years behind current year (verified) | +2 |
| Outdated contact details, owner name, or address on the website | +5 |
| Online ordering or booking features broken/disabled | +1 |

## Recommended Outreach Angles

### For ownership changes

```
"Hey [name] — saw you recently took over [business]. Congrats! 
When you inherit a business, the website often isn't what you'd 
want it to be — outdated plugins, security gaps, slow pages. 
I help new owners get the online presence sorted so it matches 
the quality of what you're doing in the shop. Keen to chat?"
```

- Lead with **congratulations** first, pitch second
- Reference the pain of inheriting someone else's website decisions
- Offer a **free quick audit** (security scan, performance check) — no obligation
- Keep it short and peer-to-peer

### For new business openings

```
"Hey [name] — congrats on opening [business]. [Suburb] needed a spot like this.
New venue, new website — or at least one that matches the vibe. 
If you need a hand, I build clean, fast sites for [type of business]
— menu, location, online ordering, the works. 
Happy to look at what you've got and suggest what's worth doing."
```

- Lead with **congratulations** and a specific compliment about their venue
- New businesses often launch with Instagram-only or a rushed site — reference that
- Offer a **free once-over** of whatever they currently have
- No pressure — they're still settling in

### For rebrands / relocations

```
"Hey [name] — congrats on the rebrand/new location. [Specific detail about change] looks great.
If the website needs updating to match the new direction, 
I build clean, fast sites for [type of business]. 
Happy to do a quick audit and give you my honest take."
```

## When to Use

Trigger this mode when the selected offering:
- Targets local/micro businesses (cafes, restaurants, hair salons, retail, bakeries, trades)
- Is about websites (security audits, maintenance, rebuilds, SEO, plugins)
- Keywords in idea file include: "website", "WordPress", "small business", "local business", "SMB", "micro"
