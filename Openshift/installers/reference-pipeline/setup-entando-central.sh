#!/usr/bin/env bash
export APPLICATION_NAME=entando-central

function prepare_redhat_route(){
  if [ -f $(dirname $0)/$1.conf ]; then
    source $(dirname $0)/$1.conf
  else
    echo "$1 config file not found. Expected file: $(dirname $0)/$1.conf)"
    exit -1
  fi
  echo "Creating the Red Hat route for $1: ${APPLICATION_NAME}, ${ENTANDO_ENGINE_SECURE_HOSTNAME}"
  cat <<EOF | oc replace -n "${APPLICATION_NAME}-$1" --force --grace-period 60 -f -
apiVersion: v1
kind: Route
metadata:
  name: ${APPLICATION_NAME}-redhat-route
  labels:
    application: "${APPLICATION_NAME}"
spec:
  host: ${REDHAT_ENTANDO_ENGINE_HOSTNAME}
  port:
    targetPort: 8080
  tls:
    termination: edge
  to:
    kind: Service
    name: ${APPLICATION_NAME}
    weight: 100
  wildcardPolicy: None
EOF
}
function create_bitbucket_webhook_secret(){
  WEB_HOOK_SECRET_KEY=$(date +%s | sha256sum | base64 | head -c 16)
  cat <<EOF | oc replace -n "${APPLICATION_NAME}-build" --force --grace-period 60 -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${APPLICATION_NAME}-webhook-secret
  labels:
    application: "${APPLICATION_NAME}"
stringData:
  WebHookSecretKey: "$WEB_HOOK_SECRET_KEY"
EOF
  oc patch bc ${APPLICATION_NAME}-jenkins-pipeline -n "${APPLICATION_NAME}-build" --patch '{"spec":{"triggers":[{"type":"Bitbucket","bitbucket":{"secretReference":{"name":"entando-central-webhook-secret"}}}]}}'
  echo $WEB_HOOK_SECRET_KEY >> webhook.key

}

function setup_entando_pipeline(){
  $(dirname $BASH_SOURCE[0])/setup-entando-pipeline.sh $COMMAND --application-name=${APPLICATION_NAME} --config-dir=entando-central-conf
}

COMMAND=$1
shift


case $COMMAND in
  populate)
    setup_entando_pipeline
    setup-entando-pipeline.sh log-into-stage
    create_bitbucket_webhook_secret
    prepare_redhat_route stage
    setup-entando-pipeline.sh log-into-prod
    prepare_redhat_route prod
  ;;
  *)
    setup_entando_pipeline
  ;;
esac
