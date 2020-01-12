################################################################################
# Dockerized CLIs
#
# Inspired by:
# https://gist.github.com/flyingluscas/a2fc4e637f3d967d427105055f6be8cd
#


################################################################################
# Windows quirks & workarounds

# Windows TTY problems workaround
if [ "$OSTYPE" == "msys" ] || [ "$OSTYPE" == "cygwin" ]; then
    function docker {
        (winpty docker "$@")
    }
fi

function dockerize_path {
    local path=$1

    # Prefix with "/" to avoid MSYS Posix path conversion
    # @see
    #   http://www.mingw.org/wiki/Posix_path_conversion
    #   https://github.com/moby/moby/issues/12590
    #   https://github.com/moby/moby/issues/24029
    #   https://github.com/rprichard/winpty/issues/88
    #   https://github.com/rprichard/winpty/issues/127
    [ "$OSTYPE" == "msys" ] && path="/${path}"

    echo $path
}

function dockerize_bind_path {
    local path=$1

    # Add "/host_mnt" prefix for Docker
    # @see
    #   https://docs.docker.com/v17.12/docker-for-windows/release-notes/docker-community-edition-17120-ce-win47-2018-01-12
    #   https://github.com/docker/for-win/issues/1509#issuecomment-356419753
    [ "$OSTYPE" == "msys" ] && path="/host_mnt${path}"

    echo $(dockerize_path $path)
}

################################################################################
# Common configuration

DOCKERIZE_CLIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Volumes mounted in every container
DOCKER_COMMON_VOLUMES=${DOCKER_COMMON_VOLUMES:-""}


################################################################################
# Load scripts

# Shell-related commands
source $DOCKERIZE_CLIS_DIR/dockerize-clis-shell.sh

# PHP-related commands
source $DOCKERIZE_CLIS_DIR/dockerize-clis-node.sh

# NodeJS-related commands
source $DOCKERIZE_CLIS_DIR/dockerize-clis-php.sh


################################################################################
# Common utilities

function docker_clis_pull {
    docker pull php:$PHP_VERSION-cli
    docker pull composer
    docker pull phpstan/phpstan
    docker pull node:$NODE_VERSION
    docker pull koalaman/shellcheck:$SHELLCHECK_VERSION
}

function docker_clis_env {
    echo "DOCKERIZE_PHP        : $DOCKERIZE_PHP"
    echo "DOCKERIZE_COMPOSER   : $DOCKERIZE_COMPOSER"
    echo "DOCKERIZE_PHPUNIT    : $DOCKERIZE_PHPUNIT"
    echo "DOCKERIZE_PHPSTAN    : $DOCKERIZE_PHPSTAN"
    echo "DOCKERIZE_NODE       : $DOCKERIZE_NODE"
    echo "DOCKERIZE_NPM        : $DOCKERIZE_NPM"
    echo "DOCKERIZE_YARN       : $DOCKERIZE_YARN"
    echo "DOCKERIZE_SHELLCHECK : $DOCKERIZE_SHELLCHECK"
    echo ""
    echo "PHP_VERSION        : $PHP_VERSION"
    echo "PHP_PUBLISH_PORTS  : $PHP_PUBLISH_PORTS"
    echo "PHP_USER           : $PHP_USER"
    echo ""
    echo "COMPOSER_HOME      : $COMPOSER_HOME"
    echo ""
    echo "NODE_VERSION       : $NODE_VERSION"
    echo "NODE_PUBLISH_PORTS : $NODE_PUBLISH_PORTS"
    echo "NODE_USER          : $NODE_USER"
    echo "NODE_USER_HOME     : $NODE_USER_HOME"
    echo ""
    echo "SHELLCHECK_VERSION: $SHELLCHECK_VERSION"
    echo ""
    echo "DOCKER_COMMON_VOLUMES : $DOCKER_COMMON_VOLUMES"
}
