export VERSION=${1:-5.0.1-SNAPSHOT}
echo $VERSION
docker build --build-arg ENTANDO_VERSION_TO_BUILD=$VERSION -t entando/entando-wildfly12-quickstart-docker:$VERSION \
    -t 172.30.1.1:5000/entando/entando-wildfly12-quickstart-docker:$VERSION \
     -t entando/entando-wildfly12-quickstart-docker:latest  .

