#!/usr/bin/env bash
#OPENSHIFT_REGISTRY=${LOCAL_OPENSHIFT_REGISTRY:-127.0.0.1:5000}
#This utility is only to be used on local developmentmore machines and will never be executed in Docker's Cloud infrastructure
if [ -n "${BASH_SOURCE[1]}" ]; then
    if   [ -n "$ENTANDO_IMAGE" ] && [ -n "$VERSION" ]  ; then
        DOCKER_BUILD_DIR=$(realpath $(dirname ${BASH_SOURCE[1]}))
        echo "build-common.sh sourced from $DOCKER_BUILD_DIR"
        export DOCKER_TAG=$VERSION
        export DOCKER_REPO="entando/$ENTANDO_IMAGE"
        export IMAGE_NAME="$DOCKER_REPO:$VERSION"
        export DOCKERFILE_PATH="$DOCKER_BUILD_DIR/Dockerfile"
        $DOCKER_BUILD_DIR/hooks/build docker &> $DOCKER_BUILD_DIR/docker-build.log || exit 2
        if [ $? -eq 0 ]; then
            echo "Docker build successful"
            if [ "$PUSH_TO_DOCKER_HUB" = true ]; then
                docker push "$DOCKER_REPO:$DOCKER_TAG"
            fi
            LATEST_VERSION=$(cat $(dirname $(realpath ${BASH_SOURCE[0]}))/hooks/VERSION_TO_TAG_AS_LATEST)
            #If we are building the latest release branch, tag as latest. This would usually be done in post_push but when running on
            # our own infrastructure we don't have a post_push callback
            if [ "$VERSION" = "$LATEST_VERSION" ]; then
                echo "Tagging entando/$ENTANDO_IMAGE:latest"
                docker tag "entando/$ENTANDO_IMAGE:$VERSION" "entando/$ENTANDO_IMAGE:latest"
                if [ "$PUSH_TO_DOCKER_HUB" = true ]; then
                    docker push "entando/$ENTANDO_IMAGE:latest"
                fi
            fi
            if [ -n "$OPENSHIFT_REGISTRY" ]; then
                #Now push to locally forwarded port (easiest way to get access to Openshift registry)
                docker login -u $(oc whoami) -p $(oc whoami -t) $OPENSHIFT_REGISTRY
                export DOCKER_REPO="$OPENSHIFT_REGISTRY/$DOCKER_REPO"

                echo "Pushing $DOCKER_REPO:$DOCKER_TAG to local registry"
                docker tag $IMAGE_NAME "$DOCKER_REPO:$DOCKER_TAG"
                docker push "$DOCKER_REPO:$DOCKER_TAG"
                echo "Removing the local tag $DOCKER_REPO:$DOCKER_TAG"
                docker rmi "$DOCKER_REPO:$DOCKER_TAG"

                echo "Optionally tagging and pushing $DOCKER_REPO:latest"
                $DOCKER_BUILD_DIR/hooks/post_push # this is more to just test that post_push works, testing it against Openshift's docker registry
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
