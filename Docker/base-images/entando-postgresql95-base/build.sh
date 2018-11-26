#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
export ENTANDO_IMAGE="entando-postgresql95-base"
source ../../../common/build-common.sh
