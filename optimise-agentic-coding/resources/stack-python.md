# Python Stack Optimisation (FastAPI, Flask, generic)

Apply these settings when the detected framework is a generic Python project (FastAPI, Flask, aiohttp, etc. — not Django).

## Layer 1: Framework-level debug mode

### FastAPI
In `main.py` or entrypoint, ensure reload is enabled for dev:
```python
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", reload=True, log_level="debug")
```
Set `LOG_LEVEL=debug` in `.env` for application logging.

### Flask
In the app factory or entrypoint:
```python
app.config["DEBUG"] = True
app.config["PROPAGATE_EXCEPTIONS"] = True
```
Or set `FLASK_DEBUG=1` and `FLASK_ENV=development` in `.flaskenv`.

### Generic Python
- Enable debug-level logging via `logging.basicConfig(level=logging.DEBUG)`
- Ensure `__debug__` is `True` (default in CPython without `-O`)

### Fast Linting
Run `ruff check . --quiet` (10x faster than flake8). For type checking: `mypy --incremental .` Agents should lint before any test or run.

### Fast Tests
Configure pytest tiers using markers:
```ini
# pytest.ini
markers =
    unit_fast: pure function tests, no fixtures
    contract: API/schema checks
    integration: slow, CI-only
```
Run `pytest -m unit_fast -x --quiet` for sub-second feedback (can be as fast as 0.04s with `uv`). Full suite is CI-only.

### Velocity Hacks
- **Kill import-time side effects** — lazy imports, no module-level DB/config/env reads. Python agent loops are slow because *imports*, not tests, dominate.
- **Use `uv` for package management** — 10-100x faster than pip; parallel resolution, built-in caching
- **Disable pytest plugins aggressively** — coverage, asyncio, xdist (unless needed); minimal plugin set = huge gains
- **`mypy --incremental` as first signal** — skip runtime for many iterations, treat type checks as first feedback
- **`watchfiles` + targeted test triggers** — file→test mapping, only rerun affected tests

## Layer 2: Structured logger

Create `app/lib/logger.py` (or `src/lib/logger.py`) following the generic contract from Skill.md.

Logger file path: `app/lib/logger.py`

### Python template
```python
import json, os, sys, traceback
from datetime import datetime, timezone

LEVELS = {'debug': 0, 'info': 1, 'warn': 2, 'error': 3}
PREFIXES = {'debug': 'DEBUG', 'info': 'INFO ', 'warn': 'WARN ', 'error': 'ERROR'}

def _get_level():
    env = os.environ.get('LOG_LEVEL', '').lower()
    if env in LEVELS:
        return env
    return 'debug' if os.environ.get('DEV') else 'warn'

_CURRENT_LEVEL = _get_level()

def logger(context):
    def _log(level, message, data=None):
        if LEVELS.get(level, 99) < LEVELS[_CURRENT_LEVEL]:
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

Recommended MCP servers for Python projects. Add relevant ones to `.mcp.json`:

- Database: MCP server matching the project's database
- Testing: appropriate test runner MCP
- Codebase indexing: `npx -y @anthropic/mcp-server-codebase-indexer`

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
