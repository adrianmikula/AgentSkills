# Tech-Stack Detection Playbook

Use this playbook when `dev-level-up` runs in `Auto-detect current repo` or `Both` scope mode. The goal is to produce a bounded, evidence-backed `.tech-stack/` state that can drive relevant searches without assuming a fixed language or framework.

## Principles

- **Evidence first.** Record only domains supported by manifests, configs, lockfiles, source structure, scripts, or explicit user input.
- **Bounded scan.** Inspect repository-root manifests and representative config/code paths first; do not recursively analyse every file unless needed.
- **Ignore generated/vendor output.** Skip `node_modules/`, `dist/`, `build/`, `.next/`, `target/`, `vendor/`, `.venv/`, `venv/`, `__pycache__/`, `.git/`, and similar generated directories.
- **Confidence matters.** Use `detected` for direct evidence, `inferred` for strong contextual evidence, `manual` for user input, and `custom` for user-defined domains.
- **Preserve state.** Existing `.tech-stack/` manual/custom rows are authoritative unless the user asks to remove them.

## Detection Order

1. Resolve repository root and confirm `.tech-stack/` state handling.
2. Detect languages/runtimes from manifests and version files.
3. Detect frameworks and libraries from dependencies and framework configs.
4. Detect infrastructure and deployment platforms.
5. Detect developer tooling from scripts and CI/editor configs.
6. Infer coding patterns and practices.
7. Detect AI tooling and agent configuration.
8. Record evidenced risk domains.
9. Write `.tech-stack/` category files and update `index.md`.

---

## Manifest and Runtime Signals

| Ecosystem | Primary signals | Extract |
|-----------|-----------------|---------|
| JavaScript/TypeScript | `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lockb`, `tsconfig.json`, `jsconfig.json` | package manager, Node version, framework deps, scripts |
| Python | `pyproject.toml`, `requirements*.txt`, `Pipfile`, `poetry.lock`, `uv.lock`, `setup.py`, `setup.cfg`, `tox.ini`, `.python-version` | Python version, package manager, framework deps, test/lint tools |
| JVM | `pom.xml`, `build.gradle`, `build.gradle.kts`, `settings.gradle`, `settings.gradle.kts`, `gradle.properties`, `mvnw`, `.mvn/` | Java/Kotlin/Scala, Spring/Quarkus/Micronaut, build plugins |
| .NET | `*.sln`, `*.csproj`, `*.fsproj`, `global.json`, `Directory.Build.props`, `Directory.Packages.props`, `nuget.config` | SDK version, ASP.NET/Blazor/MAUI, test/build tools |
| Go | `go.mod`, `go.work`, `go.sum` | Go version, module path, framework deps |
| Rust | `Cargo.toml`, `Cargo.lock`, `rust-toolchain.toml`, `.cargo/config.toml` | Rust edition/toolchain, crate deps, workspace structure |
| Ruby | `Gemfile`, `Gemfile.lock`, `.ruby-version`, `*.gemspec`, `Rakefile` | Ruby version, Rails/Sinatra, test/lint tools |
| PHP | `composer.json`, `composer.lock` | PHP version, Laravel/Symfony/Drupal/WordPress, tooling |
| Swift/Apple | `Package.swift`, `*.xcodeproj`, `*.xcworkspace`, `Podfile`, `Cartfile` | Swift version, iOS/macOS framework, packages |
| Kotlin/Android | `build.gradle.kts`, `settings.gradle.kts`, `gradle.properties`, `AndroidManifest.xml` | Android Gradle Plugin, Compose, Kotlin version |
| Flutter/Dart | `pubspec.yaml`, `pubspec.lock`, `.metadata`, `analysis_options.yaml` | Dart/Flutter version, packages, platforms |
| Elixir/Erlang | `mix.exs`, `mix.lock`, `.tool-versions` | Elixir/OTP versions, Phoenix/LiveView, packages |
| C/C++ | `CMakeLists.txt`, `Makefile`, `conanfile.txt`, `vcpkg.json`, `compile_commands.json` | build system, dependencies, toolchain |
| Terraform/OpenTofu | `*.tf`, `*.tfvars`, `.terraform.lock.hcl` | IaC tool, providers, modules |
| Kubernetes/Helm | `Chart.yaml`, `values.yaml`, `kustomization.yaml`, manifests under `k8s/`, `deploy/`, `charts/` | cluster platform, Helm/Kustomize, workloads |

When multiple ecosystems are present, record each relevant category instead of choosing only one.

---

## Framework and Library Inference

Use dependency names, config filenames, directory conventions, and imports to infer frameworks. Examples:

- **Web/frontend:** React, Vue, Angular, Svelte, Next.js, Nuxt, Remix, Astro, Angular Universal, Webpack/Vite/Rspack/esbuild.
- **Backend:** Express, Fastify, NestJS, Django, Flask, FastAPI, Rails, Spring Boot, ASP.NET Core, Phoenix, Laravel, Symfony.
- **Data:** Prisma, Drizzle, TypeORM, Sequelize, Hibernate/JPA, Entity Framework, SQLAlchemy, ActiveRecord, Ecto, Doctrine.
- **Testing:** Jest, Vitest, Playwright, Cypress, pytest, JUnit, xUnit, RSpec, PHPUnit, Go test, cargo test.
- **Quality/tooling:** ESLint, Biome, Prettier, Ruff, Black, mypy, pyright, RuboCop, SpotBugs, SonarQube.

Only list a library in `libraries.md` when it is architecturally significant, security-sensitive, frequently upgraded, or directly relevant to likely search findings. Do not dump every transitive dependency.

---

## Infrastructure and Platform Signals

Inspect root and deployment directories for:

- Containers: `Dockerfile`, `docker-compose*.yml`, `Containerfile`, `devcontainer.json`.
- Orchestration: `k8s/`, `kubernetes/`, `helm/`, `charts/`, `kustomize/`, `manifests/`.
- IaC: `*.tf`, `Pulumi.yaml`, `Pulumi.*.yaml`, `cdk.json`, `serverless.yml`, `samconfig.toml`, `vercel.json`, `netlify.toml`, `fly.toml`, `railway.json`, `render.yaml`.
- CI/CD: `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`, `azure-pipelines.yml`, `.circleci/`, `.buildkite/`, `bitbucket-pipelines.yml`, `.drone.yml`.
- Cloud SDKs/env vars: AWS, GCP, Azure, Cloudflare, Supabase, Firebase, Vercel, Netlify, Railway, Render.
- Data platforms: Postgres, MySQL, SQLite, MongoDB, Redis, Elasticsearch, Kafka, RabbitMQ, SQS/SNS, BigQuery, Snowflake, DynamoDB.

Record the platform/tool, not every cloud resource name. If the repo clearly uses a managed service but the exact product is ambiguous, mark confidence as `inferred` and explain the evidence.

---

## Developer Tooling Signals

Inspect scripts and agent/editor configuration:

- Package scripts: `package.json` → `scripts`.
- Task runners: `Makefile`, `makefile`, `justfile`, `Taskfile.yml`, `magefile.go`, `invoke.json`, `noxfile.py`, `tox.ini`.
- CI workflows: test, lint, build, deploy, release jobs.
- Formatter/linter/typechecker configs: `.eslintrc*`, `eslint.config.*`, `.prettierrc*`, `biome.json`, `ruff.toml`, `mypy.ini`, `pyrightconfig.json`, `.editorconfig`, `detekt.yml`, `checkstyle.xml`.
- Test configs: `vitest.config.*`, `jest.config.*`, `playwright.config.*`, `pytest.ini`, `phpunit.xml*`, `xunit.runner.json`, `cucumber.js`.
- Local dev: `.devcontainer/`, `compose.yaml`, `Procfile`, `direnv`, `.env.example`, `mise.toml`, `.tool-versions`.
- Agent/AI configs: `.claude/`, `.devin/`, `.opencode/`, `.kilocode/`, `.windsurf/`, `.cursor/`, `AGENTS.md`, `CLAUDE.md`, `.mcp.json`, MCP config files.

For each tool, record current version when available and the command or config path as evidence.

---

## Pattern and Practice Inference

Infer practices only when the repository provides enough evidence:

- **Architecture:** monorepo vs polyrepo, modular monolith, microservices, serverless, event-driven, plugin architecture.
- **API style:** REST, GraphQL, gRPC, tRPC, WebSocket, webhook-driven.
- **Testing:** unit, integration, contract, E2E, mutation, property-based, snapshot, visual regression.
- **Observability:** structured logging, tracing, metrics, OpenTelemetry, Sentry, Datadog, Prometheus/Grafana.
- **Security practices:** auth providers, RBAC/ABAC, secrets management, SAST/DAST config, dependency scanning, signed commits.
- **Delivery practices:** trunk-based development, release trains, feature flags, canary/blue-green deploys, GitOps.
- **AI-assisted development:** agent rules, skills, MCP servers, prompt files, eval suites, AI code review config.

Write these to `patterns-practices.md` with confidence `inferred` unless the user explicitly stated them.

---

## AI Tooling Signals

Look specifically for:

- `.mcp.json`, `mcp_config.json`, `.devin/mcp_config.json`, `.kilocode/mcp.json`, `.opencode/config.json`.
- Agent instruction files: `AGENTS.md`, `CLAUDE.md`, `.windsurfrules`, `.cursor/rules`, `.github/copilot-instructions.md`.
- Prompt templates, eval harnesses, model configs, LLM client dependencies.
- AI IDE/editor integrations and extensions.
- AI gateway/proxy configs, vector stores, embeddings pipelines, RAG components.

Record model/provider names only when explicitly configured; do not infer model versions from generic AI mentions.

---

## Risk Domain Signals

Record a risk domain only when there is concrete evidence or user input:

- Authentication/authorization code or config.
- Secrets handling, `.env.example`, secret scanners, vault/KMS references.
- PII/payment/health data indicators.
- Public APIs, webhooks, file uploads, SSRF-prone fetches.
- AI agents with tool access, prompt inputs, MCP servers, or autonomous actions.
- Dependency manifests with known high-risk ecosystems or plugins.
- Compliance hints such as HIPAA, PCI, GDPR, SOC2 only when explicitly present in docs/config.

Do not turn every repo into a compliance project. Use `risk-domains.md` for evidenced concerns and `custom-domains.md` for user-defined priorities.

---

## Writing `.tech-stack` State

For each category file:

1. Preserve existing `manual` and `custom` rows.
2. Add or update `detected`/`inferred` rows from this scan.
3. Include evidence paths in the `Evidence` column.
4. Include concise `Search hints` and `Source hints` to support query generation.
5. Set `Last updated` to today's date for rows touched by this scan.
6. Update `index.md` counts and notes.

Example detected row:

```markdown
| Next.js | 15.3.x | package.json, next.config.ts | Next.js release notes React Server Components AI | nextjs.org/blog, github.com/vercel/next.js | detected | 2026-11-09 | App Router, Vercel deployment |
```

Example inferred row:

```markdown
| Contract testing | API schema tests | tests/, openapi.yaml | contract testing AI-generated APIs | pact.io, thoughtworks.com | inferred | 2026-11-09 | Verify coverage before recommending |
```

---

## Handling Ambiguity

Ask the user before searching when:

- Multiple plausible primary stacks are detected and the user has not prioritised one.
- A detected version cannot be determined and version-specific upgrades would matter.
- A manual/custom domain is broad enough to produce noisy results, e.g. `AI`, `security`, or `performance`.
- The repository is not a code repo, is generated, or has almost no source evidence.

When asking, offer the detected candidates and let the user select, remove, or add domains.
