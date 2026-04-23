packages := "take take_promise"

_default:
    just --list

test:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Testing ${pkg} ==="
      just packages/"${pkg}"/test
    done

build:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Building ${pkg} ==="
      just packages/"${pkg}"/build
    done

lint:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Linting ${pkg} ==="
      just packages/"${pkg}"/lint
    done

docs:
    #!/usr/bin/env bash
    for pkg in {{ packages }}; do
      just packages/"${pkg}"/docs
    done

docs-open:
    #!/usr/bin/env bash
    for pkg in {{ packages }}; do
      just packages/"${pkg}"/docs-open
    done

format-check:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Format check ${pkg} ==="
      (cd packages/"${pkg}" && gleam format --check src test)
    done

format:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Format ${pkg} ==="
      (cd packages/"${pkg}" && gleam format)
    done

deps *args="download":
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Downloading deps for ${pkg} ==="
      (cd packages/"${pkg}" && gleam deps {{ args }})
    done
