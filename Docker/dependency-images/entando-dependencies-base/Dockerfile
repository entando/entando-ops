FROM openshift/wildfly-120-centos7:latest
ARG ENTANDO_VERSION
ARG ENTANDO_IMAGE_VERSION
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    STI_SCRIPTS_PATH="/usr/libexec/s2i" \
    USERID_TO_USE=1001

COPY --chown=1001:0 ./s2i/bin ${STI_SCRIPTS_PATH}
COPY --chown=1001:0 ./settings.xml $HOME/.m2/settings.xml
COPY --chown=1001:0 ./wfmodules $HOME/wildfly/modules

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
RUN mkdir -p /entando-data/databases  && chown -Rf $USERID_TO_USE:0 /entando-data/ && chmod -Rf ug+rw /entando-data/ && \
    mkdir -p /entando-data-templates && chown -Rf $USERID_TO_USE:0 /entando-data-templates/ && chmod -Rf ug+rw /entando-data-templates/ && \
    ${STI_SCRIPTS_PATH}/init-db-and-dependencies.sh
USER $USERID_TO_USE
#Now we have all the dependencies sitting at $HOME./m2/settings
