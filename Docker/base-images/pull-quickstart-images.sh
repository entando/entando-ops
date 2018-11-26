q#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
docker pull entando/appbuilder:$VERSION
docker pull entando/entando-eap71-base:$VERSION
