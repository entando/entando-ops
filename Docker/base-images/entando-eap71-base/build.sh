#!/usr/bin/env bash
export VERSION=${1:-5.0.1-SNAPSHOT}
export ENTANDO_IMAGE="entando-eap71-base"

#potential common util:
export DOCKER_TAG=$VERSION
export DOCKER_REPO="127.0.0.1:5000/entando/$ENTANDO_IMAGE"
export IMAGE_NAME="$DOCKER_REPO:$VERSION"
export DOCKERFILE_PATH="$(dirname ${BASH_SOURCE[0]})/Dockerfile"
./hooks/build
if [ $? -eq 0 ]; then
    docker login -u $(oc whoami) -p $(oc whoami -t) 127.0.0.1:5000
    ./hooks/post_push
else
    echo "Docker build failed"
fi