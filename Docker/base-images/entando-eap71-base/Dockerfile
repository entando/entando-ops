# This image provides a very lightweight base for building and running Entando 
# EAP based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on EAP 
ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION AS dependencies

FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:1.3
ARG ENTANDO_VERSION
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
    USERID_TO_USE=185
COPY --chown=185:0 --from=dependencies  /opt/app-root/src/wildfly/modules /opt/eap/modules
COPY --chown=185:0 --from=dependencies /opt/app-root/src/.m2/settings.xml $HOME/.m2/settings.xml
COPY --chown=185:0 --from=dependencies /entando-data-templates /entando-data-templates
COPY --chown=185:0 ./contrib/wildfly-configuration/standalone-openshift.xml /opt/eap/standalone/configuration/standalone-openshift.xml
COPY --chown=185:0 ./s2i/bin ${STI_SCRIPTS_PATH}
ENV DB_SERVICE_PREFIX_MAPPING="portdb-derby=PORTDB,servdb-derby=SERVDB" \
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
    PREPARE_DATA="true"
USER root
RUN mkdir -p /entando-data/databases  && chown -Rf $USERID_TO_USE:0 /entando-data/ && chmod -Rf ug+rw /entando-data/
USER $USERID_TO_USE

CMD "${STI_SCRIPTS_PATH}/run"
#NB!!! Place the VOLUME declaration AFTER the state (permissions, ownership, content) of the volume has been set
VOLUME /entando-data
