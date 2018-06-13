# Entando Full Stack Deployment

## Images

### entando/appbuilder 

`docker run -it --rm -d -p 80:5000 entando/appbuilder`

Open your browse and point to `http://localhost/`

it will takes sometime before you'll be able to see something on the browser

### entando/microengine

`docker run -it --rm -d -p 81:5000 entando/microengine`

Open your browser and point to `http://localhost:81/`

it will takes sometime before you'll be able to see something on the browser

### entando/engine-api

`docker run -it --rm -d -p 8080:8080 entando/engine-api`

Open your browser and point to `http://localhost:8080/entando`


## How to Run

execute `./start.sh`

## How to stop

execute `./stop.sh`

## Prerequisites

- Docker with privileges to run as normal user
- curl
- git