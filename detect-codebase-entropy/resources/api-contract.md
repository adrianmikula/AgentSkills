# API Contract — SlopGuard

## IntelliJ Plugin API (Internal)

### Inputs

#### Analyze File

Triggered via:
- `AnalyzeCurrentFileAction` (editor popup menu — right-click)
- `AnalyzeProjectAction` (Tools menu)
- Automatic: file save, tab switch, edit cooldown timer

Internal payload:

```kotlin
data class AnalysisInput(
  val filePath: String,
  val fileContent: String,
  val fileType: FileType,
  val trigger: TriggerType,
  val projectBasePath: String
)
```

#### Analyze Project

Triggered via `Tools → Analyze Project Risk`.

```kotlin
data class ProjectAnalysisInput(
  val projectBasePath: String,
  val includePatterns: List<String>? = null,
  val excludePatterns: List<String>? = null
)
```

### Outputs

```kotlin
data class RiskResult(
  val score: Int?,              // 0-100, null if excluded
  val findings: List<Finding>,
  val filePath: String,
  val timestamp: String
)

data class Finding(
  val title: String,
  val detail: String,
  val severity: Severity,       // HIGH | MEDIUM | LOW
  val category: Category,       // SECURITY | COMPLEXITY | DUPLICATION | PERFORMANCE | CORRUPTION
  val file: String,
  val line: Int,
  val scoreDelta: Int
)
```

### Persistence

Results are stored to `.aicodequalityrisk/latest-scan.json` in the project root.

```json
{
  "projectBasePath": "/path/to/project",
  "lastScanTimestamp": "2026-07-09T12:00:00Z",
  "fileResults": [ ... ]
}
```

## MCP Server (Disabled)

Uses JSON-RPC over stdin/stdout. Currently disabled in `plugin.xml` since v1.0.2.

### Tools

| Tool | Input | Output |
|------|-------|--------|
| `scan_file` | `{ filePath: string }` | `RiskResult` |
| `scan_project` | `{ projectBasePath: string }` | `ProjectRiskResult` |
| `get_last_result` | `{ filePath: string }` | `RiskResult` or null |

## Code Generator (Standalone)

CLI interface via Gradle `application` plugin:

```bash
gradlew run --args="config/generator.json"
```

### Config file (JSON)

```json
{
  "mode": "ITERATIVE",
  "features": [
    "Add user CRUD operations",
    "Add authentication",
    "Add caching layer"
  ],
  "variationsPerPrompt": 5,
  "projectDescription": "Spring Boot task management API",
  "basePrompt": "Generate a complete Spring Boot project..."
}
```

### Outputs

- Generated projects: `workspace/generated/{project-id}/`
- Metrics: `workspace/generated/results.csv`
