# Dockerize-CLIs

Shell functions to run PHP or Node related commands on Docker. 

This project allows the dockerization of common commands : 
`php`, `composer`, `phpunit`, `node`, `npm` and `yarn`.

Some Windows quirks and workarounds are handled (winpty usage for TTY problems, MSYS Posix path conversion)

Inspired by:
* https://gist.github.com/flyingluscas/a2fc4e637f3d967d427105055f6be8cd
* https://hub.docker.com/r/library/composer/

## Installation

Source `dockerize-clis.sh` in a shell startup script (`.bashrc`, `.bash_profile` or `.bash_functions`):
```bash
source ~/dockerize-clis/dockerize-clis.sh
```

## Configuration

Versions and other options are configured through environment variables.


### Enable dockerized commands

By default, no function is enabled. Set the corresponding variables to enable or configure the dockerized commands.

```bash
DOCKERIZE_PHP=true
DOCKERIZE_COMPOSER=true
DOCKERIZE_PHPUNIT=true

source ~/dockerize-clis/dockerize-clis.sh
```

### Configuration variables reference

Here are all the used variables, with their default value and suggestions.

```dotenv
DOCKERIZE_PHP=false
DOCKERIZE_COMPOSER=false
DOCKERIZE_PHPUNIT=false
DOCKERIZE_PHPSTAN=false

DOCKERIZE_NODE=false
DOCKERIZE_NPM=false
DOCKERIZE_YARN=false

PHP_VERSION=7.2

PHP_PUBLISH_PORTS="" # ex: "--publish 8000:8000"
PHP_USER=$(id -u):$(id -g)

NODE_VERSION=8

NODE_PUBLISH_PORTS="" # ex: "--publish 3000:3000"
NODE_USER=$(id -u):$(id -g) # or: node
NODE_USER_HOME=$HOME # or: /home/node

DOCKER_COMMON_VOLUMES="" # ex: "--volume /etc/passwd:/etc/passwd:ro --volume /etc/group:/etc/group:ro" 
                         # (non-existant user workaround, for Unices)
```
