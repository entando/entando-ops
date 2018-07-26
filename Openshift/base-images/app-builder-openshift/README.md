# Entando AppBuilder image
This image was developed for use inside Openshift. It extends the official Openshift NodeJS image for compatibility
with Openshift's security and standard templates. It can however also be used in 'vanilla' Docker environments. It serves
a pre-built version of the Entando AppBuilder Javascript app at port 5000. The NodeJS 'serve' package is used to serve the Javascript
files and other supporting static content over HTTP

It is mandatory to pass as argument the `DOMAIN` env variable to make requests to an entando REST API Server instance. Please
make sure that the version of your AppBuilder image is in sync with the Entando server you connect it to. At this point in
time backward compatibility is not supported. Also note that the `DOMAIN` variable must resolve to your Entando server from
the user's browser. Specifying a cluster-local address from Openshift for the `DOMAIN` variable would therefore not work.

##Environment variables

__DOMAIN__ (string, default: `//localhost:8080/entando-sample`)
a string representing the domain name of the Entando Core instance. The protocol is optional and it is possible to 
specify a subdirectory of the domain. Trailing slashes are not valid.
All the following would be valid values:

* http://my.entando.com
* https://my.entando.com
* //my.entando.com
* //my.entando.com/entando-sample

##How to run in Openshift after installation of the Entando Service 
`ENTANDO_SERVICE_URL=$(oc describe route <<name of your entando service>>|grep -oP "(?<=Requested\sHost:\t\t)[^ ]+")`

`oc new-app --name my-app-builder --docker-image entando/app-builder-openshift:5.0.1 -e DOMAIN=$ENTANDO_SERVICE_URL`

`oc expose svc my-app-builder`

##How to run in Docker

`docker run -it --rm -d -p 5000:5000 -e DOMAIN=http://your-entando-domain-app-url entando/app-builder-openshift:5.0.1`

##Exposed ports

`5000`

##Known issues

If you have OIDC or OAUTH2 enabled on your Entando server, the AppBuilder won't work.
