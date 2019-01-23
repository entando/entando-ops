//Environment Variable names for images
:PORTDB_URL: the full JDBC connection string used to connect to the Entando PORT database
:PORTDB_DATABASE: the name of the Entando PORT database that is created and hosted in the image
:PORTDB_JNDI: the full JNDI name where the Entando PORT datasource will be made available to the Entando Engine JEE application
:PORTDB_DRIVER: the name of the driver for the Entando PORT database as configured in the JEE application server
:PORTDB_USERNAME: the username of the user that has read/write access to the Entando PORT database
:PORTDB_PASSWORD: the password of the above-mentioned username.
:PORTDB_SERVICE_HOST: the  name of the server that hosts the Entando PORT database.
:PORTDB_SERVICE_PORT: the port on the above-mentioned server that serves the Entando PORT database. Generally we keep to the default port for each RDBMS, e.g. for PostgreSQL it is 5432
:SERVDB_URL: the full JDBC connection string used to connect to the Entando SERV database
:SERVDB_DATABASE: - the name of the Entando SERV database that is created and hosted in the image
:SERVDB_JNDI: the full JNDI name where the Entando SERV datasource will be made available to the Entando Engine JEE application
:SERVDB_DRIVER: the name of the driver for the Entando SERV database as configured in the JEE application server
:SERVDB_USERNAME: the username of the user that has read/write access to the Entando SERV database. For compatibility with mvn jetty:run, please keep this the same as PORTDB_USERNAME
:SERVDB_PASSWORD: the password of the above-mentioned username.  For compatibility with mvn jetty:run, please keep this the same as PORTDB_PASSWORD
:SERVDB_SERVICE_HOST: the  name of the server that hosts the Entando SERV database
:SERVDB_SERVICE_PORT: the port on the above-mentioned server that serves the Entando SERV database. Generally we keep to the default port for each RDBMS, e.g. for PostgreSQL it is 5432
:ADMIN_USERNAME: the username of a user that has admin rights on both the SERV and PORT databases. For compatibility with Postgresql, keep this value to 'postgres'
:ADMIN_PASSWORD: the password of the above-mentioned username.
:KIE_SERVER_BASE_URL: The base URL where a KIE Server instance is hosted, e.g. http://entando-kieserver701.apps.serv.run/
:KIE_SERVER_USERNAME: The username of a user that be used to log into the above-mentioned KIE Server
:KIE_SERVER_PASSWORD: The password of the above-mentioned KIE Server user.
:ENTANDO_OIDC_ACTIVE: set this variable's value to "true" to activate Entando's Open ID Connect and the related OAuth authentication infrastructure. If set to "false" all the subsequent OIDC  variables will be ignored. Once activated, you may need to log into Entando using the following url: <application_base_url>/<lang_code>/<any_public_page_code>.page?username=<MY_USERNAME>&password=<MY_PASSWORD>
:ENTANDO_OIDC_AUTH_LOCATION: the URL of the authentication service, e.g. the 'login page' that Entando needs to redirect the user to in order to  allow the OAuth provider to authenticate the user.
:ENTANDO_OIDC_TOKEN_LOCATION: the URL of the token service where Entando can retrieve the OAuth token from after authentication
:ENTANDO_OIDC_CLIENT_ID: the Client ID that uniquely identifies the Entando App in the OAuth provider's configuration
:ENTANDO_OIDC_REDIRECT_BASE_URL: the optional base URL, typically the protocol, host and port (https://some.host.com:8080/) that will be prepended to the path segment of the URL requested by the user and provided as a redirect URL to the OAuth provider. If empty, the requested URL will be used as is.
:DOMAIN:  the HTTP URL on which the associated Entando Engine instance will be served
:CLIENT_SECRET: the secret associated with the 'appbuilder' Oauth Client ID in the Entando OAuth infrastructure.
:JGROUPS_ENCRYPT_SECRET: - the name of the secret containing the keystore file
:JGROUPS_ENCRYPT_KEYSTORE: - the name of the keystore file within the secret
:JGROUPS_ENCRYPT_NAME: - the name or alias of the kesytore entry containing the server certificate
:JGROUPS_ENCRYPT_PASSWORD: - the password for the keystore and certificate
:JGROUPS_PING_PROTOCOL: - JGroups protocol to use for node discovery. Can be either openshift.DNS_PING or openshift.KUBE_PING.
:JGROUPS_CLUSTER_PASSWORD: -JGroups cluster password
//Ports
:PORT_5000: the port for the NodeJS HTTP Service on images that serve JavaScript applications
:PORT_8080: the port for the HTTP service hosted by JEE Servleit Containers on images that host Java services
:PORT_8443: the port for  the HTTPS service hosted by JEE Servlet Containers that support HTTPS. (P.S. generally we prefer to configure HTTPS on a router such as the Openshift Router)
:PORT_8778: the port for the Jolokia service on JBoss. This service is used primarily for monitoring.
:PORT_8888: the port that a ping service will expose to on support JGroups on images that support JGroups such as the JBoss EAP images
//Image names
:APP_BUILDER_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Docker/Production/entando-full-stack/appbuilder[Entando App Builder Image (entando/appbuilder:latest)]
:ENTANDO_ENGINE_API_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Docker/Production/entando-full-stack/entando[The Full Entando Engine API (entando/engine-api:latest)]
:ENTANDO_POSTGRESQL95_BASE_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Docker/base-images/entando-postgresql95-base[Entando PostgreSQL 9.5 Base Image (entando/entando-postgresql95-base:latest)]
:ENTANDO_POSTGRESQL95_OPENSHIFT_IMAGE:  https://github.com/entando/entando-ops/tree/EN-2348/Openshift/s2i-images/entando-postgresql95-openshift[Entando PostgreSQL 9.5 Openshift S2I Image (entando/entando-postgresql95-openshift:latest)]
:ENTANDO_EAP71_BASE_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Docker/base-images/entando-eap71-base[Entando EAP 7.1 Base Image (entando/entando-eap71-base:latest)]
:ENTANDO_WILDFLY12_BASE_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Docker/base-images/entando-wildfly12-base[Entando Wildfly 12 Base Image (entando/entando-wildfly12-base:latest)]
:ENTANDO_EAP71_QUICKSTART_OPENSHIFT_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Openshift/s2i-images/entando-eap71-quickstart-openshift[Entando EAP 7.1 Openshift Quickstart Image (entando/entando-eap71-quickstart-openshift:latest)]
:ENTANDO_WILDFLY12_QUICKSTART_OPENSHIFT_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Openshift/s2i-images/entando-wildfly12-quickstart-openshift[Entando Wildfly 12 Openshift Quickstart Image (entando/entando-wildfly12-quickstart-openshift:latest)]
:FSI_CC_DISPUTE_CUSTOMER_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Docker/demos/fsi-cc-dispute-customer[Entando FSI Credit Card Dispute Customer Image (entando/fsi-cc-dispute-customer:latest)]
:FSI_CC_DISPUTE_ADMIN_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Docker/demos/fsi-cc-dispute-admin[Entando FSI Credit Card Dispute Back Office Image (entando/fsi-cc-dispute-admin:latest)]
:ENTANDO_POSTGRESQL_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Docker/Production/entando-full-stack/postgresql[PostgreSQL Database Image (entando/postgresql:latest]
:ENTANDO_EAP71_CLUSTERED_BASE_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Docker/base-images/entando-eap71-clustered-base[Entando EAP 7.1 Clustered Base Image (entando/entando-eap71-clustered-base:latest)]
:ENTANDO_EAP71_CLUSTERED_OPENSHIFT_IMAGE: https://github.com/entando/entando-ops/tree/EN-2348/Openshift/s2i-images/entando-eap71-clustered-openshift[Entando EAP 7.1 Clustered Openshift Image (entando/entando-eap71-clustered-openshift:latest)]
:ENTANDO_MAVEN_JENKINS_SLAVE_OPENSHIFT39: https://github.com/entando/entando-ops/tree/EN-2348/Openshift/supporting-images/entando-maven-jenkins-slave-openshift39[Entando Maven Jenkins Slave Image for Openshift 3.9 (entando/entando-maven-jenkins-slave-openshift39:latest)]
:ENTANDO_POSTGRESQL_JENKINS_SLAVE_OPENSHIFT39: https://github.com/entando/entando-ops/tree/EN-2348/Openshift/supporting-images/entando-postgresql-jenkins-slave-openshift39[Entando PostgreSQL Client Jenkins Slave Image for Openshift 3.9 (entando/entando-postgresql-jenkins-slave-openshift39:latest)]
//Image streams
:APP_BUILDER_IMAGE_STREAM: Entando AppBuilder Image stream: https://raw.githubusercontent.com/entando/entando-ops/master/Openshift/image-streams/appbuilder.json
:ENTANDO_EAP71_QUICKSTART_OPENSHIFT_IMAGE_STREAM: Entando EAP 7.1 Quickstart Openshift Image Stream: https://raw.githubusercontent.com/entando/entando-ops/master/Openshift/image-streams/entando-eap71-quickstart-openshift.json
:ENTANDO_EAP71_CLUSTERED_OPENSHIFT_IMAGE_STREAM: Entando EAP 7.1 Clustered Openshift Image Stream: https://raw.githubusercontent.com/entando/entando-ops/master/Openshift/image-streams/entando-eap71-clustered-openshift.json
:ENTANDO_POSTGRESQL95_OPENSHIFT_IMAGE_STREAM: Entando PostgreSQL 9.5 Openshift Image Stream: https://raw.githubusercontent.com/entando/entando-ops/master/Openshift/image-streams/entando-postgresql95-openshift.json
//Template parameters
:APPLICATION_NAME:  an Openshift compliant name that can be used as a prefix to automatically  generate names for related objects in the Template
:IMAGE_STREAM_NAMESPACE: the name of the Openshift project that contains all the  ImageStreams required for the Template  in question. If the ImageStreams were created in the default 'openshift' project,  Openshift will automatically add it to  its application catalog. It is however possible to store them in any   project, including the project that the current Template is being instantiated in.
:ENTANDO_IMAGE_VERSION: the version number of the Entando images that will be used. In Docker, this will be the 'tag' segment of the Image repository reference. In Openshift, this will be the name of a Tag in the ImageStreams that will be used to bind all  S2I BuildConfigs and  DeploymentConfigs to. This generally corresponds with the version of Entando being used.
:ENTANDO_ENGINE_HOSTNAME: the fully qualified domain name of the Route that will be  created to expose the Entando Runtime Service using HTTP without SSL. This variable  is often used to connect to from the App Builder. You therefore need to make sure that it is accessible from outside the Openshift cluster.
:ENTANDO_ENGINE_SECURE_HOSTNAME: the fully qualified domain name of the Route that will be  created to expose the Entando Runtime Service using SSL/HTTPS. This variable  is often used to connect to from the App Builder. You therefore need to make sure that it is accessible from outside the Openshift cluster.
:ENTANDO_APP_BUILDER_HOSTNAME: the fully qualified domain name of the Route that will be  created to expose the Entando App Builder JavaScript App  using HTTP without SSL.
:ENTANDO_APP_BUILDER_SECURE_HOSTNAME: the fully qualified domain name of the Route that will be  created to expose the Entando App Builder JavaScript App using SSL/HTTPS.
:ENTANDO_ENGINE_BASEURL: The full URL that AppBuilder must use to connect to the Entando Runtime. This parameter is required in situations where AppBuilder can connet to the Entando Runtime using either HTTP or HTTPS. AppBuilder does not work well with self-signed certificates so for test environments you may sometimes fall back on the HTTP Route. Also keep in mind that you may need to append the web context that the Entando app is served at by the JEE servlet container.
:ENTANDO_ENGINE_WEB_CONTEXT: the context root  of the Entando Web Application. This is the context  on the JEE server that will be used to dispatch requests to the Entando Web Application. Generally this would be the same as the APPLICATION_NAME. In typical JEE deployments this would be the name of the war file, excluding the '.war' extension. In typical Maven projects, this would be the value of the <finalName> element in the pom.xml
:SOURCE_REPOSITORY_URL: the full URL of the source repository where the source code of the image that needs to be built can be found
:SOURCE_REPOSITORY_REF: the branch or tag that will be checked out from the source repository specified at the SOURCE_REPOSITORY_URL
:SOURCE_SECRET: the Openshift Secret containing the Username and Password for the source repository specified at the SOURCE_REPOSITORY_URL
:CONTEXT_DIR: the relative directory inside the source repository from which the build should be  executed.
:VOLUME_CAPACITY: the amount of storage space to be allocated to the Entando App. This needs to be large enough for documents and images that are uploaded, database backups that need to be made,  and the indices that Entando generates. Depending  on the exact template, this may aslo include the space required for the embedded Derby database.
:MEMORY_LIMIT: the maximum amount of memory to be allocated to the Entando JEE App.
:DOMAIN_SUFFIX:  the domain suffix will be appended to the various service names to form a full domain name for the Route of the  mapped to the service. This parameter is required to ensure that the AppBuider points to the externally accessible URL that serves Entando App.
:GITHUB_WEBHOOK_SECRET: Github webhook secret that can be used from Github to trigger builds on this BuildConfig in the Openshift cluster
:GENERIC_WEBHOOK_SECRET: Generic webhook secret that can be used from any generic SCM tool to trigger builds on this BuildConfig in the Openshift cluster
:MAVEN_MIRROR_URL: Maven mirror to use for S2I builds. Specifying a Maven mirror such as Nexus, running in the same cluster can significantly speed up build execution.
:MAVEN_ARGS_APPEND: additional Maven arguments that will be appended to the standard Maven command used in the S2I build
:ARTIFACT_DIR: List of directories from which archives will be copied into the deployment folder. If unspecified, all archives in /target will be copied.


:FSI_CCD_DEMO_DESCRIPTION: The Entando team, Red Hat and our business partners have collaborated to bring you a demo that illustrates how Entando can be used as the user experience layer for your Red Hat Process Automation Manager processes. The process in question allows customers to initiate a dispute case against a specific transaction. This demo provides two Entando apps - a customer facing app and a back-office app. These apps connect to a shared KIE Server instance.
:EAP_IMAGE_DISCLAIMER: Please note that this configuration uses a child image of the official JBoss EAP commercial Docker Image. This would mean that  in order to deploy this in a production environment, you would need to purchase the necessary subscription from Red Hat first.

# Entando Wildfly 12 Base Image

The Entando Wildfly 12  7.1 Base Image is not intended to be run directly, but to be extended in other contexts that could leverage
its functionality. It provides all the Wildfly and Java/Maven build infrastructure to allow extending images to build a war file
from a Maven project, and then to deploy the resulting war file to /wildfly/standalone/deployments. 

In addition to this, it also provides the necessary functionality to build two local Derby databases, the Entando SERV database 
and the Entando PORT database. Even though this image itself is not compliant 
with the Openshift Source-to-image specification, it does provide some of the infrastructure to build an image from sources. 
One can use the 'assemble' script (located at /usr/libexec/s2i/assemble) to build a war file and the supporting 
Derby databases from a Maven project. 


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

This image extends the open source Wildfly S2I image for Opensfhit with minimal modifications to the original logic. Feel free
to experiment with the environment variables documented in the
[original image](https://github.com/openshift-s2i/s2i-wildfly)  

## Ports

**8080** - the port for the HTTP service hosted by Wildfly


## Volumes

**/entando-data**: the standard 'entando-data' volume is mounted at /entando-data. This directory contains the uploaded resources, protected resources and indices, as well as the two
embedded Derby databases for optional use. 

## How to run

This image was not intended to be run directly in Docker. Extend the image to support the Openshfit S2I functionality, or
use it as a base image in a Maven build or a Dockerfile  