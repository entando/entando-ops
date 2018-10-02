#!/bin/bash
rm -f *.sql
export PGPASSWORD=$POSTGRESQL_ADMIN_PASSWORD
source $(dirname ${BASH_SOURCE[0]})/parse-url.sh ${PORTDB_URL}
pg_dump -U ${POSTGRESQL_ADMIN} ${URL_PATH} > ${URL_PATH}.sql -h ${URL_HOST} --port=${URL_PORT}
source $(dirname ${BASH_SOURCE[0]})/parse-url.sh ${SERVDB_URL}
pg_dump -U ${POSTGRESQL_ADMIN} ${URL_PATH} > ${URL_PATH}.sql -h ${URL_HOST} --port=${URL_PORT}

