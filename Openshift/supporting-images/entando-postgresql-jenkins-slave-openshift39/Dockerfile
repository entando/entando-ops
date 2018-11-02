ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-maven-jenkins-slave-openshift39:$ENTANDO_IMAGE_VERSION
ARG ENTANDO_VERSION
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Jenkins image for building and Entando applications with a pre-cached maven repository, a PostgreSQL client and some helper scripts" \
      io.k8s.display-name="Entando PostgreSQL build with Jenkins "
ENV ENTANDO_VERSION=$ENTANDO_VERSION \
    USERID_TO_USE=1001
USER root
RUN yum -y update-minimal --setopt=tsflags=nodocs --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-3.noarch.rpm && \
    yum  -y install postgresql95 && \
    yum clean all && \
    rm -rf /var/cache/yum/*
USER 1001
ADD --chown=1001:root ./s2i/bin/ $HOME
ENV PORTDB_URL="jdbc:postgresql://postgresql.svc:5432/entandoPort" \
    SERVDB_URL="jdbc:postgresql://postgresql.svc:5432/entandoServ" \
    PORTDB_USERNAME="agile" \
    SERVDB_USERNAME="agile" \
    PORTDB_PASSWORD="agile" \
    SERVDB_PASSWORD="agile" \
    POSTGRESQL_ADMIN="psql" \
    POSTGRESQL_ADMIN_PASSWORD="psql"
