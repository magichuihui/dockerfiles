ARG K6_VERSION=2.0.0
ARG TARGETARCH=amd64

FROM alpine:3.20 AS release

ARG K6_VERSION
ARG TARGETARCH

RUN apk add --no-cache curl tar && \
    curl -fsSL \
    "https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-linux-${TARGETARCH}.tar.gz" \
    | tar xz -C /tmp --strip-components=1

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="k6"
LABEL org.opencontainers.image.description="Grafana k6 load testing tool on Chainguard base"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"

COPY --from=release /tmp/k6 /usr/bin/k6

USER 65532
ENTRYPOINT ["/usr/bin/k6"]
