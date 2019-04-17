#!/bin/bash
set -e
source $(dirname ${BASH_SOURCE[0]})/common.sh
export PGPASSWORD=$ADMIN_PASSWORD
function recreate_db(){
  HOST_VAR=$(get_host_var $1)
  PORT_VAR=$(get_port_var $1)
  DATABASE_VAR=$(get_var_name ${1} DATABASE)
  USERNAME_VAR=$(get_var_name ${1} USERNAME)

  dropdb -h ${!HOST_VAR} --port=${!PORT_VAR} -U ${ADMIN_USERNAME} ${!DATABASE_VAR}
  createdb -h ${!HOST_VAR} --port=${!PORT_VAR} -U ${ADMIN_USERNAME} -E UTF-8 -O ${!USERNAME_VAR} ${!DATABASE_VAR}
}
recreate_db SERVDB
recreate_db PORTDB