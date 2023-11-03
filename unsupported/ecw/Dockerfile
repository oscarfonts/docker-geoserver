FROM oscarfonts/geoserver:2.18.7

LABEL maintainer="Geomatico <info@geomatico.es>"

# Install GDAL
COPY --from=geomatico/gdal:2.4.4_ECW_JAVA /usr/local /usr/local

# Extensions GeoServer - GDAL + Dependencies + other stuff
RUN cd /usr/local/src \
	&& wget https://netcologne.dl.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/extensions/geoserver-${GEOSERVER_VERSION}-gdal-plugin.zip \
	&& unzip -o geoserver-${GEOSERVER_VERSION}-gdal-plugin.zip \
	&& mv *.jar ${GEOSERVER_INSTALL_DIR}/WEB-INF/lib \
	&& rm -f geoserver-${GEOSERVER_VERSION}-gdal-plugin.zip LICENSE.txt README.TXT

	# GDAL dependencies
RUN apt-get update \
	&& apt-get install -y \
	    libgeos-dev \
	    libnetcdf-dev \
	    libhdf4-0-alt \
	    libpq-dev \
	    libspatialite-dev \
	&& apt clean -y\
    && apt autoclean -y \
    && apt autoremove -y \
    # Install Gdal java bindings
    && ln -s /usr/local/java/gdal.jar ${GEOSERVER_INSTALL_DIR}/WEB-INF/lib

ENV GDAL_DATA /usr/local/share/gdal

# Tomcat environment
ENV CATALINA_OPTS "$CATALINA_OPTS -Djava.library.path=/usr/local/lib"
