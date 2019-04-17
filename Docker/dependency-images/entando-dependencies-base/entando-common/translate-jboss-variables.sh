#!/usr/bin/env bash
source ${ENTANDO_COMMON_PATH}/env-helper.sh
export_env_files
#TODO refactor this to generically iterate through all DB prefixes
function extract_database_name(){
  path="$(echo $1 | grep / | cut -d/ -f4-)"
  echo $path
}
function extract_database_driver(){
  path="$(echo $1 | grep / | cut -d: -f2)"
  echo $path
}
#Derive URL from variables compatible with the EAP Image when connecting to a database service
if [ -n "$PORTDB_POSTGRESQL_SERVICE_HOST" ]; then
  export PORTDB_URL="jdbc:postgresql://$PORTDB_POSTGRESQL_SERVICE_HOST:${PORTDB_POSTGRESQL_SERVICE_PORT:-5432}/${PORTDB_DATABASE:-entandoPort}"
elif [ -n "$PORTDB_MYSQL_SERVICE_HOST" ]; then
  export PORTDB_URL="jdbc:mysql://$PORTDB_MYSQL_SERVICE_HOST:${PORTDB_MYSQL_SERVICE_PORT:-3306}/${PORTDB_DATABASE:-entandoPort}"
fi
if [ -n "$SERVDB_POSTGRESQL_SERVICE_HOST" ]; then
  export SERVDB_URL="jdbc:postgresql://$SERVDB_POSTGRESQL_SERVICE_HOST:${SERVDB_POSTGRESQL_SERVICE_PORT:-5432}/${SERVDB_DATABASE:-entandoServ}"
elif [ -n "$SERVDB_MYSQL_SERVICE_HOST" ]; then
  export SERVDB_URL="jdbc:mysql://$SERVDB_MYSQL_SERVICE_HOST:${SERVDB_MYSQL_SERVICE_PORT:-3306}/${SERVDB_DATABASE:-entandoServ}"
fi
#Derive variables from URLs to increase robustness
if [ -n "$PORTDB_URL" ]; then
  export PORTDB_DRIVER=$(extract_database_driver $PORTDB_URL)
  export PORTDB_DATABASE=$(extract_database_name $PORTDB_URL)
fi
if [ -n "$SERVDB_URL" ]; then
  export SERVDB_DRIVER=$(extract_database_driver $SERVDB_URL)
  export SERVDB_DATABASE=$(extract_database_name $SERVDB_URL)
fi
#Derive Entando's confusing datasourceclassname variable
if [ -n "$PORTDB_DRIVER" ]; then
    export PORTDATASOURCECLASSNAME=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh ${PORTDB_DRIVER})
fi
if [ -n "$SERVDB_DRIVER" ]; then
    export SERVDATASOURCECLASSNAME=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh ${SERVDB_DRIVER})
fi
