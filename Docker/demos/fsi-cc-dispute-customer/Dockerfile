
ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION AS dependencies
FROM entando/entando-wildfly12-base:$ENTANDO_IMAGE_VERSION AS wildflys2i
ARG ENTANDO_VERSION
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=1001
COPY --chown=1001:0 --from=dependencies  /opt/app-root/src/.m2 $HOME/.m2
RUN ls -al $HOME/.m2/repository/org/entando/entando
USER 1001
RUN mkdir -p /tmp/src  && cd /tmp/src && \
    git clone --depth 1 -b  v5.0.1-SNAPSHOT https://github.com/entando/fsi-cc-dispute-customer.git . && \
    ${STI_SCRIPTS_PATH}/assemble
FROM entando/entando-eap71-base:${ENTANDO_IMAGE_VERSION}
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=185
COPY --chown=185:0 --from=wildflys2i /wildfly/standalone/deployments/fsi-credit-card-dispute-customer.war /opt/eap/standalone/deployments/
RUN rm -Rf /entando-data-templates/*
COPY --chown=185:0 --from=wildflys2i /entando-data-templates /entando-data-templates
