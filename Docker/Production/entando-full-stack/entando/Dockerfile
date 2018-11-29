ARG ENTANDO_IMAGE_VERSION
FROM entando/entando-dependencies-full:$ENTANDO_IMAGE_VERSION AS dependencies
ARG ENTANDO_VERSION
ENV ENTANDO_VERSION=${ENTANDO_VERSION}
RUN mkdir -p /tmp/entando && cd /tmp/entando  && \
    curl -L "https://github.com/entando/entando-sample-full/archive/v${ENTANDO_VERSION}.zip" -o entando-sample-full.zip  && \
    unzip entando-sample-full.zip  && \
    cd entando-sample-full-${ENTANDO_VERSION}  && \
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
            -Djava.net.preferIPv4Stack=true
FROM entando/entando-wildfly12-base:$ENTANDO_IMAGE_VERSION
RUN rm -Rf /entando-data-templates/*
COPY --chown=185:0 --from=dependencies /entando-data-templates /entando-data-templates
COPY --chown=1001:0 --from=dependencies /tmp/entando/entando-sample-full-${ENTANDO_VERSION}/target/entando-sample-full.war /wildfly/standalone/deployments/entando.war
ENV PREPARE_DATA="false"

