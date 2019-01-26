#!/usr/bin/env bash
#Start PG service in the background and continue once the last expected logline appears
export PGPASSWORD=postgres
echo "Creating DB $MYSQL_DATABASE for $MYSQL_USER and $MYSQL_DATABASE2 for $MYSQL_USER2 "
run-mysqld 2>&1 | tee mysql_startup.log &
for i in {1..40}
do
    sleep 5
    if fgrep --quiet "Running final exec" mysql_startup.log && tail -n 1 mysql_startup.log|fgrep  --quiet "MySQL Community Server"
    then
        echo "MySQL Started"
        exit 0
    fi
done
exit 1