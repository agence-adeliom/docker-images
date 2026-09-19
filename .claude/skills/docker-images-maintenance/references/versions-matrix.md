# Matrice de versions actuellement supportées

⚠️ Ce fichier est un instantané — **toujours revérifier dans les fichiers sources cités** avant de s'y fier, il peut se périmer dès le prochain bump.

## PHP

| Variante | Versions dans `build_php.yml` (CI) | Versions dans le `Makefile` racine |
|---|---|---|
| `cli`, `fpm` (job `base`) | 8.2, 8.3, 8.4, 8.5 | 8.1, 8.2, 8.3, 8.4, 8.5 (8.1 en plus, local seulement) |
| `apache` | 8.2, 8.3, 8.4, 8.5 | 8.2, 8.3, 8.4 (pas de cible `php-apache@8.5` hors mode debug) |
| `nginx` | 8.2, 8.3, 8.4, 8.5 | 8.2, 8.3, 8.4 (pas de cible `php-nginx@8.5` hors mode debug) |
| `caddy` | 8.2, 8.3, 8.4, 8.5 | 8.2, 8.3, 8.4, 8.5 |
| `frankenphp` | 8.2, 8.3, 8.4, 8.5 | 8.2, 8.3 seulement (pas de cible `php-frankenphp@8.4`/`8.5` hors mode debug) |
| `*-wkhtmltopdf` | même matrice que le variant de base, sauf si `skip_wkhtmltopdf: true` | — |
| Toutes variantes, mode debug | — | cibles `php-<variant>@8.5-debug` disponibles pour apache/nginx/caddy/frankenphp même quand la cible normale 8.5 n'existe pas |

⚠️ **Incohérence connue** : le `Makefile` racine n'expose pas de cible directe pour builder `apache`/`nginx`/`frankenphp` en 8.5 (ou `frankenphp` en 8.4) alors que la CI les construit et les publie bien. Pour builder ces combinaisons en local il faut passer par `cd php && make <variant>@<version>` (le `php/Makefile` sous-jacent, lui, n'a pas cette limite) plutôt que par les raccourcis `php-<variant>@<version>` du Makefile racine. À harmoniser lors d'une revue trimestrielle plutôt que de supposer que les deux Makefiles et la CI sont synchronisés.

Sources de vérité : `.github/workflows/build_php.yml` (matrices `matrix.version`) pour ce qui est réellement publié ; `Makefile` et `php/Makefile` pour ce qui est buildable en local.

## Redis

Versions : 6.2, 7.0, 7.2, 7.4, 8.2, 8.4 (cibles `redis@X.Y` dans le `Makefile` racine et `redis/Makefile`). Détection de nouvelles versions mineures automatisée par `.github/scripts/update_redis_versions.py` (cron `check_redis_versions.yml`).

## Composants embarqués dans les images PHP

| Composant | Où | Version au 2026-09-19 |
|---|---|---|
| Caddy | `php/Dockerfile.caddy`, `php/Dockerfile.caddy-wkhtmltopdf` (`ARG CADDY_VERSION`) | 2.11.4 |
| Go (toolchain de build de Caddy) | même fichiers, stage `caddy-builder` (`FROM golang:1.26-alpine`) | 1.26 (tag Alpine, patch géré par Docker Hub) |
| `golang.org/x/crypto` (forcé via `--replace` xcaddy) | idem | v0.56.0 |
| `google.golang.org/grpc` (forcé via `--replace` xcaddy) | idem | v1.83.2 (bumpé le 2026-09-19 pour CVE-2026-84445, remplace v1.83.1 lui-même vulnérable) |
| FrankenPHP | `php/Dockerfile.frankenphp` (`FROM dunglas/frankenphp:php${PHP_VERSION}`) | suit le tag officiel `dunglas/frankenphp`, pas de version pinnée séparément dans ce repo |
| wkhtmltopdf (variante FrankenPHP) | `php/Dockerfile.frankenphp-wkhtmltopdf` (`ARG WKHTMLTOX_VERSION`) | 0.12.6.1-3 |
| wkhtmltopdf (variantes Alpine `*-wkhtmltopdf`) | `php/Dockerfile.fpm-wkhtmltopdf`, `cli-wkhtmltopdf` | voir le `Dockerfile` correspondant, paquet installé via gestionnaire Alpine — vérifier au moment du besoin |

Les `--replace` xcaddy sont une dette volontaire et temporaire (voir `cve-workflow.md` section 5) : dès que Caddy publie une version dont le `go.mod` intègre nativement ces versions de dépendances, les retirer plutôt que de les laisser trainer indéfiniment.
