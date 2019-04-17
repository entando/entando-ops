#!/bin/bash
#TODO set a variable somewhere that tells this script whether or not local portforwarding is on or not
export LOCAL_PORT=3306
export LOCAL_HOST=127.0.0.1

set -e
rm my.cnf &>/dev/null || true
cat <<EOT >> my.cnf
[client]
user = ${ADMIN_USERNAME}
password = ${ADMIN_PASSWORD}
EOT
chmod 600 my.cnf
function get_db_prefix_array(){
    DATABASES=${DATASOURCES:-PORTDB,SERVDB}
    IFS=',' ARR=($DATABASES)
    echo ${ARR[*]}
}
function get_host_var(){
    if [ -f $(dirname ${BASH_SOURCE[0]})/forwarding.log ]; then
        echo LOCAL_HOST
    else
        VARNAME="${1}_SERVICE_HOST"
        if ! [ -v ${VARNAME} ] ; then
            echo "Variable ${VARNAME} not found!" >&2
            exit -1
        fi
        echo $VARNAME
    fi
}
function get_port_var(){
    if [ -f $(dirname ${BASH_SOURCE[0]})/forwarding.log ]; then
       echo LOCAL_PORT
    else
        VARNAME="${1}_SERVICE_PORT"
        if ! [ -v ${VARNAME} ] ; then
            echo "Variable ${VARNAME} not found!" >&2
            exit -1
        fi
        echo $VARNAME
    fi
}
function get_var_name(){
    VARNAME="${1}_${2}"
    if ! [ -v ${VARNAME} ] ; then
        echo "Variable ${VARNAME} not found!" >&2
        exit -1
    fi
    echo $VARNAME
}
function backup_db(){
    HOST_VAR=$(get_host_var $1)
    PORT_VAR=$(get_port_var $1)
    DATABASE_VAR=$(get_var_name ${1} DATABASE)
    rm -f ${!DATABASE_VAR}.sql
    mysqldump --defaults-extra-file=my.cnf -u ${ADMIN_USERNAME} -h ${!HOST_VAR} -P ${!PORT_VAR} ${!DATABASE_VAR} > ${!DATABASE_VAR}.sql
}

function restore_db(){
    HOST_VAR=$(get_host_var $1)
    PORT_VAR=$(get_port_var $1)
    DATABASE_VAR=$(get_var_name ${1} DATABASE)
    if [ -f "${!DATABASE_VAR}.sql" ]; then
        echo "Restoring ${!DATABASE_VAR} from ${!DATABASE_VAR}.sql"
        mysql --defaults-extra-file=my.cnf  -u ${ADMIN_USERNAME} -h ${!HOST_VAR} -P ${!PORT_VAR} ${!DATABASE_VAR} < ${!DATABASE_VAR}.sql
    else
        echo "ERROR: NO BACKUP FOUND FOR ${!DATABASE_VAR}"
    fi
}

function drop_db(){
    HOST_VAR=$(get_host_var $1)
    PORT_VAR=$(get_port_var $1)
    DATABASE_VAR=$(get_var_name ${1} DATABASE)
    mysql --defaults-extra-file=my.cnf -u ${ADMIN_USERNAME} -h ${!HOST_VAR} -P ${!PORT_VAR} -e "drop database ${!DATABASE_VAR}"
}

function create_db(){
    HOST_VAR=$(get_host_var $1)
    PORT_VAR=$(get_port_var $1)
    DATABASE_VAR=$(get_var_name ${1} DATABASE)
    USERNAME_VAR=$(get_var_name ${1} USERNAME)
    mysql --defaults-extra-file=my.cnf -u ${ADMIN_USERNAME} -h ${!HOST_VAR} -P ${!PORT_VAR} -e "create database ${!DATABASE_VAR}"
    mysql --defaults-extra-file=my.cnf -u ${ADMIN_USERNAME} -h ${!HOST_VAR} -P ${!PORT_VAR} -e "grant all privileges on ${!DATABASE_VAR}.* to '${!USERNAME_VAR}'@'%' ; flush privileges;"
}