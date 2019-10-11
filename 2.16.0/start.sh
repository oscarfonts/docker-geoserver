#!/bin/bash

if [ -n "${CUSTOM_UID}" ];then
  echo "Using custom UID ${CUSTOM_UID}."
  usermod -u ${CUSTOM_UID} tomcat
  find / -user 1099 -exec chown -h tomcat {} \; 
fi

if [ -n "${CUSTOM_GID}" ];then
  echo "Using custom GID ${CUSTOM_GID}."
  groupmod -g ${CUSTOM_GID} tomcat
  find / -group 1099 -exec chgrp -h tomcat {} \;
fi

#We need this line to ensure that data has the correct rights
chown -R tomcat:tomcat ${GEOSERVER_DATA_DIR} 
chown -R tomcat:tomcat ${GEOSERVER_EXT_DIR}

for ext in `ls -d "${GEOSERVER_EXT_DIR}"/*/`; do
  su tomcat -c "cp "${ext}"*.jar /usr/local/geoserver/WEB-INF/lib"
done

su tomcat -c "/usr/local/tomcat/bin/catalina.sh run"
