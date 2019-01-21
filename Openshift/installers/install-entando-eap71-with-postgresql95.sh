#!/usr/bin/env bash
source $(dirname $BASH_SOURCE[0])/common.sh
echo "This script installs the Entando Sample project on Entando, EAP 7.1  and PostgreSQL 9.5"
validate_environment
APPLICATION_NAME=${APPLICATION_NAME:-"entando-eap-with-postgresql"}
recreate_project ${APPLICATION_NAME}
ensure_image_stream "entando-eap71-clustered-openshift"
ensure_image_stream "entando-postgresql95-openshift"
ensure_image_stream "appbuilder"

function recreate_postgresql_secret(){
    echo "Creating Postgresql secret."
    export DATABASE_PASSWORD=$(openssl rand -base64 20)
    oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-secret.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p SECRET_NAME="${APPLICATION_NAME}-db-secret" \
            -p USERNAME="agile" \
            -p PASSWORD="${DATABASE_PASSWORD}" \
            | oc replace --force --grace-period 60  -f -

}

function recreate_kie_secret(){
    #Just a place holder for when we may want to instantiate PAM here. We'll probably generate passwords then too
    echo "Creating KIEServer secret."
    cat <<EOF | oc replace --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: "${APPLICATION_NAME}-kieserver-secret"
stringData:
  url: "http://${APPLICATION_NAME}-kieserver.${OPENSHIFT_PROJECT}.svc:8080"
  username: "pamAdmin"
  password: "redhatpam1!"
EOF

}


function dump_passwords(){
    echo "Dumping generated passwords to passwords.txt"
    rm passwords.txt 2> /dev/null
    cat <<EOT >>passwords.txt
DATABASE_PASSWORD=$DATABASE_PASSWORD
EOT

}
function recreate_source_secret(){
    echo "Creating the SCM source secret."
    oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-secret.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p SECRET_NAME="${APPLICATION_NAME}-source-secret" \
        | oc replace --force --grace-period 60  -f -
}
function recreate_jgroups_secret(){
    oc process -f $ENTANDO_OPS_HOME/Openshift/templates/sample-jgroups-secret.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p SECRET_NAME="${APPLICATION_NAME}-app-secret" \
        | oc replace --force --grace-period 60  -f -

}
function recreate_secrets_and_linked_service_accounts() {
    recreate_jgroups_secret
    recreate_postgresql_secret
    recreate_kie_secret
    recreate_source_secret
    dump_passwords
}

function recreate_entando_application(){
    echo "Recreating Entando 5 Application config." 2> /dev/null
    oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-eap71-with-postgresql95.yml \
            -p APPLICATION_NAME="${APPLICATION_NAME}" \
            -p IMAGE_STREAM_NAMESPACE="${IMAGE_STREAM_NAMESPACE}" \
            -p ENTANDO_IMAGE_STREAM_TAG="${ENTANDO_IMAGE_STREAM_TAG}" \
            -p SOURCE_REPOSITORY_REF="${SOURCE_REPOSITORY_REF}" \
            -p SOURCE_REPOSITORY_URL="https://github.com/entando/entando-sample-minimal.git" \
            -p KIE_SERVER_SECRET="${APPLICATION_NAME}-kieserver-secret" \
            -p DB_SECRET="${APPLICATION_NAME}-db-secret" \
            -p SOURCE_SECRET="${APPLICATION_NAME}-source-secret" \
            -p ENTANDO_PORT_DATABASE="entandoPortDb" \
            -p ENTANDO_SERV_DATABASE="entandoServDb" \
            -p ENTANDO_ENGINE_SECURE_HOSTNAME="secure-${APPLICATION_NAME}-engine.${OPENSHIFT_DOMAIN_SUFFIX}" \
            -p ENTANDO_ENGINE_HOSTNAME="${APPLICATION_NAME}-engine.${OPENSHIFT_DOMAIN_SUFFIX}" \
            -p ENTANDO_ENGINE_WEB_CONTEXT="/entando-sample-minimal" \
            -p ENTANDO_ENGINE_BASEURL="http://${APPLICATION_NAME}-engine.${OPENSHIFT_DOMAIN_SUFFIX}/entando-sample-minimal" \
            -p JGROUPS_ENCRYPT_SECRET="${APPLICATION_NAME}-app-secret" \
            -p JGROUPS_ENCRYPT_NAME="jgroups" \
            -p ENTANDO_APP_BUILDER_HOSTNAME="${APPLICATION_NAME}-appbuilder.${OPENSHIFT_DOMAIN_SUFFIX}" \
        |  oc replace --force --grace-period 60  -f -
}

recreate_secrets_and_linked_service_accounts
recreate_entando_application


if [ "${TEST_DEPLOYMENT}" = true ]; then
    test_deployment "${APPLICATION_NAME}-postgresql,${APPLICATION_NAME}-engine" "${APPLICATION_NAME}-appbuilder" "${ENTANDO_IMAGE_STREAM_TAG}"
    if [ "${DESTROY_DEPLOYMENT}" = true ]; then
        oc delete project ${APPLICATION_NAME}
    fi
fi