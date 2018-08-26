#!/usr/bin/env bash
export VERSION=${1:-5.0.1-SNAPSHOT}
cd /tmp
rm -Rf entando
mvn archetype:generate -DgroupId=org.entando -DartifactId=entando \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-web-app-BPM \
  -DarchetypeVersion=$VERSION -DinteractiveMode=false -DarchetypeCatalog=remote
cd entando
mvn jetty:run 2>&1 > db_creation.log &
JETTY_PID=$!
echo "jetty: $JETTY_PID"
START_SUCCESS="false"
for i in {1..900} ;
    do sleep 2 && tail db_creation.log -n 20;
    if fgrep --quiet "BUILD FAILURE" db_creation.log; then
      exit 1
    fi
    if fgrep --quiet "Started Jetty Server" db_creation.log; then
      echo "Jetty started" &&  kill $JETTY_PID
      START_SUCCESS="true"
      break
    fi;
done;
if [ $START_SUCCESS = "false" ]; then
  exit 1
fi
cd target/derby/production
tar zcvf entando-derby-template.tar.gz .
mvn deploy:deploy-file -DgroupId=org.entando -DartifactId=entando-derby-template -Dversion=$VERSION \
    -Dpackaging=tar.gz -DrepositoryId=nexus-snapshot -Dfile=entando-derby-template.tar.gz \
    -Durl=https://repository.entando.org/repository/maven-snapshots/
