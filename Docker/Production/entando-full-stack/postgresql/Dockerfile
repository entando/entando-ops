ARG ENTANDO_IMAGE_VERSION
FROM entando/engine-api:$ENTANDO_IMAGE_VERSION as server-image

FROM entando/entando-postgresql95-base:$ENTANDO_IMAGE_VERSION as database-template
ENV PORTDB_DATABASE=portdb \
    PORTDB_USERNAME=portdb \
    PORTDB_PASSWORD=portdb \
    SERVDB_DATABASE=servdb \
    SERVDB_USERNAME=servdb \
    SERVDB_PASSWORD=servdb \
    ADMIN_PASSWORD=adminpwd \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource"
COPY --chown=26:0 --from=server-image /wildfly/standalone/deployments/entando.war /tmp/entando.war
RUN  source /usr/share/container-scripts/postgresql/translate-variables.sh && $STI_SCRIPTS_PATH/init-postgresql-from-war.sh --war-file=/tmp/entando.war

FROM entando/entando-postgresql95-base:$ENTANDO_IMAGE_VERSION
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Postgresql Database Image with a pre-configured Entando database" \
      io.k8s.display-name="Postgresql Database Image for Entando 5+"
ARG ENTANDO_VERSION
ENV PORTDB_DATABASE=portdb \
    PORTDB_USERNAME=portdb \
    PORTDB_PASSWORD=portdb \
    SERVDB_DATABASE=servdb \
    SERVDB_USERNAME=servdb \
    SERVDB_PASSWORD=servdb \
    ADMIN_PASSWORD=adminpwd
ENV ENTANDO_VERSION=$ENTANDO_VERSION \
    USERID_TO_USE=26
COPY --chown=26:0 --from=database-template /var/lib/pgsql/data_template /var/lib/pgsql/data_template
