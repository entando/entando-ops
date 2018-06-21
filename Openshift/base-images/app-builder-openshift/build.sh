export VERSION=${1:-5.0.1}
echo $VERSION
docker build  -t entando/app-builder-openshift:$VERSION -t 172.30.1.1:5000/entando/app-builder-openshift:$VERSION .
docker push 172.30.1.1:5000/entando/app-builder-openshift:$VERSION
