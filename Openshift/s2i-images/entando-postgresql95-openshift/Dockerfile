
ARG ENTANDO_VERSION_TO_BUILD
FROM entando/entando-postgresql95-base:$ENTANDO_VERSION_TO_BUILD
LABEL io.openshift.s2i.destination="/opt/s2i/destination" \
      maintainer="Ampie Barnard <a.barnard@entando.com>" \
      io.k8s.description="Postgresql Database Image for building and running Entando applications" \
      io.k8s.display-name="Postgresql Database Image for Entando 5"
#Change to root for installation operations
USER root
COPY ./contrib/maven-setup /tmp/maven-setup
RUN chmod -Rf ug+rw /tmp/maven-setup && chown -Rf $USERID_TO_USE:root /tmp/maven-setup

#The user 'postgres' is $USERID_TO_USE, and openshift requires the numeric:
#Run all of this as postgres as this will be the user under which the S2I build takes place
USER $USERID_TO_USE
RUN cd /tmp/maven-setup/ && ./prepare_m2_repo.sh $ENTANDO_VERSION
CMD "$STI_SCRIPTS_PATH/usage"

