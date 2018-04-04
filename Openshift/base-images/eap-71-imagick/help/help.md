% IMAGE_NAME (1) Container Image Pages
% MAINTAINER
% DATE

# NAME
entando-eap71-imagick

# DESCRIPTION
This is an extended EAP 7.1 OpenShift image with the entando dependencies installed.

# USAGE
This image has been created to run on OpenShift platform:

To pull the container and set up the host system for use by the XYZ container, run:

    # oc import-image XYZimage


# ENVIRONMENT VARIABLES
Explain all the environment variables available to run the image in different ways without the need of rebuilding the image. Change variables on the docker command line with -e option. For example:

MYSQL_PASSWORD=mypass
                The password set for the current MySQL user.

# LABELS
Describe LABEL settings (from the Dockerfile that created the image) that contains pertinent information.
For containers run by atomic, that could include INSTALL, RUN, UNINSTALL, and UPDATE LABELS.


# SECURITY IMPLICATIONS

-p 8080:8080
    Opens container port 8080 and maps it to the same port on the Host.
-p 8888:8888
    this port is used by jgroups for node cluster discovering protocol

# HISTORY
release 1 Added support for image manipulation by entando installing ImageMagick package and all dependencies.

# SEE ALSO
References to documenation or other sources.

https://access.redhat.com/documentation/en/red-hat-xpaas/0/paged/red-hat-xpaas-eap-image
