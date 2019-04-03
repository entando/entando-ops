#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
export ENTANDO_IMAGE="entando-maven-jenkins-agent-openshift311"
source ../../../common/build-common.sh

