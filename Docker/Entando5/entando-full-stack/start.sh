#!/usr/bin/env bash

# Declare ports
ENGINE_PORT=8080
APPBUILDER_PORT=80
MICROENGINE_PORT=81

# Check if Docker is installed
command -v docker >/dev/null 2>&1 || { echo >&2 "docker is required to run this demo but it's not installed.  Aborting..."; exit 1; }

# Make sure we have the latest version of the images
echo "----------------------------------------------------"
echo "Ensuring we have the latest version of the images"
echo

docker pull entando/appbuilder
docker pull entando/microengine
docker pull entando/engine-api

# Start running the containers
echo "----------------------------------------------------"
echo "Start running the containers"
echo
echo "Starting appbuilder container"
echo
docker run -it --rm -d --name=appbuilder -p ${APPBUILDER_PORT}:5000 entando/appbuilder
echo
echo "----------------------------------------------------"
echo "Starting microengine container"
echo
docker run -it --rm -d --name=microengine -p ${MICROENGINE_PORT}:5000 entando/microengine
echo
echo "----------------------------------------------------"
echo "Starting engine-api container"
echo
docker run -it --rm -d --name=engine-api -p ${ENGINE_PORT}:8080 entando/engine-api
echo
echo "----------------------------------------------------"
echo "All containers have been started. "
echo "Please wait a couple of minutes to make them download all the needed dependencies"
echo
echo "You can reach the images at: "
echo "Appbuilder is running at: http://127.0.0.1.nip.io/"
echo
echo "Microengine is running at http://127.0.0.1.nip.io:${MICROENGINE_PORT}/"
echo
echo "Entando engine-api is running at http://127.0.0.1.nip.io:${ENGINE_PORT}/entando "
echo
echo "----------------------------------------------------"
