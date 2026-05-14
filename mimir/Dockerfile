ARG VERSION=3.0.6
ARG TARGETARCH=amd64

FROM alpine:3.20 AS release

ARG VERSION
ARG TARGETARCH

RUN apk add --no-cache curl && \
    curl -fsSL \
    "https://github.com/grafana/mimir/releases/download/mimir-${VERSION}/mimir-linux-${TARGETARCH}" \
    -o /tmp/mimir && \
    chmod +x /tmp/mimir

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="mimir"
LABEL org.opencontainers.image.description="Grafana Mimir metrics storage"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"

COPY --from=release /tmp/mimir /usr/bin/mimir

USER 65532
ENTRYPOINT ["/usr/bin/mimir"]
