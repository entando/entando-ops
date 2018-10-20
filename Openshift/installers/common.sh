#!/usr/bin/env bash
export ENTANDO_OPS_HOME=/home/lulu/Code/entando/entando-ops
#export ENTANDO_OPS_HOME="https://raw.githubusercontent.com/entando/entando-ops/credit-card-dispute"

function get_openshift_subdomain(){
  if [ -n "${OPENSHIFT_DOMAIN_SUFFIX}" ]; then
    echo "${OPENSHIFT_DOMAIN_SUFFIX}"
  elif command  -v minishift ; then
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

function echo_header() {
    echo
    echo "########################################################################"
    echo $1
    echo "########################################################################"
}
