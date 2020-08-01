
DOCKERIZE_SHELLCHECK=${DOCKERIZE_SHELLCHECK:-false}

SHELLCHECK_VERSION=${SHELLCHECK_VERSION:-stable}

# Volumes mounted in every container
DOCKER_COMMON_VOLUMES=${DOCKER_COMMON_VOLUMES:-""}


if [ "$DOCKERIZE_SHELLCHECK" = true ]; then
    function shellcheck {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            $DOCKER_COMMON_VOLUMES \
            --volume $(dockerize_bind_path $(pwd)):/mnt \
            --workdir $(dockerize_path '/mnt') \
            koalaman/shellcheck:$SHELLCHECK_VERSION "$@"
    }
fi
