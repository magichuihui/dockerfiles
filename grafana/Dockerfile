# syntax=docker/dockerfile:1
ARG GRAFANA_VERSION=13.0.1
ARG TARGETARCH=amd64

FROM alpine:3.20 AS release

ARG GRAFANA_VERSION
ARG TARGETARCH

RUN apk add --no-cache curl ca-certificates tar && \
    mkdir -p /tmp/grafana-release && \
    curl -fsSL \
    "https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-${TARGETARCH}.tar.gz" \
    | tar xz -C /tmp/grafana-release --strip-components=1

RUN mkdir -p /var/lib/grafana /var/log/grafana /var/lib/grafana/plugins && \
    chown -R 65532:65532 /var/lib/grafana /var/log/grafana

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG GRAFANA_VERSION
ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="Grafana (CI-built)"
LABEL org.opencontainers.image.description="Binary compiled in CI with patched deps, packaged on Chainguard"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"

# Base files from the release tarball (public/, conf/, etc.)
COPY --chown=65532:65532 --from=release /tmp/grafana-release/ /usr/share/grafana/

# Override binary with CI-compiled version (patched deps, newer Go toolchain)
# Replaces both grafana-server and the release tarball's grafana binary
COPY --chown=65532:65532 grafana-server /usr/share/grafana/bin/grafana-server
COPY --chown=65532:65532 grafana-server /usr/share/grafana/bin/grafana

# Directories created in release stage (which has a shell) then COPY'd here
# because Chainguard glibc-dynamic has no shell for RUN commands
COPY --chown=65532:65532 --from=release /var/lib/grafana /var/lib/grafana
COPY --chown=65532:65532 --from=release /var/log/grafana /var/log/grafana

USER 65532
WORKDIR /usr/share/grafana
EXPOSE 3000

ENTRYPOINT ["/usr/share/grafana/bin/grafana-server"]
CMD ["--homepath=/usr/share/grafana", "--config=/etc/grafana/grafana.ini"]
