# Redis Adeliom - Quick Start Guide

## 🚀 Getting Started

### Prerequisites

```bash
# Required
docker --version  # >= 20.10
docker-compose --version  # >= 2.0 (optional)

# Navigate to redis directory
cd redis
```

### Quick Test (Recommended)

```bash
# Build, run, and test Redis 7.4 in one command
make 7.4
```

## 📦 Installation & Testing

### Step 1: Build the Image

```bash
# Build latest version (7.4)
make build

# Or build specific version
make build REDIS_VERSION=7.2
```

### Step 2: Run Redis

```bash
# With password (recommended)
make run

# Without password (development only)
make run-no-password

# With production config
make run-prod
```

### Step 3: Test Redis

```bash
# Run all tests
make test
```

### Step 4: Interact with Redis

```bash
# Open redis-cli
make cli

# Test connection
make ping

# View info
make info
```

### Step 5: Stop Redis

```bash
make stop
```

## 🔧 Common Commands

```bash
# Show all available commands
make help

# Build and test all versions
make build-all
make test-all-versions

# View logs
make logs

# Monitor commands in real-time
make monitor

# Check health
make health

# Clean everything
make clean-all
```

## 📋 Environment Variables

### Basic Configuration

```yaml
environment:
  # Authentication
  - REDIS_PASSWORD=your_password
  # or
  - ALLOW_EMPTY_PASSWORD=yes  # Dev only!
  
  # Basic settings
  - REDIS_PORT_NUMBER=6379
  - REDIS_DATABASE=16
```

### Advanced Configuration

```yaml
environment:
  # Persistence
  - REDIS_AOF_ENABLED=yes
  - REDIS_RDB_POLICY=900 1 300 10 60 10000
  
  # Performance
  - REDIS_IO_THREADS=4
  - REDIS_IO_THREADS_DO_READS=yes
  
  # Security
  - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG
  
  # Debug
  - MODE_DEBUG=true
```

## 🐳 Docker Compose Example

```yaml
version: '3.8'

services:
  redis:
    image: adeliom/redis:7.4
    environment:
      - REDIS_PASSWORD=my_secure_password
      - REDIS_AOF_ENABLED=yes
      - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/adeliom/redis/data

volumes:
  redis_data:
```

## 📚 Documentation

- **[Main README](README.md)** - Complete documentation
- **[Config README](config/README.md)** - Configuration guide
- **[Makefile Usage](../MAKEFILE_USAGE.md)** - Detailed Makefile guide
- **[Docker Compose Example](config/docker-compose.example.yml)** - Usage examples

## 🔍 Available Versions

| Version | Tag | Status |
|---------|-----|--------|
| 7.4 | `adeliom/redis:7.4`, `latest` | ✅ Recommended |
| 7.2 | `adeliom/redis:7.2` | ✅ Stable |
| 7.0 | `adeliom/redis:7.0` | ✅ Stable |
| 6.2 | `adeliom/redis:6.2` | ✅ Legacy |

## 🛠️ Development Workflow

```bash
# 1. Make changes to Dockerfile or config
vim Dockerfile

# 2. Rebuild image
make build-nc  # No cache

# 3. Test changes
make run
make test

# 4. Debug if needed
make logs
make shell

# 5. Clean up
make stop
```

## 🎯 Use Cases

### Development

```bash
make build
make run-no-password
make cli-no-password
```

### Testing

```bash
make build
make run
make test
make test-persistence
```

### Production Simulation

```bash
make build
make run-prod
make info-stats
make slowlog
```

## 🆘 Troubleshooting

### Redis Won't Start

```bash
# Check logs
make logs

# Try debug mode
make run-debug
```

### Connection Issues

```bash
# Test connection
make ping

# Check config
make config | grep requirepass
```

### Build Issues

```bash
# Clean and rebuild
make clean
make build-nc
```

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/agence-adeliom/docker-images/issues)
- **Email**: contact@adeliom.com
- **Documentation**: See [README.md](README.md)

## ✅ Checklist

Before using in production:

- [ ] Built image successfully
- [ ] Ran all tests (`make test`)
- [ ] Tested persistence (`make test-persistence`)
- [ ] Set strong password
- [ ] Disabled dangerous commands
- [ ] Configured volumes for data persistence
- [ ] Tested healthcheck
- [ ] Reviewed logs

## 🎉 Next Steps

1. Read the [full documentation](README.md)
2. Explore [configuration options](config/README.md)
3. Check out [Docker Compose examples](config/docker-compose.example.yml)
4. Review the [Makefile usage guide](../MAKEFILE_USAGE.md)

---

**Made with ❤️ by [@agence-adeliom](https://github.com/agence-adeliom)**
