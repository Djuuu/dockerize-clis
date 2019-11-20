
DOCKERIZE_NODE=${DOCKERIZE_NODE:-false}
DOCKERIZE_NPM=${DOCKERIZE_NPM:-false}
DOCKERIZE_YARN=${DOCKERIZE_YARN:-false}

NODE_VERSION=${NODE_VERSION:-8}

NODE_PUBLISH_PORTS=${NODE_PUBLISH_PORTS:-""} # ex: "--publish 3000:3000"
NODE_USER=${NODE_USER:-$(id -u):$(id -g)} # or: node
NODE_USER_HOME=${NODE_USER_HOME:-$HOME} # or: /home/node


if [ "$DOCKERIZE_NODE" = true ]; then
    # Alias might be set by node windows installation
    unalias node 2>/dev/null
    function node {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            --user $NODE_USER \
            $DOCKER_COMMON_VOLUMES \
            --volume $(dockerize_bind_path $(pwd)):/code \
            --workdir $(dockerize_path '/code') \
            $NODE_PUBLISH_PORTS \
            node:$NODE_VERSION node "$@"
    }
fi

if [ "$DOCKERIZE_NPM" = true ]; then
    function npm {
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            --user $NODE_USER \
            $DOCKER_COMMON_VOLUMES \
            --volume $(dockerize_bind_path $HOME/.config):$NODE_USER_HOME/.config \
            --volume $(dockerize_bind_path $HOME/.npm):$NODE_USER_HOME/.npm \
            --volume $(dockerize_bind_path $(pwd)):/code \
            --workdir $(dockerize_path '/code') \
            --entrypoint $(dockerize_path '/usr/local/bin/npm') \
            $NODE_PUBLISH_PORTS \
            node:$NODE_VERSION "$@"
    }
fi

if [ "$DOCKERIZE_YARN" = true ]; then
    function yarn {
        yarnFile="$HOME/.yarnrc"
        [ ! -f $yarnFile ] && touch $yarnFile
        tty=
        tty -s && tty=--tty
        docker run $tty --interactive --rm \
            --user $NODE_USER \
            $DOCKER_COMMON_VOLUMES \
            --volume $(dockerize_bind_path $HOME/.config):$NODE_USER_HOME/.config \
            --volume $(dockerize_bind_path $HOME/.cache):$NODE_USER_HOME/.cache \
            --volume $(dockerize_bind_path $HOME/.npm):$NODE_USER_HOME/.npm \
            --volume $(dockerize_bind_path $yarnFile):$yarnFile \
            --volume $(dockerize_bind_path $(pwd)):/code \
            --workdir $(dockerize_path '/code') \
            --entrypoint $(dockerize_path '/usr/local/bin/yarn') \
            $NODE_PUBLISH_PORTS \
            node:$NODE_VERSION "$@"
    }
fi
