#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
IMAGES_IN_SEQUENCE="entando-sample-full engine-api appbuilder appbuilder-with-digital-exchange postgresql mysql"
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    echo "########## Pushing $D ###########"
    docker pull entando/$D:$VERSION || exit 1
done




