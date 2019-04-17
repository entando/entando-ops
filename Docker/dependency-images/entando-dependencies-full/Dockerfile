ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    STI_SCRIPTS_PATH="/usr/libexec/s2i" \
    USERID_TO_USE=1001 \
    MAVEN_MIRROR_URL="${MAVEN_MIRROR_FOR_DOCKER_BUILDS}"
COPY --chown=1001:0 ./entando-dependencies-bootstrap "${ENTANDO_COMMON_PATH}"
ENV PORTDB_NONXA="true" \
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
RUN  ${ENTANDO_COMMON_PATH}/init-dependencies.sh
ENV MAVEN_MIRROR_URL="" \
