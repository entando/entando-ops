#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
#Copies all directories across from $1/entando-data-templates to /entando-data-templates
#Does NOT initialize a derby database as this script should only be used in clustered environments
#deprecation considered as these files can be extracted from the WAR file too
if [ -d $1/entando-data-templates/resources ]; then
  rm -rf  -p /entando-data-templates/resources > /dev/null 2>&1
  mkdir -p /entando-data-templates/resources > /dev/null 2>&1
  echo $(date +%s) > /entando-data-templates/build_id
  if ! cp -rf $1/entando-data-templates/resources/* /entando-data-templates/resources/ ; then
    exit 1
  fi
fi
if [ -d $1/entando-data-templates/protected ]; then
  rm -rf  -p /entando-data-templates/protected > /dev/null 2>&1
  mkdir -p /entando-data-templates/protected > /dev/null 2>&1
  if ! [[ -f /entando-data-templates/build_id ]]; then
    echo $(date +%s) > /entando-data-templates/build_id
  fi
  if ! cp -rf $1/entando-data-templates/protected/* /entando-data-templates/protected/ ; then
    exit 1
  fi
fi
