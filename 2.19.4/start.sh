#!/bin/sh

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
