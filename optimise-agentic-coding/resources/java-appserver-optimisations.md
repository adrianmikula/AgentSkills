# Java Appserver Optimisations

Reference document for optimising Jakarta EE / Java Enterprise appserver (WildFly, Payara, WebLogic, WebSphere, TomEE) dev velocity.

## Ranked optimisation methods

### 1. Hot redeploy / hot swap (no server restart)
- Reload CDI beans, REST endpoints, EJB logic, persistence mappings
- Without restarting the appserver JVM (10-120s startup avoided)
- Works best with: Quarkus dev mode, Payara Micro, WildFly exploded deployments, JRebel

### 2. Exploded deployments + incremental classpath rebuild
- Deploy as `target/app.war/WEB-INF/classes` instead of packaged WAR
- Only changed `.class` files are updated
- JVM classloader reload is cheap compared to repackaging WAR/EAR

### 3. Containerless / embedded server testing
- Run CDI, JPA, REST without a full appserver
- Tools: Arquillian embedded, Weld SE, JerseyTest
- 70-80% of enterprise bugs are logic-level, not server-level

### 4. Build DAG short-circuiting (Maven/Gradle)
- Hash module inputs, annotations, persistence.xml
- Skip packaging, annotation processors, bytecode enhancement
- Agents avoid rebuilding EARs, client JARs, unused modules

### 5. Persistence-layer dry runs (JPA-first validation)
- Validate entities, mappings, JPQL, schema compatibility without starting server
- Tools: Hibernate schema validator, Metamodel generation checks, JPQL static analysis

## Inner-loop latency targets
| Task | Traditional | Agentic |
|------|-------------|---------|
| Appserver restart | 30-120s | Avoided |
| WAR rebuild + redeploy | 10-60s | Avoided |
| Single class logic change | 10-30s | <500ms |
| JPA mapping error detection | Runtime | <1s |
| REST endpoint validation | Manual | <1s |

## Core insight
Enterprise Java is slow because people restart servers unnecessarily. Agentic workflows treat appservers as long-lived daemons, deployments as mutable, and builds as graphs (not scripts). These optimisations are machine-orchestrable via MCP: detect safe hotswap boundaries, choose embedded vs server tests, skip packaging when irrelevant, decide when full redeploy is actually needed.
