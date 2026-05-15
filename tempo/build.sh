#!/bin/bash
set -eux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
source version.txt

echo "=== Downloading Tempo source v${VERSION} ==="
SRC_DIR=$(mktemp -d)
curl -fsSL \
  "https://github.com/grafana/tempo/archive/refs/tags/v${VERSION}.tar.gz" \
  | tar xz --strip-components=1 -C "$SRC_DIR"

echo "=== Building Tempo binary ==="
GIT_REVISION=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "master")
cd "$SRC_DIR"
GO_LDFLAGS="-X main.Version=${VERSION} \
  -X main.Branch=${GIT_BRANCH} \
  -X main.Revision=${GIT_REVISION}"
GOWORK=off go mod download
GOWORK=off CGO_ENABLED=1 go build -ldflags "${GO_LDFLAGS}" -o "$SCRIPT_DIR/tempo" ./cmd/tempo/

echo "=== Cleanup ==="
rm -rf "$SRC_DIR"
