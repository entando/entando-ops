FROM openshift/jenkins-slave-maven-centos7:v3.9
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Jenkins image for building and Entando quickstart applications with a pre-cached maven repository" \
      io.k8s.display-name="Entando build with Jenkins "
ARG ENTANDO_IMAGE_VERSION
ENV ENTANDO_VERSION=$ENTANDO_IMAGE_VERSION \
    USERID_TO_USE=1001
COPY --chown=1001:0 ./contrib/settings.xml $HOME/.m2/settings.xml
COPY --chown=1001:0 ./contrib/maven-setup /tmp/maven-setup
#Prepare the Maven repo as 1001
USER 1001
RUN cd /tmp/maven-setup && ./prepare_m2_repo.sh ${ENTANDO_VERSION}
