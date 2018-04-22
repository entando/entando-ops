#!/usr/bin/env bash

echo "----------------------------------------------------"
echo "Start stopping all running containers"
echo
docker stop appbuilder
echo
echo "Appbuilder container stopped and deleted"
echo
docker stop microengine
echo
echo "Microengine container stopped and deleted"
echo
docker stop engine-api
echo
echo "Engine-api container stopped and deleted"
echo
echo "----------------------------------------------------"