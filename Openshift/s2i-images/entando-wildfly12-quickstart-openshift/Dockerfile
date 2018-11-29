# This image provides a very lightweight base for building and running Entando
# Wildfly based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on Wildfly

ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:${ENTANDO_IMAGE_VERSION} AS dependencies

FROM entando/entando-wildfly12-base:${ENTANDO_IMAGE_VERSION}
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"
ARG ENTANDO_VERSION
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=1001
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/.m2 $HOME/.m2
CMD "${STI_SCRIPTS_PATH}/usage"
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
