# Java Dev Velocity Optimisations

Reference document for optimising JVM development velocity for agentic coding.

## JVM languages ranked for agentic velocity

### Kotlin (best default)
- ~40-60% less boilerplate than Java
- Null-safety eliminates a major class of agent errors
- Type inference produces cleaner diffs, less hallucinated verbosity
- Zero-cost Java interop for migration
- LLMs consistently produce cleaner, more correct Kotlin than modern Java
- **AI ecosystem (2026):** JetBrains Koog 1.0.0 (stable, MCP integration, Spring/Ktor support), Google ADK for Kotlin 0.3.0, JetBrains Junie AI agent built on Kotlin with Mellum LLM, MCP Kotlin SDK, Spring AI integration — all shipping production AI agent frameworks in Kotlin
- Best practice: Kotlin for implementation, Java for interfaces if needed

### Scala (powerful but agent-hostile)
- Too many ways to express the same thing
- Compile errors are complex and verbose
- LLMs still struggle with advanced type-level Scala
- Viable only if heavily constrained in style

### Groovy (underrated for agent workflows)
- Dynamically typed, very concise, JVM-native
- Agents can generate Groovy very reliably
- Excellent for build scripts, test harnesses, internal DSLs
- Think of it as a JVM "Python" for agents

## JVM runtime choices

### CRaC (Coordinated Restore at Checkpoint) — primary recommendation
- JVM process snapshot for near-instant startup from warm state
- Eliminates JVM warm-up penalties
- Production-grade as of 2026: available in Azul Zulu (JDK 17, 21, 25), Ubuntu packages, Spring Boot 3.2+, Quarkus, Micronaut, Helidon 4.2+
- Measured results: Spring PetClinic checkpoint/restore cuts startup from 5-7s to near-instant
- **Why it beats Native Image for agent loops:** preserves JIT-compiled code, doesn't require closed-world assumption, works with existing frameworks, no reflection config needed
- Platform limitation: checkpoint only works on Linux (x64/ARM64); Windows/macOS for dev/testing only

### GraalVM — use case dependent (not a blanket recommendation)
- **Oracle announced "Detaching GraalVM from the Java Ecosystem Train" (Sep 2025):** GraalVM for JDK 24 was the final version as part of Oracle Java SE. Native Image discontinued for Java SE customers.
- GraalVM continues as a standalone product (25.0 LTS, monthly feature releases 25.1+), but focus is shifting to non-Java polyglot languages (GraalPy, GraalJS)
- Native Image is still useful for serverless (sub-100ms cold starts) and CLI tools where CRaC's Linux-only limitation is a blocker
- GraalVM 25 removed macOS x64 support (Apple Silicon only)
- **For agentic dev loops:** CRaC is the more practical path — no closed-world assumption, works with any framework, no reflection hint config

### Project Leyden (emerging — watch this space)
- OpenJDK effort for ahead-of-time compilation as a standard Java feature
- JEP 483 (AOT compilation) shipping in mainline JDK
- Long-term, this is where Java AOT is heading — part of standard Java rather than a separate VM
- Not yet production-ready for agent loops, but the strategic direction

## Frameworks ranked for agentic velocity

### Quarkus (best for agent feedback loops)
- Dev Mode: live reload with sub-second feedback cycles, change code and see results in <200ms without restart
- Dev Services: auto-starts Postgres/Redis/Keycloak containers when app starts
- Built-in Dev UI: runtime config changes, logging control, dependency graph
- First-class Kubernetes support, fast native compilation
- Compromise: smaller ecosystem than Spring, reflection hints occasionally needed for native

### Micronaut (middle path)
- Compile-time DI eliminates runtime reflection — most predictable memory profile
- Fastest cold start in JVM mode (950ms) and lowest memory (98MB idle)
- No live reload equivalent — relies on continuous Gradle builds
- Weaker IntelliJ/VS Code plugin support than Spring or Quarkus
- Best for: greenfield projects where startup speed and memory matter most

### Spring Boot (still dominant for complex enterprise)
- Largest ecosystem by far — Spring Data, Security, Cloud, Batch cover every production need
- Best IDE tooling: IntelliJ IDEA Ultimate Spring support is the gold standard (visual bean graphs, auto-complete, one-click K8s deploy)
- DevTools provides hot restart (slower than Quarkus live reload but reliable)
- Virtual threads (Project Loom) support since 3.2 as one-line config
- Spring AOT + CDS (since 3.3) closes much of the startup gap with Quarkus
- For agent loops: if the project already uses Spring, the ecosystem advantage outweighs the startup speed difference for most projects

## Recommended agentic JVM stack
```
Language: Kotlin
Runtime: CRaC-enabled JDK (Azul Zulu or Ubuntu OpenJDK CRaC)
Framework: Quarkus (for new agent-velocity-optimised projects) or Spring Boot (for complex enterprise)
Tests: Kotest (spec-driven) or JUnit 5 with Launcher API
Build: Gradle (Kotlin DSL)
```

## Gradle multi-module configuration overhead

### The problem
When an agent runs `./gradlew :module:fastTest`, Gradle still configures ALL projects in the build — even modules that aren't needed. In a 5-module project with Spring Boot, IntelliJ, and SpotBugs plugins, this adds 15-25s of configuration time and can fail with configuration cache serialization errors.

### Measured impact (JakartaMigrationMCP, 5 modules)

| Scenario | Time | Notes |
|----------|------|-------|
| Single module fast-test (warm) | 0.76s | ✅ Fast |
| All 5 modules fast-test (cold) | 2.0s | ✅ With `--configure-on-demand` |
| All 5 modules fast-test (warm) | 1.9s | ✅ With `--configure-on-demand` |
| All 5 modules fast-test (without fix) | 25s | ❌ Broken transitive deps + no `--configure-on-demand` |

### Root causes
1. **Gradle configures ALL projects** — even when you only need one module's tests
2. **Heavy plugins** — Spring Boot, IntelliJ, SpotBugs each add 3-8s of configuration per module
3. **Broken transitive dependencies** — one module's broken dep (e.g. missing version) cascades to all modules that depend on it
4. **Configuration cache serialization** — broken deps cause config cache to be discarded, forcing full re-configuration

### Fixes

**1. `--configure-on-demand`** — skips configuring modules not needed for the requested task:
```bash
./gradlew :core:fastTest --configure-on-demand  # skips unrelated modules
```
Add to `gradle.properties` for permanent effect, or to mise/CI commands.

**2. Explicit module listing** — never use bare `fastTest` in multi-module projects:
```bash
# GOOD: only configures the modules you need
./gradlew :core:fastTest :domain:fastTest --configure-on-demand

# BAD: configures ALL modules including broken ones
./gradlew fastTest
```

**3. Disable heavy plugins for inner loop** — SpotBugs, ErrorProne, Checkstyle add 3-8s each:
```kotlin
// build.gradle.kts — comment out for agent iteration
// id("com.github.spotbugs") version "6.0.25"
// id("net.ltgt.errorprone") version "4.1.0"
```

**4. Fix version-less dependencies** — causes configuration cache failures:
```kotlin
// BAD — version-less, fails with configuration cache
runtimeOnly("org.springframework.boot:spring-boot-devtools")

// GOOD — explicit version, configuration cache works
runtimeOnly("org.springframework.boot:spring-boot-devtools:3.2.0")
```

**5. Document broken modules** — add to COMMANDS.md:
```markdown
## Do NOT use
| Command | Reason |
|---------|--------|
| `./gradlew :broken-module:test` | Fails with config cache error |
```

### Profiling overhead
Use `--profile` to generate an HTML report showing per-phase and per-module timing:
```bash
./gradlew :module:fastTest --profile --no-configuration-cache
```
The report shows: startup time, configuration time per project, dependency resolution time, task execution time. This identifies which modules are slow to configure.
