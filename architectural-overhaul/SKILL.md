# Architectural Overhaul Skill

## Overview

This skill guides performing deep architectural overhauls of complex multi-module Java systems to simplify, consolidate, strengthen implementation, and overcome incorrect/inconsistent/unreliable behavior caused by complexity, duplication, and lack of clear logic/codebase understandability.

## When to Use This Skill

- A system has accumulated technical debt that causes incorrect behavior
- Multiple modules implement overlapping functionality with inconsistencies
- Features show high failure rates
- The codebase has grown organically without clear architectural boundaries
- New requirements reveal gaps in the existing approach
- Code duplication exists across modules with subtle behavioral differences
- The system is hard to debug because logic is scattered across multiple locations

## Phase 1: Problem Identification & Root Cause Analysis

### Step 1: Identify Symptoms

Document the observable problems with specific metrics:
- What percentage of operations fail?
- What are the failure modes?
- Which user-facing features are affected?

### Step 2: Trace the Code Path

For each symptom, trace the full execution path:
1. Identify entry points (UI handlers, service methods, API endpoints)
2. Follow the call chain through all layers
3. Map the data flow from input to output
4. Identify where decisions are made and where failures occur

**Key questions:**
- Where does the logic branch?
- Where are errors caught and how are they handled?
- What fallback paths exist?
- Where is state stored or cached?

### Step 3: Identify Root Causes

Distinguish symptoms from root causes:

| Symptom | Root Cause |
|---------|------------|
| High failure rate | Classifier/validator only knows subset of valid inputs |
| Error cascade | Error handler marks dependent components as failed |
| Inconsistent results | Multiple implementations with different logic |

**Root cause categories:**
1. **Missing data** - Configuration lacks known-good mappings
2. **Incorrect logic** - Error handling propagates failures incorrectly
3. **Duplication** - Multiple implementations of same logic with subtle differences
4. **Coupling** - Components that should be independent are tightly coupled
5. **Missing integration** - Components exist but aren't wired together

### Step 4: Document the Current Architecture

Create a visual representation of the current state:
- Module boundaries and dependencies
- Key interfaces and implementations
- Data flow through the system
- Configuration sources and their relationships

## Phase 2: Research & Solution Discovery

### Step 1: Study Industry Solutions

Research how other tools solve similar problems:
- Search for open-source implementations
- Read technical blogs and conference talks
- Study established patterns and frameworks
- Look at adjacent domains for inspiration

**Key questions to answer:**
- What approaches do mature tools use?
- What data structures and algorithms are effective?
- How do they handle edge cases and failures?
- What trade-offs have they made?

### Step 2: Identify Reusable Components

Map existing code to the solution:
- What already exists that can be reused as-is?
- What exists but needs modification?
- What is duplicated and should be consolidated?
- What is completely missing?

**Classification matrix:**

| Component | Status | Action |
|-----------|--------|--------|
| Existing component A | Works correctly | Reuse as-is |
| Existing component B | Missing data | Expand configuration |
| Existing component C | Duplicates logic | Consolidate |
| Missing component D | Missing | Create new |

### Step 3: Define the Target Architecture

Design the simplified, consolidated architecture:
- Clear module responsibilities
- Single source of truth for each concern
- Minimal duplication
- Explicit dependency direction
- Testable components

## Phase 3: Implementation Planning

### Step 1: Create Phased Plan

Structure work in phases that deliver incremental value:

```
Phase 1: Core foundation (new components)
Phase 2: Integration with existing systems
Phase 3: Expansion of existing components
Phase 4: Error handling improvements
Phase 5: Performance optimization
Phase 6: Testing (integration tests alongside components)
Phase 7: Testing (performance/memory tests separately)
Phase 8: Cleanup and deletion
```

### Step 2: Pair Integration Tests with Components

Each component phase should include its integration tests:
- Tests verify the component works correctly
- Tests serve as documentation of expected behavior
- Tests catch regressions during refactoring

**Example structure:**
```
Phase 1: ComponentA + ComponentAIntegrationTest
Phase 2: ComponentB + ComponentBIntegrationTest
Phase 3: Expand ComponentC + ComponentCIntegrationTest
```

### Step 3: Separate Performance Tests

Performance and memory tests should be a dedicated phase:
- They require different infrastructure (memory measurement, timing)
- They often need longer timeouts and more resources
- They may need to be run in isolation
- They validate non-functional requirements

### Step 4: Plan Legacy Code Deletion

Explicitly plan for deleting old code:
- Identify what becomes redundant
- Define verification criteria before deletion
- Ensure all tests pass before removing code
- Document what was deleted and why

## Phase 4: Implementation Execution

### Step 1: Implement Components Bottom-Up

Start with foundational components that have no dependencies:
1. Data extraction/parsing components
2. Classification/matching components
3. Integration/orchestration components
4. Error handling components

### Step 2: Write Tests Alongside Code

For each component:
1. Write the component
2. Write integration tests
3. Verify tests pass
4. Move to next component

### Step 3: Consolidate as You Go

When integrating new components:
1. Identify duplicate logic in existing code
2. Replace duplicate logic with calls to new component
3. Verify behavior is preserved
4. Mark old code for deletion

### Step 4: Fix Bugs During Integration

Use the integration process to fix existing bugs:
- Error handling that propagates failures incorrectly
- Missing fallback paths
- Incorrect state management
- Performance bottlenecks

## Phase 5: Verification & Cleanup

### Step 1: Run All Tests

Before any deletion:
- Run full test suite
- Run fast test loop for quick feedback
- Run slow/integration tests for comprehensive coverage
- Verify no regressions

### Step 2: Verify Behavior

Check that the system now behaves correctly:
- Failure rates have decreased significantly
- No out-of-memory errors
- User-facing features work as expected

### Step 3: Delete Legacy Code

Only after verification:
- Remove duplicate implementations
- Delete unused interfaces
- Simplify classes that became redundant
- Update documentation

### Step 4: Update Documentation

- Update architecture diagrams
- Update API documentation
- Update troubleshooting guides
- Update technical debt tracking

## Code Smell Detection

### Duplication Smells

| Smell | Detection | Resolution |
|-------|-----------|------------|
| Duplicate classifiers | Multiple classes with similar classification logic | Consolidate to single classifier with strategy pattern |
| Duplicate error handling | Same try/catch in multiple places | Extract to shared error handler |
| Duplicate data extraction | Same parsing logic in multiple files | Extract to shared utility |

### Architecture Smells

| Smell | Detection | Resolution |
|-------|-----------|------------|
| God class | Class >500 lines doing too many things | Split into focused components |
| Circular dependencies | Module A depends on B, B depends on A | Introduce interface or shared module |
| Feature envy | Class A uses Class B's data more than its own | Move method to Class B |
| Inappropriate intimacy | Two classes know too much about each other | Reduce coupling via interfaces |

### Logic Smells

| Smell | Detection | Resolution |
|-------|-----------|------------|
| Silent failure | Catch block with no logging | Add logging and fallback behavior |
| Error cascade | Single failure marks many things as failed | Mark only the failing component |
| Missing data | Hardcoded values that should be configurable | Load from configuration |
| Inconsistent state | Multiple sources of truth for same data | Single source of truth pattern |

## Metrics for Success

### Quantitative Metrics

| Metric | Before | After | Target |
|--------|--------|-------|--------|
| Failure rate | High (e.g., 90%) | Low (e.g., <10%) | <10% |
| Error cascade rate | High (e.g., 90%) | Low (e.g., <20%) | <20% |
| Memory usage | Unstable/OOM | Stable | Within budget |
| Test coverage | Low (<50%) | High (>70%) | >70% |

### Qualitative Metrics

- **Code clarity**: Single responsibility, clear interfaces
- **Maintainability**: Easy to add new components, easy to fix bugs
- **Testability**: Components can be tested in isolation
- **Documentation**: Architecture diagrams match implementation

## Anti-Patterns to Avoid

### 1. Big Bang Rewrite
**Don't:** Rewrite everything at once
**Do:** Incremental phases with working system at each step

### 2. Premature Optimization
**Don't:** Optimize before understanding the problem
**Do:** Measure first, optimize bottlenecks

### 3. Copy-Paste Refactoring
**Don't:** Copy code to new locations
**Do:** Extract to shared component, update references

### 4. Test After Deletion
**Don't:** Delete code, then write tests
**Do:** Write tests first, verify they pass, then delete

### 5. Skip Root Cause Analysis
**Don't:** Fix symptoms without understanding causes
**Do:** Trace code path, identify root cause, fix cause

## Checklist for Architectural Overhaul

- [ ] **Problem identification**: Document symptoms with metrics
- [ ] **Root cause analysis**: Trace code path, identify causes
- [ ] **Industry research**: Study how others solve similar problems
- [ ] **Reuse analysis**: Map existing code to solution
- [ ] **Target architecture**: Design simplified, consolidated system
- [ ] **Phased plan**: Create incremental implementation plan
- [ ] **Test strategy**: Pair integration tests with components
- [ ] **Performance tests**: Separate phase for memory/performance
- [ ] **Legacy deletion**: Plan for cleanup after verification
- [ ] **Verification criteria**: Define success metrics
- [ ] **Documentation update**: Keep docs in sync with implementation

## Reference Files

- `skills/real-repo-integration-test/SKILL.md` - Integration testing conventions
- `skills/performance-memory-profiling/SKILL.md` - Performance testing conventions
- `docs/patterns/memory_efficiency.md` - Memory efficiency patterns
- `docs/patterns/simplicity_and_consistency.md` - Simplicity guidelines
- `docs/troubleshooting/COMMON_ISSUES.md` - Known issues catalogue
