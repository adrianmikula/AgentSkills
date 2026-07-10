# Data Models — SlopGuard

## RiskResult

Represents the outcome of a single file analysis.

```json
{
  "score": 72,
  "findings": [
    {
      "title": "Hardcoded API token detected",
      "detail": "AI-generated code often contains hardcoded secrets that should use environment variables",
      "severity": "HIGH",
      "category": "SECURITY",
      "file": "src/main/kotlin/example.kt",
      "line": 15,
      "scoreDelta": 25
    }
  ],
  "filePath": "src/main/kotlin/example.kt",
  "timestamp": "2026-07-09T12:00:00Z"
}
```

### Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `score` | `number (0-100) or null` | Yes | Overall risk score. null for excluded files |
| `findings` | `Finding[]` | Yes | Prioritized findings (max 7) |
| `filePath` | `string` | Yes | Absolute path to analyzed file |
| `timestamp` | `string (ISO 8601)` | Yes | When analysis completed |

## Finding

A single detected issue.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | `string` | Yes | Short human-readable title |
| `detail` | `string` | Yes | Longer explanation with remediation guidance |
| `severity` | `enum` | Yes | `HIGH` / `MEDIUM` / `LOW` |
| `category` | `enum` | Yes | `SECURITY` / `COMPLEXITY` / `DUPLICATION` / `PERFORMANCE` / `CORRUPTION` |
| `file` | `string` | Yes | Relative or absolute file path |
| `line` | `number` | Yes | 1-indexed line number |
| `scoreDelta` | `number` | Yes | Contribution to overall risk score |

### Severity Levels

| Level | Score range | Meaning |
|-------|-------------|---------|
| HIGH | 61-100 | Security issues, corrupted content |
| MEDIUM | 31-60 | Code smells, duplication, moderate issues |
| LOW | 0-30 | Minor issues (long comments, TODO markers) |

### Categories

| Category | Rules | Description |
|----------|-------|-------------|
| SECURITY | 10 | Hardcoded tokens, placeholder domains, null assertions, broad catches, empty catches, plaintext passwords |
| COMPLEXITY | 8 | Long methods, deep nesting, high cyclomatic complexity, heavy boolean logic, long if/else chains, null propagation |
| DUPLICATION | 4 | Duplicate string/number literals, repeated method calls, large signatures |
| PERFORMANCE | 2 | Thread.sleep, magic numbers |
| CORRUPTION | 4 | Parse failure, markdown tokens, unbalanced braces, mixed-language content |

## ProjectRiskResult

Aggregated results from a full project scan.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `aggregateScore` | `number (0-100)` | Yes | Mean score across all scanned files |
| `totalFindings` | `number` | Yes | Sum of all findings across all files |
| `scannedFileCount` | `number` | Yes | Number of eligible files analyzed |
| `excludedFileCount` | `number` | Yes | Number of files skipped due to exclusion rules |
| `fileResults` | `RiskResult[]` | Yes | Per-file analysis results |

## ExperimentConfig

Configuration for the code generator experiment.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `mode` | `enum` | Yes | `SINGLE_SHOT` or `ITERATIVE` |
| `features` | `string[]` | Yes | Ordered list of features to implement |
| `variationsPerPrompt` | `number` | Yes | Number of independent generation paths (default: 5) |

## ExperimentResult

Result of a code generator run.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `projectId` | `string` | Yes | Unique project identifier |
| `generatedFiles` | `number` | Yes | Count of successfully generated files |
| `metrics.duplicateLiterals` | `number` | Yes | Count of duplicate string/number literals |
| `metrics.duplicateMethodCalls` | `number` | Yes | Count of repeated method calls |
| `metrics.loc` | `number` | Yes | Total lines of code |
| `metrics.similarMethods` | `number` | Yes | Count of structurally similar methods |

## TriggerType

| Value | Description |
|-------|-------------|
| `edit` | User is actively typing (30s cooldown) |
| `save` | File was saved to disk |
| `focus` | Editor tab gained focus |
| `manual` | User explicitly triggered analysis (menu action) |

## FileType

Supported language types: `java`, `kotlin`, `python`, `javascript`, `typescript`, `scala`
