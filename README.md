docker-geoserver
================

Dockerized GeoServer.


## Features

* Built on top of [Docker's official tomcat image](https://hub.docker.com/_/tomcat/).
* Taken care of [JVM Options](http://docs.geoserver.org/latest/en/user/production/container.html), to avoid PermGen space issues &c.
* Separate GEOSERVER_DATA_DIR location (on /var/local/geoserver).
* Automatic installation of [Native JAI and Image IO](http://docs.geoserver.org/latest/en/user/production/java.html#install-native-jai-and-jai-image-i-o-extensions) for better performance.
* Automatic installation of [Microsoft Core Fonts](http://www.microsoft.com/typography/fonts/web.aspx) for better labelling compatibility.
* AWS configuration files and scripts in order to deploy easily using [Elastic Beanstalk](https://aws.amazon.com/documentation/elastic-beanstalk/). See [github repo](https://github.com/oscarfonts/docker-geoserver/blob/master/aws/README.md). Thanks to @victorzinho


## Trusted builds

[Automated builds](https://hub.docker.com/r/oscarfonts/geoserver/) on [docker registry](https://registry.hub.docker.com/):

* Latest (2.9.x) ([Dockerfile](https://github.com/oscarfonts/docker-geoserver/blob/master/Dockerfile))
* 2.8.x ([Dockerfile](https://github.com/oscarfonts/docker-geoserver/blob/2.8.x/Dockerfile))
* 2.7.x ([Dockerfile](https://github.com/oscarfonts/docker-geoserver/blob/2.7.x/Dockerfile))


## Running

Get the image:

```
docker pull oscarfonts/geoserver
```

Run as a service, exposing port 8080 and using a hosted GEOSERVER_DATA_DIR:

```
docker run -d -p 8080:8080 -v /path/to/local/data_dir:/var/local/geoserver localhost --name=MyGeoServerInstance oscarfonts/geoserver
```

Get an [empty minimal GEOSERVER_DATA_DIR structure](https://github.com/oscarfonts/docker-geoserver/tree/master/data_dir) to start with.

It is also possible to configure the context path by providing a Catalina configuration directory:

```
docker run -d -p 8080:8080 -v /path/to/local/data_dir:/var/local/geoserver -v /path/to/local/conf_dir:/usr/local/tomcat/conf/Catalina/localhost --name=MyGeoServerInstance oscarfonts/geoserver
```

See some [examples](https://github.com/oscarfonts/docker-geoserver/tree/master/conf).

See the tomcat logs while running:

```
docker logs -f MyGeoServerInstance
```


## Other versions

Other non pre-built versions that can be found on GitHub repo:

* [GeoServer + H2 extension](https://github.com/oscarfonts/docker-geoserver/tree/2.8.x-h2)
* [GeoServer + Oracle extension](https://github.com/oscarfonts/docker-geoserver/tree/2.8.x-oracle). Uses [wnameless/oracle-xe-11g](https://hub.docker.com/r/wnameless/oracle-xe-11g/), needs ojdbc7.jar and [setting up a database](https://github.com/oscarfonts/docker-geoserver/blob/2.8.x-oracle/setup.sql). See [the run commands](https://github.com/oscarfonts/docker-geoserver/blob/2.8.x-oracle/run.sh).
