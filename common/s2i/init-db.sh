#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
#Copies all directories across from $1/entando-data-templates to /entando-data-templates
#Does NOT initialize a derby database as this script should only be used in clustered environments
#deprecation considered as the database can be built from the WAR file and the resource files can be extracted from the WAR file too

#remove all previous Entando data from parent images
rm -Rf /entando-data-templates/* > /dev/null 2>&1

#Build the empty database and let 'mvn jetty:run' take care of any SQL file backups where they may exist.

#Hack into the pom to avoid the annotation scanning timeout that we tend to get in Docker builds. By default
#we scan all jar files but when building the DB only we don't have to scan any jar file
sed -i  '/\<webApp>/a <webInfIncludeJarPattern>nothing</webInfIncludeJarPattern>' pom.xml

if [ "$PORTDB_DRIVER" = "derby" ]; then
   if [ -d /entando-data/databases ]; then
   #Delete the old database entirely so that Entando can do a full restore
       rm -Rf /entando-data/databases/*
   else
       mkdir -p /entando-data/databases
   fi
fi
export MAVEN_OPTS="$MAVEN_OPTS -XX:MaxMetaspaceSize=350m"
mvn_command="mvn clean package jetty:run --settings $HOME/.m2/settings.xml \
    --batch-mode \
    $MAVEN_ARGS_APPEND \
    -DskipTests \
    -Dproject.build.sourceEncoding=UTF-8 \
    -Dmaven.repo.local=$HOME/.m2/repository \
    -Dprofile.config.version=production \
    -Dprofile.db.restore.enabled=true \
    -Denv.db.environment=develop \
    -Dprofile.database.username=${PORTDB_USERNAME} \
    -Dprofile.database.password=${PORTDB_PASSWORD} \
    -Dprofile.database.username.portdb=${PORTDB_USERNAME} \
    -Dprofile.database.password.portdb=${PORTDB_PASSWORD} \
    -Dprofile.database.username.servdb=${SERVDB_USERNAME} \
    -Dprofile.database.password.servdb=${SERVDB_PASSWORD} \
    -Dprofile.database.url.portdb=${PORTDB_URL} \
    -Dprofile.database.url.servdb=${SERVDB_URL} \
    -Dprofile.database.driverClassName=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh $PORTDB_DRIVER) \
    -Dprofile.portDataSourceClassName=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh $PORTDB_DRIVER) \
    -Dprofile.servDataSourceClassName=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh $SERVDB_DRIVER) \
    -Dprofile.resources.path=./src/main/webapp/resources \
    -Dprofile.resources.path.protected=./src/main/webapp/protected \
    -Dprofile.index.path=./target/temp/indexdir \
    -Dprofile.log.file.prefix=./target/build_log"
echo "executing $mvn_command "
$mvn_command  &> db_creation.log &
export JETTY_PID=$(echo $!)
echo "JETTY_PID=${JETTY_PID}"
tail -f db_creation.log &
for i in {1..360}
do
    sleep 15
    if fgrep --quiet "BUILD FAILURE" "db_creation.log"; then
      exit 1
    fi
    if fgrep --quiet "Started Jetty Server" "db_creation.log"
    then
        if [[ -d "src/main/webapp/protected/databaseBackups/develop/portDataSource" ]]; then
          echo "An Entando backup was detected. Please verify that your data has been restored."
        fi
        echo "Jetty started and database created."
# Attempt killing Jetty only AFTER waiting for it to terminate
        (echo "Waiting for Jetty process [$JETTY_PID] to shut down"; sleep 3; ps; kill -9 ${JETTY_PID}; ps) &
        wait ${JETTY_PID}
        if [ "$PORTDB_DRIVER" = "derby" ]; then
           echo "Copying newly generated DB to /entando-data-templates/"
   #Copy the new database across, overwriting the old database entirely. This ensures a full restore can be effected
            rm -Rf /entando-data-templates/databases > /dev/null 2>&1
            mkdir -p /entando-data-templates/databases/
            cp -Rf /entando-data/databases/* /entando-data-templates/databases/
            chmod -Rf ug+rw /entando-data-templates/databases/
            chown -Rf $USERID_TO_USE:0 /entando-data-templates/databases/
        fi
        exit 0
    fi
done
echo "BUILD TIMED OUT!!!!!"
exit 1
