#!/usr/bin/env bash
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    echo "$0: Setting ARG[1] to: php-fpm${PHP_VER:-7.1}"
    set -- php-fpm${PHP_VER:-7.1} "$@"
fi

if [ ! -e "/initialized" ]
then
    if [ -d "/docker-entrypoint-init.d" ]
    then
        shopt -s nullglob
        for f in /docker-entrypoint-init.d/*.sh ; do
            echo "$0: running $f"
            nohup "$f" &
        done

        shopt -u nullglob

    fi
fi

echo "$0: Executing: $@"
exec "$@"

