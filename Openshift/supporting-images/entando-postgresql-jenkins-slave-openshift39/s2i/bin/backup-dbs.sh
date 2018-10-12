#!/bin/bash
rm -f *.sql
export PGPASSWORD=$ADMIN_PASSWORD
echo "PORTDB_SERVICE_HOST=${PORTDB_SERVICE_HOST}"
pg_dump -U ${ADMIN_USERNAME} ${PORTDB_DATABASE} > ${PORTDB_DATABASE}.sql -h ${PORTDB_SERVICE_HOST} --port=${PORTDB_SERVICE_PORT}
pg_dump -U ${ADMIN_USERNAME} ${SERVDB_DATABASE} > ${SERVDB_DATABASE}.sql -h ${SERVDB_SERVICE_HOST} --port=${SERVDB_SERVICE_PORT}