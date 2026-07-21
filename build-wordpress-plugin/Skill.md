---
name: build-wordpress-plugin
description: Generate a complete WordPress plugin codebase from a plain-English description of the plugin's purpose. Produces two fully independent build outputs (free .org-clean ZIP + premium ZIP) from one monorepo, with zero trialware or telemetry violations in the free build.
---

## Overview

You are a WordPress plugin architecture specialist. The user describes what their plugin should do (e.g. *"A WordPress plugin that scans comments for spam using a cloud AI API. Free version scans hourly and flags obvious spam. Premium adds Bayesian training, custom filters, and a quarantine dashboard."*). You generate the full file tree, all PHP/JS/CSS source, build scripts, preflight checks, tests, and documentation — producing two standalone ZIPs from one monorepo.

---

## Architecture Rule

The free plugin and premium plugin are **separate products that share utility code**. They are not one product with a gate. Every decision must pass these two tests:

> **Test 1:** "If I had never heard of this premium version, would this code make complete sense as a standalone product?"

If the answer is no, the code does not belong in the free build.

> **Test 2 (the function-signature test):** A free function's public parameters are as visible to a reviewer as its comments. If removing a parameter requires no feature loss for free users, and the parameter's name matches a premium upsell concept, the parameter belongs only in premium code.

---

## Repository Layout

```
{plugin-slug}/
├── free/                          # Free plugin source
│   ├── {plugin-slug}.php          # Main plugin file
│   ├── includes/
│   │   ├── core-service.php       # Core logic — always runs, no conditions
│   │   ├── api-client.php         # Cloud API client (serviceware)
│   │   └── queue.php              # Background processing (if needed)
│   ├── admin/
│   │   ├── ui.php                 # Admin page — free features only
│   │   ├── js/admin.js
│   │   └── css/admin.css
│   ├── readme.txt                 # Describes ONLY free-version behaviour
│   └── uninstall.php              # Cleans ONLY free-version options
│
├── premium/                       # Additive premium code
│   ├── loader.php                 # Injected into main file by premium build only
│   ├── premium-feature-1.php
│   ├── premium-feature-2.php
│   └── js/admin-premium.js
│
├── shared/                        # Pure utility code — included in both builds
│   ├── http.php                   # HTTP wrappers
│   ├── compat.php                 # WordPress API wrappers
│   └── helpers.php                # Pure functions, no business logic
│
├── scripts/
│   ├── build.sh                   # Produces both ZIPs
│   ├── preflight-check.sh         # Grep checks before submission
│   ├── deploy-to-svn.sh           # Push a built release to WordPress.org SVN (from template)
│   └── validate-svn.sh            # Verify the deployed SVN files/structure (from template)

├── bin/
│   └── install-wp-tests.sh        # One-command WP_PHPUnit bootstrap script

├── tests/
│   ├── bootstrap.php              # Auto-detecting bootstrap: WP_PHPUnit or Brain Monkey fallback
│   ├── TestCase.php               # Base test case — extends WP_UnitTestCase or Brain Monkey
│   ├── wp-tests-config.php        # WP_PHPUnit database config (gitignored, template-only)
│   ├── TestCoreService.php        # Unit tests for core service logic
│   ├── TestApiClient.php          # Tests for API client with HTTP mocking
│   ├── TestAdmin.php              # Tests for admin UI rendering
│   └── TestHelpers.php            # Tests for shared utility functions
│
├── sql/                           # Cloud DB schema (not distributed)
├── .distignore
└── .gitignore
```

---

## Naming Conventions

| Rule | Convention |
|------|------------|
| Plugin slug | Lowercase, hyphens, no "free", "premium", "pro", "lite" |
| Constant prefix | Uppercase slug (e.g. `MYPLUGIN_`) |
| Option names | Same prefix, snake_case |
| Function names | Same prefix, snake_case |
| Class names | `{PREFIX}_{FeatureName}` |
| PHP files | ABSPATH guard — `if ( ! defined( 'ABSPATH' ) ) exit;` |
| Hooks | `register_activation_hook( PREFIX_PLUGIN_FILE, ... )` — never `__FILE__` |
| Plugin URI | Must be a **publicly accessible URL** — typically the WordPress.org plugin page (`https://wordpress.org/plugins/{slug}/`). Never use private repository URLs; WordPress.org reviewers cannot access them and will flag a 404. |
| Author URI | Must be a publicly accessible URL — the WordPress.org plugin page or a public profile page. |
| Domain Path | Include `Domain Path: /languages` in the plugin header. WordPress.org uses this to package translations even though `load_plugin_textdomain()` is not needed (see WordPress.org Compatibility section). |

---

## Testing Strategy: WP_PHPUnit Preferred, Brain Monkey Fallback

Every core logic class must have tests. Tests live in `tests/` and are excluded from both ZIP distributions.

The skill uses a **dual-mode testing strategy**:

| Mode | Base Class | What It Does | Setup Required |
|------|-----------|--------------|----------------|
| **WP_PHPUnit** (primary) | `WP_UnitTestCase` | Loads real WordPress core, runs against a test DB. Tests actual WP API behaviour: options, posts, roles, capabilities. | WordPress checkout + test database + `wp-tests-config.php` |
| **Brain Monkey** (fallback) | Custom `TestCase` with `Monkey\setUp()` | Mocks every WP function with `Functions\when()` / `Functions\expect()`. Fast, no DB, self-contained. | `composer install` only |

**Decision rule:** Generate WP_PHPUnit tests first. If `wp-tests-config.php` is missing or the WordPress test suite cannot be loaded (e.g. CI without a database, local dev without WordPress checked out), the bootstrap auto-detects the failure and falls back to Brain Monkey. Tests must work under both modes — pure logic tests run identically; WP-dependent assertions degrade gracefully.

### Dependencies (`composer.json`)
```json
{
  "require-dev": {
    "phpunit/phpunit": "^10.5",
    "brain/monkey": "^2.6"
  },
  "autoload": {
    "classmap": [
      "free/",
      "shared/",
      "premium/"
    ]
  },
  "scripts": {
    "test": "phpunit",
    "test:coverage": "phpunit --coverage-html build/coverage",
    "test:wp": "phpunit --testsuite=wp",
    "test:unit": "phpunit --testsuite=unit"
  }
}
```

### WP_PHPUnit: Test Bootstrap (`tests/bootstrap.php`)

Auto-detects available test infrastructure:
```php
<?php
$wp_tests_config = __DIR__ . '/wp-tests-config.php';

if ( file_exists( $wp_tests_config ) ) {
    // Mode: WP_PHPUnit — load WordPress test suite
    require_once $wp_tests_config;
    $_tests_dir = getenv( 'WP_TESTS_DIR' ) ?: '/tmp/wordpress-tests-lib';
    require_once $_tests_dir . '/includes/functions.php';
    require_once $_tests_dir . '/includes/bootstrap.php';
    define( 'TEST_MODE', 'wp' );
} else {
    // Mode: Brain Monkey — standalone unit testing fallback
    define( 'ABSPATH', true );
    define( 'MYPLUGIN_PLUGIN_FILE', '/dev/null' );
    define( 'MYPLUGIN_DIR', __DIR__ . '/../free/' );
    define( 'MYPLUGIN_VERSION', '1.0.0' );
    require_once __DIR__ . '/../vendor/autoload.php';
    define( 'TEST_MODE', 'unit' );
}
```

### WP_PHPUnit: Database Config (`tests/wp-tests-config.php`)

Template checked into the repo (values set via environment or `.env`):
```php
<?php
define( 'DB_NAME',     getenv( 'WP_TESTS_DB_NAME' ) ?: 'wordpress_test' );
define( 'DB_USER',     getenv( 'WP_TESTS_DB_USER' ) ?: 'root' );
define( 'DB_PASSWORD', getenv( 'WP_TESTS_DB_PASS' ) ?: '' );
define( 'DB_HOST',     getenv( 'WP_TESTS_DB_HOST' ) ?: 'localhost' );
define( 'DB_CHARSET',  'utf8' );
define( 'DB_COLLATE',  '' );
define( 'WP_TESTS_DOMAIN', 'example.org' );
define( 'WP_TESTS_EMAIL', 'admin@example.org' );
define( 'WP_TESTS_TITLE', 'Test Blog' );
$_SERVER['REMOTE_ADDR'] = '127.0.0.1';
```

### Base Test Case (`tests/TestCase.php`)

Switches behaviour based on detected mode:
```php
<?php
if ( defined( 'TEST_MODE' ) && TEST_MODE === 'wp' ) {
    // WP_PHPUnit mode — real WordPress APIs available
    class TestCase extends WP_UnitTestCase {}
} else {
    // Brain Monkey fallback mode — mock everything
    use Brain\Monkey;
    use PHPUnit\Framework\TestCase as PHPUnitTestCase;

    class TestCase extends PHPUnitTestCase {
        protected function setUp(): void {
            parent::setUp();
            Monkey\setUp();
        }
        protected function tearDown(): void {
            Monkey\tearDown();
            parent::tearDown();
        }
    }
}
```

### PHPUnit Config (`phpunit.xml.dist`)

Two test suites so users can target WP or unit mode independently:
```xml
<?xml version="1.0"?>
<phpunit bootstrap="tests/bootstrap.php" colors="true">
  <testsuites>
    <testsuite name="wp">
      <directory>tests</directory>
    </testsuite>
    <testsuite name="unit">
      <directory>tests</directory>
    </testsuite>
  </testsuites>
  <coverage>
    <include>
      <directory>free</directory>
      <directory>shared</directory>
    </include>
  </coverage>
</phpunit>
```

### Writing Tests for Both Modes

| Test Scenario | WP_PHPUnit Approach | Brain Monkey Fallback | Works In Both? |
|---------------|---------------------|----------------------|----------------|
| Pure logic (no WP calls) | Assert directly | Assert directly | Yes — identical code |
| Option get/set | `update_option( 'key', 'val' )` then `get_option( 'key' )` | `Functions\when('get_option')->justReturn('val')` | No — wrap in condition |
| Hook registration | `assertNotFalse( has_action( 'init' ) )` | `Functions\expect('add_action')` | No — wrap in condition |
| Post/term queries | Create with factory: `$this->factory()->post->create()` | `Functions\when('get_posts')->justReturn( [] )` | No — wrap in condition |
| HTTP calls | `wp_remote_get()` hits real endpoint or `WP_Http` mock | `Functions\when('wp_remote_get')->justReturn( $mock )` | No — wrap in condition |
| Admin screen render | `set_current_screen( 'edit-post' )` | `Functions\when('current_user_can')->justReturn( true )` | No — wrap in condition |

**Pattern for mode-safe tests:**
```php
public function test_core_feature() {
    $service = new MyPlugin_CoreService();

    if ( defined( 'TEST_MODE' ) && TEST_MODE === 'wp' ) {
        update_option( 'myplugin_setting', 'value' );
    } else {
        Brain\Monkey\Functions\when( 'get_option' )->justReturn( 'value' );
    }

    $result = $service->do_something();
    $this->assertTrue( $result );
}
```

### Test Conventions

- One test file per production class, named `Test{ClassName}.php`
- Each test class extends the project's `TestCase` base
- Pure logic tests (no WP API calls) should need **zero** mocking — they run identically in both modes
- Use `TEST_MODE` constant to guard WP-dependent assertions when the same test file runs in both modes
- Test both success and failure paths for all API calls
- Test that `ABSPATH` guard is present in every PHP file
- Premium tests (if any) go in `tests/premium/` and are only run against premium build

### WP_PHPUnit Setup Script (`bin/install-wp-tests.sh`)

Include a helper script so users can bootstrap WP_PHPUnit with one command:
```bash
#!/usr/bin/env bash
# Usage: ./bin/install-wp-tests.sh [db-name] [db-user] [db-pass] [db-host] [wp-version]
set -euo pipefail

DB_NAME=${1:-wordpress_test}
DB_USER=${2:-root}
DB_PASS=${3:-}
DB_HOST=${4:-localhost}
WP_VERSION=${5:-latest}

# Download WordPress test suite
if [ ! -d /tmp/wordpress-tests-lib ]; then
    svn co --quiet "https://develop.svn.wordpress.org/tags/$WP_VERSION/tests/phpunit/includes/" /tmp/wordpress-tests-lib
fi

# Create test database
mysqladmin create "$DB_NAME" --user="$DB_USER" --password="$DB_PASS" 2>/dev/null || true
```

### Running Tests
```bash
composer install

# WP_PHPUnit (requires WP test suite + DB — see bin/install-wp-tests.sh)
composer test:wp

# Brain Monkey fallback (no DB needed, runs anywhere)
composer test:unit

# Both suites (falls back to unit only if WP not configured)
composer test

# With coverage
composer test:coverage
```

## Serviceware Compliance

If the plugin calls a cloud API, enforce these rules:

1. The API endpoint called by the free plugin must return the same response for all callers — no server-side tier check
2. The free API request must NOT send: site URL, admin email, licence key, or any site identifier. Only send data needed for the service to function (e.g. versions, package names)
3. Premium-only API calls (telemetry, premium features) must live exclusively in `premium/` code
4. `readme.txt` must include an `== External Services ==` section — one subsection per external service, following the template below. A generic "we call a cloud API" description is not sufficient; WordPress.org reviewers require each service individually named and documented.

**External Services template** (add one `=== Service Name ===` block per service the plugin calls):

```
== External Services ==

This plugin queries several third-party services to provide its core functionality. No personally identifiable information is transmitted. Each service is described below.

=== Service Name ===

What it is: <short description of the service and its purpose>

Data sent: <what data is transmitted and in what format>

When: <when the call happens — e.g. on every scheduled scan, on page load, on user action>

Terms of Service: <URL>
Privacy Policy:   <URL>
```

Both the Terms of Service and Privacy Policy URLs **must be live and accessible** — WordPress.org verifies them. If the service is a US government project with no separate ToS, link to the agency's general policies page. If the service is open-source with no explicit ToS, link to the project's main documentation or GitHub README.

---

## Shared Data Architecture

If the plugin collects telemetry data, stores community-contributed data (e.g. shared block patterns, performance rankings, user-submitted content), or uses any shared cloud storage with a public/anon key visible in client code, load `resources/supabase-security.md` before designing the storage layer.

The resource covers:
- Insert-only RLS patterns for public-key clients (recommended architecture)
- RPC-based insert functions as an alternative
- SECURITY DEFINER view risks and how to avoid them
- Input validation in `WITH CHECK` policies
- A copy-paste agent prompt for future Supabase-backed plugin generation

The data architecture must be designed and documented in `sql/` before writing any plugin code.

---

## Code Smell Rules

### 1. No tiering language in free code
No "free version", "premium only", "pro version", "unlock", "upgrade" (except external link in readme.txt). No `is_premium()` function or equivalent.

### 2. No premium concepts as fields/constants/options in free code
If a premium feature exists (e.g. Bayesian training, custom filters, stability gates), NO field, constant, option key, or comment referencing it may appear in free code — even with a default-false value.

### 3. No filters designed as premium extension points
Do NOT add `apply_filters()` whose sole purpose is allowing premium to override behaviour. Do use `do_action()` for legitimate post-event hooks (logging, custom alerts).

### 4. No telemetry option registration in free code
Premium opt-in settings, data collection toggles, and reporting options are registered and managed entirely within `premium/`. Free `uninstall.php` must NOT clean premium options.

### 5. `readme.txt` must not describe premium behaviour
External link to a website describing paid features is acceptable. Describing them inline is not.

### 6. No parameter-forwarding pattern that reveals capability hiding
A free function must not accept a parameter that is always called with the same hardcoded value across all free callers, when that parameter relates to a capability described in a premium upsell.

**Why this matters:** A reviewer traces the call chain and sees:
1. Low-level function `do_thing($url, ...)` — accepts arbitrary URLs
2. All free callers pass `home_url()` unconditionally
3. Upsell says "Pro adds custom URL scanning"
4. Conclusion: the engine already supports arbitrary URLs; free was deliberately hobbled

**Bad:**
```php
// loopback.php
function build_test_url($url, $disable = null) {  // $url param reveals capability
    return add_query_arg(['test' => '1'], $url);
}

// scanner.php
function initiate_scan() {
    $url = home_url();                        // hardcoded single value
    return build_test_url($url);               // always passes same value
}
```

**Good:**
```php
// loopback.php
function build_test_url($disable = null) {    // no $url parameter
    return add_query_arg(['test' => '1'], home_url());  // inline home_url
}
```

**Defense-in-depth:** This rule applies with extra force when:
- The parameter's purpose maps to a feature name in a premium upsell ("custom URL scanning", "page selection")
- Removing the parameter produces simpler code (no change in free behaviour)
- Removing the parameter requires no filter/action hook rearrangement

**Exceptions (keep the parameter):**
- The function is genuinely called with different values within free code (not just different callers all passing the same hardcoded value)
- The parameter controls internal behaviour with no corresponding upsell feature (e.g. `$timeout = 8` — a tuning knob, not a capped feature)

### 7. Upsell language must not expose free version scope limitations
Premium upsell text must describe genuinely additive features, never capabilities that extend a deliberately limited free version scope.

**Bad upsell:**
```
"Pro adds page selection, custom URL scanning, and export"
```
The detection: free scans homepage, Pro "adds custom URL scanning" — a reviewer sees the free version's scope as a deliberate restriction.

**Good upsell:**
```
"Adds advanced plugin performance features"
```
Generic, additive. Does not enumerate what free won't do.

**Rule of thumb:** If the upsell feature name describes *where* or *how broadly* the free version operates (e.g. "custom URLs", "any page", "unlimited"), it's a leak. If it describes *what* it adds (e.g. "export", "priority support", "advanced reporting"), it's additive.

### 8. No `load_plugin_textdomain()` in WordPress.org plugins

Do NOT include `load_plugin_textdomain()` in the main plugin file or any init callback. WordPress.org has auto-loaded translations for plugins hosted on its directory since WordPress 4.6. Including this call triggers a review flag. The `Domain Path` header in the plugin file is sufficient — WordPress.org uses it to locate and package translations automatically.

If the plugin supports WordPress versions below 4.6, keep the call but ensure it is hooked into `init` (not called at file scope). The standard skill output targets WP 5.8+, so this exception should never apply.

---

## Free Version Contract

The free version must be a **complete, useful product**. It does NOT:
- Check any licence or key
- Degrade or delay its core function
- Contain configurable settings whose only purpose is premium gating
- Reference premium features in any string, comment, or variable

It DOES:
- Perform its advertised function fully and automatically
- Store all its own data in WordPress options it creates
- Clean up all its own data on uninstall
- Work identically on every WordPress install

The difference between free and premium is **capability addition**, not **capability restriction**.

---

## WordPress.org Compatibility

These rules apply to all plugins targeting the WordPress.org directory. Violations cause review rejection.

### No `load_plugin_textdomain()`

WordPress.org auto-loads translations since WordPress 4.6. The standard skill output requires WP 5.8+, so this call is never needed. Omit it entirely. Include `Domain Path: /languages` in the plugin header — WordPress.org uses this to locate translation files.

### Public plugin header URLs

`Plugin URI` and `Author URI` must be publicly accessible URLs. WordPress.org reviewers verify these links and reject plugins where they return 404. Use the WordPress.org plugin page URL (`https://wordpress.org/plugins/{slug}/`) or a public profile page. Never use private repository URLs.

### External Services disclosure

If the plugin calls any external API, the `readme.txt` must include an `== External Services ==` section documenting each service individually (see Serviceware Compliance section for the template). A vague "we call a cloud API" description will be rejected. Each service entry must include working ToS and Privacy Policy links — WordPress.org verifies these.

---

## Build Process

### Single command produces both ZIPs
```bash
./scripts/build.sh
```

Outputs:
- `build/{plugin-slug}.zip` — free version
- `build/{plugin-slug}-premium.zip` — premium version

### Free build exclusions (`.distignore`)
```
premium/
bin/
tests/
docs/
sql/
.env*
vendor/
composer.json
composer.lock
*.sh
.gitignore
.distignore
```

### Premium build additions
1. Start from free source
2. Overlay `premium/` folder
3. Inject premium loader block into main plugin file (NOT present in free source)
4. Generate `config.php` from `.env` for premium API URLs/keys

Injected loader block:
```php
// Premium module — injected by build process
if ( file_exists( MYPLUGIN_DIR . 'premium/loader.php' ) ) {
    require_once MYPLUGIN_DIR . 'premium/loader.php';
}
```

---

## WordPress.org SVN Deployment

When a plugin is ready to ship, it must be pushed to the official WordPress.org SVN repository. The skill generates two slug-agnostic helper scripts from templates so every new plugin gets a working deploy/verify workflow without hand-editing paths.

### Generated scripts (copy from `resources/`)

Copy `resources/deploy-to-svn.sh` and `resources/validate-svn.sh` into the new plugin's `scripts/` directory and make them executable:

```bash
cp resources/deploy-to-svn.sh scripts/deploy-to-svn.sh
cp resources/validate-svn.sh   scripts/validate-svn.sh
chmod +x scripts/deploy-to-svn.sh scripts/validate-svn.sh
```

Both scripts are slug-agnostic. They read their configuration from `${PLUGIN_SRC}/.env` (falling back to `.env.example`) and the shell environment — do NOT hardcode the plugin slug or paths into the script body.

### Required configuration (set in `.env`)

| Variable | Purpose |
|----------|---------|
| `PLUGIN_SLUG` | Plugin slug — also the main plugin file name (e.g. `my-plugin`). Used to locate `readme.txt`, the main `.php` file, and the zip root. |
| `SVN_REPO_PATH` | Local checkout of the WordPress.org SVN repo. Create it once with `svn co "https://plugins.svn.wordpress.org/${PLUGIN_SLUG}" "$SVN_REPO_PATH"` |

### Optional configuration (with defaults)

| Variable | Default | Purpose |
|----------|---------|---------|
| `PLUGIN_SRC` | current directory | Path to the built plugin source dir |
| `ASSETS_SRC` | `PLUGIN_SRC/../assets` | Path to the assets dir (banner/icon/screenshots) |
| `WP_CLI_PATH` | `/home/adrian/Studio/plugin-test` | Local WordPress install for the live WP-CLI install test |

### `deploy-to-svn.sh`

- Cleans `trunk/`, then copies plugin files respecting `.distignore` (via `rsync --exclude` plus a second pass that force-removes any excluded paths that were previously tracked)
- Stages `svn add` / `svn rm` so the working tree is clean
- Copies the `assets/` directory (banner/icon/screenshots)
- Creates `/tags/<version>` via `svn copy` unless it already exists
- Version is taken from the first argument, or falls back to the `Stable tag:` in `readme.txt`
- Prints a reminder to `svn commit`

```bash
# One-time setup:
svn co "https://plugins.svn.wordpress.org/${PLUGIN_SLUG}" "$SVN_REPO_PATH"
# Deploy (version from readme.txt Stable tag):
scripts/deploy-to-svn.sh
# Deploy with explicit version:
scripts/deploy-to-svn.sh 1.2.3
# Then commit:
svn commit "$SVN_REPO_PATH" -m "Release 1.2.3"
```

### `validate-svn.sh`

Validates the deployed state in the SVN checkout before/after commit. It reports `[PASS]`/`[FAIL]`/`[WARN]` lines and exits non-zero on any failure. Checks include:

1. Detects the version from `trunk/readme.txt` `Stable tag:`
2. `readme.txt` and the main plugin file exist at `trunk/` root
3. The main plugin file is at `trunk/` root, not nested in a subfolder
4. `readme.txt` has the `=== Plugin Name ===`, `Stable tag:`, and `License: GPL` headers
5. The main plugin file has `Plugin Name:` and `Version:` headers
6. No dev files leaked into trunk (`composer.json`, `.env`, `vendor/`, `premium/`, `tests/`, `*.md`, `*.sh`, `*.sql`, `*.ps1`, etc.)
7. SVN status is clean (no missing `!` items, warns on untracked `?`)
8. `/tags/<version>` exists and is non-empty
9. `assets/` exists and has files (warns if empty/missing)
10. Builds a test zip from `trunk/` and verifies `.php` files, `readme.txt`, and the main plugin file are at the zip root
11. Optionally does a live WP-CLI install/uninstall test against `WP_CLI_PATH`
12. WordPress.org review checks:
    - No `load_plugin_textdomain()` in the main plugin file
    - `Plugin URI` is publicly accessible (HTTP check, warns on code hosting URLs)
    - `readme.txt` has `== External Services ==` section if the plugin calls external APIs (with per-service subsection count)

```bash
scripts/validate-svn.sh
# Result: PASS  (exit 0)  or  Result: FAIL  (exit 1)
```

### Deploy workflow summary

1. `./scripts/build.sh` — produce the free + premium ZIPs
2. (optional) `./scripts/preflight-check.sh` against the free ZIP
3. First time only: `svn co` the repo into `SVN_REPO_PATH`
4. `./scripts/deploy-to-svn.sh [VERSION]` — populate trunk, assets, and tag
5. `./scripts/validate-svn.sh` — confirm the deployed files are correct
6. `svn commit "$SVN_REPO_PATH" -m "Release <version>"`

---

## Preflight Checklist

The preflight script (`scripts/preflight-check.sh`) must check against the extracted free ZIP:

**Automated grep checks:**
1. No tiering language strings ("free version", "premium only", "unlock", "upgrade" except external links)
2. No premium concept identifiers (stability, soak, canary, fleet, telemetry, etc.)
3. No `apply_filters` hooks with premium-only purpose
4. No premium option names registered in free code
5. No `is_premium()` or `IS_PREMIUM` anywhere
6. No `premium/` folder present
7. No premium loader block in main plugin file
8. `readme.txt` does not describe premium features
9. No test files reference premium concepts
10. WP_PHPUnit config template (`tests/wp-tests-config.php`) contains only env-variable defaults, no hardcoded secrets
11. Function parameters that always receive the same hardcoded value from all free callers — flag any parameter whose name matches a premium upsell concept:
    ```bash
    # Pattern: function takes $url param but all callers pass the same constant
    grep -rn "function.*(\$url" free/includes/ | while read line; do
        func=$(echo "$line" | grep -oP 'function \K\w+')
        # Manually verify whether all callers pass a hardcoded value
    done
    ```
12. Upsell text does not name features that describe scope ("custom URLs", "any page", "unlimited", "page selection") — only additive capabilities ("export", "priority support", "advanced reporting")
13. No `load_plugin_textdomain()` call anywhere in free code — WordPress.org auto-translates since WP 4.6
14. `Plugin URI` and `Author URI` in the main plugin file header point to publicly accessible URLs (not private repos, localhost, or internal network addresses)
15. If the plugin calls external APIs (`wp_remote_get`, `wp_remote_post`, `wp_remote_request`), `readme.txt` contains an `== External Services ==` section with per-service `=== Service Name ===` subsections documenting: what the service is, what data is sent, when it is called, Terms of Service link, and Privacy Policy link

**Manual verification checklist (performed by the AI during generation):**
- [ ] For every parameter in every free function: are there at least two different values passed to it across all free callers? If not, does removing the parameter expose a capability named in the upsell?
- [ ] Does the upsell text name any feature that describes *where/when/how much* vs *what*?

---

## Generation Process

When the user describes a plugin idea, follow these steps:

1. **Parse the idea** into free features vs premium features. If the plugin collects telemetry, stores community-contributed data, or uses shared cloud storage, load `resources/supabase-security.md` and design the data architecture before proceeding.
2. **Design the API contract** — what the free cloud endpoint returns, what premium adds
3. **Create the file tree** matching the repository layout above
4. **Write free files first** — make them fully functional standalone
5. **Write tests alongside each free class** — one test file per class. Pure-logic tests must run identically in both WP_PHPUnit and Brain Monkey modes. Guard WP-API-dependent assertions with `TEST_MODE` constant checks
6. **Write premium files** — additive features only
7. **Write build scripts** — `.distignore`, `build.sh`, `preflight-check.sh`, and copy `deploy-to-svn.sh` + `validate-svn.sh` from `resources/` into `scripts/` (see WordPress.org SVN Deployment). Add `PLUGIN_SLUG` and `SVN_REPO_PATH` to `.env`/`.env.example`.
8. **Write test infrastructure** — `phpunit.xml.dist`, `tests/bootstrap.php` (auto-detecting bootstrap), `tests/TestCase.php` (dual-mode base class), `tests/wp-tests-config.php` (template), `bin/install-wp-tests.sh`
9. **Write readme.txt** — free-only description + External Services section (see Serviceware Compliance for template). Follow WordPress.org Compatibility rules for all plugin header fields.
10. **Run tests in fallback mode** — `composer install && composer test:unit` — all tests pass without any external setup
11. **Run build** and verify both ZIPs
12. **Run preflight** against free ZIP — zero non-informational failures
13. **Verify deploy scaffolding** — `scripts/deploy-to-svn.sh` and `scripts/validate-svn.sh` are executable, `PLUGIN_SLUG`/`SVN_REPO_PATH` are documented in `.env.example`. If the user has a local SVN checkout, run `scripts/validate-svn.sh` after a dry deploy to confirm trunk structure
14. **Return the ZIPs** and a summary of what was built, including how to deploy (WordPress.org SVN Deployment section)

---

## Example Output

Given input: *"A plugin that minifies CSS/JS assets. Free minifies on the fly with basic caching. Premium adds CDN push, source maps, and per-page exclusion rules."*

The skill generates:
- `free/assets-minify.php`, `free/includes/minifier.php`, `free/includes/cache.php`, `free/admin/ui.php`
- `premium/loader.php`, `premium/cdn-push.php`, `premium/source-maps.php`, `premium/exclusions.php`
- `shared/http.php`, `shared/helpers.php`
- `tests/TestCase.php`, `tests/TestMinifier.php`, `tests/TestCache.php`, `tests/TestAdmin.php`, `tests/bootstrap.php`, `tests/wp-tests-config.php`
- `bin/install-wp-tests.sh`
- `phpunit.xml.dist`, `composer.json` with `phpunit` and `brain/monkey` dev deps
- Build scripts, preflight, deploy-to-svn.sh + validate-svn.sh (copied from resources/), readme.txt with External Services section
- `.env.example` documenting `PLUGIN_SLUG` and `SVN_REPO_PATH` for the SVN deploy workflow
- Free ZIP: basic on-the-fly minification with cache — no CDN, no source maps, no exclusions
- Premium ZIP: all features, CDN API key baked into config.php
