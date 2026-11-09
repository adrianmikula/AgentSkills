# Improvement Objectives

This catalog defines the targeted objectives used to generate, narrow, score, and recommend `dev-level-up` findings. Objectives are not just report labels; they determine which searches are worth running and which candidates deserve detailed evaluation.

## How Objectives Are Used

1. **Candidate generation:** combine each selected objective with relevant `.tech-stack/` domains to form search queries.
2. **Admission gating:** reject candidates that do not clearly advance at least one selected objective.
3. **Narrowing:** prefer candidates with direct objective fit and concrete adoption paths when the candidate set is large.
4. **Scoring:** the `Objective Fit` axis in `resources/evaluation-rubric.md` measures how directly a finding advances the selected objective.
5. **Recommendation:** the 80/20 picks must fit the user's time budget and selected objectives, not merely have high generic scores.

If the user selects `All objectives`, generate a balanced sweep across all objectives but still record the best-matching objective for every finding.

---

## Objective Catalog

| Objective | Definition | Candidate Signals | Query Keywords | Negative Filters |
|-----------|------------|-------------------|----------------|------------------|
| **Agentic velocity** | Tools, patterns, and workflows that make AI-assisted coding faster without sacrificing control. | AI pair programming, agentic IDEs, context engines, spec-driven development, agent skills, faster codegen loops, repository-aware assistants. | `AI pair programming`, `agentic coding`, `codegen latency`, `context engine`, `spec-driven development`, `agent skills`, `AI IDE` | Generic model hype with no coding workflow, consumer AI assistants unrelated to development |
| **Correctness & verification** | Techniques that improve the correctness of human- and AI-generated code. | AI code review, generated tests, property-based testing, type inference, evals, mutation testing, contract tests, formal methods. | `AI code review`, `LLM-generated tests`, `property-based testing`, `type-safe AI`, `mutation testing`, `AI evals`, `contract testing` | Vague "AI writes better code" claims without verification evidence |
| **AI-era security** | Security risks and defences introduced or amplified by AI coding, agents, MCP, and generated dependencies. | Prompt injection, AI SAST, secrets detection, SBOM, supply-chain security, agent guardrails, MCP security, AI code vulnerabilities. | `prompt injection`, `AI SAST`, `AI-generated vulnerabilities`, `MCP security`, `AI supply chain`, `secrets detection`, `agent guardrails` | General security news unrelated to AI-assisted development or the repo's stack |
| **Workflow orchestration** | Multi-step, multi-agent, or automated development workflows across coding, review, CI/CD, and operations. | Multi-agent pipelines, MCP servers, agent orchestration frameworks, CI/CD agents, workflow automation, eval-driven agents. | `multi-agent coding`, `MCP server`, `agent orchestration`, `AI CI/CD`, `workflow automation`, `agent swarm`, `coding agents` | Single-model demos with no orchestration or integration path |
| **Modernization & tech debt** | Safe upgrades, migrations, codemods, dependency updates, and architecture modernisation for detected stacks. | Framework upgrades, language version migrations, automated refactoring, codemods, deprecation replacements, dependency major-version upgrades. | `migration`, `codemod`, `automated refactoring`, `dependency upgrade`, `framework upgrade`, `legacy modernisation`, `breaking changes` | Upgrade advice for stacks not present in `.tech-stack/` unless explicitly requested |
| **Capability expansion** | New platform, language, framework, model, or ecosystem capabilities that unlock work the repo could not previously do. | New language features, runtime capabilities, browser/platform APIs, database features, model capabilities, edge capabilities, protocol advances. | `new language feature`, `new framework capability`, `platform API`, `runtime feature`, `model capability`, `protocol update`, `edge runtime` | Research previews with no usable artifact or unclear relevance |
| **Toolchain & developer experience** | Editors, CLIs, build tools, test runners, debuggers, profilers, formatters, local environments, and agent configs. | IDE plugins, CLI tools, faster test runners, debug/profiling improvements, devcontainer improvements, lint/format/typecheck upgrades. | `IDE plugin`, `CLI tool`, `test runner`, `debugger`, `profiler`, `linter`, `devcontainer`, `developer experience` | Productivity thought pieces without a concrete tool or workflow change |
| **MVP & product speed** | Ways to move from idea to working product faster, especially for new projects or early-stage products. | Full-stack scaffolds, AI MVP builders, boilerplates, rapid prototyping, no-code/low-code where appropriate, launch tooling. | `AI MVP builder`, `full-stack scaffold`, `rapid prototype`, `SaaS boilerplate`, `ship fast`, `no-code AI`, `prototype tooling` | Generic startup advice unrelated to technical implementation |

---

## Candidate Generation Rules

### Domain-Objective Matrix

For each selected objective, identify the `.tech-stack/` domains most likely to produce relevant candidates:

- **Agentic velocity:** AI tooling, developer tooling, frameworks with AI features, agent configs, editor integrations.
- **Correctness & verification:** testing frameworks, type systems, lint/static analysis, CI quality gates, generated-test tools.
- **AI-era security:** risk domains, dependencies, AI tooling, CI/CD, auth/secrets handling, MCP/agent configs.
- **Workflow orchestration:** AI tooling, CI/CD, developer tooling, infrastructure automation, agent frameworks.
- **Modernization & tech debt:** languages, frameworks, libraries, infrastructure, package ecosystems, current versions.
- **Capability expansion:** languages, frameworks, platforms, infrastructure, protocols, model/tool capabilities.
- **Toolchain & developer experience:** developer tooling, CI/CD, local dev infrastructure, editor/agent configs.
- **MVP & product speed:** frameworks, scaffolding tools, deployment platforms, AI tooling, libraries that reduce build effort.

### Query Construction

For each objective-domain pair:

1. Start with the domain's canonical name, aliases, and package names from `.tech-stack/`.
2. Add the objective's primary keywords.
3. Add version/change keywords where relevant: `release`, `changelog`, `migration`, `upgrade`, `breaking change`, `new`, `beta`, `GA`.
4. Search official sources first for versioned domains.
5. Search AI vendor and community sources for agentic/AI objectives.
6. Merge duplicate coverage before scoring.

Example combinations:

- `Next.js` + `Modernization & tech debt` → `Next.js 16 release migration upgrade`
- `Terraform` + `Capability expansion` → `Terraform/OpenTofu new provider capabilities`
- `MCP servers` + `AI-era security` → `MCP server security prompt injection tools`
- `pytest` + `Correctness & verification` → `pytest AI-generated tests property-based testing`

---

## Narrowing Rules

Use these rules when the candidate set exceeds the evaluation budget:

1. **Direct stack fit beats generic relevance.** A Next.js-specific release outranks generic "AI coding is faster" content for a Next.js repo.
2. **Selected objective beats incidental benefit.** A security tool that also speeds coding belongs under `AI-era security` if that objective was selected; otherwise it can still qualify through `Agentic velocity` only if the benefit is concrete.
3. **Primary evidence beats commentary.** Prefer release notes, docs, repos, papers, and benchmarks over listicles.
4. **Actionable artifacts beat abstract advice.** Prefer installable tools, version upgrades, configs, codemods, and workflows over vague best practices.
5. **Recency within 30 days is mandatory.** Do not relax the date filter to fill the report.
6. **Do not force coverage.** If a domain has no qualifying findings, say so rather than padding with irrelevant items.

---

## Objective Fit Scoring Guide

The `Objective Fit` axis is scored 1–5:

| Score | Meaning |
|-------|---------|
| 5 | Directly advances the selected objective for the detected stack; adoption path is clear. |
| 4 | Strongly advances the objective with minor adaptation or setup. |
| 3 | Partially advances the objective or applies to an adjacent domain. |
| 2 | Tangentially related; benefit depends on broader changes. |
| 1 | Does not meaningfully advance the selected objective. |

When `All objectives` is selected:

- Score against the best-matching objective.
- Record that objective in the output.
- Do not give high Objective Fit to generic findings that could fit any objective equally well; require a concrete link to at least one objective.

---

## Objective-Specific Evidence Requirements

- **Agentic velocity:** evidence of workflow integration, IDE/CLI support, context handling, or measurable task-speed improvement.
- **Correctness & verification:** evidence of tests, types, static analysis, evals, benchmarks, or reduced defect classes.
- **AI-era security:** evidence of threat model, exploit path, mitigation, scanner/rule, or vendor security guidance.
- **Workflow orchestration:** evidence of multi-step automation, agent coordination, CI/CD hooks, or reproducible pipeline.
- **Modernization & tech debt:** evidence of version compatibility, migration guide, codemod, deprecation timeline, or upgrade path.
- **Capability expansion:** evidence of new API/runtime/model capability and a concrete use case.
- **Toolchain & developer experience:** evidence of installable tool, config, command, or measurable DX improvement.
- **MVP & product speed:** evidence of scaffold, template, boilerplate, deployment path, or accelerated build workflow.

If a candidate cannot meet its objective's evidence requirement, it should be gated out or classified as `Watch` with a clear revisit condition.
