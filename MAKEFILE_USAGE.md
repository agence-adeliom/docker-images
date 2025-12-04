# Makefiles Guide - Quick Reference

## 📁 Structure

```
docker-images/
├── Makefile           # Main orchestrator (simplified)
├── php/
│   └── Makefile       # PHP-specific commands
└── redis/
    └── Makefile       # Redis-specific commands
```

## 🎯 Main Makefile (Root)

The root Makefile is now simplified and delegates to subdirectory Makefiles.

### Quick Help

```bash
# Show main menu
make help

# Show PHP commands
make php-help

# Show Redis commands
make redis-help
```

### Quick Commands

```bash
# PHP
make php-cli@8.4
make php-caddy@8.3
make php-apache@8.2-debug

# Redis
make redis@7.4
make redis-build
make redis-test

# Global
make build-all        # Build everything
make clean-all        # Clean everything
make status          # Show all containers
make images          # List all images
```

## 🔧 PHP Makefile

Located in `php/Makefile` - Full control over PHP images.

### Navigation

```bash
cd php
make help  # Show all PHP commands
```

### Common Commands

```bash
# Build
make build PHP_VERSION=8.4 VARIATION=cli
make cli@8.4
make apache@8.3
make build-all-variants  # All variants for current version
make build-all          # Everything

# Run
make run PHP_VERSION=8.3 VARIATION=apache
make run-debug

# Test
make test
make test-version
make test-extensions

# Info
make php-info
make php-modules
make composer-version

# Clean
make clean
make clean-version
make clean-all
```

### Examples

```bash
# Build and run Apache
make apache@8.3
make run PHP_VERSION=8.3 VARIATION=apache
# Visit http://localhost:8080

# Debug Caddy
make caddy@8.2-debug

# Test CLI
make cli@8.4
make test PHP_VERSION=8.4 VARIATION=cli
```

## 🔴 Redis Makefile

Located in `redis/Makefile` - Full control over Redis images.

### Navigation

```bash
cd redis
make help  # Show all Redis commands
```

### Common Commands

```bash
# Build
make build REDIS_VERSION=7.4
make 7.4              # Build and test
make build-all        # All versions

# Run
make run
make run-no-password
make run-debug
make run-prod

# Test
make test
make test-persistence
make test-all-versions

# Info
make info
make config
make health

# CLI
make cli
make ping

# Clean
make clean
make clean-all
```

### Examples

```bash
# Quick test
make 7.4

# Development
make build
make run-no-password
make cli-no-password

# Production test
make build
make run-prod
make test
```

## 🚀 Workflows

### PHP Development Workflow

```bash
# From project root
make php-caddy@8.3

# Or from php directory
cd php
make caddy@8.3
make run PHP_VERSION=8.3 VARIATION=caddy
# Test your app on http://localhost:8080
make stop
```

### Redis Development Workflow

```bash
# From project root
make redis@7.4

# Or from redis directory
cd redis
make build
make run
make test
make stop
```

### Full Build Workflow

```bash
# Build everything
make build-all

# Check status
make status
make images

# Clean everything
make clean-all
```

## 📊 Comparison: Root vs Sub-Makefiles

### Root Makefile (Simplified)

**Purpose**: Quick access and orchestration

**Use when**:
- You want to quickly build/test from project root
- You're working with multiple image types
- You need a global overview

**Examples**:
```bash
make php-cli@8.4
make redis@7.4
make build-all
```

### Sub-Makefiles (Detailed)

**Purpose**: Full control and detailed operations

**Use when**:
- You're focusing on one image type
- You need advanced commands
- You want detailed control

**Examples**:
```bash
cd php && make build-all-variants
cd redis && make test-persistence
```

## 🔄 Migration from Old Makefile

Old commands still work for backward compatibility:

```bash
# Old way (still works)
make fpm@8.4
make apache@8.2-debug

# New way (recommended)
make php-fpm@8.4
make php-apache@8.2-debug

# Or even better
cd php && make fpm@8.4
```

## 💡 Best Practices

### 1. Use Sub-Makefiles for Development

```bash
# Recommended
cd php
make apache@8.3
make run PHP_VERSION=8.3 VARIATION=apache
make logs

# Instead of
make php-apache@8.3
cd php && docker run...
```

### 2. Use Root Makefile for Quick Tasks

```bash
# Good for quick commands
make php-cli@8.4
make redis@7.4
make status
```

### 3. Variables Override

```bash
# In php directory
make build PHP_VERSION=8.2 VARIATION=nginx

# In redis directory
make build REDIS_VERSION=7.0
make run TEST_PASSWORD=custom_pass
```

### 4. Chaining Commands

```bash
# PHP
cd php && make build && make test && make clean

# Redis
cd redis && make build && make run && make test && make stop
```

## 🎨 Tips & Tricks

### Parallel Building

```bash
# Build multiple versions in parallel
cd php
make cli@8.3 & make cli@8.4 & wait
```

### Quick Testing

```bash
# PHP quick test
cd php && make cli@8.4 && docker run --rm adeliom/php:8.4-cli php -v

# Redis quick test
cd redis && make 7.4
```

### Environment Variables

```bash
# Override defaults
cd php
PHP_VERSION=8.2 VARIATION=apache make build
make run PHP_VERSION=8.2 VARIATION=apache

cd redis
REDIS_VERSION=7.0 TEST_PASSWORD=mypass make run
```

## 📚 Related Documentation

- [Main README](README.md)
- [PHP README](php/README.md)
- [Redis README](redis/README.md)
- [Full Makefile Usage](MAKEFILE_USAGE.md)

## 🆘 Quick Help

```bash
# Get help anywhere
make help                  # Root
cd php && make help       # PHP
cd redis && make help     # Redis

# Show running containers
make status               # All
cd php && make ps        # PHP
cd redis && make ps      # Redis

# Show images
make images              # All
cd php && make images    # PHP
cd redis && make images  # Redis
```

---

**Pro Tip**: Bookmark this file for quick reference! 📖
