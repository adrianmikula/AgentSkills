# Search API Guide

This guide documents the preferred search mechanisms for the dev-level-up skill, organized by reliability of date filtering and source coverage.

## Search Strategy Tiers

| Tier | Mechanism | Date Filtering | Best For |
|------|-----------|----------------|----------|
| 1 | **Direct APIs** | Native, precise | Hacker News (Algolia), GitHub Search |
| 2 | **Brave Search API** | Native, custom ranges | General web, news, discussions |
| 3 | **News APIs** | Native, publish date | Mainstream tech news |
| 4 | **Web Search Fallback** | Operator-based (`after:`) | Sources without APIs |

---

## Tier 1: Direct APIs

### Hacker News Algolia API

Free, no authentication required. Provides precise Unix-timestamp filtering.

**Endpoint:** `https://hn.algolia.com/api/v1/search`

**Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `query` | string | Search terms | `"vibe coding"` |
| `tags` | string | Filter by tag | `story`, `show_hn`, `ask_hn` |
| `numericFilters` | string | Timestamp range | `created_at_i>1714464000` |
| `hitsPerPage` | integer | Results per page (max 100) | `50` |
| `page` | integer | Zero-based pagination | `0` |

**Date math:** Convert `YYYY-MM-DD` to Unix timestamp: `date -d "YYYY-MM-DD" +%s` -> `1714464000`

**Example calls:**

```bash
# HN stories about vibe coding from last 30 days
curl -s "https://hn.algolia.com/api/v1/search?query=vibe+coding&tags=story&numericFilters=created_at_i>1714464000&hitsPerPage=50"

# Show HN AI tools from last 30 days
curl -s "https://hn.algolia.com/api/v1/search?query=AI&tags=show_hn&numericFilters=created_at_i>1714464000&hitsPerPage=50"
```

**Why this works:** Algolia indexes HN with exact `created_at_i` timestamps. Results are guaranteed to be within the date range.

---

### GitHub Search API

Free for public repos, no auth needed for low-volume searches. Supports `created:>` and `pushed:>` qualifiers.

**Endpoint:** `https://api.github.com/search/repositories`

**Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `q` | string | Query with qualifiers | `AI codegen language:Java created:>2026-04-30` |
| `sort` | string | Sort order | `updated`, `stars` |
| `order` | string | Direction | `desc` |
| `per_page` | integer | Results per page (max 100) | `30` |

**Date qualifiers:**
- `created:>YYYY-MM-DD` — repo created after date
- `pushed:>YYYY-MM-DD` — last push after date
- `language:java` / `language:python` / `language:typescript`

**Example calls:**

```bash
# AI repos in Java updated recently
curl -s "https://api.github.com/search/repositories?q=AI+coding+assistant+language:Java+pushed:>2026-04-30&sort=updated&order=desc&per_page=30"

# React AI tools released recently
curl -s "https://api.github.com/search/repositories?q=AI+react+component+generator+pushed:>2026-04-30&sort=updated&order=desc&per_page=30"
```

---

## Tier 2: Brave Search API

Requires free API key from `https://api-dashboard.search.brave.com/`. Best general-purpose search with robust native date filtering.

**Endpoint:** `https://api.search.brave.com/res/v1/web/search`

**Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `q` | string | Search query | `"new AI IDE Java"` |
| `freshness` | string | Date filter | `pm` (31 days) or `2022-04-01to2022-07-30` |
| `result_filter` | string | Result types | `news`, `discussions`, `web` |
| `count` | integer | Results (max 20) | `20` |
| `offset` | integer | Pagination (max 9) | `0` |

**Freshness values:**
- `pd` — past 24 hours
- `pw` — past 7 days
- `pm` — past 31 days
- `py` — past 365 days
- `YYYY-MM-DDtoYYYY-MM-DD` — custom range (most reliable for exact 30-day windows)

**Goggles (domain prioritization):**
- Hacker News: `https://raw.githubusercontent.com/brave/goggles-quickstart/main/goggles/hacker_news.goggle`

**Example calls:**

```bash
# News about AI coding tools in last 31 days
curl -s -H "X-Subscription-Token: $BRAVE_API_KEY" \
  "https://api.search.brave.com/res/v1/web/search?q=new+AI+coding+tool&freshness=pm&result_filter=news&count=20"

# Discussions about vibe coding with custom date range
curl -s -H "X-Subscription-Token: $BRAVE_API_KEY" \
  "https://api.search.brave.com/res/v1/web/search?q=vibe+coding&freshness=2026-04-30to2026-05-30&result_filter=discussions&count=20"
```

**Why this works:** Brave's `freshness` uses the page's most relevant reported date (published or modified), not crawl date. Custom ranges are exact.

---

## Tier 3: News APIs

### News API (newsapi.org)

Free developer tier (100 requests/day). Good for mainstream tech news sources.

**Endpoint:** `https://newsapi.org/v2/everything`

**Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `q` | string | Search query | `"AI coding assistant"` |
| `from` | date | Start date (ISO 8601) | `2026-04-30` |
| `to` | date | End date | `2026-05-30` |
| `domains` | string | Comma-separated domains | `techcrunch.com,techradar.com` |
| `language` | string | ISO 639-1 code | `en` |
| `sortBy` | string | Order | `publishedAt`, `relevancy` |
| `pageSize` | integer | Results per page (max 100) | `50` |

**Example calls:**

```bash
# Tech news about AI coding from last 30 days
curl -s "https://newsapi.org/v2/everything?q=AI+coding+assistant&from=2026-04-30&to=2026-05-30&domains=techcrunch.com,techradar.com,theverge.com&sortBy=publishedAt&pageSize=50&apiKey=$NEWSAPI_KEY"
```

**Limitations:**
- No Hacker News, Dev.to, or GitHub Blog in source list
- 1-month historical limit on free tier for some endpoints
- Better for mainstream news than deep technical content

---

## Tier 4: Web Search Fallback

Use when APIs are unavailable or for sources without API access (Ars Technica blog, OpenJDK, React Blog, Python Insider).

### Google Search Operators

| Operator | Purpose | Reliability |
|----------|---------|-------------|
| `site:domain.com` | Restrict to source | High |
| `after:YYYY-MM-DD` | Date filter | **Low** — uses crawl date, not publish date |
| `before:YYYY-MM-DD` | Date filter | **Low** — uses crawl date, not publish date |

### Bing Search Operators

| Operator | Purpose | Reliability |
|----------|---------|-------------|
| `site:domain.com` | Restrict to source | High |
| `sortby:date` | Sort by date | Medium |
| `daterange:start-end` | Custom range | Medium — Julian date format required |

**Recommendation:** Only use web search fallback for sources that have no API. Always verify publish dates manually when using web search fallback.

---

## Source-to-Mechanism Mapping

| Source | Preferred Mechanism | Fallback |
|--------|---------------------|----------|
| Hacker News | HN Algolia API | Brave Search (goggles) |
| GitHub (repos/releases) | GitHub Search API | Brave Search |
| TechRadar | Brave Search API | Web search |
| Dev.to | Brave Search API | Web search |
| Ars Technica | Brave Search API (news filter) | Web search |
| The Verge | Brave Search API (news filter) | Web search |
| GitHub Blog | Brave Search API | Web search |
| OpenJDK Blog | Brave Search API | Web search |
| React Blog | Brave Search API | Web search |
| Python Insider | Brave Search API | Web search |

---

## Rate Limits & Cost

| API | Free Tier | Auth Required | Rate Limit |
|-----|-----------|---------------|------------|
| HN Algolia | Unlimited | No | ~10 req/min (be polite) |
| GitHub Search | 10 req/min | No (public) | 10 req/min unauthenticated |
| Brave Search API | 2,000 queries/month | Yes (free key) | ~1 req/sec |
| News API | 100 req/day | Yes (free key) | ~1 req/sec |

---

## Recommended Execution Order

1. **Run Tier 1 APIs first** — they have the most reliable date filtering and are free
2. **Run Brave Search API** for sources not covered by Tier 1, using custom `freshness` range
3. **Run News API** only if you need mainstream news coverage beyond what Brave provides
4. **Run web search fallback** only for gaps, with strict manual date verification

**Query budget:** Do not exceed 12 total API calls + web searches combined to manage response time.
