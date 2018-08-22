FROM openshift/jenkins-slave-maven-centos7:v3.9
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Jenkins image for building and Entando quickstart applications with a pre-cached maven repository" \
      io.k8s.display-name="Entando build with Jenkins "
ARG ENTANDO_VERSION_TO_BUILD
ENV ENTANDO_VERSION=$ENTANDO_VERSION_TO_BUILD
USER root
COPY settings.xml $HOME/.m2/settings.xml
RUN chmod -f ug+rw $HOME/.m2/settings.xml && chown -f 1001:root $HOME/.m2/settings.xml
COPY maven-setup /tmp/maven-setup
RUN chmod -Rf ug+rw /tmp/maven-setup/ && chown -Rf 1001:root /tmp/maven-setup/
#Prepare the Maven repo as 1001
USER 1001
RUN cd /tmp/maven-setup && ./prepare_m2_repo.sh ${ENTANDO_VERSION}
