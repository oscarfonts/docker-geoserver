FROM tomcat:8-jre7
MAINTAINER Oscar Fonts <oscar.fonts@geomati.co>

ENV GEOSERVER_VERSION 2.7.2

# Based on: https://github.com/oscarfonts/geoserver-deploy-doc

# Use host's APT cache (apt-cacher-ng)
RUN echo "Acquire::http { Proxy \"http://`/sbin/ip route|awk '/default/ { print $3 }'`:3142\"; };" > /etc/apt/apt.conf.d/71-apt-cacher-ng

# APT multiverse
RUN echo "deb http://httpredir.debian.org/debian jessie contrib" >> /etc/apt/sources.list

# Microsoft fonts
RUN set -x \
	&& apt-get update \
	&& apt-get install -yq ttf-mscorefonts-installer \
	&& rm -rf /var/lib/apt/lists/*

# Native JAI & ImageIO
RUN cd /usr/lib/jvm/java-7-openjdk-amd64 && \
	wget http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64-jdk.bin && \
	tail -n +139 jai-1_1_3-lib-linux-amd64-jdk.bin > INSTALL-jai && \
	chmod u+x INSTALL-jai && \
	./INSTALL-jai && \
	wget http://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64-jdk.bin && \
	tail -n +215 jai_imageio-1_1-lib-linux-amd64-jdk.bin > INSTALL-jai_imageio && \
	chmod u+x INSTALL-jai_imageio && \
	./INSTALL-jai_imageio

# GeoServer
RUN cd /usr/local/tomcat/webapps/ && \
	wget http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip && \
	unzip geoserver-${GEOSERVER_VERSION}-war.zip && \
	rm -rf target/ *.txt geoserver-${GEOSERVER_VERSION}-war.zip

# Tomcat 7 environment
ENV CATALINA_OPTS "-server -Djava.awt.headless=true -Xms768m -Xmx1560m -XX:PermSize=384m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:NewSize=48m"

# GEOSERVER_DATA_DIR will be in /usr/local/tomcat/webapps/geoserver/data
