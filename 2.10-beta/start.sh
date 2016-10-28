#!/bin/bash
for ext in `ls -d /var/local/geoserver-exts/*/`; do
  cp "${ext}"*.jar /usr/local/geoserver/WEB-INF/lib
done

catalina.sh run

