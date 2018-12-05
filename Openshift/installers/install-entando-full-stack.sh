#!/usr/bin/env bash
source $(dirname $0)/common.sh
echo "This script installs the Entando Full Stack Sample project image with a persistent embedded Derby database"
#oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-quickstart-openshift.json
#oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/appbuilder.json
oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-full-stack.yml \
  -p IMAGE_STREAM_NAMESPACE=entando \
  -p DOMAIN_SUFFIX="$(get_openshift_subdomain)" \
  | oc replace --force -f -
