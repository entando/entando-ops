#!/usr/bin/env bash
source $(dirname $BASH_SOURCE[0])/common.sh
echo "This script installs the FSI Credit Card Dispute Demo Template on the EAP 7.1 QuickStart image with persistent embedded Derby databases"
validate_environment
APPLICATION_NAME=${APPLICATION_NAME:-"entando-fsi-ccd-demos-template"}
recreate_project ${APPLICATION_NAME}
ensure_image_stream "fsi-cc-dispute-customer"
ensure_image_stream "fsi-cc-dispute-admin"
ensure_image_stream "appbuilder"

oc process -f $ENTANDO_OPS_HOME/Openshift/templates/fsi-ccd-demo.yml \
    -p APPLICATION_NAME="${APPLICATION_NAME}" \
    -p KIE_SERVER_BASE_URL="http://rhpam7-install-kieserver-rhpam7-install-entando.apps.serv.run" \
    -p KIE_SERVER_USERNAME="kieserver" \
    -p KIE_SERVER_PASSWORD="kieserver1!" \
    -p IMAGE_STREAM_NAMESPACE="entando" \
    -p ADMIN_APP_BUILDER_HOSTNAME="${APPLICATION_NAME}-appbuilder-admin.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p ADMIN_ENTANDO_ENGINE_HOSTNAME="${APPLICATION_NAME}-engine-admin.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p CUSTOMER_APP_BUILDER_HOSTNAME="${APPLICATION_NAME}-appbuilder-customer.${OPENSHIFT_DOMAIN_SUFFIX}" \
    -p CUSTOMER_ENTANDO_ENGINE_HOSTNAME="${APPLICATION_NAME}-engine-customer.${OPENSHIFT_DOMAIN_SUFFIX}" \
  | oc replace --force -f -

if [ "${TEST_DEPLOYMENT}" = true ]; then
    test_deployment "${APPLICATION_NAME}-ccd-admin-engine,${APPLICATION_NAME}-ccd-customer-engine" "${APPLICATION_NAME}-ccd-admin-appbuilder,${APPLICATION_NAME}-ccd-customer-appbuilder" "${ENTANDO_IMAGE_VERSION}"
    if [ "${DESTROY_DEPLOYMENT}" = true ]; then
        oc delete project ${APPLICATION_NAME}
    fi
fi