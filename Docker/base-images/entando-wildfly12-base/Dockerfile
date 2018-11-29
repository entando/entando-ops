# This image provides a base for building and running Entando WildFly based applications.
# It builds using maven and runs the resulting artifacts on WildFly 12.0.0 Final
ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION AS dependencies

# Note to self: we couldn't use entando-wildfly12-quickstart-openshift because of permissions on Volumes TODO see if it is fixable
FROM openshift/wildfly-120-centos7:latest
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"
ARG ENTANDO_VERSION
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=1001

COPY --chown=1001:0 ./contrib/wildfly-configuration/standalone.xml /wildfly/standalone/configuration/standalone.xml
COPY --chown=1001:0 ./s2i/bin ${STI_SCRIPTS_PATH}
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/wildfly/modules /wildfly/modules
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/.m2/settings.xml $HOME/.m2/settings.xml
COPY --chown=1001:0 --from=dependencies /entando-data-templates /entando-data-templates
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
