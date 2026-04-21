packages := "take take_promise"

_default:
    just --list

test:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Testing ${pkg} ==="
      just "${pkg}"/test
    done

build:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Building ${pkg} ==="
      just "${pkg}"/build
    done

lint:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Linting ${pkg} ==="
      just "${pkg}"/lint
    done

docs:
    #!/usr/bin/env bash
    for pkg in {{ packages }}; do
      just "${pkg}"/docs
    done

docs-open:
    #!/usr/bin/env bash
    for pkg in {{ packages }}; do
      just "${pkg}"/docs-open
    done

format-check:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Format check ${pkg} ==="
      (cd "${pkg}" && gleam format --check src test)
    done

format:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Format ${pkg} ==="
      (cd "${pkg}" && gleam format)
    done

deps *args="download":
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in {{ packages }}; do
      echo "=== Downloading deps for ${pkg} ==="
      (cd "${pkg}" && gleam deps {{ args }})
    done
