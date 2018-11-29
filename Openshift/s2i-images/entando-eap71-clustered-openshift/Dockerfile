# This image provides a very lightweight base for building and running Entando
# EAP based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on EAP

ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:${ENTANDO_IMAGE_VERSION} as dependencies
FROM entando/entando-eap71-base:${ENTANDO_IMAGE_VERSION}
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on EAP 7.1" \
      io.k8s.display-name="Entando on EAP 7.1"
ARG ENTANDO_VERSION
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=185
#add the dependencies temporarily to speed up builds. remove from final image
COPY --chown=185:0 --from=dependencies  /opt/app-root/src/.m2 $HOME/.m2
COPY --chown=185:0 ./standalone-openshift.xml /opt/eap/standalone/configuration
COPY --chown=185:0 ./s2i/bin ${STI_SCRIPTS_PATH}

CMD "${STI_SCRIPTS_PATH}/usage"
ENV DB_SERVICE_PREFIX_MAPPING="portdb-postgresql=PORTDB,servdb-postgresql=SERVDB" \
    PORTDB_NONXA="true" \
    PORTDB_JTA="false" \
    PORTDB_URL="jdbc:postgresql://postgresql:5432/entandoPort" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    PORTDB_DRIVER="postgresql" \
    PORTDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    PORTDB_SERVICE_HOST="postgresql" \
    PORTDB_SERVICE_PORT="5432" \
    SERVDB_NONXA="true" \
    SERVDB_JTA="false" \
    SERVDB_URL="jdbc:postgresql://postgresql:5432/entandoServ" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    SERVDB_DRIVER="postgresql" \
    SERVDB_USERNAME="agile" \
    SERVDB_PASSWORD="agile" \
    SERVDB_SERVICE_HOST="postgresql" \
    SERVDB_SERVICE_PORT="5432"