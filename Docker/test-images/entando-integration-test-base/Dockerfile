FROM maven:3.6.1-jdk-8
RUN apt-get update && apt-get -y install tar git
RUN cd /tmp && git clone https://github.com/entando/entando-user-mgmt.git &&  cd entando-user-mgmt && \
    ( mvn clean package jacoco:report sonar:sonar -Dsonar.host.url=https://sonar.entandocloud.com -Dsonar.login=admin -Dsonar.password=61b0217508585701668b7ddc || true ) && \
cd /tmp && git clone https://github.com/entando/entando-keycloak-plugin.git &&  cd entando-keycloak-plugin && \
    ( mvn clean package sonar:sonar -Dsonar.host.url=https://sonar.entandocloud.com -Dsonar.login=admin -Dsonar.password=61b0217508585701668b7ddc || true )
COPY ./settings.xml /root/.m2/settings.xml
