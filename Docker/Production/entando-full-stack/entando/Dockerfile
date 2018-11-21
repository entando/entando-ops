ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-base:$ENTANDO_IMAGE_VERSION AS dependencies
ARG ENTANDO_VERSION
ENV ENTANDO_VERSION=${ENTANDO_VERSION}
RUN mkdir  -p /tmp/entando-init && \
    cd /tmp/entando-init && \
    mvn archetype:generate -B --settings $HOME/.m2/settings.xml \
        -Dfilter=entando \
        -DarchetypeGroupId=org.entando.entando \
        -DarchetypeArtifactId=entando-archetype-web-app-BPM \
        -DarchetypeVersion="${ENTANDO_VERSION}" \
        -DgroupId=org.entando \
        -DartifactId=entando \
        -Dversion=1.0 \
        -Dpackage=org.entando && \
     cd entando  && \
     mvn clean package -Popenshift -DskipTests \
            --batch-mode --settings $HOME/.m2/settings.xml \
            -Dprofile.portDataSourceClassName="org.apache.derby.jdbc.EmbeddedDriver" \
            -Dprofile.servDataSourceClassName="org.apache.derby.jdbc.EmbeddedDriver" \
            -Djboss=jboss \
            -Denv.db.environment=production \
            -Dprofile.config.version=production \
            -Dprofile.application.baseurl.protocol=http \
            -Dprofile.datasource.jndiname.servdb=${SERVDB_JNDI} \
            -Dprofile.datasource.jndiname.portdb=${PORTDB_JNDI} \
            -Dprofile.log.file.prefix=/entando-data/logs/log \
            -Dprofile.resources.path=/entando-data/resources \
            -Dprofile.resources.path.protected=/entando-data/protected \
            -Dprofile.index.path=/entando-data/indexdir \
            -Djava.net.preferIPv4Stack=true
FROM entando/entando-wildfly12-base:$ENTANDO_IMAGE_VERSION
COPY --chown=1001:0 --from=dependencies /tmp/entando-init/entando/target/entando.war /wildfly/standalone/deployments/
ENV PREPARE_DB="false"

