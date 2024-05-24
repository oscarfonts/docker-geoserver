#!/bin/sh

# Enable CORS
if [ "${GEOSERVER_CORS_ENABLED}" != "false" -a -z "$(grep "<filter-name>\s*cross-origin" ${GEOSERVER_INSTALL_DIR}/WEB-INF/web.xml)" ]; then
  sed -i "\:</web-app>:i\
    <filter>\n\
      <filter-name>cross-origin</filter-name>\n\
      <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>\n\
      <init-param>\n\
        <param-name>cors.allowed.origins</param-name>\n\
        <param-value>${GEOSERVER_CORS_ALLOWED_ORIGINS:-*}</param-value>\n\
      </init-param>\n\
      <init-param>\n\
        <param-name>cors.allowed.methods</param-name>\n\
        <param-value>${GEOSERVER_CORS_ALLOWED_METHODS:-GET,POST,PUT,DELETE,HEAD,OPTIONS}</param-value>\n\
      </init-param>\n\
      <init-param>\n\
      <param-name>cors.allowed.headers</param-name>\n\
        <param-value>${GEOSERVER_CORS_ALLOWED_HEADERS:-*}</param-value>\n\
      </init-param>\n\
    </filter>\n\
    <filter-mapping>\n\
      <filter-name>cross-origin</filter-name>\n\
      <url-pattern>${GEOSERVER_CORS_URL_PATTERN:-/*}</url-pattern>\n\
    </filter-mapping>" ${GEOSERVER_INSTALL_DIR}/WEB-INF/web.xml
fi

if [ -n "${CUSTOM_UID}" ]; then
  echo "Using custom UID ${CUSTOM_UID}."
  usermod -u ${CUSTOM_UID} tomcat
  find / -xdev -user 1099 -exec chown -h tomcat '{}' +
fi

if [ -n "${CUSTOM_GID}" ]; then
  echo "Using custom GID ${CUSTOM_GID}."
  groupmod -g ${CUSTOM_GID} tomcat
  find / -xdev -group 1099 -exec chgrp -h tomcat '{}' +
fi

# We need this line to ensure that data has the correct rights
if [ "$(stat -c %U:%G ${GEOSERVER_DATA_DIR})" != "tomcat:tomcat" ]; then
  chown -R tomcat:tomcat "${GEOSERVER_DATA_DIR}"
fi

# Install extensions
find "${GEOSERVER_EXT_DIR}" -mindepth 2 -maxdepth 2 -type f -iname '*.jar' \
 -exec install -o tomcat -g tomcat -p '{}' /usr/local/geoserver/WEB-INF/lib \;

# https://unix.stackexchange.com/questions/132663/how-do-i-drop-root-privileges-in-shell-scripts
# http://jdebp.info/FGA/dont-abuse-su-for-dropping-privileges.html
# --inh-caps=-all results in an error on some systems (setpriv: libcap-ng is too old for "all" caps)
# get a list of all capabilities, prefix with '-', make a one line ',' sep list & remove the last ',':
all_caps=$(setpriv --list-caps | sed -e 's/^/-/' | tr '\n' ',' | sed -e 's/,$//')
command="setpriv --reuid=tomcat --regid=tomcat --init-groups --inh-caps=${all_caps}"
command="${command} /usr/local/tomcat/bin/catalina.sh run"

exec ${command}