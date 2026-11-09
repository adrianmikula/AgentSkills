# Source Registry

This registry defines the source classes, seed sources, and dynamic source-derivation rules used by `dev-level-up`. It is intentionally broader than a fixed news-site list: the skill should search the places where the detected stack, objective, and AI tooling ecosystem actually publish advances.

## Authority Model

| Tier | Class | Trust Rule |
|------|-------|------------|
| A | Primary ecosystem sources | Official docs, blogs, release notes, changelogs, package registries, standards bodies, vendor engineering posts. Highest authority for versions and capabilities. |
| B | High-authority research/community | Recognised practitioner blogs, conference talks, research papers, whitepapers, standards discussions. Strong for techniques and early signals. |
| C | High-signal community | Hacker News, Lobsters, technically focused discussions with corroboration. Useful for validation and adoption friction. |
| D | General tech media | Broad product/market coverage. Good for discovery, but technical claims should be corroborated by A/B/C sources before Quick Win classification. |

A candidate can pass with Tier D only if the claim is low-risk and clearly labelled as secondary reporting; otherwise seek corroboration or classify as `Watch`/`Deep Dive`.

---

## Source Classes

### 1. Primary Ecosystem Sources

Use for version upgrades, breaking changes, new APIs, official techniques, package releases, and standards.

Typical sources:

- Official project blogs and changelogs.
- Official docs and migration guides.
- Release notes and GitHub releases.
- Package registries and metadata APIs.
- Standards bodies and foundation sites.
- Vendor engineering blogs for platforms and infrastructure.

Query patterns:

- `{{DOMAIN}} changelog {{START}}..{{END}}`
- `{{DOMAIN}} release notes {{OBJECTIVE_KEYWORDS}}`
- `{{PACKAGE_NAME}} latest release {{ECOSYSTEM}}`
- `site:{{SOURCE_DOMAIN}} {{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}}`

### 2. High-Authority Community and Research Sources

Use only for high-signal sources. Do not treat all Reddit/forums as authoritative; prefer sources with technical depth, practitioner reputation, or research rigour.

Typical sources:

- Hacker News discussions and Show HN.
- Lobsters.
- Recognised industry practitioner blogs.
- Conference talks and proceedings.
- Research papers, preprints, whitepapers, and technical reports.
- Engineering blogs from respected organisations.

Query patterns:

- `{{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} site:news.ycombinator.com`
- `{{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} practitioner blog`
- `{{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} conference talk`
- `{{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} paper whitepaper`

### 3. AI Vendor and Coding-Tool Feeds

Use for AI models, agents, IDEs, MCP servers, coding assistants, prompt/workflow techniques, evals, and AI-era tooling.

Seed domains/examples:

- OpenAI: `openai.com`, `platform.openai.com`
- Anthropic: `anthropic.com`, `docs.anthropic.com`
- Google AI/DeepMind: `deepmind.google`, `ai.google.dev`, `blog.google`
- GitHub: `github.blog`, `github.com/features`, `docs.github.com`
- Cursor: `cursor.com`
- JetBrains: `jetbrains.com`, `blog.jetbrains.com`
- Windsurf/Codeium: `windsurf.com`, `codeium.com`
- Sourcegraph: `sourcegraph.com`
- Replit: `replit.com`
- Vercel: `vercel.com`
- Cognition/Devin: `cognition.ai`, `devin.ai`
- MCP ecosystem: `modelcontextprotocol.io`, `github.com/modelcontextprotocol`
- Agent/coding tools: `continue.dev`, `cline.bot`, `aider.chat`, `openhands.dev`

Query patterns:

- `{{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} site:{{SOURCE_DOMAIN}}`
- `AI coding tool {{DOMAIN_KEYWORDS}} changelog`
- `MCP server {{DOMAIN_KEYWORDS}} security`
- `{{PACKAGE_NAME}} GitHub release AI`

### 4. General Tech Media

Use for broad discovery and market/ecosystem context.

Seed domains/examples:

- `techradar.com`
- `arstechnica.com`
- `theverge.com`
- `theregister.com`
- `zdnet.com`
- `venturebeat.com`
- `techcrunch.com`
- `thenewstack.io`
- `sdtimes.com`
- `infoworld.com`
- `cio.com`
- `devops.com`

Query patterns:

- `{{DOMAIN_KEYWORDS}} {{OBJECTIVE_KEYWORDS}} site:{{SOURCE_DOMAIN}}`
- `{{DOMAIN}} AI coding breakthrough`
- `{{DOMAIN}} developer tool launch`

### 5. Standards and Ecosystem Bodies

Use when a domain has formal standards, foundations, or ecosystem governance.

Seed domains/examples:

- `w3.org`
- `whatwg.org`
- `ietf.org`
- `ecma-international.org`
- `openjsf.org`
- `cncf.io`
- `owasp.org`
- `kubernetes.io`
- `opentelemetry.io`

Query patterns:

- `{{DOMAIN}} standard update {{OBJECTIVE_KEYWORDS}}`
- `{{DOMAIN}} specification change`
- `site:{{SOURCE_DOMAIN}} {{DOMAIN_KEYWORDS}}`

---

## High-Authority Community Seeds

Use sparingly and prefer corroboration for technical claims.

| Source | Domain | Best For |
|--------|--------|----------|
| Hacker News | `news.ycombinator.com` | Show HN launches, community validation, early tooling signals |
| Lobsters | `lobste.rs` | High-signal technical discussion |
| Simon Willison | `simonwillison.net` | AI tooling, LLM workflows, practical experimentation |
| Martin Fowler | `martinfowler.com` | Architecture, refactoring, enterprise patterns |
| Addy Osmani | `addyo.me` | Web platform, performance, engineering practice |
| Julia Evans | `jvns.ca` | Developer tooling, debugging, systems concepts |
| Dan Luu | `danluu.com` | Benchmarks, systems, empirical engineering |
| LeadDev | `leaddev.com` | Engineering leadership, process, team productivity |
| InfoQ | `infoq.com` | Enterprise software, architecture, conference coverage |
| QCon | `qconferences.com` | Practitioner talks and patterns |
| arXiv | `arxiv.org` | AI/ML research relevant to coding tools and techniques |
| Papers With Code | `paperswithcode.com` | Research-to-implementation bridge |

Do not assume these sources cover every stack. Derive stack-specific practitioner sources from official communities, conference agendas, package ecosystems, and recognised experts in that domain.

---

## Dynamic Source Derivation

For every `.tech-stack/` row, derive candidate sources before searching:

1. **Canonical identity:** domain name, package name, GitHub org/repo, Maven group/artifact, Cargo crate, Go module, NuGet package, RubyGems package, Packagist package.
2. **Official web presence:** project site, docs subdomain, blog subdomain, changelog path, releases page.
3. **Package registry:** npm, PyPI, crates.io, Maven Central, NuGet, RubyGems, Packagist, Go module proxy, Docker Hub, Helm charts, Terraform Registry.
4. **Code/release source:** GitHub/GitLab/Bitbucket repo, release tags, issues, discussions.
5. **Ecosystem bodies:** language foundation, framework foundation, cloud provider docs, standards body.
6. **AI/vendor feeds:** if the domain is AI-related or the objective is agentic/AI tooling, add relevant vendor blogs, changelogs, MCP sources, and model/provider docs.
7. **Community sources:** add HN/Lobsters/search queries only if the domain has meaningful public discussion; add domain-specific recognised blogs/conferences when known.

If `.tech-stack/` rows include `Search hints` or `Source hints`, treat them as user/agent-provided seeds and verify them before relying on them.

---

## Source Selection Rules

- Start with sources most likely to publish fresh, dated, actionable findings.
- For versioned libraries/frameworks, official changelogs/release notes outrank news articles.
- For AI tooling, vendor changelogs/docs outrank generic AI news.
- For techniques and patterns, recognised practitioner blogs, conference talks, and papers can outrank vendor marketing.
- For adoption friction and community sentiment, use HN/Lobsters only as supporting evidence.
- For custom/manual domains, ask for or infer source hints if no obvious official source exists.
- Do not search low-authority SEO content unless it is the only available signal; then classify cautiously.

---

## Query Budget Guidance

The default budget is defined in `resources/search-api-guide.md`. When scope is broad:

1. Prioritise domains marked `manual`/`custom`.
2. Prioritise domains with current versions and clear upgrade paths.
3. Prioritise objectives explicitly selected by the user.
4. Use `All objectives` only for a balanced sweep, not exhaustive coverage.
5. If the budget is exhausted, report the domains/objectives that were searched and the ones deferred.
