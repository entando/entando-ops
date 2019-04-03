#!/usr/bin/env bash

export PORTDB_URL="jdbc:postgresql://localhost:5432/${PORTDB_DATABASE}"
export SERVDB_URL="jdbc:postgresql://localhost:5432/${SERVDB_DATABASE}"
export PORTDB_DRIVER="postgresql"
export SERVDB_DRIVER="postgresql"
${STI_SCRIPTS_PATH}/start-pg-and-wait.sh
if ${ENTANDO_COMMON_PATH}/init-db-from-war.sh "$@" ;  then
    pg_ctl stop -D /$HOME/data/userdata
    echo "copying from:"
    ls -al $HOME/data/
    cp $HOME/data/ $HOME/data_template/ -Rf
    echo "copy result:"
    ls -al $HOME/data_template/

    rm $HOME/data_template/userdata/postmaster.pid
    /usr/libexec/fix-permissions $HOME/data_template
    /usr/libexec/fix-permissions $HOME/openshift-custom-postgresql.conf
    /usr/libexec/fix-permissions $HOME/passwd
    rm /var/run/postgresql/.s.PGSQL*
    rm /var/lib/pgsql/pg_startup.log
    rm /tmp/.s.PGSQL*
    rm * -rf
    echo "PostgreSQL Database preparation successful"
    echo $(date +%s) > $HOME/data_template/build_id
    exit 0
else
    echo "PostgreSQL Database preparation failed"
    exit 1
fi