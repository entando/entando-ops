#!/usr/bin/env bash

if [ -n "$ENV_FILES" ]; then
  IFS=,
  for val in $ENV_FILES; do
    source $val
  done
fi
if [[ -v PORTDB_USERNAME ]]; then
  export POSTGRESQL_USER="${PORTDB_USERNAME}"
fi
if [[ -v PORTDB_PASSWORD ]]; then
  export POSTGRESQL_PASSWORD="${PORTDB_PASSWORD}"
fi
if [[ -v PORTDB_DATABASE ]]; then
  export POSTGRESQL_DATABASE="${PORTDB_DATABASE}"
fi
if [[ -v SERVDB_USERNAME ]]; then
  export POSTGRESQL_USER2="${SERVDB_USERNAME}"
fi
if [[ -v SERVDB_PASSWORD ]]; then
  export POSTGRESQL_PASSWORD2="${SERVDB_PASSWORD}"
fi
if [[ -v SERVDB_DATABASE ]]; then
  export POSTGRESQL_DATABASE2="${SERVDB_DATABASE}"
fi
if [[ -v ADMIN_PASSWORD ]]; then
   export POSTGRESQL_ADMIN_PASSWORD="${ADMIN_PASSWORD}"
fi
if [ -v ADMIN_USERNAME ] && [ ! $ADMIN_USERNAME = "postgres" ]; then
   export POSTGRESQL_MASTER_USER="${ADMIN_USERNAME}"
   export POSTGRESQL_MASTER_PASSWORD="${ADMIN_PASSWORD:-postgres}"
fi
#set | grep POSTGRESQL
