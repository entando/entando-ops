# Entando base image for entando relase 5.0.0 based docker images

This image has a default user 1001 that has write permissions on `/opt/entando` that is the default path for the `WORKDIR` directive.

You have to extend this image knowing that the maven path is under `/opt/entando/.m2/repository` indeed you have to build your new container passing this path to maven. (i.e. `-Dmaven.repo.local=/opt/entando/.m2/repository`)

This image is the fastest way to have your entando project deployed with docker

## Environment variables

__JAVA_HOME__ Set to `/usr/lib/jvm/java-8-openjdk-amd64`

__JRE_HOME__ Set to `/usr/lib/jvm/java-8-openjdk-amd64/jre`

__MAVEN_HOME__ Set to `/usr/share/maven`

__PROJECT_HOME__ Set to `/opt/entando`

__MVN_HOME__ Set to `${PROJECT_HOME}/.m2`

## Configuration

The default user is 1001

## How to

This is only a builder image so it does not exposes any port. It's a base image to start from creating your docker images with an entando project.
 

### How to create a Dockerfile to use this image

```bash
FROM entando/docker-builder-5:latest

RUN mvn archetype:generate -B -Dfilter=entando \
-DarchetypeGroupId=org.entando.entando \
-DarchetypeArtifactId=entando-archetype-entando-sample \
-DgroupId=org.entando \
-DartifactId=entando-sample \
-Dversion=1.0-SNAPSHOT \
-Dpackage=org.entando \
-DarchetypeCatalog=local \
&& chown -R 1001:0 $HOME/ && chmod -R ug+w $HOME/

WORKDIR $HOME/entando-sample

EXPOSE 8080
CMD ["mvn","jetty:run"]
```
