#!/bin/bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
function extract_resources(){
  mkdir -p /tmp/exploded-war
  pushd /tmp/exploded-war
  for WAR in ${DEPLOYMENTS_DIR}/*.war; do
    jar xf ${WAR}
    mkdir -p /entando-data/resources/ > /dev/null 2>&1
    mkdir -p /entando-data/protected/ > /dev/null 2>&1
    cp resources/* /entando-data/resources/ -rf
    cp protected/* /entando-data/protected/ -rf
  done
  popd
  rm -Rf /tmp/exploded-war
}
NEW_BUILD_ID="false"
if [ ! -f /entando-data/build_id ] ||  [ "$(cat /entando-data-templates/build_id)" -gt "$(cat /entando-data/build_id)" ]; then
  NEW_BUILD_ID="true"
fi
if [ "$SERVDB_DRIVER" = "derby" ] || [ "$PORTDB_DRIVER" = "derby" ]; then
  if [ "$PREPARE_DATA" = "true" ]; then
    if [ "$NEW_BUILD_ID" = "true" ]; then
      echo "Entando database rebuild requested. Replacing existing database with database built from Maven project"
      rm -Rf /entando-data/databases/* > /dev/null 2>&1
      mkdir -p /entando-data/databases/ > /dev/null 2>&1
      cp /entando-data-templates/build_id /entando-data/build_id -f
      cp /entando-data-templates/databases/* /entando-data/databases/ -rf
    fi
  elif [ !  -d /entando-data/databases/entandoPort  ]; then
    echo "New Entando instance detected. Copying default Entando Derby database for optional use."
    mkdir -p /entando-data/databases/ > /dev/null 2>&1
    cp /entando-data-templates/build_id /entando-data/build_id -f
    cp /entando-data-templates/databases/* /entando-data/databases/ -rf
  fi
fi
if [ "$PREPARE_DATA" = "true" ]; then
  if [ "$NEW_BUILD_ID" = "true" ]; then
    echo "Entando resource reset requested. Replacing existing resources with resources copied from Maven project"
    cp /entando-data-templates/build_id /entando-data/build_id -f
    rm -Rf /entando-data/protected/* > /dev/null 2>&1
    rm -Rf /entando-data/resources/* > /dev/null 2>&1
    extract_resources
   fi
elif [ !  -d /entando-data/resources ]; then
  echo "New Entando instance detected. Copying Entando resources from Maven project for optional use."
  cp /entando-data-templates/build_id /entando-data/build_id -f
  extract_resources
fi
chmod -Rf ug+rw /entando-data/
