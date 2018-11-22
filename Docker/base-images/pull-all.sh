#!/usr/bin/env bash
export VERSION=${1:-5.0.2-SNAPSHOT}
docker pull entando/entando-dependencies-base:$VERSION
docker pull entando/entando-eap71-base:$VERSION
docker pull entando/entando-wildfly12-base:$VERSION
docker pull entando/entando-postgresql95-base:$VERSION


