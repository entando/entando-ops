FROM builder

USER 0

RUN mvn archetype:generate -B -Dfilter=entando \
-DarchetypeGroupId=org.entando.entando \
-DarchetypeArtifactId=entando-archetype-web-app-BPM \
-DgroupId=org.entando \
-DartifactId=entando \
-Dversion=1.0-SNAPSHOT \
-Dpackage=org.entando \
-DarchetypeCatalog=local \
&& chown -R 1001:0 ${PROJECT_HOME}/ && chmod -R ug+w ${PROJECT_HOME}/

WORKDIR ${PROJECT_HOME}/entando

EXPOSE 8080

USER 1001

CMD ["mvn","jetty:run"]
