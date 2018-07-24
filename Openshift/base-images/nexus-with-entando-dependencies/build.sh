#!/usr/bin/env bash
export VERSION=${1:-5.0.1}
echo $VERSION
#docker build --build-arg ENTANDO_VERSION=$VERSION -t entando/entando-fabric8s2i-eap-71:$VERSION .
docker build -t entando/nexus-with-entando-dependencies:$VERSION -t 172.30.1.1:5000/entando/nexus-with-entando-dependencies:$VERSION .
docker push 172.30.1.1:5000/entando/nexus-with-entando-dependencies:$VERSION
