export VERSION=${1:-5.0.1-SNAPSHOT}
echo $VERSION
docker build --build-arg ENTANDO_VERSION_TO_BUILD=$VERSION -t entando/engine-api:$VERSION .
