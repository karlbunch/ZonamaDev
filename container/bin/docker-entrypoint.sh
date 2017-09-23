#!/usr/bin/env bash
echo "ARGS: $@"
set -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

if [ "${1:0:1}" = '-' ]; then
    set -- swgemu "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'swgemu' ] && [ "$(id -u)" = '0' ]; then
    export USER=swgemu
    cd /home/$USER
    export SHELL=/bin/bash
    export TZ='Etc/UTC'
    exec gosu swgemu "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'swgemu' ]; then
    file_env 'DBHOST'
    file_env 'DBPORT'
    file_env 'DBNAME'
    file_env 'DBUSER'
    file_env 'DBPASS'
    file_env 'DBSECRET'
fi

exec "$@"

# vim: set ai sw=4 expandtabs
