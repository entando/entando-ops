#!/usr/bin/env bash



mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=$1 \
  -DinteractiveMode=false --settings settings.xml -Dmaven.repo.local=$HOME/.m2/repository
cp pom-$1.xml sample/pom.xml -f
cp -f *.properties sample/src/main/filters/
pushd sample
#reduce image size
rm -rf $HOME/.m2/repository/*
mvn jetty:run -Ppostgresql --settings ../settings.xml -Dmaven.repo.local=$HOME/.m2/repository  2>&1 > db_creation.log &
jetty_pid=$!
echo "jetty: $jetty_pid"
for i in {1..900} ;
    do sleep 2 && tail db_creation.log -n 20;
    if fgrep --quiet "BUILD FAILURE" db_creation.log; then
      exit 1
    fi
    if fgrep --quiet "Started Jetty Server" db_creation.log; then
      echo "Jetty started" &&  kill $jetty_pid
      popd
      rm -rf sample
      find $HOME/.m2 -name "_remote.repositories" -type f -delete
      find $HOME/.m2 -name "*.lastUpdated" -type f -delete
      chmod -Rf ug+rw $HOME/.m2 && chown -Rf 26:root $HOME/.m2
      exit 0
    fi;
done;
exit 1


