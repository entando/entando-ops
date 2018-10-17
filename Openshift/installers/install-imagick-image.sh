#!/usr/bin/env bash
source $(dirname $0)/common.sh
echo "This script installs the Entando Imagick Image stream. project on the Wildfly 12 QuickStart image with a persistent embedded Derby database"
  if [ -n "${REDHAT_REGISTRY_USERNAME}" ]; then
    oc delete secret base-image-registry-secret 2>/dev/null
    oc create secret docker-registry base-image-registry-secret \
        --docker-server=registry.connect.redhat.com \
        --docker-username=${REDHAT_REGISTRY_USERNAME} \
        --docker-password=${REDHAT_REGISTRY_PASSWORD} \
        --docker-email=${REDHAT_REGISTRY_USERNAME}
#    oc label secret base-image-registry-secret application=entando-central
  else
    echo "Please set the REDHAT_REGISTRY_USERNAME and REDHAT_REGISTRY_PASSWORD variables so that the image can be retrieved from the secure Red Hat registry"
    exit -1
  fi
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-openshift.json
