ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-full:$ENTANDO_IMAGE_VERSION as dependencies

FROM entando/entando-postgresql95-base:$ENTANDO_IMAGE_VERSION as database-template
COPY --chown=26:0 --from=dependencies  /opt/app-root/src/.m2 /var/lib/pgsql/.m2
COPY --chown=26:0 ./s2i/bin/ $STI_SCRIPTS_PATH
RUN  $STI_SCRIPTS_PATH/init-default-postgresql-db.sh

FROM entando/entando-postgresql95-base:$ENTANDO_IMAGE_VERSION
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Postgresql Database Image with a pre-configured Entando database" \
      io.k8s.display-name="Postgresql Database Image for Entando 5+"
ARG ENTANDO_VERSION
ENV ENTANDO_VERSION=$ENTANDO_VERSION \
    USERID_TO_USE=26
COPY --chown=26:0 --from=database-template /var/lib/pgsql/data_template /var/lib/pgsql/data_template
