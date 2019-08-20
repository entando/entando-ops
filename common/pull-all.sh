#!/usr/bin/env bash
export VERSION=${1:-5.2.0-SNAPSHOT}
IMAGES_IN_SEQUENCE=$(cat IMAGES_IN_SEQUENCE)
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    pushd $D
    echo "########## Pulling $D ###########"
    docker pull entando/$D:$VERSION
    popd
done




