ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION as dependencies

FROM centos/postgresql-95-centos7:9.5
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Postgresql Database Image for building and running Entando applications" \
      io.k8s.display-name="Postgresql Database Image for Entando 5+"
ARG ENTANDO_VERSION
ENV MAVEN_VERSION="3.5.4" \
    JAVA_HOME="/usr/lib/jvm/java-1.8.0" \
    ENTANDO_VERSION=$ENTANDO_VERSION \
    POSTGRESQL_USER=agile \
    POSTGRESQL_PASSWORD=agile \
    POSTGRESQL_ADMIN_PASSWORD=postgres \
    POSTGRESQL_DATABASE=entandoPort \
    POSTGRESQL_DATABASE2=entandoServ \
    POSTGRESQL_MAX_PREPARED_TRANSACTIONS=0 \
    POSTGRESQL_SHARED_BUFFERS=32MB \
    USERID_TO_USE=26
#Change to root for installation operations
USER root
RUN INSTALL_PKGS="ant tar curl java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
  yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum clean all -y && \
  (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local) && \
  ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
  mkdir -p $HOME/.m2 && chmod ug+rw $HOME/.m2 && chown $USERID_TO_USE:0 $HOME/.m2

COPY --chown=26:0 ./common.sh /usr/share/container-scripts/postgresql/common.sh
COPY --chown=26:0 --from=dependencies /opt/app-root/src/.m2/settings.xml $HOME/.m2/settings.xml
COPY --chown=26:0 ./s2i/bin/ $STI_SCRIPTS_PATH
RUN mkdir -p /opt/s2i/destination && chmod -R ug+rw /opt/s2i/destination && chown -R $USERID_TO_USE:0 /opt/s2i/destination
USER $USERID_TO_USE
#And end by making the user postgres again
CMD "${STI_SCRIPTS_PATH}/run"
