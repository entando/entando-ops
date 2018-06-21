#Entando Mapp Engine Admin App image for Openshift
This image is intended for use specifically inside Openshift. It extends the official Openshift NodeJS image for compatibility
with Openshift's security and standard templates. It provides an alternative to installing Mapp Engine Admin App directly from GitHub with
the NodeJS builder image to simplify the process of of installing this app from the command line, specifically for 
use with the Entando archetypes.  

It is mandatory to pass as argument the `DOMAIN` env variable  to make requests to an entando REST API Server instance.

##Environment variables

__USE_MOCKS__ (boolean, default: false)
a boolean used to determine whether the API calls will be against a real Entando Core or if they are just being mocked

__DOMAIN__ (string, default: `//localhost:8080/entando-sample`)
a string representing the domain name of the Entando Core instance. The protocol is optional and it is possible to specify a subdirectory of the domain. Trailing slashes are not valid and it only vaildates up to 3rd level domains.
All the following would be valid values:

* http://my.entando.com
* https://my.entando.com
* //my.entando.com
* //my.entando.com/entando-sample

##How to run in Openshift after installation of the Entando Service 
`ENTANDO_SERVICE_URL=$(oc describe route <<name of your entando service>>|grep -oP "(?<=Requested\sHost:\t\t)[^ ]+")`

`oc new-app --name my-mapp-engine-admin-app --docker-image entando/mapp-engine-admin-app-openshift:5.0.0 -e USE_MOCKS=false -e DOMAIN=$ENTANDO_SERVICE_URL`

`oc expose svc my-mapp-engine-admin-app`

##How to run in Docker

`docker run -it --rm -d -p 80:3000 -e DOMAIN=http://your-entando-domain-app-url entando/app-builder-openshift:5.0.0`

##Exposed ports

`3000`

##Known Limitations
Unfortunately, currently the DOMAIN variable has to be passed as a build parameter to the ReactJS app build. As a result
we need to rebuild the app on container startup which slows startup down significantly. Please be patient, 
we are hoping to address this soon 
