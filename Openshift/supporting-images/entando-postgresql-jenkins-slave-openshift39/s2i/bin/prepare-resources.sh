#!/bin/bash
if [ "$RESET_RESOURCES" = "true" ]; then
  echo "Entando resource reset requested. Replacing existing resources with resources copied from Maven project"
  rm -Rf /entando-resources/protected/* > /dev/null 2>&1
  mkdir -p /entando-resources/ > /dev/null 2>&1
  cp /entando-resources-base/* /entando-resources/databases/ -rf
  chmod -Rf ug+rw /entando-resources/databases/
elif [ !  -d /entando-resources/databases/entandoPort  ]; then
  echo "New Entando instance detected. Copying Entando resources from Maven project optional use."
  mkdir -p /entando-resources/databases/ > /dev/null 2>&1
  cp /entando-resources-base/* /entando-resources/databases/ -rf
  chmod -Rf ug+rw /entando-resources/databases/
fi
