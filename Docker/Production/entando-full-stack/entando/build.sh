#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
export ENTANDO_IMAGE="engine-api"
source ../../../../common/build-common.sh
export ENTANDO_IMAGE="entando-sample-full"
source ../../../../common/build-common.sh
