#!/usr/bin/env bash
tty=
    tty -s && tty=--tty
    docker run \
        $tty \
        --interactive \
        --rm \
        --user node:node \
        --volume $(pwd):/usr/src/app \
        -w /usr/src/app \
        node:6-alpine yarn "$@"