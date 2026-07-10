---
name: detect-codebase-entropy
description: IntelliJ IDEA plugin that detects code quality issues introduced by AI-generated code — security vulnerabilities, duplicate boilerplate, and structural decay.
version: 1.1.2
---

## Overview

SlopGuard is an IntelliJ IDEA plugin that analyzes code in real-time and on-demand to detect quality issues introduced by AI-generated code. It uses four detection engines (JavaParser AST, Tree-sitter fuzzy matching, corrupted source detection, and a YAML-defined rule engine) to produce a risk score (0–100) with prioritized findings.

## Capabilities

### Analyze File

Analyzes a single file and returns quality risk findings with a score.

**Fixed contract:**
| Property | Description |
|----------|-------------|
| Inputs | `fileContent: string`, `fileType: FileType`, `trigger: TriggerType` |
| Outputs | `RiskResult { score, findings[], filePath, timestamp }` |
| Business rules | Score is 0–100. Max 7 findings returned, sorted by severity (HIGH first). Excluded file types (.md, .class, .tst, .log, .jar) return empty result. Edit-triggered analysis has 30s cooldown. |
| Error semantics | Parse failure → corrupted source finding (not an exception). License expired → return cached result. |

**Open layer:**
| Property | Description |
|----------|-------------|
| Algorithm | Cooldown strategy (debounce vs throttle) |
| Structure | How engines are composed (sequential vs parallel) |

**Logic:**

1. Capture the current state: diff since last save (for EDIT triggers) or full file content (for SAVE/MANUAL triggers)
2. Run four analysis engines:
   - **ASTAnalyzer** (JavaParser): extract structural metrics — method length, nesting depth, cyclomatic complexity, boolean complexity, null propagation
   - **TreeSitterFuzzyDetector**: detect duplicate strings/numbers/method calls, similar methods via shingling, LLM repetition patterns
   - **CorruptedSourceDetector**: detect parse failures (JavaParser + Tree-sitter both fail), markdown tokens, unbalanced braces, mixed-language content (>30% prose)
   - **Rule engine** (LocalMockAnalyzerClient): apply 30+ YAML-defined detection rules — security patterns (hardcoded tokens, placeholder domains, null assertions), complexity thresholds, duplication thresholds
3. Calculate entropy score per category via EntropyScoreCalculator
4. Aggregate into overall risk score (0–100) — weighted sum of category sub-scores
5. Return top 7 findings sorted by severity (HIGH > MEDIUM > LOW), then by score delta descending

**Config parameters used:**
| Parameter | Config path | Purpose |
|-----------|-------------|---------|
| Analysis rules | `data_sources.analysis_rules_path` | Path to YAML rule definitions |
| Scoring weights | `scoring.category_weights` | Weight per category for score aggregation |
| Max findings | `limits.max_findings` | Max findings returned per analysis |
| Excluded extensions | `lists.excluded_extensions` | File extensions skipped during analysis |
| Edit cooldown | `limits.edit_cooldown_ms` | Debounce interval for edit-triggered analysis |
| Thresholds | `thresholds.*` | Complexity, duplication, corruption thresholds |
| Score ranges | `scoring.risk_levels` | Low/Medium/High score boundaries |

**Error states:**
| Condition | Error | Handling |
|-----------|-------|----------|
| Parse failure (both parsers) | `CorruptedSourceType.PARSE_FAILURE` | Add corrupted source finding, continue analysis on rest of file |
| License expired | License check fail | Return cached result, show license prompt in tool window |
| File type excluded | Skip | Return empty RiskResult with score null |
| Empty content | Empty input | Return score 0, no findings |

**Example:**
```json
// Input
{ "fileContent": "fun calculate() { val key = \"sk-abc123\"; ... }", "fileType": "kotlin", "trigger": "save" }

// Output
{ "score": 72, "findings": [{ "title": "Hardcoded API token detected", "severity": "HIGH", "detail": "AI-generated code often contains hardcoded secrets", "category": "SECURITY", "file": "src/main.kt", "line": 1 }], "filePath": "src/main.kt", "timestamp": "2026-07-09T12:00:00Z" }
```

### Analyze Project

Analyzes all eligible files in the project and returns aggregated results.

**Fixed contract:**
| Property | Description |
|----------|-------------|
| Inputs | `projectRoot: string`, `fileFilter: FileFilter` (optional) |
| Outputs | `ProjectRiskResult { fileResults[], aggregateScore, totalFindings, scannedFileCount, excludedFileCount }` |
| Business rules | Excluded file types (.md, .class, .tst, .log, .jar) are skipped. Results stored in `.aicodequalityrisk/latest-scan.json`. |
| Error semantics | Empty project → empty result set. Mixed success: per-file errors don't fail the whole scan. |

**Logic:**

1. Recursively walk project root directory
2. Skip files matching excluded extensions list
3. For each eligible file, invoke Analyze File capability
4. Aggregate per-file results into overall project summary
5. Persist results to `.aicodequalityrisk/latest-scan.json`
6. Update tool window UI with project-level scores

**Config parameters used:**
| Parameter | Config path | Purpose |
|-----------|-------------|---------|
| Excluded extensions | `lists.excluded_extensions` | File types to skip |
| Max findings | `limits.max_findings` | Capped per file |

**Error states:**
| Condition | Error | Handling |
|-----------|-------|----------|
| No eligible files | Empty result | Return 0 scanned, 0 findings |
| License expired | License check fail | Return cached project result |

**Example:**
```json
// Input
{ "projectRoot": "/home/user/project", "fileFilter": { "includePatterns": ["**/*.kt", "**/*.java"] } }

// Output
{ "aggregateScore": 45, "totalFindings": 23, "scannedFileCount": 12, "excludedFileCount": 4, "fileResults": [...] }
```

### Run Code Generator (Experimental)

Generates Java Spring Boot projects using LLMs to study code quality evolution during iterative development.

**Fixed contract:**
| Property | Description |
|----------|-------------|
| Inputs | `config: ExperimentConfig` |
| Outputs | `ExperimentResult { projectDir, resultsCsv, generatedFiles[] }` |
| Business rules | Generator mode: SINGLE_SHOT (one prompt) or ITERATIVE (sequential feature additions). Each iteration builds on the previous. Quality metrics collected after each generation. |
| Error semantics | LLM call failure → retry up to 3 times. Partial generation → include successfully generated files. |

**Logic:**

1. Load experiment config from `config/generator.json`
2. Build LLM prompt using PromptBuilder (normal Java/Spring Boot prompts, no quality-related instructions)
3. Call LLM via `opencode` CLI (LlmCaller)
4. Parse LLM output, extract files via FileExtractor
5. Write generated files to `workspace/generated/{project-id}/`
6. Run DetectionRunner to measure quality metrics (duplicate literals, method calls, LOC, similarity)
7. Append results to `workspace/generated/results.csv`
8. For ITERATIVE mode: repeat steps 2–7 for each feature in `iterationFeatures`, building on the previous output

**Config parameters used:**
| Parameter | Config path | Purpose |
|-----------|-------------|---------|
| Generator config | `data_sources.generator_config_path` | Path to generator JSON config |
| LLM retries | `limits.llm_retries` | Max retries for LLM call |
| Variations per prompt | `thresholds.variations_per_prompt` | Number of independent generation paths |
| Output dir | `data_sources.workspace_dir` | Generated project output directory |

**Error states:**
| Condition | Error | Handling |
|-----------|-------|----------|
| LLM call fails after retries | Generation aborted | Log error, skip to next variation |
| Config file not found | Config load failure | Use default config |
| Invalid LLM output | Parse failure | Log warning, skip malformed files |

**Example:**
```json
// Input
{ "mode": "ITERATIVE", "features": ["add-user-crud", "add-authentication", "add-caching"], "variationsPerPrompt": 5 }

// Output
{ "projectId": "proj-abc123", "generatedFiles": 24, "metrics": { "duplicateLiterals": 12, "duplicateMethodCalls": 8, "loc": 1800, "similarMethods": 3 } }
```

## Configuration

| Variable | Config path | Default | Description |
|----------|-------------|---------|-------------|
| Analysis rules path | `data_sources.analysis_rules_path` | `config/analysis-rules.yaml` | YAML detection rules |
| Edit cooldown | `limits.edit_cooldown_ms` | 30000 | Debounce for edit-triggered analysis (ms) |
| Max findings per file | `limits.max_findings` | 7 | Max findings returned per file |
| Excluded extensions | `lists.excluded_extensions` | [.md, .class, .tst, .log, .jar] | File types to skip |
| Low risk max | `scoring.risk_levels.low_max` | 30 | Score <= this is low risk |
| Medium risk max | `scoring.risk_levels.medium_max` | 60 | Score <= this is medium risk |
| High risk min | `scoring.risk_levels.high_min` | 61 | Score >= this is high risk |
| LLM retries | `limits.llm_retries` | 3 | Max retries for generator LLM calls |
| Variations per prompt | `thresholds.variations_per_prompt` | 5 | Independent generation paths |

## Dependencies

- Runtime: Kotlin 2.3.0, JVM 17+
- Key libraries: JavaParser 3.25.8, Tree-sitter 0.26.6, kotlinx-serialization-json 1.7.3, SnakeYAML 2.0
- Platform: IntelliJ IDEA 2023.3+ (Platform SDK 242.*)
- External services: opencode CLI (for code generator), IntelliJ Marketplace Trial API (licensing)

## Test Cases

See `resources/test-cases.md` for full invocation examples and expected outputs.
