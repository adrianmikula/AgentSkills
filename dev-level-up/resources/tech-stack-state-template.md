# `.tech-stack` State Template

Use this template only during a `dev-level-up` run, after the user has chosen a scope mode. Create `.tech-stack/` at the target repository root, populate the relevant category files, and ensure `.gitignore` contains `.tech-stack/`.

This folder is local state. Do not commit it, do not store secrets, and do not include private credentials or sensitive customer data. The example rows below are illustrative only; replace them with detected or user-provided entries before using the state for search.

## Common Row Schema

Use this table shape for detected category files unless a category file defines a different schema:

```markdown
| Domain / Item | Current version or scope | Evidence | Search hints | Source hints | Confidence | Last updated | Notes |
|---------------|--------------------------|----------|--------------|--------------|------------|--------------|-------|
```

Confidence values:

- `detected` — directly evidenced by a manifest, lockfile, config, or explicit project file.
- `inferred` — strongly suggested by code structure, dependencies, scripts, or conventions.
- `manual` — supplied by the user.
- `custom` — user-defined domain that does not fit the standard categories.

---

## `.tech-stack/index.md`

```markdown
# Tech Stack Scope

- Last scan: <YYYY-MM-DD>
- Scope mode: <auto-detect | manual/custom | both | saved-state>
- Selected objectives: <objective names or All objectives>
- Repository root: <path>

| Category | File | Entries | Primary purpose |
|----------|------|---------|-----------------|
| Languages | `languages.md` | <count> | Languages and runtimes |
| Frameworks | `frameworks.md` | <count> | Frameworks, ORMs, UI/meta-frameworks |
| Libraries | `libraries.md` | <count> | Notable libraries and packages |
| Infrastructure | `infrastructure.md` | <count> | Cloud, containers, IaC, databases, platforms |
| Developer tooling | `developer-tooling.md` | <count> | Editors, CLIs, build/test/lint/debug tools |
| AI tooling | `ai-tooling.md` | <count> | Models, agents, MCP, prompts, AI coding tools |
| Patterns & practices | `patterns-practices.md` | <count> | Architecture, testing, observability, workflows |
| Risk domains | `risk-domains.md` | <count> | Security, privacy, compliance, reliability |
| Custom domains | `custom-domains.md` | <count> | User-defined domains |

## Notes

- <confidence caveats, ambiguous detections, or user corrections>
```

---

## `.tech-stack/languages.md`

```markdown
# Languages

| Domain / Item | Current version or scope | Evidence | Search hints | Source hints | Confidence | Last updated | Notes |
|---------------|--------------------------|----------|--------------|--------------|------------|--------------|-------|
| TypeScript | 5.x | package.json, tsconfig.json | TypeScript release notes AI codegen | typescriptlang.org, github.com/microsoft/TypeScript | detected | <YYYY-MM-DD> | Frontend and Node tooling |
```

---

## `.tech-stack/frameworks.md`

```markdown
# Frameworks

| Domain / Item | Current version or scope | Evidence | Search hints | Source hints | Confidence | Last updated | Notes |
|---------------|--------------------------|----------|--------------|--------------|------------|--------------|-------|
| Next.js | 15.x | package.json, next.config.ts | Next.js release notes React Server Components | nextjs.org, github.com/vercel/next.js | detected | <YYYY-MM-DD> | App Router |
```

---

## `.tech-stack/libraries.md`

```markdown
# Libraries

| Domain / Item | Current version or scope | Evidence | Search hints | Source hints | Confidence | Last updated | Notes |
|---------------|--------------------------|----------|--------------|--------------|------------|--------------|-------|
| Zod | 3.x | package.json | Zod schema validation release | zod.dev, github.com/colinhacks/zod | detected | <YYYY-MM-DD> | Runtime validation |
```

---

## `.tech-stack/infrastructure.md`

```markdown
# Infrastructure

| Domain / Item | Current version or scope | Evidence | Search hints | Source hints | Confidence | Last updated | Notes |
|---------------|--------------------------|----------|--------------|--------------|------------|--------------|-------|
| Docker | compose file, image tags | Dockerfile, docker-compose.yml | Docker release notes BuildKit | docs.docker.com, github.com/docker | detected | <YYYY-MM-DD> | Local and CI containers |
```

---

## `.tech-stack/developer-tooling.md`

```markdown
# Developer Tooling

| Domain / Item | Current version or scope | Evidence | Search hints | Source hints | Confidence | Last updated | Notes |
|---------------|--------------------------|----------|--------------|--------------|------------|--------------|-------|
| Vitest | package.json scripts | package.json | Vitest release browser mode | vitest.dev, github.com/vitest-dev/vitest | detected | <YYYY-MM-DD> | Fast unit tests |
```

---

## `.tech-stack/ai-tooling.md`

```markdown
# AI Tooling

| Domain / Item | Current version or scope | Evidence | Search hints | Source hints | Confidence | Last updated | Notes |
|---------------|--------------------------|----------|--------------|--------------|------------|--------------|-------|
| MCP servers | configured servers | .mcp.json, .devin/mcp_config.json | MCP server security tools | modelcontextprotocol.io, github.com/modelcontextprotocol | detected | <YYYY-MM-DD> | Agent tooling |
```

---

## `.tech-stack/patterns-practices.md`

```markdown
# Patterns & Practices

| Domain / Item | Current version or scope | Evidence | Search hints | Source hints | Confidence | Last updated | Notes |
|---------------|--------------------------|----------|--------------|--------------|------------|--------------|-------|
| Test-driven development | unit + integration tests | tests/, package scripts | AI-generated tests TDD agents | thoughtworks.com, martinfowler.com | inferred | <YYYY-MM-DD> | Verify before broadening |
```

---

## `.tech-stack/risk-domains.md`

```markdown
# Risk Domains

| Domain / Item | Current version or scope | Evidence | Search hints | Source hints | Confidence | Last updated | Notes |
|---------------|--------------------------|----------|--------------|--------------|------------|--------------|-------|
| AI supply-chain security | dependency and agent configs | package manifests, .mcp.json | AI-generated code vulnerabilities SBOM | owasp.org, github.blog | inferred | <YYYY-MM-DD> | Needs user confirmation if broad |
```

---

## `.tech-stack/custom-domains.md`

Use this file for user-defined domains that do not fit the categories above. It may also hold cross-category manual entries when the user wants a single place to review them.

```markdown
# Custom Domains

| Domain | Category | Objective tags | Current version or scope | Search hints | Source hints | Confidence | Last updated | Notes |
|--------|----------|----------------|--------------------------|--------------|--------------|------------|--------------|-------|
| Payments modernisation | risk-domains | AI-era security, modernization | Stripe + legacy processor | payments API agent workflows | stripe.com/docs, owasp.org | manual | <YYYY-MM-DD> | User-provided priority |
```

---

## `.gitignore` Addition

Ensure the target repository `.gitignore` contains:

```gitignore
# dev-level-up local scope state (never commit)
.tech-stack/
```
