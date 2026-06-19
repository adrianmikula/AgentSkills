# .NET / C# Stack Optimisation

Apply these settings when the detected project contains `*.csproj` files.

## Layer 1: Framework-level debug mode

In `appsettings.Development.json`:
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "Microsoft.AspNetCore": "Information"
    }
  }
}
```

Ensure source maps are generated for debug builds in `.csproj`:
```xml
<PropertyGroup Condition="'$(Configuration)' == 'Debug'">
  <DebugType>full</DebugType>
  <Optimize>false</Optimize>
</PropertyGroup>
```

## Layer 2: Structured logger

Create `Lib/Logger.cs` (or `src/Lib/Logger.cs`) following the generic contract from Skill.md.

Logger file path: `Lib/Logger.cs`

### C# template
```csharp
using System;
using System.Text.Json;
using System.Collections.Generic;

public static class Logger
{
    private static readonly Dictionary<string, int> Levels = new()
    {
        ["debug"] = 0, ["info"] = 1, ["warn"] = 2, ["error"] = 3
    };

    private static readonly Dictionary<string, string> Prefixes = new()
    {
        ["debug"] = "DEBUG", ["info"] = "INFO ", ["warn"] = "WARN ", ["error"] = "ERROR"
    };

    private static int _currentLevel = -1;

    private static int GetLevel()
    {
        if (_currentLevel >= 0) return _currentLevel;
        var env = Environment.GetEnvironmentVariable("LOG_LEVEL")?.ToLower();
        if (env != null && Levels.ContainsKey(env))
            _currentLevel = Levels[env];
        else
        #if DEBUG
            _currentLevel = 0;
        #else
            _currentLevel = 2;
        #endif
        return _currentLevel;
    }

    public static Action<string, object?> Log(string context)
    {
        var current = GetLevel();
        return (level, data) =>
        {
            if (!Levels.TryGetValue(level, out var lvl) || lvl < current) return;
            var ts = DateTime.UtcNow.ToString("O");
            var prefix = Prefixes[level];
            var message = data?.ToString() ?? "";
            Console.Error.WriteLine($"{ts} [{prefix}] [{context}] {message}");
        };
    }
}
```

## Layer 3: MCP server config

Recommended MCP servers for .NET projects. Add relevant ones to `.mcp.json`:

- Testing: appropriate test runner MCP
- Database: MCP server matching the project's database

Example `.mcp.json`:
```json
{
  "mcpServers": {}
}
```

### Fast Linting
Run `dotnet format --verify-no-changes --severity error` for immediate syntax/style feedback. Use `dotnet build --no-restore -warnaserror` for compile-time checks only.

### Fast Tests
Create a `FastTests` category and run only those:
```
dotnet test --filter "Category=FastTests" --no-restore
```
Keep integration tests (`Category=Integration`) for CI only.

### Velocity Hacks
- **No heavy DI in inner loop** — test pure logic with plain constructors, skip service provider setup
- **Pre-compile dependencies** — use NuGet fallback folders to avoid restore during iteration
- **Source generators over reflection** — AOT-friendly, faster startup, no runtime discovery

For manual debugging via `@modelcontextprotocol/inspector`:
```
npx @modelcontextprotocol/inspector <command> <args>
```
