#!/usr/bin/env bash
source $(dirname $BASH_SOURCE[0])/common.sh "$@"
echo "This script installs the Entando Full Stack Sample project image with a persistent embedded Derby database"
#validate_environment
export APPLICATION_NAME=${APPLICATION_NAME:-"entando-full-stack"}
#recreate_project ${APPLICATION_NAME}
#ensure_image_stream "entando-sample-full"
#ensure_image_stream "appbuilder"

#oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-full-stack.yml \
#        -p APPLICATION_NAME="${APPLICATION_NAME}" \
#        -p IMAGE_STREAM_NAMESPACE="${IMAGE_STREAM_NAMESPACE}" \
#        -p ENTANDO_IMAGE_VERSION="${ENTANDO_IMAGE_VERSION}" \
#        -p ENTANDO_ENGINE_HOSTNAME="${APPLICATION_NAME}-engine.${OPENSHIFT_DOMAIN_SUFFIX}" \
#        -p ENTANDO_APP_BUILDER_HOSTNAME="${APPLICATION_NAME}-appbuilder.${OPENSHIFT_DOMAIN_SUFFIX}" \
#    | oc replace --force -f -

if [ "${TEST_DEPLOYMENT}" = true ]; then
    test_deployment --engine-routes=${APPLICATION_NAME}-engine-http --appbuilder-routes=${APPLICATION_NAME}-appbuilder
    if [ "${DESTROY_DEPLOYMENT}" = true ]; then
        oc delete project ${APPLICATION_NAME}
    fi
fi
