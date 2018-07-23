#!/usr/bin/env bash

cp settings-entando.xml $HOME/.m2/settings.xml -f

git clone --branch v$1-ampie https://github.com/ampie/entando-archetypes.git
pushd entando-archetypes
mvn clean install archetype:update-local-catalog -DskipTests
popd
rm entando-archetypes -rf


git clone --branch v$1-ampie https://github.com/ampie/entando-core.git
pushd entando-core
mvn clean install -DskipTests
popd
rm entando-core -rf

git clone --branch v$1-ampie https://github.com/ampie/entando-components.git
pushd entando-components
mvn clean install -DskipTests
popd
rm entando-components -rf


mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=$1 \
  -DinteractiveMode=false -DarchetypeCatalog=local
cp pom-$1.xml sample/pom.xml -f
cp -rf filters/* sample/src/main/filters/
pushd sample
mvn package -Popenshift
if [ $? -ne 0 ]; then
    exit 1
fi
popd
rm sample -rf
chmod -Rf ug+rw $HOME/.m2 && chown -Rf 1001:root $HOME/.m2
find $HOME/.m2 -name "_remote.repositories" -type f -delete
cp settings-secure.xml $HOME/.m2/settings.xml -f
