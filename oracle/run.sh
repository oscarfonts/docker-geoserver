docker run -d -p 1521:1521 -p 2222:22 --name=oracle wnameless/oracle-xe-11g
docker run -v $PWD/data_dir:/var/local/geoserver -d -p 8080:8080 --link oracle --name=geoserver-oracle geoserver-oracle
docker logs -f geoserver-oracle 2>&1
#xdg-open http://localhost:8080/geoserver/web/
