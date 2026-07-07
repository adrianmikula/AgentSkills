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

1. **Ownership confirmed** (+3 for confirmed sale/article, +1 for "under offer"/broker listing)
2. **Size** (+2 for micro 1–9, +1 for small 10–39, -3 for 40+)
3. **Current website quality** (+2 if no website or broken, +1 if outdated, -2 if modern or recent redesign)
4. **Industry fit** (matches the offering's target sector)
5. **Recency** (+2 if changed hands <3 months ago, +1 if <6 months)

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

### Website Verification Step

MANDATORY. Before scoring website quality (+2/+1/-1/-2), you MUST verify any URL found for the business. Never score a site without loading it first.

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
