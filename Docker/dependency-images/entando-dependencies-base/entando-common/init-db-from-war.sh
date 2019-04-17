#!/usr/bin/env bash
#NB!!! This file is copied from common/s2i in the Docker build hook. Only modify the original file!
source $(dirname ${BASH_SOURCE[0]})/translate-jboss-variables.sh
source $(dirname ${BASH_SOURCE[0]})/build-jetty-command.sh "$@"
$JETTY_COMMAND  &> db_creation.log &
export JETTY_PID=$(echo $!)
echo "JETTY_PID=${JETTY_PID}"
sleep 3
tail -f db_creation.log &
for i in {1..720}
do
    sleep 1
    if [[ -f db_creation.log ]] &&  fgrep --quiet "oejs.Server:main: Started" "db_creation.log" ; then
    # Attempt killing Jetty only AFTER waiting for it to terminate
        (echo "Waiting for Jetty process [$JETTY_PID] to shut down"; sleep 3; ps; kill -9 ${JETTY_PID}; ps) &
        wait ${JETTY_PID}
        if fgrep --quiet "java.util.ConcurrentModificationException" "db_creation.log"  || fgrep --quiet "java.lang.ArrayIndexOutOfBoundsException" "db_creation.log"  ; then
            mv db_creation.log db_creation_conccurency_exception.log
            $JETTY_COMMAND  &> db_creation.log &
            export JETTY_PID=$(echo $!)
            echo "Restarting Jetty due to intermittent ConcurrentModificationException or ArrayIndexOutOfBoundsException. JETTY_PID=${JETTY_PID}"
            sleep 3
            tail -f db_creation.log &
        else
            if [[ -d "./protected/databaseBackups/develop/portDataSource" ]]; then
              echo "An Entando backup was detected. Please verify that your data has been restored."
            fi
            echo "Jetty started and database created."
            popd
            rm -Rf /tmp/entando-db-build
            rm -Rf /tmp/entando-indices
            rm -Rf /tmp/entando-logs
            exit 0
        fi
    fi
done
echo "BUILD TIMED OUT!!!!!"
exit 1
