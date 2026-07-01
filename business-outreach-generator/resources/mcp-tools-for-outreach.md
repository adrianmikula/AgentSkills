# MCP Tools for Outreach Automation

MCP (Model Context Protocol) servers give AI agents direct API access to social platforms.

---

## Recommended Setup

| Tool | For | Install Method | Why |
|------|-----|---------------|-----|
| [William-Gao/instagram-mcp](https://github.com/William-Gao/instagram-mcp) | Instagram publishing, comments, DMs, hashtags, insights | `git clone` + `pip install -e .` inside `.mcp/instagram-mcp/` | Only official-API Instagram MCP that works **without a Facebook Page** (IG Login auth). 27 tools. |
| [jordanburke/reddit-mcp-server](https://github.com/jordanburke/reddit-mcp-server) | Reddit search, subreddit browsing, post/comment reading | `npx reddit-mcp-server` | 163★, 10 releases, npm-published, actively maintained. Most trusted Reddit MCP. |
| [andrezani/outpost-mcp](https://github.com/andrezani/outpost-mcp) | Cross-platform (X, LinkedIn, IG, Reddit, Bluesky, Threads) | `npx @outpost/mcp-server` | **Future use** — single API key for 6 platforms. Pre-production as of Mar 2026 (OAuth not yet deployed). Switch to once production-ready. |

---

## Credential Safety

Real API credentials **must never be committed to git**. The repository uses an example-file pattern to keep secrets out of source control:

| Agent | Example File (committed) | Real File (gitignored) |
|-------|-------------------------|----------------------|
| Kilo Code | `.kilocode/mcp.example.json` | `.kilocode/mcp.json` |
| Opencode | `.opencode/config.example.json` | `.opencode/config.json` |
| Devin (shared) | `.devin/config.json` (committed with empty values) | — |
| Devin (local) | `.devin/config.local.example.json` | `.devin/config.local.json` |

### Setup flow

1. **Copy the example** to the real location:
   ```bash
   cp .kilocode/mcp.example.json .kilocode/mcp.json
   cp .opencode/config.example.json .opencode/config.json
   cp .devin/config.local.example.json .devin/config.local.json   # Devin only
   ```
2. **Edit the real file(s)** with your API keys.
3. **Replace `PROJECT_ROOT`** in `command` paths with the absolute path to this project (e.g., `/home/user/project`).
4. The real files are listed in `.gitignore` and will never be committed.

> For Devin, `.devin/config.json` is safe to commit — it holds empty credential placeholders. Secrets go in the gitignored `.devin/config.local.json` which overrides the shared values.

---

## Instagram — William-Gao/instagram-mcp

**GitHub:** https://github.com/William-Gao/instagram-mcp  
**Auth:** Instagram Login token (IGAA) — no Facebook Page required for 24 core tools  
**Tools:** 27 (profile, media, publishing, comments, DMs, insights, hashtags)  
**Ban risk:** None — official Meta API

### Key capabilities

- `publish_image`, `publish_carousel`, `publish_reel`, `publish_story`
- `list_comments`, `reply_to_comment`, `hide_comment`, `delete_comment`
- `list_conversations`, `get_conversation`, `send_dm` (requires Meta App Review)
- `search_hashtag`, `get_hashtag_media`, `hashtag_top_media`, `hashtag_recent_media`
- `get_account_insights`, `get_media_insights`
- `business_discovery` — read any public Professional account (requires FB token)

### Install

```bash
git clone https://github.com/William-Gao/instagram-mcp.git .mcp/instagram-mcp
python3 -m venv .mcp/instagram-mcp/.venv
.mcp/instagram-mcp/.venv/bin/pip install -e .mcp/instagram-mcp
```

The `.mcp/` directory is gitignored — clone and install once.

### Config

All configs point to the venv python. Replace `PROJECT_ROOT` with the absolute path to this project.

> **Setup:** Copy the example file, replace `PROJECT_ROOT`, and fill in credentials. See [Credential Safety](#credential-safety) above.

**Kilo Code** — edit `.kilocode/mcp.json` (copy from `.kilocode/mcp.example.json`):
```json
{
  "mcpServers": {
    "instagram": {
      "command": "PROJECT_ROOT/.mcp/instagram-mcp/.venv/bin/python",
      "args": ["-m", "instagram_mcp"],
      "env": {
        "INSTAGRAM_ACCESS_TOKEN": ""
      }
    }
  }
}
```

**Devin** — `.devin/config.json` (committed, empty values shared):
```json
{
  "mcpServers": {
    "instagram": {
      "command": "PROJECT_ROOT/.mcp/instagram-mcp/.venv/bin/python",
      "args": ["-m", "instagram_mcp"],
      "env": {
        "INSTAGRAM_ACCESS_TOKEN": ""
      }
    }
  }
}
```
Secrets go in `.devin/config.local.json` (gitignored, copy from `.devin/config.local.example.json`):
```json
{
  "mcpServers": {
    "instagram": {
      "env": {
        "INSTAGRAM_ACCESS_TOKEN": ""
      }
    }
  }
}
```

**Opencode** — edit `.opencode/config.json` (copy from `.opencode/config.example.json`):
```json
{
  "mcpServers": {
    "instagram": {
      "command": "PROJECT_ROOT/.mcp/instagram-mcp/.venv/bin/python",
      "args": ["-m", "instagram_mcp"],
      "env": {
        "INSTAGRAM_ACCESS_TOKEN": ""
      }
    }
  }
}
```

---

## Reddit — jordanburke/reddit-mcp-server

**GitHub:** https://github.com/jordanburke/reddit-mcp-server  
**Auth:** Reddit OAuth 2.0 (script app)  
**Tools:** ~10 (search, browse, read posts/comments, user info)  
**npm:** `reddit-mcp-server`

### Key capabilities

- `search_reddit` — search posts across Reddit
- `browse_subreddit` — browse by hot/new/top/rising/controversial
- `get_reddit_post` — full post + engagement analysis
- `get_post_comments` — threaded comments
- `get_user_info`, `get_user_posts`, `get_user_comments`
- `get_subreddit_info`, `get_trending_subreddits`

### Config

> **Setup:** Copy the example file and fill in credentials. See [Credential Safety](#credential-safety) above.

**Kilo Code** — edit `.kilocode/mcp.json` (copy from `.kilocode/mcp.example.json`):
```json
{
  "mcpServers": {
    "reddit": {
      "command": "npx",
      "args": ["reddit-mcp-server"],
      "env": {
        "REDDIT_CLIENT_ID": "",
        "REDDIT_CLIENT_SECRET": "",
        "REDDIT_USERNAME": "",
        "REDDIT_PASSWORD": ""
      }
    }
  }
}
```

**Devin** — `.devin/config.json` (committed, empty values shared):
```json
{
  "mcpServers": {
    "reddit": {
      "command": "npx",
      "args": ["reddit-mcp-server"],
      "env": {
        "REDDIT_CLIENT_ID": "",
        "REDDIT_CLIENT_SECRET": "",
        "REDDIT_USERNAME": "",
        "REDDIT_PASSWORD": ""
      }
    }
  }
}
```
Secrets go in `.devin/config.local.json` (gitignored):
```json
{
  "mcpServers": {
    "reddit": {
      "env": {
        "REDDIT_CLIENT_ID": "",
        "REDDIT_CLIENT_SECRET": "",
        "REDDIT_USERNAME": "",
        "REDDIT_PASSWORD": ""
      }
    }
  }
}
```

**Opencode** — edit `.opencode/config.json` (copy from `.opencode/config.example.json`):
```json
{
  "mcpServers": {
    "reddit": {
      "command": "npx",
      "args": ["reddit-mcp-server"],
      "env": {
        "REDDIT_CLIENT_ID": "",
        "REDDIT_CLIENT_SECRET": "",
        "REDDIT_USERNAME": "",
        "REDDIT_PASSWORD": ""
      }
    }
  }
}
```

---

## Future: Outpost (Cross-Platform)

**GitHub:** https://github.com/andrezani/outpost-mcp  
**Status:** Pre-production (OAuth env vars not yet configured as of Mar 2026)

Once production-ready, Outpost replaces individual per-platform MCP servers for basic publishing. A single API key and a single `publish_post` call covers X, LinkedIn, Instagram, Reddit, Bluesky, and Threads.

**Install when ready:**

> Setup follows the same example-file pattern. Once `@outpost/mcp-server` is published, add it to the configs below.

**Kilo Code** — edit `.kilocode/mcp.json`:
```json
{
  "mcpServers": {
    "outpost": {
      "command": "npx",
      "args": ["@outpost/mcp-server"],
      "env": {
        "OUTPOST_API_KEY": ""
      }
    }
  }
}
```

**Devin** — `.devin/config.json` (shared, empty values):
```json
{
  "mcpServers": {
    "outpost": {
      "command": "npx",
      "args": ["@outpost/mcp-server"],
      "env": {
        "OUTPOST_API_KEY": ""
      }
    }
  }
}
```
Secrets go in `.devin/config.local.json` (gitignored):
```json
{
  "mcpServers": {
    "outpost": {
      "env": {
        "OUTPOST_API_KEY": ""
      }
    }
  }
}
```

**Opencode** — edit `.opencode/config.json`:
```json
{
  "mcpServers": {
    "outpost": {
      "command": "npx",
      "args": ["@outpost/mcp-server"],
      "env": {
        "OUTPOST_API_KEY": ""
      }
    }
  }
}
```

Monitor the repo for a production release announcement.

---

## Connection to Outreach Formats

| Format | MCP Server | Tools Used |
|--------|-----------|------------|
| Email | None (use Resend/SendGrid directly) | — |
| LinkedIn | Outpost (when ready) | `publish_post` |
| Phone | None (manual) | — |
| Reddit | **jordanburke/reddit-mcp-server** | Search, browse, read posts/comments |
| StackOverflow | None (API too restrictive) | Manual only |
| Instagram | **William-Gao/instagram-mcp** | Publish carousels/reels, comments, DMs, hashtag research |
| Airtasker | None (no public MCP server) | Manual only |
