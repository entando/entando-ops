#!/usr/bin/env bash
echo -n "Waiting for Admin Entando Engine ..."
while ! [ "$(docker inspect $(docker ps -q  -f name=fsi-credit-card-dispute_admin-engine*) --format='{{.State.Health.Status}}')" = "healthy" ] ; do
    echo -n "."
    sleep 10
done
echo
echo -n "Waiting for Customer Entando Engine ..."
while ! [ "$(docker inspect $(docker ps -q  -f name=fsi-credit-card-dispute_customer-engine*) --format='{{.State.Health.Status}}')" = "healthy" ] ; do
    echo -n "."
    sleep 10
done
sleep 10
echo
