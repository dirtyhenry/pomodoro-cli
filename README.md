# 🍅 Pomodoro CLI

Pomodoro is a [Swift](https://swift.org) command line tool to help you implement the [Pomodoro Technique](https://en.wikipedia.org/wiki/Pomodoro_Technique) from your terminal.

When I started this project, I wrote a [blog post][blog-post] on my motivations on [bootstragram.com][bootstragram].

## Installation

First, make sure [Homebrew](https://brew.sh/) & [Swift](https://swift.org/getting-started/) are installed on your environment.

Then:

```bash
make install
make deploy
```

## Usage

<div align="center">
  <img src="https://github.com/dirtyhenry/pomodoro-cli/blob/master/docs/assets/usage-carbon.png?raw=true" alt="pomodoro-cli usage example" width="673" height="250">
  </a>
</div>

```
> pomodoro-cli --help
Usage:

    $ .build/debug/PomodoroCLI

Options:
    --duration [default: 1500] - The duration of the pomodoro in seconds (100) or in minutes (10m).
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)

[blog-post]: https://bootstragram.com/blog/swift-command-line-pomodoro/
[bootstragram]: https://bootstragram.com
