#!/bin/bash
set -eux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
source version.txt

echo "=== Downloading Loki source v${VERSION} ==="
SRC_DIR=$(mktemp -d)
curl -fsSL \
  "https://github.com/grafana/loki/archive/refs/tags/v${VERSION}.tar.gz" \
  | tar xz --strip-components=1 -C "$SRC_DIR"

echo "=== Building Loki binary ==="
cd "$SRC_DIR"
GOWORK=off go mod download
# Apply dep patches — these work because loki itself (not loki the dep of grafana) uses these packages
GOWORK=off go get github.com/apache/thrift@v0.23.0
GOWORK=off go get github.com/prometheus/prometheus@v0.311.3
GOWORK=off go mod tidy
GOWORK=off CGO_ENABLED=1 go build -o "$SCRIPT_DIR/loki" ./cmd/loki/

echo "=== Cleanup ==="
rm -rf "$SRC_DIR"
