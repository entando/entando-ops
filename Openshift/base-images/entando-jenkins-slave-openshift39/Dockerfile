FROM openshift/jenkins-slave-maven-centos7:v3.9
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Jenkins image for building and Entando quickstart applications with a pre-cached maven repository" \
      io.k8s.display-name="Entando build with Jenkins "

ENV ENTANDO_VERSION="5.0.1"
COPY maven-setup /tmp/maven-setup
USER root
RUN chmod -Rf ug+rw /tmp/maven-setup/ && chown -Rf 1001:root /tmp/maven-setup/
#Prepare the Maven repo as 1001
USER 1001
RUN cd /tmp/maven-setup && ./prepare_m2_repo.sh ${ENTANDO_VERSION}
