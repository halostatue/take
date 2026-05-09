# `take` Changelog

## v1.0.1 / 2026-05-09

Fixed an error on the Erlang FFI where Unicode output was instead returned as
Latin 1 bytes. It is assumed that all output through `stdout` and `stderr` is
Unicode now.

## v1.0.0 / 2026-04-21

Initial release of `take`, an IO capture library for Gleam tests.
