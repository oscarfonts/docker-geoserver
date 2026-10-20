# docker-geoserver

Dockerized GeoServer.


> **Note:** Starting with GeoServer 3, this Docker image will no longer be maintained. We recommend switching to the [official GeoServer Docker build](https://docs.geoserver.org/main/en/user/installation/docker/). If you need professional support, feel free to [contact us](https://geomatico.es/en/contact/).


## Features

* Built on top of [Docker's official tomcat image](https://hub.docker.com/_/tomcat/), specifically `tomcat:9-jre17`.
* Running tomcat process as non-root user.
* Separate GEOSERVER_DATA_DIR location (on /var/local/geoserver).
* Configurable extensions.
* Injectable UID and GID for better mounted volume management.
* [CORS ready](http://enable-cors.org/server_tomcat.html).
* Taken care of [JVM Options](http://docs.geoserver.org/latest/en/user/production/container.html).
* Automatic installation of [Microsoft Core Fonts](http://www.microsoft.com/typography/fonts/web.aspx) for better labelling compatibility.
* Custom geoserver deployment path.
* docker health check.

## Trusted builds

Latest versions with [automated builds](https://hub.docker.com/r/oscarfonts/geoserver/) available on [docker registry](https://registry.hub.docker.com/):

* [`latest`, `2.28.6` (*2.28.6/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.28.6/Dockerfile)
* [`2.27.7` (*2.27.7/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.27.7/Dockerfile)
* [`2.26.4` (*2.26.4/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.26.4/Dockerfile)
* [`2.25.7` (*2.25.7/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.25.7/Dockerfile)
* [`2.24.5` (*2.24.5/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.24.5/Dockerfile)
* [`2.23.6` (*2.23.6/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.23.6/Dockerfile)


## Unsupported builds

Other experimental dockerfiles (not automated build):

* [`oracle`](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/oracle/Dockerfile). Uses [wnameless/oracle-xe-11g](https://hub.docker.com/r/wnameless/oracle-xe-11g/), needs ojdbc7.jar and [setting up a database](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/oracle/setup.sql). See [the run commands](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/oracle/run.sh).
* [`h2-vector`](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/h2-vector/Dockerfile). Plays nicely with [oscarfonts/h2:geodb](https://hub.docker.com/r/oscarfonts/h2/tags/), and includes sample scripts for docker-compose and systemd.
* DEPRECATED [`ecw`](https://github.com/oscarfonts/docker-geoserver/blob/master/unsupported/ecw/Dockerfile). Added GDAL plugin with ECW support to legacy GeoServer versions, not distributed anymore. Needs an update to recent versions.

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