#!/usr/bin/env bash
cd /tmp/
BRANCH=$($(dirname ${BASH_SOURCE[0]})/determine-branch.sh)
echo "BRANCH = $BRANCH"

curl -L "https://github.com/entando/fsi-cc-dispute-customer/archive/${BRANCH}.zip" -o fsi-cc-dispute-customer.zip
unzip fsi-cc-dispute-customer.zip
pushd fsi-cc-dispute-customer-*
if mvn clean package -Dproject.build.sourceEncoding=UTF-8 ; then
      find $HOME/.m2 -name "_remote.repositories" -type f -delete
      find $HOME/.m2 -name "entando*SNAPSHOT*" -type f -delete
      find $HOME/.m2 -name "*.lastUpdated" -type f -delete
      find $HOME/.m2 -name "resolver-status.properties" -type f -delete
      popd
    #Keep the image lean:
      rm -Rf fsi-cc-dispute-customer-*
      echo "Dependency init succeeded"
      exit 0
else
      echo "Dependency init failed"
      exit 1
fi
