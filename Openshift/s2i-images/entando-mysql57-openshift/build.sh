#!/usr/bin/env bash
export VERSION=${1:-5.2.0-SNAPSHOT}
export ENTANDO_IMAGE="entando-mysql57-openshift"
source ../../../common/build-common.sh
