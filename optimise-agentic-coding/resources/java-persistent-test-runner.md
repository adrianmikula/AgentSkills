# Java Persistent Test Runner

Reference document for achieving sub-1-second Java test feedback loops.

## Core insight
Java test time is dominated by JVM startup + framework boot, not test logic. JUnit test logic is usually microseconds. Agentic coding breaks when those repeat constantly. The solution: keep the JVM alive and treat tests as in-process function calls.

## Tier 0 — What cannot hit <1s
- `mvn test` / `gradle test` (cold JVM)
- Spring Boot context per test
- Fork-per-test
- Surefire default settings
- Heavy mocks + reflection
These top out at 2-10s.

## Tier 1 — Techniques that achieve sub-1s

### Persistent test JVM (non-negotiable)
- Start a JVM once, load test classes once, execute tests repeatedly inside it
- Removes JVM startup, classpath resolution, classloading
- 100-300 tests in 100-400ms

### JUnit 5 Launcher API (in-process)
Instead of `gradle test`, use:
```java
Launcher launcher = LauncherFactory.create();
launcher.execute(request);
```
Inside a long-running JVM. This is how IDEs do it.

### Hot code replace / dynamic class redefinition
- Modern JVMs allow method body replacement with instant reloads
- Tools: JVM TI agents, ByteBuddy, JRebel-style mechanisms, HotSwapAgent 2.0.3+ (Jan 2026, supports JDK 21+, Spring 6, Hibernate, MyBatis, Vaadin, GlassFish 7)
- Agent workflow: AI edits code → bytecode swapped → tests rerun immediately
- Note: IntelliJ IDEA 2025+ handles persistent JVM + JUnit Launcher natively during debug sessions — consider reusing IDE infrastructure rather than building a custom daemon

### Incremental compilation
- Compile only what changed (Gradle and IntelliJ already do this)
- Annotation processors minimised, no clean builds
- Compile time drops to ~50-200ms

### Framework-free test paths
- No Spring, CDI, Hibernate, or context bootstrap in inner loop
- Use constructors, factories, fake adapters instead
- Keep Spring out of the inner loop

## Tier 2 — JVM & runtime choices

### JVM choice
| JVM | Agentic fit |
|-----|-------------|
| HotSpot | Good |
| OpenJ9 | Better startup, worse tooling |
| GraalVM JVM (standalone 25.x) | Good — but Oracle has shifted focus to polyglot; evaluate based on project needs |
| Native Image | Bad for iteration (closed-world assumption, slow build) |
| CRaC-enabled JDK (Azul Zulu / Ubuntu) | Excellent for persistent test snapshots |

### GC choice (startup-optimised)
```
-XX:+UseSerialGC
```

## Tier 3 — Framework comparison (speed)
| Framework | Cold | Warm | Agentic |
|-----------|------|------|---------|
| JUnit 5 | Medium | Fast | Excellent |
| TestNG | Medium | Fast | Good |
| Spock (Groovy) | Slow | Medium | Poor |
| Kotest | Medium | Fast | Good |

## The real secret weapon
Big teams don't use Gradle/Maven for dev tests at all. They launch tests via IDE engines, embed that logic into agentic tools, and reuse IDE classloaders. That's how you get instant feedback.

## Real-world numbers (2026)
- 50 tests → 50-100ms
- 200 tests → 200-400ms
- Single test → <20ms

## Gold-standard setup
- JUnit 5 Launcher
- Persistent JVM daemon
- Incremental compile
- Hot code replace
- Test selection by dependency graph
- Spring only in CI
