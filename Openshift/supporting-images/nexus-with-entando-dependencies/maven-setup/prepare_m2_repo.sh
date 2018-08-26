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

mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-web-app-BPM -DarchetypeVersion=$1 \
  -DinteractiveMode=false
#cp filter-openshift.properties sample/src/main/filters/filter-openshift.properties
pushd sample
mvn package jetty:run 2>&1 > db_creation.log &
jetty_pid=$!
echo "jetty: $jetty_pid"
for i in {1..900} ;
    do sleep 2 && tail db_creation.log -n 20;
    if fgrep --quiet "BUILD FAILURE" db_creation.log; then
      exit 1
    fi
    if fgrep --quiet "Started Jetty Server" db_creation.log; then
        echo "Jetty started" &&  kill $jetty_pid
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
