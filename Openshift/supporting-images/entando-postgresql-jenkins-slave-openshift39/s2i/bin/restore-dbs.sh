#!/bin/bash

export PGPASSWORD=$ADMIN_PASSWORD

if [ -f "${SERVDB_DATABASE}.sql" ]; then
    dropdb -h ${SERVDB_SERVICE_HOST} --port=${SERVDB_SERVICE_PORT} -U ${ADMIN_USERNAME} ${SERVDB_DATABASE}
    createdb -h ${SERVDB_SERVICE_HOST} --port=${SERVDB_SERVICE_PORT} -U ${ADMIN_USERNAME} -E UTF-8 -O ${SERVDB_USERNAME} ${SERVDB_DATABASE}
    psql -U ${ADMIN_USERNAME} --host=${SERVDB_SERVICE_HOST} --port=${SERVDB_SERVICE_PORT} -d ${SERVDB_DATABASE} < ${SERVDB_DATABASE}.sql
fi
if [ -f "${PORTDB_DATABASE}.sql" ]; then
    dropdb -h ${PORTDB_SERVICE_HOST} --port=${PORTDB_SERVICE_PORT} -U ${ADMIN_USERNAME} ${PORTDB_DATABASE}
    createdb -h ${PORTDB_SERVICE_HOST} --port=${PORTDB_SERVICE_PORT} -U ${ADMIN_USERNAME} -E UTF-8 -O ${PORTDB_USERNAME} ${PORTDB_DATABASE}
    psql -U ${ADMIN_USERNAME} --host=${PORTDB_SERVICE_HOST} --port=${PORTDB_SERVICE_PORT} -d ${PORTDB_DATABASE} < ${PORTDB_DATABASE}.sql
fi


