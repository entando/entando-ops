#!/usr/bin/env bash
source $(dirname $BASH_SOURCE[0])/common.sh "$@"
echo "This script installs the Demo PAM App on the EAP 7.1 QuickStart image with a persistent embedded Derby database"
validate_environment
APPLICATION_NAME=${APPLICATION_NAME:-"entando-pam-demo-app"}
recreate_project ${APPLICATION_NAME}
ensure_image_stream "entando-eap71-quickstart-openshift"
ensure_image_stream "appbuilder"
oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-eap71-quickstart.yml \
        -p APPLICATION_NAME="${APPLICATION_NAME}" \
        -p IMAGE_STREAM_NAMESPACE="${IMAGE_STREAM_NAMESPACE}" \
        -p ENTANDO_IMAGE_VERSION="${ENTANDO_IMAGE_VERSION}" \
        -p SOURCE_REPOSITORY_REF="master" \
#        -p SOURCE_REPOSITORY_REF="${SOURCE_REPOSITORY_REF}" \
        -p SOURCE_REPOSITORY_URL="https://github.com/joewhite101/entando-pam-demo-app.git" \
        -p KIE_SERVER_BASE_URL="https://secure-rhpam7-cc-dispute-kieserver-rhpam7-cc-dispute-en701.apps.serv.run/" \
        -p KIE_SERVER_USERNAME="kieUser" \
        -p KIE_SERVER_PASSWORD="kieUser!23" \
        -p ENTANDO_ENGINE_HOSTNAME="${APPLICATION_NAME}-engine.${OPENSHIFT_DOMAIN_SUFFIX}" \
        -p ENTANDO_APP_BUILDER_HOSTNAME="${APPLICATION_NAME}-appbuilder.${OPENSHIFT_DOMAIN_SUFFIX}" \
        -p ENTANDO_ENGINE_WEB_CONTEXT="/entando-pam-demo-app" \
  | oc replace --force -f -
