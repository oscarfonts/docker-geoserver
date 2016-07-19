docker run -v $PWD/data_dir:/var/local/geoserver -v $PWD/conf/geoserver.xml:/usr/local/tomcat/conf/Catalina/localhost/geoserver.xml -d -p 8080:8080 --name=geoserver geoserver
docker logs -f geoserver 2>&1
#xdg-open http://localhost:8080/geoserver/web/
