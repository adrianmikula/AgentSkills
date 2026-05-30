# Source Search Templates

This file provides both **API call templates** (preferred) and **web search fallback templates** for each source. Substitute `YYYY-MM-DD` with 30 days before today. Substitute `{{LANG}}` with `Java`, `React`, `Python`, or omit for language-agnostic searches. Substitute `{{FOCUS_KEYWORDS}}` with the keyword set from the relevant focus area below.

**Execution order:** Use API templates first. Fall back to web search only if APIs are unavailable for a given source.

Run multiple queries per focus area to maximise coverage, then deduplicate results by URL before evaluation.

---

## Focus Area Keyword Sets

Use these keyword sets to populate `{{FOCUS_KEYWORDS}}` in the source-specific templates below.

| Focus Area | Primary Keywords | Secondary Keywords |
|------------|------------------|-------------------|
| **Vibe coding speed** | `vibe coding`, `AI pair programming`, `10x developer`, `AI codegen speed`, `cursor rules`, `windsurf rules` | `AI autocomplete`, `real-time AI suggestions`, `zero-shot codegen`, `prompt-to-code` |
| **Code quality assurance** | `AI code review`, `LLM-generated tests`, `AI test coverage`, `contract-based AI codegen`, `type-safe AI`, `AI linting` | `self-healing code`, `AI bug detection`, `generated unit tests`, `AI static analysis` |
| **AI-era security** | `AI-generated vulnerabilities`, `LLM supply chain`, `AI code injection`, `prompt injection defence`, `AI SAST`, `MCP security` | `AI secrets leakage`, `autonomous agent security`, `AI CWE`, `generated code audit` |
| **AI workflow orchestration** | `multi-agent AI`, `AI workflow orchestration`, `MCP server`, `agentic coding pipeline`, `AI devops automation`, `LangChain coding` | `AI CI/CD`, `agent swarm`, `orchestrated AI codegen`, `sequential AI tasks` |
| **MVP acceleration** | `AI MVP builder`, `vibe coding startup`, `AI full-stack scaffold`, `monetisable AI product`, `no-code AI`, `AI SaaS boilerplate` | `AI landing page generator`, `AI backend scaffold`, `rapid AI prototype`, `ship fast AI` |
| **Tech debt modernisation** | `AI code migration`, `automated refactoring`, `AI legacy modernisation`, `AI dependency upgrade`, `AI Jakarta migration`, `AI React migration` | `AI dead code elimination`, `AI architecture migration`, `safe AI refactoring`, `AI codemod` |
| **Bleeding-edge tools & integrations** | `new AI IDE`, `AI coding assistant launch`, `AI CLI tool`, `AI dev tool integration`, `cutting-edge AI codegen`, `AI plugin ecosystem` | `experimental AI tool`, `beta AI developer tool`, `AI toolchain innovation`, `next-gen AI coding` |

---

## API Templates (Preferred)

Load `resources/search-api-guide.md` for full authentication, rate limit, and parameter details.

### Hacker News Algolia API

**Base:** `https://hn.algolia.com/api/v1/search`

**Date math:** Convert `YYYY-MM-DD` to Unix timestamp: `date -d "YYYY-MM-DD" +%s`

| Focus Area | Template |
|------------|----------|
| Vibe coding speed | `?query={{FOCUS_KEYWORDS}}&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=50` |
| Code quality assurance | `?query={{FOCUS_KEYWORDS}}&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=50` |
| AI-era security | `?query={{FOCUS_KEYWORDS}}&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=50` |
| AI workflow orchestration | `?query={{FOCUS_KEYWORDS}}&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=50` |
| MVP acceleration | `?query={{FOCUS_KEYWORDS}}&tags=show_hn&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=50` |
| Tech debt modernisation | `?query={{FOCUS_KEYWORDS}}&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=50` |
| Bleeding-edge tools | `?query={{FOCUS_KEYWORDS}}&tags=show_hn&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=50` |

**Example (Vibe coding speed, 30 days):**
```
https://hn.algolia.com/api/v1/search?query=vibe+coding&tags=story&numericFilters=created_at_i>1714464000&hitsPerPage=50
```

---

### GitHub Search API

**Base:** `https://api.github.com/search/repositories`

| Language | Template |
|----------|----------|
| Java | `?q={{FOCUS_KEYWORDS}}+language:Java+pushed:>YYYY-MM-DD&sort=updated&order=desc&per_page=30` |
| React | `?q={{FOCUS_KEYWORDS}}+language:TypeScript+pushed:>YYYY-MM-DD&sort=updated&order=desc&per_page=30` |
| Python | `?q={{FOCUS_KEYWORDS}}+language:Python+pushed:>YYYY-MM-DD&sort=updated&order=desc&per_page=30` |
| All | `?q={{FOCUS_KEYWORDS}}+pushed:>YYYY-MM-DD&sort=updated&order=desc&per_page=30` |

**Example (Bleeding-edge tools, Java, 30 days):**
```
https://api.github.com/search/repositories?q=new+AI+IDE+language:Java+pushed:>2026-04-30&sort=updated&order=desc&per_page=30
```

---

### Brave Search API

**Base:** `https://api.search.brave.com/res/v1/web/search`

**Headers:** `X-Subscription-Token: $BRAVE_API_KEY`

**Parameters:** `q`, `freshness=YYYY-MM-DDtoYYYY-MM-DD`, `result_filter`, `count=20`, `offset=0`

| Source | `result_filter` | Template |
|--------|-----------------|----------|
| TechRadar | `news,web` | `?q={{FOCUS_KEYWORDS}}+{{LANG}}+site:techradar.com&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |
| Dev.to | `discussions,web` | `?q={{FOCUS_KEYWORDS}}+{{LANG}}+site:dev.to&freshness={{START}}to{{END}}&result_filter=discussions,web&count=20` |
| Ars Technica | `news,web` | `?q={{FOCUS_KEYWORDS}}+site:arstechnica.com&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |
| The Verge | `news,web` | `?q={{FOCUS_KEYWORDS}}+site:theverge.com&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |
| GitHub Blog | `news,web` | `?q={{FOCUS_KEYWORDS}}+{{LANG}}+site:github.blog&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |
| OpenJDK | `web` | `?q=AI+codegen+site:openjdk.org&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| React Blog | `web` | `?q=AI+site:react.dev/blog&freshness={{START}}to{{END}}&result_filter=web&count=20` |
| Python Insider | `web` | `?q=developer+productivity+site:blog.python.org&freshness={{START}}to{{END}}&result_filter=web&count=20` |

**Hacker News Goggle (alternative to Algolia):**
```
?q={{FOCUS_KEYWORDS}}&freshness={{START}}to{{END}}&result_filter=discussions&count=20&goggles_id=https://raw.githubusercontent.com/brave/goggles-quickstart/main/goggles/hacker_news.goggle
```

---

## Web Search Fallback Templates

Only use these if the APIs above are unavailable.

### TechRadar
- `site:techradar.com {{FOCUS_KEYWORDS}} {{LANG}} after:YYYY-MM-DD`
- `site:techradar.com "AI" "developer tool" {{LANG}} after:YYYY-MM-DD`

### Hacker News
- `site:news.ycombinator.com {{FOCUS_KEYWORDS}} {{LANG}} after:YYYY-MM-DD`
- `site:news.ycombinator.com "Show HN" {{LANG}} AI after:YYYY-MM-DD`
- `site:news.ycombinator.com "Ask HN" AI coding after:YYYY-MM-DD`

### Dev.to
- `site:dev.to {{FOCUS_KEYWORDS}} {{LANG}} after:YYYY-MM-DD`
- `site:dev.to "tutorial" AI {{LANG}} after:YYYY-MM-DD`

### Ars Technica
- `site:arstechnica.com {{FOCUS_KEYWORDS}} after:YYYY-MM-DD`
- `site:arstechnica.com "AI" "software development" after:YYYY-MM-DD`

### The Verge
- `site:theverge.com {{FOCUS_KEYWORDS}} after:YYYY-MM-DD`
- `site:theverge.com "AI" "developer" after:YYYY-MM-DD`

### GitHub Blog
- `site:github.blog {{FOCUS_KEYWORDS}} after:YYYY-MM-DD`
- `site:github.blog Copilot {{LANG}} after:YYYY-MM-DD`

### GitHub Search (Repos & Releases)
- `site:github.com {{FOCUS_KEYWORDS}} {{LANG}} after:YYYY-MM-DD`
- `site:github.com {{LANG}} "AI" "released" OR "launch" after:YYYY-MM-DD`

### OpenJDK Blog (Java only)
- `site:openjdk.org AI codegen after:YYYY-MM-DD`
- `site:openjdk.org "JEP" developer productivity after:YYYY-MM-DD`

### React Blog (React only)
- `site:react.dev/blog AI after:YYYY-MM-DD`
- `site:react.dev "React Compiler" AI after:YYYY-MM-DD`

### Python Insider (Python only)
- `site:blog.python.org developer productivity after:YYYY-MM-DD`
- `site:blog.python.org "PEP" AI after:YYYY-MM-DD`

---

## All-Focus-Area Sweep (When Focus Area = "All")

When the human selects `All focus areas`, run one representative query from each focus area using the primary keyword set. Combine results and rank by total 5-axis score. Do not exceed 12 total queries to manage response time.

**Recommended sweep using APIs:**

| # | Focus Area | Mechanism | Query |
|---|-----------|-----------|-------|
| 1 | Vibe coding speed | HN Algolia | `?query=vibe+coding&tags=story&numericFilters=created_at_i>{{TIMESTAMP}}&hitsPerPage=30` |
| 2 | Code quality assurance | Brave Search | `?q=AI+code+review+site:dev.to&freshness={{START}}to{{END}}&result_filter=discussions,web&count=20` |
| 3 | AI-era security | Brave Search | `?q=prompt+injection+AI+security+site:arstechnica.com&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |
| 4 | AI workflow orchestration | Brave Search | `?q=MCP+server+multi-agent+site:github.blog&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |
| 5 | MVP acceleration | Brave Search | `?q=AI+MVP+builder+site:theverge.com&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |
| 6 | Tech debt modernisation | Brave Search | `?q=AI+code+migration+site:dev.to&freshness={{START}}to{{END}}&result_filter=discussions,web&count=20` |
| 7 | Bleeding-edge tools | Brave Search | `?q=new+AI+IDE+site:techradar.com&freshness={{START}}to{{END}}&result_filter=news,web&count=20` |
| 8 | GitHub repos | GitHub Search | `?q=AI+coding+assistant+pushed:>YYYY-MM-DD&sort=updated&order=desc&per_page=20` |

**Note:** If `All` languages is selected, add the language qualifier to the GitHub Search queries and append `{{LANG}}` to Brave Search `q` parameters where relevant. Do not duplicate identical queries.
