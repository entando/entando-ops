#!/usr/bin/env bash
export VERSION=${1:-5.0.3-SNAPSHOT}
IMAGES_IN_SEQUENCE="engine-api appbuilder entando-sample-full postgresql"
for D in ${IMAGES_IN_SEQUENCE[@]}; do
    echo "########## Pushing $D ###########"
    docker push entando/$D:$VERSION || exit 1
done




