#!/bin/bash
set -e

# Redis Adeliom Entrypoint Script
# This script configures Redis based on environment variables

# ========== HELPER FUNCTIONS ==========

# Logging function
log() {
    local type="$1"
    shift
    local message="$*"
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$type] $message"
}

info() {
    log "INFO" "$@"
}

warn() {
    log "WARN" "$@"
}

error() {
    log "ERROR" "$@"
    exit 1
}

debug() {
    if [[ "$MODE_DEBUG" =~ ^(yes|true|1)$ ]]; then
        log "DEBUG" "$@"
    fi
}

# Check if a value is true
is_boolean_yes() {
    local value="${1:-}"
    [[ "$value" =~ ^(yes|true|1)$ ]]
}

# Ensure directories exist
ensure_directories() {
    info "Creating required directories..."
    mkdir -p /adeliom/redis/data
    mkdir -p /adeliom/redis/logs
    mkdir -p /adeliom/redis/conf
    mkdir -p /adeliom/redis/tmp
    chown -R redis:redis /adeliom/redis
}

# ========== CONFIGURATION ==========

# Validate password
validate_password() {
    if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        if [[ -z "$REDIS_PASSWORD" ]] && [[ -z "$REDIS_PASSWORD_FILE" ]]; then
            error "The REDIS_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is only recommended for development."
        fi
    fi

    if [[ -n "$REDIS_PASSWORD_FILE" ]]; then
        if [[ -f "$REDIS_PASSWORD_FILE" ]]; then
            REDIS_PASSWORD=$(cat "$REDIS_PASSWORD_FILE")
            debug "Password loaded from file"
        else
            error "The password file $REDIS_PASSWORD_FILE does not exist"
        fi
    fi
}

# Generate Redis configuration
generate_config() {
    info "Generating Redis configuration..."

    # Copy default configuration
    cp /opt/adeliom/redis/redis.conf.default /adeliom/redis/conf/redis.conf

    # Configure port
    local port="${REDIS_PORT_NUMBER:-6379}"
    info "  - Port: $port"
    sed -i "s/^port .*/port $port/" /adeliom/redis/conf/redis.conf

    # Configure databases
    if [[ -n "$REDIS_DATABASE" ]]; then
        info "  - Databases: $REDIS_DATABASE"
        sed -i "s/^databases .*/databases $REDIS_DATABASE/" /adeliom/redis/conf/redis.conf
    fi

    # Configure password
    if [[ -n "$REDIS_PASSWORD" ]]; then
        info "  - Authentication: Enabled ✓"
        sed -i "s/^# requirepass .*/requirepass $REDIS_PASSWORD/" /adeliom/redis/conf/redis.conf
    elif is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "  - Authentication: Disabled (ALLOW_EMPTY_PASSWORD=yes) ⚠️"
        warn "  - This is only recommended for development"
    fi

    # Configure AOF persistence
    if is_boolean_yes "$REDIS_AOF_ENABLED"; then
        info "  - AOF Persistence: Enabled"
        sed -i "s/^appendonly .*/appendonly yes/" /adeliom/redis/conf/redis.conf
    else
        info "  - AOF Persistence: Disabled"
        sed -i "s/^appendonly .*/appendonly no/" /adeliom/redis/conf/redis.conf
    fi

    # Configure RDB persistence
    if is_boolean_yes "$REDIS_RDB_POLICY_DISABLED"; then
        info "  - RDB Persistence: Disabled"
        sed -i '/^save /d' /adeliom/redis/conf/redis.conf
    elif [[ -n "$REDIS_RDB_POLICY" ]]; then
        info "  - RDB Persistence: Custom policy"
        sed -i '/^save /d' /adeliom/redis/conf/redis.conf
        echo "save $REDIS_RDB_POLICY" >> /adeliom/redis/conf/redis.conf
    fi

    # Configure I/O threads
    if [[ -n "$REDIS_IO_THREADS" ]]; then
        info "  - I/O Threads: $REDIS_IO_THREADS"
        echo "io-threads $REDIS_IO_THREADS" >> /adeliom/redis/conf/redis.conf

        if is_boolean_yes "$REDIS_IO_THREADS_DO_READS"; then
            echo "io-threads-do-reads yes" >> /adeliom/redis/conf/redis.conf
        fi
    fi

    # Disable commands
    if [[ -n "$REDIS_DISABLE_COMMANDS" ]]; then
        info "  - Disabling commands: $REDIS_DISABLE_COMMANDS"
        IFS=',' read -ra COMMANDS <<< "$REDIS_DISABLE_COMMANDS"
        for cmd in "${COMMANDS[@]}"; do
            # Trim whitespace
            cmd=$(echo "$cmd" | xargs)
            echo "rename-command $cmd \"\"" >> /adeliom/redis/conf/redis.conf
        done
    fi

    # Set proper permissions
    chown redis:redis /adeliom/redis/conf/redis.conf
    chmod 640 /adeliom/redis/conf/redis.conf
}

# ========== MAIN ==========

info "🚀 Starting Redis Adeliom..."

# Show debug info
if is_boolean_yes "$MODE_DEBUG"; then
    info "Debug mode enabled"
    set -x
fi

# Validate configuration
validate_password

# Ensure directories exist
ensure_directories

# Generate configuration
generate_config

info "✅ Configuration complete, starting Redis..."

# Execute as redis user
exec gosu redis "$@"
