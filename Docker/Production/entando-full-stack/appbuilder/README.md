# entando appbuilder image

it's mandatory to pass as argument the `DOMAIN` env variable  to make requests to an entando REST API Server instance.

## Environment variables

__USE_MOCKS__ (boolean, default: false)
a boolean used to determine whether the API calls will be against a real Entando Core or if they are just being mocked

__DOMAIN__ (string, default: `//localhost:8080/entando-sample`)
a string representing the domain name of the Entando Core instance. The protocol is optional and it is possible to specify a subdirectory of the domain. Trailing slashes are not valid and it only vaildates up to 3rd level domains.
All the following would be valid values:

* http://my.entando.com
* https://my.entando.com
* //my.entando.com
* //my.entando.com/entando-sample

## How to run

`docker run -it --rm -d -p 80:3000 -e DOMAIN=http://your-entando-domain-app-url entando/appbuilder`

## Exposed ports

`5000`

## How to run in Openshift after installation of the Entando Service

`ENTANDO_SERVICE_URL=$(oc describe route <<name of your entando service>> \`

`    |grep -oP "(?<=Requested\sHost:\t\t)[^ ]+")`

`oc new-app --name my-app-builder --docker-image entando/app-builder-openshift:5.0.1-SNAPSHOT \`

`    -e USE_MOCKS=false  -e DOMAIN=$ENTANDO_SERVICE_URL`

`oc expose svc my-app-builder`


