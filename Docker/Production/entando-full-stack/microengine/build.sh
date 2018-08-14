#!/usr/bin/env bash
echo "BASH_SOURCE=$BASH_SOURCE"
export VERSION=${1:-5.0.1-SNAPSHOT}
echo $VERSION
export DOCKER_TAG=$VERSION
export IMAGE_NAME="entando/microengine:$VERSION"
export DOCKERFILE_PATH="$(dirname $0)/Dockerfile"
source hooks/build
#docker push 172.30.1.1:5000/entando/microengine:$VERSION
