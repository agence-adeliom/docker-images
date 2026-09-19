# Calendrier de maintenance préventive

Objectif : éviter que les images dérivent en silence (CVE non patchées, versions upstream obsolètes, `--replace` de contournement oubliés). Ce calendrier est une proposition de discipline, à ajuster avec l'équipe — rien ici n'est automatisé sauf mention contraire.

## Hebdomadaire (déjà partiellement automatisé)

- ✅ **Automatique** — `check_redis_versions.yml` (lundi 06:00 UTC) ouvre une PR si une nouvelle version mineure Redis apparaît sur Docker Hub.
- ✅ **Automatique** — Dependabot bump quotidien des GitHub Actions utilisées dans les workflows.
- 🔲 **Manuel** — scanner les images les plus utilisées en prod avec `docker scout` :
  ```
  make php-scan-all PHP_VERSION=8.4
  make redis-scan REDIS_VERSION=7.4
  ```
  Objectif : détecter une CVE critique/haute fixable avant qu'un client ou un audit ne la remonte. Si `docker scout` remonte du nouveau, traiter avec `references/cve-workflow.md`.

## Mensuel

- 🔲 Consulter les security advisories des composants "maison" (build custom depuis les sources) :
  - Caddy : https://github.com/caddyserver/caddy/security/advisories
  - FrankenPHP : https://github.com/dunglas/frankenphp/security/advisories (ou releases)
  - Go (toolchain de build `golang:1.26-alpine`) : https://go.dev/doc/devel/release#policy (les patchs de sécu Go sortent souvent en dehors du cycle normal)
- 🔲 Vérifier si les `--replace` forcés dans `php/Dockerfile.caddy` et `php/Dockerfile.caddy-wkhtmltopdf` (actuellement `golang.org/x/crypto` et `google.golang.org/grpc`) sont encore nécessaires : comparer avec le `go.mod` de la version Caddy pinnée (`ARG CADDY_VERSION`). Si Caddy a absorbé le bump, retirer le `--replace` correspondant (moins de dette, moins de risque qu'un `--replace` gelé devienne lui-même la prochaine CVE — cf. CVE-2026-84445).
- 🔲 Vérifier la version `wkhtmltopdf` (`ARG WKHTMLTOX_VERSION` dans `Dockerfile.frankenphp-wkhtmltopdf`, et le binaire installé dans les Dockerfiles `*-wkhtmltopdf` basés sur Alpine) — projet peu maintenu upstream, donc surveiller surtout les CVE de ses dépendances système (Qt/WebKit) plutôt qu'un nouveau tag.

## Trimestriel

- 🔲 Revue de la matrice de versions PHP supportées (voir `versions-matrix.md`) :
  - Une nouvelle version mineure PHP est-elle sortie et doit être ajoutée (Dockerfiles + matrices `build_php.yml` + cibles `Makefile` racine et `php/Makefile`) ?
  - Une version PHP est-elle proche de l'EOL (https://www.php.net/supported-versions.php) et doit être annoncée en dépréciation aux clients avant retrait ?
- 🔲 Revue des images de base : les tags `-alpine`/`-fpm-alpine`/`-cli-alpine` suivent-ils toujours une version d'Alpine maintenue (pas EOL) ? Idem pour la base Debian de `dunglas/frankenphp`.
- 🔲 Revue des extensions PHP installées (`install-php-extensions ...` dans `Dockerfile.frankenphp`, équivalent pour les autres variantes) : toujours nécessaires, pas de nouvelle extension à ajouter suite à une demande client récurrente ?
- 🔲 Vérifier `.github/workflows/*` : les versions d'actions (`actions/checkout@v4`, `docker/build-push-action@v6`, etc.) sont-elles à jour indépendamment de Dependabot (parfois Dependabot ne couvre pas tout) ?

## Semestriel / Annuel

- 🔲 Audit complet des Dockerfiles vs bonnes pratiques : multi-stage bien utilisé partout, pas de secret en dur, utilisateur non-root quand c'est possible (`Dockerfile.frankenphp` le fait déjà via `useradd`+`setcap`), taille d'image (`docker images` + `dive` si besoin).
- 🔲 Rotation des secrets CI (`DOCKERHUB_USERNAME`/`DOCKERHUB_PASSWORD`, `GITHUB_TOKEN` est géré par GitHub) — vérifier qu'ils ne sont pas partagés avec d'autres repos au-delà du nécessaire.
- 🔲 Relire `SECURITY.md` et `CONTRIBUTING.md` pour vérifier qu'ils reflètent toujours le process réel (ex. comment un rapport de CVE externe doit être traité).
- 🔲 Envisager d'ajouter un job CI de scan automatisé (`docker scout` ou Trivy/Grype) si ce n'est toujours pas fait — actuellement 100% manuel (voir `architecture.md`, section CI/CD).

## Déclencheurs événementiels (pas calendaires, mais à ne pas oublier)

- Une CVE nommée est communiquée par un client/audit/veille → traiter immédiatement via `references/cve-workflow.md`, indépendamment du calendrier.
- Une nouvelle version majeure/mineure de PHP, Caddy, FrankenPHP ou Redis sort → évaluer l'ajout à la matrice dans le mois qui suit (pas besoin d'attendre la revue trimestrielle si la demande client existe déjà).
- Un `docker scout` en CI (`manual_build.yml` déclenché manuellement) ou en local remonte une CVE critique fixable → traiter avant toute prochaine release.
