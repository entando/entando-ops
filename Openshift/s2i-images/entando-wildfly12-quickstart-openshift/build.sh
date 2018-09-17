#!/usr/bin/env bash
export VERSION=${1:-5.0.1-SNAPSHOT}
export ENTANDO_IMAGE="entando-wildfly12-quickstart-openshift"
source ../../../common/build-common.sh
