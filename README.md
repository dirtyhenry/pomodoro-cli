# 🍅 Pomodoro CLI

Pomodoro is a [Swift](https://swift.org) command line tool to help you implement the [Pomodoro Technique](https://en.wikipedia.org/wiki/Pomodoro_Technique) from your terminal.

When I started this project, I wrote a [blog post][blog-post] on my motivations on [bootstragram.com][bootstragram].

## Usage

<div align="center">
  <img src="https://github.com/dirtyhenry/pomodoro-cli/blob/master/Resources/usage-carbon.png?raw=true" alt="pomodoro-cli usage example" width="673" height="250">
  </a>
</div>

```
➜ pomodoro-cli --help
> Usage:

    $ pomodoro-cli

Options:
--duration [default: 25m] - The duration of the pomodoro in seconds (100) or in minutes (10m).
```

## Hooks

Pomodoro can optionnaly run shell scripts when a pomodoro starts and/or finished.

Sample scripts can be found in [the `SampleHooks` directory](https://github.com/dirtyhenry/pomodoro-cli/blob/master/Resources/SampleHooks).

## Installation

To install from sources, [Swift](https://swift.org/getting-started/) is required.

[Homebrew](https://brew.sh/) and [Ruby](https://www.ruby-lang.org/fr/)/[Bundler](https://bundler.io) are recommended for an easy installation.

- `make install` will install development dependencies;
- `make deploy` will build a release binary, move it to `/usr/local/bin` by default, with default hooks installed;

Check out [`Makefile`](https://github.com/dirtyhenry/pomodoro-cli/blob/master/Makefile) for more development convenience commands.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)

[blog-post]: https://bootstragram.com/blog/swift-command-line-pomodoro/
[bootstragram]: https://bootstragram.com
