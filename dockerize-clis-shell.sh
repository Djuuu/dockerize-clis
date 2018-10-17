
DOCKERIZE_SHELLCHECK=${DOCKERIZE_SHELLCHECK:-false}

SHELLCHECK_VERSION=${SHELLCHECK_VERSION:-stable}

if [ "$DOCKERIZE_SHELLCHECK" = true ]; then
    function shellcheck {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            $DOCKER_COMMON_VOLUMES \
            --volume $(abspath $(pwd)):/mnt \
            --workdir $(abspath '/mnt') \
            koalaman/shellcheck:$SHELLCHECK_VERSION "$@"
    }
fi
