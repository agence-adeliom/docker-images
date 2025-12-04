# Redis Adeliom Configuration

This directory contains configuration files for the Adeliom Redis Docker images.

## 📁 Available Files

### Redis Configuration Files

- **`redis.conf`** - Balanced default configuration
- **`redis-dev.conf`** - Development-optimized configuration
- **`redis-prod.conf`** - Production-secured configuration

### Scripts

- **`docker-entrypoint.sh`** - Custom entrypoint script
- **`healthcheck.sh`** - Health check script
- **`docker-compose.example.yml`** - Docker Compose usage examples

## 🎯 Usage

### Default Configuration

The image automatically uses the default configuration (`redis.conf`). No action required.

### Custom Configuration via Environment Variables

```bash
docker run -d \
  -e REDIS_PASSWORD=my-password \
  -e REDIS_PORT_NUMBER=6379 \
  -e REDIS_DATABASE=16 \
  -e REDIS_AOF_ENABLED=yes \
  adeliom/redis:7.4
```

### Custom Configuration via File

#### Development

```yaml
services:
  redis:
    image: adeliom/redis:7.4
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - ./config/redis-dev.conf:/opt/adeliom/redis/redis.conf.default:ro
```

#### Production

```yaml
services:
  redis:
    image: adeliom/redis:7.4
    environment:
      - REDIS_PASSWORD=${REDIS_PASSWORD}
      - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG
    volumes:
      - ./config/redis-prod.conf:/opt/adeliom/redis/redis.conf.default:ro
```

## 🔧 Configuration Differences

### `redis.conf` (Default)

- Balance between performance and security
- AOF enabled with sync every second
- RDB with regular saves
- Logging in `notice` mode
- Ideal for most use cases

**Features:**
- `port 6379`
- `databases 16`
- `maxmemory 256mb`
- `appendonly yes`
- `appendfsync everysec`
- `save 900 1 300 10 60 10000`

### `redis-dev.conf` (Development)

- Detailed logging (`debug` mode)
- AOF disabled for better performance
- `protected-mode` disabled
- Event notifications enabled
- Very sensitive slow log (> 1ms)
- **⚠️ Do not use in production**

**Features:**
- `loglevel debug`
- `appendonly no`
- `protected-mode no`
- `slowlog-log-slower-than 1000`
- `notify-keyspace-events "KEA"`
- `always-show-logo yes`

### `redis-prod.conf` (Production)

- Maximum security
- Dangerous commands disabled by default
- `protected-mode` enabled
- Password required (via `REDIS_PASSWORD`)
- AOF enabled for better durability
- Higher memory limit

**Features:**
- `loglevel notice`
- `protected-mode yes`
- `maxmemory 1gb`
- `appendonly yes`
- Disabled commands: `FLUSHDB`, `FLUSHALL`, `KEYS`, `CONFIG`, `DEBUG`
- `slowlog-log-slower-than 10000`

## 🔐 Security Best Practices

### 1. Always Use a Password in Production

```yaml
environment:
  - REDIS_PASSWORD=your-secure-password
  # Or use password file
  - REDIS_PASSWORD_FILE=/run/secrets/redis_password
```

### 2. Disable Dangerous Commands

```yaml
environment:
  - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG,KEYS,DEBUG
```

### 3. Use Custom Configuration for Production

```yaml
volumes:
  - ./config/redis-prod.conf:/opt/adeliom/redis/redis.conf.default:ro
```

### 4. Limit Network Access

Use Docker networks to restrict access:

```yaml
networks:
  backend:
    driver: bridge
    internal: true
```

## 📊 Monitoring Configuration

### Enable Slow Log

Monitor slow queries in production:

```conf
# Log queries taking more than 10ms
slowlog-log-slower-than 10000
slowlog-max-len 128
```

### Enable Latency Monitoring

```conf
# Monitor latencies > 100ms
latency-monitor-threshold 100
```

### Enable Event Notifications (Optional)

```conf
# Enable keyspace notifications
notify-keyspace-events "KEA"
```

**Note**: Event notifications can impact performance. Use wisely in production.

## 🚀 Performance Tuning

### Memory Configuration

```conf
maxmemory 1gb
maxmemory-policy allkeys-lru
```

**Available policies:**
- `noeviction` - Return errors when memory limit is reached
- `allkeys-lru` - Remove least recently used keys
- `volatile-lru` - Remove LRU keys with expire set
- `allkeys-random` - Remove random keys
- `volatile-random` - Remove random keys with expire set
- `volatile-ttl` - Remove keys with shortest TTL

### I/O Threads (Redis 6.0+)

```yaml
environment:
  - REDIS_IO_THREADS=4
  - REDIS_IO_THREADS_DO_READS=yes
```

### Persistence Trade-offs

**Maximum Durability** (Slower):
```yaml
environment:
  - REDIS_AOF_ENABLED=yes
  - REDIS_RDB_POLICY=900 1 300 10 60 10000
```

**Maximum Performance** (Data loss risk):
```yaml
environment:
  - REDIS_AOF_ENABLED=no
  - REDIS_RDB_POLICY_DISABLED=yes
```

**Balanced** (Recommended):
```yaml
environment:
  - REDIS_AOF_ENABLED=yes
  - REDIS_RDB_POLICY=3600 1 300 100 60 10000
```

## 📝 Configuration File Format

Redis configuration files use a simple format:

```conf
# Comment
key value
key "value with spaces"
```

### Common Directives

| Directive | Description | Example |
|-----------|-------------|---------|
| `port` | Listening port | `port 6379` |
| `bind` | Bind address | `bind 0.0.0.0` |
| `requirepass` | Password | `requirepass mypassword` |
| `databases` | Number of databases | `databases 16` |
| `maxmemory` | Memory limit | `maxmemory 1gb` |
| `appendonly` | Enable AOF | `appendonly yes` |
| `save` | RDB save points | `save 900 1` |

## 🔄 Configuration Reload

Some configuration changes can be applied without restart:

```bash
# Using redis-cli
docker exec my-redis redis-cli CONFIG SET maxmemory 2gb

# Make persistent
docker exec my-redis redis-cli CONFIG REWRITE
```

**Note**: Not all directives support runtime changes. Restart may be required.

## 🐛 Debugging

### Enable Debug Mode

```yaml
environment:
  - MODE_DEBUG=true
```

This will:
- Show detailed startup logs
- Display all configuration steps
- Enable bash tracing in entrypoint script

### Check Generated Configuration

```bash
# View the generated config
docker exec my-redis cat /adeliom/redis/conf/redis.conf

# Check if password is set
docker exec my-redis grep "requirepass" /adeliom/redis/conf/redis.conf
```

### Test Configuration

```bash
# Test configuration syntax
docker exec my-redis redis-server --test-memory 1

# Check Redis info
docker exec my-redis redis-cli INFO
```

## 📚 Additional Resources

- [Official Redis Configuration](https://redis.io/docs/management/config/)
- [Redis Best Practices](https://redis.io/docs/management/optimization/)
- [Redis Security](https://redis.io/docs/management/security/)
- [Redis Persistence](https://redis.io/docs/management/persistence/)

## ⚠️ Important Notes

1. **Configuration Precedence**: Environment variables override configuration file settings
2. **File Permissions**: Configuration files are mounted read-only (`:ro`) for security
3. **Restart Required**: Most configuration changes require container restart
4. **Password Security**: Never commit passwords to version control
5. **Development vs Production**: Always use different configurations for dev and prod

---

For more information, see the [main README](../README.md).
