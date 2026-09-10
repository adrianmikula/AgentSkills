# Generic Convention Options

Use this as a menu when populating `.conventions/conventions.toml`. Only one chosen pattern per domain should end up in the state file.

## Naming

- `kebab-case` for repository names, packages, and file names.
- `camelCase` for variables and functions; `PascalCase` for classes and components.
- `SCREAMING_SNAKE_CASE` for environment variables, with a shared `ENV_PREFIX`.
- Consistent suffixes such as `-api`, `-web`, `-worker`, `-cli`.

## URLs

- Subdomain APIs: `https://api.<domain>.com`.
- Path-prefix APIs: `https://<domain>.com/api/v1`.
- Separate auth domain from API domain.
- Use environment variables for the base URL, not hardcoded hosts.

## Schemas

- JSON Schema for REST request/response contracts.
- OpenAPI for public API documentation.
- Protobuf for internal service-to-service messages.
- SQL DDL conventions: singular table names, `snake_case` columns, `id`, `created_at`, `updated_at` on every table.

## Database

- Default backend: Supabase.
- Multiple schemas can coexist in one Supabase project when each schema name is prefixed.
- Schema name format: `PROJECTTYPE_PROJECTNAME`.
- Valid project types: `INTELLIJPLUGIN`, `VSCODEPLUGIN`, `WPPLUGIN`, `WEBAPP`.
- Project name is the virtual product name for plugins, or the customer's business name for custom webapps and other products.
- Example: `WEBAPP_PERTHRESTAURANT` for a `WEBAPP` named `PERTHRESTAURANT`.
- Supabase projects can be grouped by project type, each with its own project URL.
- Tables inside a schema keep the existing SQL DDL convention: singular names, `snake_case` columns, and `id`, `created_at`, `updated_at` on every table.

## Logins / Secrets

- One env var per service, e.g. `<PREFIX>_<SERVICE>_TOKEN`.
- Reference a secret manager (Doppler, 1Password, Vault, AWS Secrets Manager) instead of plain text.
- Separate dev/test/prod keys by environment, not by source file.

## CI/CD

- GitHub Actions with reusable workflows in `.github/workflows/`.
- GitLab CI with `include` templates.
- Branch protection, required status checks, and deployment gates.
- Matrix testing across supported language/runtime versions.
- Run the full test suite only for commits pushed to open pull requests; skip CI for branches without open PRs.

## Telemetry

- Error reporting: Sentry, Rollbar, Bugsnag.
- Usage analytics: PostHog, Amplitude, Mixpanel.
- Observability: Datadog, Honeycomb, OpenTelemetry.
- Consistent event/span naming and privacy tags.

## Release

- SemVer with `release-please` or `changesets`.
- CalVer for time-based releases.
- Git tags and protected release branches.
- Changelog and migration-note conventions.

## Error Routing & Alerting

- Route production errors to one Slack channel and development errors to a different Slack channel (e.g., `#alerts-prod`, `#alerts-dev`).
- Send startup/mandatory-config failures to the production error channel.
- Store channel identifiers in environment variables, not source code.

## Error Handling

- Never add hidden fallback logic inside `catch` / `except` / `onError` blocks unless the design explicitly permits it.
- Allow fallback only for transient, self-healing production cases: network timeout, rate-limit retry, brief dependency unavailability.
- Log the original exception and the fallback decision before executing the fallback.

## Configuration

- Never hardcode configuration constants in source code.
- Load from `config/*.yaml`, `*.json`, `*.properties`, or environment variables with a single validated loader.
- Define mandatory settings; fail on startup when any are missing.
- Report missing mandatory config failures to the production error channel.

## Git Workflow

- Main branch auto-deploys to production via Vercel, Netlify, Railway, or another modern cloud deployment service.
- Pull requests auto-deploy to a staging environment for review.
- Use branch protection and required status checks before merging.
- AI agents must never run `git commit`, `git push`, or any other source-control write command without explicit human approval.
- Any exceptions must be explicitly listed in `allowed_auto_commit_conditions`.
- After completing a major task or body of work, the agent should ask the human if they are ready to commit. If yes, the agent should draft a commit message organized under roadmap, architecture, features, bugfixes, and skills, but the human must perform the actual `git commit`.
- Commit messages avoid duplication: each change is summarized once under its single most relevant category, not repeated across categories.
- Commit message summaries describe changes in high-level, plain-English conceptual terms — avoid low-level references to filenames, classes, or method names.
- Commit messages describe only the uncommitted changes currently in the workspace; do not summarize historical changes that have already been committed.

## Testing

- Follow test-driven development principles.
- Mocked unit tests must cover a minimum of 75% of the codebase.
- Run unmocked integration tests for mission-critical paths.
- Test commands and coverage gates are wired into CI/CD.

## Security

- Never commit secrets, API keys, or credentials; use secret managers and env vars.
- Scan dependencies for known vulnerabilities and keep them updated.
- Run static analysis (SAST) and linting in CI.
- Validate and sanitize all external input.
- Enforce least-privilege access for services, databases, and infrastructure.
- Use parameterized queries or ORM to prevent injection.
- Require MFA for admin and production accounts where feasible.
- Apply standard security headers and TLS for web applications.

## AI Autonomy

- The agent must obtain explicit human verification before making major decisions or assumptions.
- Minor, obvious, or trivial decisions may be made by the agent when there is no ambiguity the human might want to clarify.
- If unsure, the agent must plan the decision with the human and verify the final plan before implementation.
- The AI acts as an expert researcher, adviser, coder, and tester — not as a decision-maker.
- Only the human makes major decisions and clarifies assumptions.
- The agent should warn the human when it detects over-reliance on AI for major decisions that could reduce cognitive engagement.
- Reference the `cognitive-sustainability` skill (`.agents/skills/cognitive-sustainability/SKILL.md`) for decision-boundary and escalation guidance.

## Documentation

- Create `AGENTS.md` at the repository root and make it reference `docs/INDEX.md` and `docs/conventions/common-conventions.md` so AI agents can locate both.
- Maintain `docs/conventions/common-conventions.md` with a link to the canonical common-coding-conventions source (e.g., this `code-conventions-aligner` skill repository).
- Maintain `docs/INDEX.md` with a concise, one-line-per-file index of every Markdown file under `docs/`.
- Group `docs/INDEX.md` by folder, using a heading for each directory.
- List all folder names at the top of `docs/INDEX.md` and include the line numbers where each folder's items appear.
