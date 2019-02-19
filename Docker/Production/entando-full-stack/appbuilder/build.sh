#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
export ENTANDO_IMAGE="appbuilder"
export DIGITAL_EXCHANGE_UI_ENABLED=false
source ../../../../common/build-common.sh
export ENTANDO_IMAGE="appbuilder-with-digital-exchange"
export DIGITAL_EXCHANGE_UI_ENABLED=true
source ../../../../common/build-common.sh
