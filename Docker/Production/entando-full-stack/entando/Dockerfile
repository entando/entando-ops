ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-full:$ENTANDO_IMAGE_VERSION AS dependencies
ARG ENTANDO_VERSION
FROM entando/entando-wildfly12-base:$ENTANDO_IMAGE_VERSION as builder
ARG MAVEN_MIRROR_FOR_DOCKER_BUILDS
ENV ENTANDO_VERSION=${ENTANDO_VERSION} \
    MAVEN_MIRROR_URL="${MAVEN_MIRROR_FOR_DOCKER_BUILDS}" \
    ENTANDO_COMMON_PATH="/entando-common" \
    servDataSourceClassName=com.mysql.jdbc.Driver \
    portDataSourceClassName=com.mysql.jdbc.Driver
COPY --chown=1001:0 --from=dependencies /opt/app-root/src/.m2 $HOME/.m2
COPY --chown=1001:0 --from=dependencies ${ENTANDO_COMMON_PATH}  ${ENTANDO_COMMON_PATH}
RUN $ENTANDO_COMMON_PATH/inject-maven-docker-build-mirror.sh && \
    mkdir -p /tmp/entando && cd /tmp/entando  && \
    BRANCH=$(${ENTANDO_COMMON_PATH}/determine-branch.sh)  && \
    curl -L "https://github.com/entando/entando-sample-full/archive/${BRANCH}.zip" -o entando-sample-full.zip  && \
    unzip entando-sample-full.zip  && \
    pushd entando-sample-full-*  && \
    mvn clean package -Popenshift -DskipTests \
            --batch-mode --settings $HOME/.m2/settings.xml \
            -Dprofile.portDataSourceClassName="org.apache.derby.jdbc.EmbeddedDriver" \
            -Dprofile.servDataSourceClassName="org.apache.derby.jdbc.EmbeddedDriver" \
            -Djboss=jboss \
            -Denv.db.environment=production \
            -Dprofile.application.name=entando \
            -Dprofile.config.version=production \
            -Dprofile.application.baseurl.protocol=http \
            -Dprofile.datasource.jndiname.servdb=${SERVDB_JNDI} \
            -Dprofile.datasource.jndiname.portdb=${PORTDB_JNDI} \
            -Dprofile.log.file.prefix=/var/log/entando/engine_ \
            -Dprofile.log.activeFileOutput=true \
            -Dprofile.resources.path=/entando-data/resources \
            -Dprofile.resources.path.protected=/entando-data/protected \
            -Dprofile.index.path=/entando-data/indexdir \
            -Djava.net.preferIPv4Stack=true && \
    mv target/entando-sample-full.war ../ && \
    ${ENTANDO_COMMON_PATH}/init-derby-from-war.sh --war-file=/tmp/entando/entando-sample-full.war && \
    $ENTANDO_COMMON_PATH/restore-settings-xml.sh
ENV MAVEN_MIRROR_URL=""
FROM entando/entando-wildfly12-base:$ENTANDO_IMAGE_VERSION
ENV resourceRootURL=/entando/resources/ \
    protectedResourceRootURL=/entando/protected/
COPY --chown=1001:0 --from=builder /tmp/entando/entando-sample-full.war /wildfly/standalone/deployments/entando.war
COPY --chown=1001:0 --from=builder /entando-data-templates /entando-data-templates
