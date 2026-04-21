//// Async IO capture for Gleam tests on JavaScript.
////
//// Like `take`, but accepts callbacks that return `Promise(a)` and
//// awaits them before returning captured output.
////
//// ```gleam
//// import take_promise
//// import gleam/javascript/promise
////
//// pub fn async_greeting_test() {
////   use #(result, output) <- take_promise.with_stdout(fn() {
////     io.println("Hello!")
////     promise.resolve(42)
////   })
////
////   assert 42 == result
////   assert "Hello!\n" == output
//// }
//// ```

import gleam/javascript/promise.{type Promise}

/// Runs `f`, awaits the returned promise, and captures stdout.
/// Returns a promise of the result and captured output.
pub fn with_stdout(f: fn() -> Promise(a)) -> Promise(#(a, String)) {
  do_with_stdout(f)
}

/// Runs `f`, awaits the returned promise, and captures stderr.
/// Returns a promise of the result and captured output.
pub fn with_stderr(f: fn() -> Promise(a)) -> Promise(#(a, String)) {
  do_with_stderr(f)
}

/// Runs `f`, awaits the returned promise, and captures both stdout and stderr.
pub fn with_stdio(f: fn() -> Promise(a)) -> Promise(#(a, String, String)) {
  do_with_stdout(fn() { do_with_stderr(f) })
  |> promise.map(fn(outer) {
    let #(#(result, stderr), stdout) = outer
    #(result, stdout, stderr)
  })
}

/// Runs `f`, awaits the returned promise, and returns captured stdout.
pub fn capture_stdout(f: fn() -> Promise(a)) -> Promise(String) {
  do_with_stdout(f)
  |> promise.map(fn(pair) { pair.1 })
}

/// Runs `f`, awaits the returned promise, and returns captured stderr.
pub fn capture_stderr(f: fn() -> Promise(a)) -> Promise(String) {
  do_with_stderr(f)
  |> promise.map(fn(pair) { pair.1 })
}

/// Runs `f`, awaits the returned promise, and returns both captured streams.
pub fn capture_stdio(f: fn() -> Promise(a)) -> Promise(#(String, String)) {
  with_stdio(f)
  |> promise.map(fn(triple) { #(triple.1, triple.2) })
}

@external(javascript, "./take_promise_ffi.mjs", "with_stdout")
fn do_with_stdout(f: fn() -> Promise(a)) -> Promise(#(a, String))

@external(javascript, "./take_promise_ffi.mjs", "with_stderr")
fn do_with_stderr(f: fn() -> Promise(a)) -> Promise(#(a, String))
