# Adeliom Redis

![Docker Pulls](https://img.shields.io/docker/pulls/adeliom/redis)

This repository contains a developer-friendly, preconfigured Redis image for Docker, based on the official Redis Alpine image.

## 🚀 Features

- **Based on Redis Alpine**: Lightweight and performant image
- **Preconfigured**: Optimized configuration for production use
- **Environment variables**: Flexible configuration via ENV
- **Persistence**: Configurable AOF and RDB
- **Healthcheck**: Automatic health verification
- **Security**: Authentication and dangerous command disabling
- **Structured logs**: Organized and accessible logs
- **Timezone**: Configured for Europe/Paris by default

## Latest Images

| Name                      | Redis version | Architecture |
|---------------------------|---------------|--------------|
| `adeliom/redis:6.2`       | `6.2`         | `amd64/arm64`|
| `adeliom/redis:7.0`       | `7.0`         | `amd64/arm64`|
| `adeliom/redis:7.2`       | `7.2`         | `amd64/arm64`|
| `adeliom/redis:7.4`       | `7.4`         | `amd64/arm64`|
| `adeliom/redis:latest`    | `7.4`         | `amd64/arm64`|

## Specific Image Versions

Using latest tags is a good way to stay up to date, but sometimes you need more control over the version you are using.

All detailed images are the latest stable versions. You can also use specific versions by adding a `-{specific-version}` part in the image name:

Example: `adeliom/redis:7.4-dev` or `adeliom/redis:7.4-1.0.0`

- On every release, the image tag is moved to the new version.
- On every release a new tag is created with the version number (e.g. `1.0.0`, `1.0.1`, etc.). [See releases list](https://github.com/agence-adeliom/docker-images/releases)
- Before a new release, the `dev` tag is used for the new version. Do not use this tag in production.

To stay up to date, you can use the `default` tag, which is always pointing to the latest stable version.

## Prerequisites

- Docker >= 20.10
- Docker Compose >= 2.0 (optional)

## Usage

### Basic Usage

```bash
# Run Redis with password
docker run -d --name my-redis \
  -e REDIS_PASSWORD=my-secure-password \
  -p 6379:6379 \
  adeliom/redis:7.4

# Run Redis with custom port
docker run -d --name my-redis \
  -e REDIS_PASSWORD=my-secure-password \
  -e REDIS_PORT_NUMBER=6380 \
  -p 6380:6380 \
  adeliom/redis:7.4

# Run Redis for development (no password)
docker run -d --name my-redis-dev \
  -e ALLOW_EMPTY_PASSWORD=yes \
  -p 6379:6379 \
  adeliom/redis:7.4
```

### Docker Compose Example

```yaml
version: '3.8'

services:
  redis:
    image: adeliom/redis:7.4
    container_name: my-redis
    restart: unless-stopped
    
    environment:
      - REDIS_PASSWORD=my-secure-password
      - REDIS_PORT_NUMBER=6379
      - REDIS_DATABASE=16
      - REDIS_AOF_ENABLED=yes
      - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG
    
    ports:
      - "6379:6379"
    
    volumes:
      - redis_data:/adeliom/redis/data
      - redis_logs:/adeliom/redis/logs

volumes:
  redis_data:
  redis_logs:
```

## Default Working Directory

The data directory structure in the image:

| Directory                  | Purpose                |
|---------------------------|------------------------|
| `/adeliom/redis/data`     | Redis data files       |
| `/adeliom/redis/logs`     | Redis log files        |
| `/adeliom/redis/conf`     | Redis configuration    |
| `/adeliom/redis/tmp`      | Temporary files        |

## Configuration via Environment Variables

You can configure Redis using the following environment variables:

### Basic Configuration

| Variable                  | Description                                | Default   |
|--------------------------|--------------------------------------------|-----------|
| `ALLOW_EMPTY_PASSWORD`   | Allow empty password (dev only)            | `no`      |
| `REDIS_PASSWORD`         | Redis password                             | ` `       |
| `REDIS_PASSWORD_FILE`    | Path to file containing Redis password     | ` `       |
| `REDIS_PORT_NUMBER`      | Redis listening port                       | `6379`    |
| `REDIS_DATABASE`         | Number of databases                        | `16`      |

### Persistence Configuration

| Variable                    | Description                              | Default |
|----------------------------|------------------------------------------|---------|
| `REDIS_AOF_ENABLED`        | Enable AOF persistence                   | `yes`   |
| `REDIS_RDB_POLICY`         | Custom RDB save policy                   | ` `     |
| `REDIS_RDB_POLICY_DISABLED`| Disable RDB persistence                  | `no`    |

**RDB Policy Format**: `<seconds> <changes> [<seconds> <changes> ...]`

**Example**: `REDIS_RDB_POLICY="900 1 300 10 60 10000"` means:
- Save after 900 seconds if at least 1 key changed
- Save after 300 seconds if at least 10 keys changed
- Save after 60 seconds if at least 10000 keys changed

### Performance Configuration

| Variable                    | Description                              | Default |
|----------------------------|------------------------------------------|---------|
| `REDIS_IO_THREADS`         | Number of I/O threads                    | ` `     |
| `REDIS_IO_THREADS_DO_READS`| Enable threaded reads                    | `no`    |

### Security Configuration

| Variable                  | Description                                | Default   |
|--------------------------|--------------------------------------------|-----------|
| `REDIS_DISABLE_COMMANDS` | Comma-separated list of commands to disable| ` `       |

**Example**: `REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG,KEYS`

### Advanced Configuration

| Variable                  | Description                                | Default   |
|--------------------------|--------------------------------------------|-----------|
| `MODE_DEBUG`          | Enable debug mode                          | `false`   |
| `TZ`                     | Timezone                                   | `Europe/Paris` |

## Security Configuration Examples

### Production Setup

```yaml
services:
  redis:
    image: adeliom/redis:7.4
    environment:
      # Strong password
      - REDIS_PASSWORD=MyVerySecurePassword123!
      
      # Disable dangerous commands
      - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG,KEYS,DEBUG
      
      # Enable both persistence methods
      - REDIS_AOF_ENABLED=yes
      - REDIS_RDB_POLICY=900 1 300 10 60 10000
    
    volumes:
      - redis_data:/adeliom/redis/data
```

### Development Setup

```yaml
services:
  redis-dev:
    image: adeliom/redis:7.4
    environment:
      # No password in development
      - ALLOW_EMPTY_PASSWORD=yes
      
      # Disable AOF for better performance
      - REDIS_AOF_ENABLED=no
      
      # Enable debug logging
      - MODE_DEBUG=true
```

### Using Password File

```yaml
services:
  redis:
    image: adeliom/redis:7.4
    environment:
      - REDIS_PASSWORD_FILE=/run/secrets/redis_password
    
    secrets:
      - redis_password

secrets:
  redis_password:
    file: ./secrets/redis_password.txt
```

## Data Persistence

Two persistence mechanisms are available:

### AOF (Append Only File)
- File: `/adeliom/redis/data/appendonly.aof`
- Sync: Every second by default
- Safer but slower
- Enabled by default

```bash
docker run -d \
  -e REDIS_AOF_ENABLED=yes \
  adeliom/redis:7.4
```

### RDB (Snapshots)
- File: `/adeliom/redis/data/dump.rdb`
- Configurable save points
- Faster but potential data loss
- Enabled by default with standard policy

```bash
# Custom RDB policy
docker run -d \
  -e REDIS_RDB_POLICY="3600 1 300 100 60 10000" \
  adeliom/redis:7.4

# Disable RDB completely
docker run -d \
  -e REDIS_RDB_POLICY_DISABLED=yes \
  adeliom/redis:7.4
```

### Disabling Both (Not Recommended)

```bash
docker run -d \
  -e REDIS_AOF_ENABLED=no \
  -e REDIS_RDB_POLICY_DISABLED=yes \
  adeliom/redis:7.4
```

**⚠️ Warning**: Disabling both persistence methods means data loss on container restart.

## Performance Tuning

### Multi-threaded I/O

Starting from Redis 6.0, you can enable multi-threaded I/O:

```yaml
services:
  redis:
    image: adeliom/redis:7.4
    environment:
      # Use 4 I/O threads
      - REDIS_IO_THREADS=4
      
      # Enable threaded reads (Redis 6.2+)
      - REDIS_IO_THREADS_DO_READS=yes
```

**Note**: 
- Set `REDIS_IO_THREADS` to the number of CPU cores for best performance
- `REDIS_IO_THREADS_DO_READS` requires Redis 6.2 or higher

## Monitoring

### Health Check

The image includes a built-in health check:

```bash
docker inspect --format='{{.State.Health.Status}}' my-redis
```

### Connection Test

```bash
# Without password (development)
docker exec my-redis redis-cli ping

# With password
docker exec my-redis redis-cli -a my-password ping
```

### Get Redis Info

```bash
# Full info
docker exec my-redis redis-cli -a my-password INFO

# Specific section
docker exec my-redis redis-cli -a my-password INFO server
docker exec my-redis redis-cli -a my-password INFO memory
docker exec my-redis redis-cli -a my-password INFO stats
```

### Using Redis Commander

```yaml
services:
  redis:
    image: adeliom/redis:7.4
    environment:
      - REDIS_PASSWORD=my-password
  
  redis-commander:
    image: rediscommander/redis-commander:latest
    environment:
      - REDIS_HOSTS=local:redis:6379:0:my-password
      - HTTP_USER=admin
      - HTTP_PASSWORD=admin
    ports:
      - "8081:8081"
    depends_on:
      - redis
```

Access the UI at http://localhost:8081

## Troubleshooting

### Redis doesn't start

```bash
# Check logs
docker logs my-redis

# Check configuration
docker exec my-redis cat /adeliom/redis/conf/redis.conf
```

### Connection issues

```bash
# Test connection
docker exec my-redis redis-cli ping

# Check listening port
docker exec my-redis netstat -tlnp | grep redis

# Verify environment variables
docker exec my-redis env | grep REDIS
```

### Permission issues

```bash
# Check volume permissions
docker volume inspect redis_data

# Ensure redis user owns the data directory
docker exec my-redis ls -la /adeliom/redis/data
```

### Password not working

```bash
# Verify password is set
docker exec my-redis grep "requirepass" /adeliom/redis/conf/redis.conf

# Check if ALLOW_EMPTY_PASSWORD is set
docker exec my-redis env | grep ALLOW_EMPTY_PASSWORD
```

## Kubernetes Deployment Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: adeliom/redis:7.4
        env:
        - name: REDIS_PASSWORD
          valueFrom:
            secretKeyRef:
              name: redis-secret
              key: password
        - name: REDIS_PORT_NUMBER
          value: "6379"
        - name: REDIS_DATABASE
          value: "16"
        - name: REDIS_AOF_ENABLED
          value: "yes"
        - name: REDIS_DISABLE_COMMANDS
          value: "FLUSHDB,FLUSHALL,CONFIG"
        ports:
        - containerPort: 6379
        volumeMounts:
        - name: data
          mountPath: /adeliom/redis/data
        livenessProbe:
          exec:
            command:
            - /opt/adeliom/scripts/redis/healthcheck.sh
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - /opt/adeliom/scripts/redis/healthcheck.sh
          initialDelaySeconds: 5
          periodSeconds: 5
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: redis-pvc
---
apiVersion: v1
kind: Secret
metadata:
  name: redis-secret
type: Opaque
stringData:
  password: your-secure-password-here
```

## Helm Chart Example

You can deploy Redis using Helm with a custom values file.

### Create Helm Chart Values

Create a `redis-values.yaml` file:

```yaml
# redis-values.yaml
image:
  registry: docker.io
  repository: adeliom/redis
  tag: 7.4
  pullPolicy: IfNotPresent

# Redis configuration
auth:
  enabled: true
  password: "your-secure-password"
  # Or use existing secret
  # existingSecret: "redis-secret"
  # existingSecretPasswordKey: "password"

# Environment variables
env:
  - name: REDIS_PORT_NUMBER
    value: "6379"
  - name: REDIS_DATABASE
    value: "16"
  - name: REDIS_AOF_ENABLED
    value: "yes"
  - name: REDIS_RDB_POLICY
    value: "900 1 300 10 60 10000"
  - name: REDIS_DISABLE_COMMANDS
    value: "FLUSHDB,FLUSHALL,CONFIG,KEYS"
  - name: REDIS_IO_THREADS
    value: "4"
  - name: REDIS_IO_THREADS_DO_READS
    value: "yes"

# Service configuration
service:
  type: ClusterIP
  port: 6379

# Persistence
persistence:
  enabled: true
  storageClass: ""  # Use default storage class
  size: 8Gi
  mountPath: /adeliom/redis/data

# Resources
resources:
  limits:
    memory: 512Mi
    cpu: 500m
  requests:
    memory: 256Mi
    cpu: 250m

# Health checks
livenessProbe:
  enabled: true
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 5
  exec:
    command:
      - /opt/adeliom/scripts/redis/healthcheck.sh

readinessProbe:
  enabled: true
  initialDelaySeconds: 5
  periodSeconds: 5
  timeoutSeconds: 3
  successThreshold: 1
  failureThreshold: 3
  exec:
    command:
      - /opt/adeliom/scripts/redis/healthcheck.sh

# Security context
podSecurityContext:
  fsGroup: 1001

securityContext:
  runAsUser: 999
  runAsNonRoot: true

# Node selector
nodeSelector: {}

# Tolerations
tolerations: []

# Affinity
affinity: {}
```

### Simple Helm Template

For a simpler deployment, create a minimal Helm chart structure:

```bash
# Create chart directory
mkdir -p redis-chart/templates

# Create Chart.yaml
cat > redis-chart/Chart.yaml <<EOF
apiVersion: v2
name: redis-adeliom
description: Redis Adeliom Helm chart
type: application
version: 1.0.0
appVersion: "7.4"
EOF

# Create values.yaml
cat > redis-chart/values.yaml <<EOF
image:
  repository: adeliom/redis
  tag: 7.4
  pullPolicy: IfNotPresent

redis:
  password: "change-me"
  port: 6379
  database: 16

persistence:
  enabled: true
  size: 8Gi

resources:
  limits:
    memory: 512Mi
  requests:
    memory: 256Mi
EOF

# Create deployment template
cat > redis-chart/templates/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-redis
  labels:
    app: {{ .Release.Name }}-redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Release.Name }}-redis
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-redis
    spec:
      containers:
      - name: redis
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        env:
        - name: REDIS_PASSWORD
          value: "{{ .Values.redis.password }}"
        - name: REDIS_PORT_NUMBER
          value: "{{ .Values.redis.port }}"
        - name: REDIS_DATABASE
          value: "{{ .Values.redis.database }}"
        - name: REDIS_AOF_ENABLED
          value: "yes"
        ports:
        - containerPort: {{ .Values.redis.port }}
        volumeMounts:
        - name: data
          mountPath: /adeliom/redis/data
        resources:
          {{- toYaml .Values.resources | nindent 10 }}
      volumes:
      - name: data
        {{- if .Values.persistence.enabled }}
        persistentVolumeClaim:
          claimName: {{ .Release.Name }}-redis-pvc
        {{- else }}
        emptyDir: {}
        {{- end }}
EOF
```

### Deploy with Helm

```bash
# Install Redis
helm install my-redis ./redis-chart \
  --set redis.password=my-secure-password \
  --namespace redis \
  --create-namespace

# Or with values file
helm install my-redis ./redis-chart \
  -f redis-values.yaml \
  --namespace redis \
  --create-namespace

# Upgrade
helm upgrade my-redis ./redis-chart \
  -f redis-values.yaml \
  --namespace redis

# Uninstall
helm uninstall my-redis --namespace redis
```

### Using with ArgoCD

Create an Application manifest:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: redis-adeliom
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-org/helm-charts
    targetRevision: HEAD
    path: redis-adeliom
    helm:
      values: |
        image:
          repository: adeliom/redis
          tag: 7.4
        redis:
          password: "secure-password"
        persistence:
          enabled: true
          size: 10Gi
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

### Helm Testing

```bash
# Dry run
helm install my-redis ./redis-chart \
  --dry-run --debug \
  -f redis-values.yaml

# Test connection after deployment
kubectl run redis-test --rm -it --restart=Never \
  --image=redis:alpine -- \
  redis-cli -h my-redis-redis -a your-password ping

# Check status
helm status my-redis --namespace redis

# Get values
helm get values my-redis --namespace redis
```

## Custom Configuration File

You can use a custom Redis configuration file:

```yaml
services:
  redis:
    image: adeliom/redis:7.4
    environment:
      - REDIS_PASSWORD=my-password
    volumes:
      - ./my-redis.conf:/opt/adeliom/redis/redis.conf.default:ro
      - redis_data:/adeliom/redis/data
```

See [config/](./config/) directory for configuration examples:
- `redis.conf` - Balanced default configuration
- `redis-dev.conf` - Development configuration
- `redis-prod.conf` - Production configuration

## Best Practices

1. **Always use a password in production**
   ```yaml
   environment:
     - REDIS_PASSWORD=${REDIS_PASSWORD}  # Use environment variable
   ```

2. **Enable both AOF and RDB for maximum durability**
   ```yaml
   environment:
     - REDIS_AOF_ENABLED=yes
     - REDIS_RDB_POLICY=900 1 300 10 60 10000
   ```

3. **Disable dangerous commands in production**
   ```yaml
   environment:
     - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL,CONFIG,KEYS,DEBUG
   ```

4. **Use volumes for data persistence**
   ```yaml
   volumes:
     - redis_data:/adeliom/redis/data
   ```

5. **Monitor memory usage** and set appropriate limits

6. **Regular backups** of your data directory

7. **Use secrets** for password management in production

## Differences from Official Redis Image

- **Environment-based configuration**: Configure Redis entirely through environment variables
- **Automatic setup**: No need to mount configuration files for basic setup
- **Security defaults**: Better security defaults out of the box
- **Structured directories**: Organized directory structure under `/adeliom/redis/`
- **Built-in healthcheck**: Automatic container health monitoring
- **Debug mode**: Easy troubleshooting with `MODE_DEBUG=true`

## Building from Source

If you want to build the image yourself:

```bash
# Clone the repository
git clone https://github.com/agence-adeliom/docker-images.git
cd docker-images/redis

# Build the image
docker build --build-arg REDIS_VERSION=7.4 -t adeliom/redis:7.4 .
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -am 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

For issues and questions:
- GitHub Issues: [GitHub Issues](https://github.com/agence-adeliom/docker-images/issues)

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.

## Versions

- **Redis**: 6.2, 7.0, 7.2, 7.4
- **Alpine**: Latest
- **Image Version**: See [releases](https://github.com/agence-adeliom/docker-images/releases)

---

Made with ❤️ by [@agence-adeliom](https://github.com/agence-adeliom)
