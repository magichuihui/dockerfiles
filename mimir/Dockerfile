ARG VERSION=3.0.6

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG VERSION
ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="mimir"
LABEL org.opencontainers.image.description="Grafana Mimir metrics storage (CI-compiled)"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"
LABEL org.opencontainers.image.version="${VERSION}"

COPY --chown=65532:65532 mimir /usr/bin/mimir

USER 65532
ENTRYPOINT ["/usr/bin/mimir"]
