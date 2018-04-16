FROM entando/base-builder-jetty

USER 1001

RUN mvn archetype:generate -B -Dfilter=entando \
-DarchetypeGroupId=org.entando.entando \
-DarchetypeArtifactId=entando-archetype-entando-sample \
-DgroupId=org.entando \
-DartifactId=entando-sample \
-Dversion=1.0-SNAPSHOT \
-Dpackage=org.entando \
-DarchetypeCatalog=local \
&& chown -R 1001:0 ${PROJECT_HOME}/ && chmod -R ug+w ${PROJECT_HOME}/

WORKDIR ${PROJECT_HOME}/entando-sample

EXPOSE 8080
CMD ["mvn", "-Dmaven.repo.local=/opt/entando/.m2/repository", "jetty:run"]