#!/usr/bin/env bash
export VERSION=${1:-5.0.1-SNAPSHOT}
export ENTANDO_IMAGE="entando-jenkins-slave-openshift39"
source ../../../common/build-common.sh
