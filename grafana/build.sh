#!/bin/bash
set -eux

# Build Grafana binary from source with patched deps
# Outputs: grafana-server in the image directory (from build-arg VERSION)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

source version.txt

echo "=== Downloading Grafana source v${VERSION} ==="
SRC_DIR=$(mktemp -d)
curl -fsSL \
  "https://github.com/grafana/grafana/archive/refs/tags/v${VERSION}.tar.gz" \
  | tar xz --strip-components=1 -C "$SRC_DIR"

echo "=== Building Grafana binary ==="
GIT_REVISION=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "master")
cd "$SRC_DIR"
GOWORK=off go mod download
GOWORK=off go get github.com/jackc/pgx/v5@v5.9.0
GOWORK=off go get github.com/apache/thrift@v0.23.0
GOWORK=off go get go.opentelemetry.io/otel/sdk@v1.43.0
# prometheus pinned by loki v3.5.11 internal APIs — skip direct upgrade
GO_LDFLAGS="-X main.version=${VERSION} \
  -X main.commit=${GIT_REVISION} \
  -X main.buildBranch=${GIT_BRANCH} \
  -X main.buildstamp=$(date -u +%s)"
GOWORK=off CGO_ENABLED=1 go build -p=1 -tags oss \
  -ldflags "${GO_LDFLAGS}" \
  -o "$SCRIPT_DIR/grafana-server" ./pkg/cmd/grafana

echo "=== Cleanup ==="
rm -rf "$SRC_DIR"
