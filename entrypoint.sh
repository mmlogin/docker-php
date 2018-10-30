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
        for f in /docker-entrypoint-init.d/*
        do
            case "${f}"
            in
                *.sh)
                    echo "$0: running $f"
                    nohup "$f" &
                    ;;
                *)
                   echo "$0: ignoring $f"
                   ;;
            esac
        done

    fi
fi

echo "Executing $@"
exec "$@"

