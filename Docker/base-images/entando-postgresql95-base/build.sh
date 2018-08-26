#!/usr/bin/env bash
export VERSION=${1:-5.0.1-SNAPSHOT}
echo $VERSION
export DOCKER_TAG=$VERSION
export IMAGE_NAME="entando/entando-postgresql95-base:$VERSION"
export DOCKERFILE_PATH="$(dirname $0)/Dockerfile"
source hooks/build
if [ $? -eq 0 ]; then
    docker login -u $(oc whoami) -p $(oc whoami -t) 127.0.0.1:5000
    docker tag $IMAGE_NAME 127.0.0.1:5000/$IMAGE_NAME
    docker push 127.0.0.1:5000/$IMAGE_NAME
else
    echo "Docker build failed"
fi

