#!/usr/bin/env bash
export PORTDB_URL="jdbc:postgresql://localhost:5432/${PORTDB_DATABASE}"
export SERVDB_URL="jdbc:postgresql://localhost:5432/${SERVDB_DATABASE}"
export PORTDB_DRIVER="postgresql"
export SERVDB_DRIVER="postgresql"
$(dirname ${BASH_SOURCE[0]})/start-pg-and-wait.sh
if $(dirname ${BASH_SOURCE[0]})/init-db.sh ; then
    pg_ctl stop -D /$HOME/data/userdata
    cp $HOME/data/* $HOME/data_template/ -Rf
    rm $HOME/data_template/userdata/postmaster.pid
    /usr/libexec/fix-permissions $HOME/data_template
    /usr/libexec/fix-permissions $HOME/openshift-custom-postgresql.conf
    /usr/libexec/fix-permissions $HOME/passwd
    rm /var/run/postgresql/.s.PGSQL*
    rm /var/lib/pgsql/pg_startup.log
    rm /tmp/.s.PGSQL*
    rm * -rf
    echo "PostgreSQL Database preparation successful"
    exit 0
else
    echo "PostgreSQL Database preparation failed"
    exit 1
fi
