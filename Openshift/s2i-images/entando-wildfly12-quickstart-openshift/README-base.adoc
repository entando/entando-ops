#Entando Wildfly 12 Openshift S2I Image 
The Entando Wildfly 12 Openshift S2I Image is intended for use in the Openshift S2I build process.
It provides all the Wildfly and Java/Maven build infrastructure to allow extending images to build a war file
from a Maven project, and then to deploy the resulting war file to /wildfly/standalone/deployments. 

In addition to this, it can also build two local Derby databases, the Entando SERV database 
and the Entando PORT database. 


## Database construction process
The databases will typically be built and populated from one of two possible sources inside the Maven project

### The Entando plugins listed as dependencies.
When this image detects a Maven project with no SQL backups, it starts up Entando and allows all the plugins configured
in the project to create the tables they require, and then allows them to populate these tables with the necessary default data.

### A SQL Backup inside the Maven project 
If this image detects a standard Entando database backup in SQL format at the location src/main/webapp/protected, it restores the database
from this backup

Once the databases have be built and populated, the 'assemble' script copies both databases to a the directory /entando-data-templates/databases. 
When a container is started from this image, it detects whether the container already has fully populated databases in the 
/entando-data/databases directory. If none is detected, it copies the database template directory across thus ensuring that 
the databases reflect the correct initial state for the associated Entando app.

## Environment Variables

### Entando specific Environment Variables
**PREPARE_DATA** - If set to "true", this variable will activate the creation of the Derby databases during the S2I build process, and activate the databases during the S2I run process. This will slow down the build unnecessarily, and ultimately the databases are ignored for clustered deployments.   

**KIE_SERVER_BASE_URL**: The base URL where a KIE Server instance is hosted, e.g. http://entando-kieserver701.apps.serv.run/

**KIE_SERVER_USERNAME**: The username of a user that be used to log into the above-mentioned KIE Server

**KIE_SERVER_PASSWORD**: The password of the above-mentioned KIE Server user.


### Inherited Environment Variables.

This image extends the open source Wildfly S2I image for Opensfhit with minimal modifications to the original logic. Feel free
to experiment with the environment variables documented in the
[original image](https://github.com/openshift-s2i/s2i-wildfly)  


Keep in mind though that this is a "Quick Start" image and is not intended for overly complicated configurations. In fact, for 
advanced configurations we recommend looking at our Entando EAP/PostreSQL template for clustering, or one of our pipelines.

## Ports

**8080** - the port for the HTTP service hosted by JBoss EAP

## Volumes

**/entando-data**: the standard 'entando-data' volume is mounted at /entando-data. This directory contains the uploaded resources, protected resources and indices, along with the two embedded Derby databases. 

## How to run

This image is not intended to be run directly in Docker. Instead, import and run this image as part of the Openshift S2I process, e.g.

    oc import-image entando-wildfly12-quickstart-openshift --from=docker.io/entando/entando-wildfly12-quickstart-openshift --confirm
    oc new-app --name=[name of your application] entando-wildfly12-clustered-openshift~https://[your vcs server repository containing the entando project]
    
    
    
