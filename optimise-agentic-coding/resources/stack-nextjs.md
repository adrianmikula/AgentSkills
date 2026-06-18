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

Create `.mcp.json` at repo root:

```json
{
  "mcpServers": {
    "next-devtools": {
      "command": "npx",
      "args": ["-y", "next-devtools-mcp"]
    }
  }
}
```

For manual debugging via `@modelcontextprotocol/inspector`:
```
npx @modelcontextprotocol/inspector npx -y next-devtools-mcp
```
