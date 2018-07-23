#!/usr/bin/env bash

source /opt/rh/rh-maven35/enable
cp settings-entando.xml $HOME/.m2/settings.xml -f

curl https://github.com/ampie/entando-archetypes/archive/v$1-ampie.zip -L -o entando-archetypes.zip
unzip -q entando-archetypes.zip
pushd entando-archetypes-$1-ampie
mvn clean install archetype:update-local-catalog -DskipTests
popd
rm entando-archetypes-$1-ampie -rf

curl https://github.com/ampie/entando-core/archive/v$1-ampie.zip -L -o entando-core.zip
unzip -q entando-core.zip
pushd entando-core-$1-ampie
mvn clean install -DskipTests
popd
rm entando-core-$1-ampie -rf

curl https://github.com/ampie/entando-components/archive/v$1-ampie.zip -L -o entando-components.zip
unzip -q entando-components.zip
pushd entando-components-$1-ampie
mvn clean install -DskipTests
popd
rm entando-components-$1-ampie -rf


mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=$1 \
  -DinteractiveMode=false -DarchetypeCatalog=local
cp pom-$1.xml sample/pom.xml -f
cp -rf filters/* sample/src/main/filters/
pushd sample

#Minimize .m2 size
mv $HOME/.m2/repository/org/entando $HOME/.m2/
rm $HOME/.m2/repository/* -rf
mkdir $HOME/.m2/repository/org
mv $HOME/.m2/entando $HOME/.m2/repository/org/

mvn package -Popenshift
if [ $? -ne 0 ]; then
    exit 1
fi
popd
rm *.zip -f
rm sample -rf
chmod -Rf ug+rw $HOME/.m2 && chown -Rf 185:root $HOME/.m2
find $HOME/.m2 -name "_remote.repositories" -type f -delete
cp settings-secure.xml $HOME/.m2/settings.xml -f
