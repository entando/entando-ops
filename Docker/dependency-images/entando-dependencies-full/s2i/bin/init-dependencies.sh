#!/usr/bin/env bash
cd /tmp/
echo "ENTANDO_VERSION = $ENTANDO_VERSION"
BRANCH=$($(dirname ${BASH_SOURCE[0]})/determine-branch.sh)
echo "BRANCH = $BRANCH"

curl -L "https://github.com/entando/entando-sample-full/archive/${BRANCH}.zip" -o entando-sample-full.zip
unzip entando-sample-full.zip
pushd entando-sample-full-*
if mvn clean package -Dproject.build.sourceEncoding=UTF-8  ; then
  find $HOME/.m2 -name "entando*SNAPSHOT*" -type f -delete
  find $HOME/.m2 -name "_remote.repositories" -type f -delete
  find $HOME/.m2 -name "*.lastUpdated" -type f -delete
  find $HOME/.m2 -name "resolver-status.properties" -type f -delete
  popd
#Keep the image lean:
  rm -Rf entando-sample-full-*
  echo "Dependency init succeeded"
  exit 0
else
  echo "Dependency init failed"
  exit 1
fi
