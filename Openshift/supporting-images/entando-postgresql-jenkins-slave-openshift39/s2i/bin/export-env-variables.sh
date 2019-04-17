#!/usr/bin/env bash
IFS=$'\n' EXPORTS=($1)
IFS=' '
echo "Entando-specific exports=${EXPORTS[*]}"
export ${EXPORTS[*]}