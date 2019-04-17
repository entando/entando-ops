#!/bin/bash
#TODO set a variable somewhere that tells this script whether or not local portforwarding is on or not
export LOCAL_PORT=5432
export LOCAL_HOST=127.0.0.1

set -e

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