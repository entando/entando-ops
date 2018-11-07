#!/usr/bin/env bash
cd /tmp/
mkdir default-entando-project
cd default-entando-project
echo "ENTANDO_VERSION = $ENTANDO_VERSION"
mvn archetype:generate -B --settings $HOME/.m2/settings.xml \
        -Dfilter=entando \
        -DarchetypeGroupId=org.entando.entando \
        -DarchetypeArtifactId=entando-archetype-web-app-BPM \
        -DarchetypeVersion="${ENTANDO_VERSION}" \
        -DgroupId=org.entando \
        -DartifactId=entando \
        -Dversion=1.0 \
        -Dpackage=org.entando


if [ -f "/tmp/pom-$ENTANDO_VERSION.xml" ]; then
  echo "Using pom-$ENTANDO_VERSION.xml"
  rm entando/pom.xml
  mv /tmp/pom-$ENTANDO_VERSION.xml entando/pom.xml
fi
pushd entando
rm -rf ${HOME}/.m2/repository/*
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
  rm -Rf entando
  echo "DB init succeeded"
  exit 0
else
  echo "DB init failed"
  exit 1
fi
