# docker-geoserver

Dockerized GeoServer.

## Features

* Built on top of [Docker's official tomcat image](https://hub.docker.com/_/tomcat/).
* Running tomcat process as non-root user.
* Separate GEOSERVER_DATA_DIR location (on /var/local/geoserver).
* Configurable extensions.
* Injectable UID and GID for better mounted volume management.
* [CORS ready](http://enable-cors.org/server_tomcat.html).
* Taken care of [JVM Options](http://docs.geoserver.org/latest/en/user/production/container.html).
* Automatic installation of [Microsoft Core Fonts](http://www.microsoft.com/typography/fonts/web.aspx) for better labelling compatibility.
* AWS configuration files and scripts in order to deploy easily using [Elastic Beanstalk](https://aws.amazon.com/documentation/elastic-beanstalk/). See [github repo](https://github.com/oscarfonts/docker-geoserver/blob/master/aws/README.md). Thanks to @victorzinho

## Trusted builds

Latest versions with [automated builds](https://hub.docker.com/r/oscarfonts/geoserver/) available on [docker registry](https://registry.hub.docker.com/):

* [`latest`, `2.18.1` (*2.18.1/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.18.1/Dockerfile)
* [`2.17.3` (*2.17.3/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.17.3/Dockerfile)

Other experimental dockerfiles (not automated build):

* [`oracle`](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/Dockerfile). Uses [wnameless/oracle-xe-11g](https://hub.docker.com/r/wnameless/oracle-xe-11g/), needs ojdbc7.jar and [setting up a database](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/setup.sql). See [the run commands](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/run.sh).

* [`h2-vector`](https://github.com/oscarfonts/docker-geoserver/blob/master/h2-vector/Dockerfile). Plays nicely with [oscarfonts/h2:geodb](https://hub.docker.com/r/oscarfonts/h2/tags/), and includes sample scripts for docker-compose and systemd.

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

See some [examples](https://github.com/oscarfonts/docker-geoserver/tree/master/2.18.1/conf).
