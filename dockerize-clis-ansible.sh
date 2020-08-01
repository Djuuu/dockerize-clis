
DOCKERIZE_ANSIBLE=${DOCKERIZE_ANSIBLE:-false}
ANSIBLE_VERSION=${ANSIBLE_VERSION:-latest}


if [ "$DOCKERIZE_ANSIBLE" = true ]; then

    function ansible_common_options {

        # Docker common volumes
        echo " $DOCKER_COMMON_VOLUMES "

        # Inventory file
        if [ -f "inventory" ]; then
            echo " --volume $(dockerize_bind_path $(pwd)/inventory):/etc/ansible/hosts "
        fi

        # SSH agent
        if [ ! -z "$SSH_AUTH_SOCK" ]; then
            echo " --volume $SSH_AUTH_SOCK:/ssh-agent "
            echo " --env SSH_AUTH_SOCK=/ssh-agent "
        else
            if [ -f "${HOME}/.ssh/id_rsa" ]; then
                echo " --volume $(dockerize_bind_path ${HOME}/.ssh/id_rsa):/root/.ssh/id_rsa "
            fi
        fi

        if [ -f "${HOME}/.ssh/known_hosts" ]; then
            echo " --volume $(dockerize_bind_path ${HOME}/.ssh/known_hosts):/root/.ssh/known_hosts "
        fi

        # Ansible volumes
        if [ -d ".ansible" ]; then
            echo " --volume $(dockerize_bind_path $(pwd)/.ansible):/runner/.ansible "
        fi

        # Project volume
        echo " --volume $(dockerize_bind_path $(pwd)):/runner/project "
        echo " --workdir $(dockerize_path '/runner/project') "
    }

    function ansible_container {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            $(ansible_common_options) \
            ansible/ansible-runner:$ANSIBLE_VERSION "$@"
    }

    function ansible {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            $(ansible_common_options) \
            ansible/ansible-runner:$ANSIBLE_VERSION ansible "$@"
    }

    function ansible-playbook {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            $(ansible_common_options) \
            ansible/ansible-runner:$ANSIBLE_VERSION ansible-playbook "$@"
    }

    function ansible-galaxy {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            $(ansible_common_options) \
            ansible/ansible-runner:$ANSIBLE_VERSION ansible-galaxy "$@"
    }

fi
