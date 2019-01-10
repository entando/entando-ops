#!/usr/bin/env bash
source $(dirname $0)/common.sh
echo "This script installs the Entando Sample project on the Wildfly 12 QuickStart image with a persistent embedded Derby database"
#oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-wildfly12-quickstart-openshift.json
#oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/appbuilder.json
oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-wildfly12-quickstart.yml \
  -p APPLICATION_NAME="entando-sample" \
  -p IMAGE_STREAM_NAMESPACE="entando" \
  -p ENTANDO_ENGINE_HOSTNAME="entando-core.$(get_openshift_subdomain)" \
  -p ENTANDO_ENGINE_WEB_CONTEXT="/entando-sample" \
  | oc replace --force -f -
