#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!

#remove all previous Entando data from parent images
rm -Rf /entando-data-templates/* > /dev/null 2>&1
if $(dirname ${BASH_SOURCE[0]})/init-db.sh ; then
  if [ -d src/main/webapp/resources ]; then
    mkdir -p /entando-data-templates/resources > /dev/null 2>&1
    if ! cp -rf src/main/webapp/resources/* /entando-data-templates/resources/ ; then
      exit 1
    fi
  fi
  if [ -d src/main/webapp/protected ]; then
    mkdir -p /entando-data-templates/protected > /dev/null 2>&1
    if ! cp -rf src/main/webapp/protected/* /entando-data-templates/protected/ ; then
      exit 1
    fi
  fi
  echo $(date +%s) > /entando-data-templates/build_id
  chmod -Rf ug+rw /entando-data-templates/
  chown -Rf $USERID_TO_USE:0 /entando-data-templates/
  exit 0
else
  exit 1
fi
