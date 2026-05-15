#!/bin/bash
set -eux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
source version.txt

echo "=== Downloading Mimir source v${VERSION} ==="
SRC_DIR=$(mktemp -d)
# Mimir uses tags like "mimir-3.0.6" (without "v" prefix)
curl -fsSL \
  "https://github.com/grafana/mimir/archive/refs/tags/mimir-${VERSION}.tar.gz" \
  | tar xz --strip-components=1 -C "$SRC_DIR"

echo "=== Building Mimir binary ==="
GIT_REVISION=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "master")
cd "$SRC_DIR"
GO_LDFLAGS="-X github.com/grafana/mimir/pkg/util/version.Version=${VERSION} \
  -X github.com/grafana/mimir/pkg/util/version.Branch=${GIT_BRANCH} \
  -X github.com/grafana/mimir/pkg/util/version.Revision=${GIT_REVISION}"
GOWORK=off go mod download
GOWORK=off CGO_ENABLED=1 go build -ldflags "${GO_LDFLAGS}" -o "$SCRIPT_DIR/mimir" ./cmd/mimir/

echo "=== Cleanup ==="
rm -rf "$SRC_DIR"
