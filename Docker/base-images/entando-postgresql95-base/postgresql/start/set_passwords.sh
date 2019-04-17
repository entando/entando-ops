#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../translate-variables.sh
if [[ ",$postinitdb_actions," = *,simple_db,* ]]; then
  DB_PREFIX_ARRAY=($(get_db_prefix_array))
  for DB in ${DB_PREFIX_ARRAY[*]} ; do
    USER_VAR=$(get_var_name $DB USERNAME)
    PASSWORD_VAR=$(get_var_name $DB PASSWORD)
    psql --command "ALTER USER \"${!USER_VAR}\" WITH ENCRYPTED PASSWORD '${!PASSWORD_VAR}';"
  done
fi

if [ -v POSTGRESQL_MASTER_USER ]; then
psql --command "ALTER USER \"${POSTGRESQL_MASTER_USER}\" WITH REPLICATION;"
psql --command "ALTER USER \"${POSTGRESQL_MASTER_USER}\" WITH ENCRYPTED PASSWORD '${POSTGRESQL_MASTER_PASSWORD}';"
fi

if [ -v POSTGRESQL_ADMIN_PASSWORD ]; then
psql --command "ALTER USER \"postgres\" WITH ENCRYPTED PASSWORD '${POSTGRESQL_ADMIN_PASSWORD}';"
fi
