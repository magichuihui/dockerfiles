# syntax=docker/dockerfile:1
# =============================================================
# Secure Grafana — multi-stage build
#
# Why build your own?
#   - Control the base image → patched against CVEs
#   - Minimal runtime footprint → smaller attack surface
#   - Weekly rebuilds via CI → stay current on security fixes
# =============================================================

# ------- Builder stage: fetch official Grafana binaries -------
FROM debian:bookworm-slim AS builder

ARG GRAFANA_VERSION=11.3.0
ARG TARGETARCH=amd64

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL \
      "https://dl.grafana.com/oss/release/grafana_${GRAFANA_VERSION}_${TARGETARCH}.deb" \
      -o /tmp/grafana.deb \
    && mkdir -p /tmp/root \
    && dpkg-deb -x /tmp/grafana.deb /tmp/root

# ------- Runtime: minimal Debian slim -------
FROM debian:bookworm-slim

ARG SOURCE_REPO="https://github.com/magichuihui/dockerfiles"

LABEL org.opencontainers.image.title="Grafana (self-built)"
LABEL org.opencontainers.image.description="Minimal Grafana image rebuilt regularly to minimize CVEs"
LABEL org.opencontainers.image.source="${SOURCE_REPO}"
LABEL org.opencontainers.image.licenses="AGPL-3.0-only"

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system grafana \
    && useradd --system --no-create-home --gid grafana grafana

COPY --from=builder /tmp/root/ /

# Create data / log directories with correct ownership
RUN mkdir -p /var/lib/grafana /var/log/grafana /var/lib/grafana/plugins \
    && chown -R grafana:grafana \
      /var/lib/grafana \
      /var/log/grafana \
      /usr/share/grafana \
      /etc/grafana

# Drop privileges
USER grafana
WORKDIR /usr/share/grafana

# Grafana default port
EXPOSE 3000

ENTRYPOINT ["/usr/share/grafana/bin/grafana-server"]
CMD ["--homepath=/usr/share/grafana", "--config=/etc/grafana/grafana.ini"]
