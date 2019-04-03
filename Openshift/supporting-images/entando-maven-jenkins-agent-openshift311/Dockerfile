ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-full:$ENTANDO_IMAGE_VERSION AS dependencies
FROM openshift/jenkins-agent-maven-35-centos7:v3.11
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
LABEL maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Jenkins image for building and Entando quickstart applications with a pre-cached maven repository" \
      io.k8s.display-name="Entando build with Jenkins "
ENV ENTANDO_VERSION=$ENTANDO_VERSION \
    USERID_TO_USE=1001 \
    ENTANDO_COMMON_PATH=/entando-common \
    DOCKER_HOST=tcp://172.17.0.1:2375
USER root
RUN yum install -y yum-utils  device-mapper-persistent-data lvm2 && \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum -y install docker-ce
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/.m2 $HOME/.m2
COPY --chown=1001:0 --from=dependencies ${ENTANDO_COMMON_PATH} ${ENTANDO_COMMON_PATH}
USER 1001
