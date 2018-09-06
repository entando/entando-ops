ARG ENTANDO_VERSION_TO_BUILD
FROM entando/entando-postgresql95-base:$ENTANDO_VERSION_TO_BUILD
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Postgresql Database Image for building and running Entando applications" \
      io.k8s.display-name="Postgresql Database Image for Entando 5"
ENV USERID_TO_USE=26
#Change to root for installation operations
COPY --chown=26:0 ./contrib/maven-setup /tmp/maven-setup
RUN cd /tmp/maven-setup/ && ./prepare_m2_repo.sh $ENTANDO_VERSION
CMD "$STI_SCRIPTS_PATH/usage"

