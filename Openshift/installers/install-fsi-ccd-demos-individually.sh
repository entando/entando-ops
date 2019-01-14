#!/usr/bin/env bash
source $(dirname $BASH_SOURCE[0])/common.sh
echo "This script installs the FSI Credit Card Dispute Demo Projects on the EAP 7.1 QuickStart image with persistent embedded Derby databases"
validate_environment
APPLICATION_NAME=${APPLICATION_NAME:-"entando-fsi-ccd-demos-inidividually"}
recreate_project ${APPLICATION_NAME}
ensure_image_stream "fsi-cc-dispute-customer"
ensure_image_stream "fsi-cc-dispute-admin"
ensure_image_stream "appbuilder"

oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-demo.yml \
    -p APPLICATION_NAME="entando-fsi-ccd-customer" \
    -p KIE_SERVER_BASE_URL="http://rhpam7-install-kieserver-rhpam7-install-entando.apps.serv.run" \
    -p KIE_SERVER_USERNAME="kieserver" \
    -p KIE_SERVER_PASSWORD="kieserver1!" \
    -p IMAGE_STREAM_NAMESPACE="entando" \
    -p DEMO_IMAGE_STREAM="fsi-cc-dispute-customer" \
    -p ENTANDO_APP_BUILDER_HOSTNAME="${APPLICATION_NAME}-appbuilder-customer.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p ENTANDO_ENGINE_HOSTNAME="${APPLICATION_NAME}-engine-customer.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p ENTANDO_ENGINE_WEB_CONTEXT="/fsi-credit-card-dispute-customer" \
  | oc replace --force -f -

oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-demo.yml \
    -p APPLICATION_NAME="entando-fsi-ccd-admin" \
    -p KIE_SERVER_BASE_URL="http://rhpam7-install-kieserver-rhpam7-install-entando.apps.serv.run" \
    -p KIE_SERVER_USERNAME="kieserver" \
    -p KIE_SERVER_PASSWORD="kieserver1!" \
    -p IMAGE_STREAM_NAMESPACE="entando" \
    -p DEMO_IMAGE_STREAM="fsi-cc-dispute-admin" \
    -p ENTANDO_APP_BUILDER_HOSTNAME="${APPLICATION_NAME}-appbuilder-admin.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p ENTANDO_ENGINE_HOSTNAME="${APPLICATION_NAME}-engine-admin.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p ENTANDO_ENGINE_WEB_CONTEXT="/fsi-credit-card-dispute-backoffice" \
  | oc replace --force -f -
