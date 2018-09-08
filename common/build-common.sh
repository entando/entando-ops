#!/usr/bin/env bash
#This utility is only to be used on local machines and will never be executed in Docker's Cloud infrastructure
if [ -n "${BASH_SOURCE[1]}" ]; then
    if   [ -n "$ENTANDO_IMAGE" ] && [ -n "$VERSION" ]  ; then
        DOCKER_BUILD_DIR=$(realpath $(dirname ${BASH_SOURCE[1]}))
        echo "build-common.sh sourced from $DOCKER_BUILD_DIR"
        export DOCKER_TAG=$VERSION
        export DOCKER_REPO="entando/$ENTANDO_IMAGE"
        export IMAGE_NAME="$DOCKER_REPO:$VERSION"
        export DOCKERFILE_PATH="$DOCKER_BUILD_DIR/Dockerfile"
        $DOCKER_BUILD_DIR/hooks/build
        if [ $? -eq 0 ]; then
            #Now push to locally forwarded port (easiest way to get access to Openshift registry)
            docker login -u $(oc whoami) -p $(oc whoami -t) 127.0.0.1:5000
            export DOCKER_REPO="127.0.0.1:5000/$DOCKER_REPO"

            echo "Pushing $DOCKER_REPO:$DOCKER_TAG to local registry"
            docker tag $IMAGE_NAME "$DOCKER_REPO:$DOCKER_TAG"
            docker push "$DOCKER_REPO:$DOCKER_TAG"
            echo "Removing the local tag $DOCKER_REPO:$DOCKER_TAG"
            docker rmi "$DOCKER_REPO:$DOCKER_TAG"

            echo "Optionally tagging and pushing $DOCKER_REPO:latest"
            $DOCKER_BUILD_DIR/hooks/post_push

            LATEST_VERSION=$(cat $(dirname $(realpath ${BASH_SOURCE[0]}))/hooks/VERSION_TO_TAG_AS_LATEST)
            #If we are building the latest release branch, tag as latest
            if [ "$VERSION" = "$LATEST_VERSION" ]; then
                echo "Tagging entando/$ENTANDO_IMAGE:latest"
                docker tag "entando/$ENTANDO_IMAGE:$VERSION" "entando/$ENTANDO_IMAGE:latest"
                echo "Removing useless $DOCKER_REPO:$DOCKER_TAG tag"
                docker rmi "$DOCKER_REPO:latest"
            fi
        else
            echo "Docker build failed"
            exit 1
        fi
    else
        echo "ERROR: please export the desired ENTANDO_IMAGE and VERSION variables"
        exit 1
    fi
else
    echo "ERROR: build-common.sh has to be invoked using the 'source build-common.sh' style invokation"
    exit 1
fi