ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION as dependencies

FROM centos/mysql-57-centos7:latest
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="MySQL Database Image for building and running Entando applications" \
      io.k8s.display-name="MySQL Database Image for Entando 5+"
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV MAVEN_VERSION="3.5.4" \
    JAVA_HOME="/usr/lib/jvm/java-1.8.0" \
    ENTANDO_VERSION=$ENTANDO_VERSION \
    USERID_TO_USE=27 \
    STI_SCRIPTS_PATH="/usr/libexec/s2i" \
    ENTANDO_COMMON_PATH="/entando-common"
#Change to root for installation operations
USER root
RUN INSTALL_PKGS="ant tar curl java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
  yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum clean all -y && \
  (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local) && \
  ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
  mkdir -p $HOME/.m2 && chmod ug+rw $HOME/.m2 && chown $USERID_TO_USE:0 $HOME/.m2
ENV PORTDB_USERNAME=agile \
    PORTDB_PASSWORD=agile \
    SERVDB_USERNAME=agile1 \
    SERVDB_PASSWORD=agile1 \
    ADMIN_PASSWORD=mysql123 \
    PORTDB_DATABASE=entandoPort \
    SERVDB_DATABASE=entandoServ \
    PORTDB_DRIVER=mysql \
    SERVDB_DRIVER=mysql \
    PORTDB_JNDI="java:jboss/datasources/entandoPortDataSource" \
    SERVDB_JNDI="java:jboss/datasources/entandoServDataSource" \
    ENV_FILES="" \
    PREPARE_DATA="true" \
    DB_ENVIRONMENT="production" \
    LOGFILEPREFIX="/var/log/entando/engine_" \
    LOGNAME="/var/log/entando/engine.log" \
    LOGFILEROTATEPATTERN="/var/log/entando/engine_%i.log.gz" \
    LOGACTIVEFILEOUTPUT="true"

COPY --chown=27:0 ./mysql /usr/share/container-scripts/mysql
COPY --chown=27:0 --from=dependencies /opt/app-root/src/.m2/settings.xml $HOME/.m2/settings.xml
COPY --chown=27:0 --from=dependencies /opt/app-root/src/jetty-runner /jetty-runner
COPY --chown=27:0 --from=dependencies ${ENTANDO_COMMON_PATH} ${ENTANDO_COMMON_PATH}
COPY --chown=27:0 ./s2i/bin/ $STI_SCRIPTS_PATH
COPY test /etc/mysql-test-datasources
RUN mkdir -p /opt/s2i/destination && chmod -R ug+rw /opt/s2i/destination && chown -R $USERID_TO_USE:0 /opt/s2i/destination && \
    mkdir -p /entando-data/databases  && chown -Rf $USERID_TO_USE:0 /entando-data/ && chmod -Rf ug+rw /entando-data/ && \
    mkdir -p /entando-data-templates/databases  && chown -Rf $USERID_TO_USE:0 /entando-data-templates/ && chmod -Rf ug+rw /entando-data-templates/ && \
    mkdir -p /var/log/entando && chown -Rf $USERID_TO_USE:0 /var/log/entando && chmod -Rf ug+rw /var/log/entando

USER $USERID_TO_USE
#And end by making the user mysql  again
CMD "${STI_SCRIPTS_PATH}/run"
