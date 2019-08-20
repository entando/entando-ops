#!/usr/bin/env bash
export VERSION=${1:-5.2.0-SNAPSHOT}
IMAGE_GROUPS_IN_SEQUENCE=$(cat IMAGE_GROUPS_IN_SEQUENCE)
for D in ${IMAGE_GROUPS_IN_SEQUENCE[@]}; do
    pushd $D
    echo "################## Pulling $D ###################"
    ./pull-all.sh $VERSION
    popd
done
