#!/usr/bin/env bash
export GIT_COMMITTER_NAME=Ampie
export GIT_COMMITTER_EMAIL=a.barnard@entando.com
#git clone --branch v$1-ampie https://github.com/ampie/entando-core.git
#pushd entando-core
#mvn clean install -DskipTests --settings ../settings.xml
#popd
#
#git clone --branch v$1-ampie https://github.com/ampie/entando-components.git
#pushd entando-components
#mvn clean install -DskipTests --settings ../settings.xml
#popd
#
#git clone --branch v$1-ampie https://github.com/ampie/entando-archetypes.git
#pushd entando-archetypes
#mvn clean install -DskipTests archetype:update-local-catalog --settings ../settings.xml
#popd

mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=$1 \
  -DinteractiveMode=false --settings settings.xml -Dmaven.repo.local=$HOME/.m2/repository
#  -DarchetypeCatalog=local
cp pom-$1.xml sample/pom.xml -f
cp filter-openshift.properties sample/src/main/filters/filter-openshift.properties
pushd sample
mvn package -Popenshift --settings ../settings.xml -Dmaven.repo.local=$HOME/.m2/repository -DskipTests
popd
rm -rf entando*
rm -rf sample
find $HOME/.m2 -name "_remote.repositories" -type f -delete
find $HOME/.m2 -name "*.lastUpdated" -type f -delete
chmod -Rf ug+rw $HOME/.m2
echo "HOME=$HOME"