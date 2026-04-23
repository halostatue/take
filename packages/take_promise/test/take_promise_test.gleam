import gleam/io
import gleam/javascript/promise
import gleeunit
import take_promise

pub fn main() {
  gleeunit.main()
}

pub fn with_stdout_captures_async_test() {
  use #(result, output) <- promise.await(
    take_promise.with_stdout(fn() {
      io.println("hello")
      promise.resolve(42)
    }),
  )
  assert 42 == result
  assert "hello\n" == output
  promise.resolve(Nil)
}

pub fn with_stderr_captures_async_test() {
  use #(result, output) <- promise.await(
    take_promise.with_stderr(fn() {
      io.println_error("oops")
      promise.resolve(99)
    }),
  )
  assert 99 == result
  assert "oops\n" == output
  promise.resolve(Nil)
}

pub fn with_stdio_captures_both_async_test() {
  use #(result, stdout, stderr) <- promise.await(
    take_promise.with_stdio(fn() {
      io.println("out")
      io.println_error("err")
      promise.resolve("done")
    }),
  )
  assert "done" == result
  assert "out\n" == stdout
  assert "err\n" == stderr
  promise.resolve(Nil)
}

pub fn capture_stdout_async_test() {
  use output <- promise.await(
    take_promise.capture_stdout(fn() {
      io.println("hello")
      promise.resolve(Nil)
    }),
  )
  assert "hello\n" == output
  promise.resolve(Nil)
}

pub fn capture_stderr_async_test() {
  use output <- promise.await(
    take_promise.capture_stderr(fn() {
      io.println_error("oops")
      promise.resolve(Nil)
    }),
  )
  assert "oops\n" == output
  promise.resolve(Nil)
}

pub fn capture_stdio_async_test() {
  use #(stdout, stderr) <- promise.await(
    take_promise.capture_stdio(fn() {
      io.println("out")
      io.println_error("err")
      promise.resolve(Nil)
    }),
  )
  assert "out\n" == stdout
  assert "err\n" == stderr
  promise.resolve(Nil)
}
