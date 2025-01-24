# Hidden Hooks

A way to defer hooks to reduce dependencies.

Sometimes we need callbacks that break dependencies. This gem allows to invert those dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hidden_hooks', '~> 1.0'
```

And then execute:

```bash
$ bundle
```

Or you can install the gem on its own:

```bash
gem install hidden_hooks
```

## Usage

TODO

## Version numbers

Hidden Hooks loosely follows [Semantic Versioning](https://semver.org/), with a hard guarantee that breaking changes to the public API will always coincide with an increase to the `MAJOR` number.

Version numbers are in three parts: `MAJOR.MINOR.PATCH`.

- Breaking changes to the public API increment the `MAJOR`. There may also be changes that would otherwise increase the `MINOR` or the `PATCH`.
- Additions, deprecations, and "big" non breaking changes to the public API increment the `MINOR`. There may also be changes that would otherwise increase the `PATCH`.
- Bug fixes and "small" non breaking changes to the public API increment the `PATCH`.

Notice that any feature deprecated by a minor release can be expected to be removed by the next major release.

## Changelog

Full list of changes in [CHANGELOG.md](CHANGELOG.md)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/moku-io/hidden_hooks.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
