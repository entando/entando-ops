#!/usr/bin/env bash
export GIT_COMMITTER_NAME=Ampie
export GIT_COMMITTER_EMAIL=a.barnard@entando.com

mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=$1 \
  -DinteractiveMode=false --settings settings.xml -Dmaven.repo.local=$HOME/.m2/repository
cp pom-$1.xml sample/pom.xml -f
cp -rf *.properties sample/src/main/filters/
pushd sample
#Minimize .m2 size
rm -rf $HOME/.m2/repository/*
mvn package -Popenshift --settings ../settings.xml -Dmaven.repo.local=$HOME/.m2/repository
if [ $? -ne 0 ]; then
    exit 1
fi
popd
rm -rf sample
find $HOME/.m2 -name "_remote.repositories" -type f -delete
find $HOME/.m2 -name "*.lastUpdated" -type f -delete
chmod -Rf ug+rw $HOME/.m2 && chown -Rf 185:root $HOME/.m2
