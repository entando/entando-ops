FROM sonatype/nexus3:3.12.1
ENV MAVEN_VERSION="3.5.4" \
    ENTANDO_VERSION="5.0.1"

MAINTAINER Ampie Barnard "<a.barnard@entando.com>"

LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
            name="Nexus30 With Entando Dependencies for faster builds" \
            vendor="Entando Srl" \
            version="1.0" \
            release="5.0.1" \
            license="lgplv2.1" \
            summary="This is an extended Nexus 3 image with the entando dependencies installed." \
            description="This is an extended Nexus 3 image with the entando dependencies installed."


#Change to root for installation operations
USER root
RUN INSTALL_PKGS="curl git java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
  yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
  rpm -V $INSTALL_PKGS && \
  yum clean all -y && \
  (curl -v https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local) && \
  ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
  mkdir -p /opt/sonatype/nexus/.m2 && chmod ug+rw /opt/sonatype/nexus/.m2 && chown 200:root /opt/sonatype/nexus/.m2
#stay in root to ensure chmod works
COPY maven-setup /tmp/maven-setup
RUN chmod -Rf ug+rw /tmp/maven-setup && chown -Rf 200:root /tmp/maven-setup
RUN mkdir /nexus-data-template && chmod -Rf ug+rw /nexus-data-template && chown -Rf 200:root /nexus-data-template

#Prepare the Maven repo as 200
USER 200
WORKDIR /tmp/maven-setup/
#RUN ./prepare_m2_repo.sh  5.0.1-SNAPSHOT && ./prepare_m2_repo.sh 5.1.0-SNAPSHOT
WORKDIR /opt/sonatype/nexus/

#CMD ["./start.sh"]
USER root
COPY start.sh /opt/sonatype/nexus/
RUN chmod ug+x /opt/sonatype/nexus/start.sh && chown 200:root /opt/sonatype/nexus/start.sh
USER 200
