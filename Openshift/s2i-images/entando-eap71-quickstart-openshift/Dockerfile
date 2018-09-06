# This image provides a very lightweight base for building and running Entando
# EAP based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on EAP

ARG ENTANDO_VERSION_TO_BUILD
FROM entando/entando-eap71-base:${ENTANDO_VERSION_TO_BUILD}
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on EAP 7.1" \
      io.k8s.display-name="Entando on EAP 7.1"
ENV  USERID_TO_USE=185
#stay in root to ensure chmod works
USER root
COPY --chown=185:0 ./contrib/maven-setup /tmp/maven-setup
#Run all of this as $USERID_TO_USE as this will be the user under which the S2I build takes place
USER $USERID_TO_USE
RUN source /opt/rh/rh-maven35/enable && cd /tmp/maven-setup && ./prepare_m2_repo.sh $ENTANDO_VERSION


USER root
USER $USERID_TO_USE
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
    SERVDB_SERVICE_PORT="1527"
COPY --chown=185:0 ./settings.xml $HOME/.m2/settings.xml
COPY --chown=185:0 ./s2i/bin ${STI_SCRIPTS_PATH}
