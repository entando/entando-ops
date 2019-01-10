#!/bin/bash
export PGPASSWORD=$ADMIN_PASSWORD
echo "PORTDB_SERVICE_HOST=${PORTDB_SERVICE_HOST}"
echo "SERVDB_SERVICE_HOST=${SERVDB_SERVICE_HOST}"

set -e

dropdb -h ${SERVDB_SERVICE_HOST} --port=${SERVDB_SERVICE_PORT} -U ${ADMIN_USERNAME} ${SERVDB_DATABASE}
createdb -h ${SERVDB_SERVICE_HOST} --port=${SERVDB_SERVICE_PORT} -U ${ADMIN_USERNAME} -E UTF-8 -O ${SERVDB_USERNAME} ${SERVDB_DATABASE}

dropdb -h ${PORTDB_SERVICE_HOST} --port=${PORTDB_SERVICE_PORT} -U ${ADMIN_USERNAME} ${PORTDB_DATABASE}
createdb -h ${PORTDB_SERVICE_HOST} --port=${PORTDB_SERVICE_PORT} -U ${ADMIN_USERNAME} -E UTF-8 -O ${PORTDB_USERNAME} ${PORTDB_DATABASE}
