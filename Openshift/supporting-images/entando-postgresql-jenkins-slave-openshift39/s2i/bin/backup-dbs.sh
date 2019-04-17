#!/bin/bash
set -e
source $(dirname ${BASH_SOURCE[0]})/common.sh
export PGPASSWORD=$ADMIN_PASSWORD
function dump_db(){
  HOST_VAR=$(get_host_var $1)
  PORT_VAR=$(get_port_var $1)
  DATABASE_VAR=$(get_var_name ${1} DATABASE)
  rm  -f ${!DATABASE_VAR}.sql
  pg_dump -U ${ADMIN_USERNAME} ${!DATABASE_VAR} > ${!DATABASE_VAR}.sql -h ${!HOST_VAR} --port=${!PORT_VAR}
}

dump_db PORTDB
dump_db SERVDB