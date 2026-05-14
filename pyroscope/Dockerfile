ARG VERSION=2.0.2
ARG TARGETARCH=amd64

FROM alpine:3.20 AS release

ARG VERSION
ARG TARGETARCH

RUN apk add --no-cache curl tar && \
    curl -fsSL \
    "https://github.com/grafana/pyroscope/releases/download/v${VERSION}/pyroscope_${VERSION}_linux_${TARGETARCH}.tar.gz" \
    | tar xz -C /tmp --strip-components=1 && \
    install -m 755 /tmp/pyroscope /usr/local/bin/pyroscope

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="pyroscope"
LABEL org.opencontainers.image.description="Grafana Pyroscope continuous profiling"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"

COPY --from=release /usr/local/bin/pyroscope /usr/bin/pyroscope

USER 65532
ENTRYPOINT ["/usr/bin/pyroscope"]
