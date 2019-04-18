#!/usr/bin/env bash
function export_variables(){
  VARS="$(echo $1 | grep -v ^# | xargs -d '\n' | xargs)"
  echo "Entando Exports: $VARS"
  export $VARS
}

function export_env_files(){
  if [ -v ENV_FILES  ] && [ -n "${ENV_FILES}" ]; then
    IFS=","  read -ra ENV_FILES_ARG <<< "$ENV_FILES"
    for f in "${ENV_FILES_ARG[@]}"
    do
      export_variables "$(cat $f)"
    done
  fi
}

function get_var_name(){
  VARNAME="${1}_${2}"
  if ! [ -v ${VARNAME} ] ; then
    echo "Variable ${VARNAME} not found!" >&2
    env |grep ${VARNAME}>&2
    exit -1
  fi
  echo $VARNAME
}

function get_db_prefix_array(){
  DATABASES=${DATASOURCES:-PORTDB,SERVDB}
  IFS=',' ARR=($DATABASES)
  echo ${ARR[*]}
}
