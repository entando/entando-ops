#!/usr/bin/env bash
export VERSION=${1:-5.0.1-SNAPSHOT}
docker pull entando/appbuilder:$VERSION
docker pull entando/entando-eap71-openshift:$VERSION
