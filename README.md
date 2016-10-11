docker-geoserver
================

Dockerized GeoServer.


## Features

* Built on top of [Docker's official tomcat image](https://hub.docker.com/_/tomcat/).
* Taken care of [JVM Options](http://docs.geoserver.org/latest/en/user/production/container.html), to avoid PermGen space issues &c.
* Separate GEOSERVER_DATA_DIR location (on /var/local/geoserver).
* [CORS ready](http://enable-cors.org/server_tomcat.html).
* Automatic installation of [Native JAI and Image IO](http://docs.geoserver.org/latest/en/user/production/java.html#install-native-jai-and-jai-image-i-o-extensions) for better performance.
* ~Automatic installation of [Microsoft Core Fonts](http://www.microsoft.com/typography/fonts/web.aspx) for better labelling compatibility.~
* AWS configuration files and scripts in order to deploy easily using [Elastic Beanstalk](https://aws.amazon.com/documentation/elastic-beanstalk/). See [github repo](https://github.com/oscarfonts/docker-geoserver/blob/master/aws/README.md). Thanks to @victorzinho


## Trusted builds

Active versions with [automated builds](https://hub.docker.com/r/oscarfonts/geoserver/) available on [docker registry](https://hub.docker.com/r/oscarfonts/geoserver/):

* [`latest`, `stable`, `2.9.x`, `2.9.1` (*2.9.1/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.9.1/Dockerfile)
* [`maintenance`, `2.8.x`, `2.8.5` (*2.8.5/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.8.5/Dockerfile)
* [`development`, `2.10.x`, `2.10-beta` (*2.10-beta/Dockerfile*)](https://github.com/oscarfonts/docker-geoserver/blob/master/2.10-beta/Dockerfile)

Other experimental (no automated build):

* [`oracle`](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/Dockerfile). Uses [wnameless/oracle-xe-11g](https://hub.docker.com/r/wnameless/oracle-xe-11g/), needs ojdbc7.jar and [setting up a database](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/setup.sql). See [the run commands](https://github.com/oscarfonts/docker-geoserver/blob/master/oracle/run.sh).

* [`h2-vector`](https://github.com/oscarfonts/docker-geoserver/blob/master/h2-vector/Dockerfile). Plays nice with [oscarfonts/h2:geodb](https://hub.docker.com/r/oscarfonts/h2/tags/), and includes sample scripts for docker-compose and systemd.


## Running

Get the image:

```
docker pull oscarfonts/geoserver
```

Run as a service, exposing port 8080 and using a hosted GEOSERVER_DATA_DIR:

```
docker run -d -p 8080:8080 -v /path/to/local/data_dir:/var/local/geoserver localhost --name=MyGeoServerInstance oscarfonts/geoserver
```

It is also possible to configure the context path by providing a Catalina configuration directory:

```
docker run -d -p 8080:8080 -v /path/to/local/data_dir:/var/local/geoserver -v /path/to/local/conf_dir:/usr/local/tomcat/conf/Catalina/localhost --name=MyGeoServerInstance oscarfonts/geoserver
```

See some [examples](https://github.com/oscarfonts/docker-geoserver/tree/master/2.9.1/conf).

See the tomcat logs while running:

```
docker logs -f MyGeoServerInstance
```
