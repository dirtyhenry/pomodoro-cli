# AGENTS.md

This file provides guidance to coding agents when working with code in this repository.

## Build Commands

```bash
# Install/update dependencies
make install

# Build debug
make build

# Build and run a quick test (5 second pomodoro)
make run-test

# Build release and install to /usr/local/bin
make deploy

# Run tests
swift test

# Run a single test
swift test --filter TimeIntervalFormatterTests

# Format code
make format

# Lint code
make lint
```

## Architecture

This is a Swift CLI tool built with Swift Package Manager. The executable is `pomodoro-cli`.

**Target structure:**

- `PomodoroCLI` - Executable target with `RootCommand.swift` (entry point using swift-argument-parser)
- `Pomodoro` - Library target with core logic
- `PomodoroTests` - Test target

**Key components in the Pomodoro library:**

- `TimerViewCLI` - Main CLI view that manages the timer display, progress bar, interrupt handling, and coordinates hooks/logging
- `TimerViewModel` - Tracks timer state (start date, duration, progress)
- `Hook` - Executes shell scripts at pomodoro lifecycle events (didStart/didFinish) from `~/.pomodoro-cli/`
- `LogWriter` - Writes completed pomodoros to `~/.pomodoro-cli/journal.yml`
- `PomodoroDescription` - Value type holding pomodoro data (duration, message, start/end dates)
- `InterruptHandler` - Handles Ctrl+C signals for graceful interruption

**Dependencies:**

- `swift-argument-parser` - CLI argument parsing
- `swift-blocks` (dirtyhenry/swift-blocks) - Utility library (provides `CLIUtils`, `Blocks`)
