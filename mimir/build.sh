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
cd "$SRC_DIR"
GOWORK=off go mod download
GOWORK=off CGO_ENABLED=1 go build -o "$SCRIPT_DIR/mimir" ./cmd/mimir/

echo "=== Cleanup ==="
rm -rf "$SRC_DIR"
