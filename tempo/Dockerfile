ARG VERSION=2.10.5
ARG TARGETARCH=amd64

FROM alpine:3.20 AS release

ARG VERSION
ARG TARGETARCH

RUN apk add --no-cache curl tar && \
    curl -fsSL \
    "https://github.com/grafana/tempo/releases/download/v${VERSION}/tempo_${VERSION}_linux_${TARGETARCH}.tar.gz" \
    | tar xz -C /tmp --strip-components=1 && \
    install -m 755 /tmp/tempo /usr/local/bin/tempo

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="tempo"
LABEL org.opencontainers.image.description="Grafana Tempo trace storage"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"

COPY --from=release /usr/local/bin/tempo /usr/bin/tempo

USER 65532
ENTRYPOINT ["/usr/bin/tempo"]
