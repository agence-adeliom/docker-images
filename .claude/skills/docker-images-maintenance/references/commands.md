# Cheat-sheet commandes

## Build local (racine du repo)

```
make php-cli@8.4                 # build PHP 8.4 CLI
make php-fpm@8.4                 # build PHP 8.4 FPM (prérequis pour apache/nginx/caddy)
make php-caddy@8.4 REGISTRY=adeliom   # build PHP 8.4 Caddy (part de fpm construit localement — voir piège REGISTRY ci-dessous)
make php-frankenphp@8.4           # build PHP 8.4 FrankenPHP
make php-apache@8.5-debug         # variante debug (voir php/Makefile pour le détail de "debug")
make php-build-all                # build toutes les variantes/versions
```
Équivalent direct dans `php/` : `cd php && make caddy@8.4 REGISTRY=adeliom`, etc. — regarder `php/Makefile` pour les variables `IMAGE_NAME`, `PHP_VERSION`, `VARIATION` si besoin de builder à la main avec `docker build`.

### ⚠️ Piège `REGISTRY` : image locale vs image officielle/registry distant

`Dockerfile.apache`, `Dockerfile.nginx`, `Dockerfile.caddy` et `Dockerfile.caddy-wkhtmltopdf` ne partent pas de l'image officielle `php:*-alpine` mais de l'image **fpm construite par ce repo** : `FROM ${REGISTRY}/php:${PHP_VERSION}-fpm${TAG_VERSION}`.

Dans `php/Makefile`, `REGISTRY` vaut par défaut `docker.io`, et le build ne passe que `--build-arg REGISTRY=$(REGISTRY)` (pas `IMAGE_PREFIX`). Résultat : sans override, `FROM ${REGISTRY}/php:...` résout en `docker.io/php:8.4-fpm`, c'est-à-dire **l'image PHP officielle** (Debian-based) — et non `adeliom/php:8.4-fpm` construite en local (Alpine-based). Symptôme typique : `apk: not found` (ou toute étape `apk add` qui échoue) pendant le build de `caddy`/`apache`/`nginx`, alors que `fpm` a bien été buildé juste avant.

**Fix** : passer explicitement `REGISTRY=adeliom` pour que Docker résolve le `FROM` vers l'image locale `adeliom/php:${PHP_VERSION}-fpm` (tag produit par `IMAGE_NAME := adeliom/php`) au lieu d'aller chercher/pull l'image officielle ou celle d'un registry distant :

```
make php-fpm@8.4                              # build adeliom/php:8.4-fpm en local
make php-caddy@8.4 REGISTRY=adeliom           # caddy part bien du fpm local, pas de docker.io/php
```

Cette variable `REGISTRY` overridée sur la ligne de commande est automatiquement exportée aux sous-`make` (le Makefile racine délègue via `cd php && make ...`), donc `make php-caddy@8.4 REGISTRY=adeliom` depuis la racine fonctionne aussi. Ne pas confondre avec le `REGISTRY` utilisé en CI/release (`ghcr.io/agence-adeliom` ou `docker.io`, voir `architecture.md#registries-et-tags`) : celui-là sert à pousser vers un registry distant après un build multi-stage où l'image de base a déjà été construite et poussée précédemment dans le même run CI — en local il n'y a pas de push intermédiaire, donc il faut pointer vers l'image locale.

```
make redis@7.4                    # build & test Redis 7.4
make redis-build                  # build Redis (dernière version par défaut)
make redis-build-all              # build toutes les versions Redis
```

## Scan de vulnérabilités (docker scout, 100% manuel — pas de job CI dédié)

```
make php-scan PHP_VERSION=8.4 VARIATION=caddy     # scan un variant précis (critical/high, fixable)
make php-scan-all PHP_VERSION=8.4                 # scan toutes les variantes construites pour cette version
make redis-scan REDIS_VERSION=7.4                 # scan Redis
make scan-all                                     # php-scan-all + redis-scan (versions par défaut : PHP 8.4 / Redis 7.4)
```
Sous le capot (`php/Makefile`, `redis/Makefile`) :
```
docker scout cves local://<image>:<tag>                                             # rapport complet
docker scout cves --only-severity critical,high --only-fixed local://<image>:<tag>  # bruit réduit, actionnable
docker scout cves --only-severity critical,high --only-fixed --exit-code local://<image>:<tag>  # pour un usage CI (exit 2 si trouvé)
```
`--only-fixed` est important : il exclut les CVE sans correctif disponible (donc rien à patcher immédiatement), pour se concentrer sur l'actionnable.

## Déclencher la CI manuellement (sans faire de release)

Via l'onglet GitHub Actions → `Build manually` (`manual_build.yml`), ou `gh workflow run manual_build.yml` avec les inputs :
- `image` : `php` ou `redis`
- `variant` (PHP seulement) : `all`, `frankenphp`, `base`, `caddy`, `nginx`, `apache`
- `registry` : `adeliom` (Docker Hub) ou `ghcr.io/agence-adeliom`
- `image_suffix` : `-dev` (pas de push par défaut), `-{{latest_release_tag}}`, ou `-latest`
- `push_image` : `false` pour juste valider le build+test en CI sans publier
- `skip_wkhtmltopdf` : `true` pour aller plus vite si non pertinent

Exemple :
```
gh workflow run manual_build.yml \
  -f image=php \
  -f variant=caddy \
  -f registry=ghcr.io/agence-adeliom \
  -f image_suffix=-dev \
  -f push_image=false
```
Utile pour valider un correctif de CVE en environnement CI propre avant de créer une release GitHub (qui, elle, pousse automatiquement sur les deux registries via `ci_publish_release.yml`).

## Nettoyage local

```
make php-clean       # supprime les images PHP locales
make redis-clean-all # supprime les images Redis locales
make clean-all        # les deux
make images           # liste les images adeliom présentes localement
make status            # liste les conteneurs php_*/redis*
```
