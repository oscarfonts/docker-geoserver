FROM oscarfonts/geoserver:2.15.1

MAINTAINER Oscar Fonts <oscar.fonts@geomati.co>

ENV GEOSERVER_VERSION 2.15.1
ENV GEOSERVER_INSTALL_DIR /usr/local/geoserver

WORKDIR ${GEOSERVER_INSTALL_DIR}/WEB-INF/lib

# H2 plugin
RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-h2-plugin.zip \
	&& unzip -o geoserver-${GEOSERVER_VERSION}-h2-plugin.zip \
	&& rm geoserver-${GEOSERVER_VERSION}-h2-plugin.zip *.txt

# Vector Tiles Community Module
RUN wget https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip \
	&& unzip -o geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip \
	&& rm geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip
