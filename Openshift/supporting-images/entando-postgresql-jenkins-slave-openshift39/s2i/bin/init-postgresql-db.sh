#!/usr/bin/env bash
if $(dirname ${BASH_SOURCE[0]})/init-db.sh ; then
    echo "PostgreSQL Database preparation successful"
    exit 0
else
    echo "PostgreSQL Database preparation failed"
    exit 1
fi
