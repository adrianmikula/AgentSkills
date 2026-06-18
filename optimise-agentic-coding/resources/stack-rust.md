# Rust Stack Optimisation

Apply these settings when the detected language is Rust (Cargo.toml present).

## Layer 1: Framework-level debug mode

- Ensure debug symbols are enabled in `Cargo.toml` for dev profile:
  ```toml
  [profile.dev]
  debug = true
  ```
- For web frameworks (Actix, Axum, Rocket): enable debug-level logging via `RUST_LOG=debug` environment variable
- For verbose request logging in web frameworks, use `tower-http`'s `TraceLayer` (Actix/Axum) or framework equivalent

## Layer 2: Structured logger

Create `src/logger.rs` following the generic contract from Skill.md.

Logger file path: `src/logger.rs`

### Rust template
```rust
use std::sync::atomic::{AtomicU8, Ordering};
use std::time::SystemTime;

const LEVELS: &[&str] = &["DEBUG", "INFO ", "WARN ", "ERROR"];
const NAMES: &[&str] = &["debug", "info", "warn", "error"];

static CURRENT_LEVEL: AtomicU8 = AtomicU8::new(0);

fn get_level() -> u8 {
    let env = std::env::var("LOG_LEVEL").unwrap_or_default();
    match env.as_str() {
        "debug" => 0,
        "info" => 1,
        "warn" => 2,
        "error" => 3,
        _ => {
            if cfg!(debug_assertions) { 0 } else { 2 }
        }
    }
}

pub fn init() {
    CURRENT_LEVEL.store(get_level(), Ordering::Relaxed);
}

pub fn logger(context: &'static str) -> Logger {
    Logger { context }
}

pub struct Logger {
    context: &'static str,
}

impl Logger {
    fn log(&self, level: u8, message: &str, data: Option<&dyn std::fmt::Debug>) {
        if level < CURRENT_LEVEL.load(Ordering::Relaxed) {
            return;
        }
        let ts = std::time::UNIX_EPOCH.elapsed().unwrap_or_default().as_secs();
        let prefix = LEVELS[level as usize];
        let name = NAMES[level as usize];
        match data {
            Some(d) => eprintln!("{ts} [{prefix}] [{}] {message} {d:?}", self.context),
            None => eprintln!("{ts} [{prefix}] [{}] {message}", self.context),
        }
    }

    pub fn debug(&self, message: &str, data: Option<&dyn std::fmt::Debug>) {
        self.log(0, message, data);
    }
    pub fn info(&self, message: &str, data: Option<&dyn std::fmt::Debug>) {
        self.log(1, message, data);
    }
    pub fn warn(&self, message: &str, data: Option<&dyn std::fmt::Debug>) {
        self.log(2, message, data);
    }
    pub fn error(&self, message: &str, data: Option<&dyn std::fmt::Debug>) {
        self.log(3, message, data);
    }
}
```

## Layer 3: MCP server config

Recommended MCP servers for Rust projects. Add relevant ones to `.mcp.json`:

- Testing: `cargo test` can be wrapped via MCP
- Database: MCP server matching the project's database

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
