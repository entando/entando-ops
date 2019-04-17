#!/bin/bash
set -e
source $(dirname ${BASH_SOURCE[0]})/common.sh

export PGPASSWORD=$ADMIN_PASSWORD
function restore_db(){
  HOST_VAR=$(get_host_var $1)
  PORT_VAR=$(get_port_var $1)
  DATABASE_VAR=$(get_var_name ${1} DATABASE)
  USERNAME_VAR=$(get_var_name ${1} USERNAME)

  if [ -f "${!DATABASE_VAR}.sql" ]; then
    echo "Restoring ${!DATABASE_VAR} from ${!DATABASE_VAR}.sql"
    dropdb -h ${!HOST_VAR} --port=${!PORT_VAR} -U ${ADMIN_USERNAME} ${!DATABASE_VAR}
    createdb -h ${!HOST_VAR} --port=${!PORT_VAR} -U ${ADMIN_USERNAME} -E UTF-8 -O ${!USERNAME_VAR} ${!DATABASE_VAR}
    psql -U ${ADMIN_USERNAME} --host=${!HOST_VAR} --port=${!PORT_VAR} -d ${!DATABASE_VAR} < ${!DATABASE_VAR}.sql
  else
    echo "ERROR: NO BACKUP FOUND FOR ${!DATABASE_VAR}"
  fi
}

restore_db SERVDB
restore_db PORTDB
