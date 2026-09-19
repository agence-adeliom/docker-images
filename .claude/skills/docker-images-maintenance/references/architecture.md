# Architecture du repo

## Arborescence

```
.
├── Makefile                     # orchestrateur racine (délègue à php/ et redis/)
├── MAKEFILE_USAGE.md            # guide d'usage détaillé du Makefile
├── README.md                    # présentation générale
├── php/
│   ├── Makefile                 # build/run/test/scan des images PHP
│   ├── README.md                # doc publiée sur Docker Hub (adeliom/php)
│   ├── Dockerfile.cli                  # FROM php:${PHP_VERSION}-cli-alpine
│   ├── Dockerfile.cli-wkhtmltopdf      # FROM ${REGISTRY}/php:${PHP_VERSION}-cli${TAG}
│   ├── Dockerfile.fpm                  # FROM php:${PHP_VERSION}-fpm-alpine
│   ├── Dockerfile.fpm-wkhtmltopdf      # FROM ${REGISTRY}/php:${PHP_VERSION}-fpm${TAG}
│   ├── Dockerfile.apache               # FROM ${REGISTRY}/php:${PHP_VERSION}-fpm${TAG}
│   ├── Dockerfile.apache-wkhtmltopdf   # FROM ${REGISTRY}/php:${PHP_VERSION}-fpm-wkhtmltopdf${TAG}
│   ├── Dockerfile.nginx                # FROM ${REGISTRY}/php:${PHP_VERSION}-fpm${TAG}
│   ├── Dockerfile.nginx-wkhtmltopdf    # FROM ${REGISTRY}/php:${PHP_VERSION}-fpm-wkhtmltopdf${TAG}
│   ├── Dockerfile.caddy                # build stage golang:1.26-alpine (xcaddy) + FROM ${REGISTRY}/php:${PHP_VERSION}-fpm${TAG}
│   ├── Dockerfile.caddy-wkhtmltopdf    # idem + FROM ...-fpm-wkhtmltopdf${TAG}
│   ├── Dockerfile.frankenphp           # FROM dunglas/frankenphp:php${PHP_VERSION} (indépendant, pas basé sur notre fpm)
│   ├── Dockerfile.frankenphp-wkhtmltopdf # FROM ${REGISTRY}/php:${PHP_VERSION}-frankenphp${TAG}
│   └── config/                  # Caddyfile, vhosts apache/nginx, supervisord, php.ini, entrypoints
├── redis/
│   ├── Makefile
│   ├── Dockerfile               # FROM redis:${REDIS_VERSION}-alpine
│   └── config/                  # redis.conf (default/dev/prod), entrypoint, healthcheck
├── test/                        # fichiers PHP de test montés dans les images pour vérif manuelle
└── .github/
    ├── workflows/
    │   ├── build_php.yml        # workflow réutilisable (workflow_call) : build+test+push toutes variantes PHP
    │   ├── build_redis.yml      # équivalent pour Redis
    │   ├── manual_build.yml     # workflow_dispatch : déclenche build_php/build_redis à la demande
    │   ├── ci_publish_release.yml # déclenché sur `release: published` : build + push + MAJ des README Docker Hub
    │   └── check_redis_versions.yml # cron hebdo : détecte nouvelles versions Redis, ouvre une PR
    ├── scripts/update_redis_versions.py # logique de détection de version utilisée par check_redis_versions.yml
    └── dependabot.yml            # bump quotidien des GitHub Actions (package-ecosystem: github-actions)
```

## Graphe de dépendances entre Dockerfiles PHP

Les variantes ne sont pas indépendantes : plusieurs `FROM ${REGISTRY}/php:...` pointent vers une image *déjà construite par ce même repo* (pas l'image officielle `php:*-alpine`). Concrètement, dans la CI (`build_php.yml`), le job `base` (variants `cli`, `fpm`) doit tourner avant les jobs `apache`, `nginx`, `caddy`, `wkhtmltopdf` (`needs: [base]`), et `frankenphp-wkhtmltopdf` dépend du job `frankenphp`.

```
php:${V}-cli-alpine (officielle)     php:${V}-fpm-alpine (officielle)
        │                                     │
        ▼                                     ▼
  Dockerfile.cli  ────────────────►  Dockerfile.fpm
        │                                     │
        ▼                                     ├──► Dockerfile.apache
Dockerfile.cli-wkhtmltopdf                    ├──► Dockerfile.nginx
                                               ├──► Dockerfile.caddy
                                               └──► Dockerfile.fpm-wkhtmltopdf
                                                        │
                                                        ├──► Dockerfile.apache-wkhtmltopdf
                                                        ├──► Dockerfile.nginx-wkhtmltopdf
                                                        └──► Dockerfile.caddy-wkhtmltopdf

dunglas/frankenphp:php${V} (officielle)
        │
        ▼
Dockerfile.frankenphp ──► Dockerfile.frankenphp-wkhtmltopdf
```

**Conséquence pratique** : si tu corriges une CVE dans le PHP de base (`Dockerfile.fpm` ou `Dockerfile.cli`), il faut reconstruire/rescanner les variantes en aval (`apache`, `nginx`, `caddy`, et les `-wkhtmltopdf`) car elles héritent de l'image locale, pas seulement de l'image officielle.

**En local, `${REGISTRY}` doit correspondre à une image déjà buildée localement — ce n'est PAS automatique.** `php/Makefile` a `REGISTRY ?= docker.io` par défaut ; sans override, `FROM ${REGISTRY}/php:${PHP_VERSION}-fpm${TAG_VERSION}` résout vers l'image PHP **officielle** Debian-based (`docker.io/php:...`), pas vers `adeliom/php:...-fpm` construite juste avant en local — ce qui casse toute étape `apk add` (`apk: not found`) dans les Dockerfiles en aval. Toujours passer `REGISTRY=adeliom` en local pour builder `apache`/`nginx`/`caddy`/`caddy-wkhtmltopdf` après un `fpm` local (détail et commandes dans `references/commands.md`).

## Registries et tags

- **Docker Hub** : `adeliom/php`, `adeliom/redis`.
- **GHCR** : `ghcr.io/agence-adeliom/php`, `ghcr.io/agence-adeliom/redis`.
- Le registre cible est passé en `ARG REGISTRY` (défaut CI `ghcr.io/agence-adeliom`), utilisé pour résoudre les `FROM ${REGISTRY}/php:...` internes ET comme préfixe du tag poussé.
- Tag format : `<version>-<variant>[<suffix>]`, ex. `8.4-caddy`, `8.4-caddy-latest-release-tag`. Le suffixe dépend de `image_suffix` :
  - `-dev` → pas de suffixe supplémentaire, tag `dev` (build de test, jamais poussé sauf si explicitement demandé).
  - `-{{latest_release_tag}}` → suffixe = dernier tag git (`git describe --tags --abbrev=0`), utilisé automatiquement par `ci_publish_release.yml` sur chaque release GitHub publiée.
  - `-latest` → pas de suffixe (option manuelle uniquement, via `manual_build.yml`).

## CI/CD

- **`build_php.yml`** (réutilisable, `workflow_call`) : matrice `version × variant`, jobs `frankenphp`, `frankenphp-wkhtmltopdf`, `base` (cli+fpm), `wkhtmltopdf`, `caddy`, `caddy-wkhtmltopdf`, `nginx`, `nginx-wkhtmltopdf`, `apache`, `apache-wkhtmltopdf`. Chaque job : login Docker Hub + GHCR → build amd64 avec cache GHA → **test fonctionnel** (vérifie `php -v`, `composer --version`, présence des extensions attendues, `wkhtmltopdf --version` si applicable) → build+push multi-registre avec `provenance: true`, `sbom: true`. Le paramètre `variant_filter` permet de ne construire qu'un sous-ensemble (`all`, `frankenphp`, `base`, `caddy`, `nginx`, `apache`). `skip_wkhtmltopdf` permet de sauter les variantes wkhtmltopdf.
- **`ci_publish_release.yml`** : déclenché sur `release: published` (hors prerelease) — build+push PHP et Redis vers Docker Hub ET GHCR avec le tag de la release, puis met à jour les README publiés sur Docker Hub via `peter-evans/dockerhub-description`.
- **`manual_build.yml`** : `workflow_dispatch` — permet de rejouer un build ciblé (image `php`/`redis`, registre, variantes, suffixe, push ou non) sans faire de release. **C'est le moyen recommandé pour valider un correctif CVE en conditions CI avant de faire une release.**
- **`check_redis_versions.yml`** : cron hebdo (lundi 06:00 UTC) — exécute `update_redis_versions.py`, ouvre automatiquement une PR si une nouvelle version mineure Redis est détectée sur Docker Hub.
- **`dependabot.yml`** : bump quotidien des actions GitHub utilisées dans les workflows (pas de bump des Dockerfiles eux-mêmes — la veille sur PHP/Caddy/FrankenPHP/wkhtmltopdf reste manuelle, voir `maintenance-calendar.md`).
- **Il n'existe pas de job CI de scan de vulnérabilités automatisé** (`docker scout`) : le scan est un geste manuel avant/après un correctif, via `make scan-*` (voir `commands.md`). C'est un angle mort à garder en tête — proposer d'en ajouter un si pertinent, mais ne pas l'inventer sans validation de l'utilisateur.
