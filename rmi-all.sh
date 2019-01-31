#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
IMAGE_GROUPS_IN_SEQUENCE=($(cat IMAGE_GROUPS_IN_SEQUENCE))
for (( idx=${#IMAGE_GROUPS_IN_SEQUENCE[@]}-1 ; idx>=0 ; idx-- )) ; do
    echo $idx
    D="${IMAGE_GROUPS_IN_SEQUENCE[idx]}"
    echo "################## Removing Images from $D ###################"
    pushd $D
    ./rmi-all.sh $VERSION
    popd
done
