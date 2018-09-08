#!/usr/bin/env bash
source $(dirname $0)/common.sh
echo "This script installs the Entando Sample project on the EAP 7.1 QuickStart image with a persistent embedded Derby database"
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-quickstart-openshift.json
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/appbuilder.json
oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-eap71-quickstart.yml \
  -p APPLICATION_NAME="entando-sample" \
  -p IMAGE_STREAM_NAMESPACE="$(oc project -q)" \
  -p ENTANDO_RUNTIME_HOSTNAME_HTTP="entando-core.$(get_openshift_subdomain)" \
  -p SOURCE_REPOSITORY_URL="https://github.com/ampie/fsi-cc-dispute-customer.git" \
  -p CONTEXT_DIR="entando-5.0/fsi-credit-card-dispute/fsi-cc-dispute-customer" \
  -p SOURCE_REPOSITORY_REF="v5.0.1-SNAPSHOT" \
  | oc replace --force -f -
