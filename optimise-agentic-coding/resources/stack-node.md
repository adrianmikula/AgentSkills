# Node.js / Express Stack Optimisation

Apply these settings when the detected framework is Express.js or a generic Node.js framework (not Next.js).

## Layer 1: Framework-level debug mode

Enable verbose dev logging:
- Set `NODE_ENV=development` and `DEBUG=express:*` (or framework equivalent) in `.env` or dev scripts
- Ensure source maps are enabled: `"sourceMap": true` in `tsconfig.json`, or `"devtool": "eval-source-map"` in webpack config
- For Express: add morgan for structured request logging (`npm install morgan` is acceptable — it is a standard dev dependency)

```js
// In app.js/entry point (before migration to logger)
if (process.env.NODE_ENV === 'development') {
  app.use(require('morgan')('dev'));
}
```

## Layer 2: Structured logger

Create `lib/logger.js` (or `lib/logger.ts` if TypeScript is detected) following the generic contract from Skill.md.

Logger file path: `lib/logger.js` (use `.ts` if TypeScript)

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

### TypeScript template (use if `tsconfig.json` detected)
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

## Layer 3: MCP server config

Recommended MCP servers for Node.js projects. Add relevant ones to `.mcp.json`:

- Database: MCP server matching the project's database
- Testing: `npx -y @playwright/mcp` (if using Playwright)
- Error monitoring: if Sentry is detected, reference the Sentry MCP

Example `.mcp.json`:
```json
{
  "mcpServers": {}
}
```

For manual debugging via `@modelcontextprotocol/inspector`:
```
npx @modelcontextprotocol/inspector <command> <args>
```
