#!/usr/bin/env bash

#Declare common functions
# function line print an hr line 80 chars width"

function line {
	echo "--------------------------------------------------------------------------------"
	echo
}

line
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
line