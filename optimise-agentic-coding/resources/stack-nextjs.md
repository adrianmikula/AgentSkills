| Optimisation | Speed | Quality | Debugging |
|---|---|---|---|
| Framework debug mode (Layer 1) | | | ✓ |
| Structured logger (Layer 2) | | ✓ | ✓ |
| MCP / tooling config (Layer 3) | | | ✓ |
| Fast linting | ✓ | ✓ | |
| Fast tests | ✓ | ✓ | |
| Velocity / DX hacks | ✓ | ✓ | |

# Next.js Stack Optimisation

Apply these settings when the detected framework is Next.js (any version).

## Layer 1: Framework-level debug mode

### Next.js 16+
Add to `next.config.*`:
```js
logging: { browserToTerminal: true, fetches: { fullUrl: true } },
```

Also ensure `source Maps` are enabled in development (default in Next.js 16+).

### Next.js <16 (or any version if 16+ check is uncertain)
Enable verbose dev logging:
- Ensure `NODE_ENV=development` is set
- Use `con:sole` API for structured request logging in middleware or API routes (migrated to logger in Layer 2)
- Source maps: confirm `productionBrowserSourceMaps: false` in dev (default), or set `devIndicators: true`

## Layer 2: Structured logger

Create `lib/logger.ts` (or `lib/logger.js` if no TypeScript) following the generic contract from Skill.md.

Logger file path: `lib/logger.ts`

### TypeScript template
```ts
const PREFIXES = { debug: 'DEBUG', info: 'INFO ', warn: 'WARN ', error: 'ERROR' } as const;
type Level = keyof typeof PREFIXES;

function getLevel(): Level {
  if (typeof process === 'undefined') return 'warn';
  const env = process.env.LOG_LEVEL as Level | undefined;
  if (env && env in PREFIXES) return env;
  return process.env.NODE_ENV === 'production' ? 'warn' : 'debug';
}

const currentLevel = getLevel();
const levels: Level[] = ['debug', 'info', 'warn', 'error'];

export function logger(context: string) {
  function log(level: Level, message: string, data?: unknown) {
    if (levels.indexOf(level) < levels.indexOf(currentLevel)) return;
    const ts = new Date().toISOString();
    const prefix = PREFIXES[level];
    const base = `${ts} [${prefix}] [${context}] ${message}`;
    if (data instanceof Error) {
      console[level](base, data.stack);
    } else if (data !== undefined) {
      console[level](base, JSON.stringify(data, null, 0));
    } else {
      console[level](base);
    }
  }
  return {
    debug: (msg: string, data?: unknown) => log('debug', msg, data),
    info: (msg: string, data?: unknown) => log('info', msg, data),
    warn: (msg: string, data?: unknown) => log('warn', msg, data),
    error: (msg: string, data?: unknown) => log('error', msg, data),
  };
}
```

### JavaScript template
```js
const PREFIXES = { debug: 'DEBUG', info: 'INFO ', warn: 'WARN ', error: 'ERROR' };

function getLevel() {
  if (typeof process === 'undefined') return 'warn';
  const env = process.env.LOG_LEVEL;
  if (env && env in PREFIXES) return env;
  return process.env.NODE_ENV === 'production' ? 'warn' : 'debug';
}

const currentLevel = getLevel();
const levels = ['debug', 'info', 'warn', 'error'];

export function logger(context) {
  function log(level, message, data) {
    if (levels.indexOf(level) < levels.indexOf(currentLevel)) return;
    const ts = new Date().toISOString();
    const prefix = PREFIXES[level];
    const base = `${ts} [${prefix}] [${context}] ${message}`;
    if (data instanceof Error) {
      console[level](base, data.stack);
    } else if (data !== undefined) {
      console[level](base, JSON.stringify(data, null, 0));
    } else {
      console[level](base);
    }
  }
  return {
    debug: (msg, data) => log('debug', msg, data),
    info: (msg, data) => log('info', msg, data),
    warn: (msg, data) => log('warn', msg, data),
    error: (msg, data) => log('error', msg, data),
  };
}
```

## Layer 3: MCP server config

Next.js 16+ includes built-in MCP support via [`next-devtools-mcp`](https://www.npmjs.com/package/next-devtools-mcp), giving agents runtime access to the app.

Create `.mcp.json` at repo root:

```json
{
  "mcpServers": {
    "next-devtools": {
      "command": "npx",
      "args": ["-y", "next-devtools-mcp@latest"]
    }
  }
}
```

With dev server running, agents get:
- **`get_errors`** / **`get_logs`** — build/runtime errors, console logs
- **`get_page_metadata`** — routes, components, rendering details
- **`get_server_action_by_id`** — inspect Server Action hierarchies
- **`evaluate`** via integrated Playwright MCP — execute JS in browser, inspect memory/DOM, take screenshots, capture console traces

For deeper browser automation (heap snapshots, network inspection, DOM queries), also add [`chrome-devtools-mcp`](https://www.npmjs.com/package/chrome-devtools-mcp).

### Fast Linting
Add lint script to `package.json` if missing: `"lint": "next lint"`. Agents should run `npm run lint -- --quiet` for immediate structural feedback before any test or build step.

### Fast Tests
Configure Vitest with jsdom for component-level tests (no browser):
```
npm install -D vitest @testing-library/react jsdom
```
Run `npx vitest run --project unit` for sub-second feedback. Keep E2E (Playwright) for CI only.

### Velocity Hacks
- **Component-level hot reload only** — disable full-app refresh, iterate per component
- **Contract-first frontend** — freeze API schemas, use mocked backends so agents never wait on backend state
- **Snapshot tests > DOM tests** for agent loops — fast, deterministic, no browser startup
- **Lint-only first signal** — ESLint + TypeScript as immediate syntactic/semantic rejection before tests

For manual debugging via `@modelcontextprotocol/inspector`:
```
npx @modelcontextprotocol/inspector npx -y next-devtools-mcp
```
