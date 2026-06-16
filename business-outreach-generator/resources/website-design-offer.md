# Website Design — Outreach Template

This resource contains the reusable outreach templates for the Website Design offering. It is loaded by `Skill.md` when the selected offering is "Website Design".

---

## Research Instructions (Executed Before Template Population)

Before populating either template, perform the following research steps:

 1. **Search for businesses in `{{CITY}}` operating in `{{INDUSTRY}}` that have no website, an outdated website, or only a social media page.** Use:
    - Google Maps / local business directories to find business names and categories
    - Visit any listed website URLs to confirm whether they exist, are outdated, or are missing
    - Search: `"{{CITY}}" "{{INDUSTRY}}" no website OR facebook page OR "coming soon"` to find businesses without an active web presence
    - Search: `"{{CITY}}" "{{INDUSTRY}}" site:facebook.com` — businesses running purely on social media
    - Search: `"{{CITY}}" "{{INDUSTRY}}" site:google.com/maps` — cross-reference with website links

 2. **Detect recent name changes or ownership changes** by cross-referencing multiple sources:
    - Compare business names on Google Maps, Facebook, ABN Lookup, and directory listings — mismatches may signal a recent rebrand or new owner
    - Search: `"{{CITY}}" "{{INDUSTRY}}" "formerly known as" OR "previously" OR "under new management" OR "rebranded"` — catches name-change signals
    - Search: `"{{CITY}}" "{{INDUSTRY}}" "under new management" OR "new owners" OR "now open under"` — catches ownership-change signals
    - Search Google Maps reviews for phrases like "since the new owners", "used to be", "name changed from", "since the takeover" — reviews are a strong signal of recent handover
    - Search: `"{{CITY}}" "{{INDUSTRY}}" business sale OR "sold" OR "new ownership" [current year]` — business sale listings
    - Check ABN Lookup (`https://abn.business.gov.au/`) for changes in business name or entity registration dates
    - Compare historical Google Street View or Google Maps imagery for changed storefront signs (note as "Check visually — street view recommended")
    - For social-media-only businesses, check Facebook page creation date and historical page name changes (visible in Page Info → Page History if available)

 3. **Select 3–5 candidate businesses** that clearly illustrate:
    - No website at all (only social media or Google Maps listing)
    - Website is clearly outdated (copyright year 2022 or earlier, broken layout, non-responsive)
    - Website is a basic single-page site that doesn't represent the business well
    - Business recently changed name or ownership (a new owner almost always needs a fresh website for their brand)
    - Business is actively trading and appears to have customer demand

 4. **Verify the business is in the target location** using Google Maps, ABN Lookup, or directory listings.

 5. **Localise spelling and phrasing** to match `{{COUNTRY}}`:
    - Australia / UK: "localise", "programme", "organisation", "centre", "analyse", "behaviour", "colour", "favour", "neighbour".
    - United States: "localize", "program", "organization", "center", "analyze", "behavior", "color", "favor", "neighbor".

 6. **Determine pricing tier** based on the target's needs:
    - **Brochure Site (Tier 1):** Clean, mobile-responsive, 3–5 page site with contact form, Google Maps integration, social links. Best for cafes, restaurants, tradies, local services.
    - **Business Site (Tier 2):** Full multi-page site with blog, gallery, testimonials, booking or enquiry system. Best for professional services, retail, growing businesses.
    - **eCommerce Site (Tier 3):** Full online store with product catalogue, cart, checkout, payment gateway. Best for retail, food delivery, product-based businesses.

 7. **Adjust tone for `{{BUSINESS_SIZE}}`**:
    - **Micro:** Very personal, direct, empathetic. Acknowledge tight budgets. Emphasise ROI of having a website.
    - **Small:** Friendly peer-to-peer. Discuss competitive disadvantage of not having a website.
    - **Medium:** Professional approach. Highlight brand credibility, customer expectations, and digital transformation.

---

## Email Template

```
Subject: A thought about {{COMPANY_NAME}}'s online presence

Hi [First Name],

I was looking at {{INDUSTRY}} businesses in {{CITY}} recently and came across {{COMPANY_NAME}}. I noticed you don't currently have a website — or at least not one that's easy to find online.

In 2026, most customers start their search for local {{INDUSTRY}} businesses online. When they can't find a website, they often move to the next option. Having a modern, mobile-friendly website isn't just about looking professional — it's about making sure customers can actually find you.

Here's what I'm thinking:

- **Tier 1 — Brochure Site:** A clean, responsive 3–5 page site with your menu/services, contact form, location map, and social links. Perfect for getting started.
- **Tier 2 — Business Site:** Full multi-page site with blog, photo gallery, customer reviews, and online booking or enquiry forms. Great for growing businesses.
- **Tier 3 — eCommerce Site:** Complete online store with product catalogue, shopping cart, and secure checkout. Ideal if you want to take orders or bookings online.

Every site is built mobile-first, optimised for search engines, and designed to grow with your business. I can also set up social media accounts, handle security patching, and provide ongoing content updates.

I'd love to show you some examples of {{INDUSTRY}} websites we've built and talk about what might work for {{COMPANY_NAME}}. No pressure, no obligation — just a chat.

Worth a quick coffee or call?

Best regards,

[Your Name]
[Your Title]
[Your Company]
[Website] | [Email] | [Phone]
```

---

## LinkedIn Message Template

```
Hi [First Name],

I was checking out {{INDUSTRY}} businesses in {{CITY}} and noticed {{COMPANY_NAME}} doesn't have a website yet.

Most customers these days search online before choosing a local business. Without a site, you could be missing out on a lot of foot traffic (or calls).

I build modern, mobile-friendly websites for {{INDUSTRY}} businesses — from simple brochure sites to full online stores. All built to be fast, search-friendly, and easy to update.

Would you be open to a quick chat about what a website could do for {{COMPANY_NAME}}? Happy to show you some examples.

Cheers,
[Your Name]
```

---

## Phone Research Brief

When `Output format == "Phone"`, do not generate a scripted conversation. Instead, produce a concise dot-point research brief the caller can reference during a real call.

### Research Steps (Before Generating the Brief)

 1. **Search for the business** in Google Maps, local directories, and social media to confirm:
    - No website exists, or existing website is outdated/poor
    - Business is actively trading
    - Location matches `{{CITY}}` and suburbs

 2. **Check for recent name or ownership changes:**
    - Compare business name across Google Maps, Facebook, ABN Lookup, and directories for mismatches
    - Search reviews for phrases like "since the new owners", "used to be", "name changed from"
    - Check Facebook page for "Page History" or date created vs when it became active
    - Search: `"{{COMPANY_NAME}}" "formerly" OR "under new management"` — direct evidence of recent change
    - If a recent change is detected, note it in the brief — new owners are a warm lead because they're likely still setting up and open to building a brand-aligned website

 3. **Check social media presence** (Facebook, Instagram) to understand:
    - How active they are online
    - Customer engagement and reviews
    - Whether they're posting menu items, specials, events, etc.

 4. **Look up reviews** (Google Reviews, Yelp, TripAdvisor) to understand:
    - Customer sentiment
    - Common complaints or praise
    - Any mentions of "wish they had a website" or "can't find their menu online"

### Brief Format

```
**Phone Research Brief — {{COMPANY_NAME}}**

- **Company:** [name], {{BUSINESS_SIZE}}, {{CITY}}, {{COUNTRY}}
- **Industry:** {{INDUSTRY}} [add specifics, e.g. "Italian restaurant in Ellenbrook"]
- **Current Online Presence:** [None / Facebook only / Outdated site at [URL] / Instagram page]
- **Recent Changes:** [Name change / New ownership / Rebrand / None detected — if recent change found, note date and specifics, e.g. "Rebranded from 'Old Name Cafe' in March 2026 under new owner"]
- **Social Media:** [Platforms used, follower count range, posting frequency]
- **Estimated Monthly Search Volume:** [e.g. "likely 200–500 searches/month for '{{INDUSTRY}} {{CITY}}'"]
- **Competitor Note:** [e.g. "3 other {{INDUSTRY}} businesses in the area have websites"]
- **Suggested Tier:**
  - [Tier 1: Brochure — if they just need a basic presence]
  - [Tier 2: Business — if they need blog, gallery, booking, reviews]
  - [Tier 3: eCommerce — if they sell products or take online orders]
- **Suggested Add-Ons:** [Social account setup / Security patching / Content updates / SEO optimisation]
- **Leading Questions:**
  1. "How do customers usually find you — word of mouth, Google, or social media?"
  2. "Have you ever thought about getting a website, or has it just not been a priority yet?"
  3. "If a customer searches for '{{INDUSTRY}} {{CITY}}' on Google right now, what comes up?"
```

### Tone Guidance for the Call

- Friendly, casual, consultative — you're offering to help them get found online
- Focus on the missed opportunity, not the lack of a site
- Use local examples: "I noticed [competitor name] has a site and it ranks well for '[INDUSTRY] [CITY]'"
- If the business recently changed name or ownership, lead with that: "I saw you've recently taken over [business name] — congratulations! A fresh website is a great way to signal the new chapter to customers."
- Low pressure: offer a no-obligation chat over coffee or a quick call
- Mention that a basic site can be up in a week and doesn't have to be expensive

---

## Website Security Social Scanning — Offering-Specific Signals

When Website Security Social Scanning Mode is triggered for this offering, load `resources/developer-social-scanning.md` for the shared scanning framework (platform strategy, geo-filtering, scoring, output format, and handoff). The definitions below are the offering-specific inputs that the shared resource requires.

> **Scan target for this offering:** Small businesses in `{{CITY}}` operating in `{{INDUSTRY}}` with no detectable website or an outdated/poor-quality website. The goal is to find businesses losing customers because they have no digital storefront.

---

### Platform Query Variants

Supply these query variants to the shared resource's Step 2 platform searches.

#### Priority 1 — Business Directories and Google Maps (highest yield for this offering)

Business directories and Google Maps list businesses by category and location, often including website links (or the lack thereof). This is the fastest way to find businesses without an online presence.

**Google Maps leads:**
- Search: `site:google.com/maps "{{CITY}}" "{{INDUSTRY}}"` — browse results; businesses without website links in their Google Maps entry are prime candidates
- For each result, note: business name, address, phone, reviews, whether a website URL is listed

**Australian business directories:**
- Search: `"{{CITY}}" "{{INDUSTRY}}" site:yellowpages.com.au` — Yellow Pages listings
- Search: `"{{CITY}}" "{{INDUSTRY}}" site:truelocal.com.au` — True Local listings
- Search: `"{{CITY}}" "{{INDUSTRY}}" site:hotfrog.com.au` — Hotfrog business directory

> **Note:** Some directories return 403 Forbidden to AI reads (confirmed for Yellow Pages and True Local). In that case, fall back to Google Maps and general web search.

**General web search for un-webified businesses:**
- Search: `"{{CITY}}" "{{INDUSTRY}}" -site:*.com -site:*.com.au` — narrows to businesses without a `.com` or `.com.au` domain
- Search: `"{{CITY}}" "{{INDUSTRY}}" facebook page no website` — finds businesses running purely on Facebook
- Search: `"{{CITY}}" "{{INDUSTRY}}" instagram only` — social-media-only businesses
- Search: `best "{{INDUSTRY}}" in "{{CITY}}" 2025 2026` — local "best of" listicles mentioning businesses; visit each to check for a website

**Name-change and ownership-change detection:**
- Search: `"{{CITY}}" "{{INDUSTRY}}" "formerly known as" OR "previously"` — finds businesses that have rebranded or been renamed
- Search: `"{{CITY}}" "{{INDUSTRY}}" "under new management" OR "new owners"` — finds businesses that recently changed hands
- Search: `"{{CITY}}" "{{INDUSTRY}}" business sale OR "sold" OR "new ownership" [current year]` — surfaces recent business sale listings
- Search: `"{{CITY}}" "{{INDUSTRY}}" site:facebook.com "new owners" OR "under new management"` — Facebook posts announcing ownership changes
- For Google Maps results, check reviews for phrases like "since the new owners", "used to be called", "name changed" — these are strong signals of recent change that can be verified by reading a few recent reviews

#### Priority 2 — Social Media Platforms

Social media is often the only online presence for small hospitality businesses. Scanning Facebook and Instagram can surface businesses that are active but have no website.

- `site:facebook.com "{{CITY}}" "{{INDUSTRY}}"` — local business Facebook pages
- `site:instagram.com "{{CITY}}" "{{INDUSTRY}}"` — local business Instagram accounts
- For each business found, check their profile bio for a website link. If absent, they're a strong candidate.

#### Priority 3 — Review Sites

Review platforms (Google Reviews, Yelp, TripAdvisor, Zomato) list businesses with contact details. Many businesses on these platforms still lack a website.

- `site:tripadvisor.com.au "{{CITY}}" "{{INDUSTRY}}"` — TripAdvisor listings for the city
- `site:yelp.com.au "{{CITY}}" "{{INDUSTRY}}"` — Yelp listings
- For each listing, check whether a website URL is listed. If not, they're a candidate.

---

### Signal Taxonomy

#### Tier 1 — High-Confidence Signals (score +3 each)

| Signal | Example |
|--------|---------|
| No website exists at all (not even a basic page) | Business name + "{{CITY}}" returns no website in top 10 results |
| Only has a Facebook page or Instagram as online presence | Facebook page has "Website" field empty, no link in bio |
| Google Maps listing has no website URL | Google Maps entry shows address, phone, hours — no link |
| Business is in a competitive industry where customers expect a website | Restaurant, café, medical clinic, tradesperson |
| Business recently changed name or ownership | Reviews mention "under new management", "since the new owners"; Google Maps name differs from Facebook name; ABN lookup shows recent registration date |

#### Tier 2 — Medium-Confidence Signals (score +2 each)

| Signal | Example |
|--------|---------|
| Has a website but it's clearly outdated (copyright 2022 or earlier, broken layout) | `© 2019` in footer, non-responsive design on mobile |
| Has a basic single-page site with no info | One page with name, phone, address — no menu/services, no photos |
| Website is a "coming soon" or "under construction" page | Single page with "Website coming soon — call us at [number]" |
| Operates in {{CITY}} target suburbs | Ellenbrook, Aveley, Midland, Ballajura, or adjacent |

#### Tier 3 — Weak/Contextual Signals (score +1 each)

| Signal | Example |
|--------|---------|
| Has a website on a free subdomain (e.g. `.wordpress.com`, `.wixsite.com`) | `mybusiness.wordpress.com` |
| Has a social media page but no consistent posting | Facebook page with last post 6+ months ago |
| Low review count on Google Maps (< 10 reviews) | May indicate limited digital presence overall |

#### Disqualifying Signals (exclude the lead entirely)

- Business already has a professional, modern, actively maintained website
- Business is a national chain or franchise with a corporate website
- Business is clearly not in the target city/region `{{CITY}}`
- Business appears to be closed, dormant, or no longer trading
- Business is a tech/digital company (they already understand the value of a website)
- Business has a current, active web agency relationship (see Universal Lead Disqualifiers in `Skill.md`)

---

## Placeholder Reference

| Token | Source Parameter |
|-------|-----------------|
| `{{COUNTRY}}` | Target country |
| `{{CITY}}` | Target city/region |
| `{{INDUSTRY}}` | Industry sector |
| `{{BUSINESS_SIZE}}` | Business size |
| `{{COMPANY_NAME}}` | Business name |
| `{{CONTACT_NAME}}` | Name of identified contact (Phone output) |
| `{{CONTACT_ROLE}}` | Job title of the contact (Phone output) |
| `{{CONTACT_PHONE}}` | Direct phone number of the contact, or main company line with instructions (Phone output) |

All tokens must be replaced before presenting the final message to the human.
