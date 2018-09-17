ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:${ENTANDO_IMAGE_VERSION} AS dependencies

FROM entando/entando-postgresql95-base:$ENTANDO_IMAGE_VERSION
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Postgresql Database Image for building and running Entando applications" \
      io.k8s.display-name="Postgresql Database Image for Entando 5"
ARG ENTANDO_VERSION
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=26
COPY --chown=185:0 --from=dependencies  /opt/app-root/src/.m2 $HOME/.m2
CMD "$STI_SCRIPTS_PATH/usage"


