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
GIT_REVISION=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "master")
GO_LDFLAGS="-X github.com/grafana/loki/v3/pkg/util/build.Version=${VERSION} \
  -X github.com/grafana/loki/v3/pkg/util/build.Revision=${GIT_REVISION} \
  -X github.com/grafana/loki/v3/pkg/util/build.Branch=${GIT_BRANCH} \
  -X github.com/grafana/loki/v3/pkg/util/build.BuildUser=ci \
  -X github.com/grafana/loki/v3/pkg/util/build.BuildDate=$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
GOWORK=off go mod download
GOWORK=off CGO_ENABLED=1 go build -ldflags "${GO_LDFLAGS}" -o "$SCRIPT_DIR/loki" ./cmd/loki/

echo "=== Cleanup ==="
rm -rf "$SRC_DIR"
