# This image provides a very lightweight base for building and running Entando
# Wildfly based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on Wildfly

ARG ENTANDO_VERSION_TO_BUILD
FROM entando/entando-wildfly12-base:${ENTANDO_VERSION_TO_BUILD}
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Platform for building and running Entando quickstart applications on WildFly 12.0.0.Final" \
      io.k8s.display-name="Entando on WildFly 12.0.0.Final"

#stay in root to ensure chmod works
USER root
COPY ./contrib/maven-setup /tmp/maven-setup
RUN chmod -Rf ug+rw /tmp/maven-setup && chown -Rf 1001:root /tmp/maven-setup

#Prepare M2 cachess. Run all of this as 1001 as this will be the user under which the S2I build takes place
USER 1001
RUN cd /tmp/maven-setup && ./prepare_m2_repo.sh $ENTANDO_VERSION

# Add s2i optimizationss
COPY ./s2i/bin/ /usr/libexec/s2i/
USER root
RUN chown -Rf 1001:0 /usr/libexec/s2i/ && chmod -Rf ug+rwx /usr/libexec/s2i/
USER 1001
CMD "${STI_SCRIPTS_PATH}/usage"
ENV DB_SERVICE_PREFIX_MAPPING="portdb-derby=PORTDB,servdb-derby=SERVDB" \
    PORTDB_NONXA="true" \
    PORTDB_JTA="false" \
    PORTDB_URL="jdbc:derby:/entando-data/databases/entandoPort" \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    PORTDB_DRIVER="derby" \
    PORTDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    PORTDB_SERVICE_HOST="dummy" \
    PORTDB_SERVICE_PORT="1527" \
    SERVDB_NONXA="true" \
    SERVDB_JTA="false" \
    SERVDB_URL="jdbc:derby:/entando-data/databases/entandoServ" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    SERVDB_DRIVER="derby" \
    SERVDB_USERNAME="agile" \
    SERVDB_PASSWORD="agile" \
    SERVDB_SERVICE_HOST="dummy" \
    SERVDB_SERVICE_PORT="1527"
