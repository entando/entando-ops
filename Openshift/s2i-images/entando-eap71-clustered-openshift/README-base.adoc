# Entando JBoss EAP 7.1 Clustered Openshift S2I Image 
The Entando JBoss EAP 7.1 Clustered Openshift S2I Image is intended for use in the Openshift S2I build process. It 
provides all the JBoss EAP and Java/Maven build infrastructure to build a war file
from a Maven project, and then to deploy the resulting war file to /opt/eap/standalone/deployments.

It comes with a default JBoss EAP configuration in /opt/eap/standalone/configuration/standalone-openshift.xml that
activates distributed, cluster safe caches for all of the known Entando plugins. However, these caches will only 
work if the JGroups infrastructure in JBoss is configured properly.  

Whereas this image can also automatically create the two embedded Derby databases, this is strongly discouraged in a
clustered environment. Please ensure that the **PREAPRE_DATA** environment variable remains set to "false" at all times

## Environment Variables

### Entando specific Environment Variables
**PREPARE_DATA** - Keep this variable set to "false". If set to "true", this variable will activate the creation of the Derby databases during the S2I build process, and activate the databases during the S2I run process. This will slow down the build unnecessarily, and ultimately the databases are ignored for clustered deployments.   

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

**SERVDB_SERVICE_HOST** - the  name of the server that hosts the Entando SERV database.

**SERVDB_SERVICE_PORT** - the port on the above-mentioned server that serves the Entando SERV database. Generally we keep to the default port for each RDBMS, e.g. for PostgreSQL it is 5432
 
**Please note**: When the SERVDB_URL  and the PORTDB_URL variables are specified, the corresponding *_SERVICE_HOST and *_SERVICE_PORT 
variables will be ignored.

**ENTANDO_OIDC_ACTIVE** - set this variable's value to "true" to activate Entando's Open ID Connect and the related OAuth authentication infrastructure. If set to "false"
all the subsequent OIDC  variables will be ignored. 

**ENTANDO_OIDC_AUTH_LOCATION** - the URL of the authentication service, e.g. the 'login page' that Entando needs to redirect the user to in order to  allow the OAuth provider to authenticate the user.

**ENTANDO_OIDC_TOKEN_LOCATION** - the URL of the token service where Entando can retrieve the OAuth token from after authentication

**ENTANDO_OIDC_CLIENT_ID** - the Client ID that uniquely identifies the Entando App in the OAuth provider's configuration

**ENTANDO_OIDC_REDIRECT_BASE_URL** - the optional base URL, typically the protocol, host and port (https://some.host.com:8080/) that will be prepended to t
he path segment of the URL requested by the user and provided as a redirect URL to the OAuth provider. If empty, the requested URL will be used as is.

**KIE_SERVER_BASE_URL**: The base URL where a KIE Server instance is hosted, e.g. http://entando-kieserver701.apps.serv.run/

**KIE_SERVER_USERNAME**: The username of a user that be used to log into the above-mentioned KIE Server

**KIE_SERVER_PASSWORD**: The password of the above-mentioned KIE Server user.

### Inherited Environment Variables.

This image extends the official Red Hat JBoss EAP 7.1 image for Opensfhit with minimal modifications to the original logic. Feel free
to experiment with the environment variables documented in the
[original image](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.1/html/red_hat_jboss_enterprise_application_platform_for_openshift/configuring_eap_openshift_image)

In order to get the clustering to be secured and to work properly, be sure to configure this image as per of . 
https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.1/html/red_hat_jboss_enterprise_application_platform_for_openshift/reference_information#reference_clustering[section 6 ]
it's documentation. More specifically, take care that the following environment variables are given correct values:

**JGROUPS_PING_PROTOCOL** - JGroups protocol to use for node discovery. Can be either openshift.DNS_PING or openshift.KUBE_PING. Red Hat recommends the latter.
**JGROUPS_ENCRYPT_KEYSTORE_DIR** - The directory containing  the JGroups keystore file e.g. "/etc/jgroups-encrypt-secret-volume". You need to make sure you configure a volume that makes a keystore available there
**JGROUPS_ENCRYPT_KEYSTORE** - The name of the keystore file in the keystore directory that contains the certificates JGroups will be using
**JGROUPS_ENCRYPT_NAME** - The alias of the keystore entry containing the certificate for JGroups
**JGROUPS_ENCRYPT_PASSWORD** - The password of the JGroups keystore and certificate 
**JGROUPS_CLUSTER_PASSWORD**  - The passwords of the JGroups cluster
**OPENSHIFT_KUBE_PING_LABELS** - Clustering labels selector for the Kubernetes discovery mechanism, eg. app=my-app
**OPENSHIFT_KUBE_PING_NAMESPACE** -  Clustering project namespace for the Kubernetes discovery mechanism.

## Ports

**8080** - the port for the HTTP service hosted by JBoss EAP
**8778** - the port for the JGroups service on JBoss
**8443** - the port for  the HTTPS service hosted by JBoss EAP
**8888** - the port for the PING service


## Volumes

**/entando-data**: the standard 'entando-data' volume is mounted at /entando-data. This directory contains the uploaded resources, protected resources and indices. 

## How to run

This image is not intended to be run directly in Docker. Instead, import and run this image as part of the Openshift S2I process, e.g.

    oc import-image entando-eap71-clustered-openshift --from=docker.io/entando/entando-eap71-clustered-openshift --confirm
    
    oc new-app --name=[name of your application] entando-eap71-clustered-openshift~https://[your vcs server repository containing the entando project] \
     -p PORTDB_USERNAME=[agile] \
     -p PORTDB_PASSWORD=[agile] \
     -p SERVDB_USERNAME=[agile] \
     -p SERVDB_PASSWORD=[agile] \
     -p PORTDB_JNDI=[JNDI for the port DB] \
     -p SERVDV_JNDI=[JNDI for the serv DB] \
     -p PORTDB_URL=[host:port/DB] \
     -p SERVDB_URL=[host:port/DB] \
     -p OPENSHIFT_KUBE_PING_NAMESPACE=[name of the openshift project] \
     -p OPENSHIFT_KUBE_PING_LABELS=[app=[name of the entando application in Openshift]] \
     -p JGROUPS_CLUSTER_PASSWORD[random chars] \
     -p OPENSHIFT_KUBE_PING_PORT_NAME=ping \
     -p MAVEN_MIRROR_URL=[url of maven mirror where dependencies are cached] 
    
    oc patch dc/[your app name] -p '[{"op": "replace", "path": "/spec/template/spec/containers/0/ports/3", "value": {"name":"ping","containerPort":8888,"protocol":"TCP"}}]' --type=json
     