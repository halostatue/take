# take\_promise

[![Hex.pm][shield-hex]][hexpm] [![Hex Docs][shield-docs]][docs]
[![Apache 2.0][shield-licence]][licence] ![JavaScript Only][shield-js]

Async IO capture for Gleam tests on JavaScript. Like
[`take`](https://hexdocs.pm/take), but accepts callbacks that return
`Promise(a)` and awaits them before returning captured output.

## Usage

```sh
gleam add --dev take_promise@1
```

```gleam
import gleam/javascript/promise
import take_promise

pub fn async_greeting_test() {
  use #(result, output) <- promise.await(
    take_promise.with_stdout(fn() {
      io.println("Hello, world!")
      promise.resolve(42)
    }),
  )

  assert 42 == result
  assert "Hello, world!\n" == output
  promise.resolve(Nil)
}
```

## Semantic Versioning

Take Promise follows [Semantic Versioning 2.0][semver].

[docs]: https://hexdocs.pm/take_promise
[hexpm]: https://hex.pm/package/take_promise
[licence]: https://github.com/halostatue/take/blob/main/LICENCE.md
[semver]: https://semver.org/
[shield-docs]: https://img.shields.io/badge/hex-docs-lightgreen.svg?style=for-the-badge "Hex Docs"
[shield-hex]: https://img.shields.io/hexpm/v/take_promise?style=for-the-badge "Hex Version"
[shield-js]: https://img.shields.io/badge/target-javascript-f3e155?style=for-the-badge "Javascript Only"
[shield-licence]: https://img.shields.io/hexpm/l/take_promise?style=for-the-badge&label=licence "Apache 2.0"
