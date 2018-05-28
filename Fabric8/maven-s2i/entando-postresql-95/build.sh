export VERSION=${1:-5.0.0-SNAPSHOT}
echo $VERSION
docker build --build-arg ENTANDO_VERSION=$VERSION -t ampie/entando-s2i-postgresql-95:$VERSION .
