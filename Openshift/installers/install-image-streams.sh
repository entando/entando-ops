#!/usr/bin/env bash
# the installers in this directory only work if the Openshift namespace 'entando' contains all the predefined images
IMAGE_STREAM_DIR=../image-streams
NAMESPACE=${1:-entando}
echo $NAMESPACE
oc create -f ${IMAGE_STREAM_DIR}/entando-eap71-clustered-openshift.json -n ${NAMESPACE}
#oc create -f ${IMAGE_STREAM_DIR}/entando-eap71-imagick-openshift.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-eap71-quickstart-openshift.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-fsi-ccd-demo.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-postgresql95-openshift.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-wildfly12-quickstart-openshift.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-maven-jenkins-slave-openshift39.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-postgresql-jenkins-slave-openshift39.json -n ${NAMESPACE}
