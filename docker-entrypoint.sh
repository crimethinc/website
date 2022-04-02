#!/bin/sh

set -e

# I am not sure if this is still an issue, but in past experiences
# docker-compose occasionally wouldn't clean up the server.pid file when
# shutting down. This would result in a "server already running" error,
# with the fix being to manually delete this file. I am just encoding it
# here so we do not need to even think about it
if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
fi

exec "$@"
