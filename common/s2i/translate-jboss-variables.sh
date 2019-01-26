#!/usr/bin/env bash
#USE_ENV=""
if [ -n "$ENV_FILES" ]; then
  IFS=","  read -ra ENV_FILES_ARG <<< "$ENV_FILES"
  for f in "${ENV_FILES_ARG[@]}"
  do
    VARIABLE_DECLARATIONS="$VARIABLE_DECLARATIONS $(cat $f | grep -v ^# | xargs)"
  done
  #USE_ENV="env $VARIABLE_DECLARATIONS"
  export $VARIABLE_DECLARATIONS
fi
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
#Derive drivers from URLs to increase robustness
if [ -n "$PORTDB_URL" ]; then
  case "$PORTDB_URL" in
    jdbc:derby:* )
        export PORTDB_DRIVER=derby
    ;;
    jdbc:postgresql:* )
        export PORTDB_DRIVER=postgresql
    ;;
    jdbc:mysql:* )
        export PORTDB_DRIVER=mysql
    ;;
    jdbc:oracle:* )
        export PORTDB_DRIVER=oracle
    ;;
  esac
fi
if [ -n "$SERVDB_URL" ]; then
  case "$SERVDB_URL" in
    jdbc:derby:* )
        export SERVDB_DRIVER=derby
    ;;
    jdbc:postgresql:* )
        export SERVDB_DRIVER=postgresql
    ;;
    jdbc:mysql:* )
        export SERVDB_DRIVER=mysql
    ;;
    jdbc:oracle:* )
        export SERVDB_DRIVER=oracle
    ;;
  esac
fi
#Derive Entando's confusing datasourceclassname variable
if [ -n "$PORTDB_DRIVER" ]; then
    export PORTDATASOURCECLASSNAME=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh ${PORTDB_DRIVER})
fi
if [ -n "$SERVDB_DRIVER" ]; then
    export SERVDATASOURCECLASSNAME=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh ${SERVDB_DRIVER})
fi
