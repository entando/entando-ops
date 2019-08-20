#!/usr/bin/env bash
export VERSION=${1:-5.2.0-SNAPSHOT}
IMAGES_IN_SEQUENCE=($(cat IMAGES_IN_SEQUENCE))
for (( idx=${#IMAGES_IN_SEQUENCE[@]}-1 ; idx>=0 ; idx-- )) ; do
    D="${IMAGES_IN_SEQUENCE[idx]}"
    echo "########## Removing $D ###########"
    docker rmi entando/$D:$VERSION -f || exit 1
done




