
DOCKERIZE_PHP=${DOCKERIZE_PHP:-false}
DOCKERIZE_COMPOSER=${DOCKERIZE_COMPOSER:-false}
DOCKERIZE_PHPUNIT=${DOCKERIZE_PHPUNIT:-false}
DOCKERIZE_PHPSTAN=${DOCKERIZE_PHPSTAN:-false}

PHP_VERSION=${PHP_VERSION:-7.3}

PHP_PUBLISH_PORTS=${PHP_PUBLISH_PORTS:-""} # ex: "--publish 8000:8000"
PHP_USER=${PHP_USER:-$(id -u):$(id -g)} # or: www-data

COMPOSER_HOME=${COMPOSER_HOME:-$HOME/.composer}

if [ "$DOCKERIZE_PHP" = true ]; then
    function php {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            --user $PHP_USER \
            $DOCKER_COMMON_VOLUMES \
            --volume $(dockerize_bind_path $(pwd)):/code \
            --workdir $(dockerize_path '/code') \
            $PHP_PUBLISH_PORTS \
            php:$PHP_VERSION-cli php "$@"
    }
fi

if [ "$DOCKERIZE_COMPOSER" = true ]; then
    function composer {

        [ ! -d "$COMPOSER_HOME" ] && echo "Creating \$COMPOSER_HOME directory ($COMPOSER_HOME)" && mkdir $COMPOSER_HOME

        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            --user $PHP_USER \
            $DOCKER_COMMON_VOLUMES \
            --volume $(dockerize_bind_path $COMPOSER_HOME):/tmp \
            --volume $(dockerize_bind_path $(pwd)):/code \
            --workdir $(dockerize_path '/code') \
            composer "$@"
    }

    function laravel {
	    if [ ! -f "$COMPOSER_HOME/vendor/bin/laravel" ]; then
	        echo "Installing Laravel Installer globally..."
	        echo ""
	        composer global require "laravel/installer"
	        echo ""
	    fi

		composer $(dockerize_path '/tmp/vendor/bin/laravel') "$@"
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
            --volume $(dockerize_bind_path $(pwd)):/app \
            phpstan/phpstan "$@"
    }
fi
