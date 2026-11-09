# Search API Guide

This guide documents the preferred search mechanisms for `dev-level-up`. The skill is language-agnostic: use the detected `.tech-stack/` domains, selected objectives, and `resources/source-registry.md` to choose queries and endpoints.

## Search Strategy Tiers

| Tier | Mechanism | Date Filtering | Best For |
|------|-----------|----------------|----------|
| 1 | **Direct APIs** | Native, precise | Hacker News, GitHub repos/releases, package registries, arXiv |
| 2 | **Brave Search API** | Native, custom ranges | General web, official sites, vendor feeds, community sources, news |
| 3 | **News APIs / RSS / Atom** | Publish-date fields or feed dates | Mainstream tech news and official blogs with feeds |
| 4 | **Web Search Fallback** | Operator-based (`after:`) | Sources without APIs or feeds; requires manual date verification |

---

## Tier 1: Direct APIs

### Hacker News Algolia API

Free, no authentication required. Provides precise Unix-timestamp filtering.

**Endpoint:** `https://hn.algolia.com/api/v1/search`

**Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `query` | string | Search terms | `"MCP server security"` |
| `tags` | string | Filter by tag | `story`, `show_hn`, `ask_hn` |
| `numericFilters` | string | Timestamp range | `created_at_i>1767225600` |
| `hitsPerPage` | integer | Results per page (max 100) | `50` |
| `page` | integer | Zero-based pagination | `0` |

**Date math:** Convert `YYYY-MM-DD` to Unix timestamp: `date -d "YYYY-MM-DD" +%s`

**Example calls:**

```bash
# HN stories about MCP security from last 30 days
curl -s "https://hn.algolia.com/api/v1/search?query=MCP+server+security&tags=story&numericFilters=created_at_i>1767225600&hitsPerPage=50"

# Show HN launches for a detected domain
curl -s "https://hn.algolia.com/api/v1/search?query=Next.js+AI&tags=show_hn&numericFilters=created_at_i>1767225600&hitsPerPage=50"
```

**Why this works:** Algolia indexes HN with exact `created_at_i` timestamps.

---

### GitHub Search API

Free for public repos at low volume. Supports `created:`, `pushed:`, `topic:`, and `language:` qualifiers.

**Endpoint:** `https://api.github.com/search/repositories`

**Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `q` | string | Query with qualifiers | `"AI code review" topic:developer-tools pushed:>2026-10-10` |
| `sort` | string | Sort order | `updated`, `stars` |
| `order` | string | Direction | `desc` |
| `per_page` | integer | Results per page (max 100) | `30` |

**Useful qualifiers:**

- `created:>YYYY-MM-DD` — repo created after date
- `pushed:>YYYY-MM-DD` — last push after date
- `topic:<topic>` — repository topic
- `language:<language>` — primary language, when known
- `user:<org>` or `org:<org>` — restrict to an organisation
- `filename:`/`path:` — only for code search, which normally requires authentication; prefer repo search for unauthenticated use

**Example calls:**

```bash
# Recent AI tooling repos related to a detected domain
curl -s "https://api.github.com/search/repositories?q=AI+coding+assistant+topic:developer-tools+pushed:>2026-10-10&sort=updated&order=desc&per_page=30"

# Recent releases-adjacent repos for an ecosystem
curl -s "https://api.github.com/search/repositories?q=Terraform+AI+automation+pushed:>2026-10-10&sort=updated&order=desc&per_page=30"
```

---

### GitHub Releases API

Use when `.tech-stack/` identifies a specific GitHub repo or org.

**Endpoint:** `https://api.github.com/repos/{owner}/{repo}/releases?per_page=30`

Check `published_at` for each release and keep only releases within the 30-day window. For organisations, use GitHub Search or the organisation's release feed/blog when a single repo is not enough.

---

### arXiv API

Useful for AI/ML research relevant to coding tools, agents, verification, and security.

**Endpoint:** `https://export.arxiv.org/api/query`

**Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `search_query` | string | arXiv query | `all:"AI code generation"` or `cat:cs.SE AND all:"large language models"` |
| `sortBy` | string | Sort field | `submittedDate` |
| `sortOrder` | string | Direction | `descending` |
| `max_results` | integer | Result count | `10` |

**Example:**

```bash
curl -s "https://export.arxiv.org/api/query?search_query=all:%22AI%20code%20generation%22&sortBy=submittedDate&sortOrder=descending&max_results=10"
```

Verify the paper's submission/published date before inclusion.

---

## Tier 2: Brave Search API

Requires a free API key from `https://api-dashboard.search.brave.com/`. Best general-purpose search with robust native date filtering.

**Endpoint:** `https://api.search.brave.com/res/v1/web/search`

**Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `q` | string | Search query | `"Next.js 16" release migration` |
| `freshness` | string | Date filter | `pm` or `YYYY-MM-DDtoYYYY-MM-DD` |
| `result_filter` | string | Result types | `news`, `discussions`, `web` |
| `count` | integer | Results (max 20) | `20` |
| `offset` | integer | Pagination (max 9) | `0` |

**Freshness values:**

- `pd` — past 24 hours
- `pw` — past 7 days
- `pm` — past 31 days
- `py` — past 365 days
- `YYYY-MM-DDtoYYYY-MM-DD` — custom range; most reliable for exact 30-day windows

**Example calls:**

```bash
# Official-domain search for a detected framework
curl -s -H "X-Subscription-Token: $BRAVE_API_KEY" \
  "https://api.search.brave.com/res/v1/web/search?q=Next.js+release+site:nextjs.org&freshness=2026-10-10to2026-11-09&result_filter=web&count=20"

# AI vendor feed search
curl -s -H "X-Subscription-Token: $BRAVE_API_KEY" \
  "https://api.search.brave.com/res/v1/web/search?q=MCP+security+site:modelcontextprotocol.io&freshness=2026-10-10to2026-11-09&result_filter=web&count=20"
```

**Why this works:** Brave's `freshness` uses the page's most relevant reported date, and custom ranges are exact.

---

## Tier 3: News APIs, RSS, and Atom Feeds

### News API

Free developer tier. Useful for mainstream tech news, but limited for deep technical sources.

**Endpoint:** `https://newsapi.org/v2/everything`

**Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `q` | string | Search query | `"AI coding assistant"` |
| `from` | date | Start date | `2026-10-10` |
| `to` | date | End date | `2026-11-09` |
| `domains` | string | Comma-separated domains | `techcrunch.com,thenewstack.io` |
| `language` | string | ISO 639-1 code | `en` |
| `sortBy` | string | Order | `publishedAt`, `relevancy` |
| `pageSize` | integer | Results per page | `50` |

Use News API only when Brave coverage is insufficient or when targeting known media domains.

### RSS/Atom and Changelog Feeds

Many official blogs and changelogs publish RSS/Atom feeds. Common paths to try:

- `/feed`
- `/feed.xml`
- `/rss.xml`
- `/atom.xml`
- `/blog/feed`
- `/changelog.xml`
- `/releases.atom`

Fetch candidate feeds with `curl` or web fetch, parse `pubDate`/`published`/`updated`, and keep only items inside the 30-day window. If a feed lacks dates, verify the item page manually.

---

## Tier 4: Web Search Fallback

Use when APIs and feeds are unavailable or for sources without API access.

### Search Operators

| Operator | Purpose | Reliability |
|----------|---------|-------------|
| `site:domain.com` | Restrict to source | High |
| `after:YYYY-MM-DD` | Date filter | Low — can reflect crawl/index date |
| `before:YYYY-MM-DD` | Date filter | Low — can reflect crawl/index date |
| `intitle:` / `inurl:` | Narrow titles/URLs | Medium |

**Recommendation:** Always verify publish dates manually for web-search-only results.

---

## Package Registry and Version Checks

Use package registries to identify current versions, release recency, package identity, and official project links. They are evidence sources, not replacements for dated release notes.

| Ecosystem | Metadata endpoint pattern | Notes |
|-----------|---------------------------|-------|
| npm | `https://registry.npmjs.org/{package}` | Check `dist-tags`, `time`, `repository`, `homepage` |
| npm search | `https://registry.npmjs.org/-/v1/search?text={query}&size=20` | Discovery only; no reliable date filter |
| PyPI | `https://pypi.org/pypi/{package}/json` | Check `releases` upload times and project URLs |
| PyPI updates RSS | `https://pypi.org/rss/updates.xml` | Broad recent package updates; noisy |
| crates.io | `https://crates.io/api/v1/crates/{crate}` | Check versions and `created_at`/`updated_at` |
| crates.io search | `https://crates.io/api/v1/crates?q={query}&per_page=20` | Discovery only |
| Go modules | `https://proxy.golang.org/{module}/@latest` and `/@v/{version}.info` | Check latest version and timestamp |
| Maven Central | `https://search.maven.org/solrsearch/select?q={query}&rows=20&wt=json` | Use for discovery/version evidence; verify dates via POM/release notes |
| NuGet | `https://api.nuget.org/v3-flatcontainer/{id-lower}/index.json` | Version list; verify release dates through NuGet registration or release notes |
| RubyGems | `https://rubygems.org/api/v1/versions/{gem}/latest.json` | Latest version evidence |
| RubyGems search | `https://rubygems.org/api/v1/search.json?query={query}` | Discovery only |
| Packagist | `https://repo.packagist.org/p2/{vendor}/{package}.json` | Package metadata; verify dates via VCS/release notes |

**Rule:** If a registry shows a new version but no clear publish date, use the project's changelog, GitHub release, tag, or announcement to establish freshness.

---

## Dynamic Mechanism Selection

Use `resources/source-registry.md` to map each domain/objective pair to source classes, then choose mechanisms as follows:

| Source class | Preferred mechanism |
|--------------|---------------------|
| Official changelog/release notes | RSS/Atom, official API, GitHub releases, Brave `site:` search |
| Package registry | Registry metadata/search endpoints above |
| AI vendor feed | Brave `site:` search, vendor RSS/docs, GitHub releases |
| Hacker News | HN Algolia API |
| GitHub repos/tools | GitHub Search API or releases API |
| Research papers | arXiv API or targeted web search |
| General media | Brave Search API or News API |
| Unknown source | Web search fallback with manual date verification |

---

## Rate Limits and Cost

| API | Free Tier | Auth Required | Rate Limit |
|-----|-----------|---------------|------------|
| HN Algolia | Unlimited | No | ~10 req/min; be polite |
| GitHub Search | 10 req/min | No for basic repo search | 10 req/min unauthenticated |
| GitHub Releases | 60 req/hr | No for public repos | 60 req/hr unauthenticated |
| Brave Search API | 2,000 queries/month | Yes | ~1 req/sec |
| News API | 100 req/day | Yes | ~1 req/sec |
| arXiv API | Generous | No | Respectful delay between calls |
| Package registries | Varies | Usually no | Varies; cache results |

---

## Recommended Execution Order

1. **Derive scope and sources** from `.tech-stack/` and `resources/source-registry.md`.
2. **Run direct APIs first** for HN, GitHub repos/releases, arXiv, and package registries where applicable.
3. **Run Brave Search API** for official domains, AI vendor feeds, community sources, standards bodies, and general web coverage.
4. **Run News API or RSS/Atom** only for gaps or media-specific coverage.
5. **Run web search fallback** only for remaining gaps, with strict manual date verification.

**Query budget:** Do not exceed 18 total API calls + web searches by default. If scope is broad, prioritise manual/custom domains, selected objectives, and domains with current versions or clear upgrade paths. Report deferred domains/objectives in the executive summary.
