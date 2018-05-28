export VERSION=${1:-5.0.0-SNAPSHOT}
echo $VERSION
docker build -t ampie/entando-microengine:$VERSION .
