export VERSION=${1:-5.0.1}
echo $VERSION
docker build -t entando/entando-eap71-quickstart-openshift:$VERSION -t 172.30.1.1:5000/entando/entando-eap71-quickstart-openshift:$VERSION .
if [ $? -eq 0 ]; then
  docker login -u $(oc whoami) -p $(oc whoami --show-token) 172.30.1.1:5000
  docker push 172.30.1.1:5000/entando/entando-eap71-quickstart-openshift:$VERSION
else
  echo "Build failed"
fi
