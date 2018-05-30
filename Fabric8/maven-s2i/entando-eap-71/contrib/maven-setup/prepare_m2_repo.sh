cp settings-entando.xml $HOME/.m2/settings.xml -f
mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=$1 \
  -DinteractiveMode=false
cp pom-$1.xml sample/pom.xml -f
cp filter-openshift.properties sample/src/main/filters/filter-openshift.properties
cd sample
mvn package -Popenshift
if [ $? -ne 0 ]; then
    exit 1
fi
cd ..  && rm sample -r
chmod -Rf ug+rw $HOME/.m2 && chown -Rf 185:root $HOME/.m2
find $HOME/.m2 -name "_remote.repositories" -type f -delete
cp settings-secure.xml $HOME/.m2/settings.xml -f
