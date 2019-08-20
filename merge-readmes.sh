#!/usr/bin/env bash
export VERSION=${1:-5.2.0-SNAPSHOT}
OPS_ROOT=$(realpath .)
IMAGE_GROUPS_IN_SEQUENCE=$(cat IMAGE_GROUPS_IN_SEQUENCE)
for G in ${IMAGE_GROUPS_IN_SEQUENCE[@]}; do
    pushd $G
    echo "################## Merging README's for  $G ###################"
        IMAGES_IN_SEQUENCE=$(cat IMAGES_IN_SEQUENCE)
        for D in ${IMAGES_IN_SEQUENCE[@]}; do
            pushd $D
            echo "########## Merging README's for $D ###########"
            cat $OPS_ROOT/common/adoc-variables.adoc README-base.adoc > README.adoc
            popd
        done
    popd
done
