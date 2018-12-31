#!/usr/bin/env bash
cd /tmp/
echo "ENTANDO_VERSION = $ENTANDO_VERSION"
BRANCH=${ENTANDO_VERSION%-*}
if [[ "$ENTANDO_VERSION" = *"-SNAPSHOT" ]]; then
#use bnranch
    BRANCH="${BRANCH}-dev"
else
#use tag
    BRANCH="${BRANCH}"
fi
echo "BRANCH = $BRANCH"

curl -L "https://github.com/entando/fsi-cc-dispute-customer/archive/v${BRANCH}.zip" -o fsi-cc-dispute-customer.zip
unzip fsi-cc-dispute-customer.zip
pushd fsi-cc-dispute-customer-${BRANCH}
if $(dirname ${BASH_SOURCE[0]})/init-db.sh ; then
  find $HOME/.m2 -name "_remote.repositories" -type f -delete
  find $HOME/.m2 -name "*.lastUpdated" -type f -delete
  find $HOME/.m2 -name "resolver-status.properties" -type f -delete
  echo "Fixing M2 permissions ..."
  chown -Rf $USERID_TO_USE:0 ${HOME}/.m2
  chmod -Rf ug+rw ${HOME}/.m2
  ls -al ${HOME}/.m2/repository
  popd
#Keep the image lean:
  rm -Rf fsi-cc-dispute-customer-${BRANCH}
  echo "DB init succeeded"
  exit 0
else
  echo "DB init failed"
  exit 1
fi
