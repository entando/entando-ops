#!/usr/bin/env bash
source ${ENTANDO_COMMON_PATH}/env-helper.sh
export_env_files
#This may not be needed anymore. I attempted to remove all of the parent image's use of the MYSQL_USER/PASSWORD/DATABASE vars because we read them from an array now
if [[ -v PORTDB_USERNAME ]]; then
  export MYSQL_USER="${PORTDB_USERNAME}"
fi
if [[ -v PORTDB_PASSWORD ]]; then
  export MYSQL_PASSWORD="${PORTDB_PASSWORD}"
fi
if [[ -v PORTDB_DATABASE ]]; then
  export MYSQL_DATABASE="${PORTDB_DATABASE}"
fi
if [[ -v ADMIN_PASSWORD ]]; then
   export MYSQL_ROOT_PASSWORD="${ADMIN_PASSWORD}"
fi
