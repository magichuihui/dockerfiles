ARG VERSION=3.7.2
ARG TARGETARCH=amd64

FROM alpine:3.20 AS release

ARG VERSION
ARG TARGETARCH

RUN apk add --no-cache curl unzip && \
    curl -fsSL \
    "https://github.com/grafana/loki/releases/download/v${VERSION}/loki-linux-${TARGETARCH}.zip" \
    -o /tmp/loki.zip && \
    unzip -j /tmp/loki.zip -d /tmp && \
    rm /tmp/loki.zip && \
    install -m 755 /tmp/loki /usr/local/bin/loki

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="loki"
LABEL org.opencontainers.image.description="Grafana Loki log aggregation system"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"

COPY --from=release /usr/local/bin/loki /usr/bin/loki

USER 65532
ENTRYPOINT ["/usr/bin/loki"]
