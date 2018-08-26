#!/usr/bin/env bash
export GIT_COMMITTER_NAME=Ampie
export GIT_COMMITTER_EMAIL=a.barnard@entando.com

mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-web-app-BPM -DarchetypeVersion=$1 \
  -DinteractiveMode=false --settings $HOME/.m2/settings.xml -Dmaven.repo.local=$HOME/.m2/repository

pushd sample
#Minimize .m2 size
rm -rf $HOME/.m2/repository/*
mvn package --settings $HOME/.m2/settings.xml -Dmaven.repo.local=$HOME/.m2/repository
if [ $? -ne 0 ]; then
    exit 1
fi
popd
rm -rf sample
find $HOME/.m2 -name "_remote.repositories" -type f -delete
find $HOME/.m2 -name "*.lastUpdated" -type f -delete
find $HOME/.m2 -name "resolver-status.properties" -type f -delete
chmod -Rf ug+rw $HOME/.m2 && chown -Rf 1001:root $HOME/.m2
