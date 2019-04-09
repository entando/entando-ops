# This image provides a very lightweight base for building and running Entando 
# EAP based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on EAP 
ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION AS dependencies

#FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:1.3
FROM registry.connect.redhat.com/entando/entando-eap71-openshift-imagick:latest
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on EAP 7.1" \
      io.k8s.display-name="Entando on EAP 7.1" \
      authoritative-source-url="docker.io" \
      description="Platform for building and running Entando quickstart applications on EAP 7.1" \
      name="entando/entando-eap71-base" \
      vendor="Entando" \
      summary="Platform for building and running Entando quickstart applications on EAP 7.1" \
      url="https://github.com/entando/entando-ops/tree/master/Docker/base-images/entando-eap71-base"
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    STI_SCRIPTS_PATH="/usr/local/s2i" \
    USERID_TO_USE=185 \
    ENTANDO_COMMON_PATH="/entando-common"


COPY --chown=185:0 --from=dependencies  /opt/app-root/src/wildfly/modules /opt/eap/modules
COPY --chown=185:0 --from=dependencies /opt/app-root/src/.m2/settings.xml $HOME/.m2/settings.xml
COPY --chown=185:0 --from=dependencies /opt/app-root/src/jetty-runner /jetty-runner
COPY --chown=185:0 --from=dependencies ${ENTANDO_COMMON_PATH} ${ENTANDO_COMMON_PATH}
COPY --chown=185:0 ./contrib/wildfly-configuration/standalone-openshift.xml /opt/eap/standalone/configuration/standalone-openshift.xml
COPY --chown=185:0 ./s2i/bin ${STI_SCRIPTS_PATH}
ENV DATASOURCES="PORTDB,SERVDB" \
    PORTDB_NONXA="true" \
    PORTDB_JTA="false" \
    PORTDB_URL="jdbc:derby:/entando-data/databases/entandoPort;create=true" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    PORTDB_DRIVER="derby" \
    PORTDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    PORTDB_SERVICE_HOST="dummy" \
    PORTDB_SERVICE_PORT="1527" \
    SERVDB_NONXA="true" \
    SERVDB_JTA="false" \
    SERVDB_URL="jdbc:derby:/entando-data/databases/entandoServ;create=true" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    SERVDB_DRIVER="derby" \
    SERVDB_USERNAME="agile" \
    SERVDB_PASSWORD="agile" \
    SERVDB_SERVICE_HOST="dummy" \
    SERVDB_SERVICE_PORT="1527" \
    PREPARE_DATA="true" \
    DB_ENVIRONMENT="production" \
    DEPLOYMENTS_DIR="/opt/eap/standalone/deployments" \
    ENTANDO_OIDC_ACTIVE="false" \
    ENTANDO_OIDC_AUTH_LOCATION="http://dummy.com" \
    ENTANDO_OIDC_TOKEN_LOCATION="http://dummy.com" \
    ENTANDO_OIDC_CLIENT_ID="dummy" \
    ENTANDO_OIDC_REDIRECT_BASE_URL="http://dummy.com" \
    LOGFILEPREFIX="/var/log/entando/engine_" \
    LOGFILEROTATEPATTERN="/var/log/entando/engine_%i.log.gz" \
    LOGACTIVEFILEOUTPUT="true" \
    RESOURCEDISKROOTFOLDER="/entando-data/resources/" \
    PROTECTEDRESOURCEDISKROOTFOLDER="/entando-data/protected/" \
    INDEXDISKROOTFOLDER="/tmp/entando-indices"
USER root
RUN mkdir -p /entando-data/databases  && chown -Rf $USERID_TO_USE:0 /entando-data/ && chmod -Rf ug+rw /entando-data/ && \
    mkdir -p /entando-data-templates/databases  && chown -Rf $USERID_TO_USE:0 /entando-data-templates/ && chmod -Rf ug+rw /entando-data-templates/ && \
    mkdir -p /var/log/entando && chown -Rf $USERID_TO_USE:0 /var/log/entando && chmod -Rf ug+rw /var/log/entando

USER $USERID_TO_USE

CMD "${STI_SCRIPTS_PATH}/run"
#NB!!! Place the VOLUME declaration AFTER the state (permissions, ownership, content) of the volume has been set
VOLUME /entando-data
