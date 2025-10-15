# Adeliom PHP

![Docker Pulls](https://img.shields.io/docker/pulls/adeliom/php)

This repository contains a set of developer-friendly, general purpose PHP images for Docker.

- You can also modify the php.ini settings using environment variables.
- 2 runtime variants available: cli, fpm
- 4 server variants available: apache, nginx, caddy and frankenphp
- A variant with wkhtmltopdf
- Images come with Composer

## ⚠️ Important

This project is maintained by ❤️ by [@agence-adeliom](https://github.com/agence-adeliom). And images are used for our projects and clients.
This work is open-source and publicly available, but we do not provide any guarantee or official support.
Use at your own risk and always test thoroughly before deploying to production.

## Latest Images

| Name                                     | PHP version | variant | server       | wkhtmltopdf |
|------------------------------------------| ----------- | ------- | ------------ | :---------: |
| `adeliom/php:8.1-cli`                    | `8.1`       | `cli`   |              |             |
| `adeliom/php:8.2-cli`                    | `8.2`       | `cli`   |              |             |
| `adeliom/php:8.3-cli`                    | `8.3`       | `cli`   |              |             |
| `adeliom/php:8.4-cli`                    | `8.4`       | `cli`   |              |             |
| `adeliom/php:8.1-cli-wkhtmltopdf`        | `8.1`       | `cli`   |              |     ✅      |
| `adeliom/php:8.2-cli-wkhtmltopdf`        | `8.2`       | `cli`   |              |     ✅      |
| `adeliom/php:8.3-cli-wkhtmltopdf`        | `8.3`       | `cli`   |              |     ✅      |
| `adeliom/php:8.4-cli-wkhtmltopdf`        | `8.4`       | `cli`   |              |     ✅      |
| `adeliom/php:8.1-fpm`                    | `8.1`       | `fpm`   |              |             |
| `adeliom/php:8.2-fpm`                    | `8.2`       | `fpm`   |              |             |
| `adeliom/php:8.3-fpm`                    | `8.3`       | `fpm`   |              |             |
| `adeliom/php:8.4-fpm`                    | `8.4`       | `fpm`   |              |             |
| `adeliom/php:8.1-fpm-wkhtmltopdf`        | `8.1`       | `fpm`   |              |     ✅      |
| `adeliom/php:8.2-fpm-wkhtmltopdf`        | `8.2`       | `fpm`   |              |     ✅      |
| `adeliom/php:8.3-fpm-wkhtmltopdf`        | `8.3`       | `fpm`   |              |     ✅      |
| `adeliom/php:8.4-fpm-wkhtmltopdf`        | `8.4`       | `fpm`   |              |     ✅      |
| `adeliom/php:8.1-apache`                 | `8.1`       | `fpm`   | `apache`     |             |
| `adeliom/php:8.2-apache`                 | `8.2`       | `fpm`   | `apache`     |             |
| `adeliom/php:8.3-apache`                 | `8.3`       | `fpm`   | `apache`     |             |
| `adeliom/php:8.4-apache`                 | `8.4`       | `fpm`   | `apache`     |             |
| `adeliom/php:8.1-apache-wkhtmltopdf`     | `8.1`       | `fpm`   | `apache`     |     ✅      |
| `adeliom/php:8.2-apache-wkhtmltopdf`     | `8.2`       | `fpm`   | `apache`     |     ✅      |
| `adeliom/php:8.3-apache-wkhtmltopdf`     | `8.3`       | `fpm`   | `apache`     |     ✅      |
| `adeliom/php:8.4-apache-wkhtmltopdf`     | `8.4`       | `fpm`   | `apache`     |     ✅      |
| `adeliom/php:8.1-nginx`                  | `8.1`       | `fpm`   | `nginx`      |             |
| `adeliom/php:8.2-nginx`                  | `8.2`       | `fpm`   | `nginx`      |             |
| `adeliom/php:8.3-nginx`                  | `8.3`       | `fpm`   | `nginx`      |             |
| `adeliom/php:8.4-nginx`                  | `8.4`       | `fpm`   | `nginx`      |             |
| `adeliom/php:8.1-nginx-wkhtmltopdf`      | `8.1`       | `fpm`   | `nginx`      |     ✅      |
| `adeliom/php:8.2-nginx-wkhtmltopdf`      | `8.2`       | `fpm`   | `nginx`      |     ✅      |
| `adeliom/php:8.3-nginx-wkhtmltopdf`      | `8.3`       | `fpm`   | `nginx`      |     ✅      |
| `adeliom/php:8.4-nginx-wkhtmltopdf`      | `8.4`       | `fpm`   | `nginx`      |     ✅      |
| `adeliom/php:8.1-caddy`                  | `8.1`       | `fpm`   | `caddy`      |             |
| `adeliom/php:8.2-caddy`                  | `8.2`       | `fpm`   | `caddy`      |             |
| `adeliom/php:8.3-caddy`                  | `8.3`       | `fpm`   | `caddy`      |             |
| `adeliom/php:8.4-caddy`                  | `8.4`       | `fpm`   | `caddy`      |             |
| `adeliom/php:8.1-caddy-wkhtmltopdf`      | `8.1`       | `fpm`   | `caddy`      |     ✅      |
| `adeliom/php:8.2-caddy-wkhtmltopdf`      | `8.2`       | `fpm`   | `caddy`      |     ✅      |
| `adeliom/php:8.3-caddy-wkhtmltopdf`      | `8.3`       | `fpm`   | `caddy`      |     ✅      |
| `adeliom/php:8.4-caddy-wkhtmltopdf`      | `8.4`       | `fpm`   | `caddy`      |     ✅      |
| `adeliom/php:8.2-frankenphp`             | `8.2`       | `php`   | `frankenphp` |             |
| `adeliom/php:8.3-frankenphp`             | `8.3`       | `php`   | `frankenphp` |             |
| `adeliom/php:8.2-frankenphp-wkhtmltopdf` | `8.2`       | `php`   | `frankenphp` |     ✅      |
| `adeliom/php:8.3-frankenphp-wkhtmltopdf` | `8.3`       | `php`   | `frankenphp` |     ✅      |


## Specific Images versions

Using latest tags is a good way to stay up to date, but sometimes you need more control over the version you are using :

All detailed images are the latest stable versions.
You can also use specific versions by adding a `-{specific-version}` part in the image name by one of the following:
Example: `adeliom/php:8.4-caddy-dev` or `adeliom/php:8.4-caddy-1.0.0`

- On every release, the image tag is moved to the new version.
- On every release a new tag is created with the version number (e.g. `1.0.0`, `1.0.1`, etc.). [See releases list](https://github.com/agence-adeliom/docker-images/releases)
- Before a new release, the `dev` tag is used for the new version. Do not use this tag in production.

To stay up to date, you can use the `default` tag, which is always pointing to the latest stable version.
[build_php.yml](../.github/workflows/build_php.yml)
And if you have some trouble with the latest stable version, you can use a `adeliom/php:8.4-caddy-{specific-version}` tag, which is always pointing to the previous released version. [See releases list](https://github.com/agence-adeliom/docker-images/releases)

## Usage

These images are based on the [official PHP image](https://hub.docker.com/_/php/).

Example with CLI:

```bash
$ docker run -it --rm --name my-running-script -v "$PWD":/var/www/html adeliom/php:8.2-cli-latest php your-script.php
```

Example with Apache:

```bash
$ docker run -p 80:80 --rm --name my-apache-php-app -v "$PWD":/var/www/html adeliom/php:8.2-apache-latest
```

Example with PHP-FPM:

```bash
$ docker run -p 9000:9000 --rm --name my-php-fpm -v "$PWD":/var/www/html adeliom/php:8.2-fpm-latest
```

## Default working directory

The working directory (the directory in which you should mount/copy your application) depends on the image variant
you are using:

| Variant    | Working directory |
| ---------- | ----------------- |
| cli        | `/var/www/html`   |
| fpm        | `/var/www/html`   |
| apache     | `/var/www/html`   |
| nginx      | `/var/www/html`   |
| caddy      | `/var/www/html`   |
| frankenphp | `/var/www/html`   |

## Changing server document root

For all server variants, you can change the document root (i.e. your "public" directory) by using the
`DOCUMENT_ROOT` variable:

```bash
# The root of your website is in the "public" directory:
DOCUMENT_ROOT=/var/www/html/public/
```

## Setting parameters in php.ini

| PHP.ini variable                  | Environement variable name              | Default value                       |
| --------------------------------- | --------------------------------------- | ----------------------------------- |
| `memory_limit`                    | PHP_INI_MEMORY_LIMIT                    | `128M` (fpm) `-1` (cli)             |
| `date.timezone`                   | PHP_INI_DATE_TIMEZONE                   | `UTC`                               |
| `cgi.fix_pathinfo`                | PHP_INI_CGI_FIX_PATHINFO                | `1`                                 |
| `upload_max_filesize`             | PHP_INI_UPLOAD_MAX_FILESIZE             | `16M`                               |
| `post_max_size`                   | PHP_INI_POST_MAX_SIZE                   | `16M`                               |
| `error_reporting`                 | PHP_INI_ERROR_REPORTING                 | `E_ALL & ~E_DEPRECATED & ~E_STRICT` |
| `display_errors`                  | PHP_INI_DISPLAY_ERRORS                  | `Off`                               |
| `display_startup_errors`          | PHP_INI_DISPLAY_STARTUP_ERRORS          | `Off`                               |
| `realpath_cache_size`             | PHP_INI_REALPATH_CACHE_SIZE             | `4096k`                             |
| `realpath_cache_ttl`              | PHP_INI_REALPATH_CACHE_TTL              | `120`                               |
| `opcache.memory_consumption`      | PHP_INI_OPCACHE_MEMORY_CONSUMPTION      | `128`                               |
| `opcache.interned_strings_buffer` | PHP_INI_OPCACHE_INTERNED_STRINGS_BUFFER | `8`                                 |
| `opcache.max_accelerated_files`   | PHP_INI_OPCACHE_MAX_ACCELERATED_FILES   | `4000`                              |
| `opcache.revalidate_freq`         | PHP_INI_OPCACHE_REVALIDATE_FREQ         | `60`                                |
| `opcache.validate_timestamps`     | PHP_INI_OPCACHE_VALIDATE_TIMESTAMPS     | `1`                                 |
| `opcache.fast_shutdown`           | PHP_INI_OPCACHE_FAST_SHUTDOWN           | `1`                                 |
| `opcache.enable_cli`              | PHP_INI_OPCACHE_ENABLE_CLI              | `1`                                 |
| `opcache.enable`                  | PHP_INI_OPCACHE_ENABLE                  | `1`                                 |
| `opcache.preload`                 | PHP_INI_OPCACHE_PRELOAD                 | ``                                  |
| `opcache.preload_user`            | PHP_INI_OPCACHE_PRELOAD_USER            | ``                                  |
| `soap.wsdl_cache_enabled`         | PHP_INI_SOAP_WSDL_CACHE_ENABLED         | `1`                                 |
| `max_execution_time`              | PHP_INI_MAX_EXECUTION_TIME              | `30`                                |
| `max_input_time`                  | PHP_INI_MAX_INPUT_TIME                  | `60`                                |
| `sendmail_path`                   | PHP_INI_SENDMAIL_PATH                   | `sendmail -t -i`                    |

## Debugging

To enable XDebug you simply have to set the environment variable:

```bash
XDEBUG_MODE='debug'
XDEBUG_CONFIG='client_host=host.docker.internal discover_client_host=1 log=/tmp/xdebug.log remote_enable=true remote_host=host.docker.internal'
```

You can setup your own xdebug config by following the documentation of [Xdebug](https://xdebug.org/docs/all_settings)

## Extensions available

These extensions are enabled by default in images : `amqp` `ctype` `curl` `date` `dom` `exif` `fileinfo` `filter` `ftp` `gd` `gettext` `hash` `iconv` `imagick` `intl` `json` `ldap` `libxml` `mbstring` `mongodb` `mysqli` `mysqlnd` `openssl` `pcre` `PDO` `pdo_mysql` `pdo_pgsql` `pdo_sqlite` `pgsql` `Phar` `posix` `readline` `redis` `Reflection` `session` `SimpleXML` `soap` `sodium` `SPL` `sqlite3` `standard` `swoole` `sysvsem` `tokenizer` `xdebug` `xml` `xmlreader` `xmlwriter` `opcache` `zip` `zlib`

This list can be outdated, you can verify by executing : `docker run --rm -it  adeliom/php:8.1-cli php -m`

### Compiling extensions in the custom image with [mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer)

```Dockerfile
FROM ${REGISTRY}/php:8.1-apache

# Install tidy extension
RUN install-php-extensions tidy
```

---

Made with ❤️ by [@agence-adeliom](https://github.com/agence-adeliom)
