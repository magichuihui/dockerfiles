ARG VERSION=3.7.2

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG VERSION
ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="loki"
LABEL org.opencontainers.image.description="Grafana Loki log aggregation system (CI-compiled)"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"
LABEL org.opencontainers.image.version="${VERSION}"

COPY --chown=65532:65532 loki /usr/bin/loki

USER 65532
ENTRYPOINT ["/usr/bin/loki"]
