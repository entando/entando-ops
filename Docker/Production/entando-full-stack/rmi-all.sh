#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
IMAGES_IN_SEQUENCE=(entando-sample-full engine-api appbuilder mysql postgresql)
for (( idx=${#IMAGES_IN_SEQUENCE[@]}-1 ; idx>=0 ; idx-- )) ; do
    D="${IMAGES_IN_SEQUENCE[idx]}"
    echo "########## Removing $D ###########"
    docker rmi entando/$D:$VERSION -f || exit 1
done




