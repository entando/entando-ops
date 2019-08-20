#!/usr/bin/env bash
export VERSION=${1:-5.2.0-SNAPSHOT}
IMAGES_IN_SEQUENCE=$(cat IMAGES_IN_SEQUENCE)
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    pushd $D
    echo "########## Building $D ###########"
    ./build.sh $VERSION || { echo "Exiting build for $D because of result code $?"; exit 1; }
    popd
done
