---
name: docker-images-maintenance
description: Use when working in the agence-adeliom/docker-images repo — understanding what it builds, building/testing/scanning images locally, patching a CVE in a PHP/Caddy/FrankenPHP/Redis image, adding a new PHP or Redis version, or doing routine/preventive maintenance. Triggers on "CVE", "scan", "vulnerabilité", "docker scout", "mettre à jour caddy/php/redis/frankenphp", "maintenance des images".
---

# Docker Images (Adeliom) — maintenance

## Ce que fait ce repo

`agence-adeliom/docker-images` construit et publie deux familles d'images Docker utilisées par les projets clients Adeliom, sur Docker Hub (`adeliom/*`) et GHCR (`ghcr.io/agence-adeliom/*`) :

- **PHP** (`php/`) — image PHP multi-variantes : `cli`, `fpm`, `apache`, `nginx`, `caddy`, `frankenphp`, chacune avec un pendant `-wkhtmltopdf`. Versions PHP maintenues : 8.1 → 8.5 (voir `references/versions-matrix.md`, à revérifier dans les Dockerfiles car cette liste évolue).
- **Redis** (`redis/`) — image Redis Alpine avec configs dev/prod, healthcheck. Versions : 6.2, 7.0, 7.2, 7.4, 8.2, 8.4.

Ce n'est **pas une application** : le "produit" livré, ce sont des images Docker publiées sur les registries. Le travail de maintenance consiste presque exclusivement à :
1. corriger des CVE dans les Dockerfiles,
2. suivre les nouvelles versions upstream (PHP, Caddy, FrankenPHP, wkhtmltopdf, Redis, Alpine/Debian, Go),
3. garder la CI (GitHub Actions) et le Makefile cohérents avec les variantes existantes.

Charge `references/architecture.md` pour le détail de l'arborescence, du graphe de dépendances entre Dockerfiles et des conventions de tags.

## Boucle de travail par défaut

1. **Comprendre la variante concernée** — chaque `Dockerfile.<variant>` dans `php/` (et `redis/Dockerfile`) est indépendant mais certains héritent d'une image `${REGISTRY}/php:...` construite par un autre Dockerfile du repo (ex. `caddy` part de `fpm`, `apache`/`nginx` aussi). Voir `references/architecture.md` pour le graphe complet — un patch sur `fpm` doit souvent être répercuté ou vérifié sur ses dépendants.
2. **Patcher** — voir `references/cve-workflow.md` pour la méthode exacte selon le type d'image (Alpine `apk`, Debian `apt-get upgrade`, binaire Go compilé via `xcaddy --replace`, ou bump de version de base image).
3. **Documenter dans le Dockerfile** — chaque contournement de sécurité (force d'une dépendance, upgrade ciblé) est expliqué par un commentaire au-dessus de la ligne, citant la CVE et la raison (voir les commentaires existants dans `php/Dockerfile.caddy` comme modèle). Ne pas patcher silencieusement.
4. **Construire et scanner en local** avant de commit — voir `references/commands.md` pour le cheat-sheet Make/`docker scout`.
5. **Commit** — convention observée dans l'historique : `fix: cve <composant>` ou `fix: <composant>` pour un correctif ciblé, `feat: ...` pour une nouvelle capacité (ex. nouvelle action de scan). Un seul commit peut toucher plusieurs Dockerfiles si le même correctif s'applique à toutes les variantes concernées (ex. `Dockerfile.caddy` + `Dockerfile.caddy-wkhtmltopdf` en même temps).
6. **Ne pas pousser d'images** — le push vers les registries se fait uniquement via CI (release GitHub ou `workflow_dispatch` manuel), jamais en local. Voir `references/architecture.md#ci-cd`.

## Plan de maintenance préventive

Un calendrier détaillé (hebdo/mensuel/trimestriel/annuel) est dans `references/maintenance-calendar.md`. Résumé :
- **Hebdomadaire** : la CI vérifie déjà les nouvelles versions Redis (`check_redis_versions.yml`, lundi 06:00 UTC) et Dependabot tourne quotidiennement sur les GitHub Actions. Compléter par un scan `docker scout` manuel des images les plus utilisées en prod (php cli/fpm/caddy 8.4, redis 7.4).
- **Mensuel** : vérifier les CVE connues sur Caddy, FrankenPHP, wkhtmltopdf et le toolchain Go pinné (`golang:1.26-alpine`), et les `--replace` forcés dans `Dockerfile.caddy*` (les retirer dès qu'upstream les a absorbés).
- **Trimestriel** : revue des versions PHP supportées (ajout d'une nouvelle mineure, dépréciation d'une version EOL), revue des images de base (Alpine/Debian) et des extensions PHP installées.
- **Annuel** : audit complet des Dockerfiles vs bonnes pratiques (multi-stage, non-root, taille d'image), rotation des secrets CI (`DOCKERHUB_USERNAME/PASSWORD`).

## Références

- `references/architecture.md` — arborescence du repo, graphe de dépendances entre variantes, registries, conventions de tags, workflows CI.
- `references/cve-workflow.md` — méthode pas-à-pas pour corriger une CVE selon le type d'image, avec les patchs déjà appliqués comme précédents (historique commit).
- `references/maintenance-calendar.md` — calendrier de maintenance préventive détaillé avec checklist par échéance.
- `references/commands.md` — cheat-sheet Make (build/test/scan) et `docker scout`, et déclenchement manuel de la CI.
- `references/versions-matrix.md` — matrice des versions actuellement supportées (PHP, Redis, Caddy, FrankenPHP, wkhtmltopdf, Go) à tenir à jour à chaque bump.
