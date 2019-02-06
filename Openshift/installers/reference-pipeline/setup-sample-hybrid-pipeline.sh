#!/usr/bin/env bash
export APPLICATION_NAME=entando-sample-full

function setup_entando_pipeline(){
  $(dirname $BASH_SOURCE[0])/setup-entando-pipeline.sh $COMMAND --application-name=${APPLICATION_NAME} --config-dir=entando-sample-full-conf --image-promotion-only
}

COMMAND=$1
shift


case $COMMAND in
  populate)
    setup_entando_pipeline
  ;;
  *)
    setup_entando_pipeline
  ;;
esac
