#!/usr/bin/env bash
source $(dirname $0)/common.sh
echo "This script installs the Entando Sample project on the EAP 7.1 QuickStart image with a persistent embedded Derby database"
#oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-quickstart-openshift.json
#oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/appbuilder.json
oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-eap71-quickstart.yml \
  -p APPLICATION_NAME="entando-sample" \
  -p IMAGE_STREAM_NAMESPACE=entando \
  -p ENTANDO_RUNTIME_HOSTNAME_HTTP="entando-core.$(get_openshift_subdomain)" \
  -p ENTANDO_WEB_CONTEXT="entando-sample" \
  -p SOURCE_REPOSITORY_URL="https://github.com/ampie/entando-sample.git" \
  | oc replace --force -f -
