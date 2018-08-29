
DOCKERIZE_PHP=${DOCKERIZE_PHP:-false}
DOCKERIZE_COMPOSER=${DOCKERIZE_COMPOSER:-false}
DOCKERIZE_PHPUNIT=${DOCKERIZE_PHPUNIT:-false}
DOCKERIZE_PHPSTAN=${DOCKERIZE_PHPSTAN:-false}

PHP_VERSION=${PHP_VERSION:-7.2}

PHP_PUBLISH_PORTS=${PHP_PUBLISH_PORTS:-""} # ex: "--publish 8000:8000"
PHP_USER=${PHP_USER:-$(id -u):$(id -g)}

COMPOSER_HOME=${COMPOSER_HOME:-$HOME/.composer}

if [ "$DOCKERIZE_PHP" = true ]; then
    function php {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            --user $PHP_USER \
            $DOCKER_COMMON_VOLUMES \
            --volume $(abspath $(pwd)):/code \
            --workdir $(abspath '/code') \
            $PHP_PUBLISH_PORTS \
            php:$PHP_VERSION-cli php "$@"
    }
fi

if [ "$DOCKERIZE_COMPOSER" = true ]; then
    function composer {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            --user $PHP_USER \
            $DOCKER_COMMON_VOLUMES \
            --volume $(abspath $COMPOSER_HOME):/tmp \
            --volume $(abspath $(pwd)):/code \
            --workdir $(abspath '/code') \
            composer "$@"
    }
fi

if [ "$DOCKERIZE_PHPUNIT" = true ]; then
    function phpunit {
        php vendor/phpunit/phpunit/phpunit "$@"
    }
fi

if [ "$DOCKERIZE_PHPSTAN" = true ]; then
    function phpstan {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            --volume $(abspath $(pwd)):/app \
            phpstan/phpstan "$@"
    }
fi
