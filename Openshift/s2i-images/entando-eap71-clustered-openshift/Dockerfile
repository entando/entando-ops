ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:${ENTANDO_IMAGE_VERSION} as dependencies
FROM entando/entando-eap71-clustered-base:${ENTANDO_IMAGE_VERSION}
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando clustered applications on EAP 7.1" \
      io.k8s.display-name="Entando on EAP 7.1"
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=185
#add the dependencies temporarily to speed up builds. remove from final image
COPY --chown=185:0 --from=dependencies  /opt/app-root/src/.m2 $HOME/.m2

CMD "${STI_SCRIPTS_PATH}/usage"
ENV PORTDB_NONXA="true" \
    PORTDB_JTA="false" \
    PORTDB_URL="" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    PORTDB_DRIVER="postgresql" \
    PORTDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    PORTDB_SERVICE_HOST="postgresql" \
    PORTDB_SERVICE_PORT="5432" \
    SERVDB_NONXA="true" \
    SERVDB_JTA="false" \
    SERVDB_URL="" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    SERVDB_DRIVER="postgresql" \
    SERVDB_USERNAME="agile" \
    SERVDB_PASSWORD="agile" \
    SERVDB_SERVICE_HOST="postgresql" \
    SERVDB_SERVICE_PORT="5432"