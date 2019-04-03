#!/usr/bin/env bash
#OPENSHIFT_REGISTRY=${LOCAL_OPENSHIFT_REGISTRY:-127.0.0.1:5000}
#This utility is only to be used on local development machines and will never be executed in Docker's Cloud infrastructure
if [ -n "${BASH_SOURCE[1]}" ]; then
    if   [ -n "$ENTANDO_IMAGE" ] && [ -n "$VERSION" ]  ; then
        DOCKER_BUILD_DIR=$(realpath $(dirname ${BASH_SOURCE[1]}))
        echo "build-common.sh sourced from $DOCKER_BUILD_DIR"
        export DOCKER_TAG=$VERSION
        export DOCKER_REPO="entando/$ENTANDO_IMAGE"
        export IMAGE_NAME="$DOCKER_REPO:$VERSION"
        export DOCKERFILE_PATH="$DOCKER_BUILD_DIR/Dockerfile"

        echo "Running Docker build from $DOCKER_BUILD_DIR"
        echo "DOCKER_TAG=${DOCKER_TAG}"
        if [ -n "${DOCKER_TAG}" ]; then
            if [ -f $DOCKER_BUILD_DIR/custom-docker-build.sh ]; then
                $DOCKER_BUILD_DIR/custom-docker-build.sh &> "$DOCKER_BUILD_DIR/$ENTANDO_IMAGE-docker-build.log" || exit 2
            else
                docker build --build-arg ENTANDO_VERSION=${DOCKER_TAG} --build-arg ENTANDO_IMAGE_VERSION=${DOCKER_TAG} \
                   --build-arg MAVEN_MIRROR_FOR_DOCKER_BUILDS="${MAVEN_MIRROR_FOR_DOCKER_BUILDS}" \
                   -f $DOCKERFILE_PATH -t $IMAGE_NAME .  &> "$DOCKER_BUILD_DIR/$ENTANDO_IMAGE-docker-build.log" || exit 2
            fi
        else
            env
            echo "DOCKER_TAG NOT SET!!!!"
            exit 1
        fi

        if [ $? -eq 0 ]; then
            echo "Docker build successful"
            LATEST_VERSION=$(cat $(dirname $(realpath ${BASH_SOURCE[0]}))/VERSION_TO_TAG_AS_LATEST)
            if [ "$VERSION" = "$LATEST_VERSION" ]; then
                echo "Tagging entando/$ENTANDO_IMAGE:latest"
                docker tag "entando/$ENTANDO_IMAGE:$VERSION" "entando/$ENTANDO_IMAGE:latest"
            fi
            if [ -n "$OPENSHIFT_REGISTRY" ]; then
                #Now push to locally forwarded port (easiest way to get access to Openshift registry)
                export DOCKER_REPO="$OPENSHIFT_REGISTRY/$DOCKER_REPO"
                #TODO move this to where we test it.
                echo "Pushing $DOCKER_REPO:$DOCKER_TAG to the Openshift registry"
                docker tag $IMAGE_NAME "$DOCKER_REPO:$DOCKER_TAG"
                docker push "$DOCKER_REPO:$DOCKER_TAG"
                echo "Removing the local tag $DOCKER_REPO:$DOCKER_TAG"
                docker rmi "$DOCKER_REPO:$DOCKER_TAG"
                echo "Removing local tag $DOCKER_REPO:latest if present"
                docker rmi "$DOCKER_REPO:latest" &> /dev/null || true
            fi
        else
            echo "Docker build failed"
            exit 3
        fi
    else
        echo "ERROR: please export the desired ENTANDO_IMAGE and VERSION variables"
        exit 4
    fi
else
    echo "ERROR: build-common.sh has to be invoked using the 'source build-common.sh' style invokation"
    exit 5
fi
