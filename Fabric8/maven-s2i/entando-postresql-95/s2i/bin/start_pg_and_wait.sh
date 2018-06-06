echo "Running run-postgresql in:"
run-postgresql 2>&1 | tee pg_startup.log &
pg_pid=$!
for i in {1..40}
do
    sleep 5
    tail pg_startup.log -n 10
    if fgrep --quiet "Future log output will appear in directory" pg_startup.log
    then
        echo "Postgresql Started"
        exit 0
    fi
done
exit 1