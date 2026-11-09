# `.conventions` state skeleton

Use this skeleton only in **operational mode**, when setting up a new convention library in a repository that will own its own `.conventions/` state. Create a `.conventions/` folder in the target repository root, copy these files into it, then replace every `<FILL>` placeholder with the agreed convention. Do not commit the folder once populated. In **reference mode**, do not create `.conventions/` in the target repository; apply the conventions directly from `resources/convention-catalog.md` and `Skill.md` instead.

## `.conventions/conventions.toml`

```toml
[naming]
repo_pattern = "<FILL>"
package_pattern = "<FILL>"
env_prefix = "<FILL>"
branch_default = "<FILL>"

[urls]
api_base_url = "<FILL>"
auth_url = "<FILL>"
docs_url = "<FILL>"

[schemas]
directory = ".conventions/schemas"
format = "json-schema"

[cicd]
platform = "<FILL>"
reusable_workflows = ["<FILL>"]
ci_trigger = "<FILL>"
test_command = "<FILL>"

[git]
main_branch = "<FILL>"
prod_deploy_service = "<FILL>"
pr_staging_deploy = "<FILL>"
require_human_approval_for_commits = "<FILL>"
allowed_auto_commit_conditions = ["<FILL>"]
prompt_for_commit_after_major_work = "<FILL>"

[telemetry]
service = "<FILL>"
required_events = ["<FILL>"]

[release]
versioning = "<FILL>"
release_tool = "<FILL>"
protected_branches = ["<FILL>"]

[error_routing]
prod_slack_channel = "<FILL>"
dev_slack_channel = "<FILL>"

[error_handling]
require_explicit_approval_for_fallback = "<FILL>"
allowed_fallback_conditions = ["<FILL>"]

[config]
sources = ["<FILL>"]
mandatory_settings = ["<FILL>"]
fail_on_missing = "<FILL>"

[testing]
methodology = "<FILL>"
unit_test_coverage_minimum = "<FILL>"
unit_test_command = "<FILL>"
integration_test_command = "<FILL>"
integration_test_paths = ["<FILL>"]

[security]
secret_scanning = "<FILL>"
dependency_scanning = "<FILL>"
static_analysis = "<FILL>"
input_validation = "<FILL>"
auth_pattern = "<FILL>"
least_privilege = "<FILL>"

[ai_autonomy]
require_human_verification_for_major = "<FILL>"
allow_unambiguous_minor_decisions = "<FILL>"
plan_and_verify_when_unsure = "<FILL>"
agent_roles = ["<FILL>"]
warn_on_over_reliance = "<FILL>"
cognitive_sustainability_reference = "<FILL>"

[database]
backend = "<FILL>"
schema_name = "<FILL>"
project_types = ["<FILL>"]
project_name_source = "<FILL>"
example = "<FILL>"

[[database.project_group]]
name = "<FILL>"
url = "<FILL>"
project_types = ["<FILL>"]

[documentation]
agents_readme_path = "<FILL>"
common_conventions_path = "<FILL>"
index_path = "<FILL>"
skill_reference_url = "<FILL>"
```

## `.conventions/logins.toml`

```toml
[[service]]
name = "<FILL>"
env_var = "<FILL>"
secret_manager_ref = "<FILL>"
notes = "<FILL>"
```

## `.conventions/schemas/example.schema.yaml`

```yaml
$id: "<FILL>"
type: object
properties:
  id:
    type: string
required: ["id"]
```

## `.conventions/projects.toml`

```toml
[[project]]
name = "<FILL>"
path = "<FILL>"
modules = ["naming", "urls", "schemas", "cicd", "git", "telemetry", "release", "logins", "error_routing", "error_handling", "config", "testing", "security", "ai_autonomy", "documentation"]
env_template = ".conventions/env.template"
```

## `.conventions/env.template`

```text
# Copy to .env in each project and fill via the secret manager or login source
<FILL_VARIABLE_NAME>=<FILL>
```

## `.gitignore` additions

```gitignore
# Convention state — actual preferences, never commit
.conventions/
```
