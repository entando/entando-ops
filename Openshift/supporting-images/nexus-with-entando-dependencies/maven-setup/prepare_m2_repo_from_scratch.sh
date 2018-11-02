#!/usr/bin/env bash
export JAVA_HOME=/etc/alternatives/java_sdk
pushd $HOME
bin/nexus run 2>&1 > nexus.log &
nexus_pid=$!
echo "nexus: $nexus_pid"
for i in {1..900} ;
    do sleep 2 && tail nexus.log -n 20;
    if fgrep --quiet "Started Sonatype Nexus OSS 3" nexus.log; then
      echo "Nexus started"
      break
    fi;
done;
popd
cp settings.xml $HOME/.m2/settings.xml -f

git clone --branch v$1-ampie https://github.com/ampie/entando-core.git
pushd entando-core
mvn clean deploy -DskipTests -Dmaven-repository-url-release=http://localhost:8081/repository/maven-releases
popd

git clone --branch v$1-ampie https://github.com/ampie/entando-components.git
pushd entando-components
mvn clean deploy -DskipTests -Dmaven-repository-url-release=http://localhost:8081/repository/maven-releases
popd

git clone --branch v$1-ampie https://github.com/ampie/entando-archetypes.git
pushd entando-archetypes
mvn clean deploy -DskipTests
popd

mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=$1 \
  -DinteractiveMode=false
cp pom-$1.xml sample/pom.xml -f
cp filter-openshift.properties sample/src/main/filters/filter-openshift.properties
pushd sample
mvn package jetty:run -Popenshift  2>&1 > db_creation.log &
JETTY_PID=$!
echo "jetty: $JETTY_PID"
for i in {1..900} ;
    do sleep 2 && tail db_creation.log -n 20;
    if fgrep --quiet "BUILD FAILURE" db_creation.log; then
      exit 1
    fi
    if fgrep --quiet "Started Jetty Server" db_creation.log; then
        echo "Jetty started" &&  kill $JETTY_PID
        popd  && rm sample -r
        rm -rf $HOME/.m2
        rm -rf entando*
        cp -rf /nexus-data/* /nexus-data-template/
        chmod -Rf ug+rw /nexus-data-template/
        chown -Rf 200:root /nexus-data-template/
        exit 0
    fi;
done;
exit 1
