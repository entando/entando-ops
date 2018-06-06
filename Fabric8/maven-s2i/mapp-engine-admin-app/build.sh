export VERSION=${1:-5.0.1}
echo $VERSION
docker build -t entando/mapp-engine-admin-app-openshift:$VERSION .
