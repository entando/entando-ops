#!/usr/bin/env bash
export APPLICATION_NAME=entando-central

function prepare_redhat_route(){
  if [ -f $(dirname $0)/$1.conf ]; then
    source $(dirname $0)/$1.conf
  else
    echo "$1 config file not found. Expected file: $(dirname $0)/$1.conf)"
    exit -1
  fi
  echo "Creating the Red Hat route for $1: ${APPLICATION_NAME}, ${ENGINE_API_DOMAIN}"
  cat <<EOF | oc replace -n "${APPLICATION_NAME}-$1" --force --grace-period 60 -f -
apiVersion: v1
kind: Route
metadata:
  name: ${APPLICATION_NAME}-redhat-route
  labels:
    application: "${APPLICATION_NAME}"
spec:
  host: redhat.${ENGINE_API_DOMAIN}
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
function setup_entando_pipeline(){
  ./setup-entando-pipeline.sh $COMMAND --application-name=${APPLICATION_NAME}

}
if [[ $1 =~ -.* ]]; then
  echo "The first argument should be one of create/delete"
  exit -1
else
  COMMAND=$1
  shift
fi


case $COMMAND in
  populate)
    prepare_redhat_route stage
    prepare_redhat_route prod
  ;;
  clear)
      oc delete secrets -l application=${APPLICATION_NAME} -n ${APPLICATION_NAME}-prod
  ;;
esac
setup_entando_pipeline
