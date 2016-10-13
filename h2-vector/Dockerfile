FROM oscarfonts/geoserver:2.9.2

MAINTAINER Oscar Fonts <oscar.fonts@geomati.co>

ENV GEOSERVER_VERSION 2.9.2
ENV GEOSERVER_INSTALL_DIR /usr/local/geoserver

WORKDIR ${GEOSERVER_INSTALL_DIR}/WEB-INF/lib

# H2 plugin
RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-h2-plugin.zip \
	&& unzip -o geoserver-${GEOSERVER_VERSION}-h2-plugin.zip \
	&& rm geoserver-${GEOSERVER_VERSION}-h2-plugin.zip *.txt

# Vector Tiles Community Module
RUN wget http://ares.boundlessgeo.com/geoserver/2.9.x/community-latest/geoserver-2.9-SNAPSHOT-vectortiles-plugin.zip \
	&& unzip -o geoserver-2.9-SNAPSHOT-vectortiles-plugin.zip \
	&& rm geoserver-2.9-SNAPSHOT-vectortiles-plugin.zip

