# Source Search Templates

This file provides API call templates (preferred), feed patterns, and web-search fallback templates for `dev-level-up`. It is language-agnostic: substitute placeholders from the user's `.tech-stack/` state and selected objectives.

## Placeholders

| Placeholder | Meaning | Example |
|-------------|---------|---------|
| `{{DOMAIN}}` | Canonical domain name | `Next.js`, `Terraform`, `MCP security` |
| `{{DOMAIN_ALIASES}}` | Aliases, package names, short names | `nextjs`, `npm:next`, `terraform` |
| `{{DOMAIN_KEYWORDS}}` | Concise keywords for the domain | `Next.js React Server Components` |
| `{{OBJECTIVE_KEYWORDS}}` | Keywords for the selected objective | `AI code review generated tests` |
| `{{ECOSYSTEM}}` | Package manager/platform/ecosystem | `npm`, `PyPI`, `crates.io`, `Maven`, `GitHub` |
| `{{PACKAGE_NAME}}` | Exact package/module/crate name | `next`, `pydantic`, `tokio` |
| `{{CURRENT_VERSION}}` | Detected current version, if known | `15.3.x`, `2.8` |
| `{{SOURCE_DOMAIN}}` | Domain being searched | `nextjs.org`, `cursor.com`, `modelcontextprotocol.io` |
| `{{TOPIC}}` | GitHub topic or ecosystem topic | `developer-tools`, `ai-agents` |
| `{{GITHUB_ORG}}` | GitHub organisation/user, when known | `vercel`, `modelcontextprotocol` |
| `{{LANGUAGE}}` | GitHub language qualifier, only when known | `TypeScript`, `Python`, `Go` |
| `{{START}}` / `{{END}}` | 30-day date window | `2026-10-10` / `2026-11-09` |
| `{{TIMESTAMP}}` | Unix timestamp for 30 days ago | `1767225600` |

Load `resources/improvement-objectives.md` for objective keyword sets and `resources/source-registry.md` for source classes and seed domains.

**Execution order:** Use API/feed templates first. Fall back to web search only if APIs or feeds are unavailable for a given source.

Run multiple targeted queries per objective-domain pair, then deduplicate by URL and underlying announcement before evaluation.

---

## API Templates (Preferred)

### Hacker News Algolia API

**Base:** `https://hn.algolia.com/api/v1/search`

**Date math:** Convert `YYYY-MM-DD` to Unix timestamp: `date -d "YYYY-MM-DD" +%s`

| Query Pattern | Template |
|---------------|----------|
| Domain + objective stories | `?query={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=30` |
| Domain launches | `?query={{DOMAIN_KEYWORDS}}+launch&tags=show_hn&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=30` |
| AI/tooling validation | `?query={{OBJECTIVE_KEYWORDS}}+AI+coding&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=30` |
| Custom/manual domain | `?query={{DOMAIN}}+{{OBJECTIVE_KEYWORDS}}&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=30` |

**Example:**

```text
https://hn.algolia.com/api/v1/search?query=MCP+server+security&tags=story&numericFilters=created_at_i>1767225600&hitsPerPage=30
```

---

### GitHub Search API

**Base:** `https://api.github.com/search/repositories`

| Query Pattern | Template |
|---------------|----------|
| Domain + objective repos | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+pushed:>{{START}}&sort=updated&order=desc&per_page=30` |
| Topic-constrained | `?q={{DOMAIN_KEYWORDS}}+topic:{{TOPIC}}+pushed:>{{START}}&sort=updated&order=desc&per_page=30` |
| Language-constrained | `?q={{DOMAIN_KEYWORDS}}+language:{{LANGUAGE}}+pushed:>{{START}}&sort=updated&order=desc&per_page=30` |
| Org-constrained | `?q={{DOMAIN_KEYWORDS}}+org:{{GITHUB_ORG}}+pushed:>{{START}}&sort=updated&order=desc&per_page=30` |
| AI tooling | `?q={{OBJECTIVE_KEYWORDS}}+AI+agent+pushed:>{{START}}&sort=updated&order=desc&per_page=30` |

**Example:**

```text
https://api.github.com/search/repositories?q=AI+code+review+topic:developer-tools+pushed:>2026-10-10&sort=updated&order=desc&per_page=30
```

---

### GitHub Releases API

**Base:** `https://api.github.com/repos/{owner}/{repo}/releases?per_page=30`

Use when `.tech-stack/` or source derivation identifies a specific repository. Keep only releases whose `published_at` falls inside the 30-day window.

---

### arXiv API

**Base:** `https://export.arxiv.org/api/query`

| Query Pattern | Template |
|---------------|----------|
| AI/coding research | `?search_query=all:{{DOMAIN_KEYWORDS}}+AND+all:{{OBJECTIVE_KEYWORDS}}&sortBy=submittedDate&sortOrder=descending&max_results=10` |
| Verification/security research | `?search_query=cat:cs.SE+AND+all:{{OBJECTIVE_KEYWORDS}}&sortBy=submittedDate&sortOrder=descending&max_results=10` |

Verify submission/published dates before inclusion.

---

## Brave Search API Templates

**Base:** `https://api.search.brave.com/res/v1/web/search`
**Headers:** `X-Subscription-Token: $BRAVE_API_KEY`
**Parameters:** `q`, `freshness={{START}}to{{END}}`, `result_filter`, `count=20`, `offset=0`

### Official / Primary Sources

| Source Type | Template |
|-------------|----------|
| Official domain | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+site:{{SOURCE_DOMAIN}}&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| Changelog/release notes | `?q={{DOMAIN}}+changelog+OR+release+notes+{{OBJECTIVE_KEYWORDS}}+site:{{SOURCE_DOMAIN}}&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| Docs/migration | `?q={{DOMAIN}}+migration+OR+upgrade+guide+{{OBJECTIVE_KEYWORDS}}&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| Package ecosystem | `?q={{PACKAGE_NAME}}+{{ECOSYSTEM}}+release+{{OBJECTIVE_KEYWORDS}}&freshness={{START}}to{{END}}&result_filter=web&count=20` |

### AI Vendor Feeds

| Source Type | Template |
|-------------|----------|
| Vendor domain | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+site:{{SOURCE_DOMAIN}}&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| AI coding tools | `?q=AI+coding+tool+{{DOMAIN_KEYWORDS}}+changelog&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| MCP ecosystem | `?q=MCP+server+{{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| Agent frameworks | `?q=multi-agent+{{DOMAIN_KEYWORDS}}+framework+release&freshness={{START}}to{{END}}&result_filter=web&count=20` |

### High-Authority Community / Research

| Source Type | Template |
|-------------|----------|
| Hacker News via Brave | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}&freshness={{START}}to{{END}}&result_filter=discussions&count=20&goggles_id=https://raw.githubusercontent.com/brave/goggles-quickstart/main/goggles/hacker_news.goggle` |
| Lobsters | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+site:lobste.rs&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| Practitioner blogs | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+engineering+blog&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| Conference talks | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+conference+talk&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| Papers/whitepapers | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+paper+OR+whitepaper&freshness={{START}}to{{END}}&result_filter=web&count=20` |

### General Tech Media

| Source Type | Template |
|-------------|----------|
| Media domain | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+site:{{SOURCE_DOMAIN}}&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |
| Broad discovery | `?q={{DOMAIN}}+AI+developer+tool+{{OBJECTIVE_KEYWORDS}}&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |

---

## RSS / Atom / Feed Patterns

Try these paths on official domains before web-search fallback:

```text
{{SOURCE_DOMAIN}}/feed
{{SOURCE_DOMAIN}}/feed.xml
{{SOURCE_DOMAIN}}/rss.xml
{{SOURCE_DOMAIN}}/atom.xml
{{SOURCE_DOMAIN}}/blog/feed
{{SOURCE_DOMAIN}}/changelog.xml
{{SOURCE_DOMAIN}}/releases.atom
```

Keep only feed items with `pubDate`, `published`, `updated`, or equivalent inside the 30-day window. If dates are absent, verify the item page manually.

---

## News API Template

**Endpoint:** `https://newsapi.org/v2/everything`

Use only for mainstream media gaps:

```text
?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}&from={{START}}&to={{END}}&domains=techcrunch.com,thenewstack.io,theverge.com&sortBy=publishedAt&pageSize=50&apiKey=$NEWSAPI_KEY
```

---

## Web Search Fallback Templates

Only use these if APIs and feeds are unavailable. Always verify publish dates manually.

### Official / Primary

```text
site:{{SOURCE_DOMAIN}} {{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} after:{{START}}
site:{{SOURCE_DOMAIN}} {{DOMAIN}} changelog release notes after:{{START}}
{{PACKAGE_NAME}} {{ECOSYSTEM}} release notes after:{{START}}
```

### AI Vendor / MCP

```text
site:{{SOURCE_DOMAIN}} {{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} after:{{START}}
AI coding tool {{DOMAIN_KEYWORDS}} changelog after:{{START}}
MCP server {{DOMAIN_KEYWORDS}} security after:{{START}}
```

### Community / Research

```text
site:news.ycombinator.com {{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} after:{{START}}
site:lobste.rs {{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} after:{{START}}
{{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} conference talk after:{{START}}
{{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} paper whitepaper after:{{START}}
```

### General Media

```text
site:{{SOURCE_DOMAIN}} {{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} after:{{START}}
{{DOMAIN}} AI developer tool {{OBJECTIVE_KEYWORDS}} after:{{START}}
```

---

## All-Objective / All-Domain Sweep

When the user selects broad scope, do not try to cover everything. Build a prioritised sweep:

1. Rank `.tech-stack/` domains by user priority, recency of version evidence, and likely upgrade impact.
2. Rank objectives by whether the user selected them explicitly or accepted `All objectives`.
3. Allocate queries to the highest-value domain-objective pairs first.
4. Use one representative query per pair across the most relevant source class.
5. Fill remaining budget with official changelog/release-note searches for top versioned domains.

**Recommended sweep pattern:**

| # | Purpose | Mechanism | Query |
|---|---------|-----------|-------|
| 1 | Top domain official updates | Brave `site:` | `?q={{DOMAIN_KEYWORDS}}+changelog+release+{{OBJECTIVE_KEYWORDS}}+site:{{SOURCE_DOMAIN}}&freshness={{START}}to{{END}}` |
| 2 | Top domain community signal | HN Algolia | `?query={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}` |
| 3 | AI/tooling advances | Brave vendor | `?q=AI+coding+{{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}&freshness={{START}}to{{END}}` |
| 4 | GitHub ecosystem | GitHub Search | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+pushed:>{{START}}&sort=updated` |
| 5 | Research/practitioner signal | Brave/arXiv | `?q={{DOMAIN_KEYWORDS}}+{{OBJECTIVE_KEYWORDS}}+paper+OR+conference+talk` |
| 6 | Package/version evidence | Registry API | `{{PACKAGE_NAME}}` metadata endpoint from `search-api-guide.md` |

**Budget rule:** Do not exceed 18 total API calls + web searches by default. If the scope is broad, report deferred domains/objectives in the executive summary.
