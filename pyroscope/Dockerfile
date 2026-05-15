ARG VERSION=2.0.2

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG VERSION
ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="pyroscope"
LABEL org.opencontainers.image.description="Grafana Pyroscope continuous profiling (CI-compiled)"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"
LABEL org.opencontainers.image.version="${VERSION}"

COPY --chown=65532:65532 pyroscope /usr/bin/pyroscope

USER 65532
ENTRYPOINT ["/usr/bin/pyroscope"]
