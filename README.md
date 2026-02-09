# 🍅 Pomodoro CLI

Pomodoro is a command-line interface to run timers from your terminal for people using the [Pomodoro Technique](https://en.wikipedia.org/wiki/Pomodoro_Technique).

[I started this project in 2017][blog-post], as a pet project to learn how to write a CLI in [Swift](https://swift.org). I never stopped writing command-line tools from then.

<div align="center">
  <img src="https://github.com/dirtyhenry/pomodoro-cli/blob/main/Resources/usage-carbon.png?raw=true" alt="pomodoro-cli usage example" width="673" height="250">
</div>

## Usage

### Basic Examples

```bash
# Standard 25-minute pomodoro
pomodoro-cli -m "Write documentation"

# Custom duration (5 minutes)
pomodoro-cli -d 5m -m "Quick review"

# Duration in seconds
pomodoro-cli -d 300 -m "Five minute break"

# Indefinite pomodoro (for meetings with unknown duration)
pomodoro-cli --indefinite -m "Team meeting"

# Catch-up mode (log a pomodoro that already happened)
pomodoro-cli --catch-up -m "Forgot to log earlier work"
```

### Available Options

| Option                   | Description                                       | Default                 |
| ------------------------ | ------------------------------------------------- | ----------------------- |
| `-d, --duration <value>` | Duration in seconds (100) or minutes (10m)        | 25m                     |
| `-m, --message <value>`  | Description of the pomodoro's intent              | Prompts if not provided |
| `--indefinite`           | Run indefinitely until interrupted (for meetings) | Off                     |
| `--catch-up`             | Exit immediately, only run finish hook            | Off                     |
| `-h, --help`             | Show help information                             | -                       |

## Features

### Interrupt Handling

Press **Ctrl+C** during a running pomodoro to see an interactive menu:

1. **Exit without saving** - Abandon the pomodoro (no hooks, no journal entry)
2. **Save shortened pomodoro** - Record the actual time worked with hooks and journal

**Double Ctrl+C** forces immediate exit without any prompts.

**Use case**: Perfect for when emergencies arise or priorities shift mid-pomodoro.

### Indefinite Mode

Use `--indefinite` for meetings or tasks with unknown duration:

- Timer shows elapsed time: `Running: 5m 23s...` (updates every second)
- No progress bar (since there's no known end time)
- Must be stopped with Ctrl+C to finish
- When saved, records actual duration in journal and calls hooks with real times

**Use case**: Ideal for meetings, pair programming sessions, or any task where you don't know the duration upfront.

## Hooks

Hooks let you run custom shell scripts when a pomodoro starts and/or finishes. This is one of the most powerful features of pomodoro-cli — you can integrate with any tool or service.

### Setup

1. Create the hooks directory (if it doesn't exist):
   ```bash
   mkdir -p ~/.pomodoro-cli
   ```

2. Create your hook scripts:
   ```bash
   touch ~/.pomodoro-cli/pomodoro-start.sh
   touch ~/.pomodoro-cli/pomodoro-finish.sh
   ```

3. Make them executable:
   ```bash
   chmod +x ~/.pomodoro-cli/pomodoro-start.sh
   chmod +x ~/.pomodoro-cli/pomodoro-finish.sh
   ```

Both hooks are optional — create only the ones you need.

### Hook Parameters

Both hooks receive 4 arguments:

| Parameter | Description                        | Example                    |
| --------- | ---------------------------------- | -------------------------- |
| `$1`      | Start date (ISO8601 format)        | `2025-11-17T10:30:00.123Z` |
| `$2`      | End date (ISO8601 or "indefinite") | `2025-11-17T10:55:00.123Z` |
| `$3`      | Duration (seconds or "indefinite") | `1500.0`                   |
| `$4`      | Message                            | `Write documentation`      |

**Note**: For indefinite pomodoros, the start hook receives `"indefinite"` for end date and duration. The finish hook always receives actual values.

### Examples

#### Basic notification (finish hook)

```bash
#!/usr/bin/env bash
set -e
MESSAGE=$4
osascript -e "display notification \"$MESSAGE\" with title \"Pomodoro Complete!\""
```

#### Text-to-speech announcements

```bash
#!/usr/bin/env bash
set -e
# Start hook: Italian-accented motivation
/usr/bin/say --voice=Alice "Andiamo a lavorare!"
```

```bash
#!/usr/bin/env bash
set -e
# Finish hook: Announce completion and lock screen
/usr/bin/say --voice=Alice "Il pomodoro è finito."
sleep 5
/usr/bin/pmset displaysleepnow
```

#### Log to SQLite database

```bash
#!/usr/bin/env bash
set -e

DATABASE="$HOME/pomodoros.sqlite"

# Create table if needed
sqlite3 "$DATABASE" <<EOF
CREATE TABLE IF NOT EXISTS pomodoros (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  start TEXT NOT NULL,
  end TEXT NOT NULL,
  message TEXT
);
EOF

# Escape single quotes for SQL
SAFE_MESSAGE="${4//\'/\'\'}"

sqlite3 "$DATABASE" <<EOF
INSERT INTO pomodoros (start, end, message) VALUES ('$1', '$2', '$SAFE_MESSAGE');
EOF
```

#### Integration with Focus apps

```bash
#!/usr/bin/env bash
set -e
# Start hook: Enable focus mode
/usr/bin/open focus://focus
```

```bash
#!/usr/bin/env bash
set -e
# Finish hook: Disable focus mode
/usr/bin/open focus://unfocus
```

#### Play a sound

```bash
#!/usr/bin/env bash
set -e
afplay /System/Library/Sounds/Glass.aiff
```

More sample scripts can be found in [the `SampleHooks` directory](https://github.com/dirtyhenry/pomodoro-cli/blob/main/Resources/SampleHooks).

### Note on `make deploy`

When installing from source with `make deploy`, sample hooks are only copied if no hooks exist yet. Your custom hooks are never overwritten.

## Journal

A journal of all completed pomodoros is automatically maintained at `~/.pomodoro-cli/journal.yml`.

### Format

The journal uses YAML format with the following structure:

```yaml
- - startDate: 11/17/25, 10:30:15 AM
  - endDate: 11/17/25, 10:55:15 AM
  - message: Write documentation
- - startDate: 11/17/25, 11:00:42 AM
  - endDate: 11/17/25, 11:05:42 AM
  - message: Quick review
- - startDate: 11/17/25, 2:15:30 PM
  - endDate: 11/17/25, 2:47:18 PM
  - message: Team meeting
```

**Note**: Duration can be calculated from the difference between start and end dates. Shortened and indefinite pomodoros record their actual elapsed time.

## Installation

### From Source

To install from sources, [Swift](https://swift.org/getting-started/) is required.

Installing `swiftlint` and `swiftformat` via [Homebrew](https://brew.sh/) is recommended for an easy installation.

- `make install` will install development dependencies;
- `make deploy` will build a release binary, move it to `/usr/local/bin` by default, with default hooks installed;

Check out [`Makefile`](https://github.com/dirtyhenry/pomodoro-cli/blob/main/Makefile) for more development convenience commands.

### From GitHub Releases

Download the latest `.dmg` or `.pkg` from [GitHub Releases](https://github.com/dirtyhenry/pomodoro-cli/releases).

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)

[blog-post]: https://mickf.net/tech/swift-command-line-pomodoro/
