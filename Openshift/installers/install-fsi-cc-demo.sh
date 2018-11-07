#!/usr/bin/env bash
#export ENTANDO_OPS_HOME="https://raw.githubusercontent.com/entando/entando-ops/EN-1928"
export ENTANDO_OPS_HOME="../../"
export OPENSHIFT_DOMAIN_SUFFIX="192.168.0.100.nip.io"
echo "This script installs the Entando Sample project on the EAP 7.1 QuickStart image with a persistent embedded Derby database"
#oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-quickstart-openshift.json
#oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/appbuilder.json
oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-demo.yml \
    -p APPLICATION_NAME="entando-fsi-ccd-customer" \
    -p KIE_SERVER_BASE_URL="http://aaaric-ccd-rhpam701-entando-kieserver.apps.dev.ldcloud.com.au" \
    -p KIE_SERVER_USERNAME="kieUser" \
    -p KIE_SERVER_PASSWORD="kieUser!23" \
    -p IMAGE_STREAM_NAMESPACE="entando" \
    -p IMAGE_STREAM="fsi-cc-dispute-customer" \
    -p ENTANDO_APP_BUILDER_HOSTNAME_HTTP="appbuilder-customer.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p ENTANDO_RUNTIME_HOSTNAME_HTTP="entando-core.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p ENTANDO_WEB_CONTEXT="fsi-credit-card-dispute-customer" \
  | oc replace --force -f -

oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-demo.yml \
    -p APPLICATION_NAME="entando-fsi-ccd-admin" \
    -p KIE_SERVER_BASE_URL="http://aaaric-ccd-rhpam701-entando-kieserver.apps.dev.ldcloud.com.au" \
    -p KIE_SERVER_USERNAME="kieUser" \
    -p KIE_SERVER_PASSWORD="kieUser!23" \
    -p IMAGE_STREAM_NAMESPACE="entando" \
    -p IMAGE_STREAM="fsi-cc-dispute-admin" \
    -p ENTANDO_APP_BUILDER_HOSTNAME_HTTP="appbuilder-admin.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p ENTANDO_RUNTIME_HOSTNAME_HTTP="entando-core.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p ENTANDO_WEB_CONTEXT="fsi-credit-card-dispute-backoffice" \
  | oc replace --force -f -
