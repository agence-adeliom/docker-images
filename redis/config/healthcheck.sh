#!/bin/bash

# Redis Adeliom Healthcheck Script
# Verifies that Redis is operational

# Configuration
HOST="${REDIS_HOST:-127.0.0.1}"
PORT="${REDIS_PORT_NUMBER:-6379}"
PASSWORD="${REDIS_PASSWORD}"

# Connection test
if [[ -n "$PASSWORD" ]]; then
    # With password
    PING_RESULT=$(redis-cli -h "$HOST" -p "$PORT" -a "$PASSWORD" --no-auth-warning ping 2>/dev/null)
else
    # Without password
    PING_RESULT=$(redis-cli -h "$HOST" -p "$PORT" ping 2>/dev/null)
fi

# Check result
if [[ "$PING_RESULT" == "PONG" ]]; then
    echo "✓ Redis is healthy"
    exit 0
else
    echo "✗ Redis is not responding"
    exit 1
fi
