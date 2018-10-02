#!/bin/bash

export PGPASSWORD=$POSTGRESQL_ADMIN_PASSWORD

source $(dirname ${BASH_SOURCE[0]})/parse-url.sh ${PORTDB_URL}
dropdb -h ${URL_HOST} --port=${URL_PORT} -U ${POSTGRESQL_ADMIN} ${URL_PATH}
createdb -h ${URL_HOST} --port=${URL_PORT} -U ${POSTGRESQL_ADMIN} -E UTF-8 -O ${PORTDB_USERNAME} ${URL_PATH}
psql -U ${POSTGRESQL_ADMIN} --host=${URL_HOST} --port=${URL_PORT} -d ${URL_PATH} < ${URL_PATH}.sql

source $(dirname ${BASH_SOURCE[0]})/parse-url.sh ${SERVDB_URL}
dropdb -h ${URL_HOST} --port=${URL_PORT} -U ${POSTGRESQL_ADMIN} ${URL_PATH}
createdb -h ${URL_HOST} --port=${URL_PORT} -U ${POSTGRESQL_ADMIN} -E UTF-8 -O ${SERVDB_USERNAME} ${URL_PATH}
psql -U ${POSTGRESQL_ADMIN} --host=${URL_HOST} --port=${URL_PORT} -d ${URL_PATH} < ${URL_PATH}.sql

