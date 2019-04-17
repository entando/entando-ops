#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/common.sh
DB_PREFIX_ARRAY=($(get_db_prefix_array))
for DB in ${DB_PREFIX_ARRAY[*]} ; do
    drop_db $DB
    create_db $DB
    restore_db $DB
done