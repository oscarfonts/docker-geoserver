FROM oscarfonts/geoserver:2.26.0

LABEL maintainer="Oscar Fonts <oscar.fonts@geomati.co>"

ENV GEOSERVER_VERSION 2.26.0
ENV GEOSERVER_INSTALL_DIR /usr/local/geoserver

WORKDIR ${GEOSERVER_INSTALL_DIR}/WEB-INF/lib

# H2 Extension
RUN wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-h2-plugin.zip \
	&& unzip -o geoserver-${GEOSERVER_VERSION}-h2-plugin.zip \
	&& rm geoserver-${GEOSERVER_VERSION}-h2-plugin.zip *.txt

# Vector Tiles Extension
RUN wget https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip \
	&& unzip -o geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip \
	&& rm geoserver-${GEOSERVER_VERSION}-vectortiles-plugin.zip
