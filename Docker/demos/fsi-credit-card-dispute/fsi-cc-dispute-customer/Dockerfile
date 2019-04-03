ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION AS dependencies
FROM entando/entando-wildfly12-base:$ENTANDO_IMAGE_VERSION AS wildflys2i
ARG ENTANDO_VERSION
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    MAVEN_MIRROR_URL="${MAVEN_MIRROR_FOR_DOCKER_BUILDS}" \
    ENTANDO_COMMON_PATH="/entando-common" \
    USERID_TO_USE=1001
COPY --chown=1001:0 --from=dependencies  /opt/app-root/src/.m2 $HOME/.m2
COPY --chown=1001:0 --from=dependencies ${ENTANDO_COMMON_PATH}  ${ENTANDO_COMMON_PATH}
USER 1001
RUN ${ENTANDO_COMMON_PATH}/inject-maven-docker-build-mirror.sh && \
    mkdir -p /tmp/src  && cd /tmp/src && \
    BRANCH=$(${ENTANDO_COMMON_PATH}/determine-branch.sh)  && \
    git clone --depth 1 -b ${BRANCH} https://github.com/entando/fsi-cc-dispute-customer.git . && \
    ${STI_SCRIPTS_PATH}/assemble
FROM entando/entando-eap71-base:${ENTANDO_IMAGE_VERSION}
ENV ENTANDO_VERSION="$ENTANDO_VERSION" \
    USERID_TO_USE=185
COPY --chown=185:0 --from=wildflys2i /wildfly/standalone/deployments/fsi-credit-card-dispute-customer.war /opt/eap/standalone/deployments/
RUN rm -Rf /entando-data-templates/*
COPY --chown=185:0 --from=wildflys2i /entando-data-templates /entando-data-templates
