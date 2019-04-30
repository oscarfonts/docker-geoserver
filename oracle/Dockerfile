FROM oscarfonts/geoserver:2.15.1
MAINTAINER Oscar Fonts <oscar.fonts@geomati.co>

ENV GEOSERVER_VERSION 2.15.1

WORKDIR /usr/local/tomcat/webapps/geoserver/WEB-INF/lib

# Oracle plugin
RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-oracle-plugin.zip \
	&& unzip -o geoserver-${GEOSERVER_VERSION}-oracle-plugin.zip \
	&& rm geoserver-${GEOSERVER_VERSION}-oracle-plugin.zip *.txt

# Add the non-free jar from Oracle
COPY ojdbc7.jar ojdbc7.jar

ENV CATALINA_OPTS "$CATALINA_OPTS -Doracle.jdbc.timezoneAsRegion=false"
