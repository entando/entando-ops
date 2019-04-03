#!/usr/bin/bash
WARS="$(dir $DEPLOYMENTS_DIR/*.war)"
for WAR in ${WARS[@]}; do
  $(dirname ${BASH_SOURCE[0]})/init-db-from-war.sh --war-file=$WAR
done

