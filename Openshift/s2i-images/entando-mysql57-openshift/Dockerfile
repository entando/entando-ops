ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:${ENTANDO_IMAGE_VERSION} AS dependencies

FROM entando/entando-mysql57-base:$ENTANDO_IMAGE_VERSION
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="MySQL Database Image for building and running Entando applications" \
      io.k8s.display-name="MySQL Database Image for Entando 5"
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=26
COPY --chown=26:0 --from=dependencies  /opt/app-root/src/.m2 $HOME/.m2
CMD "$STI_SCRIPTS_PATH/usage"