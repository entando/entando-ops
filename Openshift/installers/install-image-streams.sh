#!/usr/bin/env bash
# the installers in this directory only work if the Openshift namespace 'entando' contains all the predefined images
IMAGE_STREAM_DIR=$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))/image-streams
echo $IMAGE_STREAM_DIR
NAMESPACE=${1:-entando}
echo $NAMESPACE
oc delete is entando-eap71-clustered-openshift -n ${NAMESPACE}
oc delete is entando-eap71-quickstart-openshift -n ${NAMESPACE}
oc delete is fsi-cc-dispute-customer -n ${NAMESPACE}
oc delete is fsi-cc-dispute-admin  -n ${NAMESPACE}
oc delete is entando-postgresql95-openshift -n ${NAMESPACE}
oc delete is entando-wildfly12-quickstart-openshift -n ${NAMESPACE}
oc delete is entando-maven-jenkins-slave-openshift39  -n ${NAMESPACE}
oc delete is entando-postgresql-jenkins-slave-openshift39 -n ${NAMESPACE}
oc delete is entando-sample-full -n ${NAMESPACE}
sleep 2
oc create -f ${IMAGE_STREAM_DIR}/entando-eap71-clustered-openshift.json -n ${NAMESPACE}
#oc create -f ${IMAGE_STREAM_DIR}/entando-eap71-imagick-openshift.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-eap71-quickstart-openshift.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-fsi-ccd-demo.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-postgresql95-openshift.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-wildfly12-quickstart-openshift.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-maven-jenkins-slave-openshift39.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-postgresql-jenkins-slave-openshift39.json -n ${NAMESPACE}
oc create -f ${IMAGE_STREAM_DIR}/entando-sample-full.json -n ${NAMESPACE}
