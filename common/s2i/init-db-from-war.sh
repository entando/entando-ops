#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
for i in "$@"
do
  case $i in
    --jetty-version=*)
      JETTY_VERSION="${i#*=}"
      shift # past argument=value
    ;;
    --war-file=*)
      WAR_FILE="${i#*=}"
      shift # past argument=value
    ;;
    *)
    echo "Unknown option: $i"
    exit -1
  esac
done
#Ensure that a JETTY_VERSION is set, and that the associated JAR file is in the jetty-runner directory
if [ -z "$JETTY_VERSION" ]; then
  case $ENTANDO_VERSION in
    5.0.2*)
      JETTY_VERSION=9.4.8.v20180619
    ;;
    5.0.3*)
      JETTY_VERSION=9.4.8.v20180619
    ;;
    *)
      JETTY_VERSION=9.4.8.v20180619
    ;;
  esac
fi

if [[ -z $WAR_FILE ]]; then
  echo "No WAR file specified"
  exit 1
fi
mkdir -p /tmp/entando-db-build
pushd /tmp/entando-db-build

#Copy resources and backups to the place that the WAR file expects them to be
jar -xf $WAR_FILE
cp -Rf resources /entando-data/
cp -Rf protected /entando-data/

#Copy all the apache commons jars across to support database connection pools in Jetty. This allows for the jetty.xml to be generic.
mkdir commons-lib
cp WEB-INF/lib/commons*.jar commons-lib/

cp /jetty-runner/jetty.xml .
jetty_command="java \
    -Ddb.startup.check=true \
    -Ddb.restore.enabled=true \
    -Dprofile.datasource.jndiname.servdb=${SERVDB_JNDI} \
    -Dprofile.datasource.jndiname.portdb=${PORTDB_JNDI} \
    -Dprofile.database.url.portdb=${PORTDB_URL} \
    -Dprofile.database.url.servdb=${SERVDB_URL} \
    -Dprofile.database.username.portdb=${PORTDB_USERNAME} \
    -Dprofile.database.username.servdb=${SERVDB_USERNAME} \
    -Dprofile.database.password.portdb=${PORTDB_PASSWORD} \
    -Dprofile.database.password.servdb=${SERVDB_PASSWORD} \
    -Dprofile.database.driverClassName=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh $PORTDB_DRIVER) \
    -Dprofile.portDataSourceClassName=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh $PORTDB_DRIVER) \
    -Dprofile.servDataSourceClassName=$($(dirname ${BASH_SOURCE[0]})/determine-driver.sh $SERVDB_DRIVER) \
    -jar /jetty-runner/jetty-runner-${JETTY_VERSION}.jar \
    --lib /jetty-runner \
    --lib /tmp/entando-db-build/commons-lib \
    jetty.xml"
$jetty_command  &> db_creation.log &
export JETTY_PID=$(echo $!)
echo "JETTY_PID=${JETTY_PID}"
sleep 3
tail -f db_creation.log &
for i in {1..360}
do
    sleep 1
    if [[ -f db_creation.log ]] &&  fgrep --quiet "oejs.Server:main: Started" "db_creation.log" ; then
        if [[ -d "./protected/databaseBackups/develop/portDataSource" ]]; then
          echo "An Entando backup was detected. Please verify that your data has been restored."
        fi
        echo "Jetty started and database created."
# Attempt killing Jetty only AFTER waiting for it to terminate
        (echo "Waiting for Jetty process [$JETTY_PID] to shut down"; sleep 3; ps; kill -9 ${JETTY_PID}; ps) &
        wait ${JETTY_PID}
        popd
        rm -Rf /tmp/entando-db-build
        exit 0
    fi
done
echo "BUILD TIMED OUT!!!!!"
exit 1
