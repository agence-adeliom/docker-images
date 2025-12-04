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
