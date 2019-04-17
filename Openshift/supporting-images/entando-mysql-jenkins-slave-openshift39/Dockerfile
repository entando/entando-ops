ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-maven-jenkins-slave-openshift39:$ENTANDO_IMAGE_VERSION
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Jenkins image for building and Entando applications with a pre-cached maven repository, a MySQL client and some helper scripts" \
      io.k8s.display-name="Entando MySQL build with Jenkins "
ENV ENTANDO_VERSION=$ENTANDO_VERSION \
    USERID_TO_USE=1001
USER root
RUN yum -y update-minimal --setopt=tsflags=nodocs --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install mysql && \
    yum clean all && \
    rm -rf /var/cache/yum/*
USER 1001
ADD --chown=1001:root ./s2i/bin/ $HOME
ENV PORTDB_URL="jdbc:mysql://mysql.svc:5432/entandoPort" \
    SERVDB_URL="jdbc:mysql://mysql.svc:5432/entandoServ" \
    PORTDB_USERNAME="agile" \
    SERVDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    SERVDB_PASSWORD="agile" \
    MYSQL_ADMIN="admin" \
    MYSQL_ADMIN_PASSWORD="Password1"
