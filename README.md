# docker-geoserver

Dockerized GeoServer.


## Important deprecation notice

Old GeoServer versions affected by a severe security vulnerability have been removed from this repo to prevent damage.
Please update to most recent version where possible, or at least use a secure version:

* If you are in a version lower than 2.23.x and you can't update, you will need to patch and build your own images, as we won't provide support or patched builds here. Please refer to [CVE-2024-36401 the official GeoServer post](https://geoserver.org/vulnerability/2024/09/12/cve-2024-36401.html) for details.
* If you are in the 2.23.x series, use at least 2.23.6.
* If you are in the 2.24.x series, use at least 2.24.5.
* If you are in the 2.25.x series, use at least version 2.25.2.
* If you are in 2.26.0 or higher, you are safe from this one.

If you are concerned about security and want to keep GeoServer in good shape, [please consider supporting the key shift towards 3.0 release](https://geoserver.org/behind%20the%20scenes/2024/09/10/gs3.html).


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

* [`latest`, `2.27.0` (*2.27.0/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.27.0/Dockerfile)
* [`2.26.2` (*2.26.2/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.26.2/Dockerfile)
* [`2.25.6` (*2.25.6/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.25.6/Dockerfile)
* [`2.24.5` (*2.24.5/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.24.5/Dockerfile)
* [`2.23.6` (*2.23.6/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.23.6/Dockerfile)


## Unsupported builds

Other experimental dockerfiles (not automated build):

* [`oracle`](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/Dockerfile). Uses [wnameless/oracle-xe-11g](https://hub.docker.com/r/wnameless/oracle-xe-11g/), needs ojdbc7.jar and [setting up a database](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/setup.sql). See [the run commands](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/run.sh).
* [`h2-vector`](https://github.com/oscarfonts/docker-geoserver/blob/master/h2-vector/Dockerfile). Plays nicely with [oscarfonts/h2:geodb](https://hub.docker.com/r/oscarfonts/h2/tags/), and includes sample scripts for docker-compose and systemd.
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