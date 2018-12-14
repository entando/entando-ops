# Entando Maven Jenkins Slave for Openshift 3.9

This image is designed to work with a Jenkins server running the Jenkins Kubernetes Plugin. This specific image
targets version of the Jenkins server running in version 3.9 of Openshift. Its Openshift client will not work
with incompatible versions of the Openshift server.

This Image has the necessary Maven infrastructure to build any Maven project. In addition, it also has a 
Docker client installation. Keep in mind though that you need to connect to a Docker server, which could very
well be the Docker server that instantiated the image to start with.

This Image also comes with the Entando dependencies pre-cached in the $HOME/.m2/repository directory.

# Running this image.

This image is not intended for direct use in Docker. It can only be run by the Jenkins Kubernetes plugin.    