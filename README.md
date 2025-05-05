# 🍅 Pomodoro CLI

Pomodoro is a command-line interface to run timers from your terminal for people using the [Pomodoro Technique](https://en.wikipedia.org/wiki/Pomodoro_Technique).

I started this project in 2017, as a pet project to learn how to write a CLI in [Swift](https://swift.org). I never stopped writing CLI tools from then.

<div align="center">
  <img src="https://github.com/dirtyhenry/pomodoro-cli/blob/main/Resources/usage-carbon.png?raw=true" alt="pomodoro-cli usage example" width="673" height="250">
  </a>
</div>

## Usage

```
➜ Usage: pomodoro-cli [options]

CLI pomodoro

Options:
  -d, --duration <value>    The duration of the pomodoro in seconds (100) or in minutes (10m) (default to 25m)
  -h, --help                Show help information
  -m, --message <value>     The intent of the pomodoro (example: email zero)
```

## Hooks

Pomodoro can optionally run shell scripts when a pomodoro starts and/or finishes.

Sample scripts can be found in [the `SampleHooks` directory](https://github.com/dirtyhenry/pomodoro-cli/blob/main/Resources/SampleHooks).

## Journal

A journal of pomodoros is created in `~/.pomodoro-cli/journal.yml`.

## Installation

### From Source

To install from sources, [Swift](https://swift.org/getting-started/) is required.

Installing `swiftlint` and `swiftformat` via [Homebrew](https://brew.sh/), and having installed [Ruby](https://www.ruby-lang.org/fr/)/[Bundler](https://bundler.io) are recommended for an easy installation.

- `make install` will install development dependencies;
- `make deploy` will build a release binary, move it to `/usr/local/bin` by default, with default hooks installed;

Check out [`Makefile`](https://github.com/dirtyhenry/pomodoro-cli/blob/main/Makefile) for more development convenience commands.

### From Distribution Images

The `.dmg` files are created via:

```
make clean notarize
# and upon successful feedback from the Apple notary service:
make image
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)

[blog-post]: https://mickf.net/tech/swift-command-line-pomodoro/
