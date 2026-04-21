import gleam/io
import gleeunit
import take

pub fn main() {
  gleeunit.main()
}

pub fn with_stdout_captures_println_test() {
  let #(result, output) =
    take.with_stdout(fn() {
      io.println("hello")
      42
    })
  assert 42 == result
  assert "hello\n" == output
}

pub fn with_stdout_captures_print_test() {
  let #(_, output) = take.with_stdout(fn() { io.print("no newline") })
  assert "no newline" == output
}

pub fn with_stdout_returns_empty_when_silent_test() {
  let #(result, output) = take.with_stdout(fn() { "quiet" })
  assert "quiet" == result
  assert "" == output
}

pub fn with_stdout_does_not_capture_stderr_test() {
  let #(_, output) = take.with_stdout(fn() { io.println_error("to stderr") })
  assert "" == output
}

// --- with_stderr ---

pub fn with_stderr_captures_println_error_test() {
  let #(result, output) =
    take.with_stderr(fn() {
      io.println_error("oops")
      99
    })
  assert 99 == result
  assert "oops\n" == output
}

pub fn with_stderr_does_not_capture_stdout_test() {
  let #(_, output) = take.with_stderr(fn() { io.println("to stdout") })
  assert "" == output
}

// --- with_stdio ---

pub fn with_stdio_captures_both_test() {
  let #(result, stdout, stderr) =
    take.with_stdio(fn() {
      io.println("out")
      io.println_error("err")
      "done"
    })
  assert "done" == result
  assert "out\n" == stdout
  assert "err\n" == stderr
}

pub fn with_stdio_empty_when_silent_test() {
  let #(_, stdout, stderr) = take.with_stdio(fn() { Nil })
  assert "" == stdout
  assert "" == stderr
}

// --- capture_stdout ---

pub fn capture_stdout_returns_string_test() {
  assert "hello\n" == take.capture_stdout(fn() { io.println("hello") })
}

pub fn capture_stdout_discards_return_value_test() {
  assert "" == take.capture_stdout(fn() { 42 })
}

// --- capture_stderr ---

pub fn capture_stderr_returns_string_test() {
  assert "oops\n" == take.capture_stderr(fn() { io.println_error("oops") })
}

// --- capture_stdio ---

pub fn capture_stdio_returns_both_test() {
  let #(stdout, stderr) =
    take.capture_stdio(fn() {
      io.println("out")
      io.println_error("err")
    })
  assert "out\n" == stdout
  assert "err\n" == stderr
}

// --- nesting ---

pub fn nested_stdout_in_stderr_test() {
  let #(#(inner_result, inner_stdout), outer_stderr) =
    take.with_stderr(fn() {
      take.with_stdout(fn() {
        io.println("to stdout")
        io.println_error("to stderr")
        "inner"
      })
    })
  assert "inner" == inner_result
  assert "to stdout\n" == inner_stdout
  assert "to stderr\n" == outer_stderr
}

pub fn nested_stderr_in_stdout_test() {
  let #(#(inner_result, inner_stderr), outer_stdout) =
    take.with_stdout(fn() {
      take.with_stderr(fn() {
        io.println("to stdout")
        io.println_error("to stderr")
        "inner"
      })
    })
  assert "inner" == inner_result
  assert "to stderr\n" == inner_stderr
  assert "to stdout\n" == outer_stdout
}
