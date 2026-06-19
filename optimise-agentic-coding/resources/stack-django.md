# Django Stack Optimisation

Apply these settings when the detected framework is Django.

## Layer 1: Framework-level debug mode

In `settings.py` or `settings/local.py`:
```python
DEBUG = True
```

Add structured logging to `LOGGING` config:
```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'structured': {
            'format': '{asctime} [{levelname}] [{name}] {message}',
            'style': '{',
        },
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'structured',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'DEBUG',
    },
}
```

## Layer 2: Structured logger

Create `app/lib/logger.py` (or `your_app/lib/logger.py`) following the generic contract from Skill.md.

Logger file path: `app/lib/logger.py`

### Python template
```python
import json
import logging
import os
import sys
from datetime import datetime, timezone

LEVELS = {'debug': 0, 'info': 1, 'warn': 2, 'error': 3}
PREFIXES = {'debug': 'DEBUG', 'info': 'INFO ', 'warn': 'WARN ', 'error': 'ERROR'}

def _get_level():
    env = os.environ.get('LOG_LEVEL', '').lower()
    if env in LEVELS:
        return env
    return 'debug' if os.environ.get('DJANGO_SETTINGS_MODULE', '').endswith('.dev') else 'warn'

_CURRENT_LEVEL = _get_level()

def logger(context):
    def _log(level, message, data=None):
        if LEVELS[level] < LEVELS[_CURRENT_LEVEL]:
            return
        ts = datetime.now(timezone.utc).isoformat()
        prefix = PREFIXES[level]
        base = f"{ts} [{prefix}] [{context}] {message}"
        if isinstance(data, BaseException):
            print(f"{base}\n{''.join(traceback.format_exception(type(data), data, data.__traceback__))}", file=sys.stderr)
        elif data is not None:
            print(f"{base} {json.dumps(data, default=str)}", file=sys.stderr if level == 'error' else sys.stdout)
        else:
            print(base, file=sys.stderr if level == 'error' else sys.stdout)
    return {
        'debug': lambda msg, data=None: _log('debug', msg, data),
        'info': lambda msg, data=None: _log('info', msg, data),
        'warn': lambda msg, data=None: _log('warn', msg, data),
        'error': lambda msg, data=None: _log('error', msg, data),
    }
```

## Layer 3: MCP server config

Recommended MCP servers for Django projects. Add relevant ones to `.mcp.json`:

- Database: `npx -y @anthropic/mcp-server-sqlite` (if SQLite) or appropriate DB adapter
- Testing: `npx -y @playwright/mcp` (if using Playwright for browser tests)

Example `.mcp.json`:
```json
{
  "mcpServers": {}
}
```

### Fast Linting
Run `ruff check . --quiet` (10x faster than flake8). For type checking: `mypy --incremental .` Agents should lint before any test or run.

### Fast Tests
Configure pytest with a `fast` marker for unit tests that don't need DB:
```python
# pytest.ini
markers = fast: quick unit tests, no DB
```
Run `pytest -m fast -x --quiet` for sub-second feedback. Full suite is CI-only.

### Velocity Hacks
- **Kill import-time side effects** — lazy imports, no module-level DB/config/env reads; Python loops are slow because imports dominate, not tests
- **Disable pytest plugins aggressively** — coverage, asyncio, xdist (unless needed); minimal plugin set = huge gains
- **Switch hot paths to `mypy --incremental`** — treat type checks as first signal, skip runtime for many iterations
- **Use `uv` for package management** — 10-100x faster than pip

For manual debugging via `@modelcontextprotocol/inspector`:
```
npx @modelcontextprotocol/inspector <command> <args>
```
