# Adeliom Docker Images

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/adeliom/php)
![Docker Pulls](https://img.shields.io/docker/pulls/adeliom/redis)

Production-ready Docker images for PHP and Redis, preconfigured and optimized for Adeliom projects.

## 🚀 Quick Start

```bash
# PHP
make php-cli@8.4
make php-caddy@8.3

# Redis
make redis@7.4
make redis-test

# Get help
make help
```

## 📦 Available Images

### PHP Images

Developer-friendly PHP images with multiple variants and server options.

**Variants:** CLI, FPM, Apache, Nginx, Caddy, FrankenPHP  
**Versions:** 8.1, 8.2, 8.3, 8.4  
**Documentation:** [php/README.md](php/README.md)

```bash
docker pull adeliom/php:8.4-cli
docker pull adeliom/php:8.3-caddy
docker pull adeliom/php:8.2-apache
```

### Redis Images

Redis images with optimized configurations.

**Versions:** 6.2, 7.0, 7.2, 7.4  
**Documentation:** [redis/README.md](redis/README.md)

```bash
docker pull adeliom/redis:7.4
docker pull adeliom/redis:7.2
```

## 🎯 Features

### PHP
- ✅ Multiple server variants (Apache, Nginx, Caddy, FrankenPHP)
- ✅ Pre-installed extensions (Redis, MySQL, PostgreSQL, GD, etc.)
- ✅ Composer included
- ✅ Environment-based configuration
- ✅ Production-ready defaults

### Redis
- ✅ Multiple configurations (default, dev, prod)
- ✅ AOF and RDB persistence
- ✅ Built-in healthcheck
- ✅ Security defaults
- ✅ Alpine-based (lightweight)

## 📚 Documentation

- **[MAKEFILES.md](MAKEFILES.md)** - Quick reference for all Makefiles
- **[MAKEFILE_USAGE.md](MAKEFILE_USAGE.md)** - Detailed usage guide
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete project overview
- **[php/README.md](php/README.md)** - PHP images documentation
- **[redis/README.md](redis/README.md)** - Redis images documentation
- **[redis/QUICKSTART.md](redis/QUICKSTART.md)** - Redis quick start guide

## 🛠️ Makefile System

Three-level Makefile structure for easy management:

```
Makefile (root)      → Quick commands & orchestration
├── php/Makefile     → 50+ PHP commands
└── redis/Makefile   → 50+ Redis commands
```

### Quick Commands

```bash
# Show help
make help
make php-help
make redis-help

# PHP
make php-cli@8.4
make php-apache@8.3-debug

# Redis  
make redis@7.4
make redis-build
make redis-test

# Global
make build-all
make clean-all
make status
```

### Detailed Commands

```bash
# PHP (from php directory)
cd php
make help
make build PHP_VERSION=8.4 VARIATION=cli
make run PHP_VERSION=8.3 VARIATION=apache
make test

# Redis (from redis directory)
cd redis
make help
make build REDIS_VERSION=7.4
make run
make test
./test.sh 7.4
```

## 🔧 Installation & Setup

```bash
# Clone the repository
git clone https://github.com/agence-adeliom/docker-images.git
cd docker-images

# Setup (make scripts executable)
chmod +x setup.sh
./setup.sh

# Test PHP
cd php
make cli@8.4
make test PHP_VERSION=8.4 VARIATION=cli

# Test Redis
cd ../redis
make 7.4
./test.sh 7.4
```

## 📖 Usage Examples

### PHP Examples

#### CLI Usage
```bash
docker run --rm adeliom/php:8.4-cli php -v
docker run --rm -v $(pwd):/var/www/html adeliom/php:8.4-cli php script.php
```

#### Apache Usage
```bash
docker run -d -p 80:80 -v $(pwd):/var/www/html adeliom/php:8.3-apache
```

#### With Makefile
```bash
cd php
make apache@8.3
make run PHP_VERSION=8.3 VARIATION=apache
# Visit http://localhost:8080
```

### Redis Examples

#### Basic Usage
```bash
docker run -d -p 6379:6379 \
  -e REDIS_PASSWORD=mypassword \
  adeliom/redis:7.4
```

#### With Docker Compose
```yaml
version: '3.8'
services:
  redis:
    image: adeliom/redis:7.4
    environment:
      - REDIS_PASSWORD=secure_password
      - REDIS_AOF_ENABLED=yes
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/adeliom/redis/data
volumes:
  redis_data:
```

#### With Makefile
```bash
cd redis
make build
make run
make test
make cli
```

## 🔐 Environment Variables

### PHP

Configure via environment variables:

```yaml
PHP_INI_MEMORY_LIMIT: "256M"
PHP_INI_UPLOAD_MAX_FILESIZE: "32M"
PHP_INI_POST_MAX_SIZE: "32M"
XDEBUG_MODE: "debug"
```

See [php/README.md](php/README.md) for complete list.

### Redis

```yaml
ALLOW_EMPTY_PASSWORD: "no"          # Allow empty password
REDIS_PASSWORD: "secret"            # Redis password
REDIS_PORT_NUMBER: "6379"           # Port number
REDIS_DATABASE: "16"                # Number of databases
REDIS_AOF_ENABLED: "yes"            # Enable AOF
REDIS_RDB_POLICY: "900 1 300 10"    # RDB policy
REDIS_DISABLE_COMMANDS: "FLUSHDB"   # Disable commands
REDIS_IO_THREADS: "4"               # I/O threads
```

See [redis/README.md](redis/README.md) for complete list.

## 🏗️ Building Images

### Build Locally

```bash
# PHP
cd php
make build PHP_VERSION=8.4 VARIATION=cli

# Redis
cd redis
make build REDIS_VERSION=7.4
```

### Build All

```bash
# From root
make build-all

# PHP only
cd php && make build-all

# Redis only
cd redis && make build-all
```

## 🧪 Testing

### PHP Testing

```bash
cd php
make test PHP_VERSION=8.4 VARIATION=cli
make test-composer
make test-server
```

### Redis Testing

```bash
cd redis
make test
make test-persistence
./test.sh 7.4
```

## 🚀 CI/CD

GitHub Actions workflows are configured for automated builds:

- **PHP**: `.github/workflows/build_php.yml`
- **Redis**: `.github/workflows/build_redis.yml`

Builds are triggered on:
- Push to main
- Pull requests
- Manual workflow dispatch
- New releases

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📊 Project Structure

```
docker-images/
├── Makefile                    # Root orchestrator
├── MAKEFILES.md                # Makefile quick reference
├── MAKEFILE_USAGE.md           # Detailed usage guide
├── PROJECT_SUMMARY.md          # Project summary
├── setup.sh                    # Setup script
│
├── .github/workflows/
│   ├── build_php.yml          # PHP CI/CD
│   └── build_redis.yml        # Redis CI/CD
│
├── php/
│   ├── Makefile               # 50+ PHP commands
│   ├── Dockerfile.*           # PHP variants
│   ├── README.md              # PHP documentation
│   └── config/                # PHP configurations
│
├── redis/
│   ├── Makefile               # 50+ Redis commands
│   ├── Dockerfile             # Redis image
│   ├── README.md              # Complete docs
│   ├── QUICKSTART.md          # Quick start
│   ├── test.sh                # Test script
│   └── config/                # Configurations
│       ├── README.md          # Config guide
│       ├── docker-compose.example.yml
│       ├── docker-entrypoint.sh
│       ├── healthcheck.sh
│       ├── redis.conf         # Default
│       ├── redis-dev.conf     # Development
│       └── redis-prod.conf    # Production
│
└── test/                      # Test files
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Based on official PHP and Redis Alpine images
- Built with ❤️ by the Adeliom team

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/agence-adeliom/docker-images/issues)
- **Email**: contact@adeliom.com
- **Documentation**: See above links

## 🔗 Links

- **Docker Hub PHP**: https://hub.docker.com/r/adeliom/php
- **Docker Hub Redis**: https://hub.docker.com/r/adeliom/redis
- **GitHub Repository**: https://github.com/agence-adeliom/docker-images
- **Adeliom Website**: https://adeliom.com

---

**Made with ❤️ by [@agence-adeliom](https://github.com/agence-adeliom)**
