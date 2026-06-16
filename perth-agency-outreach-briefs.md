# Perth Web Design Agency — Phone Outreach Briefs (Corrected)

**Generated:** 16 June 2026 (corrected re-scan)
**Offerings:** AI-Era Security Audit (free) + Agency Security Pipeline (beta pilot)
**Target:** Web design agencies in Perth, WA
**Output format:** Phone

---

## #1 — The Start

**Phone Research Brief — The Start**

- **Company:** The Start, Small (20-23 staff), Perth CBD (Level 1, 370 Murray St), Australia
- **Contact Details:**
  - **Name:** Neil Mason
  - **Role:** Founder & Managing Director
  - **Phone:** (08) 6245 9847 (main line — ask for Neil Mason)
  - **Email:** hi@thestart.com.au
- **Industry Focus:** Web design, branding, digital marketing, AI product development serving clients across Australia
- **Products or Services:** Full-service creative studio — brand identity, web design/development, SEO, marketing campaigns, AI products (Voodu, Solais, Maiple), immersive experiences. Portfolio includes RTRFM (Webby award winner), Joondalup Festival, Pacific Energy.
- **Tech Stack:** WordPress 7.0, LiteSpeed server, Yoast SEO Premium 27.0, custom theme, no WAF (no Cloudflare, Sucuri, or Wordfence detected)

### Scan Findings

| Severity | Finding | Detail |
|----------|---------|--------|
| 🔴 Critical | **User enumeration via REST API** | `wp-json/wp/v2/users` returns HTTP 200 exposing all author accounts including names, avatars, and author page URLs. Automated AI tools can harvest usernames for credential-stuffing attacks. |
| 🔴 Critical | **No WAF protection** | No Cloudflare, Sucuri, or Wordfence detected. The site is directly exposed to the internet behind only LiteSpeed. |
| 🟠 High | **readme.html accessible** | `https://thestart.com.au/readme.html` returns HTTP 200, confirming exact WordPress version to any attacker. |
| 🟠 High | **No Content Security Policy** | Missing CSP header means any XSS vulnerability in a plugin or theme becomes fully exploitable — no browser-side mitigation. |
| 🟡 Medium | **`Link` headers expose internal API structure** | `wp-json/` and REST API routes disclosed in response headers, reducing reconnaissance effort for attackers. |

### Suggested Offering Focus

- **Primary: AI-Era Security Audit (free)** — Lead with the exposed user enumeration API. This is a trivially exploitable finding on a high-profile award-winning agency's own site. Frame as: *"Your own WordPress REST API is listing every author on your site publicly — including usernames an attacker can feed directly into a credential-stuffing bot."*
- **Secondary: Agency Security Pipeline (beta pilot)** — The Start manages 20+ staff building client sites. After the free audit opens the door, pivot to: *"If your own site has this gap, what's the posture across the client sites you build and maintain? I'm building a pipeline that catches exactly these issues before they reach production."*

### Leading Questions

1. "I was looking at your site and noticed the WordPress user API is listing your team members publicly — including usernames — with no authentication required. When did you last check what information your site leaks to automated scanners?"
2. "You're building AI products and websites for clients — do you have a consistent way of checking security posture across all the sites you manage, or is it done case-by-case?"
3. "If I can show you three security gaps on your own site in under two minutes, would a 20-minute call be worth your time to see what a full audit covers?"

---

## #2 — Oliver Agency

**Phone Research Brief — Oliver Agency**

- **Company:** Oliver Agency, Micro (small team), Perth WA
- **Contact Details:**
  - **Phone:** +61 409 299 310 (LinkedIn — ask for General Manager)
  - **Email:** hello@oliveragency.com.au
  - **ABN:** 30 361 320 780 (Vanessa Marie Oliver, Sole Trader)
- **Industry Focus:** Web design, branding, development. 20 years combined experience.
- **Tech Stack:** WordPress (WPBakery), nginx, no WAF

### Scan Findings

| Severity | Finding | Detail |
|----------|---------|--------|
| 🔴 Critical | **User enumeration via REST API** | `wp-json/wp/v2/users` returns HTTP 200 exposing all author accounts. Combined with zero security headers and no WAF, this is trivially exploitable. |
| 🔴 Critical | **readme.html accessible** | Returns HTTP 200 — confirms exact WordPress version. |
| 🔴 Critical | **No HSTS header** | Missing entirely — SSL-stripping attacks possible. |
| 🔴 Critical | **No Content Security Policy** | Missing — any XSS becomes fully exploitable. |
| 🔴 Critical | **No X-Frame-Options** | Clickjacking attack surface open. |
| 🟠 High | **No Referrer-Policy** | URL leakage on cross-origin navigation. |
| 🟠 High | **No WAF protection** | Bare nginx with no Cloudflare, Sucuri, or Wordfence. |
| 🟡 Medium | **Internal host-header leaked** | Internal proxy configuration detail visible to all visitors. |

### Suggested Offering Focus

- **Primary: AI-Era Security Audit (free)** — The combination of user enumeration + no security headers at all + no WAF makes this the most vulnerable agency scanned. *"Your site has no HSTS, no CSP, no clickjacking protection, no WAF — and your WordPress user API is returning everyone's usernames publicly. This is the most exposed configuration I've seen from a Perth agency."*
- **Secondary: Agency Security Pipeline (beta pilot)** — Small agency likely managing 10+ client sites with the same lack of security infrastructure.

### Leading Questions

1. "I ran a routine security check on your site and found your WordPress user API exposed — it's returning your team's usernames with no authentication. On top of that, there's no HSTS, no CSP, no clickjacking protection, and no WAF. Is this something you've looked at recently?"
2. "Do you handle maintenance and security updates for the websites you build for clients, or is that handed off after launch?"

---

## #3 — Lilo

**Phone Research Brief — Lilo**

- **Company:** Lilo, Small (est. 10-20 staff based on team page), Claremont, Perth WA
- **Contact Details:**
  - **Name:** Deon Beckley
  - **Role:** CEO & CFO
  - **Phone:** 1300 816 710 (main line — ask for Deon Beckley)
  - **Address:** Level 1, 28 Bay View Terrace, Claremont WA 6010
- **Industry Focus:** Web design and development agency, 500+ websites delivered since 2001. Clients across Australia, UK, and South Africa (3 offices).
- **Products or Services:** Custom WordPress web design, eCommerce, web development, digital strategy, website maintenance. Portfolio spans home builders (Andrew Stevens Homes), architects (Hunt Architects), lighting designers (Klaasen), and more.
- **Tech Stack:** WordPress, Apache/2.4.66 (Debian), PHP/8.3.30, no WAF, no security headers

### Scan Findings

| Severity | Finding | Detail |
|----------|---------|--------|
| 🔴 Critical | **Apache + PHP exact versions exposed** | `Server: Apache/2.4.66 (Debian)` and `X-Powered-By: PHP/8.3.30` headers leak exact software versions. AI-assisted attackers cross-reference these against CVE databases instantly. |
| 🔴 Critical | **No HSTS header** | `Strict-Transport-Security` is completely absent. Users connecting over HTTP can have their traffic downgraded (SSL-stripping attack). |
| 🔴 Critical | **No Content Security Policy** | No CSP header. Any XSS vulnerability — in Lilo's own site or a client site built on the same stack — has zero browser-side mitigation. |
| 🔴 Critical | **No X-Frame-Options** | Clickjacking attacks are trivially possible. |
| 🔴 Critical | **No X-Content-Type-Options** | MIME-type sniffing attacks are possible. |
| 🟠 High | **No WAF protection** | Bare Apache serving WordPress directly with no Cloudflare, Sucuri, Wordfence, or any web application firewall. |
| 🟠 High | **readme.html accessible** | WordPress installation confirmation available to any scanner. |
| 🟡 Medium | **No Referrer-Policy header** | URL and query-string leakage possible. |
| 🟡 Medium | **No Permissions-Policy header** | No restrictions on browser API access. |

### Suggested Offering Focus

- **Primary: Agency Security Pipeline (beta pilot)** — Lilo manages 500+ client sites from a single WordPress/Apache stack with zero security headers and a bare server. *"You deliver 500+ websites for clients, yet your own infrastructure has zero browser security controls and is leaking server software versions. Every client site you build inherits the same gap — I can show you how to fix that systematically."*
- **Secondary: AI-Era Security Audit (free)** — Offer a free scan of their own site first to demonstrate credibility.

### Leading Questions

1. "Your own site is running on Apache with PHP 8.3.30 exposed publicly — and there are zero security headers on your infrastructure. That means every client site you host or manage inherits the same gaps. Have you had a chance to audit this recently?"
2. "With 500+ client sites to manage, how do you currently handle security updates — are you updating each site manually, or do you have a pipeline in place?"
3. "If I could show you a pipeline that sandbox-tests every update before it touches your client sites, with automated rollback if something breaks — would 20 minutes to see it in action be worth your time?"

---

## #4 — Bloom Digital

**Phone Research Brief — Bloom Digital**

- **Company:** Bloom Digital, Small (14 staff), Subiaco, Perth WA
- **Contact Details:**
  - **Name:** Sara Lyon
  - **Role:** Founder & Director
  - **Phone:** 08 9384 0637 (main), 0477 533 887 (mobile)
  - **Email:** info@bloomdigital.net.au
  - **Address:** Level 2, 16/210 Bagot Road, Subiaco WA 6008
- **Industry Focus:** Digital marketing, SEO, web design, branding. Award-winning agency (AMI Awards, Search Engine Land Awards, Australian Design Awards)
- **Products or Services:** SEO-driven website design, Google Ads management, social media marketing, branding, AI-integrated marketing. Key clients: Perth Health Collective, Hermona Health, SKYN, Gambarra.
- **Tech Stack:** WordPress + Slider Revolution 6.7.57, nginx, SiteGround hosting, HubSpot, jQuery 3.4.1 loaded from Google CDN

### Scan Findings

| Severity | Finding | Detail |
|----------|---------|--------|
| 🔴 Critical | **jQuery 3.4.1 — known XSS CVEs** | Loaded from Google CDN (`ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js`). jQuery <3.5.0 has two unpatched XSS vulnerabilities (CVE-2020-11022, CVE-2020-11023). Over 6 years behind current stable. |
| 🟠 High | **Slider Revolution 6.7.57 detected** | WordPress's most-targeted plugin with a long history of critical CVEs. |
| 🟠 High | **No Content Security Policy** | Missing CSP — no mitigation against XSS in the outdated jQuery or Slider Revolution. |
| 🟠 High | **No X-Frame-Options** | Clickjacking possible. |
| 🟠 High | **No Referrer-Policy header** | URL leakage on cross-origin navigation. |
| 🟠 High | **No Permissions-Policy header** | Browser API access unrestricted. |
| 🟡 Medium | **No WAF detected** | nginx server without Cloudflare, Sucuri, or Wordfence. |

### Suggested Offering Focus

- **Primary: AI-Era Security Audit (free)** — Lead with the jQuery vulnerability: *"Your site is loading jQuery 3.4.1 from Google's CDN — that version has two publicly known XSS vulnerabilities that have been documented for years. And since there's no Content Security Policy, there's nothing stopping an attacker from exploiting it."*
- **Secondary: Agency Security Pipeline (beta pilot)** — *"If your own site has an unpatched jQuery CVE, what's the posture across the client sites you manage?"*

### Leading Questions

1. "Your website is loading jQuery 3.4.1 from Google's CDN — that version has two known XSS vulnerabilities that are publicly documented. Combined with no Content Security Policy on your site, what would stop a visitor from being served a malicious payload?"
2. "As an agency, how do you track dependency versions across your own site and the client sites you maintain?"
3. "You're an award-winning agency building sites for clients — do you have a system in place that catches dependency vulnerabilities before they go live on client sites?"

---

## #5 — CVW Creative

**Phone Research Brief — CVW Creative**

- **Company:** CVW Creative, Micro (2-7 staff), Osborne Park, Perth WA
- **Contact Details:**
  - **Phone:** (08) 6184 6715
  - **Email:** info@cvwcreative.com.au
  - **Address:** Level 1, 2/7 Hector Street, Osborne Park WA 6017
- **Industry Focus:** Web design, graphic design, eCommerce, print. Founded 2008.
- **Products or Services:** Custom web development, eCommerce, graphic design, SEO, digital strategy.
- **Tech Stack:** Custom **PHP** application (no CMS), Apache, no frameworks. jQuery 1.8.2 CDN, Modernizr 2.6.2 CDN, various hand-picked jQuery plugins (bxSlider, rhinoSlider). No security headers. No WAF.

### Key Context

CVW Creative runs a **custom-built PHP site** with no CMS — no WordPress, no auto-update mechanism. Everything is hand-coded and manually maintained. Their sitemap was last generated in **October 2017** (over 8 years ago), suggesting the site is in maintenance mode rather than active development. The complete lack of security headers and WAF protection on a bare Apache server serving a decade-old codebase with jQuery 1.8.2 makes this a straightforward pitch — no CMS complexity to navigate.

### Scan Findings

| Severity | Finding | Detail |
|----------|---------|--------|
| 🔴 Critical | **jQuery 1.8.2 loaded from CDN** | `ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js` — over 12 years old with many known CVEs. |
| 🟠 High | **Modernizr 2.6.2 loaded from CDN** | `cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.2/modernizr.min.js` — over 10 years old. |
| 🟠 High | **No HSTS / No CSP / No XFO / No XCTO** | Zero security headers. |
| 🟠 High | **No WAF protection** | Bare Apache with no Cloudflare, Sucuri, or Wordfence. |

### Suggested Offering Focus

- **Primary: AI-Era Security Audit (free)** — *"Your site is a custom PHP build running jQuery version 1.8.2 from Google's CDN — that's over 12 years old with multiple known vulnerabilities. Your sitemap hasn't been updated since 2017, and there are no security headers or WAF. It's a clean example of why manual maintenance struggles to keep up with security patches."*

### Leading Questions

1. "I noticed your site is a custom PHP build — no CMS. You're running jQuery 1.8.2 which has known CVEs, and your sitemap dates back to 2017. When was the last time the full stack was audited?"
2. "For the websites you build for clients — are they also custom PHP, or do you use WordPress? How do you handle their ongoing security updates?"

---

## #6 — Planted Web Design

**Phone Research Brief — Planted Web Design**

- **Company:** Planted Web Design, Micro (2 co-founders), Perth WA
- **Contact Details:**
  - **Names:** Greg Campbell or Paris Batka (Co-Founders)
  - **Phone:** 0491 939 628
  - **Email:** hello@plantedwebdesign.com.au
- **Industry Focus:** Boutique web design and SEO agency serving small Perth businesses (gyms, event planners, solar installers, trades)
- **Products or Services:** Custom WordPress web design, SEO consultancy, website maintenance, hosting, content creation. Recently wrote a blog post about "Hidden Security Risks of Outdated WordPress Websites" (April 2026).
- **Tech Stack:** WordPress, LiteSpeed, CSP set to upgrade-insecure-requests only

### Scan Findings

| Severity | Finding | Detail |
|----------|---------|--------|
| 🟠 High | **readme.html accessible** | Returns HTTP 200 — confirms WordPress installation. |
| 🟠 High | **No HSTS header** | Missing `Strict-Transport-Security` — no forced HTTPS connections. |
| 🟠 High | **No X-Frame-Options** | Clickjacking attack surface. |
| 🟠 High | **No Referrer-Policy** | Cross-origin URL leakage. |
| 🟠 High | **No WAF detected** | LiteSpeed without Cloudflare or other WAF. |
| 🟡 Medium | **CSP set to upgrade-insecure-requests only** | Minimal — no script/style source restrictions, no XSS mitigation. |
| 🟡 Medium | **LiteSpeed server header present** | Server software fingerprinting possible. |

### Contextual Note

Planted Web Design recently published a blog post titled *"The Hidden Security Risks of Outdated WordPress Websites"* (27 April 2026), positioning themselves as knowledgeable about WordPress security. This makes the security gaps on their own site a particularly strong credibility angle.

### Suggested Offering Focus

- **Primary: AI-Era Security Audit (free)** — Lead with the contrast: *"I read your blog post about WordPress security risks — so I was surprised to find your own site's readme.html is publicly accessible and your site is missing HSTS, X-Frame-Options, and has no WAF. I ran a quick check and found several issues worth discussing."*
- **Secondary: Agency Security Pipeline (beta pilot)** — *"You're actively educating your clients about security. A pipeline would let you show them you practice what you preach — every client site monitored and patched through a sandboxed, automated system."*

### Leading Questions

1. "Your April blog post does a great job explaining WordPress security risks to small businesses — I noticed your own site has a few of the same gaps. Have you had a chance to audit your own infrastructure recently?"
2. "You talk about security being important — what's your current process for keeping client sites updated? Is it manual, or do you have automation in place?"
3. "Would you be open to a free audit of your own site as a starting point? No obligation — just a practical look at where you stand."

---

## Call Flow Template (Agency Pipeline)

**Opening (15 seconds):**
> "Hi [CONTACT_NAME]? My name's [YOUR_NAME] — I'm a security researcher based in Perth. I had a look at [AGENCY_NAME]'s website and found something worth flagging — do you have two minutes?"

**If yes — the hook (30 seconds):**
> "I ran a passive scan of your site and found [TOP 1–2 FINDINGS — e.g., user enumeration API exposed / no security headers / outdated libraries with known CVEs]. Combined with the fact that there's no WAF protecting your infrastructure, these are gaps that automated AI attack tools will find in minutes. I'm not raising this to be critical — it's a widespread problem."

**The pivot (20 seconds):**
> "I'm building a security pipeline specifically for web agencies — it catches exactly these issues across every site you manage. Sandboxed staging, automated smoke tests, instant rollback if something breaks. I'm looking for beta partners in Perth to build it with — you'd get it configured on your infrastructure at a discounted rate. Would a 20-minute call this week work?"

### Objection Handling

| Objection | Response |
|-----------|----------|
| "Our developers handle updates" | "Absolutely — but it pulls them off billable work. The pipeline automates that, keeping your team billable." |
| "We don't have budget" | "The pilot is fixed-price and designed to prove value first. What would make 20 minutes worth it?" |
| "Send me an email" | "Happy to — who should I address it to, and is this the best email?" |
| "We already do security checks" | "That's great — what does your current update process look like? I'm curious whether what I'm building would complement it." |

---

## Summary: Corrected Priority Ranking for Outreach

| Priority | Agency | Primary Angle | Best Finding to Lead With |
|----------|--------|---------------|---------------------------|
| 1 | **The Start** | Free audit → pipeline | User enumeration API (🔴 Critical) + readme.html public + no WAF |
| 2 | **Oliver Agency** | Free audit | User enumeration + **zero** security headers + no WAF — most exposed agency found |
| 3 | **Lilo** | Pipeline (beta) | Apache/PHP version leak + zero security headers on a 500-client agency |
| 4 | **Bloom Digital** | Free audit → pipeline | jQuery 3.4.1 from CDN with known XSS CVEs + no CSP |
| 5 | **CVW Creative** | Free audit | jQuery 1.8.2 from CDN (12yr old, multiple CVEs) |
| 6 | **Planted Web Design** | Free audit → pipeline | Blogged about WP security but own readme.html + missing HSTS/XFO + no WAF |
