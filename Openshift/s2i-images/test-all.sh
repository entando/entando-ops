#!/usr/bin/env bash

if [ -n "$OPENSHIFT_REGISTRY" ]; then
    INSTALLER_DIR=$(realpath $(dirname $(realpath ${BASH_SOURCE[0]}))/../installers)
    export TEST_DEPLOYMENT=true
    export DESTROY_DEPLOYMENT=true
    ${INSTALLER_DIR}/install-entando-eap71-quickstart.sh || { echo "Entando EAP 7.1 Quickstart Openshift test failed"; exit 1; }
    ${INSTALLER_DIR}/install-entando-wildfly12-quickstart.sh || { echo "Entando Wildfly 12 Quickstart Openshift test failed"; exit 1; }
    ${INSTALLER_DIR}/install-entando-eap71-with-postgresql95.sh || { echo "Entando EAP 7.1/Postgresql 9.5  Openshift test failed"; exit 1; }
else
    echo "S2I images have no direct tests yet. Please configure Openshift connectivity"
fi
