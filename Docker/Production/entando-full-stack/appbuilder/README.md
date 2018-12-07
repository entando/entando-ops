# The Entando AppBuilder Image

This image provides the Entando AppBuilder ReactJS application, hosted from the web server packaged with NodeJS. This image
does not include any of the backend functionality it requires, and therefore needs to be configured to point to an instance
of the Entando Engine.  

## Environment variables

__USE_MOCKS__ (boolean, optional, default: false)
An optional boolean variable used to determine whether the API calls will be against a real Entando Core or if they are just being mocked.
Used internally by the Entando development team to develop and test the AppBuilder without needing access to an instance of the Entando Engine.
For most of the Entando customers the default value of 'false' would be appropriate

__DOMAIN__ (string, required, no default)
A string representing the domain name of the Entando Engine instance. The protocol is optional and it is possible to specify a subdirectory of the domain. 
Trailing slashes are not valid. Be sure to include the web context of the Entando Engine as required.
All the following would be valid values:

* http://my.entando.com
* https://my.entando.com
* //my.entando.com
* //my.entando.com/entando-sample

__CLIENT_SECRET__ (string, required, no default value)
This is the secret that is associated with the 'appbuilder' Client ID configured in Entando's Oauth infrastruture. For the default database
configuration, the value 'appbuilder_secret' would work, but it is highly recommended to change its value. It is important to note that
this secret is not a password to log in with, but an extra level of validation to validate that the AppBuilder has the permission to 
allow users to log in with their own usernames and passwords.   

## How to run

`docker run -it --rm -d -p 8080:5000 -e DOMAIN=http://your-entando-domain-app-url entando/appbuilder -e CLIENT_SECRET='appbuilder_secret`

## Exposed ports

`5000`

## Volumes

None. All persistent state for Entando is the responsibility of the Entando Engine this instance of AppBuilder connects to