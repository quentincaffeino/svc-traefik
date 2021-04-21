# Traefik Service

This is a traefik service setup with docker-compose.

```
Traefik is an open-source Edge Router that makes publishing your services a fun and easy experience. It receives requests on behalf of your system and finds out which components are responsible for handling them.
```

[Web](https://doc.traefik.io/traefik/)

---

## Table of contents

- [Traefik Service](#traefik-service)
	- [Table of contents](#table-of-contents)
	- [Variables](#variables)
- [Base repo for docker based services with make <small>[extends svc-base-docker]</small>](#base-repo-for-docker-based-services-with-make-smallextends-svc-base-dockersmall)
	- [Variables <small>[extends svc-base-docker]</small>](#variables-smallextends-svc-base-dockersmall)
	- [Usage <small>[extends svc-base-docker]</small>](#usage-smallextends-svc-base-dockersmall)
		- [Compose options <small>[extends svc-base-docker]</small>](#compose-options-smallextends-svc-base-dockersmall)
		- [Extra commands <small>[extends svc-base-docker]</small>](#extra-commands-smallextends-svc-base-dockersmall)
- [Base repo for services with make <small>[extends svc-base-make]</small>](#base-repo-for-services-with-make-smallextends-svc-base-makesmall)
	- [Usage <small>[extends svc-base-make]</small>](#usage-smallextends-svc-base-makesmall)
	- [dotenv <small>[extends svc-base-make]</small>](#dotenv-smallextends-svc-base-makesmall)
		- [Overrides <small>[extends svc-base-make]</small>](#overrides-smallextends-svc-base-makesmall)

- [Base repo for docker based services with make](#extends-base-repo-for-docker-based-services-with-make)
	- [Variables](#variables-docker)
	- [Usage](#usage-docker)

- [Base repo for services with make](#extends-base-repo-for-services-with-make)
	- [Usage](#make-usage)
	- [dotenv](#make-dotenv)
		- [Overrides](#make-overrides)

## Variables

- `BASE_DOMAIN` - The base domain on which this service would run. For example traefik dashboard could be acessed on `http://BASE_DOMAIN.localhost/dashboard/` (By default: http://traefik.localhost/dashboard/). This does not set base domain for services that use traefik.
- `HTTP_PORT` & `HTTPS_PORT` - Ports that traefik would listen to
- `ACME_EMAIL` - You **MUST** set it in production. This email will be used to register your letsencrypt certificates for services that would run under this traefik service.

# Base repo for docker based services with make <small>[extends svc-base-docker]</small>

This setup makes use of `docker-compose` ability to combine multiple configurations by reading several input files via defining multiple `-f` attributes and also combines it with environment-based make to make use easier with multi-environment setups with dynamic variables and env-based `docker-compose` configs

## Variables <small>[extends svc-base-docker]</small>

- `PROJECT_NAME` - Project name
- `DOCKER_COMPOSE_FILES` - Instructs make which docker-compose files use for which environment

## Usage <small>[extends svc-base-docker]</small>

Every `docker-compose` comand is wrapped with `make`. Example usage:

```sh
[VARIABLES] make docker-[COMMAND-NAME] [VARIABLES]
# Eg.:
make docker-up
ENV=prod make docker-config
make docker-build s="service-name"
```

Where `COMMAND-NAME` is a docker-compose command name (eg.: up, down, config, ...)

### Compose options <small>[extends svc-base-docker]</small>

There are times when you need to pass extra variables to `docker-compose` command. Most of them accept some sort of options flags/attributes. Those could be passed using `o` (options) variable like so:

```sh
make docker-up o="-d"
```

    Note: Quotes are only nessesary when there are multiple space-separated flags/attrs to pass to the command.

Some commands also accept service(s) which to run command against (eg.: `build` to build only specific services). To pass those use `s` option:

```sh
make docker-build s="service-name service2-name"
```

### Extra commands <small>[extends svc-base-docker]</small>

Some commands with options are very commonly used and because to write them each time is very inconvenient shortcuts were added:

```sh
make docker-upd
# is same as
make docker-up o="--detach" # Detached mode: Run containers in the background.

# AND

make docker-rmf
# is same as
make docker-rm o="--force" # Don't ask to confirm removal

# AND

make docker-logsf
# is same as
make docker-logs o="--follow" # View and follow output from containers
```

# Base repo for services with make <small>[extends svc-base-make]</small>

Make setup which makes use of per-environment dotenv files

## Usage <small>[extends svc-base-make]</small>

```sh
make help
```

## dotenv <small>[extends svc-base-make]</small>

Using `make` and per-environment dotenv files it is prepaired to run on several environments.

### Overrides <small>[extends svc-base-make]</small>

To override variables locally create `.env.local` or `.env.ENVIRONMENT-NAME.local` (eg.: `.env.prod.local`) files.
