#!/bin/bash
MASTER_VERSION="5.2.0-SNAPSHOT"
if [ -n "${DOCKER_TAG}" ]; then
    if [ "$DOCKER_TAG" = "$MASTER_VERSION" ]; then
        APP_BUILDER_BRANCH="master"
        ENTANDO_COMPONENTS_BRANCH="master"
    else
        ENTANDO_VERSION=${DOCKER_TAG%-*}
        if [[ "$DOCKER_TAG" = *"-SNAPSHOT" ]]; then
        #use branches
            APP_BUILDER_BRANCH="v${ENTANDO_VERSION}-release"
            ENTANDO_COMPONENTS_BRANCH="v${ENTANDO_VERSION}-dev"
        else
        #use tags
            APP_BUILDER_BRANCH="v${ENTANDO_VERSION}"
            ENTANDO_COMPONENTS_BRANCH="v${ENTANDO_VERSION}"
        fi
    fi
    echo "APP_BUILDER_BRANCH=${APP_BUILDER_BRANCH}"
    echo "ENTANDO_COMPONENTS_BRANCH=${ENTANDO_COMPONENTS_BRANCH}"
    echo "DOCKERFILE_PATH=${DOCKERFILE_PATH}"
    echo "IMAGE_NAME=${IMAGE_NAME}"
    docker build --build-arg APP_BUILDER_BRANCH=${APP_BUILDER_BRANCH} \
        --build-arg ENTANDO_COMPONENTS_BRANCH=${ENTANDO_COMPONENTS_BRANCH}  \
        --build-arg DIGITAL_EXCHANGE_UI_ENABLED=${DIGITAL_EXCHANGE_UI_ENABLED} \
        -f $DOCKERFILE_PATH -t $IMAGE_NAME .
else
    env
    echo "DOCKER_TAG NOT SET!!!!"
    exit 1
fi
