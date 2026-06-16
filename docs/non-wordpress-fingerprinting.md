# Non-WordPress Fingerprinting — Passive Tech-Stack Detection

**Purpose:** Improve prod-mode scanner accuracy by detecting frameworks, languages, and CMS platforms beyond WordPress. Many sites run custom PHP, static HTML, React/Vue SPAs, or alternative CMS platforms. Without this detection, the scanner falls back to "WordPress or unknown" and misses critical context.

---

## Why This Matters

| Scenario | Without Fingerprinting | With Fingerprinting |
|----------|----------------------|-------------------|
| Sites returning 404 on `/wp-json` and `/wp-content` | "Unknown tech stack" | "Custom PHP, no CMS, no auto-update mechanism" |
| Sites with no generator meta tag | "WordPress (assumed)" | "Static HTML site, no server-side processing" |
| Sites with `.php` extension URLs | "WordPress (permalink variation)" | "Custom PHP application — check for framework" |
| Single-page apps | "WordPress (assumed)" | "React/Vue SPA — check for source maps, API exposure" |

The tech stack determines what attacks are viable and what findings are relevant:
- **WordPress**: Check `wp-json`, `readme.html`, plugin version leaks, Slider Revolution, Yoast
- **Custom PHP**: No auto-update path, check for `.php` URL patterns, framework usage, stale sitemaps
- **React/Vue/Next/Nuxt**: Check for `__NEXT_DATA__`, source maps, SSR vs CSR, API route exposure
- **Static HTML**: No dynamic backend to exploit — focus on client-side dependencies exclusively
- **Laravel / Symfony / Django / Rails**: Check `_debug_bar`, `debug` cookies, exposed `artisan` or `manage.py` paths

---

## Fingerprint Signals (In Priority Order)

### P1: URL File Extensions

The strongest signal. Scan all `<a>`, `<form>`, `<link>`, and `<script>` href/src attributes for file extensions.

| Extension | Likely Stack |
|-----------|-------------|
| `.php` | Custom PHP, Laravel, Symfony, WordPress |
| `.aspx` / `.asp` | ASP.NET (legacy) |
| `.jsp` / `.do` / `.action` | Java (JSP / Spring MVC) |
| `.cfm` | ColdFusion |
| `.py` | Python (rarely in URLs — usually Django/Flask route) |
| `.html` / `.htm` | Static HTML, or a static-site generator |

**CVW Creative example:** All pages were `.php` (`/about.php`, `/services.php`, `/portfolio.php`, `/contact.php`) but none of the WordPress paths resolved. This strongly indicated custom PHP, not WordPress (WordPress uses pretty permalinks or `?p=ID` by default, rarely `.php` extension URLs).

### P2: CMS-Specific Paths

Check if known CMS admin/frontend paths resolve. Use HTTP status code to distinguish:
- **200** = CMS detected (confirmed)
- **301/302** = CMS detected (redirect)
- **401/403** = CMS detected (blocked, but exists)
- **404** = Not this CMS

| CMS | Path to Check |
|-----|--------------|
| **WordPress** | `/wp-admin/`, `/wp-json/`, `/wp-content/`, `/xmlrpc.php`, `/readme.html` |
| **Drupal** | `/sites/default/`, `/core/install.php`, `/user/login`, `/node/1` |
| **Joomla** | `/administrator/`, `/components/`, `/modules/`, `/templates/` |
| **Magento** | `/admin/`, `/static/`, `/media/`, `/setup/`, `/pub/` |
| **Shopify** | `/admin`, `/products/`, `/collections/`, `myshopify.com` |
| **Squarespace** | `/config/`, `squarespace.com` in HTML, unique `data-*` attributes |
| **Wix** | `wix.com` in HTML, `wix-static` in assets |
| **Webflow** | `webflow.com` in HTML, `data-wf-*` attributes |
| **Next.js** | `/_next/static/`, `__NEXT_DATA__` in HTML |
| **Nuxt** | `/_nuxt/`, `__NUXT__` in HTML |
| **Gatsby** | `/static/`, `___gatsby` in HTML |
| **Laravel** | `/artisan`, `laravel_session` cookie, `_debug_bar` |
| **Django** | `/admin/`, `csrftoken` cookie, `sessionid` cookie |
| **Ruby on Rails** | `/rails/`, `_session_id` cookie, `_csrf_token` |

**CVW Creative example:** `/admin`, `/wp-admin`, `/administrator`, `/cms`, `/backend`, `/login` all returned 404. Combined with `.php` extensions and no `wp-content` references, confirmed: **no CMS, custom PHP**.

### P3: Meta Generator Tags

Check for `<meta name="generator">`, `<meta name="framework">`, or build-tool comment headers.

| Generator Value | Platform |
|----------------|----------|
| `WordPress X.Y` | WordPress |
| `Drupal X.Y` | Drupal |
| `Joomla! X.Y` | Joomla |
| `Magento X.Y` | Magento |
| `WPBakery Page Builder` | WordPress (page builder plugin) |
| `Slider Revolution X.Y` | WordPress (slider plugin) |
| `Site Kit by Google X.Y` | WordPress (Google plugin) |
| `All in One SEO (AIOSEO) X.Y` | WordPress |
| `Yoast SEO` | WordPress |
| `Gatsby X.Y` | Gatsby (React static site) |
| `Next.js X.Y` | Next.js |
| `Hugo X.Y` | Hugo (static site generator) |
| `Jekyll X.Y` | Jekyll (static site generator) |

**Absence of any generator tag + `.php` URL pattern = custom PHP** (as with CVW Creative).

### P4: JS Framework Globals

Scan the HTML for framework-specific global variables or SSR data blocks.

| Variable / Pattern | Framework |
|--------------------|-----------|
| `__NEXT_DATA__` in `<script>` | Next.js |
| `__NUXT__` in `<script>` | Nuxt |
| `__REACT_DEVTOOLS_GLOBAL_HOOK__` | React |
| `data-reactroot` / `data-reactid` | React (older versions) |
| `ng-version="X.Y.Z"` | Angular |
| `__VUE__` or `data-v-XXXXX` | Vue (attribute on root element) |
| `___gatsby` (in `window`) | Gatsby |
| `window.__SVELTE__` | Svelte |
| `data-server-rendered="true"` | Vue (SSR) |
| `data-page="..."` | Laravel Inertia |

**CVW Creative example:** None of these were present — confirmed no JS framework, vanilla jQuery site.

### P5: Cookie & Header Patterns

Server headers and `Set-Cookie` patterns reveal framework/language.

| Header / Cookie | Indicates |
|----------------|-----------|
| `X-Powered-By: PHP/X.Y` | PHP (version leak) |
| `X-Powered-By: ASP.NET` | ASP.NET |
| `X-Powered-By: Express` | Node.js / Express |
| `server: gunicorn` | Python (Django/Flask) |
| `server: uvicorn` | Python (FastAPI) |
| `server: Caddy` | Go (Caddy server) |
| `server: nginx/1.24.0` | nginx (versioned = leak) |
| `Set-Cookie: PHPSESSID=...` | PHP-based site (WordPress, custom, Laravel, etc.) |
| `Set-Cookie: laravel_session=...` | Laravel |
| `Set-Cookie: csrftoken=...` | Django |
| `Set-Cookie: _session_id=...` | Ruby on Rails |
| `Set-Cookie: JSESSIONID=...` | Java (JSP / Spring) |
| `Set-Cookie: ASP.NET_SessionId=...` | ASP.NET |
| `Set-Cookie: connect.sid=...` | Node.js / Express |

**CVW Creative example:** `Server: Apache` (no version), no `X-Powered-By` header, no PHP version leak — the server is configured to hide version info. No `Set-Cookie` either. Combined with `.php` URLs, this told us: custom PHP on Apache with hardened headers (ironic, given no security headers elsewhere).

### P6: Build Tool / Generator Footprints

Tools used to build the site often leave artifacts.

| Artifact | Tool |
|----------|------|
| `<!-- created with Standalone Sitemap Generator www.xml-sitemaps.com -->` | Custom site, no CMS (as seen with CVW) |
| `<!-- built with Webflow -->` | Webflow |
| `<!-- This page was created with Wix -->` | Wix |
| `<!-- wp:content -->` in HTML comments | WordPress block editor (Gutenberg) |
| `@import "compass"` in CSS | Compass/SASS (older Rails/PHP sites) |
| `/*! normalize.css vX.Y.Z */` | Standard include, but paired with other signals can indicate a starter boilerplate |

**CVW Creative example:** The sitemap comment `<!-- created with Standalone Sitemap Generator www.xml-sitemaps.com (14585) -->` was a strong signal that this is a custom/manual site, not a CMS that auto-generates sitemaps.

### P7: Sitemap Freshness

Check the `<lastmod>` date in `sitemap.xml`. A stale sitemap indicates a site in maintenance mode.

| Sitemap Age | Signal |
|-------------|--------|
| < 3 months | Actively maintained |
| 3–12 months | Moderate maintenance |
| 1–5 years | Low maintenance, possibly frozen |
| 5+ years | Abandoned or static site |

**CVW Creative example:** All URLs had `<lastmod>2017-10-21</lastmod>` — 8+ years stale. This reinforced the "custom PHP in maintenance mode" profile and was a useful talking point: *"Your sitemap hasn't been updated since 2017 — that's a strong indicator the full tech stack hasn't been reviewed in nearly a decade."*

---

## Decision Tree for Non-WordPress Detection

```
Does /wp-content resolve to a 200/301/302?
├── YES → WordPress site (use wp-specific checks)
└── NO  → Not WordPress. Check:
        └── Does /sites/default or /core/install.php exist?
            ├── YES → Drupal site
            └── NO  → Check URL extensions:
                    ├── .php → Custom PHP (check for Laravel, Symfony)
                    ├── .aspx/.asp → ASP.NET
                    ├── .jsp/.do → Java
                    ├── .py → Python (Django/Flask)
                    └── .html or none → Static HTML or SPA:
                            └── Check JS framework globals:
                                ├── __NEXT_DATA__ → Next.js
                                ├── __NUXT__ → Nuxt/Vue
                                ├── data-reactroot → React
                                ├── ng-version → Angular
                                └── None of above → Static HTML or unknown
```

---

## FP Risks in Non-WordPress Detection

| Signal | FP Risk | Mitigation |
|--------|---------|------------|
| `.php` extension = custom PHP | WordPress can also have `.php` URLs if badly configured | Cross-check: does `wp-content` also exist? If both `.php` URLs AND `wp-content` exist, it's WordPress with ugly permalinks |
| No JS framework globals = vanilla JS | Framework could be loaded asynchronously (script after page render) | Check for framework CDN script tags in `<head>` — jQuery from CDN is still "vanilla jQuery" |
| 404 on all CMS paths = no CMS | CMS could be behind an opaque proxy or path-prefix | Check `Link` headers and `X-Powered-By` — a proxy usually still passes through framework cookies |
| Stale sitemap = abandoned site | Site may use dynamic sitemaps generated at request time | Check `Cache-Control` and `Last-Modified` on `sitemap.xml`. Dynamic sitemaps typically have `no-cache` or very recent `Last-Modified` headers |
| Static HTML = no backend | Site could have a headless CMS backend on a different subdomain | Check for `api.`, `cms.`, or `admin.` subdomains in links |
