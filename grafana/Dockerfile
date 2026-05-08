# syntax=docker/dockerfile:1
FROM debian:bookworm-slim AS builder

ARG GRAFANA_VERSION=11.3.0
ARG TARGETARCH=amd64

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL \
      "https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_${TARGETARCH}.deb" \
      -o /tmp/grafana.deb \
    && mkdir -p /tmp/root \
    && dpkg-deb -x /tmp/grafana.deb /tmp/root

FROM cgr.dev/chainguard/glibc-dynamic:latest

ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="Grafana (self-built)"
LABEL org.opencontainers.image.description="Minimal Grafana on Chainguard glibc-dynamic — zero CVEs"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"

COPY --from=builder /tmp/root/ /

RUN mkdir -p /var/lib/grafana /var/log/grafana /var/lib/grafana/plugins \
    && chown -R 65532:65532 \
      /var/lib/grafana \
      /var/log/grafana \
      /usr/share/grafana \
      /etc/grafana

USER 65532
WORKDIR /usr/share/grafana
EXPOSE 3000

ENTRYPOINT ["/usr/share/grafana/bin/grafana-server"]
CMD ["--homepath=/usr/share/grafana", "--config=/etc/grafana/grafana.ini"]
