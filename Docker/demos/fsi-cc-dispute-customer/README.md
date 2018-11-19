# Entando Sample

This is a demo image to let you test the entando framework

## Ports

This image exposes port `8080`

## How to run
`docker volume create entando` 
`docker run -it --rm -d -p 8080:8080 -v entando:/entando-data entando/engine-api:5.0.1`
