# Entando FSI Credit Card Dispute Back Office App 

This image contains the Entando Credit Card Dispute Back Office App. It is intended for demonstration purposes only and should not be
used in a production environment. It uses a pre-built, embedded Derby database that is not cluster safe. It contains Red Hat's JBoss EAP 7.1
product and would therefore require the necessary licensing if used in a production environment. It also extends Red Hat's official 
JBoss EAP 7.1 image, which means it inherits all the functionality as documented in 
[Red Hat's image catalog](https://access.redhat.com/containers/?tab=overview#/registry.access.redhat.com/jboss-eap-7/eap71-openshift) 

## Environment Variables

Most of the environment variables of this image are pre-configured to point to the correct database. Please do not modify
any of the database related variables. The only variables that can be changed are those related to the 
Red Hat Process Automation Manager environment in use

**KIE_SERVER_BASE_URL**: The base URL where a KIE Server instance is hosted, e.g. http://entando-kieserver701.apps.serv.run/

**KIE_SERVER_USERNAME**: The username of a user that be used to log into the above-mentioned KIE Server

**KIE_SERVER_PASSWORD**: The password of the above-mentioned KIE Server user.
 

## Ports

**8080**: the EAP HTTP service is exposed on port 8080 

**8443**: the EAP HTTPS service is optionally exposed on port 8443, if the necessary keystores are provided as per the official Red Hat documentation 

**8778**: the Jolokia monitoring port 

## Volumes

**/entando-data**: the standard 'entando-data' volume is mounted at /entando-data. This directory contains the 
uploaded resources, protected resources and indices, as well as the two pre-built embedded Derby databases. 

## How to run

```
docker volume create entando-ccd-admin-data 
docker run -it --rm -d -p 8080:8080 -v entando-ccd-admin-data:/entando-data entando/fsi-cc-dispute-admin:5.0.2
```
Once this command is executed, the app is available at http://localhost:8080/fsi-credit-card-dispute-backoffice. Log in using
admin/adminadmin as username/password