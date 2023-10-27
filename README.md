# docker-geoserver

Dockerized GeoServer.

## Features

* Built on top of [Docker's official tomcat image](https://hub.docker.com/_/tomcat/). Using `tomcat:9-jre17` as base for versions 2.23.1 and above, and `tomcat:9-jdk11` for versions below 2.23.1.
* Running tomcat process as non-root user.
* Separate GEOSERVER_DATA_DIR location (on /var/local/geoserver).
* Configurable extensions.
* Injectable UID and GID for better mounted volume management.
* [CORS ready](http://enable-cors.org/server_tomcat.html).
* Taken care of [JVM Options](http://docs.geoserver.org/latest/en/user/production/container.html).
* Automatic installation of [Microsoft Core Fonts](http://www.microsoft.com/typography/fonts/web.aspx) for better labelling compatibility.
* Custom geoserver deployment path
* docker health check

## Trusted builds

Latest versions with [automated builds](https://hub.docker.com/r/oscarfonts/geoserver/) available on [docker registry](https://registry.hub.docker.com/):

* [`latest`, `2.24.0` (*2.24.0/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.24.0/Dockerfile)
* [`2.23.2` (*2.23.2/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.23.2/Dockerfile)

Security patches for older versions:

* [`2.22.5` (*2.22.5/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.22.5/Dockerfile) Latest with JDK 11
* [`2.21.5` (*2.21.5/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.21.5/Dockerfile)
* [`2.20.7` (*2.20.7/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.20.7/Dockerfile)
* [`2.19.7` (*2.19.7/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.19.7/Dockerfile)
* [`2.18.7` (*2.18.7/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.18.7/Dockerfile)

## Unsupported builds

Other experimental dockerfiles (not automated build):

* [`oracle`](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/Dockerfile). Uses [wnameless/oracle-xe-11g](https://hub.docker.com/r/wnameless/oracle-xe-11g/), needs ojdbc7.jar and [setting up a database](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/setup.sql). See [the run commands](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/run.sh).
* [`h2-vector`](https://github.com/oscarfonts/docker-geoserver/blob/master/h2-vector/Dockerfile). Plays nicely with [oscarfonts/h2:geodb](https://hub.docker.com/r/oscarfonts/h2/tags/), and includes sample scripts for docker-compose and systemd.
* [`ecw`](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/ecw/Dockerfile). Adding GDAL plugin with ECW support.

Think of them more as recipes or documentation rather than production-ready builds :)

## Running

Get the image:

```bash
docker pull oscarfonts/geoserver
```

### Custom GEOSERVER_DATA_DIR

Run as a service, exposing port 8080 and using a hosted GEOSERVER_DATA_DIR:

```bash
docker run -d -p 8080:8080 -v ${PWD}/data_dir:/var/local/geoserver oscarfonts/geoserver
```

### Custom base path

* On build time, set the GEOSERVER_PATH arg to change the geoserver base path. It defaults to `/geoserver`.
* On run time, set the GEOSERVER_HEALTH_CHECK_URL to test for a valid (internal) URL that should respond HTTP 200 OK. It defaults to `http://localhost:8080/geoserver/ows`.


### Custom UID and GID

The tomcat user uid and gid can be customized with `CUSTOM_UID` and `CUSTOM_GID` environment variables, so that the mounted data_dir and exts_dir are accessible by both geoserver and a given host user. Usage example:

```bash
docker run -d -p 8080:8080 -e CUSTOM_UID=$(id -u) -e CUSTOM_GID=$(id -g) oscarfonts/geoserver
```

### Custom extensions

To add extensions to your GeoServer installation, provide a directory with the unzipped extensions separated by directories (one directory per extension):

```bash
docker run -d -p 8080:8080 -v ${PWD}/exts_dir:/var/local/geoserver-exts/ oscarfonts/geoserver
```

You can use the `build_exts_dir.sh` script together with a [extensions](https://github.com/oscarfonts/docker-geoserver/tree/master/extensions) configuration file to create your own extensions directory easily.

> **Warning**: The `.jar` files contained in the extensions directory will be copied to the `WEB-INF/lib` directory of the GeoServer installation. Make sure to include only `.jar` files from trusted sources to avoid security risks.

### Custom configuration directory

It is also possible to configure the context path by providing a Catalina configuration directory:

```bash
docker run -d -p 8080:8080 -v ${PWD}/config_dir:/usr/local/tomcat/conf/Catalina/localhost oscarfonts/geoserver
```

See some [examples](https://github.com/oscarfonts/docker-geoserver/tree/master/2.24.0/conf).

### CORS

CORS is configured automatically in the servlet web.xml filters. If you have another
component in front that already takes care of it you can disable it with the environment variable
`-e "GEOSERVER_CORS_ENABLED=false"`.

It is also possible to fine tune it for specific origins, methods, etc. with the following variables:
- `GEOSERVER_CORS_ALLOWED_ORIGINS` (cors.allowed.origins)
- `GEOSERVER_CORS_ALLOWED_METHODS` (cors.allowed.methods)
- `GEOSERVER_CORS_ALLOWED_HEADERS` (cors.allowed.headers)
- `GEOSERVER_CORS_URL_PATTERN` (filter-mapping url-pattern)

See [Tomcat documentation](https://tomcat.apache.org/tomcat-7.0-doc/config/filter.html#CORS_Filter)
for more info.