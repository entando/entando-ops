#!/usr/bin/env bash
export VERSION=${1:-5.2.0-SNAPSHOT}
docker pull entando/appbuilder:$VERSION
docker pull entando/entando-eap71-quickstart-openshift:$VERSION
