#!/usr/bin/env bash

# Declare variables if you need to change something plese change these
ENGINE_PORT=8080
APPBUILDER_PORT=80
MICROENGINE_PORT=81
BASE_URL=http://localhost
APPBUILDER_URL=${BASE_URL}:${APPBUILDER_PORT}
MICROENGINE_URL=${BASE_URL}:${MICROENGINE_PORT}
ENGINE_API_URL=${BASE_URL}:${ENGINE_PORT}/entando/
STATUS=true # used to loop checking the status of the image if set to false the image is tarted

#Declare common functions
# function line print an hr line 80 chars width"

function line {
	echo "--------------------------------------------------------------------------------"
	echo
}

# Function checkStatus check if the Image is up and running

function checkStatus {
	if curl -Is $1 | head -n 1 | grep -q "200 OK"; then
		echo "$1 is up and running now"
		STATUS=false
	else
		echo "$1 is still starting. Please wait..."
		STATUS=true
	fi
}

# Function loop
function loop {
while [ "$STATUS" = true ]
do
	"$@"
	sleep 30
done
}

#Function printInstructions
function printInstructions {
	if [ "$STATUS" = false ]; then
		line
		echo "All images are now up and running. You can reach them at:"
		echo
		line
		echo "Appbuilder at ${APPBUILDER_URL}"
		echo
		line
		echo "Microengine at ${MICROENGINE_URL}"
		echo
		line
		echo "Engine-api at ${ENGINE_API_URL}"
		line
		echo "To stop the images run stop.sh script"
		line
	fi
}

# Check if Docker is installed
command -v docker >/dev/null 2>&1 || { echo >&2 "docker is required to run this demo but it's not installed.  Aborting..."; exit 1; }


# Make sure we have the latest version of the images
line
echo "Ensuring we have the latest version of the images"
echo

docker pull entando/appbuilder
docker pull entando/microengine
docker pull entando/engine-api

# Start running the containers
line
echo "Start running the containers"
echo
echo "Starting appbuilder container"
echo
docker run -it --rm -d --name=appbuilder -p ${APPBUILDER_PORT}:3000 entando/appbuilder
echo
line
echo "Starting microengine container"
echo
docker run -it --rm -d --name=microengine -p ${MICROENGINE_PORT}:3000 entando/microengine
echo
line
echo "Starting engine-api container"
echo
docker run -it --rm -d --name=engine-api -p ${ENGINE_PORT}:8080 entando/engine-api
echo
line
echo "All containers have been started. "
echo
echo "Please wait even 10 minutes to make images download all the needed dependencies"
echo
echo "This script will check the status every 30 seconds: "
echo
line
# start check the status of the images
# Checking only the engine-api image status because is the most slowly
#Engine-api
loop checkStatus ${ENGINE_API_URL}

# Once all dependencies have been downloaded print URLs
printInstructions
