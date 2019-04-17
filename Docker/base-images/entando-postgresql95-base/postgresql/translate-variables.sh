#!/usr/bin/env bash

source ${ENTANDO_COMMON_PATH}/env-helper.sh
export_env_files

if [[ -v PORTDB_USERNAME ]]; then
  export POSTGRESQL_USER="${PORTDB_USERNAME}"
fi
if [[ -v PORTDB_PASSWORD ]]; then
  export POSTGRESQL_PASSWORD="${PORTDB_PASSWORD}"
fi
if [[ -v PORTDB_DATABASE ]]; then
  export POSTGRESQL_DATABASE="${PORTDB_DATABASE}"
fi
if [[ -v ADMIN_PASSWORD ]]; then
   export POSTGRESQL_ADMIN_PASSWORD="${ADMIN_PASSWORD}"
fi
if [ -v ADMIN_USERNAME ] && [ ! $ADMIN_USERNAME = "postgres" ]; then
   export POSTGRESQL_MASTER_USER="${ADMIN_USERNAME}"
   export POSTGRESQL_MASTER_PASSWORD="${ADMIN_PASSWORD:-postgres}"
fi
#set | grep POSTGRESQL
