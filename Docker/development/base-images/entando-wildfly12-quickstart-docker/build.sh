export VERSION=${1:-5.0.1}
echo $VERSION
docker build -t entando/entando-wildfly12-quickstart-docker:$VERSION \
    -t 172.30.1.1:5000/entando/entando-wildfly12-quickstart-docker:$VERSION \
     -t entando/entando-wildfly12-quickstart-docker:latest  .

