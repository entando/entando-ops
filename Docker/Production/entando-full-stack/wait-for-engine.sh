#!/usr/bin/env bash
echo -n "Waiting for Entando Engine ..."
while ! [ $(docker inspect $(docker ps -q  -f name=entando-full-stack_engine-api*) --format="{{.State.Health.Status}}") = "healthy" ] ; do
    echo -n "."
    sleep 2
done
echo
