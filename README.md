# take

IO capture for Gleam tests. Intercepts `stdout`, `stderr`, or both and returns
the captured output as a string.

This repository contains two packages:

- [`take`](https://hexdocs.pm/take): Synchronous IO capture for Erlang and
  JavaScript targets
- [`take_promise`](https://hexdocs.pm/take_promise): Async IO capture for
  JavaScript (works with `Promise`-returning callbacks)

## Semantic Versioning

All packages follow [Semantic Versioning 2.0][semver].

## Licence

[Apache 2.0][licence]

[licence]: https://github.com/halostatue/take/blob/main/LICENCE.md
[semver]: https://semver.org/
