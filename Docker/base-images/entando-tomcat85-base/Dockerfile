# This image provides a very lightweight base for building and running Entando 
# EAP based applications with an embedded Derby db.
# It builds using maven and runs the resulting artifacts on EAP 
ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION AS dependencies

FROM openshift/base-centos7
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
LABEL io.k8s.description="Platform for building and running Entando applications on Apache-Tomcat 8.5.42" \
      io.k8s.display-name="Entando Apache-Tomcat 8.5.42" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,tomcat,tomcat8.5,entando" \
      io.openshift.s2i.destination="/opt/s2i/destination"

ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    STI_SCRIPTS_PATH="/usr/local/s2i" \
    USERID_TO_USE=1001 \
    DATASOURCES="PORTDB,SERVDB" \
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
    PREPARE_DATA="true" \
    DB_ENVIRONMENT="production" \
    DEPLOYMENTS_DIR="/tomcat/webapps" \
    ENTANDO_OIDC_ACTIVE="false" \
    ENTANDO_OIDC_AUTH_LOCATION="http://dummy.com" \
    ENTANDO_OIDC_TOKEN_LOCATION="http://dummy.com" \
    ENTANDO_OIDC_CLIENT_ID="dummy" \
    ENTANDO_OIDC_REDIRECT_BASE_URL="http://dummy.com" \
    LOGFILEPREFIX="/var/log/entando/engine_" \
    LOGNAME="/var/log/entando/engine.log" \
    LOGACTIVEFILEOUTPUT="true" \
    LOGFILEROTATEPATTERN="/var/log/entando/engine_%i.log.gz" \
    RESOURCEDISKROOTFOLDER="/entando-data/resources/" \
    PROTECTEDRESOURCEDISKROOTFOLDER="/entando-data/protected/" \
    INDEXDISKROOTFOLDER="/tmp/entando-indices" \
    TOMCAT_VERSION="8.5.42" \
    TOMCAT_MAJOR=8 \
    MAVEN_VERSION=3.5.4 \
    TOMCAT_DISPLAY_VERSION="8.5" \
    CATALINA_HOME="/tomcat" \
    JAVA="java-1.8.0-openjdk java-1.8.0-openjdk-devel" \
    JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8" \
    POM_PATH=.\
    ENTANDO_COMMON_PATH="/entando-common"
USER root

# Install Maven, Tomcat, Java
RUN chown -R 1001:0 $HOME && \
    INSTALL_PKGS="tar unzip bc which lsof ImageMagick $JAVA" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 && \
    mkdir -p /tomcat && \
    (curl -v https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz | tar -zx --strip-components=1 -C /tomcat) && \
    chown -R $USERID_TO_USE:0 /tomcat &&  chmod -R ug+rwx /tomcat && \
    mkdir -p /opt/s2i/destination && chmod -R g+rw /opt/s2i/destination && \
    mkdir -p /entando-data/databases  && chown -Rf $USERID_TO_USE:0 /entando-data/ && chmod -Rf ug+rw /entando-data/ && \
    mkdir -p /entando-data-templates/databases  && chown -Rf $USERID_TO_USE:0 /entando-data-templates/ && chmod -Rf ug+rw /entando-data-templates/ && \
    mkdir -p /var/log/entando && chown -Rf $USERID_TO_USE:0 /var/log/entando && chmod -Rf ug+rw /var/log/entando


COPY --chown=1001:0 --from=dependencies /opt/app-root/src/.m2/settings.xml $HOME/.m2/settings.xml
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/jetty-runner/derby-10.9.1.0.jar /tomcat/lib/
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/jetty-runner/derbyclient-10.9.1.0.jar /tomcat/lib/
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/jetty-runner/mysql-connector-java-5.1.44-bin.jar /tomcat/lib/
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/jetty-runner/postgresql-9.4.1211.jar /tomcat/lib/
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/jetty-runner /jetty-runner
COPY --chown=1001:0 --from=dependencies ${ENTANDO_COMMON_PATH} ${ENTANDO_COMMON_PATH}
COPY --chown=1001:0 context.xml /tomcat/conf/
COPY --chown=1001:0 logging.properties /tomcat/conf/
COPY --chown=1001:0 jstl-1.2.jar /tomcat/lib/
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH
CMD "${STI_SCRIPTS_PATH}/run"
USER $USERID_TO_USE

#NB!!! Place the VOLUME declaration AFTER the state (permissions, ownership, content) of the volume has been set
VOLUME /entando-data

EXPOSE 8080
