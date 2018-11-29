#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
if [ -d $1/entando-data-templates/resources ]; then
  rm -rf  -p /entando-data-templates/resources > /dev/null 2>&1
  mkdir -p /entando-data-templates/resources > /dev/null 2>&1
  if ! cp -rf $1/entando-data-templates/resources/* /entando-data-templates/resources/ ; then
    exit 1
  fi
fi
if [ -d $1/entando-data-templates/protected ]; then
  rm -rf  -p /entando-data-templates/protected > /dev/null 2>&1
  mkdir -p /entando-data-templates/protected > /dev/null 2>&1
  if ! cp -rf $1/entando-data-templates/protected/* /entando-data-templates/protected/ ; then
    exit 1
  fi
fi
