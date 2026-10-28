# syntax=docker/dockerfile:1
ARG REDIS_VERSION
FROM redis:${REDIS_VERSION}-alpine

LABEL org.opencontainers.image.source=https://github.com/agence-adeliom/docker-images/tree/main/redis
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="Adeliom https://adeliom.com"
LABEL org.opencontainers.image.title="Redis ${REDIS_VERSION}"
LABEL org.opencontainers.image.description="Redis ${REDIS_VERSION} Docker image preconfigured for Adeliom"

# Pull the latest Alpine security patches for packages already present in the
# base image (e.g. openssl, musl, zlib, busybox on the older redis:7.0-alpine,
# which is built on Alpine 3.20), then install the required tools.
RUN apk upgrade --no-cache \
    && apk add --no-cache \
    bash \
    curl \
    su-exec

# The official image ships a `gosu` binary built with an old Go toolchain (go1.18.2
# on redis:7.0-alpine, 150+ stdlib CVEs). Our entrypoint uses `su-exec` instead,
# so `gosu` is never called: remove it from the final filesystem. It stays in the
# base image layer, so scanners that read layers may still report it; the only
# full fix is a newer upstream base image (redis 7.0 is EOL).
RUN rm -f /usr/local/bin/gosu

# Create Adeliom directory structure
RUN mkdir -p /adeliom/redis/data \
    && mkdir -p /adeliom/redis/logs \
    && mkdir -p /adeliom/redis/conf \
    && mkdir -p /adeliom/redis/tmp \
    && chown -R redis:redis /adeliom/redis

# Copy configuration files
COPY config/redis.conf /opt/adeliom/redis/redis.conf.default
COPY config/docker-entrypoint.sh /opt/adeliom/scripts/redis/entrypoint.sh
COPY config/healthcheck.sh /opt/adeliom/scripts/redis/healthcheck.sh

# Set execution permissions
RUN chmod +x /opt/adeliom/scripts/redis/entrypoint.sh \
    && chmod +x /opt/adeliom/scripts/redis/healthcheck.sh

# Default configuration
ENV MODE_DEBUG="false" \
    ALLOW_EMPTY_PASSWORD="yes" \
    REDIS_PASSWORD="" \
    REDIS_PASSWORD_FILE="" \
    REDIS_DISABLE_COMMANDS="" \
    REDIS_DATABASE="" \
    REDIS_AOF_ENABLED="yes" \
    REDIS_RDB_POLICY="" \
    REDIS_RDB_POLICY_DISABLED="no" \
    REDIS_PORT_NUMBER="6379" \
    REDIS_IO_THREADS_DO_READS="no" \
    REDIS_IO_THREADS=""

# Volumes for persistence
VOLUME ["/adeliom/redis/data", "/adeliom/redis/logs"]

# Expose port
EXPOSE 6379

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD /opt/adeliom/scripts/redis/healthcheck.sh

# Custom entrypoint
ENTRYPOINT ["/opt/adeliom/scripts/redis/entrypoint.sh"]

# Default command
CMD ["redis-server", "/adeliom/redis/conf/redis.conf"]
