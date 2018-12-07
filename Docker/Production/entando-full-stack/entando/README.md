# Entando Sample

This is a demo image to let you test the Entando framework. It provides an installation of Entando that has all of the standard Entando Plugins
pre-installed. The resulting Entando web app is hosted by a Wildfly instance. By default it uses an embedded Derby database, but it can be configured
to use an external database by setting the environment variables to the desired values.

This image extends Red Hat's open source Wildfly 12 image, which means it inherits all the functionality as documented on 
[Github](https://github.com/openshift-s2i/s2i-wildfly) 


## Environment Variables
**PORTDB_URL** - the full JDBC connection string used to connect to the Entando PORT database

**PORTDB_DRIVER** - the name of the driver for the Entando PORT database as configured in the JEE application server

**PORTDB_USERNAME** - the username of the user that has read/write access to the Entando PORT database

**PORTDB_PASSWORD** - the password of the above-mentioned username.

**PORTDB_SERVICE_HOST** - the  name of the server that hosts the Entando PORT database.

**PORTDB_SERVICE_PORT** - the port on the above-mentioned server that serves the Entando PORT database. Generally we keep to the default port for each RDBMS, e.g. for PostgreSQL it is 5432

**SERVDB_URL** - the full JDBC connection string used to connect to the Entando SERV database

**SERVDB_DRIVER** - the name of the driver for the Entando SERV database as configured in the JEE application server

**SERVDB_USERNAME** - the username of the user that has read/write access to the Entando SERV database

**SERVDB_PASSWORD** - the password of the above-mentioned username.

**SERVDB_SERVICE_HOST** - the  name of the server that hosts the Entando SERV database

**SERVDB_SERVICE_PORT** - the port on the above-mentioned server that serves the Entando SERV database. Generally we keep to the default port for each RDBMS, e.g. for PostgreSQL it is 5432
 

## Ports

This image exposes the Wildfly HTTP service on port `8080`

## Volumes

**/entando-data**: the standard 'entando-data' volume is mounted at /entando-data. This directory contains the uploaded resources, protected resources and indices, as well as the two
embedded Derby databases for optional use. 

## How to run

```
docker volume create entando-data 
docker run -it --rm -d -p 8080:8080 -v entando-data:/entando-data entando/engine-api:5.0.2
```
