#Entando JBoss EAP 7.1 Cluster Ready Base Image 

The Entando JBoss EAP 7.1 Cluster Ready Base Image directly extends the [Entando JBoss EAP 7.1 Base Image](https://github.com/entando/entando-ops/tree/credit-card-dispute/Docker/base-images/entando-eap71-base).
Please consult the parent image's documentation for a better understanding of how to configure this image. The only difference between this
image and the Entando JBoss EAP 7.1 Base Image is that it has enabled the cluster ready caches for the Entando Infinispan plugin.

## Ports

**8080** - the port for the HTTP service hosted by JBoss EAP
**8778** - the port for the JGroups service on JBoss
**8443** - the port for  the HTTPS service hosted by JBoss EAP


## Volumes

**/entando-data**: the standard 'entando-data' volume is mounted at /entando-data. This directory contains the uploaded resources, protected resources and indices, as well as the two
embedded Derby databases for optional use. 

## How to run

This image was not intended to be run directly in Docker. Extend the image to support the Openshfit S2I functionality, or
use it as a base image in a Maven build or a Dockerfile  