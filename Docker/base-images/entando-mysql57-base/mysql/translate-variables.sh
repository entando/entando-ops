#!/usr/bin/env bash

if [ -n "$ENV_FILES" ]; then
  IFS=,
  for val in $ENV_FILES; do
    source $val
  done
fi
if [[ -v PORTDB_USERNAME ]]; then
  export MYSQL_USER="${PORTDB_USERNAME}"
fi
if [[ -v PORTDB_PASSWORD ]]; then
  export MYSQL_PASSWORD="${PORTDB_PASSWORD}"
fi
if [[ -v PORTDB_DATABASE ]]; then
  export MYSQL_DATABASE="${PORTDB_DATABASE}"
fi
if [[ -v SERVDB_USERNAME ]]; then
  export MYSQL_USER2="${SERVDB_USERNAME}"
fi
if [[ -v SERVDB_PASSWORD ]]; then
  export MYSQL_PASSWORD2="${SERVDB_PASSWORD}"
fi
if [[ -v SERVDB_DATABASE ]]; then
  export MYSQL_DATABASE2="${SERVDB_DATABASE}"
fi
if [[ -v ADMIN_PASSWORD ]]; then
   export MYSQL_ROOT_PASSWORD="${ADMIN_PASSWORD}"
fi
echo "Environment variables"
set | grep MYSQL
