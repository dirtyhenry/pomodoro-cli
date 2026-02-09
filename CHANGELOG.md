# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Support for Ctrl+C to gracefully interrupt a running pomodoro
- `--catch-up` flag to run hooks only (without starting a timer)
- Hooks now receive pomodoro metadata (duration, message, timestamps)
- Sample hooks for SQLite database integration

### Changed

- Migrated to Swift 5.9
- Removed `swift-tools-support-core` dependency
- Modernized Swift style with more idiomatic patterns

### Fixed

- Single quote escaping in bash parameter expansion
- Single quote escaping in SQL insertion for hooks

## [1.1.0] - 2023-03-29

### Added

- Distribution pipeline with Apple notarization support
- Short argument versions (`-d` for `--duration`, `-m` for `--message`)
- DocC documentation (replacing Jazzy)

### Changed

- Migrated from `altool` to `notarytool` for notarization
- Upgraded to Swift 5.5
- Replaced SwiftCLI with ArgumentParser

### Fixed

- macOS Monterey compatibility (removed units when calling sleep)
- Runtime issue with SwiftToolsSupport-auto product

## [1.0.1] - 2020-02-01

### Fixed

- Hooks are now activated by default

## [1.0.0] - 2017-11-04

### Added

- Initial release
- Pomodoro timer with configurable duration
- Progress bar display
- Message support with journaling to `~/.pomodoro-cli/journal.yml`
- Hook system for custom scripts at pomodoro start/finish
- Human-readable duration format (e.g., "25m", "1h30m")

[Unreleased]: https://github.com/dirtyhenry/pomodoro-cli/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/dirtyhenry/pomodoro-cli/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/dirtyhenry/pomodoro-cli/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/dirtyhenry/pomodoro-cli/releases/tag/v1.0.0
