export VERSION=${1:-5.0.0}
echo $VERSION
docker build -t entando/mapp-engine-admin-app-openshift:$VERSION .
