# Entando PostgreSQL Jenkins Slave for Openshift 3.9

This image is designed to work with a Jenkins server running the Jenkins Kubernetes Plugin. This specific image
targets version of the Jenkins server running in version 3.9 of Openshift. Its Openshift client will not work
with incompatible versions of the Openshift server.

This Image has the necessary Maven infrastructure to build any Maven project. It also comes with
the PostgreSQL 9.5 client software. This image is intended for Maven processes that need to update
a remove PostgreSQL database.

This Image also comes with the Entando dependencies pre-cached in the $HOME/.m2/repository directory.

# Some important features.

This image comes with three important scripts that will typically be used by Jenkins pipelines. These three
scripts typically use the similar environment variables to connect to the correct PostgreSQL server. Please ensure
that these variables are available from your Jenkins Pipeline Scripts using Jenkins secrets 

**ADMIN_USERNAME** - the password associated with the postgres user
**ADMIN_PASSWORD** - the password associated with the postgres user
**PORTDB_SERVICE_HOST**
**SERVDB_SERVICE_HOST**
**PORTDB_SERVICE_PORT**
**SERVDB_SERVICE_PORT**

## backup-dbs.sh

This script backs  

# Running this image.

This image is not intended for direct use in Docker. It can only be run by the Jenkins Kubernetes plugin.    