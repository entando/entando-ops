cp settings-entando.xml $HOME/.m2/settings.xml -f
mvn archetype:generate -DgroupId=org.sample -DartifactId=sample \
  -DarchetypeGroupId=org.entando.entando -DarchetypeArtifactId=entando-archetype-webapp-generic -DarchetypeVersion=$1 \
  -DinteractiveMode=false
cp pom-$1.xml sample/pom.xml -f
cp filter-postgresql.properties sample/src/main/filters/filter-postgresql.properties
cd sample
mvn jetty:run -Ppostgresql 2>&1 > db_creation.log &
jetty_pid=$!
echo "jetty: $jetty_pid"
for i in {1..900} ;
    do sleep 2 && tail db_creation.log -n 20;
    if fgrep --quiet "BUILD FAILURE" db_creation.log; then
      exit 1
    fi
    if fgrep --quiet "Started Jetty Server" db_creation.log; then
      echo "Jetty started" &&  kill $jetty_pid
      cd ..  && rm sample -r
      chmod -Rf ug+rw $HOME/.m2 && chown -Rf 26:root $HOME/.m2
      find $HOME/.m2 -name "_remote.repositories" -type f -delete
      cp settings-secure.xml $HOME/.m2/settings.xml -f
      exit 0
    fi;
done;
exit 1

