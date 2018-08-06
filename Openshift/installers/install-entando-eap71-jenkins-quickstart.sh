#!/usr/bin/env bash
source $(dirname $0)/common.sh

echo "This script installs the Entando Sample project on the EAP 7.1 QuickStart image with a persistent embedded Derby database using a Jenkins Slave image"
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-quickstart-openshift.json
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-jenkins-slave-openshift39.json
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/app-builder-openshift.json
oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-eap71-jenkins-quickstart.yml \
  -p APPLICATION_NAME="entando-sample" \
  -p IMAGE_STREAM_NAMESPACE="$(oc project -q)" \
  -p ENTANDO_RUNTIME_HOSTNAME_HTTP="entando-core.$(get_openshift_subdomain)" \
  | oc replace --force -f -