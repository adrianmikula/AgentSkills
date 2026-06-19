# Rails Stack Optimisation

Apply these settings when the detected framework is Ruby on Rails.

## Layer 1: Framework-level debug mode

In `config/environments/development.rb`:
```ruby
config.log_level = :debug
config.log_tags  = [:request_id, :remote_ip]
```

Ensure `config.consider_all_requests_local = true` is set (default in dev).

## Layer 2: Structured logger

Create `lib/logger.rb` following the generic contract from Skill.md.

Logger file path: `lib/logger.rb`

### Ruby template
```ruby
require 'json'

LEVELS = { debug: 0, info: 1, warn: 2, error: 3 }.freeze
PREFIXES = { debug: 'DEBUG', info: 'INFO ', warn: 'WARN ', error: 'ERROR' }.freeze

def log_level
  env = ENV['LOG_LEVEL']&.to_sym
  return env if LEVELS.key?(env)
  ENV['RAILS_ENV'] == 'production' ? :warn : :debug
end

CURRENT_LEVEL = log_level

def logger(context)
  ->(level, message, data = nil) do
    return if LEVELS[level] < LEVELS[CURRENT_LEVEL]
    ts = Time.now.utc.iso8601(3)
    prefix = PREFIXES[level]
    base = "#{ts} [#{prefix}] [#{context}] #{message}"
    if data.is_a?(Exception)
      Rails.logger.send(level, "#{base}\n#{data.full_message}")
    elsif data
      Rails.logger.send(level, "#{base} #{data.to_json}")
    else
      Rails.logger.send(level, base)
    end
  end
end
```

Usage after creation:
```ruby
logger('payments').call(:warn, 'payment declined', { user_id: 42 })
logger('auth').call(:error, 'login failed', error)
```

## Layer 3: MCP server config

Create `.mcp.json` at repo root:

```json
{
  "mcpServers": {
    "rails": {
      "command": "bundle",
      "args": ["exec", "rails", "server", "--mcp"]
    }
  }
}
```

### Fast Linting
Run `rubocop --quiet` before any test: `bundle exec rubocop --only lint`. Catches syntax/style issues instantly.

### Fast Tests
Configure RSpec with only unit specs (no DB, no fixtures, no integration):
```ruby
# In spec/spec_helper.rb or .rspec
--tag ~integration
--tag ~slow
```
Run `bundle exec rspec spec/unit --tag fast` for sub-second feedback.

### Velocity Hacks
- **Kill DB-heavy tests in inner loop** — use factory defaults, avoid full DB setup for every iteration
- **Minimal Gemfile for dev** — split production gems into groups; fewer loaded gems = faster boot
- **Lint-first signal** — RuboCop as first check before any test runtime

For manual debugging via `@modelcontextprotocol/inspector`:
```
npx @modelcontextprotocol/inspector bundle exec rails server --mcp
```
