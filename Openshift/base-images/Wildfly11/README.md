# Entando Wildfly 11 s2i

## Description

This is a s2i project based on WildFly 11 release and ImageMagick package dependency for Entando.
The project has been adapted to run on OpenShift platform as a cloud-native application ready for horizontal scaling scenarios.

## Environment Variables

To be able to let OpenShift connect to the entando Data layer you have to create at least those environment variables on your OpenShift project:

- `DB_DRIVER` -> Specify the DB to use (mysql|postgresql)
- `DB_USERNAME`
- `DB_PASSWORD`
- `DB_ENTANDO_PORT_DB_JNDI_NAME` (the entire string defined in jbossBaseSystemConfig.xml configuration file)
- `DB_ENTANDO_SERV_DB_JNDI_NAME` (the entire string defined in jbossBaseSystemConfig.xml configuration file)
- `DB_ENTANDO_PORT_DB_CONNECTION_STRING` (host:port/dbName)
- `DB_ENTANDO_SERV_DB_CONNECTION_STRING` (host:port/(dbName)

