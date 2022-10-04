# Adeliom PHP
![Docker Pulls](https://img.shields.io/docker/pulls/adeliom/php)

This repository contains a set of developer-friendly, general purpose PHP images for Docker.

* You can also modify the php.ini settings using environment variables.
* 2 runtime variants available: cli, fpm
* 3 server variants available: apache, nginx and caddy
* A variant with wkhtmltopdf
* Images come with Composer
* All server variants can be installed with or without NodeJS (if you need to build your static assets).

## Images

| Name | PHP version | NodeJS version | variant | server | wkhtmltopdf |
|------|-------------|----------------|---------|--------|:-------------:|
|`adeliom/php:7.4-cli`|`7.4`||`cli`|||
|`adeliom/php:8.0-cli`|`8.0`||`cli`|||
|`adeliom/php:8.1-cli`|`8.1`||`cli`|||
|`adeliom/php:7.4-cli-wkhtmltopdf`|`7.4`||`cli`||✅|
|`adeliom/php:8.0-cli-wkhtmltopdf`|`8.0`||`cli`||✅|
|`adeliom/php:8.1-cli-wkhtmltopdf`|`8.1`||`cli`||✅|
|`adeliom/php:7.4-fpm`|`7.4`||`fpm`|||
|`adeliom/php:8.0-fpm`|`8.0`||`fpm`|||
|`adeliom/php:8.1-fpm`|`8.1`||`fpm`|||
|`adeliom/php:7.4-fpm-wkhtmltopdf`|`7.4`||`fpm`||✅|
|`adeliom/php:8.0-fpm-wkhtmltopdf`|`8.0`||`fpm`||✅|
|`adeliom/php:8.1-fpm-wkhtmltopdf`|`8.1`||`fpm`||✅|
|`adeliom/php:7.4-apache`|`7.4`||`fpm`|`apache`||
|`adeliom/php:8.0-apache`|`8.0`||`fpm`|`apache`||
|`adeliom/php:8.1-apache`|`8.1`||`fpm`|`apache`||
|`adeliom/php:7.4-apache-node14`|`7.4`|`14`|`fpm`|`apache`||
|`adeliom/php:8.0-apache-node14`|`8.0`|`14`|`fpm`|`apache`||
|`adeliom/php:8.1-apache-node14`|`8.1`|`14`|`fpm`|`apache`||
|`adeliom/php:7.4-apache-node16`|`7.4`|`16`|`fpm`|`apache`||
|`adeliom/php:8.0-apache-node16`|`8.0`|`16`|`fpm`|`apache`||
|`adeliom/php:8.1-apache-node16`|`8.1`|`16`|`fpm`|`apache`||
|`adeliom/php:7.4-apache-node18`|`7.4`|`18`|`fpm`|`apache`||
|`adeliom/php:8.0-apache-node18`|`8.0`|`18`|`fpm`|`apache`||
|`adeliom/php:8.1-apache-node18`|`8.1`|`18`|`fpm`|`apache`||
|`adeliom/php:7.4-apache-wkhtmltopdf`|`7.4`||`fpm`|`apache`|✅|
|`adeliom/php:7.4-apache-wkhtmltopdf-node14`|`7.4`|`14`|`fpm`|`apache`|✅|
|`adeliom/php:8.0-apache-wkhtmltopdf-node14`|`8.0`|`14`|`fpm`|`apache`|✅|
|`adeliom/php:8.1-apache-wkhtmltopdf-node14`|`8.1`|`14`|`fpm`|`apache`|✅|
|`adeliom/php:7.4-apache-wkhtmltopdf-node16`|`7.4`|`16`|`fpm`|`apache`|✅|
|`adeliom/php:8.0-apache-wkhtmltopdf-node16`|`8.0`|`16`|`fpm`|`apache`|✅|
|`adeliom/php:8.1-apache-wkhtmltopdf-node16`|`8.1`|`16`|`fpm`|`apache`|✅|
|`adeliom/php:7.4-apache-wkhtmltopdf-node18`|`7.4`|`18`|`fpm`|`apache`|✅|
|`adeliom/php:8.0-apache-wkhtmltopdf-node18`|`8.0`|`18`|`fpm`|`apache`|✅|
|`adeliom/php:8.1-apache-wkhtmltopdf-node18`|`8.1`|`18`|`fpm`|`apache`|✅|
|`adeliom/php:7.4-nginx`|`7.4`||`fpm`|`nginx`||
|`adeliom/php:8.0-nginx`|`8.0`||`fpm`|`nginx`||
|`adeliom/php:8.1-nginx`|`8.1`||`fpm`|`nginx`||
|`adeliom/php:7.4-nginx-node14`|`7.4`|`14`|`fpm`|`nginx`||
|`adeliom/php:8.0-nginx-node14`|`8.0`|`14`|`fpm`|`nginx`||
|`adeliom/php:8.1-nginx-node14`|`8.1`|`14`|`fpm`|`nginx`||
|`adeliom/php:7.4-nginx-node16`|`7.4`|`16`|`fpm`|`nginx`||
|`adeliom/php:8.0-nginx-node16`|`8.0`|`16`|`fpm`|`nginx`||
|`adeliom/php:8.1-nginx-node16`|`8.1`|`16`|`fpm`|`nginx`||
|`adeliom/php:7.4-nginx-node18`|`7.4`|`18`|`fpm`|`nginx`||
|`adeliom/php:8.0-nginx-node18`|`8.0`|`18`|`fpm`|`nginx`||
|`adeliom/php:8.1-nginx-node18`|`8.1`|`18`|`fpm`|`nginx`||
|`adeliom/php:7.4-nginx-wkhtmltopdf`|`7.4`||`fpm`|`nginx`|✅|
|`adeliom/php:8.0-nginx-wkhtmltopdf`|`8.0`||`fpm`|`nginx`|✅|
|`adeliom/php:8.1-nginx-wkhtmltopdf`|`8.1`||`fpm`|`nginx`|✅|
|`adeliom/php:7.4-nginx-wkhtmltopdf-node14`|`7.4`|`14`|`fpm`|`nginx`|✅|
|`adeliom/php:8.0-nginx-wkhtmltopdf-node14`|`8.0`|`14`|`fpm`|`nginx`|✅|
|`adeliom/php:8.1-nginx-wkhtmltopdf-node14`|`8.1`|`14`|`fpm`|`nginx`|✅|
|`adeliom/php:7.4-nginx-wkhtmltopdf-node16`|`7.4`|`16`|`fpm`|`nginx`|✅|
|`adeliom/php:8.0-nginx-wkhtmltopdf-node16`|`8.0`|`16`|`fpm`|`nginx`|✅|
|`adeliom/php:8.1-nginx-wkhtmltopdf-node16`|`8.1`|`16`|`fpm`|`nginx`|✅|
|`adeliom/php:7.4-nginx-wkhtmltopdf-node18`|`7.4`|`18`|`fpm`|`nginx`|✅|
|`adeliom/php:8.0-nginx-wkhtmltopdf-node18`|`8.0`|`18`|`fpm`|`nginx`|✅|
|`adeliom/php:8.1-nginx-wkhtmltopdf-node18`|`8.1`|`18`|`fpm`|`nginx`|✅|
|`adeliom/php:7.4-caddy`|`7.4`||`fpm`|`caddy`||
|`adeliom/php:8.0-caddy`|`8.0`||`fpm`|`caddy`||
|`adeliom/php:8.1-caddy`|`8.1`||`fpm`|`caddy`||
|`adeliom/php:7.4-caddy-node14`|`7.4`|`14`|`fpm`|`caddy`||
|`adeliom/php:8.0-caddy-node14`|`8.0`|`14`|`fpm`|`caddy`||
|`adeliom/php:8.1-caddy-node14`|`8.1`|`14`|`fpm`|`caddy`||
|`adeliom/php:7.4-caddy-node16`|`7.4`|`16`|`fpm`|`caddy`||
|`adeliom/php:8.0-caddy-node16`|`8.0`|`16`|`fpm`|`caddy`||
|`adeliom/php:8.1-caddy-node16`|`8.1`|`16`|`fpm`|`caddy`||
|`adeliom/php:7.4-caddy-node18`|`7.4`|`18`|`fpm`|`caddy`||
|`adeliom/php:8.0-caddy-node18`|`8.0`|`18`|`fpm`|`caddy`||
|`adeliom/php:8.1-caddy-node18`|`8.1`|`18`|`fpm`|`caddy`||
|`adeliom/php:7.4-caddy-wkhtmltopdf`|`7.4`||`fpm`|`caddy`|✅|
|`adeliom/php:8.0-caddy-wkhtmltopdf`|`8.0`||`fpm`|`caddy`|✅|
|`adeliom/php:8.1-caddy-wkhtmltopdf`|`8.1`||`fpm`|`caddy`|✅|
|`adeliom/php:7.4-caddy-wkhtmltopdf-node14`|`7.4`|`14`|`fpm`|`caddy`|✅|
|`adeliom/php:8.0-caddy-wkhtmltopdf-node14`|`8.0`|`14`|`fpm`|`caddy`|✅|
|`adeliom/php:8.1-caddy-wkhtmltopdf-node14`|`8.1`|`14`|`fpm`|`caddy`|✅|
|`adeliom/php:7.4-caddy-wkhtmltopdf-node16`|`7.4`|`16`|`fpm`|`caddy`|✅|
|`adeliom/php:8.0-caddy-wkhtmltopdf-node16`|`8.0`|`16`|`fpm`|`caddy`|✅|
|`adeliom/php:8.1-caddy-wkhtmltopdf-node16`|`8.1`|`16`|`fpm`|`caddy`|✅|
|`adeliom/php:7.4-caddy-wkhtmltopdf-node18`|`7.4`|`18`|`fpm`|`caddy`|✅|
|`adeliom/php:8.0-caddy-wkhtmltopdf-node18`|`8.0`|`18`|`fpm`|`caddy`|✅|
|`adeliom/php:8.1-caddy-wkhtmltopdf-node18`|`8.1`|`18`|`fpm`|`caddy`|✅|


## Usage

These images are based on the [official PHP image](https://hub.docker.com/_/php/).

Example with CLI:

```bash
$ docker run -it --rm --name my-running-script -v "$PWD":/var/www/html adeliom/php:8.1-cli php your-script.php
```

Example with Apache:

```bash
$ docker run -p 80:80 --rm --name my-apache-php-app -v "$PWD":/var/www/html adeliom/php:8.1-apache
```

Example with PHP-FPM:

```bash
$ docker run -p 9000:9000 --rm --name my-php-fpm -v "$PWD":/var/www/html adeliom/php:8.1-fpm
```

Example with Apache + Node 16.x in a Dockerfile:

**Dockerfile**
```Dockerfile
FROM adeliom/php:8.1-apache-node16

COPY src/ /var/www/html/
RUN composer install
RUN npm install
RUN npm run build
```


## Default working directory

The working directory (the directory in which you should mount/copy your application) depends on the image variant
you are using:

| Variant | Working directory |
|---------|-------------------|
| cli     | `/var/www/html`   |
| fpm     | `/var/www/html`   |
| apache  | `/var/www/html`   |
| nginx   | `/var/www/html`   |
| caddy   | `/var/www/html`   |


## Changing server document root

For all server variants, you can change the document root (i.e. your "public" directory) by using the 
`DOCUMENT_ROOT` variable:

```bash
# The root of your website is in the "public" directory:
DOCUMENT_ROOT=/var/www/html/public/
```

## Setting parameters in php.ini

| PHP.ini variable |Environement variable name| Default value |
|----|----|----|
| `memory_limit` | PHP_INI_MEMORY_LIMIT | `128M` (fpm) `-1` (cli) |
| `date.timezone` | PHP_INI_DATE_TIMEZONE | `UTC` |
| `cgi.fix_pathinfo` | PHP_INI_CGI_FIX_PATHINFO | `1` |
| `upload_max_filesize` | PHP_INI_UPLOAD_MAX_FILESIZE | `16M` |
| `post_max_size` | PHP_INI_POST_MAX_SIZE | `16M` |
| `error_reporting` | PHP_INI_ERROR_REPORTING | `E_ALL & ~E_DEPRECATED & ~E_STRICT` |
| `display_errors` | PHP_INI_DISPLAY_ERRORS | `Off` |
| `display_startup_errors` | PHP_INI_DISPLAY_STARTUP_ERRORS | `Off` |
| `realpath_cache_size` | PHP_INI_REALPATH_CACHE_SIZE | `4096k` |
| `realpath_cache_ttl` | PHP_INI_REALPATH_CACHE_TTL | `120` |
| `opcache.memory_consumption` | PHP_INI_OPCACHE_MEMORY_CONSUMPTION | `128` |
| `opcache.interned_strings_buffer` | PHP_INI_OPCACHE_INTERNED_STRINGS_BUFFER | `8` |
| `opcache.max_accelerated_files` | PHP_INI_OPCACHE_MAX_ACCELERATED_FILES | `4000` |
| `opcache.revalidate_freq` | PHP_INI_OPCACHE_REVALIDATE_FREQ | `60` |
| `opcache.fast_shutdown` | PHP_INI_OPCACHE_FAST_SHUTDOWN | `1` |
| `opcache.enable_cli` | PHP_INI_OPCACHE_ENABLE_CLI | `1` |
| `opcache.enable` | PHP_INI_OPCACHE_ENABLE | `1`
| `soap.wsdl_cache_enabled` | PHP_INI_SOAP_WSDL_CACHE_ENABLED | `1` |
| `max_execution_time` | PHP_INI_MAX_EXECUTION_TIME | `30` |
| `max_input_time` | PHP_INI_MAX_INPUT_TIME | `60` |
| `sendmail_path` | PHP_INI_SENDMAIL_PATH | `sendmail -t -i` |

## Debugging

To enable XDebug` `you simply have to set the environment variable:

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
FROM adeliom/php:8.1-apache

# Install tidy extension
RUN install-php-extensions tidy
```

-----
Made with ❤️ by [@agence-adeliom](https://github.com/agence-adeliom)