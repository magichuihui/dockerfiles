# syntax=docker/dockerfile:1
ARG GRAFANA_VERSION=13.0.1
ARG TARGETARCH=amd64
ARG GO_VERSION=1.26.2

FROM alpine:3.20 AS release

ARG GRAFANA_VERSION
ARG TARGETARCH

RUN apk add --no-cache curl ca-certificates tar && \
    mkdir -p /tmp/grafana-release && \
    curl -fsSL \
    "https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-${TARGETARCH}.tar.gz" \
    | tar xz -C /tmp/grafana-release --strip-components=1

FROM golang:${GO_VERSION}-alpine AS go-builder

ARG GRAFANA_VERSION

RUN apk add --no-cache curl git build-base
RUN mkdir -p /tmp/grafana-src && \
    curl -fsSL \
    "https://github.com/grafana/grafana/archive/refs/tags/v${GRAFANA_VERSION}.tar.gz" \
    | tar xz -C /tmp/grafana-src --strip-components=1

WORKDIR /tmp/grafana-src

# Download modules and patch vulnerable dependencies
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download && \
    go get github.com/jackc/pgx/v5@v5.9.0 && \
    go get github.com/apache/thrift@v0.23.0 && \
    go get go.opentelemetry.io/otel/sdk@v1.43.0

# Build Go binaries with -p=1 to minimize memory usage
# Grafana 13 uses a unified binary at pkg/cmd/grafana
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    mkdir -p /tmp/out && \
    go build -p=1 -o /tmp/out/grafana ./pkg/cmd/grafana

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG GRAFANA_VERSION
ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="Grafana (self-built)"
LABEL org.opencontainers.image.description="Built from source with patched deps on Chainguard"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"

COPY --chown=65532:65532 --from=release /tmp/grafana-release/ /usr/share/grafana/
# Override with our compiled binary (rename grafana→grafana-server for entrypoint compat)
COPY --chown=65532:65532 --from=go-builder /tmp/out/grafana /usr/share/grafana/bin/grafana-server

RUN mkdir -p /var/lib/grafana /var/log/grafana /var/lib/grafana/plugins \
    && chown -R 65532:65532 /var/lib/grafana /var/log/grafana

USER 65532
WORKDIR /usr/share/grafana
EXPOSE 3000

ENTRYPOINT ["/usr/share/grafana/bin/grafana-server"]
CMD ["--homepath=/usr/share/grafana", "--config=/etc/grafana/grafana.ini"]
