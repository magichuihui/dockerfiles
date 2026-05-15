ARG VERSION=2.10.5

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG VERSION
ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="tempo"
LABEL org.opencontainers.image.description="Grafana Tempo trace storage (CI-compiled)"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"
LABEL org.opencontainers.image.version="${VERSION}"

COPY --chown=65532:65532 tempo /usr/bin/tempo

USER 65532
ENTRYPOINT ["/usr/bin/tempo"]
