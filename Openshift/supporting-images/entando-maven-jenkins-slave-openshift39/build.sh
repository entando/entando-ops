#!/usr/bin/env bash
export VERSION=${1:-5.0.2-SNAPSHOT}
export ENTANDO_IMAGE="entando-maven-jenkins-slave-openshift39"
source ../../../common/build-common.sh
oc patch istag ${ENTANDO_IMAGE}:${VERSION} -p '{"tag":{"referencePolicy":{"type":"Local"}}}'
oc annotate istag ${ENTANDO_IMAGE}:${VERSION} --overwrite role=jenkins-slave slave-label=entando-maven-${VERSION} -n entando

