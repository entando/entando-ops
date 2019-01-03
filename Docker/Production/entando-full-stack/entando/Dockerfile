ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-full:$ENTANDO_IMAGE_VERSION AS dependencies
ARG ENTANDO_VERSION
ENV ENTANDO_VERSION=${ENTANDO_VERSION}
RUN mkdir -p /tmp/entando && cd /tmp/entando  && \
    BRANCH=${ENTANDO_VERSION%-*} && \
    if [[ "$ENTANDO_VERSION" = *"-SNAPSHOT" ]]; then  BRANCH="${BRANCH}-dev";  else  BRANCH="${BRANCH}"; fi && \
    curl -L "https://github.com/entando/entando-sample-full/archive/v${BRANCH}.zip" -o entando-sample-full.zip  && \
    unzip entando-sample-full.zip  && \
    cd entando-sample-full-${BRANCH}  && \
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
            -Dprofile.log.file.prefix=/wildfly/standalone/log/entando \
            -Dprofile.resources.path=/entando-data/resources \
            -Dprofile.resources.path.protected=/entando-data/protected \
            -Dprofile.index.path=/entando-data/indexdir \
            -Djava.net.preferIPv4Stack=true && \
    mv target/entando-sample-full.war ../
FROM entando/entando-wildfly12-base:$ENTANDO_IMAGE_VERSION
COPY --chown=1001:0 --from=dependencies /tmp/entando/entando-sample-full.war /wildfly/standalone/deployments/entando.war
RUN $STI_SCRIPTS_PATH/init-derby-from-war.sh --war-file=/wildfly/standalone/deployments/entando.war
