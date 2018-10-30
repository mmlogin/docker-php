#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm${PHP_VERSION:-7.0} "$@"
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

echo "Executing $@"
exec "$@"

