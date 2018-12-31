#!/usr/bin/env bash
IMAGES_IN_SEQUENCE=$(cat IMAGES_IN_SEQUENCE)
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    pushd $D
    echo $D
#    ./build.sh $1
    popd
done
