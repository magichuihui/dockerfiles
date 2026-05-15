#!/bin/bash
set -eux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
source version.txt

echo "=== Downloading Pyroscope source v${VERSION} ==="
SRC_DIR=$(mktemp -d)
curl -fsSL \
  "https://github.com/grafana/pyroscope/archive/refs/tags/v${VERSION}.tar.gz" \
  | tar xz --strip-components=1 -C "$SRC_DIR"

echo "=== Building Pyroscope binary ==="
cd "$SRC_DIR"
GOWORK=off go mod download
GOWORK=off CGO_ENABLED=1 go build -o "$SCRIPT_DIR/pyroscope" ./cmd/pyroscope/

echo "=== Cleanup ==="
rm -rf "$SRC_DIR"
