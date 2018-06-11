export VERSION=${1:-5.0.0}
echo $VERSION
#docker build --build-arg ENTANDO_VERSION=$VERSION -t entando/entando-fabric8s2i-eap-71:$VERSION .
docker build -t entando/entando-fabric8s2i-eap-71:$VERSION -t 172.30.1.1:5000/entando/entando-fabric8s2i-eap-71:$VERSION .
