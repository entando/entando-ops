FROM ubuntu:latest
RUN apt-get update && apt-get -y install curl
ENV SPRING_BOOT_BASE_URL="http://myservice:8081/"

ADD test-it.sh /test-it.sh 
ENTRYPOINT /test-it.sh
