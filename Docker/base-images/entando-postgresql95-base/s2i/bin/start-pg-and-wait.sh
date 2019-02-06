#!/usr/bin/env bash
#Start PG service in the background and continue once the last expected logline appears
export PGPASSWORD=postgres
echo "Creating DB $POSTGRESQL_DATABASE for $POSTGRESQL_USER and $POSTGRESQL_DATABASE2 for $POSTGRESQL_USER2"
run-postgresql 2>&1 | tee pg_startup.log &
for i in {1..40}
do
    sleep 5
    if fgrep --quiet "Future log output will appear in directory" pg_startup.log
    then
        echo "Postgresql Started"
        exit 0
    fi
done
exit 1