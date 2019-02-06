#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
#Rebuilds a Derby database for embedded use IF and only if the database driver is derby and PREPARE_DATA is true
if [ "$PORTDB_DRIVER" = "derby" ] && [ "$SERVDB_DRIVER" = "derby" ]; then
  if [ "$PREPARE_DATA" = "true" ]; then
    rm -Rf /entando-data-templates/databases/
    if [ -d /entando-data/databases ]; then
     #Delete the old database entirely so that Entando can do a full restore
      rm -Rf /entando-data/databases/*
    else
      mkdir -p /entando-data/databases
    fi
    if $(dirname ${BASH_SOURCE[0]})/init-db-from-war.sh "$@" ;  then
      echo "Copying newly generated DB to /entando-data-templates/"
      #Copy the new database across, overwriting the old database entirely. This ensures a full restore can be effected
      rm -Rf /entando-data-templates/databases > /dev/null 2>&1
      mkdir -p /entando-data-templates/databases/
      cp -Rf /entando-data/databases/* /entando-data-templates/databases/
      chmod -Rf ug+rw /entando-data-templates/databases/
      chown -Rf $USERID_TO_USE:0 /entando-data-templates/databases/
      rm -Rf /entando-data/protected
      rm -Rf /entando-data/resources
    else
      echo "Derby Database Build failed"
      exit 1
    fi
  else
    echo "Derby Database not built because PREPARE_DATA=false"
  fi
fi
#Update the build_id whether there was a Derby rebuild or not. This is to be used in prepare-date.sh
echo $(date +%s) > /entando-data-templates/build_id
exit 0
