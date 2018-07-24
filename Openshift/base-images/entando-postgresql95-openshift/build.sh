export VERSION=${1:-5.0.1}
echo $VERSION
#docker build --build-arg ENTANDO_VERSION=$VERSION -t entando/entando-fabric8postgresql95-openshift:$VERSION .
docker build -t entando/entando-postgresql95-openshift:$VERSION -t 172.30.1.1:5000/entando/entando-postgresql95-openshift:$VERSION .
docker push 172.30.1.1:5000/entando/entando-postgresql95-openshift:$VERSION