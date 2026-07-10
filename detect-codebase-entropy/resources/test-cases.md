# Test Cases — SlopGuard

## Analyze File — Security Finding

**Input:**
```json
{
  "fileContent": "fun connect() { val apiKey = \"sk-abc123def456\" }",
  "fileType": "kotlin",
  "trigger": "save",
  "filePath": "src/main/kotlin/config.kt"
}
```

**Expected Output:**
```json
{
  "score": 65,
  "findings": [
    {
      "title": "Hardcoded API token detected",
      "detail": "Found potential hardcoded API token matching pattern 'sk-'. AI-generated code often contains hardcoded secrets.",
      "severity": "HIGH",
      "category": "SECURITY",
      "file": "src/main/kotlin/config.kt",
      "line": 1,
      "scoreDelta": 25
    }
  ],
  "filePath": "src/main/kotlin/config.kt",
  "timestamp": "<any ISO 8601 string>"
}
```

## Analyze File — Corrupted Source

**Input:**
```json
{
  "fileContent": "```java\npublic class Foo {\n  public void bar() {}\n```\nThis is mostly prose text with some code snippets scattered around.",
  "fileType": "java",
  "trigger": "manual",
  "filePath": "src/main/java/Foo.java"
}
```

**Expected Output:**
```json
{
  "score": 55,
  "findings": [
    {
      "title": "Markdown tokens detected in source file",
      "detail": "Code fences (```) suggest non-code content was included.",
      "severity": "HIGH",
      "category": "CORRUPTION",
      "file": "src/main/java/Foo.java",
      "line": 1,
      "scoreDelta": 20
    }
  ],
  "filePath": "src/main/java/Foo.java",
  "timestamp": "<any ISO 8601 string>"
}
```

## Analyze File — Excluded Extension

**Input:**
```json
{
  "fileContent": "# Some markdown content",
  "fileType": "markdown",
  "trigger": "save",
  "filePath": "README.md"
}
```

**Expected Output:**
```json
{
  "score": null,
  "findings": [],
  "filePath": "README.md",
  "timestamp": "<any ISO 8601 string>"
}
```

## Analyze File — Clean Code

**Input:**
```json
{
  "fileContent": "package com.example\n\nfun add(a: Int, b: Int): Int = a + b",
  "fileType": "kotlin",
  "trigger": "save",
  "filePath": "src/main/kotlin/util.kt"
}
```

**Expected Output:**
```json
{
  "score": 0,
  "findings": [],
  "filePath": "src/main/kotlin/util.kt",
  "timestamp": "<any ISO 8601 string>"
}
```

## Analyze Project — Mixed Results

**Input:**
```json
{
  "projectRoot": "/tmp/test-project",
  "fileFilter": { "includePatterns": ["**/*.kt", "**/*.java"] }
}
```

**Expected Shape:**
```json
{
  "aggregateScore": "<number 0-100>",
  "totalFindings": "<number >= 0>",
  "scannedFileCount": "<number >= 0>",
  "excludedFileCount": "<number >= 0>",
  "fileResults": "[ ... RiskResult[] ... ]"
}
```

## Run Generator — ITERATIVE Mode

**Input:**
```json
{
  "mode": "ITERATIVE",
  "features": ["Add user CRUD", "Add authentication"],
  "variationsPerPrompt": 3
}
```

**Expected Shape:**
```json
{
  "projectId": "<string>",
  "generatedFiles": "<number >= 0>",
  "metrics": {
    "duplicateLiterals": "<number>",
    "duplicateMethodCalls": "<number>",
    "loc": "<number>",
    "similarMethods": "<number>"
  }
}
```
