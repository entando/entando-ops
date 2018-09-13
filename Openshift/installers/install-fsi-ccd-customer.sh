#!/usr/bin/env bash
export ENTANDO_OPS_HOME="https://raw.githubusercontent.com/entando/entando-ops/EN-1928"

function get_openshift_subdomain(){
  if [ -x $(command  -v minishift) ]; then
    PUBLIC_HOSTNAME=$(minishift config get public-hostname)
    if [ $PUBLIC_HOSTNAME == "<nil>" ]; then
      PUBLIC_HOSTNAME=$(minishift openshift config view | grep -oP "(?<=  subdomain: )[0-9\.a-zA-Z_\-]+")
      if [ -z $PUBLIC_HOSTNAME ]; then
        echo "$(minishift ip).nip.io"
      else
        echo $PUBLIC_HOSTNAME
      fi
    else
      echo $PUBLIC_HOSTNAME
    fi
  elif [ -f  /etc/origin/master/master-config.yaml  ]; then
    PUBLIC_HOSTNAME=$(sudo cat /etc/origin/master/master-config.yaml | grep -oP "(?<=  subdomain: )[0-9\.a-zA-Z_\-]+")
    if [[ -z $PUBLIC_HOSTNAME ]]; then
      echo "$(hostname -i).nip.io"
    else
      echo $PUBLIC_HOSTNAME
    fi
  else
     >&2 echo "Neither Minishift nor the Openshift master-config.yml found. Are you running from a node with an Openshift installation?"
     echo "COULD_NOT_RESOLVE_OS_SUBDOMAIN"
  fi
}
echo "This script installs the Entando Sample project on the EAP 7.1 QuickStart image with a persistent embedded Derby database"
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/entando-eap71-quickstart-openshift.json
oc replace --force -f $ENTANDO_OPS_HOME/Openshift/image-streams/appbuilder.json
oc process -f $ENTANDO_OPS_HOME/Openshift/templates/entando-eap71-quickstart.yml \
  -p APPLICATION_NAME="entando-sample" \
  -p IMAGE_STREAM_NAMESPACE="$(oc project -q)" \
  -p ENTANDO_RUNTIME_HOSTNAME_HTTP="entando-core.$(get_openshift_subdomain)" \
  -p SOURCE_REPOSITORY_URL="https://github.com/ampie/fsi-cc-dispute-customer.git" \
  -p CONTEXT_DIR="entando-5.0/fsi-credit-card-dispute/fsi-cc-dispute-customer" \
  -p SOURCE_REPOSITORY_REF="master" \
  | oc replace --force -f -
