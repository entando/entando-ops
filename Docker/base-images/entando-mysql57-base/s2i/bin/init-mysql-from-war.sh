#!/usr/bin/env bash

export PORTDB_URL="jdbc:mysql://localhost:3306/${PORTDB_DATABASE}"
export SERVDB_URL="jdbc:mysql://localhost:3306/${SERVDB_DATABASE}"
export PORTDB_DRIVER="mysql"
export SERVDB_DRIVER="mysql"
$(dirname ${BASH_SOURCE[0]})/start-mysql-and-wait.sh
if ${ENTANDO_COMMON_PATH}/init-db-from-war.sh "$@" ;  then
    mysqld stop
    echo "copying from:"
    ls -al $HOME/data/
    mv $HOME/data $HOME/data_template
    mkdir $HOME/data
    echo "copy result:"
    ls -al $HOME/data_template/

    /usr/libexec/fix-permissions $HOME/data_template
    /usr/libexec/fix-permissions $HOME/data
    /usr/libexec/fix-permissions /etc/my.cnf.d/
    rm  /var/lib/mysql/mysql.sock.lock
    rm * -rf
    echo "MySQL Database preparation successful"
    echo $(date +%s) > $HOME/data_template/build_id
    exit 0
else
    echo "MySQL Database preparation failed"
    exit 1
fi
