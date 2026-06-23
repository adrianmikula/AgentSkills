| Optimisation | Speed | Quality | Debugging |
|---|---|---|---|
| Framework debug mode (Layer 1) | | | ✓ |
| Structured logger (Layer 2) | | ✓ | ✓ |
| MCP / tooling config (Layer 3) | | | ✓ |
| Fast linting | ✓ | ✓ | |
| Fast tests | ✓ | ✓ | |
| Velocity / DX hacks | ✓ | ✓ | |

# Java / Kotlin Stack Optimisation

Apply these settings when the detected project uses Java or Kotlin (Maven `pom.xml`, Gradle `build.gradle`/`build.gradle.kts`, or `*.java`/`*.kt` source files).

## Layer 1: Framework-level debug mode

### Spring Boot
In `application-dev.yml` or `application-dev.properties`:
```yaml
logging:
  level:
    root: DEBUG
    org.springframework.web: DEBUG
```
Enable devtools in `build.gradle.kts`:
```kotlin
runtimeOnly("org.springframework.boot:spring-boot-devtools")
```
Or in `pom.xml`:
```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-devtools</artifactId>
  <scope>runtime</scope>
</dependency>
```

### Quarkus
Enable dev mode (default with `./mvnw quarkus:dev` or `./gradlew quarkusDev`):
- Hot reload is automatic
- Set `quarkus.log.level=DEBUG` in `application.properties`
- Enable console logging: `quarkus.log.console.enable=true`

### Micronaut
In `application-dev.yml`:
```yaml
micronaut:
  application:
    name: app
logger:
  levels:
    root: DEBUG
```

### Jakarta EE / Java Enterprise appservers (WildFly, Payara, WebLogic, TomEE)
- Use exploded deployments (`target/app.war/`) instead of packaged WARs to enable hot swap
- Prefer embedded/containerless testing via Arquillian embedded or Weld SE
- Configure XTS logging in `standalone.xml` or domain config:
  ```xml
  <logger category="com.example">
    <level name="DEBUG"/>
  </logger>
  ```

## Layer 2: Structured logger

Create a logger at the standard path for the project structure.

Logger file path: `src/main/java/com/example/lib/Logger.java` (Java) or `src/main/kotlin/com/example/lib/Logger.kt` (Kotlin)

### Java template
```java
package com.example.lib;

import java.time.Instant;
import java.util.Map;

public class Logger {
  private static final Map<String, Integer> LEVELS = Map.of(
    "debug", 0, "info", 1, "warn", 2, "error", 3
  );
  private static final Map<String, String> PREFIXES = Map.of(
    "debug", "DEBUG", "info", "INFO ", "warn", "WARN ", "error", "ERROR"
  );
  private static int currentLevel = -1;

  private static int getLevel() {
    if (currentLevel >= 0) return currentLevel;
    String env = System.getenv("LOG_LEVEL");
    if (env != null && LEVELS.containsKey(env)) {
      currentLevel = LEVELS.get(env);
    } else {
      currentLevel = "true".equals(System.getenv("DEV")) ? 0 : 2;
    }
    return currentLevel;
  }

  private final String context;

  private Logger(String context) { this.context = context; }

  public static Logger logger(String context) { return new Logger(context); }

  public void debug(String message, Object data) { log("debug", message, data); }
  public void info(String message, Object data) { log("info", message, data); }
  public void warn(String message, Object data) { log("warn", message, data); }
  public void error(String message, Object data) { log("error", message, data); }

  private void log(String level, String message, Object data) {
    if (LEVELS.getOrDefault(level, 99) < getLevel()) return;
    String ts = Instant.now().toString();
    String prefix = PREFIXES.get(level);
    String base = ts + " [" + prefix + "] [" + context + "] " + message;
    if (data instanceof Throwable) {
      System.err.println(base);
      ((Throwable) data).printStackTrace(System.err);
    } else if (data != null) {
      System.out.println(base + " " + data.toString());
    } else {
      System.out.println(base);
    }
  }
}
```

### Kotlin template
```kotlin
package com.example.lib

import java.time.Instant

class Logger private constructor(private val context: String) {
  companion object {
    private val levels = mapOf("debug" to 0, "info" to 1, "warn" to 2, "error" to 3)
    private val prefixes = mapOf("debug" to "DEBUG", "info" to "INFO ", "warn" to "WARN ", "error" to "ERROR")
    private var currentLevel = -1

    private fun getLevel(): Int {
      if (currentLevel >= 0) return currentLevel
      val env = System.getenv("LOG_LEVEL")
      currentLevel = when {
        env != null && env.lowercase() in levels -> levels[env.lowercase()]!!
        System.getenv("DEV") == "true" -> 0
        else -> 2
      }
      return currentLevel
    }

    fun logger(context: String) = Logger(context)
  }

  fun debug(message: String, data: Any? = null) = log("debug", message, data)
  fun info(message: String, data: Any? = null) = log("info", message, data)
  fun warn(message: String, data: Any? = null) = log("warn", message, data)
  fun error(message: String, data: Any? = null) = log("error", message, data)

  private fun log(level: String, message: String, data: Any?) {
    if (levels[level] ?: 99 < getLevel()) return
    val ts = Instant.now()
    val prefix = prefixes[level] ?: level
    val base = "$ts [$prefix] [$context] $message"
    when (data) {
      is Throwable -> System.err.println("$base\n${data.stackTraceToString()}")
      null -> println(base)
      else -> println("$base $data")
    }
  }
}
```

## Layer 3: MCP server config

Create `.mcp.json` at repo root with JVM-appropriate MCP servers.

If using Gradle:
```json
{
  "mcpServers": {
    "gradle": {
      "command": "./gradlew",
      "args": ["--no-daemon"]
    }
  }
}
```

If using Maven:
```json
{
  "mcpServers": {
    "maven": {
      "command": "mvn",
      "args": []
    }
  }
}
```

General recommendations:
- Database: MCP server matching the project's database (e.g. PostgreSQL, MySQL)
- Testing: `npx -y @playwright/mcp` if using Playwright for browser tests

For manual debugging via `@modelcontextprotocol/inspector`:
```
npx @modelcontextprotocol/inspector <command> <args>
```

### Fast Linting
- Gradle: `./gradlew checkstyleMain` or `./gradlew spotlessApply`
- Maven: `mvn checkstyle:check -q`
Run lint before compile — catches style/syntax issues without a full build.

### Fast Tests
Create a `devFast` test task that runs only unit tests (no Spring context, no integration):
```kotlin
tasks.register<Test>("devFast") {
  useJUnitPlatform { includeTags("fast") }
}
```
Agents run `./gradlew devFast` for <15s feedback. Full suite is CI-only.

### Velocity Hacks
- **Disable annotation processors locally** (Lombok, MapStruct, JPA) — often 10x compile speedup
- **No Spring in inner loop** — use plain constructors + manual wiring in tests; if Spring starts, loop is broken
- **Freeze generated code** (OpenAPI, Protobuf, DB codegen) into binary modules — never recompile during iteration
- **Gradle configuration cache** — enable via `gradle.properties`: `org.gradle.configuration-cache=true`
- **Classpath minimization** — separate "runtime" from "dev/test" deps; smaller classpath = faster everything
- **CRaC for near-instant startup** — use CRaC-enabled JDK (Azul Zulu or Ubuntu OpenJDK CRaC) to snapshot JVM and restore in <100ms

### Reference Documents
Load these for deeper context when applicable:

| Scenario | Resource |
|----------|----------|
| Language/framework/runtime selection for velocity | `resources/java-dev-velocity-optimisations.md` |
| Jakarta EE appserver fast feedback | `resources/java-appserver-optimisations.md` |
| Sub-second persistent test runner setup | `resources/java-persistent-test-runner.md` |
