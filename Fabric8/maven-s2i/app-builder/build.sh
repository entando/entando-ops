export VERSION=${1:-5.0.1}
echo $VERSION
docker build  -t entando/app-builder-openshift:$VERSION .