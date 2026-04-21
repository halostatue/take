# take

[![Hex.pm][shield-hex]][hexpm] [![Hex Docs][shield-docs]][docs]
[![Apache 2.0][shield-licence]][licence] ![JavaScript Compatible][shield-js]
![Erlang Compatible][shield-erlang]

IO capture for Gleam tests. Intercepts `stdout`, `stderr`, or both and returns
the captured output as a string. Works on both Erlang and JavaScript targets.

> If your callback returns a `Promise`, use
> [`take_promise`](https://hexdocs.pm/take_promise) instead.

## Usage

```sh
gleam add --dev take@1
```

```gleam
import take

pub fn prints_greeting_test() {
  let #(result, output) = take.with_stdout(fn() {
    io.println("Hello, world!")
    42
  })

  assert 42 == result
  assert "Hello, world!\n" == output
}

pub fn just_the_output_test() {
  assert "Hello, world!\n" == take.capture_stdout(fn() {
    io.println("Hello, world!")
  })
}
```

## Semantic Versioning

Take follows [Semantic Versioning 2.0][semver].

[docs]: https://hexdocs.pm/take
[hexpm]: https://hex.pm/package/take
[licence]: https://github.com/halostatue/take/blob/main/LICENCE.md
[semver]: https://semver.org/
[shield-docs]: https://img.shields.io/badge/hex-docs-lightgreen.svg?style=for-the-badge "Hex Docs"
[shield-erlang]: https://img.shields.io/badge/target-erlang-f3e155?style=for-the-badge "Erlang Compatible"
[shield-hex]: https://img.shields.io/hexpm/v/take?style=for-the-badge "Hex Version"
[shield-js]: https://img.shields.io/badge/target-javascript-f3e155?style=for-the-badge "Javascript Compatible"
[shield-licence]: https://img.shields.io/hexpm/l/take?style=for-the-badge&label=licence "Apache 2.0"
