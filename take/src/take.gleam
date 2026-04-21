//// take: IO capture for Gleam tests.
////
//// Intercepts `stdout`, `stderr`, or both streams during a function call and
//// returns the captured output as a string. Works with Erlang and
//// JavaScript targets.
////
//// The `with_` variants return both the function's result and the captured
//// output. The `capture_` variants discard the result and return only the
//// captured string.
////
//// ```gleam
//// import take
////
//// pub fn greeting_test() {
////   let #(result, output) = take.with_stdout(fn() {
////     io.println("Hello!")
////     42
////   })
////
////   assert 42 == result
////   assert "Hello!\n" == output
//// }
//// ```

/// Runs `f` and captures everything written to stdout.
/// Returns a tuple of the function's return value and the captured output.
pub fn with_stdout(f: fn() -> a) -> #(a, String) {
  do_with_stdout(f)
}

/// Runs `f` and captures everything written to stderr.
/// Returns a tuple of the function's return value and the captured output.
pub fn with_stderr(f: fn() -> a) -> #(a, String) {
  do_with_stderr(f)
}

/// Runs `f` and captures both stdout and stderr.
/// Returns a tuple of the function's return value, captured stdout, and
/// captured stderr.
pub fn with_stdio(f: fn() -> a) -> #(a, String, String) {
  let #(#(result, stderr), stdout) = do_with_stdout(fn() { do_with_stderr(f) })
  #(result, stdout, stderr)
}

/// Runs `f` and returns the captured stdout, discarding the return value.
pub fn capture_stdout(f: fn() -> a) -> String {
  let #(_, output) = do_with_stdout(f)
  output
}

/// Runs `f` and returns the captured stderr, discarding the return value.
pub fn capture_stderr(f: fn() -> a) -> String {
  let #(_, output) = do_with_stderr(f)
  output
}

/// Runs `f` and returns captured stdout and stderr, discarding the return
/// value.
pub fn capture_stdio(f: fn() -> a) -> #(String, String) {
  let #(_, stdout, stderr) = with_stdio(f)
  #(stdout, stderr)
}

@external(erlang, "take_ffi", "with_stdout")
@external(javascript, "./take_ffi.mjs", "with_stdout")
fn do_with_stdout(f: fn() -> a) -> #(a, String)

@external(erlang, "take_ffi", "with_stderr")
@external(javascript, "./take_ffi.mjs", "with_stderr")
fn do_with_stderr(f: fn() -> a) -> #(a, String)
